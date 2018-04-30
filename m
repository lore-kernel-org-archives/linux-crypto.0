From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 07/10] crypto: arm64/crc32-ce - yield NEON after every
 block of input
Date: Mon, 30 Apr 2018 18:18:27 +0200
Message-ID: <20180430161830.14892-8-ard.biesheuvel@linaro.org>
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
yielding the NEON after every block of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crc32-ce-core.S | 40 +++++++++++++++-----
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/crypto/crc32-ce-core.S b/arch/arm64/crypto/crc32-ce-core.S
index 16ed3c7ebd37..8061bf0f9c66 100644
--- a/arch/arm64/crypto/crc32-ce-core.S
+++ b/arch/arm64/crypto/crc32-ce-core.S
@@ -100,9 +100,10 @@
 	dCONSTANT	.req	d0
 	qCONSTANT	.req	q0
 
-	BUF		.req	x0
-	LEN		.req	x1
-	CRC		.req	x2
+	BUF		.req	x19
+	LEN		.req	x20
+	CRC		.req	x21
+	CONST		.req	x22
 
 	vzr		.req	v9
 
@@ -123,7 +124,14 @@ ENTRY(crc32_pmull_le)
 ENTRY(crc32c_pmull_le)
 	adr_l		x3, .Lcrc32c_constants
 
-0:	bic		LEN, LEN, #15
+0:	frame_push	4, 64
+
+	mov		BUF, x0
+	mov		LEN, x1
+	mov		CRC, x2
+	mov		CONST, x3
+
+	bic		LEN, LEN, #15
 	ld1		{v1.16b-v4.16b}, [BUF], #0x40
 	movi		vzr.16b, #0
 	fmov		dCONSTANT, CRC
@@ -132,7 +140,7 @@ ENTRY(crc32c_pmull_le)
 	cmp		LEN, #0x40
 	b.lt		less_64
 
-	ldr		qCONSTANT, [x3]
+	ldr		qCONSTANT, [CONST]
 
 loop_64:		/* 64 bytes Full cache line folding */
 	sub		LEN, LEN, #0x40
@@ -162,10 +170,21 @@ loop_64:		/* 64 bytes Full cache line folding */
 	eor		v4.16b, v4.16b, v8.16b
 
 	cmp		LEN, #0x40
-	b.ge		loop_64
+	b.lt		less_64
+
+	if_will_cond_yield_neon
+	stp		q1, q2, [sp, #.Lframe_local_offset]
+	stp		q3, q4, [sp, #.Lframe_local_offset + 32]
+	do_cond_yield_neon
+	ldp		q1, q2, [sp, #.Lframe_local_offset]
+	ldp		q3, q4, [sp, #.Lframe_local_offset + 32]
+	ldr		qCONSTANT, [CONST]
+	movi		vzr.16b, #0
+	endif_yield_neon
+	b		loop_64
 
 less_64:		/* Folding cache line into 128bit */
-	ldr		qCONSTANT, [x3, #16]
+	ldr		qCONSTANT, [CONST, #16]
 
 	pmull2		v5.1q, v1.2d, vCONSTANT.2d
 	pmull		v1.1q, v1.1d, vCONSTANT.1d
@@ -204,8 +223,8 @@ fold_64:
 	eor		v1.16b, v1.16b, v2.16b
 
 	/* final 32-bit fold */
-	ldr		dCONSTANT, [x3, #32]
-	ldr		d3, [x3, #40]
+	ldr		dCONSTANT, [CONST, #32]
+	ldr		d3, [CONST, #40]
 
 	ext		v2.16b, v1.16b, vzr.16b, #4
 	and		v1.16b, v1.16b, v3.16b
@@ -213,7 +232,7 @@ fold_64:
 	eor		v1.16b, v1.16b, v2.16b
 
 	/* Finish up with the bit-reversed barrett reduction 64 ==> 32 bits */
-	ldr		qCONSTANT, [x3, #48]
+	ldr		qCONSTANT, [CONST, #48]
 
 	and		v2.16b, v1.16b, v3.16b
 	ext		v2.16b, vzr.16b, v2.16b, #8
@@ -223,6 +242,7 @@ fold_64:
 	eor		v1.16b, v1.16b, v2.16b
 	mov		w0, v1.s[1]
 
+	frame_pop
 	ret
 ENDPROC(crc32_pmull_le)
 ENDPROC(crc32c_pmull_le)
-- 
2.17.0
