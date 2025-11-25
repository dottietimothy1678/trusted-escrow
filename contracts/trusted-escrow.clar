(define-data-var buyer principal tx-sender)
(define-data-var seller principal tx-sender)
(define-data-var referee principal tx-sender)
(define-data-var escrow-amount uint u0)
(define-data-var deposited bool false)
(define-data-var released bool false)
(define-data-var refunded bool false)

;; -----------------------------------------
;; SETUP FUNCTIONS
;; -----------------------------------------

;; Set participants: buyer, seller, referee
(define-public (set-parties (buyer-address principal) (seller-address principal) (referee-address principal))
  (begin
    (var-set buyer buyer-address)
    (var-set seller seller-address)
    (var-set referee referee-address)
    (ok true)
  )
)

;; -----------------------------------------
;; ESCROW LOGIC
;; -----------------------------------------

;; Buyer deposits funds into escrow
(define-public (deposit (amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get buyer)) (err u100)) ;; Only buyer can deposit
    (asserts! (not (var-get deposited)) (err u101))           ;; Not already deposited
    ;; Transfer STX from buyer to contract
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (var-set escrow-amount amount)
    (var-set deposited true)
    (ok amount)
  )
)

;; Buyer confirms delivery -> funds released to seller
(define-public (release-funds)
  (begin
    (asserts! (is-eq tx-sender (var-get buyer)) (err u102))
    (asserts! (var-get deposited) (err u103))
    (asserts! (not (var-get released)) (err u104))
    (try! (stx-transfer? (var-get escrow-amount) (as-contract tx-sender) (var-get seller)))
    (var-set released true)
    (ok true)
  )
)

;; Referee resolves dispute and decides who gets the funds
(define-public (resolve-dispute (send-to-seller bool))
  (begin
    (asserts! (is-eq tx-sender (var-get referee)) (err u105))
    (asserts! (var-get deposited) (err u103))
    (asserts! (not (var-get released)) (err u104))
    (asserts! (not (var-get refunded)) (err u106))
    (if send-to-seller
        (try! (stx-transfer? (var-get escrow-amount) (as-contract tx-sender) (var-get seller)))
        (try! (stx-transfer? (var-get escrow-amount) (as-contract tx-sender) (var-get buyer)))
    )
    (var-set released true)
    (ok send-to-seller)
  )
)

;; Buyer requests refund (only allowed before funds released)
(define-public (refund)
  (begin
    (asserts! (is-eq tx-sender (var-get buyer)) (err u100))
    (asserts! (var-get deposited) (err u103))
    (asserts! (not (var-get released)) (err u104))
    (asserts! (not (var-get refunded)) (err u106))
    (try! (stx-transfer? (var-get escrow-amount) (as-contract tx-sender) (var-get buyer)))
    (var-set refunded true)
    (ok true)
  )
)
