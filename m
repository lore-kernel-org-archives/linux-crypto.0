From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUG] 3.11 boot failure caused by commit crypto
Date: Wed, 24 Jul 2013 17:06:21 +1000
Message-ID: <20130724070621.GA30415@gondor.apana.org.au>
References: <51EF3BCC.30102@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, tim.c.chen@linux.intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33182 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752153Ab3GXHGp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jul 2013 03:06:45 -0400
Content-Disposition: inline
In-Reply-To: <51EF3BCC.30102@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 24, 2013 at 10:28:28AM +0800, Zhao Hongjiang wrote:
> When i boot my system with the latest 3.11-rc2 kernel, something occur as follow:
> 
> Waiting for device /dev/disk/by-id/... to appear: ............ Could not find //dev/disk/by-id/...
> Want me to fall back to /dev/disk/by-id/..... ?
> 
> I found out the patch commit id: 2d31e518a42828df7877bca23a958627d60408bc (crypto: crct10dif - 
> Wrap crc_t10dif function all to use crypto transform framework) cause this problem by bisect.
> 
> I revert this patch and this problem go away, the boot become successful.

OK, I will revert this until we have a proper solution in place
that does not break boot on systems like yours.

commit e70308ec0e4bff344fcfdf160de40e1150552c5f
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Jul 24 17:04:16 2013 +1000

    Revert "crypto: crct10dif - Wrap crc_t10dif function all to use crypto transform framework"
    
    This reverts commits
        67822649d7305caf3dd50ed46c27b99c94eff996
        39761214eefc6b070f29402aa1165f24d789b3f7
        0b95a7f85718adcbba36407ef88bba0a7379ed03
        31d939625a9a20b1badd2d4e6bf6fd39fa523405
        2d31e518a42828df7877bca23a958627d60408bc
    
    Unfortunately this change broke boot on some systems that used an
    initrd which does not include the newly created crct10dif modules.
    As these modules are required by sd_mod under certain configurations
    this is a serious problem.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 7d6ba9d..6c63c35 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -27,7 +27,6 @@ obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 obj-$(CONFIG_CRYPTO_CRC32_PCLMUL) += crc32-pclmul.o
 obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
 obj-$(CONFIG_CRYPTO_SHA512_SSSE3) += sha512-ssse3.o
-obj-$(CONFIG_CRYPTO_CRCT10DIF_PCLMUL) += crct10dif-pclmul.o
 
 # These modules require assembler to support AVX.
 ifeq ($(avx_supported),yes)
@@ -82,4 +81,3 @@ crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
 crc32-pclmul-y := crc32-pclmul_asm.o crc32-pclmul_glue.o
 sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ssse3_glue.o
 sha512-ssse3-y := sha512-ssse3-asm.o sha512-avx-asm.o sha512-avx2-asm.o sha512_ssse3_glue.o
-crct10dif-pclmul-y := crct10dif-pcl-asm_64.o crct10dif-pclmul_glue.o
diff --git a/arch/x86/crypto/crct10dif-pcl-asm_64.S b/arch/x86/crypto/crct10dif-pcl-asm_64.S
deleted file mode 100644
index 35e9756..0000000
--- a/arch/x86/crypto/crct10dif-pcl-asm_64.S
+++ /dev/null
@@ -1,643 +0,0 @@
-########################################################################
-# Implement fast CRC-T10DIF computation with SSE and PCLMULQDQ instructions
-#
-# Copyright (c) 2013, Intel Corporation
-#
-# Authors:
-#     Erdinc Ozturk <erdinc.ozturk@intel.com>
-#     Vinodh Gopal <vinodh.gopal@intel.com>
-#     James Guilford <james.guilford@intel.com>
-#     Tim Chen <tim.c.chen@linux.intel.com>
-#
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-# Redistribution and use in source and binary forms, with or without
-# modification, are permitted provided that the following conditions are
-# met:
-#
-# * Redistributions of source code must retain the above copyright
-#   notice, this list of conditions and the following disclaimer.
-#
-# * Redistributions in binary form must reproduce the above copyright
-#   notice, this list of conditions and the following disclaimer in the
-#   documentation and/or other materials provided with the
-#   distribution.
-#
-# * Neither the name of the Intel Corporation nor the names of its
-#   contributors may be used to endorse or promote products derived from
-#   this software without specific prior written permission.
-#
-#
-# THIS SOFTWARE IS PROVIDED BY INTEL CORPORATION ""AS IS"" AND ANY
-# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL CORPORATION OR
-# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-########################################################################
-#       Function API:
-#       UINT16 crc_t10dif_pcl(
-#               UINT16 init_crc, //initial CRC value, 16 bits
-#               const unsigned char *buf, //buffer pointer to calculate CRC on
-#               UINT64 len //buffer length in bytes (64-bit data)
-#       );
-#
-#       Reference paper titled "Fast CRC Computation for Generic
-#	Polynomials Using PCLMULQDQ Instruction"
-#       URL: http://www.intel.com/content/dam/www/public/us/en/documents
-#  /white-papers/fast-crc-computation-generic-polynomials-pclmulqdq-paper.pdf
-#
-#
-
-#include <linux/linkage.h>
-
-.text
-
-#define        arg1 %rdi
-#define        arg2 %rsi
-#define        arg3 %rdx
-
-#define        arg1_low32 %edi
-
-ENTRY(crc_t10dif_pcl)
-.align 16
-
-	# adjust the 16-bit initial_crc value, scale it to 32 bits
-	shl	$16, arg1_low32
-
-	# Allocate Stack Space
-	mov     %rsp, %rcx
-	sub	$16*2, %rsp
-	# align stack to 16 byte boundary
-	and     $~(0x10 - 1), %rsp
-
-	# check if smaller than 256
-	cmp	$256, arg3
-
-	# for sizes less than 128, we can't fold 64B at a time...
-	jl	_less_than_128
-
-
-	# load the initial crc value
-	movd	arg1_low32, %xmm10	# initial crc
-
-	# crc value does not need to be byte-reflected, but it needs
-	# to be moved to the high part of the register.
-	# because data will be byte-reflected and will align with
-	# initial crc at correct place.
-	pslldq	$12, %xmm10
-
-	movdqa  SHUF_MASK(%rip), %xmm11
-	# receive the initial 64B data, xor the initial crc value
-	movdqu	16*0(arg2), %xmm0
-	movdqu	16*1(arg2), %xmm1
-	movdqu	16*2(arg2), %xmm2
-	movdqu	16*3(arg2), %xmm3
-	movdqu	16*4(arg2), %xmm4
-	movdqu	16*5(arg2), %xmm5
-	movdqu	16*6(arg2), %xmm6
-	movdqu	16*7(arg2), %xmm7
-
-	pshufb	%xmm11, %xmm0
-	# XOR the initial_crc value
-	pxor	%xmm10, %xmm0
-	pshufb	%xmm11, %xmm1
-	pshufb	%xmm11, %xmm2
-	pshufb	%xmm11, %xmm3
-	pshufb	%xmm11, %xmm4
-	pshufb	%xmm11, %xmm5
-	pshufb	%xmm11, %xmm6
-	pshufb	%xmm11, %xmm7
-
-	movdqa	rk3(%rip), %xmm10	#xmm10 has rk3 and rk4
-					#imm value of pclmulqdq instruction
-					#will determine which constant to use
-
-	#################################################################
-	# we subtract 256 instead of 128 to save one instruction from the loop
-	sub	$256, arg3
-
-	# at this section of the code, there is 64*x+y (0<=y<64) bytes of
-	# buffer. The _fold_64_B_loop will fold 64B at a time
-	# until we have 64+y Bytes of buffer
-
-
-	# fold 64B at a time. This section of the code folds 4 xmm
-	# registers in parallel
-_fold_64_B_loop:
-
-	# update the buffer pointer
-	add	$128, arg2		#    buf += 64#
-
-	movdqu	16*0(arg2), %xmm9
-	movdqu	16*1(arg2), %xmm12
-	pshufb	%xmm11, %xmm9
-	pshufb	%xmm11, %xmm12
-	movdqa	%xmm0, %xmm8
-	movdqa	%xmm1, %xmm13
-	pclmulqdq	$0x0 , %xmm10, %xmm0
-	pclmulqdq	$0x11, %xmm10, %xmm8
-	pclmulqdq	$0x0 , %xmm10, %xmm1
-	pclmulqdq	$0x11, %xmm10, %xmm13
-	pxor	%xmm9 , %xmm0
-	xorps	%xmm8 , %xmm0
-	pxor	%xmm12, %xmm1
-	xorps	%xmm13, %xmm1
-
-	movdqu	16*2(arg2), %xmm9
-	movdqu	16*3(arg2), %xmm12
-	pshufb	%xmm11, %xmm9
-	pshufb	%xmm11, %xmm12
-	movdqa	%xmm2, %xmm8
-	movdqa	%xmm3, %xmm13
-	pclmulqdq	$0x0, %xmm10, %xmm2
-	pclmulqdq	$0x11, %xmm10, %xmm8
-	pclmulqdq	$0x0, %xmm10, %xmm3
-	pclmulqdq	$0x11, %xmm10, %xmm13
-	pxor	%xmm9 , %xmm2
-	xorps	%xmm8 , %xmm2
-	pxor	%xmm12, %xmm3
-	xorps	%xmm13, %xmm3
-
-	movdqu	16*4(arg2), %xmm9
-	movdqu	16*5(arg2), %xmm12
-	pshufb	%xmm11, %xmm9
-	pshufb	%xmm11, %xmm12
-	movdqa	%xmm4, %xmm8
-	movdqa	%xmm5, %xmm13
-	pclmulqdq	$0x0,  %xmm10, %xmm4
-	pclmulqdq	$0x11, %xmm10, %xmm8
-	pclmulqdq	$0x0,  %xmm10, %xmm5
-	pclmulqdq	$0x11, %xmm10, %xmm13
-	pxor	%xmm9 ,  %xmm4
-	xorps	%xmm8 ,  %xmm4
-	pxor	%xmm12,  %xmm5
-	xorps	%xmm13,  %xmm5
-
-	movdqu	16*6(arg2), %xmm9
-	movdqu	16*7(arg2), %xmm12
-	pshufb	%xmm11, %xmm9
-	pshufb	%xmm11, %xmm12
-	movdqa	%xmm6 , %xmm8
-	movdqa	%xmm7 , %xmm13
-	pclmulqdq	$0x0 , %xmm10, %xmm6
-	pclmulqdq	$0x11, %xmm10, %xmm8
-	pclmulqdq	$0x0 , %xmm10, %xmm7
-	pclmulqdq	$0x11, %xmm10, %xmm13
-	pxor	%xmm9 , %xmm6
-	xorps	%xmm8 , %xmm6
-	pxor	%xmm12, %xmm7
-	xorps	%xmm13, %xmm7
-
-	sub	$128, arg3
-
-	# check if there is another 64B in the buffer to be able to fold
-	jge	_fold_64_B_loop
-	##################################################################
-
-
-	add	$128, arg2
-	# at this point, the buffer pointer is pointing at the last y Bytes
-	# of the buffer the 64B of folded data is in 4 of the xmm
-	# registers: xmm0, xmm1, xmm2, xmm3
-
-
-	# fold the 8 xmm registers to 1 xmm register with different constants
-
-	movdqa	rk9(%rip), %xmm10
-	movdqa	%xmm0, %xmm8
-	pclmulqdq	$0x11, %xmm10, %xmm0
-	pclmulqdq	$0x0 , %xmm10, %xmm8
-	pxor	%xmm8, %xmm7
-	xorps	%xmm0, %xmm7
-
-	movdqa	rk11(%rip), %xmm10
-	movdqa	%xmm1, %xmm8
-	pclmulqdq	 $0x11, %xmm10, %xmm1
-	pclmulqdq	 $0x0 , %xmm10, %xmm8
-	pxor	%xmm8, %xmm7
-	xorps	%xmm1, %xmm7
-
-	movdqa	rk13(%rip), %xmm10
-	movdqa	%xmm2, %xmm8
-	pclmulqdq	 $0x11, %xmm10, %xmm2
-	pclmulqdq	 $0x0 , %xmm10, %xmm8
-	pxor	%xmm8, %xmm7
-	pxor	%xmm2, %xmm7
-
-	movdqa	rk15(%rip), %xmm10
-	movdqa	%xmm3, %xmm8
-	pclmulqdq	$0x11, %xmm10, %xmm3
-	pclmulqdq	$0x0 , %xmm10, %xmm8
-	pxor	%xmm8, %xmm7
-	xorps	%xmm3, %xmm7
-
-	movdqa	rk17(%rip), %xmm10
-	movdqa	%xmm4, %xmm8
-	pclmulqdq	$0x11, %xmm10, %xmm4
-	pclmulqdq	$0x0 , %xmm10, %xmm8
-	pxor	%xmm8, %xmm7
-	pxor	%xmm4, %xmm7
-
-	movdqa	rk19(%rip), %xmm10
-	movdqa	%xmm5, %xmm8
-	pclmulqdq	$0x11, %xmm10, %xmm5
-	pclmulqdq	$0x0 , %xmm10, %xmm8
-	pxor	%xmm8, %xmm7
-	xorps	%xmm5, %xmm7
-
-	movdqa	rk1(%rip), %xmm10	#xmm10 has rk1 and rk2
-					#imm value of pclmulqdq instruction
-					#will determine which constant to use
-	movdqa	%xmm6, %xmm8
-	pclmulqdq	$0x11, %xmm10, %xmm6
-	pclmulqdq	$0x0 , %xmm10, %xmm8
-	pxor	%xmm8, %xmm7
-	pxor	%xmm6, %xmm7
-
-
-	# instead of 64, we add 48 to the loop counter to save 1 instruction
-	# from the loop instead of a cmp instruction, we use the negative
-	# flag with the jl instruction
-	add	$128-16, arg3
-	jl	_final_reduction_for_128
-
-	# now we have 16+y bytes left to reduce. 16 Bytes is in register xmm7
-	# and the rest is in memory. We can fold 16 bytes at a time if y>=16
-	# continue folding 16B at a time
-
-_16B_reduction_loop:
-	movdqa	%xmm7, %xmm8
-	pclmulqdq	$0x11, %xmm10, %xmm7
-	pclmulqdq	$0x0 , %xmm10, %xmm8
-	pxor	%xmm8, %xmm7
-	movdqu	(arg2), %xmm0
-	pshufb	%xmm11, %xmm0
-	pxor	%xmm0 , %xmm7
-	add	$16, arg2
-	sub	$16, arg3
-	# instead of a cmp instruction, we utilize the flags with the
-	# jge instruction equivalent of: cmp arg3, 16-16
-	# check if there is any more 16B in the buffer to be able to fold
-	jge	_16B_reduction_loop
-
-	#now we have 16+z bytes left to reduce, where 0<= z < 16.
-	#first, we reduce the data in the xmm7 register
-
-
-_final_reduction_for_128:
-	# check if any more data to fold. If not, compute the CRC of
-	# the final 128 bits
-	add	$16, arg3
-	je	_128_done
-
-	# here we are getting data that is less than 16 bytes.
-	# since we know that there was data before the pointer, we can
-	# offset the input pointer before the actual point, to receive
-	# exactly 16 bytes. after that the registers need to be adjusted.
-_get_last_two_xmms:
-	movdqa	%xmm7, %xmm2
-
-	movdqu	-16(arg2, arg3), %xmm1
-	pshufb	%xmm11, %xmm1
-
-	# get rid of the extra data that was loaded before
-	# load the shift constant
-	lea	pshufb_shf_table+16(%rip), %rax
-	sub	arg3, %rax
-	movdqu	(%rax), %xmm0
-
-	# shift xmm2 to the left by arg3 bytes
-	pshufb	%xmm0, %xmm2
-
-	# shift xmm7 to the right by 16-arg3 bytes
-	pxor	mask1(%rip), %xmm0
-	pshufb	%xmm0, %xmm7
-	pblendvb	%xmm2, %xmm1	#xmm0 is implicit
-
-	# fold 16 Bytes
-	movdqa	%xmm1, %xmm2
-	movdqa	%xmm7, %xmm8
-	pclmulqdq	$0x11, %xmm10, %xmm7
-	pclmulqdq	$0x0 , %xmm10, %xmm8
-	pxor	%xmm8, %xmm7
-	pxor	%xmm2, %xmm7
-
-_128_done:
-	# compute crc of a 128-bit value
-	movdqa	rk5(%rip), %xmm10	# rk5 and rk6 in xmm10
-	movdqa	%xmm7, %xmm0
-
-	#64b fold
-	pclmulqdq	$0x1, %xmm10, %xmm7
-	pslldq	$8   ,  %xmm0
-	pxor	%xmm0,  %xmm7
-
-	#32b fold
-	movdqa	%xmm7, %xmm0
-
-	pand	mask2(%rip), %xmm0
-
-	psrldq	$12, %xmm7
-	pclmulqdq	$0x10, %xmm10, %xmm7
-	pxor	%xmm0, %xmm7
-
-	#barrett reduction
-_barrett:
-	movdqa	rk7(%rip), %xmm10	# rk7 and rk8 in xmm10
-	movdqa	%xmm7, %xmm0
-	pclmulqdq	$0x01, %xmm10, %xmm7
-	pslldq	$4, %xmm7
-	pclmulqdq	$0x11, %xmm10, %xmm7
-
-	pslldq	$4, %xmm7
-	pxor	%xmm0, %xmm7
-	pextrd	$1, %xmm7, %eax
-
-_cleanup:
-	# scale the result back to 16 bits
-	shr	$16, %eax
-	mov     %rcx, %rsp
-	ret
-
-########################################################################
-
-.align 16
-_less_than_128:
-
-	# check if there is enough buffer to be able to fold 16B at a time
-	cmp	$32, arg3
-	jl	_less_than_32
-	movdqa  SHUF_MASK(%rip), %xmm11
-
-	# now if there is, load the constants
-	movdqa	rk1(%rip), %xmm10	# rk1 and rk2 in xmm10
-
-	movd	arg1_low32, %xmm0	# get the initial crc value
-	pslldq	$12, %xmm0	# align it to its correct place
-	movdqu	(arg2), %xmm7	# load the plaintext
-	pshufb	%xmm11, %xmm7	# byte-reflect the plaintext
-	pxor	%xmm0, %xmm7
-
-
-	# update the buffer pointer
-	add	$16, arg2
-
-	# update the counter. subtract 32 instead of 16 to save one
-	# instruction from the loop
-	sub	$32, arg3
-
-	jmp	_16B_reduction_loop
-
-
-.align 16
-_less_than_32:
-	# mov initial crc to the return value. this is necessary for
-	# zero-length buffers.
-	mov	arg1_low32, %eax
-	test	arg3, arg3
-	je	_cleanup
-
-	movdqa  SHUF_MASK(%rip), %xmm11
-
-	movd	arg1_low32, %xmm0	# get the initial crc value
-	pslldq	$12, %xmm0	# align it to its correct place
-
-	cmp	$16, arg3
-	je	_exact_16_left
-	jl	_less_than_16_left
-
-	movdqu	(arg2), %xmm7	# load the plaintext
-	pshufb	%xmm11, %xmm7	# byte-reflect the plaintext
-	pxor	%xmm0 , %xmm7	# xor the initial crc value
-	add	$16, arg2
-	sub	$16, arg3
-	movdqa	rk1(%rip), %xmm10	# rk1 and rk2 in xmm10
-	jmp	_get_last_two_xmms
-
-
-.align 16
-_less_than_16_left:
-	# use stack space to load data less than 16 bytes, zero-out
-	# the 16B in memory first.
-
-	pxor	%xmm1, %xmm1
-	mov	%rsp, %r11
-	movdqa	%xmm1, (%r11)
-
-	cmp	$4, arg3
-	jl	_only_less_than_4
-
-	# backup the counter value
-	mov	arg3, %r9
-	cmp	$8, arg3
-	jl	_less_than_8_left
-
-	# load 8 Bytes
-	mov	(arg2), %rax
-	mov	%rax, (%r11)
-	add	$8, %r11
-	sub	$8, arg3
-	add	$8, arg2
-_less_than_8_left:
-
-	cmp	$4, arg3
-	jl	_less_than_4_left
-
-	# load 4 Bytes
-	mov	(arg2), %eax
-	mov	%eax, (%r11)
-	add	$4, %r11
-	sub	$4, arg3
-	add	$4, arg2
-_less_than_4_left:
-
-	cmp	$2, arg3
-	jl	_less_than_2_left
-
-	# load 2 Bytes
-	mov	(arg2), %ax
-	mov	%ax, (%r11)
-	add	$2, %r11
-	sub	$2, arg3
-	add	$2, arg2
-_less_than_2_left:
-	cmp     $1, arg3
-        jl      _zero_left
-
-	# load 1 Byte
-	mov	(arg2), %al
-	mov	%al, (%r11)
-_zero_left:
-	movdqa	(%rsp), %xmm7
-	pshufb	%xmm11, %xmm7
-	pxor	%xmm0 , %xmm7	# xor the initial crc value
-
-	# shl r9, 4
-	lea	pshufb_shf_table+16(%rip), %rax
-	sub	%r9, %rax
-	movdqu	(%rax), %xmm0
-	pxor	mask1(%rip), %xmm0
-
-	pshufb	%xmm0, %xmm7
-	jmp	_128_done
-
-.align 16
-_exact_16_left:
-	movdqu	(arg2), %xmm7
-	pshufb	%xmm11, %xmm7
-	pxor	%xmm0 , %xmm7   # xor the initial crc value
-
-	jmp	_128_done
-
-_only_less_than_4:
-	cmp	$3, arg3
-	jl	_only_less_than_3
-
-	# load 3 Bytes
-	mov	(arg2), %al
-	mov	%al, (%r11)
-
-	mov	1(arg2), %al
-	mov	%al, 1(%r11)
-
-	mov	2(arg2), %al
-	mov	%al, 2(%r11)
-
-	movdqa	 (%rsp), %xmm7
-	pshufb	 %xmm11, %xmm7
-	pxor	 %xmm0 , %xmm7  # xor the initial crc value
-
-	psrldq	$5, %xmm7
-
-	jmp	_barrett
-_only_less_than_3:
-	cmp	$2, arg3
-	jl	_only_less_than_2
-
-	# load 2 Bytes
-	mov	(arg2), %al
-	mov	%al, (%r11)
-
-	mov	1(arg2), %al
-	mov	%al, 1(%r11)
-
-	movdqa	(%rsp), %xmm7
-	pshufb	%xmm11, %xmm7
-	pxor	%xmm0 , %xmm7   # xor the initial crc value
-
-	psrldq	$6, %xmm7
-
-	jmp	_barrett
-_only_less_than_2:
-
-	# load 1 Byte
-	mov	(arg2), %al
-	mov	%al, (%r11)
-
-	movdqa	(%rsp), %xmm7
-	pshufb	%xmm11, %xmm7
-	pxor	%xmm0 , %xmm7   # xor the initial crc value
-
-	psrldq	$7, %xmm7
-
-	jmp	_barrett
-
-ENDPROC(crc_t10dif_pcl)
-
-.data
-
-# precomputed constants
-# these constants are precomputed from the poly:
-# 0x8bb70000 (0x8bb7 scaled to 32 bits)
-.align 16
-# Q = 0x18BB70000
-# rk1 = 2^(32*3) mod Q << 32
-# rk2 = 2^(32*5) mod Q << 32
-# rk3 = 2^(32*15) mod Q << 32
-# rk4 = 2^(32*17) mod Q << 32
-# rk5 = 2^(32*3) mod Q << 32
-# rk6 = 2^(32*2) mod Q << 32
-# rk7 = floor(2^64/Q)
-# rk8 = Q
-rk1:
-.quad 0x2d56000000000000
-rk2:
-.quad 0x06df000000000000
-rk3:
-.quad 0x9d9d000000000000
-rk4:
-.quad 0x7cf5000000000000
-rk5:
-.quad 0x2d56000000000000
-rk6:
-.quad 0x1368000000000000
-rk7:
-.quad 0x00000001f65a57f8
-rk8:
-.quad 0x000000018bb70000
-
-rk9:
-.quad 0xceae000000000000
-rk10:
-.quad 0xbfd6000000000000
-rk11:
-.quad 0x1e16000000000000
-rk12:
-.quad 0x713c000000000000
-rk13:
-.quad 0xf7f9000000000000
-rk14:
-.quad 0x80a6000000000000
-rk15:
-.quad 0x044c000000000000
-rk16:
-.quad 0xe658000000000000
-rk17:
-.quad 0xad18000000000000
-rk18:
-.quad 0xa497000000000000
-rk19:
-.quad 0x6ee3000000000000
-rk20:
-.quad 0xe7b5000000000000
-
-
-
-mask1:
-.octa 0x80808080808080808080808080808080
-mask2:
-.octa 0x00000000FFFFFFFFFFFFFFFFFFFFFFFF
-
-SHUF_MASK:
-.octa 0x000102030405060708090A0B0C0D0E0F
-
-pshufb_shf_table:
-# use these values for shift constants for the pshufb instruction
-# different alignments result in values as shown:
-#	DDQ 0x008f8e8d8c8b8a898887868584838281 # shl 15 (16-1) / shr1
-#	DDQ 0x01008f8e8d8c8b8a8988878685848382 # shl 14 (16-3) / shr2
-#	DDQ 0x0201008f8e8d8c8b8a89888786858483 # shl 13 (16-4) / shr3
-#	DDQ 0x030201008f8e8d8c8b8a898887868584 # shl 12 (16-4) / shr4
-#	DDQ 0x04030201008f8e8d8c8b8a8988878685 # shl 11 (16-5) / shr5
-#	DDQ 0x0504030201008f8e8d8c8b8a89888786 # shl 10 (16-6) / shr6
-#	DDQ 0x060504030201008f8e8d8c8b8a898887 # shl 9  (16-7) / shr7
-#	DDQ 0x07060504030201008f8e8d8c8b8a8988 # shl 8  (16-8) / shr8
-#	DDQ 0x0807060504030201008f8e8d8c8b8a89 # shl 7  (16-9) / shr9
-#	DDQ 0x090807060504030201008f8e8d8c8b8a # shl 6  (16-10) / shr10
-#	DDQ 0x0a090807060504030201008f8e8d8c8b # shl 5  (16-11) / shr11
-#	DDQ 0x0b0a090807060504030201008f8e8d8c # shl 4  (16-12) / shr12
-#	DDQ 0x0c0b0a090807060504030201008f8e8d # shl 3  (16-13) / shr13
-#	DDQ 0x0d0c0b0a090807060504030201008f8e # shl 2  (16-14) / shr14
-#	DDQ 0x0e0d0c0b0a090807060504030201008f # shl 1  (16-15) / shr15
-.octa 0x8f8e8d8c8b8a89888786858483828100
-.octa 0x000e0d0c0b0a09080706050403020100
diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
deleted file mode 100644
index 7845d7f..0000000
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ /dev/null
@@ -1,151 +0,0 @@
-/*
- * Cryptographic API.
- *
- * T10 Data Integrity Field CRC16 Crypto Transform using PCLMULQDQ Instructions
- *
- * Copyright (C) 2013 Intel Corporation
- * Author: Tim Chen <tim.c.chen@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#include <linux/types.h>
-#include <linux/module.h>
-#include <linux/crc-t10dif.h>
-#include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <asm/i387.h>
-#include <asm/cpufeature.h>
-#include <asm/cpu_device_id.h>
-
-asmlinkage __u16 crc_t10dif_pcl(__u16 crc, const unsigned char *buf,
-				size_t len);
-
-struct chksum_desc_ctx {
-	__u16 crc;
-};
-
-/*
- * Steps through buffer one byte at at time, calculates reflected
- * crc using table.
- */
-
-static int chksum_init(struct shash_desc *desc)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	ctx->crc = 0;
-
-	return 0;
-}
-
-static int chksum_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int length)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	if (irq_fpu_usable()) {
-		kernel_fpu_begin();
-		ctx->crc = crc_t10dif_pcl(ctx->crc, data, length);
-		kernel_fpu_end();
-	} else
-		ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
-	return 0;
-}
-
-static int chksum_final(struct shash_desc *desc, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	*(__u16 *)out = ctx->crc;
-	return 0;
-}
-
-static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
-			u8 *out)
-{
-	if (irq_fpu_usable()) {
-		kernel_fpu_begin();
-		*(__u16 *)out = crc_t10dif_pcl(*crcp, data, len);
-		kernel_fpu_end();
-	} else
-		*(__u16 *)out = crc_t10dif_generic(*crcp, data, len);
-	return 0;
-}
-
-static int chksum_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup(&ctx->crc, data, len, out);
-}
-
-static int chksum_digest(struct shash_desc *desc, const u8 *data,
-			 unsigned int length, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup(&ctx->crc, data, length, out);
-}
-
-static struct shash_alg alg = {
-	.digestsize		=	CRC_T10DIF_DIGEST_SIZE,
-	.init		=	chksum_init,
-	.update		=	chksum_update,
-	.final		=	chksum_final,
-	.finup		=	chksum_finup,
-	.digest		=	chksum_digest,
-	.descsize		=	sizeof(struct chksum_desc_ctx),
-	.base			=	{
-		.cra_name		=	"crct10dif",
-		.cra_driver_name	=	"crct10dif-pclmul",
-		.cra_priority		=	200,
-		.cra_blocksize		=	CRC_T10DIF_BLOCK_SIZE,
-		.cra_module		=	THIS_MODULE,
-	}
-};
-
-static const struct x86_cpu_id crct10dif_cpu_id[] = {
-	X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
-	{}
-};
-MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
-
-static int __init crct10dif_intel_mod_init(void)
-{
-	if (!x86_match_cpu(crct10dif_cpu_id))
-		return -ENODEV;
-
-	return crypto_register_shash(&alg);
-}
-
-static void __exit crct10dif_intel_mod_fini(void)
-{
-	crypto_unregister_shash(&alg);
-}
-
-module_init(crct10dif_intel_mod_init);
-module_exit(crct10dif_intel_mod_fini);
-
-MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
-MODULE_DESCRIPTION("T10 DIF CRC calculation accelerated with PCLMULQDQ.");
-MODULE_LICENSE("GPL");
-
-MODULE_ALIAS("crct10dif");
-MODULE_ALIAS("crct10dif-pclmul");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 904ffe8..2754f2b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -376,25 +376,6 @@ config CRYPTO_CRC32_PCLMUL
 	  which will enable any routine to use the CRC-32-IEEE 802.3 checksum
 	  and gain better performance as compared with the table implementation.
 
-config CRYPTO_CRCT10DIF
-	tristate "CRCT10DIF algorithm"
-	select CRYPTO_HASH
-	help
-	  CRC T10 Data Integrity Field computation is being cast as
-	  a crypto transform.  This allows for faster crc t10 diff
-	  transforms to be used if they are available.
-
-config CRYPTO_CRCT10DIF_PCLMUL
-	tristate "CRCT10DIF PCLMULQDQ hardware acceleration"
-	depends on X86 && 64BIT && CRC_T10DIF
-	select CRYPTO_HASH
-	help
-	  For x86_64 processors with SSE4.2 and PCLMULQDQ supported,
-	  CRC T10 DIF PCLMULQDQ computation can be hardware
-	  accelerated PCLMULQDQ instruction. This option will create
-	  'crct10dif-plcmul' module, which is faster when computing the
-	  crct10dif checksum as compared with the generic table implementation.
-
 config CRYPTO_GHASH
 	tristate "GHASH digest algorithm"
 	select CRYPTO_GF128MUL
diff --git a/crypto/Makefile b/crypto/Makefile
index 62af87d..a8e9b0f 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -83,7 +83,6 @@ obj-$(CONFIG_CRYPTO_ZLIB) += zlib.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
-obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
 obj-$(CONFIG_CRYPTO_842) += 842.o
diff --git a/crypto/crct10dif.c b/crypto/crct10dif.c
deleted file mode 100644
index 92aca96..0000000
--- a/crypto/crct10dif.c
+++ /dev/null
@@ -1,178 +0,0 @@
-/*
- * Cryptographic API.
- *
- * T10 Data Integrity Field CRC16 Crypto Transform
- *
- * Copyright (c) 2007 Oracle Corporation.  All rights reserved.
- * Written by Martin K. Petersen <martin.petersen@oracle.com>
- * Copyright (C) 2013 Intel Corporation
- * Author: Tim Chen <tim.c.chen@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#include <linux/types.h>
-#include <linux/module.h>
-#include <linux/crc-t10dif.h>
-#include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-
-struct chksum_desc_ctx {
-	__u16 crc;
-};
-
-/* Table generated using the following polynomium:
- * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
- * gt: 0x8bb7
- */
-static const __u16 t10_dif_crc_table[256] = {
-	0x0000, 0x8BB7, 0x9CD9, 0x176E, 0xB205, 0x39B2, 0x2EDC, 0xA56B,
-	0xEFBD, 0x640A, 0x7364, 0xF8D3, 0x5DB8, 0xD60F, 0xC161, 0x4AD6,
-	0x54CD, 0xDF7A, 0xC814, 0x43A3, 0xE6C8, 0x6D7F, 0x7A11, 0xF1A6,
-	0xBB70, 0x30C7, 0x27A9, 0xAC1E, 0x0975, 0x82C2, 0x95AC, 0x1E1B,
-	0xA99A, 0x222D, 0x3543, 0xBEF4, 0x1B9F, 0x9028, 0x8746, 0x0CF1,
-	0x4627, 0xCD90, 0xDAFE, 0x5149, 0xF422, 0x7F95, 0x68FB, 0xE34C,
-	0xFD57, 0x76E0, 0x618E, 0xEA39, 0x4F52, 0xC4E5, 0xD38B, 0x583C,
-	0x12EA, 0x995D, 0x8E33, 0x0584, 0xA0EF, 0x2B58, 0x3C36, 0xB781,
-	0xD883, 0x5334, 0x445A, 0xCFED, 0x6A86, 0xE131, 0xF65F, 0x7DE8,
-	0x373E, 0xBC89, 0xABE7, 0x2050, 0x853B, 0x0E8C, 0x19E2, 0x9255,
-	0x8C4E, 0x07F9, 0x1097, 0x9B20, 0x3E4B, 0xB5FC, 0xA292, 0x2925,
-	0x63F3, 0xE844, 0xFF2A, 0x749D, 0xD1F6, 0x5A41, 0x4D2F, 0xC698,
-	0x7119, 0xFAAE, 0xEDC0, 0x6677, 0xC31C, 0x48AB, 0x5FC5, 0xD472,
-	0x9EA4, 0x1513, 0x027D, 0x89CA, 0x2CA1, 0xA716, 0xB078, 0x3BCF,
-	0x25D4, 0xAE63, 0xB90D, 0x32BA, 0x97D1, 0x1C66, 0x0B08, 0x80BF,
-	0xCA69, 0x41DE, 0x56B0, 0xDD07, 0x786C, 0xF3DB, 0xE4B5, 0x6F02,
-	0x3AB1, 0xB106, 0xA668, 0x2DDF, 0x88B4, 0x0303, 0x146D, 0x9FDA,
-	0xD50C, 0x5EBB, 0x49D5, 0xC262, 0x6709, 0xECBE, 0xFBD0, 0x7067,
-	0x6E7C, 0xE5CB, 0xF2A5, 0x7912, 0xDC79, 0x57CE, 0x40A0, 0xCB17,
-	0x81C1, 0x0A76, 0x1D18, 0x96AF, 0x33C4, 0xB873, 0xAF1D, 0x24AA,
-	0x932B, 0x189C, 0x0FF2, 0x8445, 0x212E, 0xAA99, 0xBDF7, 0x3640,
-	0x7C96, 0xF721, 0xE04F, 0x6BF8, 0xCE93, 0x4524, 0x524A, 0xD9FD,
-	0xC7E6, 0x4C51, 0x5B3F, 0xD088, 0x75E3, 0xFE54, 0xE93A, 0x628D,
-	0x285B, 0xA3EC, 0xB482, 0x3F35, 0x9A5E, 0x11E9, 0x0687, 0x8D30,
-	0xE232, 0x6985, 0x7EEB, 0xF55C, 0x5037, 0xDB80, 0xCCEE, 0x4759,
-	0x0D8F, 0x8638, 0x9156, 0x1AE1, 0xBF8A, 0x343D, 0x2353, 0xA8E4,
-	0xB6FF, 0x3D48, 0x2A26, 0xA191, 0x04FA, 0x8F4D, 0x9823, 0x1394,
-	0x5942, 0xD2F5, 0xC59B, 0x4E2C, 0xEB47, 0x60F0, 0x779E, 0xFC29,
-	0x4BA8, 0xC01F, 0xD771, 0x5CC6, 0xF9AD, 0x721A, 0x6574, 0xEEC3,
-	0xA415, 0x2FA2, 0x38CC, 0xB37B, 0x1610, 0x9DA7, 0x8AC9, 0x017E,
-	0x1F65, 0x94D2, 0x83BC, 0x080B, 0xAD60, 0x26D7, 0x31B9, 0xBA0E,
-	0xF0D8, 0x7B6F, 0x6C01, 0xE7B6, 0x42DD, 0xC96A, 0xDE04, 0x55B3
-};
-
-__u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len)
-{
-	unsigned int i;
-
-	for (i = 0 ; i < len ; i++)
-		crc = (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff];
-
-	return crc;
-}
-EXPORT_SYMBOL(crc_t10dif_generic);
-
-/*
- * Steps through buffer one byte at at time, calculates reflected
- * crc using table.
- */
-
-static int chksum_init(struct shash_desc *desc)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	ctx->crc = 0;
-
-	return 0;
-}
-
-static int chksum_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int length)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
-	return 0;
-}
-
-static int chksum_final(struct shash_desc *desc, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	*(__u16 *)out = ctx->crc;
-	return 0;
-}
-
-static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
-			u8 *out)
-{
-	*(__u16 *)out = crc_t10dif_generic(*crcp, data, len);
-	return 0;
-}
-
-static int chksum_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup(&ctx->crc, data, len, out);
-}
-
-static int chksum_digest(struct shash_desc *desc, const u8 *data,
-			 unsigned int length, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup(&ctx->crc, data, length, out);
-}
-
-static struct shash_alg alg = {
-	.digestsize		=	CRC_T10DIF_DIGEST_SIZE,
-	.init		=	chksum_init,
-	.update		=	chksum_update,
-	.final		=	chksum_final,
-	.finup		=	chksum_finup,
-	.digest		=	chksum_digest,
-	.descsize		=	sizeof(struct chksum_desc_ctx),
-	.base			=	{
-		.cra_name		=	"crct10dif",
-		.cra_driver_name	=	"crct10dif-generic",
-		.cra_priority		=	100,
-		.cra_blocksize		=	CRC_T10DIF_BLOCK_SIZE,
-		.cra_module		=	THIS_MODULE,
-	}
-};
-
-static int __init crct10dif_mod_init(void)
-{
-	int ret;
-
-	ret = crypto_register_shash(&alg);
-	return ret;
-}
-
-static void __exit crct10dif_mod_fini(void)
-{
-	crypto_unregister_shash(&alg);
-}
-
-module_init(crct10dif_mod_init);
-module_exit(crct10dif_mod_fini);
-
-MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
-MODULE_DESCRIPTION("T10 DIF CRC calculation.");
-MODULE_LICENSE("GPL");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 25a5934..66d254c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1174,10 +1174,6 @@ static int do_test(int m)
 		ret += tcrypt_test("ghash");
 		break;
 
-	case 47:
-		ret += tcrypt_test("crct10dif");
-		break;
-
 	case 100:
 		ret += tcrypt_test("hmac(md5)");
 		break;
@@ -1502,10 +1498,6 @@ static int do_test(int m)
 		test_hash_speed("crc32c", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
-	case 320:
-		test_hash_speed("crct10dif", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-
 	case 399:
 		break;
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2f00607..ecddf92 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2046,16 +2046,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "crct10dif",
-		.test = alg_test_hash,
-		.fips_allowed = 1,
-		.suite = {
-			.hash = {
-				.vecs = crct10dif_tv_template,
-				.count = CRCT10DIF_TEST_VECTORS
-			}
-		}
-	}, {
 		.alg = "cryptd(__driver-cbc-aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 7d44aa3..1e701bc 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -450,39 +450,6 @@ static struct hash_testvec rmd320_tv_template[] = {
 	}
 };
 
-#define CRCT10DIF_TEST_VECTORS	3
-static struct hash_testvec crct10dif_tv_template[] = {
-	{
-		.plaintext = "abc",
-		.psize  = 3,
-#ifdef __LITTLE_ENDIAN
-		.digest = "\x3b\x44",
-#else
-		.digest = "\x44\x3b",
-#endif
-	}, {
-		.plaintext = "1234567890123456789012345678901234567890"
-			     "123456789012345678901234567890123456789",
-		.psize	= 79,
-#ifdef __LITTLE_ENDIAN
-		.digest	= "\x70\x4b",
-#else
-		.digest	= "\x4b\x70",
-#endif
-	}, {
-		.plaintext =
-		"abcddddddddddddddddddddddddddddddddddddddddddddddddddddd",
-		.psize  = 56,
-#ifdef __LITTLE_ENDIAN
-		.digest = "\xe3\x9c",
-#else
-		.digest = "\x9c\xe3",
-#endif
-		.np     = 2,
-		.tap    = { 28, 28 }
-	}
-};
-
 /*
  * SHA1 test vectors  from from FIPS PUB 180-1
  * Long vector from CAVS 5.0
diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
index b3cb71f..a9c96d8 100644
--- a/include/linux/crc-t10dif.h
+++ b/include/linux/crc-t10dif.h
@@ -3,10 +3,6 @@
 
 #include <linux/types.h>
 
-#define CRC_T10DIF_DIGEST_SIZE 2
-#define CRC_T10DIF_BLOCK_SIZE 1
-
-__u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len);
 __u16 crc_t10dif(unsigned char const *, size_t);
 
 #endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 339d5a4..fe01d41 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -63,8 +63,6 @@ config CRC16
 
 config CRC_T10DIF
 	tristate "CRC calculation for the T10 Data Integrity Field"
-	select CRYPTO
-	select CRYPTO_CRCT10DIF
 	help
 	  This option is only needed if a module that's not in the
 	  kernel tree needs to calculate CRC checks for use with the
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index fe3428c..fbbd66e 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -11,44 +11,57 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/crc-t10dif.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <crypto/hash.h>
 
-static struct crypto_shash *crct10dif_tfm;
+/* Table generated using the following polynomium:
+ * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
+ * gt: 0x8bb7
+ */
+static const __u16 t10_dif_crc_table[256] = {
+	0x0000, 0x8BB7, 0x9CD9, 0x176E, 0xB205, 0x39B2, 0x2EDC, 0xA56B,
+	0xEFBD, 0x640A, 0x7364, 0xF8D3, 0x5DB8, 0xD60F, 0xC161, 0x4AD6,
+	0x54CD, 0xDF7A, 0xC814, 0x43A3, 0xE6C8, 0x6D7F, 0x7A11, 0xF1A6,
+	0xBB70, 0x30C7, 0x27A9, 0xAC1E, 0x0975, 0x82C2, 0x95AC, 0x1E1B,
+	0xA99A, 0x222D, 0x3543, 0xBEF4, 0x1B9F, 0x9028, 0x8746, 0x0CF1,
+	0x4627, 0xCD90, 0xDAFE, 0x5149, 0xF422, 0x7F95, 0x68FB, 0xE34C,
+	0xFD57, 0x76E0, 0x618E, 0xEA39, 0x4F52, 0xC4E5, 0xD38B, 0x583C,
+	0x12EA, 0x995D, 0x8E33, 0x0584, 0xA0EF, 0x2B58, 0x3C36, 0xB781,
+	0xD883, 0x5334, 0x445A, 0xCFED, 0x6A86, 0xE131, 0xF65F, 0x7DE8,
+	0x373E, 0xBC89, 0xABE7, 0x2050, 0x853B, 0x0E8C, 0x19E2, 0x9255,
+	0x8C4E, 0x07F9, 0x1097, 0x9B20, 0x3E4B, 0xB5FC, 0xA292, 0x2925,
+	0x63F3, 0xE844, 0xFF2A, 0x749D, 0xD1F6, 0x5A41, 0x4D2F, 0xC698,
+	0x7119, 0xFAAE, 0xEDC0, 0x6677, 0xC31C, 0x48AB, 0x5FC5, 0xD472,
+	0x9EA4, 0x1513, 0x027D, 0x89CA, 0x2CA1, 0xA716, 0xB078, 0x3BCF,
+	0x25D4, 0xAE63, 0xB90D, 0x32BA, 0x97D1, 0x1C66, 0x0B08, 0x80BF,
+	0xCA69, 0x41DE, 0x56B0, 0xDD07, 0x786C, 0xF3DB, 0xE4B5, 0x6F02,
+	0x3AB1, 0xB106, 0xA668, 0x2DDF, 0x88B4, 0x0303, 0x146D, 0x9FDA,
+	0xD50C, 0x5EBB, 0x49D5, 0xC262, 0x6709, 0xECBE, 0xFBD0, 0x7067,
+	0x6E7C, 0xE5CB, 0xF2A5, 0x7912, 0xDC79, 0x57CE, 0x40A0, 0xCB17,
+	0x81C1, 0x0A76, 0x1D18, 0x96AF, 0x33C4, 0xB873, 0xAF1D, 0x24AA,
+	0x932B, 0x189C, 0x0FF2, 0x8445, 0x212E, 0xAA99, 0xBDF7, 0x3640,
+	0x7C96, 0xF721, 0xE04F, 0x6BF8, 0xCE93, 0x4524, 0x524A, 0xD9FD,
+	0xC7E6, 0x4C51, 0x5B3F, 0xD088, 0x75E3, 0xFE54, 0xE93A, 0x628D,
+	0x285B, 0xA3EC, 0xB482, 0x3F35, 0x9A5E, 0x11E9, 0x0687, 0x8D30,
+	0xE232, 0x6985, 0x7EEB, 0xF55C, 0x5037, 0xDB80, 0xCCEE, 0x4759,
+	0x0D8F, 0x8638, 0x9156, 0x1AE1, 0xBF8A, 0x343D, 0x2353, 0xA8E4,
+	0xB6FF, 0x3D48, 0x2A26, 0xA191, 0x04FA, 0x8F4D, 0x9823, 0x1394,
+	0x5942, 0xD2F5, 0xC59B, 0x4E2C, 0xEB47, 0x60F0, 0x779E, 0xFC29,
+	0x4BA8, 0xC01F, 0xD771, 0x5CC6, 0xF9AD, 0x721A, 0x6574, 0xEEC3,
+	0xA415, 0x2FA2, 0x38CC, 0xB37B, 0x1610, 0x9DA7, 0x8AC9, 0x017E,
+	0x1F65, 0x94D2, 0x83BC, 0x080B, 0xAD60, 0x26D7, 0x31B9, 0xBA0E,
+	0xF0D8, 0x7B6F, 0x6C01, 0xE7B6, 0x42DD, 0xC96A, 0xDE04, 0x55B3
+};
 
 __u16 crc_t10dif(const unsigned char *buffer, size_t len)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[2];
-	} desc;
-	int err;
-
-	desc.shash.tfm = crct10dif_tfm;
-	desc.shash.flags = 0;
-	*(__u16 *)desc.ctx = 0;
+	__u16 crc = 0;
+	unsigned int i;
 
-	err = crypto_shash_update(&desc.shash, buffer, len);
-	BUG_ON(err);
+	for (i = 0 ; i < len ; i++)
+		crc = (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff];
 
-	return *(__u16 *)desc.ctx;
+	return crc;
 }
 EXPORT_SYMBOL(crc_t10dif);
 
-static int __init crc_t10dif_mod_init(void)
-{
-	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
-	return PTR_RET(crct10dif_tfm);
-}
-
-static void __exit crc_t10dif_mod_fini(void)
-{
-	crypto_free_shash(crct10dif_tfm);
-}
-
-module_init(crc_t10dif_mod_init);
-module_exit(crc_t10dif_mod_fini);
-
 MODULE_DESCRIPTION("T10 DIF CRC calculation");
 MODULE_LICENSE("GPL");

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
