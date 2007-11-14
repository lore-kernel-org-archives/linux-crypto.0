From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] [eSTREAM] stream: Wrapper for eSTREAM ciphers
Date: Wed, 14 Nov 2007 11:07:40 +0800
Message-ID: <20071114030740.GA8539@gondor.apana.org.au>
References: <fd3e431c0711121159p4eec500fw5a3caec76f07295d@mail.gmail.com> <E1IrkoZ-0007hT-00@gondolin.me.apana.org.au> <fd3e431c0711130925s6b7acddck80dd0054b41d1147@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1696 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753734AbXKNDIE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 22:08:04 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711130925s6b7acddck80dd0054b41d1147@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 14, 2007 at 01:25:37AM +0800, Tan Swee Heng wrote:
>
> In fact, my "stream" template patch uses blkcipher in the same way.
> However unlike "cbc" and "ctr", "stream" cannot process the IV. It
> must pass it to the underlying eSTREAM cipher's setiv() because each
> cipher's setiv() manipulates the IV differently. (Salsa20 uses it in a
> counter block; other eSTREAM ciphers mix the IV with the key in their
> key expansion.)

I think we're talking past each other :)

What I'm suggesting is that you implement the stream ciphers that
use an IV directly using the blkcipher interface, and not the cipher
interface.  That way you can do whatever you want with the IV.

> So blkcipher is indeed fine for stream ciphers as you stated - I even
> use it in "stream". The problem is that cipher_alg and cipher_tfm do
> not have callbacks for eSTREAM ciphers to expose setiv(). The
> "estream" patch tries to address this issue by introducing
> crypto_estream_type, estream_alg and estream_tfm.

That's right.  Apart from Salsa you shouldn't have to use the cipher
interface at all.  Which means that what the cipher interface lacks
is not a problem :)

Salsa can use the cipher interface because deep down it's a block
cipher.  It's just being used in counter mode.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
