From: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Subject: [PATCH 2/2] Crypto: Add support for 192 & 256 bit keys to AESNI
 RFC4106 - resend
Date: Fri, 28 Feb 2014 17:00:30 -0600
Message-ID: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA61ADC7@USEA-EXCH7.na.uis.unisys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.bemta7.messagelabs.com ([216.82.254.111]:49434 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723AbaB1XHo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Feb 2014 18:07:44 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

See comments in part 1.

Signed off by: Timothy.McCaffrey@Unisys.com

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 477e9d7..5855172 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -32,12 +32,23 @@
 #include <linux/linkage.h>
 #include <asm/inst.h>

+/*
+* The following macros are used to move an (un)aligned 16 byte value to/from
+* an XMM register.  This can done for either FP or integer values, for FP use
+* movaps (move aligned packed single) or integer use movdqa (move double quad
+* aligned).  It doesn't make a performance difference which instruction is used
+* since Nehalem (original Core i7) was released.  However, the movaps is a byte
+* shorter, so that is the one we'll use for now. (same for unaligned).
+*/
+#define MOVADQ movaps
+#define MOVUDQ movups
+
 #ifdef __x86_64__
+
 .data
 .align 16
 .Lgf128mul_x_ble_mask:
        .octa 0x00000000000000010000000000000087
-
 POLY:   .octa 0xC2000000000000000000000000000001
 TWOONE: .octa 0x00000001000000000000000000000001

@@ -89,6 +100,7 @@ enc:        .octa 0x2
 #define arg8 STACK_OFFSET+16(%r14)
 #define arg9 STACK_OFFSET+24(%r14)
 #define arg10 STACK_OFFSET+32(%r14)
+#define keysize 2*15*16(%arg1)
 #endif


@@ -213,10 +225,12 @@ enc:        .octa 0x2

 .macro INITIAL_BLOCKS_DEC num_initial_blocks TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
 XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
+        MOVADQ     SHUF_MASK(%rip), %xmm14
        mov        arg7, %r10           # %r10 = AAD
        mov        arg8, %r12           # %r12 = aadLen
        mov        %r12, %r11
        pxor       %xmm\i, %xmm\i
+
 _get_AAD_loop\num_initial_blocks\operation:
        movd       (%r10), \TMP1
        pslldq     $12, \TMP1
@@ -225,16 +239,18 @@ _get_AAD_loop\num_initial_blocks\operation:
        add        $4, %r10
        sub        $4, %r12
        jne        _get_AAD_loop\num_initial_blocks\operation
+
        cmp        $16, %r11
        je         _get_AAD_loop2_done\num_initial_blocks\operation
+
        mov        $16, %r12
 _get_AAD_loop2\num_initial_blocks\operation:
        psrldq     $4, %xmm\i
        sub        $4, %r12
        cmp        %r11, %r12
        jne        _get_AAD_loop2\num_initial_blocks\operation
+
 _get_AAD_loop2_done\num_initial_blocks\operation:
-        movdqa     SHUF_MASK(%rip), %xmm14
        PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data

        xor        %r11, %r11 # initialise the data pointer offset as zero
@@ -243,59 +259,34 @@ _get_AAD_loop2_done\num_initial_blocks\operation:

        mov        %arg5, %rax                      # %rax = *Y0
        movdqu     (%rax), \XMM0                    # XMM0 = Y0
-        movdqa     SHUF_MASK(%rip), %xmm14
        PSHUFB_XMM   %xmm14, \XMM0

 .if (\i == 5) || (\i == 6) || (\i == 7)
+       MOVADQ          ONE(%RIP),\TMP1
+       MOVADQ          (%arg1),\TMP2
 .irpc index, \i_seq
-       paddd      ONE(%rip), \XMM0                 # INCR Y0
+       paddd      \TMP1, \XMM0                 # INCR Y0
        movdqa     \XMM0, %xmm\index
-        movdqa     SHUF_MASK(%rip), %xmm14
        PSHUFB_XMM   %xmm14, %xmm\index      # perform a 16 byte swap
-
-.endr
-.irpc index, \i_seq
-       pxor       16*0(%arg1), %xmm\index
-.endr
-.irpc index, \i_seq
-       movaps 0x10(%rdi), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 1
-.endr
-.irpc index, \i_seq
-       movaps 0x20(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
+       pxor       \TMP2, %xmm\index
 .endr
-.irpc index, \i_seq
-       movaps 0x30(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x40(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x50(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x60(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x70(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x80(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x90(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
+       lea     0x10(%arg1),%r10
+       mov     keysize,%eax
+       shr     $2,%eax                         # 128->4, 192->6, 256->8
+       add     $5,%eax                       # 128->9, 192->11, 256->13
+
+aes_loop_initial_dec\num_initial_blocks:
+       MOVADQ  (%r10),\TMP1
+.irpc  index, \i_seq
+       AESENC  \TMP1, %xmm\index
 .endr
+       add     $16,%r10
+       sub     $1,%eax
+       jnz     aes_loop_initial_dec\num_initial_blocks
+
+       MOVADQ  (%r10), \TMP1
 .irpc index, \i_seq
-       movaps 0xa0(%arg1), \TMP1
-       AESENCLAST \TMP1, %xmm\index         # Round 10
+       AESENCLAST \TMP1, %xmm\index         # Last Round
 .endr
 .irpc index, \i_seq
        movdqu     (%arg3 , %r11, 1), \TMP1
@@ -305,10 +296,8 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
        add        $16, %r11

        movdqa     \TMP1, %xmm\index
-        movdqa     SHUF_MASK(%rip), %xmm14
-       PSHUFB_XMM         %xmm14, %xmm\index
-
-               # prepare plaintext/ciphertext for GHASH computation
+       PSHUFB_XMM         %xmm14, %xmm\index
+                # prepare plaintext/ciphertext for GHASH computation
 .endr
 .endif
        GHASH_MUL  %xmm\i, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
@@ -338,30 +327,28 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
 * Precomputations for HashKey parallel with encryption of first 4 blocks.
 * Haskey_i_k holds XORed values of the low and high parts of the Haskey_i
 */
-       paddd      ONE(%rip), \XMM0              # INCR Y0
-       movdqa     \XMM0, \XMM1
-        movdqa     SHUF_MASK(%rip), %xmm14
-       PSHUFB_XMM  %xmm14, \XMM1        # perform a 16 byte swap
+       MOVADQ     ONE(%rip), \TMP1
+       paddd      \TMP1, \XMM0              # INCR Y0
+       MOVADQ     \XMM0, \XMM1
+       PSHUFB_XMM  %xmm14, \XMM1        # perform a 16 byte swap

-       paddd      ONE(%rip), \XMM0              # INCR Y0
-       movdqa     \XMM0, \XMM2
-        movdqa     SHUF_MASK(%rip), %xmm14
+       paddd      \TMP1, \XMM0              # INCR Y0
+       MOVADQ     \XMM0, \XMM2
        PSHUFB_XMM  %xmm14, \XMM2        # perform a 16 byte swap

-       paddd      ONE(%rip), \XMM0              # INCR Y0
-       movdqa     \XMM0, \XMM3
-        movdqa     SHUF_MASK(%rip), %xmm14
+       paddd      \TMP1, \XMM0              # INCR Y0
+       MOVADQ     \XMM0, \XMM3
        PSHUFB_XMM %xmm14, \XMM3        # perform a 16 byte swap

-       paddd      ONE(%rip), \XMM0              # INCR Y0
-       movdqa     \XMM0, \XMM4
-        movdqa     SHUF_MASK(%rip), %xmm14
+       paddd      \TMP1, \XMM0              # INCR Y0
+       MOVADQ     \XMM0, \XMM4
        PSHUFB_XMM %xmm14, \XMM4        # perform a 16 byte swap

-       pxor       16*0(%arg1), \XMM1
-       pxor       16*0(%arg1), \XMM2
-       pxor       16*0(%arg1), \XMM3
-       pxor       16*0(%arg1), \XMM4
+       MOVADQ     0(%arg1),\TMP1
+       pxor       \TMP1, \XMM1
+       pxor       \TMP1, \XMM2
+       pxor       \TMP1, \XMM3
+       pxor       \TMP1, \XMM4
        movdqa     \TMP3, \TMP5
        pshufd     $78, \TMP3, \TMP1
        pxor       \TMP3, \TMP1
@@ -399,7 +386,23 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
        pshufd     $78, \TMP5, \TMP1
        pxor       \TMP5, \TMP1
        movdqa     \TMP1, HashKey_4_k(%rsp)
-       movaps 0xa0(%arg1), \TMP2
+       lea        0xa0(%arg1),%r10
+       mov        keysize,%eax
+       shr        $2,%eax                      # 128->4, 192->6, 256->8
+       sub        $4,%eax                      # 128->0, 192->2, 256->4
+       jz         aes_loop_pre_dec_done\num_initial_blocks
+
+aes_loop_pre_dec\num_initial_blocks:
+       MOVADQ     (%r10),\TMP2
+.irpc  index, 1234
+       AESENC     \TMP2, %xmm\index
+.endr
+       add        $16,%r10
+       sub        $1,%eax
+       jnz        aes_loop_pre_dec\num_initial_blocks
+
+aes_loop_pre_dec_done\num_initial_blocks:
+       MOVADQ     (%r10), \TMP2
        AESENCLAST \TMP2, \XMM1
        AESENCLAST \TMP2, \XMM2
        AESENCLAST \TMP2, \XMM3
@@ -421,15 +424,11 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
        movdqu     \XMM4, 16*3(%arg2 , %r11 , 1)
        movdqa     \TMP1, \XMM4
        add        $64, %r11
-        movdqa     SHUF_MASK(%rip), %xmm14
-       PSHUFB_XMM %xmm14, \XMM1 # perform a 16 byte swap
-       pxor       \XMMDst, \XMM1
+       PSHUFB_XMM %xmm14, \XMM1 # perform a 16 byte swap
+       pxor       \XMMDst, \XMM1
 # combine GHASHed value with the corresponding ciphertext
-        movdqa     SHUF_MASK(%rip), %xmm14
        PSHUFB_XMM %xmm14, \XMM2 # perform a 16 byte swap
-        movdqa     SHUF_MASK(%rip), %xmm14
        PSHUFB_XMM %xmm14, \XMM3 # perform a 16 byte swap
-        movdqa     SHUF_MASK(%rip), %xmm14
        PSHUFB_XMM %xmm14, \XMM4 # perform a 16 byte swap

 _initial_blocks_done\num_initial_blocks\operation:
@@ -451,6 +450,7 @@ _initial_blocks_done\num_initial_blocks\operation:

 .macro INITIAL_BLOCKS_ENC num_initial_blocks TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
 XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
+        MOVADQ     SHUF_MASK(%rip), %xmm14
        mov        arg7, %r10           # %r10 = AAD
        mov        arg8, %r12           # %r12 = aadLen
        mov        %r12, %r11
@@ -472,7 +472,6 @@ _get_AAD_loop2\num_initial_blocks\operation:
        cmp        %r11, %r12
        jne        _get_AAD_loop2\num_initial_blocks\operation
 _get_AAD_loop2_done\num_initial_blocks\operation:
-        movdqa     SHUF_MASK(%rip), %xmm14
        PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data

        xor        %r11, %r11 # initialise the data pointer offset as zero
@@ -481,59 +480,35 @@ _get_AAD_loop2_done\num_initial_blocks\operation:

        mov        %arg5, %rax                      # %rax = *Y0
        movdqu     (%rax), \XMM0                    # XMM0 = Y0
-        movdqa     SHUF_MASK(%rip), %xmm14
        PSHUFB_XMM   %xmm14, \XMM0

 .if (\i == 5) || (\i == 6) || (\i == 7)
-.irpc index, \i_seq
-       paddd      ONE(%rip), \XMM0                 # INCR Y0
-       movdqa     \XMM0, %xmm\index
-        movdqa     SHUF_MASK(%rip), %xmm14
-       PSHUFB_XMM   %xmm14, %xmm\index      # perform a 16 byte swap

-.endr
+       MOVADQ          ONE(%RIP),\TMP1
+       MOVADQ          0(%arg1),\TMP2
 .irpc index, \i_seq
-       pxor       16*0(%arg1), %xmm\index
+       paddd           \TMP1, \XMM0                 # INCR Y0
+       MOVADQ          \XMM0, %xmm\index
+       PSHUFB_XMM      %xmm14, %xmm\index      # perform a 16 byte swap
+       pxor            \TMP2, %xmm\index
 .endr
-.irpc index, \i_seq
-       movaps 0x10(%rdi), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 1
-.endr
-.irpc index, \i_seq
-       movaps 0x20(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x30(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x40(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x50(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x60(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x70(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x80(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
-.endr
-.irpc index, \i_seq
-       movaps 0x90(%arg1), \TMP1
-       AESENC     \TMP1, %xmm\index          # Round 2
+       lea     0x10(%arg1),%r10
+       mov     keysize,%eax
+       shr     $2,%eax                         # 128->4, 192->6, 256->8
+       add     $5,%eax                       # 128->9, 192->11, 256->13
+
+aes_loop_initial_enc\num_initial_blocks:
+       MOVADQ  (%r10),\TMP1
+.irpc  index, \i_seq
+       AESENC  \TMP1, %xmm\index
 .endr
+       add     $16,%r10
+       sub     $1,%eax
+       jnz     aes_loop_initial_enc\num_initial_blocks
+
+       MOVADQ  (%r10), \TMP1
 .irpc index, \i_seq
-       movaps 0xa0(%arg1), \TMP1
-       AESENCLAST \TMP1, %xmm\index         # Round 10
+       AESENCLAST \TMP1, %xmm\index         # Last Round
 .endr
 .irpc index, \i_seq
        movdqu     (%arg3 , %r11, 1), \TMP1
@@ -541,8 +516,6 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
        movdqu     %xmm\index, (%arg2 , %r11, 1)
        # write back plaintext/ciphertext for num_initial_blocks
        add        $16, %r11
-
-        movdqa     SHUF_MASK(%rip), %xmm14
        PSHUFB_XMM         %xmm14, %xmm\index

                # prepare plaintext/ciphertext for GHASH computation
@@ -575,30 +548,28 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
 * Precomputations for HashKey parallel with encryption of first 4 blocks.
 * Haskey_i_k holds XORed values of the low and high parts of the Haskey_i
 */
-       paddd      ONE(%rip), \XMM0              # INCR Y0
-       movdqa     \XMM0, \XMM1
-        movdqa     SHUF_MASK(%rip), %xmm14
+       MOVADQ     ONE(%RIP),\TMP1
+       paddd      \TMP1, \XMM0              # INCR Y0
+       MOVADQ     \XMM0, \XMM1
        PSHUFB_XMM  %xmm14, \XMM1        # perform a 16 byte swap

-       paddd      ONE(%rip), \XMM0              # INCR Y0
-       movdqa     \XMM0, \XMM2
-        movdqa     SHUF_MASK(%rip), %xmm14
+       paddd      \TMP1, \XMM0              # INCR Y0
+       MOVADQ     \XMM0, \XMM2
        PSHUFB_XMM  %xmm14, \XMM2        # perform a 16 byte swap

-       paddd      ONE(%rip), \XMM0              # INCR Y0
-       movdqa     \XMM0, \XMM3
-        movdqa     SHUF_MASK(%rip), %xmm14
-       PSHUFB_XMM %xmm14, \XMM3        # perform a 16 byte swap
+       paddd      \TMP1, \XMM0              # INCR Y0
+       MOVADQ     \XMM0, \XMM3
+       PSHUFB_XMM %xmm14, \XMM3        # perform a 16 byte swap

-       paddd      ONE(%rip), \XMM0              # INCR Y0
-       movdqa     \XMM0, \XMM4
-        movdqa     SHUF_MASK(%rip), %xmm14
+       paddd      \TMP1, \XMM0              # INCR Y0
+       MOVADQ     \XMM0, \XMM4
        PSHUFB_XMM %xmm14, \XMM4        # perform a 16 byte swap

-       pxor       16*0(%arg1), \XMM1
-       pxor       16*0(%arg1), \XMM2
-       pxor       16*0(%arg1), \XMM3
-       pxor       16*0(%arg1), \XMM4
+       MOVADQ     0(%arg1),\TMP1
+       pxor       \TMP1, \XMM1
+       pxor       \TMP1, \XMM2
+       pxor       \TMP1, \XMM3
+       pxor       \TMP1, \XMM4
        movdqa     \TMP3, \TMP5
        pshufd     $78, \TMP3, \TMP1
        pxor       \TMP3, \TMP1
@@ -636,7 +607,23 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
        pshufd     $78, \TMP5, \TMP1
        pxor       \TMP5, \TMP1
        movdqa     \TMP1, HashKey_4_k(%rsp)
-       movaps 0xa0(%arg1), \TMP2
+       lea        0xa0(%arg1),%r10
+       mov        keysize,%eax
+       shr        $2,%eax                      # 128->4, 192->6, 256->8
+       sub        $4,%eax                      # 128->0, 192->2, 256->4
+       jz         aes_loop_pre_enc_done\num_initial_blocks
+
+aes_loop_pre_enc\num_initial_blocks:
+       MOVADQ     (%r10),\TMP2
+.irpc  index, 1234
+       AESENC     \TMP2, %xmm\index
+.endr
+       add        $16,%r10
+       sub        $1,%eax
+       jnz        aes_loop_pre_enc\num_initial_blocks
+
+aes_loop_pre_enc_done\num_initial_blocks:
+       MOVADQ     (%r10), \TMP2
        AESENCLAST \TMP2, \XMM1
        AESENCLAST \TMP2, \XMM2
        AESENCLAST \TMP2, \XMM3
@@ -655,15 +642,11 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
        movdqu     \XMM4, 16*3(%arg2 , %r11 , 1)

        add        $64, %r11
-        movdqa     SHUF_MASK(%rip), %xmm14
-       PSHUFB_XMM %xmm14, \XMM1 # perform a 16 byte swap
+       PSHUFB_XMM %xmm14, \XMM1 # perform a 16 byte swap
        pxor       \XMMDst, \XMM1
 # combine GHASHed value with the corresponding ciphertext
-        movdqa     SHUF_MASK(%rip), %xmm14
        PSHUFB_XMM %xmm14, \XMM2 # perform a 16 byte swap
-        movdqa     SHUF_MASK(%rip), %xmm14
-       PSHUFB_XMM %xmm14, \XMM3 # perform a 16 byte swap
-        movdqa     SHUF_MASK(%rip), %xmm14
+       PSHUFB_XMM %xmm14, \XMM3 # perform a 16 byte swap
        PSHUFB_XMM %xmm14, \XMM4 # perform a 16 byte swap

 _initial_blocks_done\num_initial_blocks\operation:
@@ -794,7 +777,23 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
        AESENC    \TMP3, \XMM3
        AESENC    \TMP3, \XMM4
        PCLMULQDQ 0x00, \TMP5, \XMM8          # XMM8 = a0*b0
-       movaps 0xa0(%arg1), \TMP3
+       lea       0xa0(%arg1),%r10
+       mov       keysize,%eax
+       shr       $2,%eax                       # 128->4, 192->6, 256->8
+       sub       $4,%eax                       # 128->0, 192->2, 256->4
+       jz        aes_loop_par_enc_done
+
+aes_loop_par_enc:
+       MOVADQ    (%r10),\TMP3
+.irpc  index, 1234
+       AESENC    \TMP3, %xmm\index
+.endr
+       add       $16,%r10
+       sub       $1,%eax
+       jnz       aes_loop_par_enc
+
+aes_loop_par_enc_done:
+       MOVADQ    (%r10), \TMP3
        AESENCLAST \TMP3, \XMM1           # Round 10
        AESENCLAST \TMP3, \XMM2
        AESENCLAST \TMP3, \XMM3
@@ -986,8 +985,24 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
        AESENC    \TMP3, \XMM3
        AESENC    \TMP3, \XMM4
        PCLMULQDQ 0x00, \TMP5, \XMM8          # XMM8 = a0*b0
-       movaps 0xa0(%arg1), \TMP3
-       AESENCLAST \TMP3, \XMM1           # Round 10
+       lea       0xa0(%arg1),%r10
+       mov       keysize,%eax
+       shr       $2,%eax                       # 128->4, 192->6, 256->8
+       sub       $4,%eax                       # 128->0, 192->2, 256->4
+       jz        aes_loop_par_dec_done
+
+aes_loop_par_dec:
+       MOVADQ    (%r10),\TMP3
+.irpc  index, 1234
+       AESENC    \TMP3, %xmm\index
+.endr
+       add       $16,%r10
+       sub       $1,%eax
+       jnz       aes_loop_par_dec
+
+aes_loop_par_dec_done:
+       MOVADQ    (%r10), \TMP3
+       AESENCLAST \TMP3, \XMM1           # last round
        AESENCLAST \TMP3, \XMM2
        AESENCLAST \TMP3, \XMM3
        AESENCLAST \TMP3, \XMM4
@@ -1155,33 +1170,29 @@ TMP7 XMM1 XMM2 XMM3 XMM4 XMMDst
        pxor      \TMP6, \XMMDst            # reduced result is in XMMDst
 .endm

-/* Encryption of a single block done*/
-.macro ENCRYPT_SINGLE_BLOCK XMM0 TMP1
-
-       pxor    (%arg1), \XMM0
-        movaps 16(%arg1), \TMP1
-       AESENC  \TMP1, \XMM0
-        movaps 32(%arg1), \TMP1
-       AESENC  \TMP1, \XMM0
-        movaps 48(%arg1), \TMP1
-       AESENC  \TMP1, \XMM0
-        movaps 64(%arg1), \TMP1
-       AESENC  \TMP1, \XMM0
-        movaps 80(%arg1), \TMP1
-       AESENC  \TMP1, \XMM0
-        movaps 96(%arg1), \TMP1
-       AESENC  \TMP1, \XMM0
-        movaps 112(%arg1), \TMP1
-       AESENC  \TMP1, \XMM0
-        movaps 128(%arg1), \TMP1
-       AESENC  \TMP1, \XMM0
-        movaps 144(%arg1), \TMP1
-       AESENC  \TMP1, \XMM0
-        movaps 160(%arg1), \TMP1
-       AESENCLAST      \TMP1, \XMM0
-.endm

+/* Encryption of a single block
+* uses eax & r10
+*/
+
+.macro ENCRYPT_SINGLE_BLOCK XMM0 TMP1
+
+       pxor            (%arg1), \XMM0
+       mov             keysize,%eax
+       shr             $2,%eax                 # 128->4, 192->6, 256->8
+       add             $5,%eax                 # 128->9, 192->11, 256->13
+       lea             16(%arg1), %r10   # get first expanded key address

+_esb_loop_\@:
+       MOVADQ          (%r10),\TMP1
+       AESENC          \TMP1,\XMM0
+       add             $16,%r10
+       sub             $1,%eax
+       jnz             _esb_loop_\@
+
+       MOVADQ          (%r10),\TMP1
+       AESENCLAST      \TMP1,\XMM0
+.endm
 /*****************************************************************************
 * void aesni_gcm_dec(void *aes_ctx,    // AES Key schedule. Starts on a 16 byte boundary.
 *                   u8 *out,           // Plaintext output. Encrypt in-place is allowed.
