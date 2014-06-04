From: chandramouli narayanan <mouli@linux.intel.com>
Subject: Re: [PATCH v2 1/1] crypto: AES CTR x86_64 "by8" AVX optimization
Date: Wed, 04 Jun 2014 10:04:36 -0700
Message-ID: <1401901476.2367.195.camel@pegasus.jf.intel.com>
References: <1401842474.2367.180.camel@pegasus.jf.intel.com>
	 <20140604065323.GA22521@jig.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Erdinc Ozturk <erdinc.ozturk@intel.com>,
	Aidan O'Mahony <aidan.o.mahony@intel.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Gabriele Paoloni <gabriele.paoloni@intel.com>,
	"Tadeusz Struk,Huang Ying" <ying.huang@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33303 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaFDQ63 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Jun 2014 12:58:29 -0400
In-Reply-To: <20140604065323.GA22521@jig.fritz.box>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2014-06-04 at 08:53 +0200, Mathias Krause wrote:
> On Tue, Jun 03, 2014 at 05:41:14PM -0700, chandramouli narayanan wrote:
> > This patch introduces "by8" AES CTR mode AVX optimization inspired by
> > Intel Optimized IPSEC Cryptograhpic library. For additional information,
> > please see:
> > http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=22972
> > 
> > The functions aes_ctr_enc_128_avx_by8(), aes_ctr_enc_192_avx_by8() and
> > aes_ctr_enc_256_avx_by8() are adapted from
> > Intel Optimized IPSEC Cryptographic library. When both AES and AVX features
> > are enabled in a platform, the glue code in AESNI module overrieds the
> > existing "by4" CTR mode en/decryption with the "by8"
> > AES CTR mode en/decryption.
> > 
> > On a Haswell desktop, with turbo disabled and all cpus running
> > at maximum frequency, the "by8" CTR mode optimization
> > shows better performance results across data & key sizes
> > as measured by tcrypt.
> > 
> > The average performance improvement of the "by8" version over the "by4"
> > version is as follows:
> > 
> > For 128 bit key and data sizes >= 256 bytes, there is a 10-16% improvement.
> > For 192 bit key and data sizes >= 256 bytes, there is a 20-22% improvement.
> > For 256 bit key and data sizes >= 256 bytes, there is a 20-25% improvement.
> 
> Nice improvement :)
> 
> How does it perform on older processors that do have a penalty for
> unaligned loads (vmovdqu), e.g. SandyBridge? If those perform worse it
> might be wise to extend the CPU feature test in the glue code by a model
> test to enable the "by8" variant only for Haswell and newer processors
> that don't have such a penalty.

Good point. I will check it out and add the needed test to enable the
optimization on processors where it shines. 
> 
> > 
> > A typical run of tcrypt with AES CTR mode encryption of the "by4" and "by8"
> > optimization shows the following results:
> > 
> > tcrypt with "by4" AES CTR mode encryption optimization on a Haswell Desktop:
> > ---------------------------------------------------------------------------
> > 
> > testing speed of __ctr-aes-aesni encryption
> > test 0 (128 bit key, 16 byte blocks): 1 operation in 343 cycles (16 bytes)
> > test 1 (128 bit key, 64 byte blocks): 1 operation in 336 cycles (64 bytes)
> > test 2 (128 bit key, 256 byte blocks): 1 operation in 491 cycles (256 bytes)
> > test 3 (128 bit key, 1024 byte blocks): 1 operation in 1130 cycles (1024 bytes)
> > test 4 (128 bit key, 8192 byte blocks): 1 operation in 7309 cycles (8192 bytes)
> > test 5 (192 bit key, 16 byte blocks): 1 operation in 346 cycles (16 bytes)
> > test 6 (192 bit key, 64 byte blocks): 1 operation in 361 cycles (64 bytes)
> > test 7 (192 bit key, 256 byte blocks): 1 operation in 543 cycles (256 bytes)
> > test 8 (192 bit key, 1024 byte blocks): 1 operation in 1321 cycles (1024 bytes)
> > test 9 (192 bit key, 8192 byte blocks): 1 operation in 9649 cycles (8192 bytes)
> > test 10 (256 bit key, 16 byte blocks): 1 operation in 369 cycles (16 bytes)
> > test 11 (256 bit key, 64 byte blocks): 1 operation in 366 cycles (64 bytes)
> > test 12 (256 bit key, 256 byte blocks): 1 operation in 595 cycles (256 bytes)
> > test 13 (256 bit key, 1024 byte blocks): 1 operation in 1531 cycles (1024 bytes)
> > test 14 (256 bit key, 8192 byte blocks): 1 operation in 10522 cycles (8192 bytes)
> > 
> > testing speed of __ctr-aes-aesni decryption
> > test 0 (128 bit key, 16 byte blocks): 1 operation in 336 cycles (16 bytes)
> > test 1 (128 bit key, 64 byte blocks): 1 operation in 350 cycles (64 bytes)
> > test 2 (128 bit key, 256 byte blocks): 1 operation in 487 cycles (256 bytes)
> > test 3 (128 bit key, 1024 byte blocks): 1 operation in 1129 cycles (1024 bytes)
> > test 4 (128 bit key, 8192 byte blocks): 1 operation in 7287 cycles (8192 bytes)
> > test 5 (192 bit key, 16 byte blocks): 1 operation in 350 cycles (16 bytes)
> > test 6 (192 bit key, 64 byte blocks): 1 operation in 359 cycles (64 bytes)
> > test 7 (192 bit key, 256 byte blocks): 1 operation in 635 cycles (256 bytes)
> > test 8 (192 bit key, 1024 byte blocks): 1 operation in 1324 cycles (1024 bytes)
> > test 9 (192 bit key, 8192 byte blocks): 1 operation in 9595 cycles (8192 bytes)
> > test 10 (256 bit key, 16 byte blocks): 1 operation in 364 cycles (16 bytes)
> > test 11 (256 bit key, 64 byte blocks): 1 operation in 377 cycles (64 bytes)
> > test 12 (256 bit key, 256 byte blocks): 1 operation in 604 cycles (256 bytes)
> > test 13 (256 bit key, 1024 byte blocks): 1 operation in 1527 cycles (1024 bytes)
> > test 14 (256 bit key, 8192 byte blocks): 1 operation in 10549 cycles (8192 bytes)
> > 
> > tcrypt with "by8" AES CTR mode encryption optimization on a Haswell Desktop:
> > ---------------------------------------------------------------------------
> > 
> > testing speed of __ctr-aes-aesni encryption
> > test 0 (128 bit key, 16 byte blocks): 1 operation in 340 cycles (16 bytes)
> > test 1 (128 bit key, 64 byte blocks): 1 operation in 330 cycles (64 bytes)
> > test 2 (128 bit key, 256 byte blocks): 1 operation in 450 cycles (256 bytes)
> > test 3 (128 bit key, 1024 byte blocks): 1 operation in 1043 cycles (1024 bytes)
> > test 4 (128 bit key, 8192 byte blocks): 1 operation in 6597 cycles (8192 bytes)
> > test 5 (192 bit key, 16 byte blocks): 1 operation in 339 cycles (16 bytes)
> > test 6 (192 bit key, 64 byte blocks): 1 operation in 352 cycles (64 bytes)
> > test 7 (192 bit key, 256 byte blocks): 1 operation in 539 cycles (256 bytes)
> > test 8 (192 bit key, 1024 byte blocks): 1 operation in 1153 cycles (1024 bytes)
> > test 9 (192 bit key, 8192 byte blocks): 1 operation in 8458 cycles (8192 bytes)
> > test 10 (256 bit key, 16 byte blocks): 1 operation in 353 cycles (16 bytes)
> > test 11 (256 bit key, 64 byte blocks): 1 operation in 360 cycles (64 bytes)
> > test 12 (256 bit key, 256 byte blocks): 1 operation in 512 cycles (256 bytes)
> > test 13 (256 bit key, 1024 byte blocks): 1 operation in 1277 cycles (1024 bytes)
> > test 14 (256 bit key, 8192 byte blocks): 1 operation in 8745 cycles (8192 bytes)
> > 
> > testing speed of __ctr-aes-aesni decryption
> > test 0 (128 bit key, 16 byte blocks): 1 operation in 348 cycles (16 bytes)
> > test 1 (128 bit key, 64 byte blocks): 1 operation in 335 cycles (64 bytes)
> > test 2 (128 bit key, 256 byte blocks): 1 operation in 451 cycles (256 bytes)
> > test 3 (128 bit key, 1024 byte blocks): 1 operation in 1030 cycles (1024 bytes)
> > test 4 (128 bit key, 8192 byte blocks): 1 operation in 6611 cycles (8192 bytes)
> > test 5 (192 bit key, 16 byte blocks): 1 operation in 354 cycles (16 bytes)
> > test 6 (192 bit key, 64 byte blocks): 1 operation in 346 cycles (64 bytes)
> > test 7 (192 bit key, 256 byte blocks): 1 operation in 488 cycles (256 bytes)
> > test 8 (192 bit key, 1024 byte blocks): 1 operation in 1154 cycles (1024 bytes)
> > test 9 (192 bit key, 8192 byte blocks): 1 operation in 8390 cycles (8192 bytes)
> > test 10 (256 bit key, 16 byte blocks): 1 operation in 357 cycles (16 bytes)
> > test 11 (256 bit key, 64 byte blocks): 1 operation in 362 cycles (64 bytes)
> > test 12 (256 bit key, 256 byte blocks): 1 operation in 515 cycles (256 bytes)
> > test 13 (256 bit key, 1024 byte blocks): 1 operation in 1284 cycles (1024 bytes)
> > test 14 (256 bit key, 8192 byte blocks): 1 operation in 8681 cycles (8192 bytes)
> > 
> > Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> > ---
> >  arch/x86/crypto/Makefile                |   2 +-
> >  arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 545 ++++++++++++++++++++++++++++++++
> >  arch/x86/crypto/aesni-intel_glue.c      |  41 ++-
> >  3 files changed, 586 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/x86/crypto/aes_ctrby8_avx-x86_64.S
> > 
> > diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> > index 61d6e28..f6fe1e2 100644
> > --- a/arch/x86/crypto/Makefile
> > +++ b/arch/x86/crypto/Makefile
> > @@ -76,7 +76,7 @@ ifeq ($(avx2_supported),yes)
> >  endif
> >  
> >  aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
> > -aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o
> > +aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
> >  ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
> >  sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
> >  ifeq ($(avx2_supported),yes)
> > diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
> > new file mode 100644
> > index 0000000..e49595f
> > --- /dev/null
> > +++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
> > @@ -0,0 +1,545 @@
> > +/*
> > + *	Implement AES CTR mode by8 optimization with AVX instructions. (x86_64)
> > + *
> > + * This is AES128/192/256 CTR mode optimization implementation. It requires
> > + * the support of Intel(R) AESNI and AVX instructions.
> > + *
> > + * This work was inspired by the AES CTR mode optimization published
> > + * in Intel Optimized IPSEC Cryptograhpic library.
> > + * Additional information on it can be found at:
> > + *    http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=22972
> > + *
> > + * This file is provided under a dual BSD/GPLv2 license.  When using or
> > + * redistributing this file, you may do so under either license.
> > + *
> > + * GPL LICENSE SUMMARY
> > + *
> > + * Copyright(c) 2014 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of version 2 of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + *
> > + * Contact Information:
> > + * James Guilford <james.guilford@intel.com>
> > + * Sean Gulley <sean.m.gulley@intel.com>
> > + * Chandramouli Narayanan <mouli@linux.intel.com>
> > + *
> > + * BSD LICENSE
> > + *
> > + * Copyright(c) 2014 Intel Corporation.
> > + *
> > + * Redistribution and use in source and binary forms, with or without
> > + * modification, are permitted provided that the following conditions
> > + * are met:
> > + *
> > + * Redistributions of source code must retain the above copyright
> > + * notice, this list of conditions and the following disclaimer.
> > + * Redistributions in binary form must reproduce the above copyright
> > + * notice, this list of conditions and the following disclaimer in
> > + * the documentation and/or other materials provided with the
> > + * distribution.
> > + * Neither the name of Intel Corporation nor the names of its
> > + * contributors may be used to endorse or promote products derived
> > + * from this software without specific prior written permission.
> > + *
> > + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> > + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> > + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> > + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> > + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> > + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> > + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> > + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> > + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> > + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> > + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> > + *
> > + */
> > +
> > +#include <linux/linkage.h>
> > +#include <asm/inst.h>
> > +
> > +#define CONCAT(a,b)	a##b
> > +#define VMOVDQ		vmovdqu
> > +
> > +#define xdata0		%xmm0
> > +#define xdata1		%xmm1
> > +#define xdata2		%xmm2
> > +#define xdata3		%xmm3
> > +#define xdata4		%xmm4
> > +#define xdata5		%xmm5
> > +#define xdata6		%xmm6
> > +#define xdata7		%xmm7
> > +#define xcounter	%xmm8
> > +#define xbyteswap	%xmm9
> > +#define xkey0		%xmm10
> > +#define xkey3		%xmm11
> > +#define xkey6		%xmm12
> > +#define xkey9		%xmm13
> > +#define xkey4		%xmm11
> > +#define xkey8		%xmm12
> > +#define xkey12		%xmm13
> > +#define xkeyA		%xmm14
> > +#define xkeyB		%xmm15
> > +
> > +#define p_in		%rdi
> > +#define p_iv		%rsi
> > +#define p_keys		%rdx
> > +#define p_out		%rcx
> > +#define num_bytes	%r8
> > +
> > +#define tmp		%r10
> > +#define	DDQ(i)		CONCAT(ddq_add_,i)
> > +#define	XMM(i)		CONCAT(%xmm, i)
> > +#define	DDQ_DATA	0
> > +#define	XDATA		1
> > +#define KEY_128		1
> > +#define KEY_192		2
> > +#define KEY_256		3
> > +
> > +.section .data
> 
> .section .rodata, as already mentioned by hpa.
> 
Ok, I will get it fixed.

> > +.align 16
> > +
> > +byteswap_const:
> > +	.octa 0x000102030405060708090A0B0C0D0E0F
> > +ddq_add_1:
> > +	.octa 0x00000000000000000000000000000001
> > +ddq_add_2:
> > +	.octa 0x00000000000000000000000000000002
> > +ddq_add_3:
> > +	.octa 0x00000000000000000000000000000003
> > +ddq_add_4:
> > +	.octa 0x00000000000000000000000000000004
> > +ddq_add_5:
> > +	.octa 0x00000000000000000000000000000005
> > +ddq_add_6:
> > +	.octa 0x00000000000000000000000000000006
> > +ddq_add_7:
> > +	.octa 0x00000000000000000000000000000007
> > +ddq_add_8:
> > +	.octa 0x00000000000000000000000000000008
> > +
> > +.text
> > +
> > +/* generate a unique variable for ddq_add_x */
> > +
> > +.macro setddq n
> > +	var_ddq_add = DDQ(\n)
> > +.endm
> > +
> > +/* generate a unique variable for xmm register */
> > +.macro setxdata n
> > +	var_xdata = XMM(\n)
> > +.endm
> > +
> > +/* club the numeric 'id' to the symbol 'name' */
> > +
> > +.macro club name, id
> > +.altmacro
> > +	.if \name == DDQ_DATA
> > +		setddq %\id
> > +	.elseif \name == XDATA
> > +		setxdata %\id
> > +	.endif
> > +.noaltmacro
> > +.endm
> > +
> > +/*
> > + * do_aes num_in_par load_keys key_len
> > + * This increments p_in, but not p_out
> > + */
> > +.macro do_aes b, k, key_len
> > +	.set by, \b
> > +	.set load_keys, \k
> > +	.set klen, \key_len
> > +
> > +	.if (load_keys)
> > +		vmovdqa	0*16(p_keys), xkey0
> > +	.endif
> > +
> > +	vpshufb	xbyteswap, xcounter, xdata0
> > +
> > +	.set i, 1
> > +	.rept (by - 1)
> > +		club DDQ_DATA, i
> > +		club XDATA, i
> > +		vpaddd	var_ddq_add(%rip), xcounter, var_xdata
> > +		vpshufb	xbyteswap, var_xdata, var_xdata
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	vmovdqa	1*16(p_keys), xkeyA
> > +
> > +	vpxor	xkey0, xdata0, xdata0
> > +	club DDQ_DATA, by
> > +	vpaddd	var_ddq_add(%rip), xcounter, xcounter
> > +
> > +	.set i, 1
> > +	.rept (by - 1)
> > +		club XDATA, i
> > +		vpxor	xkey0, var_xdata, var_xdata
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	vmovdqa	2*16(p_keys), xkeyB
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		vaesenc	xkeyA, var_xdata, var_xdata		/* key 1 */
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	.if (klen == KEY_128)
> > +		.if (load_keys)
> > +			vmovdqa	3*16(p_keys), xkeyA
> > +		.endif
> > +	.else
> > +		vmovdqa	3*16(p_keys), xkeyA
> > +	.endif
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		vaesenc	xkeyB, var_xdata, var_xdata		/* key 2 */
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	add	$(16*by), p_in
> > +
> > +	.if (klen == KEY_128)
> > +		vmovdqa	4*16(p_keys), xkey4
> > +	.else
> > +		.if (load_keys)
> > +			vmovdqa	4*16(p_keys), xkey4
> > +		.endif
> > +	.endif
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		vaesenc	xkeyA, var_xdata, var_xdata		/* key 3 */
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	vmovdqa	5*16(p_keys), xkeyA
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		vaesenc	xkey4, var_xdata, var_xdata		/* key 4 */
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	.if (klen == KEY_128)
> > +		.if (load_keys)
> > +			vmovdqa	6*16(p_keys), xkeyB
> > +		.endif
> > +	.else
> > +		vmovdqa	6*16(p_keys), xkeyB
> > +	.endif
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		vaesenc	xkeyA, var_xdata, var_xdata		/* key 5 */
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	vmovdqa	7*16(p_keys), xkeyA
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		vaesenc	xkeyB, var_xdata, var_xdata		/* key 6 */
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	.if (klen == KEY_128)
> > +		vmovdqa	8*16(p_keys), xkey8
> > +	.else
> > +		.if (load_keys)
> > +			vmovdqa	8*16(p_keys), xkey8
> > +		.endif
> > +	.endif
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		vaesenc	xkeyA, var_xdata, var_xdata		/* key 7 */
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	.if (klen == KEY_128)
> > +		.if (load_keys)
> > +			vmovdqa	9*16(p_keys), xkeyA
> > +		.endif
> > +	.else
> > +		vmovdqa	9*16(p_keys), xkeyA
> > +	.endif
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		vaesenc	xkey8, var_xdata, var_xdata		/* key 8 */
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	vmovdqa	10*16(p_keys), xkeyB
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		vaesenc	xkeyA, var_xdata, var_xdata		/* key 9 */
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	.if (klen != KEY_128)
> > +		vmovdqa	11*16(p_keys), xkeyA
> > +	.endif
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		/* key 10 */
> > +		.if (klen == KEY_128)
> > +			vaesenclast	xkeyB, var_xdata, var_xdata
> > +		.else
> > +			vaesenc	xkeyB, var_xdata, var_xdata
> > +		.endif
> > +		.set i, (i +1)
> > +	.endr
> > +
> > +	.if (klen != KEY_128)
> > +		.if (load_keys)
> > +			vmovdqa	12*16(p_keys), xkey12
> > +		.endif
> > +
> > +		.set i, 0
> > +		.rept by
> > +			club XDATA, i
> > +			vaesenc	xkeyA, var_xdata, var_xdata	/* key 11 */
> > +			.set i, (i +1)
> > +		.endr
> > +
> > +		.if (klen == KEY_256)
> > +			vmovdqa	13*16(p_keys), xkeyA
> > +		.endif
> > +
> > +		.set i, 0
> > +		.rept by
> > +			club XDATA, i
> > +			.if (klen == KEY_256)
> > +				/* key 12 */
> > +				vaesenc	xkey12, var_xdata, var_xdata
> > +			.else
> > +				vaesenclast xkey12, var_xdata, var_xdata
> > +			.endif
> > +			.set i, (i +1)
> > +		.endr
> > +
> > +		.if (klen == KEY_256)
> > +			vmovdqa	14*16(p_keys), xkeyB
> > +
> > +			.set i, 0
> > +			.rept by
> > +				club XDATA, i
> > +				/* key 13 */
> > +				vaesenc	xkeyA, var_xdata, var_xdata
> > +				.set i, (i +1)
> > +			.endr
> > +
> > +			.set i, 0
> > +			.rept by
> > +				club XDATA, i
> > +				/* key 14 */
> > +				vaesenclast	xkeyB, var_xdata, var_xdata
> > +				.set i, (i +1)
> > +			.endr
> > +		.endif
> > +	.endif
> > +
> > +	.set i, 0
> > +	.rept (by / 2)
> > +		.set j, (i+1)
> > +		VMOVDQ	(i*16 - 16*by)(p_in), xkeyA
> > +		VMOVDQ	(j*16 - 16*by)(p_in), xkeyB
> > +		club XDATA, i
> > +		vpxor	xkeyA, var_xdata, var_xdata
> > +		club XDATA, j
> > +		vpxor	xkeyB, var_xdata, var_xdata
> > +		.set i, (i+2)
> > +	.endr
> > +
> > +	.if (i < by)
> > +		VMOVDQ	(i*16 - 16*by)(p_in), xkeyA
> > +		club XDATA, i
> > +		vpxor	xkeyA, var_xdata, var_xdata
> > +	.endif
> > +
> > +	.set i, 0
> > +	.rept by
> > +		club XDATA, i
> > +		VMOVDQ	var_xdata, i*16(p_out)
> > +		.set i, (i+1)
> > +	.endr
> > +.endm
> > +
> > +.macro do_aes_load val, key_len
> > +	do_aes \val, 1, \key_len
> > +.endm
> > +
> > +.macro do_aes_noload val, key_len
> > +	do_aes \val, 0, \key_len
> > +.endm
> > +
> > +/* main body of aes ctr load */
> > +
> > +.macro do_aes_ctrmain key_len
> > +
> > +	cmp	$16, num_bytes
> > +	jb	.Ldo_return2\key_len
> > +
> > +	vmovdqa	byteswap_const(%rip), xbyteswap
> > +	vmovdqu	(p_iv), xcounter
> > +	vpshufb	xbyteswap, xcounter, xcounter
> > +
> > +	mov	num_bytes, tmp
> > +	and	$(7*16), tmp
> > +	jz	.Lmult_of_8_blks\key_len
> > +
> > +	/* 1 <= tmp <= 7 */
> > +	cmp	$(4*16), tmp
> > +	jg	.Lgt4\key_len
> > +	je	.Leq4\key_len
> > +
> > +.Llt4\key_len:
> > +	cmp	$(2*16), tmp
> > +	jg	.Leq3\key_len
> > +	je	.Leq2\key_len
> > +
> > +.Leq1\key_len:
> > +	do_aes_load	1, \key_len
> > +	add	$(1*16), p_out
> > +	and	$(~7*16), num_bytes
> > +	jz	.Ldo_return2\key_len
> > +	jmp	.Lmain_loop2\key_len
> > +
> > +.Leq2\key_len:
> > +	do_aes_load	2, \key_len
> > +	add	$(2*16), p_out
> > +	and	$(~7*16), num_bytes
> > +	jz	.Ldo_return2\key_len
> > +	jmp	.Lmain_loop2\key_len
> > +
> > +
> > +.Leq3\key_len:
> > +	do_aes_load	3, \key_len
> > +	add	$(3*16), p_out
> > +	and	$(~7*16), num_bytes
> > +	jz	.Ldo_return2\key_len
> > +	jmp	.Lmain_loop2\key_len
> > +
> > +.Leq4\key_len:
> > +	do_aes_load	4, \key_len
> > +	add	$(4*16), p_out
> > +	and	$(~7*16), num_bytes
> > +	jz	.Ldo_return2\key_len
> > +	jmp	.Lmain_loop2\key_len
> > +
> > +.Lgt4\key_len:
> > +	cmp	$(6*16), tmp
> > +	jg	.Leq7\key_len
> > +	je	.Leq6\key_len
> > +
> > +.Leq5\key_len:
> > +	do_aes_load	5, \key_len
> > +	add	$(5*16), p_out
> > +	and	$(~7*16), num_bytes
> > +	jz	.Ldo_return2\key_len
> > +	jmp	.Lmain_loop2\key_len
> > +
> > +.Leq6\key_len:
> > +	do_aes_load	6, \key_len
> > +	add	$(6*16), p_out
> > +	and	$(~7*16), num_bytes
> > +	jz	.Ldo_return2\key_len
> > +	jmp	.Lmain_loop2\key_len
> > +
> > +.Leq7\key_len:
> > +	do_aes_load	7, \key_len
> > +	add	$(7*16), p_out
> > +	and	$(~7*16), num_bytes
> > +	jz	.Ldo_return2\key_len
> > +	jmp	.Lmain_loop2\key_len
> > +
> > +.Lmult_of_8_blks\key_len:
> > +	.if (\key_len != KEY_128)
> > +		vmovdqa	0*16(p_keys), xkey0
> > +		vmovdqa	4*16(p_keys), xkey4
> > +		vmovdqa	8*16(p_keys), xkey8
> > +		vmovdqa	12*16(p_keys), xkey12
> > +	.else
> > +		vmovdqa	0*16(p_keys), xkey0
> > +		vmovdqa	3*16(p_keys), xkey4
> > +		vmovdqa	6*16(p_keys), xkey8
> > +		vmovdqa	9*16(p_keys), xkey12
> > +	.endif
> 
> You might want to align the main loop, e.g. add '.align 4' or even
> '.align 16' here.

Ok.

> 
> > +.Lmain_loop2\key_len:
> > +	/* num_bytes is a multiple of 8 and >0 */
> > +	do_aes_noload	8, \key_len
> > +	add	$(8*16), p_out
> > +	sub	$(8*16), num_bytes
> > +	jne	.Lmain_loop2\key_len
> > +
> > +.Ldo_return2\key_len:
> > +	/* return updated IV */
> > +	vpshufb	xbyteswap, xcounter, xcounter
> > +	vmovdqu	xcounter, (p_iv)
> > +	ret
> > +.endm
> > +
> > +/*
> > + * routine to do AES128 CTR enc/decrypt "by8"
> > + * XMM registers are clobbered.
> > + * Saving/restoring must be done at a higher level
> > + * aes_ctr_enc_128_avx_by8(void *in, void *iv, void *keys, void *out,
> > + *			unsigned int num_bytes)
> > + */
> > +ENTRY(aes_ctr_enc_128_avx_by8)
> > +	/* call the aes main loop */
> > +	do_aes_ctrmain KEY_128
> > +
> > +ENDPROC(aes_ctr_enc_128_avx_by8)
> > +
> > +/*
> > + * routine to do AES192 CTR enc/decrypt "by8"
> > + * XMM registers are clobbered.
> > + * Saving/restoring must be done at a higher level
> > + * aes_ctr_enc_192_avx_by8(void *in, void *iv, void *keys, void *out,
> > + *			unsigned int num_bytes)
> > + */
> > +ENTRY(aes_ctr_enc_192_avx_by8)
> > +	/* call the aes main loop */
> > +	do_aes_ctrmain KEY_192
> > +
> > +ENDPROC(aes_ctr_enc_192_avx_by8)
> > +
> > +/*
> > + * routine to do AES256 CTR enc/decrypt "by8"
> > + * XMM registers are clobbered.
> > + * Saving/restoring must be done at a higher level
> > + * aes_ctr_enc_256_avx_by8(void *in, void *iv, void *keys, void *out,
> > + *			unsigned int num_bytes)
> > + */
> > +ENTRY(aes_ctr_enc_256_avx_by8)
> > +	/* call the aes main loop */
> > +	do_aes_ctrmain KEY_256
> > +
> > +ENDPROC(aes_ctr_enc_256_avx_by8)
> > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > index 948ad0e..b06e20f 100644
> > --- a/arch/x86/crypto/aesni-intel_glue.c
> > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > @@ -105,6 +105,9 @@ void crypto_fpu_exit(void);
> >  #define AVX_GEN4_OPTSIZE 4096
> >  
> >  #ifdef CONFIG_X86_64
> > +
> > +static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
> > +			      const u8 *in, unsigned int len, u8 *iv);
> >  asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
> >  			      const u8 *in, unsigned int len, u8 *iv);
> >  
> > @@ -154,6 +157,15 @@ asmlinkage void aesni_gcm_dec(void *ctx, u8 *out,
> >  			u8 *auth_tag, unsigned long auth_tag_len);
> >  
> > 
> 
> > +#if defined(CONFIG_AS_AVX)
> > +asmlinkage void aes_ctr_enc_128_avx_by8(const u8 *in, u8 *iv,
> > +		void *keys, u8 *out, unsigned int num_bytes);
> > +asmlinkage void aes_ctr_enc_192_avx_by8(const u8 *in, u8 *iv,
> > +		void *keys, u8 *out, unsigned int num_bytes);
> > +asmlinkage void aes_ctr_enc_256_avx_by8(const u8 *in, u8 *iv,
> > +		void *keys, u8 *out, unsigned int num_bytes);
> > +#endif
> > +
> 
> Move that code below the following #ifdef. No need to introduce yet
> another ifdef of the very same symbol.

Got it. Will do.

> 
> >  #ifdef CONFIG_AS_AVX
> >  /*
> >   * asmlinkage void aesni_gcm_precomp_avx_gen2()
> > @@ -472,6 +484,25 @@ static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
> >  	crypto_inc(ctrblk, AES_BLOCK_SIZE);
> >  }
> >  
> > +#if defined(CONFIG_AS_AVX)
> 
> Please use '#ifdef CONFIG_AS_AVX' for simple preprocessor tests. That's
> easier to read and makes it consistent with the rest of the code in that
> file.

Will do.

> 
> > +static void aesni_ctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
> > +			      const u8 *in, unsigned int len, u8 *iv)
> > +{
> > +	/*
> > +	 * based on key length, override with the by8 version
> > +	 * of ctr mode encryption/decryption for improved performance
> > +	 */
> > +	if (ctx->key_length == AES_KEYSIZE_128)
> > +		aes_ctr_enc_128_avx_by8(in, iv, (void *)ctx, out, len);
> > +	else if (ctx->key_length == AES_KEYSIZE_192)
> > +		aes_ctr_enc_192_avx_by8(in, iv, (void *)ctx, out, len);
> > +	else if (ctx->key_length == AES_KEYSIZE_256)
> > +		aes_ctr_enc_256_avx_by8(in, iv, (void *)ctx, out, len);
> 
> > +	else
> > +		aesni_ctr_enc(ctx, out, in, len, iv);
> 
> How would that last case even be possible? aes_set_key_common() does
> only allow the above three key lengths. How would we end up here with a
> key length not being one of AES_KEYSIZE_128, AES_KEYSIZE_192 or
> AES_KEYSIZE_256?

Good point. I wondered if in case... I will just note that other key
lengths are out of question.
 
> 
> > +}
> > +#endif
> > +
> >  static int ctr_crypt(struct blkcipher_desc *desc,
> >  		     struct scatterlist *dst, struct scatterlist *src,
> >  		     unsigned int nbytes)
> > @@ -486,7 +517,7 @@ static int ctr_crypt(struct blkcipher_desc *desc,
> >  
> >  	kernel_fpu_begin();
> >  	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
> > -		aesni_ctr_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
> > +		aesni_ctr_enc_tfm(ctx, walk.dst.virt.addr, walk.src.virt.addr,
> >  			      nbytes & AES_BLOCK_MASK, walk.iv);
> 
> Nitpick, but re-indent to one space after the parenthesis, please.
> 

Ok, I will fix it.

> >  		nbytes &= AES_BLOCK_SIZE - 1;
> >  		err = blkcipher_walk_done(desc, &walk, nbytes);
> > @@ -1493,6 +1524,14 @@ static int __init aesni_init(void)
> >  		aesni_gcm_enc_tfm = aesni_gcm_enc;
> >  		aesni_gcm_dec_tfm = aesni_gcm_dec;
> >  	}
> > +	aesni_ctr_enc_tfm = aesni_ctr_enc;
> 
> > +#if defined(CONFIG_AS_AVX)
> 
> Make that an #ifdef CONFIG_AS_AVX
> 
> > +	if (boot_cpu_has(X86_FEATURE_AES) && boot_cpu_has(X86_FEATURE_AVX)) {
> 
> The test for X86_FEATURE_AES is already done a few lines before in the
> x86_match_cpu() check. No need to duplicate it here. Therefore you can
> reduce that test to 'if (boot_cpu_has(X86_FEATURE_AVX))' or even shorter
> to 'if (cpu_has_avx))' as X86_FEATURE_AVX has a convenience macro for
> that test.

Ok, I will fix it.

> 
> > +		/* optimize performance of ctr mode encryption trasform */
>                                                                transform
> > +		aesni_ctr_enc_tfm = aesni_ctr_enc_avx_tfm;
> > +		pr_info("AES CTR mode optimization enabled\n");
> 
> If you're emitting a message it should also say, which kind of
> optimization. In this case something like the following might be
> appropriate: "AVX CTR mode optimization enabled".
> 

Ok, I will fix it.

> > +	}
> > +#endif
> >  #endif
> >  
> >  	err = crypto_fpu_init();
> 
> Regards,
> Mathias
> 

Thanks for the review. I will fix these suggestions, and post another
patch.
- mouli
> > -- 
> > 1.8.2.1
> > 
> > 
