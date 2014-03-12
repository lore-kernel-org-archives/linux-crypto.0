From: chandramouli narayanan <mouli@linux.intel.com>
Subject: Re: [PATCH 1/2] SHA1 transform: x86_64 AVX2 optimization -
 assembly code
Date: Wed, 12 Mar 2014 11:47:01 -0700
Message-ID: <1394650021.7495.132.camel@pegasus.jf.intel.com>
References: <1393520815.7495.88.camel@pegasus.jf.intel.com>
	 <20140310121528.GA10149@gondor.apana.org.au>
	 <1394647328.7495.117.camel@pegasus.jf.intel.com>
	 <20140312180408.GA32286@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, hpa@zytor.com, ilya.albrekht@intel.com,
	maxim.locktyukhin@intel.com, ronen.zohar@intel.com,
	wajdi.k.feghali@intel.com, tim.c.chen@linux.intel.com,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaCLSqi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Mar 2014 14:46:38 -0400
In-Reply-To: <20140312180408.GA32286@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2014-03-13 at 02:04 +0800, Herbert Xu wrote:
> On Wed, Mar 12, 2014 at 11:02:08AM -0700, chandramouli narayanan wrote:
> > On Mon, 2014-03-10 at 20:15 +0800, Herbert Xu wrote:
> > > On Thu, Feb 27, 2014 at 09:06:55AM -0800, chandramouli narayanan wrote:
> > > > This git patch adds x86_64 AVX2 optimization of SHA1 transform
> > > > to crypto support. The patch has been tested with 3.14.0-rc1
> > > > kernel.
> > > > 
> > > > On a Haswell desktop, with turbo disabled and all cpus running
> > > > at maximum frequency, tcrypt shows AVX2 performance improvement
> > > > from 3% for 256 bytes update to 16% for 1024 bytes update over
> > > > AVX implementation. 
> > > > 
> > > > Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> > > 
> > > Sorry but your patch is corrupted:
> > > 
> > > Applying: crypto: sha1 - x86_64 AVX2 optimization - assembly code
> > > fatal: corrupt patch at line 160
> > > Patch failed at 0012 crypto: sha1 - x86_64 AVX2 optimization - assembly code
> > > 
> > > Please test by applying the patch from your own email.
> > > 
> > > Thanks,
> > Sorry, it didn't apply for you. I tested before sending it. I will
> > retest and send both patches today.
> 
> Please test by trying to apply the patch that you get back from
> the mailing list.
> 
> Cheers,
My apologies. Yes, there was a breakage in the patch sent out. I will
send them again.
- mouli
