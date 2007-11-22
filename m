From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/11] [CRYPTO] chainiv: Add chain IV generator
Date: Thu, 22 Nov 2007 19:26:13 +0800
Message-ID: <20071122112613.GB8781@gondor.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au> <E1Iv7jn-00020S-00@gondolin.me.apana.org.au> <20071122111711.GC2444@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4108 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752081AbXKVL0Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 06:26:16 -0500
Content-Disposition: inline
In-Reply-To: <20071122111711.GC2444@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 02:17:11PM +0300, Evgeniy Polyakov wrote:
>
> > +	spin_lock_bh(&ctx->lock);
> 
> Crypto hardware can access iv in interrupt context and thus this can get
> wrong data.

This lock only guards against other callers of this function.
It doesn't care about how you do the underlying encryption.
You can do it in softirq context, hardirq context, or offload
it to the moon :)

> Are you sure that crypto operation has to be limited to be performed
> with turned off bottom halves? I believe this is a huge limitation for
> those ablkcipher devices which are not async actually...

This only applies to givcrypt which is only used by IPsec where
we already do everything under a bh lock :)

New users should specify the IV generator explicitly as is done
in dm-crypt.

In any case, this (the choice of chainiv as the default for sync
blkcipher) is something that we can change pretty easily down
the track without affecting anything else.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
