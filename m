From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG broken?
Date: Tue, 9 Aug 2016 11:18:20 +0800
Message-ID: <20160809031820.GA4142@gondor.apana.org.au>
References: <20160808181117.GD1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: noloader@gmail.com, linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37175 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbcHIDSp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 23:18:45 -0400
Content-Disposition: inline
In-Reply-To: <20160808181117.GD1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Russell King - ARM Linux <linux@armlinux.org.uk> wrote:
> Testing that code on 4.8-rc (and 4.7 fwiw) gives:
> 
> socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> bind(3, {sa_family=AF_ALG, sa_data="hash\0\0\0\0\0\0\0\0\0\0"}, 88) = 0
> accept(3, 0, NULL)                      = 4
> write(4, "abc", 3)                      = -1 ENOKEY (Required key not available)
> read(4, 0xbec50508, 20)                 = -1 ENOKEY (Required key not available)
> 
> IOW, the same problem - and it seems not to be a recent regression.
> 
> Since the last time I tested CESA or CAAM was back in 4.4 times,
> it's got to be something between 4.4 and 4.7.
> 
> Looking at the history, my guess would be the setkey changes -
> crypto: algif_skcipher - Require setkey before accept(2)
> crypto: af_alg - Disallow bind/setkey/... after accept(2)
> crypto: af_alg - Add nokey compatibility path
> crypto: hash - Add crypto_ahash_has_setkey
> crypto: algif_hash - Require setkey before accept(2)

This is definitely supposed to work.  Basically if the algorithm
requires a key (e.g., HMAC) then you must set it.  Otherwise it
should never return ENOKEY.

Which algorithm were you testing and what does /proc/crypto say?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
