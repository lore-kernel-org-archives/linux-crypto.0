From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
	cipher
Date: Tue, 23 Feb 2010 08:32:39 +0800
Message-ID: <20100223003239.GC9118@gondor.apana.org.au>
References: <20100209145705.GA20421@Chamillionaire.breakpoint.cc> <20100209204519.GC26258@gondor.apana.org.au> <20100209211238.GC21548@Chamillionaire.breakpoint.cc> <20100209214522.GA27002@gondor.apana.org.au> <20100212084228.GA1535@Chamillionaire.breakpoint.cc> <20100216125125.GA390@gondor.apana.org.au> <20100221200140.GC11951@Chamillionaire.breakpoint.cc> <20100222004547.GA24812@gondor.apana.org.au> <20100222005217.GA24920@gondor.apana.org.au> <20100222220835.GB31291@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42603 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930Ab0BWAfi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Feb 2010 19:35:38 -0500
Content-Disposition: inline
In-Reply-To: <20100222220835.GB31291@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 22, 2010 at 11:08:35PM +0100, Sebastian Andrzej Siewior wrote:
> * Herbert Xu | 2010-02-22 08:52:17 [+0800]:
> 
> >On Mon, Feb 22, 2010 at 08:45:47AM +0800, Herbert Xu wrote:
> >> 
> >> How about this? You extend the IV by one more byte, and use that
> >> byte as a boolean flag to indicate whether the IV is valid.  All
> So I trick the crypto api to allocate more bytes than ->ivsize says.

No tricks needed, just add the flag to the struct.

struct arc4_iv {
	u8 S[256];
	u8 x, y;
	u8 valid;
};

> Okay. When we have to re-key and the user calls setkey() without
> re-allocating thr cipher then I would not notice this. So I need a
> counter. And all this will make it work but I still think it is fishy.
> Plus we waste 258bytes.

No you don't need to refresh the IV when the key changes.  The
key should only be consulted when the valid flag in the IV is zero.

You need the 258 + flag bytes because that's just the amount of
state carried between the encrypt/decrypt operation.  So it isn't
really wasted.

If you can find a way that allows arc4 to be used by multiple
threads at the same time while storing less than 258 bytes in
each thread, please let me know :)

> >In fact for arc4 we could just drop the key altogether since it
> >plays no part after setting the initial state.
> Since I'm not allowed to kfree() the ctx in encrypt() are you proposing
> tfm->setup_iv(iv, key)? 

No, what you could do is structure the IV differently based on the
flag:

struct arc4_iv {
	union {
		struct key {
			u8 key[256];
			u16 keylen;
		};
		struct iv {
			u8 S[256];
			u8 x, y;
		};
	};
	u8 type;
};

This relies on the fact that we never use more than 256 bytes in
the key so limiting its length is OK.

> >> Salsa should also be fixed.
> I saw that comming. And I complaind back then that the assembly code was
> not pretty enough... and removing the assembly is probably not option :)

Well if nobody steps in to fix the assembly then removing it is the
only option.

> >For Salsa on the other hand the key is rather useful since all
> >we need is a two-byte IV that's just a sequence number.
> No it's 8 bytes. Berstein's U8TO32_LITTLE() is actually a cpu_to_be32().
> Not sure if he knows it :)

Right.

> However I'm not sure where you going with this. salsa is fine besides
> the clobber thing, isn't it?

I don't know of any other problems.

Basically salsa should look pretty much like CTR from the outside
when it's fixed.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
