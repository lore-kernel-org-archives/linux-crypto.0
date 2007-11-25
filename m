From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Givcipher bug?
Date: Mon, 26 Nov 2007 00:09:06 +0800
Message-ID: <20071125160906.GA13583@gondor.apana.org.au>
References: <Pine.LNX.4.64.0711251324330.3663@antarct>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mikko Herranen <mikko.herranen@cs.helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3518 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752273AbXKYQJK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Nov 2007 11:09:10 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711251324330.3663@antarct>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 25, 2007 at 01:45:20PM +0200, Mikko Herranen wrote:
> Hi Herbert,
> 
> The newest cryptodev kernel hangs on "testing ctr(aes,4,8,4) encryption"
> in tcrypt. Stack trace:

OK, all the IV generators are broken.  They just happened to
work by chance on everything apart from CTR.

The problem is that I was thinking of making the IV generators
as special crypto_instance objects that simply extended existing
algorithms without spawning.

Somehow I ended up writing them as normal spawns.

So I'm going to fix that up and repost them.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
