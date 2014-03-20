From: chandramouli narayanan <mouli@linux.intel.com>
Subject: Re: [PATCH v6 1/1] crypto: SHA1 transform x86_64 AVX2
Date: Thu, 20 Mar 2014 15:51:01 -0700
Message-ID: <1395355861.2367.57.camel@pegasus.jf.intel.com>
References: <1395353640.2367.56.camel@pegasus.jf.intel.com>
	 <201403202324.17029.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Ilya Albrekht <ilya.albrekht@intel.com>,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
	Ronen Zohar <ronen.zohar@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759940AbaCTWuk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Mar 2014 18:50:40 -0400
In-Reply-To: <201403202324.17029.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2014-03-20 at 23:24 +0100, Marek Vasut wrote:
> On Thursday, March 20, 2014 at 11:14:00 PM, chandramouli narayanan wrote:
> > This git patch adds x86_64 AVX2 optimization of SHA1
> > transform to crypto support. The patch has been tested with 3.14.0-rc1
> > kernel.
> > 
> > On a Haswell desktop, with turbo disabled and all cpus running
> > at maximum frequency, tcrypt shows AVX2 performance improvement
> > from 3% for 256 bytes update to 16% for 1024 bytes update over
> > AVX implementation.
> > 
> > This patch adds sha1_avx2_transform(), the glue, build and
> > configuration changes needed for AVX2 optimization of
> > SHA1 transform to crypto support.
> > 
> > sha1-ssse3 is one module which adds the necessary optimization
> > support (SSSE3/AVX/AVX2) for the low-level SHA1 transform function.
> > With better optimization support, transform function is overridden
> > as the case may be. In the case of AVX2, due to performance reasons
> > across datablock sizes, the AVX or AVX2 transform function is used
> > at run-time as it suits best. The Makefile change therefore appends
> > the necessary objects to the linkage. Due to this, the patch merely
> > appends AVX2 transform to the existing build mix and Kconfig support
> > and leaves the configuration build support as is.
> > 
> > Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> 
> Very nice, good job. Thank you!
> 
> Reviewed-by: Marek Vasut <marex@denx.de>
> 
> Best regards,
> Marek Vasut

Thank you for reviewing the churn of patches!
Best regards,
- mouli
