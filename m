From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG broken?
Date: Tue, 9 Aug 2016 15:14:02 +0800
Message-ID: <20160809071402.GA5466@gondor.apana.org.au>
References: <20160808181117.GD1041@n2100.armlinux.org.uk>
 <20160809031820.GA4142@gondor.apana.org.au>
 <20160809070859.GF1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: noloader@gmail.com, linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51824 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbcHIHOG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 03:14:06 -0400
Content-Disposition: inline
In-Reply-To: <20160809070859.GF1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 08:08:59AM +0100, Russell King - ARM Linux wrote:
> 
> I thought I gave the commands and link to your example code.  The
> openssl case is md5, though sha* also gives the same result.  Your
> example code was sha1 iirc.  I guess none of these would be using
> HMAC - the openssl cases used to give results compatible with the
> md5sum/ sha1sum etc userspace commands.
> 
> /proc/crypto:
> 
> name         : md5
> driver       : md5-caam

Right, caam is providing a setkey function for md5, which leads the
API to think that a key is required.  We should fix it so that setkey
is only set for the HMAC-variant.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
