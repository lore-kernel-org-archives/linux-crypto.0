From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: testmgr: templates not tested
Date: Thu, 3 Sep 2015 15:45:39 +0800
Message-ID: <20150903074539.GA28992@gondor.apana.org.au>
References: <2425525.lUG5gvxoc6@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33711 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbICHpo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Sep 2015 03:45:44 -0400
Content-Disposition: inline
In-Reply-To: <2425525.lUG5gvxoc6@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 03, 2015 at 04:20:01AM +0200, Stephan Mueller wrote:
> 
> while playing with the testmgr in FIPS mode, I see that ciphers with a 
> template are not tested even though test vectors exist.
> 
> For example, when allocating cbc(aes-generic) I see records of aes-generic 
> (aes) being tested, but I do not see a record of cbc(aes).
> 
> Is it intended that such combos of a template/cipher are not tested?

It's the same bug as gcm.  cbc should use the underlying cra_name
in its cra_name.

I plan on fixing them as part of the skcipher conversion.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
