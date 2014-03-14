From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/2] SHA1 transform: x86_64 AVX2 optimization - glue & build-v2
Date: Fri, 14 Mar 2014 06:40:26 +0100
Message-ID: <201403140640.26153.marex@denx.de>
References: <1394650070.7495.134.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, hpa@zytor.com,
	ilya.albrekht@intel.com, maxim.locktyukhin@intel.com,
	ronen.zohar@intel.com, wajdi.k.feghali@intel.com,
	tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org
To: chandramouli narayanan <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:36899 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaCNFkf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Mar 2014 01:40:35 -0400
In-Reply-To: <1394650070.7495.134.camel@pegasus.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, March 12, 2014 at 07:47:50 PM, chandramouli narayanan wrote:
> This git patch adds the glue, build and configuration changes
> to include x86_64 AVX2 optimization of SHA1 transform to
> crypto support. The patch has been tested with 3.14.0-rc1
> kernel.
> 
> Changes from the initial version of this patch are in
> a) check for BMI2 in addition to AVX2 support since
> __sha1_transform_avx2() uses rorx
> b) Since the module build has dependency on 64bit, it is
> redundant to check it in the code here.
> 
> On a Haswell desktop, with turbo disabled and all cpus running
> at maximum frequency, tcrypt shows AVX2 performance improvement
> from 3% for 256 bytes update to 16% for 1024 bytes update over
> AVX implementation.
> 
> Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> 
> diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> index 6ba54d6..61d6e28 100644
> --- a/arch/x86/crypto/Makefile
> +++ b/arch/x86/crypto/Makefile
> @@ -79,6 +79,9 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
> fpu.o aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o
>  ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o
> ghash-clmulni-intel_glue.o sha1-ssse3-y := sha1_ssse3_asm.o
> sha1_ssse3_glue.o
> +ifeq ($(avx2_supported),yes)
> +sha1-ssse3-y += sha1_avx2_x86_64_asm.o

Use:

sha1-ssse3-$(CONFIG_AS_AVX2) += sha1_avx2_x86_64_asm.o

And you will not need the CONFIG_AS_AVX2 ifdef in your previous patch, no ?
[...]
Best regards,
Marek Vasut
