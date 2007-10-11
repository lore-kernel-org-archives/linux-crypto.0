From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] consider keysize in algorithm selection
Date: Thu, 11 Oct 2007 19:47:00 +0800
Message-ID: <20071011114700.GA17801@gondor.apana.org.au>
References: <20071010164400.GA19471@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4110 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752781AbXJKLrE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 07:47:04 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IfwVJ-0000gn-Jo
	for <linux-crypto@vger.kernel.org>; Thu, 11 Oct 2007 21:47:01 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IfwVI-0004fY-00
	for <linux-crypto@vger.kernel.org>; Thu, 11 Oct 2007 19:47:00 +0800
Content-Disposition: inline
In-Reply-To: <20071010164400.GA19471@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Sebastian:

On Wed, Oct 10, 2007 at 06:44:00PM +0200, Sebastian Siewior wrote:
>
> Almost all users are easy to fix. The wlan stack allocates the cipher at
> one time and sets the key at another time. So I don't know the requested
> keysize at allocation time.

Thanks for the patch!

I'm not quite happy with adding keysize to the core API though.
At some point I'd like to see the DMA operations folded into the
API as well so having a key is going to be far from universal.

In fact the compression operation is an existing example of a
user that doesn't have a key.

> In the fixup, crypto_authenc_alloc() got a little ugly. The keysize is
> only consider for the blkcipher but the hash might also be limited. Tell
> me what you thing about this one. Maybe something like cbc(aes|192) is a
> better solution.

We could do that.

However, I think the number of extant devices that actually
need this is so small that we can solve it using the fallback
flag instead.

In other words, let's make geode-aes use the padlock-sha method
and just fall back to a lower-priority AES algorithm if it sees
a key size that it can't handle.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
