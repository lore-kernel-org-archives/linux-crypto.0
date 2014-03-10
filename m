From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] SHA1 transform: x86_64 AVX2 optimization - assembly
 code
Date: Mon, 10 Mar 2014 20:15:28 +0800
Message-ID: <20140310121528.GA10149@gondor.apana.org.au>
References: <1393520815.7495.88.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, hpa@zytor.com, ilya.albrekht@intel.com,
	maxim.locktyukhin@intel.com, ronen.zohar@intel.com,
	wajdi.k.feghali@intel.com, tim.c.chen@linux.intel.com,
	linux-crypto@vger.kernel.org
To: chandramouli narayanan <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:40310 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaCJMPp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Mar 2014 08:15:45 -0400
Content-Disposition: inline
In-Reply-To: <1393520815.7495.88.camel@pegasus.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 27, 2014 at 09:06:55AM -0800, chandramouli narayanan wrote:
> This git patch adds x86_64 AVX2 optimization of SHA1 transform
> to crypto support. The patch has been tested with 3.14.0-rc1
> kernel.
> 
> On a Haswell desktop, with turbo disabled and all cpus running
> at maximum frequency, tcrypt shows AVX2 performance improvement
> from 3% for 256 bytes update to 16% for 1024 bytes update over
> AVX implementation. 
> 
> Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>

Sorry but your patch is corrupted:

Applying: crypto: sha1 - x86_64 AVX2 optimization - assembly code
fatal: corrupt patch at line 160
Patch failed at 0012 crypto: sha1 - x86_64 AVX2 optimization - assembly code

Please test by applying the patch from your own email.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
