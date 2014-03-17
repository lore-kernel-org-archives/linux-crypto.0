From: chandramouli narayanan <mouli@linux.intel.com>
Subject: Re: [PATCH 2/2] SHA1 transform: x86_64 AVX2 optimization - glue &
 build-v2
Date: Mon, 17 Mar 2014 12:09:18 -0700
Message-ID: <1395083358.7495.156.camel@pegasus.jf.intel.com>
References: <1394650070.7495.134.camel@pegasus.jf.intel.com>
	 <201403171706.24782.marex@denx.de>
	 <1395075232.7495.148.camel@pegasus.jf.intel.com>
	 <201403171911.55005.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, hpa@zytor.com,
	ilya.albrekht@intel.com, maxim.locktyukhin@intel.com,
	ronen.zohar@intel.com, wajdi.k.feghali@intel.com,
	tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5738 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaCQTIu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Mar 2014 15:08:50 -0400
In-Reply-To: <201403171911.55005.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2014-03-17 at 19:11 +0100, Marek Vasut wrote:
> On Monday, March 17, 2014 at 05:53:52 PM, chandramouli narayanan wrote:
> > On Mon, 2014-03-17 at 17:06 +0100, Marek Vasut wrote:
> > > On Monday, March 17, 2014 at 04:53:12 PM, chandramouli narayanan wrote:
> > > > On Fri, 2014-03-14 at 06:40 +0100, Marek Vasut wrote:
> > > > > On Wednesday, March 12, 2014 at 07:47:50 PM, chandramouli narayanan 
> wrote:
> > > > > > This git patch adds the glue, build and configuration changes
> > > > > > to include x86_64 AVX2 optimization of SHA1 transform to
> > > > > > crypto support. The patch has been tested with 3.14.0-rc1
> > > > > > kernel.
> > > > > > 
> > > > > > Changes from the initial version of this patch are in
> > > > > > a) check for BMI2 in addition to AVX2 support since
> > > > > > __sha1_transform_avx2() uses rorx
> > > > > > b) Since the module build has dependency on 64bit, it is
> > > > > > redundant to check it in the code here.
> > > > > > 
> > > > > > On a Haswell desktop, with turbo disabled and all cpus running
> > > > > > at maximum frequency, tcrypt shows AVX2 performance improvement
> > > > > > from 3% for 256 bytes update to 16% for 1024 bytes update over
> > > > > > AVX implementation.
> > > > > > 
> > > > > > Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> > > > > > 
> > > > > > diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> > > > > > index 6ba54d6..61d6e28 100644
> > > > > > --- a/arch/x86/crypto/Makefile
> > > > > > +++ b/arch/x86/crypto/Makefile
> > > > > > @@ -79,6 +79,9 @@ aesni-intel-y := aesni-intel_asm.o
> > > > > > aesni-intel_glue.o fpu.o aesni-intel-$(CONFIG_64BIT) +=
> > > > > > aesni-intel_avx-x86_64.o
> > > > > > 
> > > > > >  ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o
> > > > > > 
> > > > > > ghash-clmulni-intel_glue.o sha1-ssse3-y := sha1_ssse3_asm.o
> > > > > > sha1_ssse3_glue.o
> > > > > > +ifeq ($(avx2_supported),yes)
> > > > > > +sha1-ssse3-y += sha1_avx2_x86_64_asm.o
> > > > > 
> > > > > Use:
> > > > > 
> > > > > sha1-ssse3-$(CONFIG_AS_AVX2) += sha1_avx2_x86_64_asm.o
> > > > > 
> > > > > And you will not need the CONFIG_AS_AVX2 ifdef in your previous
> > > > > patch, no ? [...]
> > > > > Best regards,
> > > > > Marek Vasut
> > > > 
> > > > Sorry for the delayed reply. Agreed, I will fix the dependency.
> > > 
> > > No problem, thanks!
> > > 
> > > Best regards,
> > > Marek Vasut
> > 
> > On second thoughts, with sha1-sse3-(CONFIG_AS_AVX2) +=
> > sha1_avx2_x86_64_asm.o, I have build issues and sha1_transform_avx2
> > undefined in sha1-sss3.ko.
> > 
> > I can rid #ifdef CONFIG_AS_AVX2 in patch1. The following works though:
> > ifeq ($(avx2_supported),yes)
> > sha1-ssse3-y += sha1_avx2_x86_64_asm.o
> > endif
> 
> Looking throughout the arch/x86/crypto/Makefile , this sha1-ssse3.o thing is a 
> bit odd I think. Why exactly does this not follow suit with the camellia or 
> serpent ciphers ? I mean, look at their build rules, they handle all of 
> SSE2/AVX/AVX2 implementation and it's build. Can we not clean up the SHA1-SSSE3 
> to do exactly the same ? But please note I might be just plain wrong and if 
> that's the case, let me know ;-)
I appended AVX2 support to the existing sha1_ssse3_glue. I will see if
it can be cleaned up. 
> 
> btw. I noticed another nit in the code. You use __sha1_transform_avx2() , but 
> there previous function using AVX1 is called sha1_transform_avx() . Drop those 
> two underscores please for consistency's sake.
> 
__sha1_transform_avx2() is merely an internal inline function. The code
patch picks sha1_transform_avx() or sha1_transform_avx2() depending on
the datablock size (based on the results from running tcrypt). 
 
> Thanks!
> 
> Best regards,
> Marek Vasut

thanks
- mouli
