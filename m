From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_cbc_encrypt query
Date: Fri, 25 Sep 2015 17:39:29 +0800
Message-ID: <20150925093929.GA7305@gondor.apana.org.au>
References: <CAMf7+Lhk9E-PKtpA5TyrU9hGz1RviLQ062y5gFmnTD15LAyQdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: pavi1729 <pavitra1729@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45412 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbbIYJjc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Sep 2015 05:39:32 -0400
Content-Disposition: inline
In-Reply-To: <CAMf7+Lhk9E-PKtpA5TyrU9hGz1RviLQ062y5gFmnTD15LAyQdg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

pavi1729 <pavitra1729@gmail.com> wrote:
> Hi,
>  Shouldn't "walk" be memset ?
> 
> FILE:            crypto/cbc.c
> FUNCTION:  crypto_cbc_encrypt
> 
> "walk" is local variable and its uninitialized in
> "crypto_cbc_encrypt". The same is passed to
> "blkcipher_walk_virt" which does below
> 
> walk->flags &= ~BLKCIPHER_WALK_PHYS;
> 
> So neither 'walk' nor 'walk->flags' is memset or init to a proper value.

Other bits are initialised elsewhere as they are used.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
