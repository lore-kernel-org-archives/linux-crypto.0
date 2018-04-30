From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 08/10] crypto: arm64/crct10dif-ce - yield NEON after
 every block of input
Date: Mon, 30 Apr 2018 18:18:28 +0200
Message-ID: <20180430161830.14892-9-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/crct10dif-ce-core.S | 32 +++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index f179c01bd55c..663ea71cdb38 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -74,13 +74,19 @@
 	.text
 	.cpu		generic+crypto
 
-	arg1_low32	.req	w0
-	arg2		.req	x1
-	arg3		.req	x2
+	arg1_low32	.req	w19
+	arg2		.req	x20
+	arg3		.req	x21
 
 	vzr		.req	v13
 
 ENTRY(crc_t10dif_pmull)
+	frame_push	3, 128
+
+	mov		arg1_low32, w0
+	mov		arg2, x1
+	mov		arg3, x2
+
 	movi		vzr.16b, #0		// init zero register
 
 	// adjust the 16-bit initial_crc value, scale it to 32 bits
@@ -175,8 +181,25 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 	subs		arg3, arg3, #128
 
 	// check if there is another 64B in the buffer to be able to fold
-	b.ge		_fold_64_B_loop
+	b.lt		_fold_64_B_end
+
+	if_will_cond_yield_neon
+	stp		q0, q1, [sp, #.Lframe_local_offset]
+	stp		q2, q3, [sp, #.Lframe_local_offset + 32]
+	stp		q4, q5, [sp, #.Lframe_local_offset + 64]
+	stp		q6, q7, [sp, #.Lframe_local_offset + 96]
+	do_cond_yield_neon
+	ldp		q0, q1, [sp, #.Lframe_local_offset]
+	ldp		q2, q3, [sp, #.Lframe_local_offset + 32]
+	ldp		q4, q5, [sp, #.Lframe_local_offset + 64]
+	ldp		q6, q7, [sp, #.Lframe_local_offset + 96]
+	ldr_l		q10, rk3, x8
+	movi		vzr.16b, #0		// init zero register
+	endif_yield_neon
+
+	b		_fold_64_B_loop
 
+_fold_64_B_end:
 	// at this point, the buffer pointer is pointing at the last y Bytes
 	// of the buffer the 64B of folded data is in 4 of the vector
 	// registers: v0, v1, v2, v3
@@ -304,6 +327,7 @@ _barrett:
 _cleanup:
 	// scale the result back to 16 bits
 	lsr		x0, x0, #16
+	frame_pop
 	ret
 
 _less_than_128:
-- 
2.17.0
