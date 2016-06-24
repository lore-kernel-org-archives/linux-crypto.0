From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: rsa - Do not gratuitously drop leading zeroes
Date: Fri, 24 Jun 2016 16:41:47 +0800
Message-ID: <20160624084147.GB18603@gondor.apana.org.au>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <733379976.TmXhNiYQ9x@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44802 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbcFXIl7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 04:41:59 -0400
Content-Disposition: inline
In-Reply-To: <733379976.TmXhNiYQ9x@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 09:27:12AM +0200, Stephan Mueller wrote:
> Am Mittwoch, 22. Juni 2016, 18:14:32 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> Something breaks with this patch set in public_key_verify_signature
> 
> I get tons of these:
> 
> [    1.838720] PKCS#7 signature not signed with a trusted key
> 
> 
> Furthermore, my CAVS testing with public_key_verify_signature always EINVAL.
> 
> SigGen using the kernel crypto API interfaces work though.

Hi Stephan:

Can you bisect this down to a specific patch please?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
