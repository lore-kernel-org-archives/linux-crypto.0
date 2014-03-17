From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] SHA1 transform: x86_64 AVX2 optimization - glue &
 build-v2
Date: Mon, 17 Mar 2014 11:37:23 -0700
Message-ID: <532740E3.7020600@zytor.com>
References: <1394650070.7495.134.camel@pegasus.jf.intel.com>	 <201403140640.26153.marex@denx.de>	 <1395071592.7495.136.camel@pegasus.jf.intel.com>	 <201403171706.24782.marex@denx.de> <1395075232.7495.148.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	ilya.albrekht@intel.com, maxim.locktyukhin@intel.com,
	ronen.zohar@intel.com, wajdi.k.feghali@intel.com,
	tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org
To: chandramouli narayanan <mouli@linux.intel.com>,
	Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:37840 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060AbaCQShs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Mar 2014 14:37:48 -0400
In-Reply-To: <1395075232.7495.148.camel@pegasus.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/17/2014 09:53 AM, chandramouli narayanan wrote:
> On second thoughts, with sha1-sse3-(CONFIG_AS_AVX2) +=
> sha1_avx2_x86_64_asm.o, I have build issues and sha1_transform_avx2
> undefined in sha1-sss3.ko. 
> 
> I can rid #ifdef CONFIG_AS_AVX2 in patch1. The following works though:
> ifeq ($(avx2_supported),yes)
> sha1-ssse3-y += sha1_avx2_x86_64_asm.o
> endif

Yes, the sad thing is that the CONFIG_AS_* things aren't real config
symbols, despite the name.  They might be in the future when Kconfig can
run test probes (something we have needed for a very long time.)

The "yes" versus "y", though, is a total faceplant.

	-hpa
