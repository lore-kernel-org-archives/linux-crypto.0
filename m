From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] crypto: arm/chacha20 - faster 8-bit rotations and other
 optimizations
Date: Sat,  1 Sep 2018 00:17:07 -0700
Message-ID: <20180901071707.14712-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
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

From: Eric Biggers <ebiggers@google.com>

Optimize ChaCha20 NEON performance by:

- Implementing the 8-bit rotations using the 'vtbl.8' instruction.
- Streamlining the part that adds the original state and XORs the data.
- Making some other small tweaks.

On ARM Cortex-A7, these optimizations improve ChaCha20 performance from
about 12.08 cycles per byte to about 11.37 -- a 5.9% improvement.

There is a tradeoff involved with the 'vtbl.8' rotation method since
there is at least one CPU (Cortex-A53) where it's not fastest.  But it
seems to be a better default; see the added comment.  Overall, this
patch reduces Cortex-A53 performance by less than 0.5%.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/chacha20-neon-core.S | 277 ++++++++++++++-------------
 1 file changed, 143 insertions(+), 134 deletions(-)

diff --git a/arch/arm/crypto/chacha20-neon-core.S b/arch/arm/crypto/chacha20-neon-core.S
index 451a849ad5186..50e7b98968189 100644
--- a/arch/arm/crypto/chacha20-neon-core.S
+++ b/arch/arm/crypto/chacha20-neon-core.S
@@ -18,6 +18,34 @@
  * (at your option) any later version.
  */
 
+ /*
+  * NEON doesn't have a rotate instruction.  The alternatives are, more or less:
+  *
+  * (a)  vshl.u32 + vsri.u32		(needs temporary register)
+  * (b)  vshl.u32 + vshr.u32 + vorr	(needs temporary register)
+  * (c)  vrev32.16			(16-bit rotations only)
+  * (d)  vtbl.8 + vtbl.8		(multiple of 8 bits rotations only,
+  *					 needs index vector)
+  *
+  * ChaCha20 has 16, 12, 8, and 7-bit rotations.  For the 12 and 7-bit
+  * rotations, the only choices are (a) and (b).  We use (a) since it takes
+  * two-thirds the cycles of (b) on both Cortex-A7 and Cortex-A53.
+  *
+  * For the 16-bit rotation, we use vrev32.16 since it's consistently fastest
+  * and doesn't need a temporary register.
+  *
+  * For the 8-bit rotation, we use vtbl.8 + vtbl.8.  On Cortex-A7, this sequence
+  * is twice as fast as (a), even when doing (a) on multiple registers
+  * simultaneously to eliminate the stall between vshl and vsri.  Also, it
+  * parallelizes better when temporary registers are scarce.
+  *
+  * A disadvantage is that on Cortex-A53, the vtbl sequence is the same speed as
+  * (a), so the need to load the rotation table actually makes the vtbl method
+  * slightly slower overall on that CPU (~1.3% slower ChaCha20).  Still, it
+  * seems to be a good compromise to get a more significant speed boost on some
+  * CPUs, e.g. ~4.8% faster ChaCha20 on Cortex-A7.
+  */
+
 #include <linux/linkage.h>
 
 	.text
@@ -46,7 +74,9 @@ ENTRY(chacha20_block_xor_neon)
 	vmov		q10, q2
 	vmov		q11, q3
 
+	adr		ip, .Lrol8_table
 	mov		r3, #10
+	vld1.8		{d10}, [ip, :64]
 
 .Ldoubleround:
 	// x0 += x1, x3 = rotl32(x3 ^ x0, 16)
@@ -62,9 +92,9 @@ ENTRY(chacha20_block_xor_neon)
 
 	// x0 += x1, x3 = rotl32(x3 ^ x0, 8)
 	vadd.i32	q0, q0, q1
-	veor		q4, q3, q0
-	vshl.u32	q3, q4, #8
-	vsri.u32	q3, q4, #24
+	veor		q3, q3, q0
+	vtbl.8		d6, {d6}, d10
+	vtbl.8		d7, {d7}, d10
 
 	// x2 += x3, x1 = rotl32(x1 ^ x2, 7)
 	vadd.i32	q2, q2, q3
@@ -92,9 +122,9 @@ ENTRY(chacha20_block_xor_neon)
 
 	// x0 += x1, x3 = rotl32(x3 ^ x0, 8)
 	vadd.i32	q0, q0, q1
-	veor		q4, q3, q0
-	vshl.u32	q3, q4, #8
-	vsri.u32	q3, q4, #24
+	veor		q3, q3, q0
+	vtbl.8		d6, {d6}, d10
+	vtbl.8		d7, {d7}, d10
 
 	// x2 += x3, x1 = rotl32(x1 ^ x2, 7)
 	vadd.i32	q2, q2, q3
@@ -139,13 +169,17 @@ ENTRY(chacha20_block_xor_neon)
 	bx		lr
 ENDPROC(chacha20_block_xor_neon)
 
+	.align		4
+.Lctrinc:	.word	0, 1, 2, 3
+.Lrol8_table:	.byte	3, 0, 1, 2, 7, 4, 5, 6
+
 	.align		5
 ENTRY(chacha20_4block_xor_neon)
-	push		{r4-r6, lr}
-	mov		ip, sp			// preserve the stack pointer
-	sub		r3, sp, #0x20		// allocate a 32 byte buffer
-	bic		r3, r3, #0x1f		// aligned to 32 bytes
-	mov		sp, r3
+	push		{r4-r5}
+	mov		r4, sp			// preserve the stack pointer
+	sub		ip, sp, #0x20		// allocate a 32 byte buffer
+	bic		ip, ip, #0x1f		// aligned to 32 bytes
+	mov		sp, ip
 
 	// r0: Input state matrix, s
 	// r1: 4 data blocks output, o
@@ -155,25 +189,24 @@ ENTRY(chacha20_4block_xor_neon)
 	// This function encrypts four consecutive ChaCha20 blocks by loading
 	// the state matrix in NEON registers four times. The algorithm performs
 	// each operation on the corresponding word of each state matrix, hence
-	// requires no word shuffling. For final XORing step we transpose the
-	// matrix by interleaving 32- and then 64-bit words, which allows us to
-	// do XOR in NEON registers.
+	// requires no word shuffling. The words are re-interleaved before the
+	// final addition of the original state and the XORing step.
 	//
 
-	// x0..15[0-3] = s0..3[0..3]
-	add		r3, r0, #0x20
+	// x0..15[0-3] = s0..15[0-3]
+	add		ip, r0, #0x20
 	vld1.32		{q0-q1}, [r0]
-	vld1.32		{q2-q3}, [r3]
+	vld1.32		{q2-q3}, [ip]
 
-	adr		r3, CTRINC
+	adr		r5, .Lctrinc
 	vdup.32		q15, d7[1]
 	vdup.32		q14, d7[0]
-	vld1.32		{q11}, [r3, :128]
+	vld1.32		{q4}, [r5, :128]
 	vdup.32		q13, d6[1]
 	vdup.32		q12, d6[0]
-	vadd.i32	q12, q12, q11		// x12 += counter values 0-3
 	vdup.32		q11, d5[1]
 	vdup.32		q10, d5[0]
+	vadd.u32	q12, q12, q4		// x12 += counter values 0-3
 	vdup.32		q9, d4[1]
 	vdup.32		q8, d4[0]
 	vdup.32		q7, d3[1]
@@ -185,9 +218,13 @@ ENTRY(chacha20_4block_xor_neon)
 	vdup.32		q1, d0[1]
 	vdup.32		q0, d0[0]
 
+	adr		ip, .Lrol8_table
 	mov		r3, #10
+	b		1f
 
 .Ldoubleround4:
+	vld1.32		{q8-q9}, [sp, :256]
+1:
 	// x0 += x4, x12 = rotl32(x12 ^ x0, 16)
 	// x1 += x5, x13 = rotl32(x13 ^ x1, 16)
 	// x2 += x6, x14 = rotl32(x14 ^ x2, 16)
@@ -236,24 +273,25 @@ ENTRY(chacha20_4block_xor_neon)
 	// x1 += x5, x13 = rotl32(x13 ^ x1, 8)
 	// x2 += x6, x14 = rotl32(x14 ^ x2, 8)
 	// x3 += x7, x15 = rotl32(x15 ^ x3, 8)
+	vld1.8		{d16}, [ip, :64]
 	vadd.i32	q0, q0, q4
 	vadd.i32	q1, q1, q5
 	vadd.i32	q2, q2, q6
 	vadd.i32	q3, q3, q7
 
-	veor		q8, q12, q0
-	veor		q9, q13, q1
-	vshl.u32	q12, q8, #8
-	vshl.u32	q13, q9, #8
-	vsri.u32	q12, q8, #24
-	vsri.u32	q13, q9, #24
+	veor		q12, q12, q0
+	veor		q13, q13, q1
+	veor		q14, q14, q2
+	veor		q15, q15, q3
 
-	veor		q8, q14, q2
-	veor		q9, q15, q3
-	vshl.u32	q14, q8, #8
-	vshl.u32	q15, q9, #8
-	vsri.u32	q14, q8, #24
-	vsri.u32	q15, q9, #24
+	vtbl.8		d24, {d24}, d16
+	vtbl.8		d25, {d25}, d16
+	vtbl.8		d26, {d26}, d16
+	vtbl.8		d27, {d27}, d16
+	vtbl.8		d28, {d28}, d16
+	vtbl.8		d29, {d29}, d16
+	vtbl.8		d30, {d30}, d16
+	vtbl.8		d31, {d31}, d16
 
 	vld1.32		{q8-q9}, [sp, :256]
 
@@ -332,24 +370,25 @@ ENTRY(chacha20_4block_xor_neon)
 	// x1 += x6, x12 = rotl32(x12 ^ x1, 8)
 	// x2 += x7, x13 = rotl32(x13 ^ x2, 8)
 	// x3 += x4, x14 = rotl32(x14 ^ x3, 8)
+	vld1.8		{d16}, [ip, :64]
 	vadd.i32	q0, q0, q5
 	vadd.i32	q1, q1, q6
 	vadd.i32	q2, q2, q7
 	vadd.i32	q3, q3, q4
 
-	veor		q8, q15, q0
-	veor		q9, q12, q1
-	vshl.u32	q15, q8, #8
-	vshl.u32	q12, q9, #8
-	vsri.u32	q15, q8, #24
-	vsri.u32	q12, q9, #24
+	veor		q15, q15, q0
+	veor		q12, q12, q1
+	veor		q13, q13, q2
+	veor		q14, q14, q3
 
-	veor		q8, q13, q2
-	veor		q9, q14, q3
-	vshl.u32	q13, q8, #8
-	vshl.u32	q14, q9, #8
-	vsri.u32	q13, q8, #24
-	vsri.u32	q14, q9, #24
+	vtbl.8		d30, {d30}, d16
+	vtbl.8		d31, {d31}, d16
+	vtbl.8		d24, {d24}, d16
+	vtbl.8		d25, {d25}, d16
+	vtbl.8		d26, {d26}, d16
+	vtbl.8		d27, {d27}, d16
+	vtbl.8		d28, {d28}, d16
+	vtbl.8		d29, {d29}, d16
 
 	vld1.32		{q8-q9}, [sp, :256]
 
@@ -379,104 +418,76 @@ ENTRY(chacha20_4block_xor_neon)
 	vsri.u32	q6, q9, #25
 
 	subs		r3, r3, #1
-	beq		0f
-
-	vld1.32		{q8-q9}, [sp, :256]
-	b		.Ldoubleround4
-
-	// x0[0-3] += s0[0]
-	// x1[0-3] += s0[1]
-	// x2[0-3] += s0[2]
-	// x3[0-3] += s0[3]
-0:	ldmia		r0!, {r3-r6}
-	vdup.32		q8, r3
-	vdup.32		q9, r4
-	vadd.i32	q0, q0, q8
-	vadd.i32	q1, q1, q9
-	vdup.32		q8, r5
-	vdup.32		q9, r6
-	vadd.i32	q2, q2, q8
-	vadd.i32	q3, q3, q9
-
-	// x4[0-3] += s1[0]
-	// x5[0-3] += s1[1]
-	// x6[0-3] += s1[2]
-	// x7[0-3] += s1[3]
-	ldmia		r0!, {r3-r6}
-	vdup.32		q8, r3
-	vdup.32		q9, r4
-	vadd.i32	q4, q4, q8
-	vadd.i32	q5, q5, q9
-	vdup.32		q8, r5
-	vdup.32		q9, r6
-	vadd.i32	q6, q6, q8
-	vadd.i32	q7, q7, q9
-
-	// interleave 32-bit words in state n, n+1
-	vzip.32		q0, q1
-	vzip.32		q2, q3
-	vzip.32		q4, q5
-	vzip.32		q6, q7
-
-	// interleave 64-bit words in state n, n+2
+	bne		.Ldoubleround4
+
+	// x0..7[0-3] are in q0-q7, x10..15[0-3] are in q10-q15.
+	// x8..9[0-3] are on the stack.
+
+	// Re-interleave the words in the first two rows of each block (x0..7).
+	// Also add the counter values 0-3 to x12[0-3].
+	  vld1.32	{q8}, [r5, :128]	// load counter values 0-3
+	vzip.32		q0, q1			// => (0 1 0 1) (0 1 0 1)
+	vzip.32		q2, q3			// => (2 3 2 3) (2 3 2 3)
+	vzip.32		q4, q5			// => (4 5 4 5) (4 5 4 5)
+	vzip.32		q6, q7			// => (6 7 6 7) (6 7 6 7)
+	  vadd.u32	q12, q8			// x12 += counter values 0-3
 	vswp		d1, d4
 	vswp		d3, d6
+	  vld1.32	{q8-q9}, [r0]!		// load s0..7
 	vswp		d9, d12
 	vswp		d11, d14
 
-	// xor with corresponding input, write to output
+	// Swap q1 and q4 so that we'll free up consecutive registers (q0-q1)
+	// after XORing the first 32 bytes.
+	vswp		q1, q4
+
+	// First two rows of each block are (q0 q1) (q2 q6) (q4 q5) (q3 q7)
+
+	// x0..3[0-3] += s0..3[0-3]	(add orig state to 1st row of each block)
+	vadd.u32	q0, q0, q8
+	vadd.u32	q2, q2, q8
+	vadd.u32	q4, q4, q8
+	vadd.u32	q3, q3, q8
+
+	// x4..7[0-3] += s4..7[0-3]	(add orig state to 2nd row of each block)
+	vadd.u32	q1, q1, q9
+	vadd.u32	q6, q6, q9
+	vadd.u32	q5, q5, q9
+	vadd.u32	q7, q7, q9
+
+	// XOR first 32 bytes using keystream from first two rows of first block
 	vld1.8		{q8-q9}, [r2]!
 	veor		q8, q8, q0
-	veor		q9, q9, q4
+	veor		q9, q9, q1
 	vst1.8		{q8-q9}, [r1]!
 
+	// Re-interleave the words in the last two rows of each block (x8..15).
 	vld1.32		{q8-q9}, [sp, :256]
-
-	// x8[0-3] += s2[0]
-	// x9[0-3] += s2[1]
-	// x10[0-3] += s2[2]
-	// x11[0-3] += s2[3]
-	ldmia		r0!, {r3-r6}
-	vdup.32		q0, r3
-	vdup.32		q4, r4
-	vadd.i32	q8, q8, q0
-	vadd.i32	q9, q9, q4
-	vdup.32		q0, r5
-	vdup.32		q4, r6
-	vadd.i32	q10, q10, q0
-	vadd.i32	q11, q11, q4
-
-	// x12[0-3] += s3[0]
-	// x13[0-3] += s3[1]
-	// x14[0-3] += s3[2]
-	// x15[0-3] += s3[3]
-	ldmia		r0!, {r3-r6}
-	vdup.32		q0, r3
-	vdup.32		q4, r4
-	adr		r3, CTRINC
-	vadd.i32	q12, q12, q0
-	vld1.32		{q0}, [r3, :128]
-	vadd.i32	q13, q13, q4
-	vadd.i32	q12, q12, q0		// x12 += counter values 0-3
-
-	vdup.32		q0, r5
-	vdup.32		q4, r6
-	vadd.i32	q14, q14, q0
-	vadd.i32	q15, q15, q4
-
-	// interleave 32-bit words in state n, n+1
-	vzip.32		q8, q9
-	vzip.32		q10, q11
-	vzip.32		q12, q13
-	vzip.32		q14, q15
-
-	// interleave 64-bit words in state n, n+2
-	vswp		d17, d20
-	vswp		d19, d22
+	vzip.32		q12, q13	// => (12 13 12 13) (12 13 12 13)
+	vzip.32		q14, q15	// => (14 15 14 15) (14 15 14 15)
+	vzip.32		q8, q9		// => (8 9 8 9) (8 9 8 9)
+	vzip.32		q10, q11	// => (10 11 10 11) (10 11 10 11)
+	  vld1.32	{q0-q1}, [r0]	// load s8..15
 	vswp		d25, d28
 	vswp		d27, d30
+	vswp		d17, d20
+	vswp		d19, d22
+
+	// Last two rows of each block are (q8 q12) (q10 q14) (q9 q13) (q11 q15)
+
+	// x8..11[0-3] += s8..11[0-3]	(add orig state to 3rd row of each block)
+	vadd.u32	q8,  q8,  q0
+	vadd.u32	q10, q10, q0
+	vadd.u32	q9,  q9,  q0
+	vadd.u32	q11, q11, q0
+
+	// x12..15[0-3] += s12..15[0-3] (add orig state to 4th row of each block)
+	vadd.u32	q12, q12, q1
+	vadd.u32	q14, q14, q1
+	vadd.u32	q13, q13, q1
+	vadd.u32	q15, q15, q1
 
-	vmov		q4, q1
+	// XOR the rest of the data with the keystream
 
 	vld1.8		{q0-q1}, [r2]!
 	veor		q0, q0, q8
@@ -509,13 +520,11 @@ ENTRY(chacha20_4block_xor_neon)
 	vst1.8		{q0-q1}, [r1]!
 
 	vld1.8		{q0-q1}, [r2]
+	  mov		sp, r4		// restore original stack pointer
 	veor		q0, q0, q11
 	veor		q1, q1, q15
 	vst1.8		{q0-q1}, [r1]
 
-	mov		sp, ip
-	pop		{r4-r6, pc}
+	pop		{r4-r5}
+	bx		lr
 ENDPROC(chacha20_4block_xor_neon)
-
-	.align		4
-CTRINC:	.word		0, 1, 2, 3
-- 
2.18.0
