From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] x86/crypto: make constants readonly, allow linker to merge them
Date: Thu, 19 Jan 2017 22:33:04 +0100
Message-ID: <20170119213304.18140-1-dvlasenk@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Xiaodong Liu <xiaodong.liu@intel.com>,
        Megha Dey <megha.dey@intel.com>, linux-crypto@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751630AbdASVdI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2017 16:33:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A lot of asm-optimized routines in arch/x86/crypto/ keep its
constants in .data. This is wrong, they should be on .rodata.

Mnay of these constants are the same in different modules.
For example, 128-bit shuffle mask 0x000102030405060708090A0B0C0D0E0F
exists in at least half a dozen places.

There is a way to let linker merge them and use just one copy.
The rules are as follows: mergeable objects of different sizes
should not share sections. You can't put them all in one .rodata
section, they will lose "mergeability".

GCC puts its mergeable constants in ".rodata.cstSIZE" sections,
or ".rodata.cstSIZE.<object_name>" if -fdata-sections is used.
This patch does the same:

	.section .rodata.cst16.SHUF_MASK, "aM", @progbits, 16

It is important that all data in such section consists of
16-byte elements, not larger ones, and there are no implicit
use of one element from another.

When this is not the case, use non-mergeable section:

	.section .rodata[.VAR_NAME], "a", @progbits

This reduces .data by ~15 kbytes:

    text    data     bss     dec      hex filename
11097415 2705840 2630712 16433967  fac32f vmlinux-prev.o
11112095 2690672 2630712 16433479  fac147 vmlinux.o

Merged objects are visible in System.map:

ffffffff81a28810 r POLY
ffffffff81a28810 r POLY
ffffffff81a28820 r TWOONE
ffffffff81a28820 r TWOONE
ffffffff81a28830 r PSHUFFLE_BYTE_FLIP_MASK <- merged regardless of
ffffffff81a28830 r SHUF_MASK   <------------- the name difference
ffffffff81a28830 r SHUF_MASK
ffffffff81a28830 r SHUF_MASK
..
ffffffff81a28d00 r K512 <- merged three identical 640-byte tables
ffffffff81a28d00 r K512
ffffffff81a28d00 r K512

Use of object names in section name suffixes is not strictly necessary,
but might help if someday link stage will use garbage collection
to eliminate unused sections (ld --gc-sections).

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Josh Poimboeuf <jpoimboe@redhat.com>
CC: Xiaodong Liu <xiaodong.liu@intel.com>
CC: Megha Dey <megha.dey@intel.com>
CC: linux-crypto@vger.kernel.org
CC: x86@kernel.org
CC: linux-kernel@vger.kernel.org
---
 arch/x86/crypto/aesni-intel_asm.S                  | 37 +++++++++++++++++-----
 arch/x86/crypto/aesni-intel_avx-x86_64.S           | 32 ++++++++++++++-----
 arch/x86/crypto/camellia-aesni-avx-asm_64.S        |  5 ++-
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S       | 12 +++++--
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S          | 14 ++++++--
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S          | 12 +++++--
 arch/x86/crypto/chacha20-avx2-x86_64.S             |  9 ++++--
 arch/x86/crypto/chacha20-ssse3-x86_64.S            |  7 ++--
 arch/x86/crypto/crct10dif-pcl-asm_64.S             | 14 ++++++--
 arch/x86/crypto/des3_ede-asm_64.S                  |  2 +-
 arch/x86/crypto/ghash-clmulni-intel_asm.S          |  3 +-
 arch/x86/crypto/poly1305-avx2-x86_64.S             |  6 ++--
 arch/x86/crypto/poly1305-sse2-x86_64.S             |  6 ++--
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S        |  5 +--
 arch/x86/crypto/serpent-avx2-asm_64.S              |  9 ++++--
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S   |  6 ++--
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S  |  3 +-
 arch/x86/crypto/sha1-mb/sha1_x8_avx2.S             | 15 +++++++--
 arch/x86/crypto/sha1_ni_asm.S                      |  8 +++--
 arch/x86/crypto/sha256-avx-asm.S                   |  9 +++++-
 arch/x86/crypto/sha256-avx2-asm.S                  |  9 +++++-
 .../crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S    |  6 ++--
 .../crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S   |  3 +-
 arch/x86/crypto/sha256-mb/sha256_x8_avx2.S         |  7 +++-
 arch/x86/crypto/sha256-ssse3-asm.S                 |  8 ++++-
 arch/x86/crypto/sha256_ni_asm.S                    |  4 ++-
 arch/x86/crypto/sha512-avx-asm.S                   |  9 ++++--
 arch/x86/crypto/sha512-avx2-asm.S                  | 10 ++++--
 .../crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S    | 10 ++++--
 .../crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S   |  4 ++-
 arch/x86/crypto/sha512-mb/sha512_x4_avx2.S         |  4 ++-
 arch/x86/crypto/sha512-ssse3-asm.S                 |  9 ++++--
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        |  6 ++--
 33 files changed, 229 insertions(+), 74 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 383a6f8..3c46518 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -46,28 +46,49 @@
 
 #ifdef __x86_64__
 
-.data
+# constants in mergeable sections, linker can reorder and merge
+.section	.rodata.cst16.gf128mul_x_ble_mask, "aM", @progbits, 16
 .align 16
 .Lgf128mul_x_ble_mask:
 	.octa 0x00000000000000010000000000000087
+.section	.rodata.cst16.POLY, "aM", @progbits, 16
+.align 16
 POLY:   .octa 0xC2000000000000000000000000000001
+.section	.rodata.cst16.TWOONE, "aM", @progbits, 16
+.align 16
 TWOONE: .octa 0x00000001000000000000000000000001
 
-# order of these constants should not change.
-# more specifically, ALL_F should follow SHIFT_MASK,
-# and ZERO should follow ALL_F
-
+.section	.rodata.cst16.SHUF_MASK, "aM", @progbits, 16
+.align 16
 SHUF_MASK:  .octa 0x000102030405060708090A0B0C0D0E0F
+.section	.rodata.cst16.MASK1, "aM", @progbits, 16
+.align 16
 MASK1:      .octa 0x0000000000000000ffffffffffffffff
+.section	.rodata.cst16.MASK2, "aM", @progbits, 16
+.align 16
 MASK2:      .octa 0xffffffffffffffff0000000000000000
-SHIFT_MASK: .octa 0x0f0e0d0c0b0a09080706050403020100
-ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
-ZERO:       .octa 0x00000000000000000000000000000000
+.section	.rodata.cst16.ONE, "aM", @progbits, 16
+.align 16
 ONE:        .octa 0x00000000000000000000000000000001
+.section	.rodata.cst16.F_MIN_MASK, "aM", @progbits, 16
+.align 16
 F_MIN_MASK: .octa 0xf1f2f3f4f5f6f7f8f9fafbfcfdfeff0
+.section	.rodata.cst16.dec, "aM", @progbits, 16
+.align 16
 dec:        .octa 0x1
+.section	.rodata.cst16.enc, "aM", @progbits, 16
+.align 16
 enc:        .octa 0x2
 
+# order of these constants should not change.
+# more specifically, ALL_F should follow SHIFT_MASK,
+# and zero should follow ALL_F
+.section	.rodata, "a", @progbits
+.align 16
+SHIFT_MASK: .octa 0x0f0e0d0c0b0a09080706050403020100
+ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
+            .octa 0x00000000000000000000000000000000
+
 
 .text
 
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 522ab68..d664382 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -122,23 +122,39 @@
 #include <linux/linkage.h>
 #include <asm/inst.h>
 
-.data
+# constants in mergeable sections, linker can reorder and merge
+.section	.rodata.cst16.POLY, "aM", @progbits, 16
 .align 16
-
 POLY:            .octa     0xC2000000000000000000000000000001
+
+.section	.rodata.cst16.POLY2, "aM", @progbits, 16
+.align 16
 POLY2:           .octa     0xC20000000000000000000001C2000000
-TWOONE:          .octa     0x00000001000000000000000000000001
 
-# order of these constants should not change.
-# more specifically, ALL_F should follow SHIFT_MASK, and ZERO should follow ALL_F
+.section	.rodata.cst16.TWOONE, "aM", @progbits, 16
+.align 16
+TWOONE:          .octa     0x00000001000000000000000000000001
 
+.section	.rodata.cst16.SHUF_MASK, "aM", @progbits, 16
+.align 16
 SHUF_MASK:       .octa     0x000102030405060708090A0B0C0D0E0F
-SHIFT_MASK:      .octa     0x0f0e0d0c0b0a09080706050403020100
-ALL_F:           .octa     0xffffffffffffffffffffffffffffffff
-ZERO:            .octa     0x00000000000000000000000000000000
+
+.section	.rodata.cst16.ONE, "aM", @progbits, 16
+.align 16
 ONE:             .octa     0x00000000000000000000000000000001
+
+.section	.rodata.cst16.ONEf, "aM", @progbits, 16
+.align 16
 ONEf:            .octa     0x01000000000000000000000000000000
 
+# order of these constants should not change.
+# more specifically, ALL_F should follow SHIFT_MASK, and zero should follow ALL_F
+.section	.rodata, "a", @progbits
+.align 16
+SHIFT_MASK:      .octa     0x0f0e0d0c0b0a09080706050403020100
+ALL_F:           .octa     0xffffffffffffffffffffffffffffffff
+                 .octa     0x00000000000000000000000000000000
+
 .text
 
 
diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
index aa9e8bd..f7c495e 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -571,7 +571,9 @@ ENDPROC(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	vmovdqu y6, 14 * 16(rio); \
 	vmovdqu y7, 15 * 16(rio);
 
-.data
+
+/* NB: section is mergeable, all elements must be aligned 16-byte blocks */
+.section	.rodata.cst16, "aM", @progbits, 16
 .align 16
 
 #define SHUFB_BYTES(idx) \
@@ -711,6 +713,7 @@ ENDPROC(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	.byte 0x08, 0x05, 0x02, 0x0f, 0x0c, 0x09, 0x06, 0x03
 
 /* 4-bit mask */
+.section	.rodata.cst4.L0f0f0f0f, "aM", @progbits, 4
 .align 4
 .L0f0f0f0f:
 	.long 0x0f0f0f0f
diff --git a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
index 16186c1..eee5b39 100644
--- a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
@@ -610,20 +610,25 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	vmovdqu y6, 14 * 32(rio); \
 	vmovdqu y7, 15 * 32(rio);
 
-.data
-.align 32
 
+.section	.rodata.cst32.shufb_16x16b, "aM", @progbits, 32
+.align 32
 #define SHUFB_BYTES(idx) \
 	0 + (idx), 4 + (idx), 8 + (idx), 12 + (idx)
-
 .Lshufb_16x16b:
 	.byte SHUFB_BYTES(0), SHUFB_BYTES(1), SHUFB_BYTES(2), SHUFB_BYTES(3)
 	.byte SHUFB_BYTES(0), SHUFB_BYTES(1), SHUFB_BYTES(2), SHUFB_BYTES(3)
 
+.section	.rodata.cst32.pack_bswap, "aM", @progbits, 32
+.align 32
 .Lpack_bswap:
 	.long 0x00010203, 0x04050607, 0x80808080, 0x80808080
 	.long 0x00010203, 0x04050607, 0x80808080, 0x80808080
 
+/* NB: section is mergeable, all elements must be aligned 16-byte blocks */
+.section	.rodata.cst16, "aM", @progbits, 16
+.align 16
+
 /* For CTR-mode IV byteswap */
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
@@ -750,6 +755,7 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	.byte 0x00, 0x0d, 0x0a, 0x07, 0x04, 0x01, 0x0e, 0x0b
 	.byte 0x08, 0x05, 0x02, 0x0f, 0x0c, 0x09, 0x06, 0x03
 
+.section	.rodata.cst4.L0f0f0f0f, "aM", @progbits, 4
 .align 4
 /* 4-bit mask */
 .L0f0f0f0f:
diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index 14fa196..b4a8806 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -195,19 +195,29 @@
 	vpshufb rmask,	x0, x0;           \
 	vpshufb rmask,	x1, x1;
 
-.data
-
+.section	.rodata.cst16.bswap_mask, "aM", @progbits, 16
 .align 16
 .Lbswap_mask:
 	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+.section	.rodata.cst16.bswap128_mask, "aM", @progbits, 16
+.align 16
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+.section	.rodata.cst16.bswap_iv_mask, "aM", @progbits, 16
+.align 16
 .Lbswap_iv_mask:
 	.byte 7, 6, 5, 4, 3, 2, 1, 0, 7, 6, 5, 4, 3, 2, 1, 0
+
+.section	.rodata.cst4.16_mask, "aM", @progbits, 4
+.align 4
 .L16_mask:
 	.byte 16, 16, 16, 16
+.section	.rodata.cst4.32_mask, "aM", @progbits, 4
+.align 4
 .L32_mask:
 	.byte 32, 0, 0, 0
+.section	.rodata.cst4.first_mask, "aM", @progbits, 4
+.align 4
 .Lfirst_mask:
 	.byte 0x1f, 0, 0, 0
 
diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index c419389..952d315 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -225,8 +225,7 @@
 	vpshufb rmask,		x2, x2;       \
 	vpshufb rmask,		x3, x3;
 
-.data
-
+.section	.rodata.cst16, "aM", @progbits, 16
 .align 16
 .Lxts_gf128mul_and_shl1_mask:
 	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
@@ -244,10 +243,19 @@
 	.byte 12, 13, 14, 15, 8, 9, 10, 11, 7, 6, 5, 4, 3, 2, 1, 0
 .Lrkr_dec_QBAR_QBAR_QBAR_QBAR:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+
+.section	.rodata.cst4.L16_mask, "aM", @progbits, 4
+.align 4
 .L16_mask:
 	.byte 16, 16, 16, 16
+
+.section	.rodata.cst4.L32_mask, "aM", @progbits, 4
+.align 4
 .L32_mask:
 	.byte 32, 0, 0, 0
+
+.section	.rodata.cst4.first_mask, "aM", @progbits, 4
+.align 4
 .Lfirst_mask:
 	.byte 0x1f, 0, 0, 0
 
diff --git a/arch/x86/crypto/chacha20-avx2-x86_64.S b/arch/x86/crypto/chacha20-avx2-x86_64.S
index 16694e6..3a2dc3d 100644
--- a/arch/x86/crypto/chacha20-avx2-x86_64.S
+++ b/arch/x86/crypto/chacha20-avx2-x86_64.S
@@ -11,13 +11,18 @@
 
 #include <linux/linkage.h>
 
-.data
+.section	.rodata.cst32.ROT8, "aM", @progbits, 32
 .align 32
-
 ROT8:	.octa 0x0e0d0c0f0a09080b0605040702010003
 	.octa 0x0e0d0c0f0a09080b0605040702010003
+
+.section	.rodata.cst32.ROT16, "aM", @progbits, 32
+.align 32
 ROT16:	.octa 0x0d0c0f0e09080b0a0504070601000302
 	.octa 0x0d0c0f0e09080b0a0504070601000302
+
+.section	.rodata.cst32.CTRINC, "aM", @progbits, 32
+.align 32
 CTRINC:	.octa 0x00000003000000020000000100000000
 	.octa 0x00000007000000060000000500000004
 
diff --git a/arch/x86/crypto/chacha20-ssse3-x86_64.S b/arch/x86/crypto/chacha20-ssse3-x86_64.S
index 3a33124..3f511a7 100644
--- a/arch/x86/crypto/chacha20-ssse3-x86_64.S
+++ b/arch/x86/crypto/chacha20-ssse3-x86_64.S
@@ -11,11 +11,14 @@
 
 #include <linux/linkage.h>
 
-.data
+.section	.rodata.cst16.ROT8, "aM", @progbits, 16
 .align 16
-
 ROT8:	.octa 0x0e0d0c0f0a09080b0605040702010003
+.section	.rodata.cst16.ROT16, "aM", @progbits, 16
+.align 16
 ROT16:	.octa 0x0d0c0f0e09080b0a0504070601000302
+.section	.rodata.cst16.CTRINC, "aM", @progbits, 16
+.align 16
 CTRINC:	.octa 0x00000003000000020000000100000000
 
 .text
diff --git a/arch/x86/crypto/crct10dif-pcl-asm_64.S b/arch/x86/crypto/crct10dif-pcl-asm_64.S
index 35e9756..de04d3e 100644
--- a/arch/x86/crypto/crct10dif-pcl-asm_64.S
+++ b/arch/x86/crypto/crct10dif-pcl-asm_64.S
@@ -554,12 +554,11 @@ _only_less_than_2:
 
 ENDPROC(crc_t10dif_pcl)
 
-.data
-
+.section	.rodata, "a", @progbits
+.align 16
 # precomputed constants
 # these constants are precomputed from the poly:
 # 0x8bb70000 (0x8bb7 scaled to 32 bits)
-.align 16
 # Q = 0x18BB70000
 # rk1 = 2^(32*3) mod Q << 32
 # rk2 = 2^(32*5) mod Q << 32
@@ -613,14 +612,23 @@ rk20:
 
 
 
+.section	.rodata.cst16.mask1, "aM", @progbits, 16
+.align 16
 mask1:
 .octa 0x80808080808080808080808080808080
+
+.section	.rodata.cst16.mask2, "aM", @progbits, 16
+.align 16
 mask2:
 .octa 0x00000000FFFFFFFFFFFFFFFFFFFFFFFF
 
+.section	.rodata.cst16.SHUF_MASK, "aM", @progbits, 16
+.align 16
 SHUF_MASK:
 .octa 0x000102030405060708090A0B0C0D0E0F
 
+.section	.rodata.cst32.pshufb_shf_table, "aM", @progbits, 32
+.align 32
 pshufb_shf_table:
 # use these values for shift constants for the pshufb instruction
 # different alignments result in values as shown:
diff --git a/arch/x86/crypto/des3_ede-asm_64.S b/arch/x86/crypto/des3_ede-asm_64.S
index 038f6ae..f3e9164 100644
--- a/arch/x86/crypto/des3_ede-asm_64.S
+++ b/arch/x86/crypto/des3_ede-asm_64.S
@@ -537,7 +537,7 @@ ENTRY(des3_ede_x86_64_crypt_blk_3way)
 	ret;
 ENDPROC(des3_ede_x86_64_crypt_blk_3way)
 
-.data
+.section	.rodata, "a", @progbits
 .align 16
 .L_s1:
 	.quad 0x0010100001010400, 0x0000000000000000
diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index eed55c8..f94375a 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -20,8 +20,7 @@
 #include <asm/inst.h>
 #include <asm/frame.h>
 
-.data
-
+.section	.rodata.cst16.bswap_mask, "aM", @progbits, 16
 .align 16
 .Lbswap_mask:
 	.octa 0x000102030405060708090a0b0c0d0e0f
diff --git a/arch/x86/crypto/poly1305-avx2-x86_64.S b/arch/x86/crypto/poly1305-avx2-x86_64.S
index eff2f41..3b6e70d 100644
--- a/arch/x86/crypto/poly1305-avx2-x86_64.S
+++ b/arch/x86/crypto/poly1305-avx2-x86_64.S
@@ -11,11 +11,13 @@
 
 #include <linux/linkage.h>
 
-.data
+.section	.rodata.cst32.ANMASK, "aM", @progbits, 32
 .align 32
-
 ANMASK:	.octa 0x0000000003ffffff0000000003ffffff
 	.octa 0x0000000003ffffff0000000003ffffff
+
+.section	.rodata.cst32.ORMASK, "aM", @progbits, 32
+.align 32
 ORMASK:	.octa 0x00000000010000000000000001000000
 	.octa 0x00000000010000000000000001000000
 
diff --git a/arch/x86/crypto/poly1305-sse2-x86_64.S b/arch/x86/crypto/poly1305-sse2-x86_64.S
index 338c748..c88c670 100644
--- a/arch/x86/crypto/poly1305-sse2-x86_64.S
+++ b/arch/x86/crypto/poly1305-sse2-x86_64.S
@@ -11,10 +11,12 @@
 
 #include <linux/linkage.h>
 
-.data
+.section	.rodata.cst16.ANMASK, "aM", @progbits, 16
 .align 16
-
 ANMASK:	.octa 0x0000000003ffffff0000000003ffffff
+
+.section	.rodata.cst16.ORMASK, "aM", @progbits, 16
+.align 16
 ORMASK:	.octa 0x00000000010000000000000001000000
 
 .text
diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
index 8be5718..2925077 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -29,11 +29,12 @@
 
 .file "serpent-avx-x86_64-asm_64.S"
 
-.data
+.section	.rodata.cst16.bswap128_mask, "aM", @progbits, 16
 .align 16
-
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+.section	.rodata.cst16.xts_gf128mul_and_shl1_mask, "aM", @progbits, 16
+.align 16
 .Lxts_gf128mul_and_shl1_mask:
 	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
 
diff --git a/arch/x86/crypto/serpent-avx2-asm_64.S b/arch/x86/crypto/serpent-avx2-asm_64.S
index 97c48ad..d67888f 100644
--- a/arch/x86/crypto/serpent-avx2-asm_64.S
+++ b/arch/x86/crypto/serpent-avx2-asm_64.S
@@ -20,13 +20,18 @@
 
 .file "serpent-avx2-asm_64.S"
 
-.data
+.section	.rodata.cst16.bswap128_mask, "aM", @progbits, 16
 .align 16
-
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+
+.section	.rodata.cst16.xts_gf128mul_and_shl1_mask_0, "aM", @progbits, 16
+.align 16
 .Lxts_gf128mul_and_shl1_mask_0:
 	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
+
+.section	.rodata.cst16.xts_gf128mul_and_shl1_mask_1, "aM", @progbits, 16
+.align 16
 .Lxts_gf128mul_and_shl1_mask_1:
 	.byte 0x0e, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0
 
diff --git a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
index 96df6a3..93b9455 100644
--- a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
@@ -281,11 +281,13 @@ ENTRY(sha1_mb_mgr_get_comp_job_avx2)
 	ret
 ENDPROC(sha1_mb_mgr_get_comp_job_avx2)
 
-.data
-
+.section	.rodata.cst16.clear_low_nibble, "aM", @progbits, 16
 .align 16
 clear_low_nibble:
 .octa	0x000000000000000000000000FFFFFFF0
+
+.section	.rodata.cst8, "aM", @progbits, 8
+.align 8
 one:
 .quad  1
 two:
diff --git a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
index 63a0d9c..7a93b1c 100644
--- a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
@@ -203,8 +203,7 @@ return_null:
 
 ENDPROC(sha1_mb_mgr_submit_avx2)
 
-.data
-
+.section	.rodata.cst16.clear_low_nibble, "aM", @progbits, 16
 .align 16
 clear_low_nibble:
 	.octa	0x000000000000000000000000FFFFFFF0
diff --git a/arch/x86/crypto/sha1-mb/sha1_x8_avx2.S b/arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
index c9dae1c..20f77aa 100644
--- a/arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
+++ b/arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
@@ -461,21 +461,32 @@ lloop:
 ENDPROC(sha1_x8_avx2)
 
 
-.data
-
+.section	.rodata.cst32.K00_19, "aM", @progbits, 32
 .align 32
 K00_19:
 .octa 0x5A8279995A8279995A8279995A827999
 .octa 0x5A8279995A8279995A8279995A827999
+
+.section	.rodata.cst32.K20_39, "aM", @progbits, 32
+.align 32
 K20_39:
 .octa 0x6ED9EBA16ED9EBA16ED9EBA16ED9EBA1
 .octa 0x6ED9EBA16ED9EBA16ED9EBA16ED9EBA1
+
+.section	.rodata.cst32.K40_59, "aM", @progbits, 32
+.align 32
 K40_59:
 .octa 0x8F1BBCDC8F1BBCDC8F1BBCDC8F1BBCDC
 .octa 0x8F1BBCDC8F1BBCDC8F1BBCDC8F1BBCDC
+
+.section	.rodata.cst32.K60_79, "aM", @progbits, 32
+.align 32
 K60_79:
 .octa 0xCA62C1D6CA62C1D6CA62C1D6CA62C1D6
 .octa 0xCA62C1D6CA62C1D6CA62C1D6CA62C1D6
+
+.section	.rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 32
+.align 32
 PSHUFFLE_BYTE_FLIP_MASK:
 .octa 0x0c0d0e0f08090a0b0405060700010203
 .octa 0x0c0d0e0f08090a0b0405060700010203
diff --git a/arch/x86/crypto/sha1_ni_asm.S b/arch/x86/crypto/sha1_ni_asm.S
index 874a651..ebbdba7 100644
--- a/arch/x86/crypto/sha1_ni_asm.S
+++ b/arch/x86/crypto/sha1_ni_asm.S
@@ -293,10 +293,12 @@ ENTRY(sha1_ni_transform)
 	ret
 ENDPROC(sha1_ni_transform)
 
-.data
-
-.align 64
+.section	.rodata.cst16.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 16
+.align 16
 PSHUFFLE_BYTE_FLIP_MASK:
 	.octa 0x000102030405060708090a0b0c0d0e0f
+
+.section	.rodata.cst16.UPPER_WORD_MASK, "aM", @progbits, 16
+.align 16
 UPPER_WORD_MASK:
 	.octa 0xFFFFFFFF000000000000000000000000
diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
index 92b3b5d..e08888a 100644
--- a/arch/x86/crypto/sha256-avx-asm.S
+++ b/arch/x86/crypto/sha256-avx-asm.S
@@ -463,7 +463,7 @@ done_hash:
 	ret
 ENDPROC(sha256_transform_avx)
 
-.data
+.section	.rodata.cst256.K256, "aM", @progbits, 256
 .align 64
 K256:
 	.long 0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
@@ -483,14 +483,21 @@ K256:
 	.long 0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
 	.long 0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
 
+.section	.rodata.cst16.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 16
+.align 16
 PSHUFFLE_BYTE_FLIP_MASK:
 	.octa 0x0c0d0e0f08090a0b0405060700010203
 
+.section	.rodata.cst16._SHUF_00BA, "aM", @progbits, 16
+.align 16
 # shuffle xBxA -> 00BA
 _SHUF_00BA:
 	.octa 0xFFFFFFFFFFFFFFFF0b0a090803020100
 
+.section	.rodata.cst16._SHUF_DC00, "aM", @progbits, 16
+.align 16
 # shuffle xDxC -> DC00
 _SHUF_DC00:
 	.octa 0x0b0a090803020100FFFFFFFFFFFFFFFF
+
 #endif
diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 570ec5e..89c8f09 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -723,7 +723,7 @@ done_hash:
 	ret
 ENDPROC(sha256_transform_rorx)
 
-.data
+.section	.rodata.cst512.K256, "aM", @progbits, 512
 .align 64
 K256:
 	.long	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
@@ -759,14 +759,21 @@ K256:
 	.long	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
 	.long	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
 
+.section	.rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 32
+.align 32
 PSHUFFLE_BYTE_FLIP_MASK:
 	.octa 0x0c0d0e0f08090a0b0405060700010203,0x0c0d0e0f08090a0b0405060700010203
 
 # shuffle xBxA -> 00BA
+.section	.rodata.cst32._SHUF_00BA, "aM", @progbits, 32
+.align 32
 _SHUF_00BA:
 	.octa 0xFFFFFFFFFFFFFFFF0b0a090803020100,0xFFFFFFFFFFFFFFFF0b0a090803020100
 
 # shuffle xDxC -> DC00
+.section	.rodata.cst32._SHUF_DC00, "aM", @progbits, 32
+.align 32
 _SHUF_DC00:
 	.octa 0x0b0a090803020100FFFFFFFFFFFFFFFF,0x0b0a090803020100FFFFFFFFFFFFFFFF
+
 #endif
diff --git a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
index a78a069..8fe6338 100644
--- a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
+++ b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
@@ -284,11 +284,13 @@ ENTRY(sha256_mb_mgr_get_comp_job_avx2)
 	ret
 ENDPROC(sha256_mb_mgr_get_comp_job_avx2)
 
-.data
-
+.section	.rodata.cst16.clear_low_nibble, "aM", @progbits, 16
 .align 16
 clear_low_nibble:
 .octa	0x000000000000000000000000FFFFFFF0
+
+.section	.rodata.cst8, "aM", @progbits, 8
+.align 8
 one:
 .quad	1
 two:
diff --git a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S
index 7ea670e..b36ae74 100644
--- a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S
+++ b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S
@@ -208,8 +208,7 @@ return_null:
 
 ENDPROC(sha256_mb_mgr_submit_avx2)
 
-.data
-
+.section	.rodata.cst16.clear_low_nibble, "aM", @progbits, 16
 .align 16
 clear_low_nibble:
 	.octa	0x000000000000000000000000FFFFFFF0
diff --git a/arch/x86/crypto/sha256-mb/sha256_x8_avx2.S b/arch/x86/crypto/sha256-mb/sha256_x8_avx2.S
index aa21aea..1687c80 100644
--- a/arch/x86/crypto/sha256-mb/sha256_x8_avx2.S
+++ b/arch/x86/crypto/sha256-mb/sha256_x8_avx2.S
@@ -437,7 +437,8 @@ Lrounds_16_xx:
 
 	ret
 ENDPROC(sha256_x8_avx2)
-.data
+
+.section	.rodata.K256_8, "a", @progbits
 .align 64
 K256_8:
 	.octa	0x428a2f98428a2f98428a2f98428a2f98
@@ -568,10 +569,14 @@ K256_8:
 	.octa	0xbef9a3f7bef9a3f7bef9a3f7bef9a3f7
 	.octa	0xc67178f2c67178f2c67178f2c67178f2
 	.octa	0xc67178f2c67178f2c67178f2c67178f2
+
+.section	.rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 32
+.align 32
 PSHUFFLE_BYTE_FLIP_MASK:
 .octa 0x0c0d0e0f08090a0b0405060700010203
 .octa 0x0c0d0e0f08090a0b0405060700010203
 
+.section	.rodata.cst256.K256, "aM", @progbits, 256
 .align 64
 .global K256
 K256:
diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index 2cedc44..39b83c9 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -474,7 +474,7 @@ done_hash:
 	ret
 ENDPROC(sha256_transform_ssse3)
 
-.data
+.section	.rodata.cst256.K256, "aM", @progbits, 256
 .align 64
 K256:
         .long 0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
@@ -494,13 +494,19 @@ K256:
         .long 0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
         .long 0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
 
+.section	.rodata.cst16.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 16
+.align 16
 PSHUFFLE_BYTE_FLIP_MASK:
 	.octa 0x0c0d0e0f08090a0b0405060700010203
 
+.section	.rodata.cst16._SHUF_00BA, "aM", @progbits, 16
+.align 16
 # shuffle xBxA -> 00BA
 _SHUF_00BA:
 	.octa 0xFFFFFFFFFFFFFFFF0b0a090803020100
 
+.section	.rodata.cst16._SHUF_DC00, "aM", @progbits, 16
+.align 16
 # shuffle xDxC -> DC00
 _SHUF_DC00:
 	.octa 0x0b0a090803020100FFFFFFFFFFFFFFFF
diff --git a/arch/x86/crypto/sha256_ni_asm.S b/arch/x86/crypto/sha256_ni_asm.S
index 748cdf2..fb58f58 100644
--- a/arch/x86/crypto/sha256_ni_asm.S
+++ b/arch/x86/crypto/sha256_ni_asm.S
@@ -329,7 +329,7 @@ ENTRY(sha256_ni_transform)
 	ret
 ENDPROC(sha256_ni_transform)
 
-.data
+.section	.rodata.cst256.K256, "aM", @progbits, 256
 .align 64
 K256:
 	.long	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
@@ -349,5 +349,7 @@ K256:
 	.long	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
 	.long	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
 
+.section	.rodata.cst16.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 16
+.align 16
 PSHUFFLE_BYTE_FLIP_MASK:
 	.octa 0x0c0d0e0f08090a0b0405060700010203
diff --git a/arch/x86/crypto/sha512-avx-asm.S b/arch/x86/crypto/sha512-avx-asm.S
index 565274d..39235fe 100644
--- a/arch/x86/crypto/sha512-avx-asm.S
+++ b/arch/x86/crypto/sha512-avx-asm.S
@@ -370,14 +370,17 @@ ENDPROC(sha512_transform_avx)
 ########################################################################
 ### Binary Data
 
-.data
-
+.section	.rodata.cst16.XMM_QWORD_BSWAP, "aM", @progbits, 16
 .align 16
-
 # Mask for byte-swapping a couple of qwords in an XMM register using (v)pshufb.
 XMM_QWORD_BSWAP:
 	.octa 0x08090a0b0c0d0e0f0001020304050607
 
+# Mergeable 640-byte rodata section. This allows linker to merge the table
+# with other, exactly the same 640-byte fragment of another rodata section
+# (if such section exists).
+.section	.rodata.cst640.K512, "aM", @progbits, 640
+.align 64
 # K[t] used in SHA512 hashing
 K512:
 	.quad 0x428a2f98d728ae22,0x7137449123ef65cd
diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index 1f20b35..7f5f6c6 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -684,8 +684,11 @@ ENDPROC(sha512_transform_rorx)
 ########################################################################
 ### Binary Data
 
-.data
 
+# Mergeable 640-byte rodata section. This allows linker to merge the table
+# with other, exactly the same 640-byte fragment of another rodata section
+# (if such section exists).
+.section	.rodata.cst640.K512, "aM", @progbits, 640
 .align 64
 # K[t] used in SHA512 hashing
 K512:
@@ -730,14 +733,17 @@ K512:
 	.quad	0x4cc5d4becb3e42b6,0x597f299cfc657e2a
 	.quad	0x5fcb6fab3ad6faec,0x6c44198c4a475817
 
+.section	.rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 32
 .align 32
-
 # Mask for byte-swapping a couple of qwords in an XMM register using (v)pshufb.
 PSHUFFLE_BYTE_FLIP_MASK:
 	.octa 0x08090a0b0c0d0e0f0001020304050607
 	.octa 0x18191a1b1c1d1e1f1011121314151617
 
+.section	.rodata.cst32.MASK_YMM_LO, "aM", @progbits, 32
+.align 32
 MASK_YMM_LO:
 	.octa 0x00000000000000000000000000000000
 	.octa 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
+
 #endif
diff --git a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S
index 3ddba19..7c629ca 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S
@@ -280,12 +280,18 @@ ENTRY(sha512_mb_mgr_get_comp_job_avx2)
 	pop     %rbx
         ret
 ENDPROC(sha512_mb_mgr_get_comp_job_avx2)
-.data
 
-.align 16
+.section	.rodata.cst8.one, "aM", @progbits, 8
+.align 8
 one:
 .quad  1
+
+.section	.rodata.cst8.two, "aM", @progbits, 8
+.align 8
 two:
 .quad  2
+
+.section	.rodata.cst8.three, "aM", @progbits, 8
+.align 8
 three:
 .quad  3
diff --git a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S
index 815f07b..4ba709b 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S
@@ -209,8 +209,9 @@ return_null:
 	xor     job_rax, job_rax
 	jmp     return
 ENDPROC(sha512_mb_mgr_submit_avx2)
-.data
 
+/* UNUSED?
+.section	.rodata.cst16, "aM", @progbits, 16
 .align 16
 H0:     .int  0x6a09e667
 H1:     .int  0xbb67ae85
@@ -220,3 +221,4 @@ H4:     .int  0x510e527f
 H5:     .int  0x9b05688c
 H6:     .int  0x1f83d9ab
 H7:     .int  0x5be0cd19
+*/
diff --git a/arch/x86/crypto/sha512-mb/sha512_x4_avx2.S b/arch/x86/crypto/sha512-mb/sha512_x4_avx2.S
index 31ab1ef..e22e907 100644
--- a/arch/x86/crypto/sha512-mb/sha512_x4_avx2.S
+++ b/arch/x86/crypto/sha512-mb/sha512_x4_avx2.S
@@ -361,7 +361,7 @@ Lrounds_16_xx:
 	ret
 ENDPROC(sha512_x4_avx2)
 
-.data
+.section	.rodata.K512_4, "a", @progbits
 .align 64
 K512_4:
 	.octa 0x428a2f98d728ae22428a2f98d728ae22,\
@@ -525,5 +525,7 @@ K512_4:
 	.octa 0x6c44198c4a4758176c44198c4a475817,\
 		0x6c44198c4a4758176c44198c4a475817
 
+.section	.rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 32
+.align 32
 PSHUFFLE_BYTE_FLIP_MASK: .octa 0x08090a0b0c0d0e0f0001020304050607
                          .octa 0x18191a1b1c1d1e1f1011121314151617
diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index e610e29..66bbd90 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -369,14 +369,17 @@ ENDPROC(sha512_transform_ssse3)
 ########################################################################
 ### Binary Data
 
-.data
-
+.section	.rodata.cst16.XMM_QWORD_BSWAP, "aM", @progbits, 16
 .align 16
-
 # Mask for byte-swapping a couple of qwords in an XMM register using (v)pshufb.
 XMM_QWORD_BSWAP:
 	.octa 0x08090a0b0c0d0e0f0001020304050607
 
+# Mergeable 640-byte rodata section. This allows linker to merge the table
+# with other, exactly the same 640-byte fragment of another rodata section
+# (if such section exists).
+.section	.rodata.cst640.K512, "aM", @progbits, 640
+.align 64
 # K[t] used in SHA512 hashing
 K512:
 	.quad 0x428a2f98d728ae22,0x7137449123ef65cd
diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index dc66273..b3f49d2 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -29,11 +29,13 @@
 
 .file "twofish-avx-x86_64-asm_64.S"
 
-.data
+.section	.rodata.cst16.bswap128_mask, "aM", @progbits, 16
 .align 16
-
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+
+.section	.rodata.cst16.xts_gf128mul_and_shl1_mask, "aM", @progbits, 16
+.align 16
 .Lxts_gf128mul_and_shl1_mask:
 	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
 
-- 
2.9.2
