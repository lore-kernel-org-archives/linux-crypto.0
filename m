From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm64/aes-modes - get rid of literal load of addend
 vector
Date: Tue, 21 Aug 2018 18:46:14 +0200
Message-ID: <20180821164614.31513-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Nick Desaulniers <ndesaulniers@google.com>, will.deacon@arm.com,
 herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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

Replace the literal load of the addend vector with a sequence that
composes it using immediates. While at it, tweak the code that refers
to it so it does not clobber the register, so we can take the load
out of the loop as well.

This results in generally better code, but also works around a Clang
issue, whose integrated assembler does not implement the GNU ARM asm
syntax completely, and does not support the =literal notation for
FP registers.

Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-modes.S | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 483a7130cf0e..e966620ee230 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -225,6 +225,14 @@ AES_ENTRY(aes_ctr_encrypt)
 	enc_prepare	w22, x21, x6
 	ld1		{v4.16b}, [x24]
 
+	/* compose addend vector { 1, 2, 3, 0 } in v8.4s */
+	movi		v7.4h, #1
+	movi		v8.4h, #2
+	uaddl		v6.4s, v7.4h, v8.4h
+	zip1		v8.8h, v7.8h, v8.8h
+	zip1		v8.4s, v8.4s, v6.4s
+	zip2		v8.8h, v8.8h, v7.8h
+
 	umov		x6, v4.d[1]		/* keep swabbed ctr in reg */
 	rev		x6, x6
 .LctrloopNx:
@@ -232,17 +240,16 @@ AES_ENTRY(aes_ctr_encrypt)
 	bmi		.Lctr1x
 	cmn		w6, #4			/* 32 bit overflow? */
 	bcs		.Lctr1x
-	ldr		q8, =0x30000000200000001	/* addends 1,2,3[,0] */
 	dup		v7.4s, w6
 	mov		v0.16b, v4.16b
 	add		v7.4s, v7.4s, v8.4s
 	mov		v1.16b, v4.16b
-	rev32		v8.16b, v7.16b
+	rev32		v7.16b, v7.16b
 	mov		v2.16b, v4.16b
 	mov		v3.16b, v4.16b
-	mov		v1.s[3], v8.s[0]
-	mov		v2.s[3], v8.s[1]
-	mov		v3.s[3], v8.s[2]
+	mov		v1.s[3], v7.s[0]
+	mov		v2.s[3], v7.s[1]
+	mov		v3.s[3], v7.s[2]
 	ld1		{v5.16b-v7.16b}, [x20], #48	/* get 3 input blocks */
 	bl		aes_encrypt_block4x
 	eor		v0.16b, v5.16b, v0.16b
@@ -296,7 +303,6 @@ AES_ENTRY(aes_ctr_encrypt)
 	ins		v4.d[0], x7
 	b		.Lctrcarrydone
 AES_ENDPROC(aes_ctr_encrypt)
-	.ltorg
 
 
 	/*
-- 
2.17.1
