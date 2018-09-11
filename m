From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v3 10/17] zinc: Poly1305 MIPS32r2 and MIPS64 implementations
Date: Mon, 10 Sep 2018 19:08:31 -0600
Message-ID: <20180911010838.8818-12-Jason@zx2c4.com>
References: <20180911010838.8818-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911010838.8818-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This MIPS32r2 implementation comes from René van Dorst and me and
results in a nice speedup on the usual OpenWRT targets. The MIPS64
implementation comes from Andy Polyakov with some kernel-friendly
modifications from me and results in a nice speedup on commodity Octeon
hardware.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: Andy Polyakov <appro@openssl.org>
Cc: René van Dorst <opensource@vdorst.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@mips.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@linux-mips.org
Cc: linux-crypto@vger.kernel.org
---
 lib/zinc/Makefile                      |   8 +
 lib/zinc/poly1305/poly1305-mips-glue.h |  40 +++
 lib/zinc/poly1305/poly1305-mips.S      | 417 +++++++++++++++++++++++++
 lib/zinc/poly1305/poly1305-mips64.S    | 359 +++++++++++++++++++++
 4 files changed, 824 insertions(+)
 create mode 100644 lib/zinc/poly1305/poly1305-mips-glue.h
 create mode 100644 lib/zinc/poly1305/poly1305-mips.S
 create mode 100644 lib/zinc/poly1305/poly1305-mips64.S

diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
index 66b2f43e4592..856048209925 100644
--- a/lib/zinc/Makefile
+++ b/lib/zinc/Makefile
@@ -37,6 +37,14 @@ ifeq ($(CONFIG_ARM64),y)
 zinc-y += poly1305/poly1305-arm64.o
 CFLAGS_poly1305.o += -include $(srctree)/$(src)/poly1305/poly1305-arm-glue.h
 endif
+ifeq ($(CONFIG_MIPS)$(CONFIG_CPU_MIPS32_R2),yy)
+zinc-y += poly1305/poly1305-mips.o
+CFLAGS_poly1305.o += -include $(srctree)/$(src)/poly1305/poly1305-mips-glue.h
+endif
+ifeq ($(CONFIG_MIPS)$(CONFIG_64BIT),yy)
+zinc-y += poly1305/poly1305-mips64.o
+CFLAGS_poly1305.o += -include $(srctree)/$(src)/poly1305/poly1305-mips-glue.h
+endif
 endif
 
 zinc-y += main.o
diff --git a/lib/zinc/poly1305/poly1305-mips-glue.h b/lib/zinc/poly1305/poly1305-mips-glue.h
new file mode 100644
index 000000000000..e29f85915eec
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-mips-glue.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <zinc/poly1305.h>
+
+asmlinkage void poly1305_init_mips(void *ctx, const u8 key[16]);
+asmlinkage void poly1305_blocks_mips(void *ctx, const u8 *inp, const size_t len,
+				     const u32 padbit);
+asmlinkage void poly1305_emit_mips(void *ctx, u8 mac[16], const u32 nonce[4]);
+void __init poly1305_fpu_init(void)
+{
+}
+
+static inline bool poly1305_init_arch(void *ctx,
+				      const u8 key[POLY1305_KEY_SIZE],
+				      simd_context_t simd_context)
+{
+	poly1305_init_mips(ctx, key);
+	return true;
+}
+
+static inline bool poly1305_blocks_arch(void *ctx, const u8 *inp,
+					const size_t len, const u32 padbit,
+					simd_context_t simd_context)
+{
+	poly1305_blocks_mips(ctx, inp, len, padbit);
+	return true;
+}
+
+static inline bool poly1305_emit_arch(void *ctx, u8 mac[POLY1305_MAC_SIZE],
+				      const u32 nonce[4],
+				      simd_context_t simd_context)
+{
+	poly1305_emit_mips(ctx, mac, nonce);
+	return true;
+}
+
+#define HAVE_POLY1305_ARCH_IMPLEMENTATION
diff --git a/lib/zinc/poly1305/poly1305-mips.S b/lib/zinc/poly1305/poly1305-mips.S
new file mode 100644
index 000000000000..32d8558d8601
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-mips.S
@@ -0,0 +1,417 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (C) 2016-2018 René van Dorst <opensource@vdorst.com> All Rights Reserved.
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#define MSB 0
+#define LSB 3
+#else
+#define MSB 3
+#define LSB 0
+#endif
+
+#define POLY1305_BLOCK_SIZE 16
+.text
+#define H0 $t0
+#define H1 $t1
+#define H2 $t2
+#define H3 $t3
+#define H4 $t4
+
+#define R0 $t5
+#define R1 $t6
+#define R2 $t7
+#define R3 $t8
+
+#define O0 $s0
+#define O1 $s4
+#define O2 $v1
+#define O3 $t9
+#define O4 $s5
+
+#define S1 $s1
+#define S2 $s2
+#define S3 $s3
+
+#define SC $at
+#define CA $v0
+
+/* Input arguments */
+#define poly	$a0
+#define src	$a1
+#define srclen	$a2
+#define hibit	$a3
+
+/* Location in the opaque buffer
+ * R[0..3], CA, H[0..4]
+ */
+#define PTR_POLY1305_R(n) ( 0 + (n*4)) ## ($a0)
+#define PTR_POLY1305_CA   (16        ) ## ($a0)
+#define PTR_POLY1305_H(n) (20 + (n*4)) ## ($a0)
+
+#define POLY1305_BLOCK_SIZE 16
+#define POLY1305_STACK_SIZE 8 * 4
+
+.set reorder
+.set noat
+.align 4
+.globl poly1305_blocks_mips
+.ent poly1305_blocks_mips
+poly1305_blocks_mips:
+	.frame  $sp,POLY1305_STACK_SIZE,$31
+	/* srclen &= 0xFFFFFFF0 */
+	ins	srclen, $zero, 0, 4
+
+	.set noreorder
+	/* check srclen >= 16 bytes */
+	beqz	srclen, .Lpoly1305_blocks_mips_end
+	addiu	$sp, -(POLY1305_STACK_SIZE)
+	.set reorder
+
+	/* Calculate last round based on src address pointer.
+	 * last round src ptr (srclen) = src + (srclen & 0xFFFFFFF0)
+	 */
+	addu	srclen, src
+
+	lw	R0, PTR_POLY1305_R(0)
+	lw	R1, PTR_POLY1305_R(1)
+	lw	R2, PTR_POLY1305_R(2)
+	lw	R3, PTR_POLY1305_R(3)
+
+	/* store the used save registers. */
+	sw	$s0, 0($sp)
+	sw	$s1, 4($sp)
+	sw	$s2, 8($sp)
+	sw	$s3, 12($sp)
+	sw	$s4, 16($sp)
+	sw	$s5, 20($sp)
+
+	/* load Hx and Carry */
+	lw	CA, PTR_POLY1305_CA
+	lw	H0, PTR_POLY1305_H(0)
+	lw	H1, PTR_POLY1305_H(1)
+	lw	H2, PTR_POLY1305_H(2)
+	lw	H3, PTR_POLY1305_H(3)
+	lw	H4, PTR_POLY1305_H(4)
+
+	/* Sx = Rx + (Rx >> 2) */
+	srl	S1, R1, 2
+	srl	S2, R2, 2
+	srl	S3, R3, 2
+	addu	S1, R1
+	addu	S2, R2
+	addu	S3, R3
+
+	addiu	SC, $zero, 1
+
+.Lpoly1305_loop:
+	lwl	O0, 0+MSB(src)
+	lwl	O1, 4+MSB(src)
+	lwl	O2, 8+MSB(src)
+	lwl	O3,12+MSB(src)
+	lwr	O0, 0+LSB(src)
+	lwr	O1, 4+LSB(src)
+	lwr	O2, 8+LSB(src)
+	lwr	O3,12+LSB(src)
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	wsbh	O0
+	wsbh	O1
+	wsbh	O2
+	wsbh	O3
+	rotr	O0, 16
+	rotr	O1, 16
+	rotr	O2, 16
+	rotr	O3, 16
+#endif
+
+	/* h0 = (u32)(d0 = (u64)h0 + inp[0] + c 'Carry_previous cycle'); */
+	addu	H0, CA
+	sltu	CA, H0, CA
+	addu	O0, H0
+	sltu	H0, O0, H0
+	addu	CA, H0
+
+	/* h1 = (u32)(d1 = (u64)h1 + (d0 >> 32) + inp[4]); */
+	addu	H1, CA
+	sltu	CA, H1, CA
+	addu	O1, H1
+	sltu	H1, O1, H1
+	addu	CA, H1
+
+	/* h2 = (u32)(d2 = (u64)h2 + (d1 >> 32) + inp[8]); */
+	addu	H2, CA
+	sltu	CA, H2, CA
+	addu	O2, H2
+	sltu	H2, O2, H2
+	addu	CA, H2
+
+	/* h3 = (u32)(d3 = (u64)h3 + (d2 >> 32) + inp[12]); */
+	addu	H3, CA
+	sltu	CA, H3, CA
+	addu	O3, H3
+	sltu	H3, O3, H3
+	addu	CA, H3
+
+	/* h4 += (u32)(d3 >> 32) + padbit; */
+	addu	H4, hibit
+	addu	O4, H4, CA
+
+	/* D0 */
+	multu	O0, R0
+	maddu	O1, S3
+	maddu	O2, S2
+	maddu	O3, S1
+	mfhi	CA
+	mflo	H0
+
+	/* D1 */
+	multu	O0, R1
+	maddu	O1, R0
+	maddu	O2, S3
+	maddu	O3, S2
+	maddu	O4, S1
+	maddu	CA, SC
+	mfhi	CA
+	mflo	H1
+
+	/* D2 */
+	multu	O0, R2
+	maddu	O1, R1
+	maddu	O2, R0
+	maddu	O3, S3
+	maddu	O4, S2
+	maddu	CA, SC
+	mfhi	CA
+	mflo	H2
+
+	/* D4 */
+	mul	H4, O4, R0
+
+	/* D3 */
+	multu	O0, R3
+	maddu	O1, R2
+	maddu	O2, R1
+	maddu	O3, R0
+	maddu	O4, S3
+	maddu	CA, SC
+	mfhi	CA
+	mflo	H3
+
+	addiu	src, POLY1305_BLOCK_SIZE
+
+	/* h4 += (u32)(d3 >> 32); */
+	addu	O4, H4, CA
+	/* h4 &= 3 */
+	andi	H4, O4, 3
+	/* c = (h4 >> 2) + (h4 & ~3U); */
+	srl	CA, O4, 2
+	ins	O4, $zero, 0, 2
+
+	/* able to do a 16 byte block. */
+	.set noreorder
+	bne	src, srclen, .Lpoly1305_loop
+	/* Delay slot is always executed. */
+	addu	CA, O4
+	.set reorder
+
+	/* restore the used save registers. */
+	lw	$s0, 0($sp)
+	lw	$s1, 4($sp)
+	lw	$s2, 8($sp)
+	lw	$s3, 12($sp)
+	lw	$s4, 16($sp)
+	lw	$s5, 20($sp)
+
+	/* store Hx and Carry */
+	sw	CA, PTR_POLY1305_CA
+	sw	H0, PTR_POLY1305_H(0)
+	sw	H1, PTR_POLY1305_H(1)
+	sw	H2, PTR_POLY1305_H(2)
+	sw	H3, PTR_POLY1305_H(3)
+	sw	H4, PTR_POLY1305_H(4)
+
+.Lpoly1305_blocks_mips_end:
+	/* Jump Back */
+	.set noreorder
+	jr	$ra
+	addiu	$sp, POLY1305_STACK_SIZE
+	.set reorder
+.end poly1305_blocks_mips
+.set at
+.set reorder
+
+/* Input arguments CTX=$a0, MAC=$a1, NONCE=$a2 */
+#define MAC	$a1
+#define NONCE	$a2
+
+#define G0	$t5
+#define G1	$t6
+#define G2	$t7
+#define G3	$t8
+#define G4	$t9
+
+.set reorder
+.set noat
+.align 4
+.globl poly1305_emit_mips
+.ent poly1305_emit_mips
+poly1305_emit_mips:
+	/* load Hx and Carry */
+	lw	CA, PTR_POLY1305_CA
+	lw	H0, PTR_POLY1305_H(0)
+	lw	H1, PTR_POLY1305_H(1)
+	lw	H2, PTR_POLY1305_H(2)
+	lw	H3, PTR_POLY1305_H(3)
+	lw	H4, PTR_POLY1305_H(4)
+
+	/* Add left over carry */
+	addu	H0, CA
+	sltu	CA, H0, CA
+	addu	H1, CA
+	sltu	CA, H1, CA
+	addu	H2, CA
+	sltu	CA, H2, CA
+	addu	H3, CA
+	sltu	CA, H3, CA
+	addu	H4, CA
+
+	/* compare to modulus by computing h + -p */
+	addiu	G0, H0, 5
+	sltu	CA, G0, H0
+	addu	G1, H1, CA
+	sltu	CA, G1, H1
+	addu	G2, H2, CA
+	sltu	CA, G2, H2
+	addu	G3, H3, CA
+	sltu	CA, G3, H3
+	addu	G4, H4, CA
+
+	srl	SC, G4, 2
+
+	/* if there was carry into 131st bit, h3:h0 = g3:g0 */
+	movn	H0, G0, SC
+	movn	H1, G1, SC
+	movn	H2, G2, SC
+	movn	H3, G3, SC
+
+	lwl	G0, 0+MSB(NONCE)
+	lwl	G1, 4+MSB(NONCE)
+	lwl	G2, 8+MSB(NONCE)
+	lwl	G3,12+MSB(NONCE)
+	lwr	G0, 0+LSB(NONCE)
+	lwr	G1, 4+LSB(NONCE)
+	lwr	G2, 8+LSB(NONCE)
+	lwr	G3,12+LSB(NONCE)
+
+	/* mac = (h + nonce) % (2^128) */
+	addu	H0, G0
+	sltu	CA, H0, G0
+
+	/* H1 */
+	addu	H1, CA
+	sltu	CA, H1, CA
+	addu	H1, G1
+	sltu	G1, H1, G1
+	addu	CA, G1
+
+	/* H2 */
+	addu	H2, CA
+	sltu	CA, H2, CA
+	addu	H2, G2
+	sltu	G2, H2, G2
+	addu	CA, G2
+
+	/* H3 */
+	addu	H3, CA
+	addu	H3, G3
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	wsbh	H0
+	wsbh	H1
+	wsbh	H2
+	wsbh	H3
+	rotr	H0, 16
+	rotr	H1, 16
+	rotr	H2, 16
+	rotr	H3, 16
+#endif
+
+	/* store MAC */
+	swl	H0, 0+MSB(MAC)
+	swl	H1, 4+MSB(MAC)
+	swl	H2, 8+MSB(MAC)
+	swl	H3,12+MSB(MAC)
+	swr	H0, 0+LSB(MAC)
+	swr	H1, 4+LSB(MAC)
+	swr	H2, 8+LSB(MAC)
+	.set noreorder
+	jr	$ra
+	swr	H3,12+LSB(MAC)
+	.set reorder
+.end poly1305_emit_mips
+
+#define PR0 $t0
+#define PR1 $t1
+#define PR2 $t2
+#define PR3 $t3
+#define PT0 $t4
+
+/* Input arguments CTX=$a0, KEY=$a1 */
+
+.align 4
+.globl poly1305_init_mips
+.ent poly1305_init_mips
+poly1305_init_mips:
+	lwl	PR0, 0+MSB($a1)
+	lwl	PR1, 4+MSB($a1)
+	lwl	PR2, 8+MSB($a1)
+	lwl	PR3,12+MSB($a1)
+	lwr	PR0, 0+LSB($a1)
+	lwr	PR1, 4+LSB($a1)
+	lwr	PR2, 8+LSB($a1)
+	lwr	PR3,12+LSB($a1)
+
+	/* store Hx and Carry */
+	sw	$zero, PTR_POLY1305_CA
+	sw	$zero, PTR_POLY1305_H(0)
+	sw	$zero, PTR_POLY1305_H(1)
+	sw	$zero, PTR_POLY1305_H(2)
+	sw	$zero, PTR_POLY1305_H(3)
+	sw	$zero, PTR_POLY1305_H(4)
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	wsbh	PR0
+	wsbh	PR1
+	wsbh	PR2
+	wsbh	PR3
+	rotr	PR0, 16
+	rotr	PR1, 16
+	rotr	PR2, 16
+	rotr	PR3, 16
+#endif
+
+	lui	PT0, 0x0FFF
+	ori	PT0, 0xFFFC
+
+	/* AND 0x0fffffff; */
+	ext	PR0, PR0, 0, (32-4)
+
+	/* AND 0x0ffffffc; */
+	and	PR1, PT0
+	and	PR2, PT0
+	and	PR3, PT0
+
+	/* store Rx */
+	sw	PR0, PTR_POLY1305_R(0)
+	sw	PR1, PTR_POLY1305_R(1)
+	sw	PR2, PTR_POLY1305_R(2)
+
+	.set noreorder
+	/* Jump Back  */
+	jr	$ra
+	sw	PR3, PTR_POLY1305_R(3)
+	.set reorder
+.end poly1305_init_mips
diff --git a/lib/zinc/poly1305/poly1305-mips64.S b/lib/zinc/poly1305/poly1305-mips64.S
new file mode 100644
index 000000000000..66b0aa381570
--- /dev/null
+++ b/lib/zinc/poly1305/poly1305-mips64.S
@@ -0,0 +1,359 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ * Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
+ *
+ * This is based in part on Andy Polyakov's implementation from CRYPTOGAMS.
+ */
+
+#if !defined(CONFIG_64BIT)
+#error "This is only for 64-bit kernels."
+#endif
+
+#ifdef __MIPSEB__
+#define MSB 0
+#define LSB 7
+#else
+#define MSB 7
+#define LSB 0
+#endif
+
+#if defined(CONFIG_CPU_MIPS64_R6) || defined(CONFIG_CPU_MIPSR6)
+#define dmultu(rs,rt)
+#define mflo(rd,rs,rt)	dmulu	rd,rs,rt
+#define mfhi(rd,rs,rt)	dmuhu	rd,rs,rt
+#else
+#define dmultu(rs,rt)		dmultu	rs,rt
+#define multu(rs,rt)		multu	rs,rt
+#define mflo(rd,rs,rt)	mflo	rd
+#define mfhi(rd,rs,rt)	mfhi	rd
+#endif
+
+.text
+.set	noat
+.set	noreorder
+
+/* While most of the assembly in the kernel prefers ENTRY() and ENDPROC(),
+ * there is no existing MIPS assembly that uses it, and MIPS assembler seems
+ * to like its own .ent/.end notation, which the MIPS include files don't
+ * provide in a MIPS-specific ENTRY/ENDPROC definition. So, we skip these
+ * for now, until somebody complains. */
+
+.align	5
+.globl	poly1305_init_mips
+.ent	poly1305_init_mips
+poly1305_init_mips:
+	.frame	$29,0,$31
+	.set	reorder
+
+	sd	$0,0($4)
+	sd	$0,8($4)
+	sd	$0,16($4)
+
+	beqz	$5,.Lno_key
+
+#if defined(CONFIG_CPU_MIPS64_R6) || defined(CONFIG_CPU_MIPSR6)
+	ld	$8,0($5)
+	ld	$9,8($5)
+#else
+	ldl	$8,0+MSB($5)
+	ldl	$9,8+MSB($5)
+	ldr	$8,0+LSB($5)
+	ldr	$9,8+LSB($5)
+#endif
+#ifdef	__MIPSEB__
+#if defined(CONFIG_CPU_MIPS64_R2) || defined(CONFIG_CPU_MIPSR2) || defined(CONFIG_CPU_MIPS64_R6) || defined(CONFIG_CPU_MIPSR6)
+	dsbh	$8,$8		# byte swap
+	 dsbh	$9,$9
+	dshd	$8,$8
+	 dshd	$9,$9
+#else
+	ori	$10,$0,0xFF
+	dsll	$1,$10,32
+	or	$10,$1		# 0x000000FF000000FF
+
+	and	$11,$8,$10	# byte swap
+	 and	$2,$9,$10
+	dsrl	$1,$8,24
+	 dsrl	$24,$9,24
+	dsll	$11,24
+	 dsll	$2,24
+	and	$1,$10
+	 and	$24,$10
+	dsll	$10,8			# 0x0000FF000000FF00
+	or	$11,$1
+	 or	$2,$24
+	and	$1,$8,$10
+	 and	$24,$9,$10
+	dsrl	$8,8
+	 dsrl	$9,8
+	dsll	$1,8
+	 dsll	$24,8
+	and	$8,$10
+	 and	$9,$10
+	or	$11,$1
+	 or	$2,$24
+	or	$8,$11
+	 or	$9,$2
+	dsrl	$11,$8,32
+	 dsrl	$2,$9,32
+	dsll	$8,32
+	 dsll	$9,32
+	or	$8,$11
+	 or	$9,$2
+#endif
+#endif
+	li	$10,1
+	dsll	$10,32
+	daddiu	$10,-63
+	dsll	$10,28
+	daddiu	$10,-1		# 0ffffffc0fffffff
+
+	and	$8,$10
+	daddiu	$10,-3		# 0ffffffc0ffffffc
+	and	$9,$10
+
+	sd	$8,24($4)
+	dsrl	$10,$9,2
+	sd	$9,32($4)
+	daddu	$10,$9		# s1 = r1 + (r1 >> 2)
+	sd	$10,40($4)
+
+.Lno_key:
+	li	$2,0			# return 0
+	jr	$31
+.end	poly1305_init_mips
+
+.align	5
+.globl	poly1305_blocks_mips
+.ent	poly1305_blocks_mips
+poly1305_blocks_mips:
+	.set	noreorder
+	dsrl	$6,4			# number of complete blocks
+	bnez	$6,poly1305_blocks_internal
+	nop
+	jr	$31
+	nop
+.end	poly1305_blocks_mips
+
+.align	5
+.ent	poly1305_blocks_internal
+poly1305_blocks_internal:
+	.frame	$29,6*8,$31
+	.mask	0x00030000,-8
+	.set	noreorder
+	dsubu	$29,6*8
+	sd	$17,40($29)
+	sd	$16,32($29)
+	.set	reorder
+
+	ld	$12,0($4)		# load hash value
+	ld	$13,8($4)
+	ld	$14,16($4)
+
+	ld	$15,24($4)		# load key
+	ld	$16,32($4)
+	ld	$17,40($4)
+
+.Loop:
+#if defined(CONFIG_CPU_MIPS64_R6) || defined(CONFIG_CPU_MIPSR6)
+	ld	$8,0($5)		# load input
+	ld	$9,8($5)
+#else
+	ldl	$8,0+MSB($5)	# load input
+	ldl	$9,8+MSB($5)
+	ldr	$8,0+LSB($5)
+	ldr	$9,8+LSB($5)
+#endif
+	daddiu	$6,-1
+	daddiu	$5,16
+#ifdef	__MIPSEB__
+#if defined(CONFIG_CPU_MIPS64_R2) || defined(CONFIG_CPU_MIPSR2) || defined(CONFIG_CPU_MIPS64_R6) || defined(CONFIG_CPU_MIPSR6)
+	dsbh	$8,$8		# byte swap
+	 dsbh	$9,$9
+	dshd	$8,$8
+	 dshd	$9,$9
+#else
+	ori	$10,$0,0xFF
+	dsll	$1,$10,32
+	or	$10,$1		# 0x000000FF000000FF
+
+	and	$11,$8,$10	# byte swap
+	 and	$2,$9,$10
+	dsrl	$1,$8,24
+	 dsrl	$24,$9,24
+	dsll	$11,24
+	 dsll	$2,24
+	and	$1,$10
+	 and	$24,$10
+	dsll	$10,8			# 0x0000FF000000FF00
+	or	$11,$1
+	 or	$2,$24
+	and	$1,$8,$10
+	 and	$24,$9,$10
+	dsrl	$8,8
+	 dsrl	$9,8
+	dsll	$1,8
+	 dsll	$24,8
+	and	$8,$10
+	 and	$9,$10
+	or	$11,$1
+	 or	$2,$24
+	or	$8,$11
+	 or	$9,$2
+	dsrl	$11,$8,32
+	 dsrl	$2,$9,32
+	dsll	$8,32
+	 dsll	$9,32
+	or	$8,$11
+	 or	$9,$2
+#endif
+#endif
+	daddu	$12,$8		# accumulate input
+	daddu	$13,$9
+	sltu	$10,$12,$8
+	sltu	$11,$13,$9
+	daddu	$13,$10
+
+	dmultu	($15,$12)		# h0*r0
+	 daddu	$14,$7
+	 sltu	$10,$13,$10
+	mflo	($8,$15,$12)
+	mfhi	($9,$15,$12)
+
+	dmultu	($17,$13)		# h1*5*r1
+	 daddu	$10,$11
+	 daddu	$14,$10
+	mflo	($10,$17,$13)
+	mfhi	($11,$17,$13)
+
+	dmultu	($16,$12)		# h0*r1
+	 daddu	$8,$10
+	 daddu	$9,$11
+	mflo	($1,$16,$12)
+	mfhi	($25,$16,$12)
+	 sltu	$10,$8,$10
+	 daddu	$9,$10
+
+	dmultu	($15,$13)		# h1*r0
+	 daddu	$9,$1
+	 sltu	$1,$9,$1
+	mflo	($10,$15,$13)
+	mfhi	($11,$15,$13)
+	 daddu	$25,$1
+
+	dmultu	($17,$14)		# h2*5*r1
+	 daddu	$9,$10
+	 daddu	$25,$11
+	mflo	($1,$17,$14)
+
+	dmultu	($15,$14)		# h2*r0
+	 sltu	$10,$9,$10
+	 daddu	$25,$10
+	mflo	($2,$15,$14)
+
+	daddu	$9,$1
+	daddu	$25,$2
+	sltu	$1,$9,$1
+	daddu	$25,$1
+
+	li	$10,-4		# final reduction
+	and	$10,$25
+	dsrl	$11,$25,2
+	andi	$14,$25,3
+	daddu	$10,$11
+	daddu	$12,$8,$10
+	sltu	$10,$12,$10
+	daddu	$13,$9,$10
+	sltu	$10,$13,$10
+	daddu	$14,$14,$10
+
+	bnez	$6,.Loop
+
+	sd	$12,0($4)		# store hash value
+	sd	$13,8($4)
+	sd	$14,16($4)
+
+	.set	noreorder
+	ld	$17,40($29)		# epilogue
+	ld	$16,32($29)
+	jr	$31
+	daddu	$29,6*8
+.end	poly1305_blocks_internal
+
+.align	5
+.globl	poly1305_emit_mips
+.ent	poly1305_emit_mips
+poly1305_emit_mips:
+	.frame	$29,0,$31
+	.set	reorder
+
+	ld	$10,0($4)
+	ld	$11,8($4)
+	ld	$1,16($4)
+
+	daddiu	$8,$10,5		# compare to modulus
+	sltiu	$2,$8,5
+	daddu	$9,$11,$2
+	sltu	$2,$9,$2
+	daddu	$1,$1,$2
+
+	dsrl	$1,2			# see if it carried/borrowed
+	dsubu	$1,$0,$1
+	nor	$2,$0,$1
+
+	and	$8,$1
+	and	$10,$2
+	and	$9,$1
+	and	$11,$2
+	or	$8,$10
+	or	$9,$11
+
+	lwu	$10,0($6)		# load nonce
+	lwu	$11,4($6)
+	lwu	$1,8($6)
+	lwu	$2,12($6)
+	dsll	$11,32
+	dsll	$2,32
+	or	$10,$11
+	or	$1,$2
+
+	daddu	$8,$10		# accumulate nonce
+	daddu	$9,$1
+	sltu	$10,$8,$10
+	daddu	$9,$10
+
+	dsrl	$10,$8,8		# write mac value
+	dsrl	$11,$8,16
+	dsrl	$1,$8,24
+	sb	$8,0($5)
+	dsrl	$2,$8,32
+	sb	$10,1($5)
+	dsrl	$10,$8,40
+	sb	$11,2($5)
+	dsrl	$11,$8,48
+	sb	$1,3($5)
+	dsrl	$1,$8,56
+	sb	$2,4($5)
+	dsrl	$2,$9,8
+	sb	$10,5($5)
+	dsrl	$10,$9,16
+	sb	$11,6($5)
+	dsrl	$11,$9,24
+	sb	$1,7($5)
+
+	sb	$9,8($5)
+	dsrl	$1,$9,32
+	sb	$2,9($5)
+	dsrl	$2,$9,40
+	sb	$10,10($5)
+	dsrl	$10,$9,48
+	sb	$11,11($5)
+	dsrl	$11,$9,56
+	sb	$1,12($5)
+	sb	$2,13($5)
+	sb	$10,14($5)
+	sb	$11,15($5)
+
+	jr	$31
+.end	poly1305_emit_mips
-- 
2.18.0
