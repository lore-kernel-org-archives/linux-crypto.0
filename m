From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 09/10] crypto: arm64/sha3-ce - yield NEON after every
 block of input
Date: Mon, 30 Apr 2018 18:18:29 +0200
Message-ID: <20180430161830.14892-10-ard.biesheuvel@linaro.org>
References: <20180430161830.14892-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: will.deacon@arm.com, dave.martin@arm.com,
 linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180430161830.14892-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Avoid excessive scheduling delays under a preemptible kernel by
conditionally yielding the NEON after every block of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha3-ce-core.S | 77 +++++++++++++-------
 1 file changed, 50 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-core.S b/arch/arm64/crypto/sha3-ce-core.S
index 332ad7530690..a7d587fa54f6 100644
--- a/arch/arm64/crypto/sha3-ce-core.S
+++ b/arch/arm64/crypto/sha3-ce-core.S
@@ -41,9 +41,16 @@
 	 */
 	.text
 ENTRY(sha3_ce_transform)
-	/* load state */
-	add	x8, x0, #32
-	ld1	{ v0.1d- v3.1d}, [x0]
+	frame_push	4
+
+	mov	x19, x0
+	mov	x20, x1
+	mov	x21, x2
+	mov	x22, x3
+
+0:	/* load state */
+	add	x8, x19, #32
+	ld1	{ v0.1d- v3.1d}, [x19]
 	ld1	{ v4.1d- v7.1d}, [x8], #32
 	ld1	{ v8.1d-v11.1d}, [x8], #32
 	ld1	{v12.1d-v15.1d}, [x8], #32
@@ -51,13 +58,13 @@ ENTRY(sha3_ce_transform)
 	ld1	{v20.1d-v23.1d}, [x8], #32
 	ld1	{v24.1d}, [x8]
 
-0:	sub	w2, w2, #1
+1:	sub	w21, w21, #1
 	mov	w8, #24
 	adr_l	x9, .Lsha3_rcon
 
 	/* load input */
-	ld1	{v25.8b-v28.8b}, [x1], #32
-	ld1	{v29.8b-v31.8b}, [x1], #24
+	ld1	{v25.8b-v28.8b}, [x20], #32
+	ld1	{v29.8b-v31.8b}, [x20], #24
 	eor	v0.8b, v0.8b, v25.8b
 	eor	v1.8b, v1.8b, v26.8b
 	eor	v2.8b, v2.8b, v27.8b
@@ -66,10 +73,10 @@ ENTRY(sha3_ce_transform)
 	eor	v5.8b, v5.8b, v30.8b
 	eor	v6.8b, v6.8b, v31.8b
 
-	tbnz	x3, #6, 2f		// SHA3-512
+	tbnz	x22, #6, 3f		// SHA3-512
 
-	ld1	{v25.8b-v28.8b}, [x1], #32
-	ld1	{v29.8b-v30.8b}, [x1], #16
+	ld1	{v25.8b-v28.8b}, [x20], #32
+	ld1	{v29.8b-v30.8b}, [x20], #16
 	eor	 v7.8b,  v7.8b, v25.8b
 	eor	 v8.8b,  v8.8b, v26.8b
 	eor	 v9.8b,  v9.8b, v27.8b
@@ -77,34 +84,34 @@ ENTRY(sha3_ce_transform)
 	eor	v11.8b, v11.8b, v29.8b
 	eor	v12.8b, v12.8b, v30.8b
 
-	tbnz	x3, #4, 1f		// SHA3-384 or SHA3-224
+	tbnz	x22, #4, 2f		// SHA3-384 or SHA3-224
 
 	// SHA3-256
-	ld1	{v25.8b-v28.8b}, [x1], #32
+	ld1	{v25.8b-v28.8b}, [x20], #32
 	eor	v13.8b, v13.8b, v25.8b
 	eor	v14.8b, v14.8b, v26.8b
 	eor	v15.8b, v15.8b, v27.8b
 	eor	v16.8b, v16.8b, v28.8b
-	b	3f
+	b	4f
 
-1:	tbz	x3, #2, 3f		// bit 2 cleared? SHA-384
+2:	tbz	x22, #2, 4f		// bit 2 cleared? SHA-384
 
 	// SHA3-224
-	ld1	{v25.8b-v28.8b}, [x1], #32
-	ld1	{v29.8b}, [x1], #8
+	ld1	{v25.8b-v28.8b}, [x20], #32
+	ld1	{v29.8b}, [x20], #8
 	eor	v13.8b, v13.8b, v25.8b
 	eor	v14.8b, v14.8b, v26.8b
 	eor	v15.8b, v15.8b, v27.8b
 	eor	v16.8b, v16.8b, v28.8b
 	eor	v17.8b, v17.8b, v29.8b
-	b	3f
+	b	4f
 
 	// SHA3-512
-2:	ld1	{v25.8b-v26.8b}, [x1], #16
+3:	ld1	{v25.8b-v26.8b}, [x20], #16
 	eor	 v7.8b,  v7.8b, v25.8b
 	eor	 v8.8b,  v8.8b, v26.8b
 
-3:	sub	w8, w8, #1
+4:	sub	w8, w8, #1
 
 	eor3	v29.16b,  v4.16b,  v9.16b, v14.16b
 	eor3	v26.16b,  v1.16b,  v6.16b, v11.16b
@@ -183,17 +190,33 @@ ENTRY(sha3_ce_transform)
 
 	eor	 v0.16b,  v0.16b, v31.16b
 
-	cbnz	w8, 3b
-	cbnz	w2, 0b
+	cbnz	w8, 4b
+	cbz	w21, 5f
+
+	if_will_cond_yield_neon
+	add	x8, x19, #32
+	st1	{ v0.1d- v3.1d}, [x19]
+	st1	{ v4.1d- v7.1d}, [x8], #32
+	st1	{ v8.1d-v11.1d}, [x8], #32
+	st1	{v12.1d-v15.1d}, [x8], #32
+	st1	{v16.1d-v19.1d}, [x8], #32
+	st1	{v20.1d-v23.1d}, [x8], #32
+	st1	{v24.1d}, [x8]
+	do_cond_yield_neon
+	b		0b
+	endif_yield_neon
+
+	b	1b
 
 	/* save state */
-	st1	{ v0.1d- v3.1d}, [x0], #32
-	st1	{ v4.1d- v7.1d}, [x0], #32
-	st1	{ v8.1d-v11.1d}, [x0], #32
-	st1	{v12.1d-v15.1d}, [x0], #32
-	st1	{v16.1d-v19.1d}, [x0], #32
-	st1	{v20.1d-v23.1d}, [x0], #32
-	st1	{v24.1d}, [x0]
+5:	st1	{ v0.1d- v3.1d}, [x19], #32
+	st1	{ v4.1d- v7.1d}, [x19], #32
+	st1	{ v8.1d-v11.1d}, [x19], #32
+	st1	{v12.1d-v15.1d}, [x19], #32
+	st1	{v16.1d-v19.1d}, [x19], #32
+	st1	{v20.1d-v23.1d}, [x19], #32
+	st1	{v24.1d}, [x19]
+	frame_pop
 	ret
 ENDPROC(sha3_ce_transform)
 
-- 
2.17.0
