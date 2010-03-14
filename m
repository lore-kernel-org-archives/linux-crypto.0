From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
	cipher
Date: Sun, 14 Mar 2010 17:06:23 +0800
Message-ID: <20100314090623.GA32391@gondor.apana.org.au>
References: <20100209211238.GC21548@Chamillionaire.breakpoint.cc> <20100209214522.GA27002@gondor.apana.org.au> <20100212084228.GA1535@Chamillionaire.breakpoint.cc> <20100216125125.GA390@gondor.apana.org.au> <20100221200140.GC11951@Chamillionaire.breakpoint.cc> <20100222004547.GA24812@gondor.apana.org.au> <20100222005217.GA24920@gondor.apana.org.au> <20100222220835.GB31291@Chamillionaire.breakpoint.cc> <20100223003239.GC9118@gondor.apana.org.au> <20100314082432.GA1800@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46510 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751605Ab0CNJGc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Mar 2010 05:06:32 -0400
Content-Disposition: inline
In-Reply-To: <20100314082432.GA1800@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 14, 2010 at 09:24:32AM +0100, Sebastian Andrzej Siewior wrote:
> 
> Okay. So so are we talking about something like that below then? This is

Pretty much.

> untested and I break other users bexcept lib80211_crypt_tkip. 

For the sake of compatibility please do this as a 3-step dance.
First add a new arc4 blkcipher, then convert the users, and
finally delete the old arc4.

>  static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  			unsigned int key_len)
>  {
> -	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
> +	/*
> +	 * ARC4 is special: The user should supply an IV as struct arc4_iv and
> +	 * fill either the key or the iv.
> +	 */
> +	return -EOPNOTSUPP;
> +}

You should return 0 here.  You should also set the min/max key
size to zero.  The new arc4 no longer has a key as far as the
API is concerned.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
