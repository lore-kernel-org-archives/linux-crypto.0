From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 07/23] crypto: arm64/aes-blk - add 4 way interleave to CBC
 encrypt path
Date: Sat, 10 Mar 2018 15:21:52 +0000
Message-ID: <20180310152208.10369-8-ard.biesheuvel@linaro.org>
References: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, herbert@gondor.apana.org.au,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will.deacon@arm.com>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-rt-users@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
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

CBC encryption is strictly sequential, and so the current AES code
simply processes the input one block at a time. However, we are
about to add yield support, which adds a bit of overhead, and which
we prefer to align with other modes in terms of granularity (i.e.,
it is better to have all routines yield every 64 bytes and not have
an exception for CBC encrypt which yields every 16 bytes)

So unroll the loop by 4. We still cannot perform the AES algorithm in
parallel, but we can at least merge the loads and stores.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-modes.S | 31 ++++++++++++++++----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 27a235b2ddee..e86535a1329d 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -94,17 +94,36 @@ AES_ENDPROC(aes_ecb_decrypt)
 	 */
 
 AES_ENTRY(aes_cbc_encrypt)
-	ld1		{v0.16b}, [x5]			/* get iv */
+	ld1		{v4.16b}, [x5]			/* get iv */
 	enc_prepare	w3, x2, x6
 
-.Lcbcencloop:
-	ld1		{v1.16b}, [x1], #16		/* get next pt block */
-	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with iv */
+.Lcbcencloop4x:
+	subs		w4, w4, #4
+	bmi		.Lcbcenc1x
+	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
+	eor		v0.16b, v0.16b, v4.16b		/* ..and xor with iv */
 	encrypt_block	v0, w3, x2, x6, w7
-	st1		{v0.16b}, [x0], #16
+	eor		v1.16b, v1.16b, v0.16b
+	encrypt_block	v1, w3, x2, x6, w7
+	eor		v2.16b, v2.16b, v1.16b
+	encrypt_block	v2, w3, x2, x6, w7
+	eor		v3.16b, v3.16b, v2.16b
+	encrypt_block	v3, w3, x2, x6, w7
+	st1		{v0.16b-v3.16b}, [x0], #64
+	mov		v4.16b, v3.16b
+	b		.Lcbcencloop4x
+.Lcbcenc1x:
+	adds		w4, w4, #4
+	beq		.Lcbcencout
+.Lcbcencloop:
+	ld1		{v0.16b}, [x1], #16		/* get next pt block */
+	eor		v4.16b, v4.16b, v0.16b		/* ..and xor with iv */
+	encrypt_block	v4, w3, x2, x6, w7
+	st1		{v4.16b}, [x0], #16
 	subs		w4, w4, #1
 	bne		.Lcbcencloop
-	st1		{v0.16b}, [x5]			/* return iv */
+.Lcbcencout:
+	st1		{v4.16b}, [x5]			/* return iv */
 	ret
 AES_ENDPROC(aes_cbc_encrypt)
 
-- 
2.15.1
