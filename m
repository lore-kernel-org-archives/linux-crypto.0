From: chandramouli narayanan <mouli@linux.intel.com>
Subject: Re: [PATCH 1/2] SHA1 transform: x86_64 AVX2 optimization -
 assembly code-v2
Date: Mon, 17 Mar 2014 08:59:37 -0700
Message-ID: <1395071977.7495.142.camel@pegasus.jf.intel.com>
References: <1394650063.7495.133.camel@pegasus.jf.intel.com>
	 <201403140634.40045.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, hpa@zytor.com,
	ilya.albrekht@intel.com, maxim.locktyukhin@intel.com,
	ronen.zohar@intel.com, wajdi.k.feghali@intel.com,
	tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbaCQP6w (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Mar 2014 11:58:52 -0400
In-Reply-To: <201403140634.40045.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2014-03-14 at 06:34 +0100, Marek Vasut wrote:
> On Wednesday, March 12, 2014 at 07:47:43 PM, chandramouli narayanan wrote:
> > This git patch adds x86_64 AVX2 optimization of SHA1 transform
> > to crypto support. The patch has been tested with 3.14.0-rc1
> > kernel.
> > 
> > On a Haswell desktop, with turbo disabled and all cpus running
> > at maximum frequency, tcrypt shows AVX2 performance improvement
> > from 3% for 256 bytes update to 16% for 1024 bytes update over
> > AVX implementation.
> > 
> > Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> > 
> > diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
> > b/arch/x86/crypto/sha1_avx2_x86_64_asm.S new file mode 100644
> > index 0000000..2f71294
> > --- /dev/null
> > +++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
> > @@ -0,0 +1,732 @@
> > +/*
> > +	Implement fast SHA-1 with AVX2 instructions. (x86_64)
> > +
> > +  This file is provided under a dual BSD/GPLv2 license.  When using or
> > +  redistributing this file, you may do so under either license.
> > +
> > +  GPL LICENSE SUMMARY
> 
> Please see Documentation/CodingStyle chapter 8 for the preffered comment style.
> 
I will fix the coding style issues.

> [...]
> 
> > +*/
> > +
> > +#---------------------
> > +#
> > +#SHA-1 implementation with Intel(R) AVX2 instruction set extensions.
> 
> DTTO here.
> 
I will fix style issues.

> > +#This implementation is based on the previous SSSE3 release:
> > +#Visit http://software.intel.com/en-us/articles/
> > +#and refer to improving-the-performance-of-the-secure-hash-algorithm-1/
> > +#
> > +#Updates 20-byte SHA-1 record in 'hash' for even number of
> > +#'num_blocks' consecutive 64-byte blocks
> > +#
> > +#extern "C" void sha1_transform_avx2(
> > +#	int *hash, const char* input, size_t num_blocks );
> > +#
> > +
> > +#ifdef CONFIG_AS_AVX2
> 
> I wonder, is this large #ifdef around the entire file needed here? Can you not 
> just handle not-compiling this file in in the Makefile ?
> 
> [...]
> 
> > +        push %rbx
> > +        push %rbp
> > +        push %r12
> > +        push %r13
> > +        push %r14
> > +        push %r15
> > +	#FIXME: Save rsp
> > +
> > +        RESERVE_STACK  = (W_SIZE*4 + 8+24)
> > +
> > +        # Align stack
> > +        mov     %rsp, %rbx
> > +        and     $(0x1000-1), %rbx
> > +        sub     $(8+32), %rbx
> > +        sub     %rbx, %rsp
> > +        push    %rbx
> > +        sub     $RESERVE_STACK, %rsp
> > +
> > +        avx2_zeroupper
> > +
> > +	lea	K_XMM_AR(%rip), K_BASE
> 
> Can you please use TABs for indent consistently (see the CodingStyle again) ?
> 
Agreed.

> [...]
> 
> > +    .align 32
> > +    _loop:
> > +	# code loops through more than one block
> > +	# we use K_BASE value as a signal of a last block,
> > +	# it is set below by: cmovae BUFFER_PTR, K_BASE
> > +        cmp K_BASE, BUFFER_PTR
> > +        jne _begin
> > +    .align 32
> > +        jmp _end
> > +    .align 32
> > +    _begin:
> > +
> > +        # Do first block
> > +        RR 0
> > +        RR 2
> > +        RR 4
> > +        RR 6
> > +        RR 8
> > +
> > +        jmp _loop0
> > +_loop0:
> > +
> > +        RR 10
> > +        RR 12
> > +        RR 14
> > +        RR 16
> > +        RR 18
> > +
> > +        RR 20
> > +        RR 22
> > +        RR 24
> > +        RR 26
> > +        RR 28
> 
> Can you not generate these repeated sequences with some of the AS's macro voodoo 
> ? Like .rept or somesuch ?
> 
Will incorporate a .rept.

> [...]
> 
> > +.macro UPDATE_HASH  hash, val
> > +	add	\hash, \val
> > +	mov	\val, \hash
> > +.endm
> 
> This macro is defined below the point where it's used, which is a little 
> counter-intuitive.
> [...]
> 
Will reorganize.

> > +
> > +/* AVX2 optimized implementation:
> > + *   extern "C" void sha1_transform_avx2(
> > + *	int *hash, const char* input, size_t num_blocks );
> 
> What does this comment tell me ?
> 
> btw. you might want to squash 1/2 and 2/2 , since they are not two logical 
> separate blocks I think.
In summary, I will fix these issues, retest and post the next version.

thanks,
- mouli
