From: chandramouli narayanan <mouli@linux.intel.com>
Subject: Re: [PATCH 2/2] SHA1 transform: x86_64 AVX2 optimization - glue &
 build - resend with email correction
Date: Thu, 27 Feb 2014 12:12:25 -0800
Message-ID: <1393531945.7495.101.camel@pegasus.jf.intel.com>
References: <1393522926.7495.97.camel@pegasus.jf.intel.com>
	 <530F9050.9080006@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, hpa@zytor.com,
	ilya.albrekht@intel.com, maxim.locktyukhin@intel.com,
	ronen.zohar@intel.com, wajdi.k.feghali@intel.com,
	tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2972 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaB0ULo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Feb 2014 15:11:44 -0500
In-Reply-To: <530F9050.9080006@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2014-02-27 at 21:21 +0200, Jussi Kivilinna wrote:
> On 27.02.2014 19:42, chandramouli narayanan wrote:
> > This git patch adds the glue, build and configuration changes
> > to include x86_64 AVX2 optimization of SHA1 transform to
> > crypto support. The patch has been tested with 3.14.0-rc1
> > kernel.
> > 
> > On a Haswell desktop, with turbo disabled and all cpus running
> > at maximum frequency, tcrypt shows AVX2 performance improvement
> > from 3% for 256 bytes update to 16% for 1024 bytes update over
> > AVX implementation. 
> > 
> > Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> > 
> <..snip..>
> >  static int __init sha1_ssse3_mod_init(void)
> >  {
> > +	char *algo_name;
> >  	/* test for SSSE3 first */
> > -	if (cpu_has_ssse3)
> > +	if (cpu_has_ssse3) {
> >  		sha1_transform_asm = sha1_transform_ssse3;
> > +		algo_name = "SSSE3";
> > +	}
> >  
> >  #ifdef CONFIG_AS_AVX
> >  	/* allow AVX to override SSSE3, it's a little faster */
> > -	if (avx_usable())
> > -		sha1_transform_asm = sha1_transform_avx;
> > +	if (avx_usable()) {
> > +		if (cpu_has_avx) {
> > +			sha1_transform_asm = sha1_transform_avx;
> > +			algo_name = "AVX";
> > +		}
> > +#ifdef CONFIG_AS_AVX2
> > +		if (cpu_has_avx2) {
> 
> Wouldn't you need to check also for BMI2 as __sha1_transform_avx2 uses 'rorx'?
> 
> For example, commit 16c0c4e1656c14ef9deac189a4240b5ca19c6919 added BMI2 check for SHA-256.
> 
> -Jussi

Good catch! I will add the check for AVX and BMI2.
- mouli

> 
> > +			/* allow AVX2 to override AVX, it's a little faster */
> > +			sha1_transform_asm = __sha1_transform_avx2;
> > +			algo_name = "AVX2";
> > +		}
> > +#endif
> > +	}
> >  #endif
