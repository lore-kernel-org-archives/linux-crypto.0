From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 08/20] crypto: arm64/aes-blk - add 4 way interleave to CBC-MAC encrypt path
Date: Wed,  6 Dec 2017 19:43:34 +0000
Message-ID: <20171206194346.24393-9-ard.biesheuvel@linaro.org>
References: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-rt-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

CBC MAC is strictly sequential, and so the current AES code simply
processes the input one block at a time. However, we are about to add
yield support, which adds a bit of overhead, and which we prefer to
align with other modes in terms of granularity (i.e., it is better to
have all routines yield every 64 bytes and not have an exception for
CBC MAC which yields every 16 bytes)

So unroll the loop by 4. We still cannot perform the AES algorithm in
parallel, but we can at least merge the loads and stores.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-modes.S | 23 ++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index e86535a1329d..a68412e1e3a4 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -395,8 +395,28 @@ AES_ENDPROC(aes_xts_decrypt)
 AES_ENTRY(aes_mac_update)
 	ld1		{v0.16b}, [x4]			/* get dg */
 	enc_prepare	w2, x1, x7
-	cbnz		w5, .Lmacenc
+	cbz		w5, .Lmacloop4x
 
+	encrypt_block	v0, w2, x1, x7, w8
+
+.Lmacloop4x:
+	subs		w3, w3, #4
+	bmi		.Lmac1x
+	ld1		{v1.16b-v4.16b}, [x0], #64	/* get next pt block */
+	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with dg */
+	encrypt_block	v0, w2, x1, x7, w8
+	eor		v0.16b, v0.16b, v2.16b
+	encrypt_block	v0, w2, x1, x7, w8
+	eor		v0.16b, v0.16b, v3.16b
+	encrypt_block	v0, w2, x1, x7, w8
+	eor		v0.16b, v0.16b, v4.16b
+	cmp		w3, wzr
+	csinv		x5, x6, xzr, eq
+	cbz		w5, .Lmacout
+	encrypt_block	v0, w2, x1, x7, w8
+	b		.Lmacloop4x
+.Lmac1x:
+	add		w3, w3, #4
 .Lmacloop:
 	cbz		w3, .Lmacout
 	ld1		{v1.16b}, [x0], #16		/* get next pt block */
@@ -406,7 +426,6 @@ AES_ENTRY(aes_mac_update)
 	csinv		x5, x6, xzr, eq
 	cbz		w5, .Lmacout
 
-.Lmacenc:
 	encrypt_block	v0, w2, x1, x7, w8
 	b		.Lmacloop
 
-- 
2.11.0

