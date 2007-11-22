From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [0/11] Add IV generators and givcrypt
Date: Thu, 22 Nov 2007 20:47:10 +0800
Message-ID: <20071122124710.GA9915@gondor.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au> <20071122112558.GE2444@2ka.mipt.ru> <20071122113116.GD8781@gondor.apana.org.au> <20071122115707.GE28024@2ka.mipt.ru> <20071122120937.GA9357@gondor.apana.org.au> <20071122123701.GA16262@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2042 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752162AbXKVMrQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 07:47:16 -0500
Content-Disposition: inline
In-Reply-To: <20071122123701.GA16262@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 03:37:02PM +0300, Evgeniy Polyakov wrote:
>
> > First of all givcrypt is designed to work for hardware devices too.
> > If they can generate their own IVs then they should directly hook
> > up to the givcrypt method and use the givcipher type.
> 
> But for example chainiv_givcrypt() will not return correct iv when
> called fro async device, since when givcrypt() returned operation is not
> yet completed.

Chainiv is just one possible IV generator.  You're right that
it cannot possibly work with async ciphers, that's why its alloc
function rejects any attempt to apply it to an async cipher :)

In any case what I meant above is something different.  I'm
thinking of hardware that can naturally generate their own IVs
as part of the encryption operation, e.g., through a hardware
RNG for CBC or a counter for CTR.

> Yes, that what I meant. And also other possible crypto modes, which can
> require iv-based tweaks.

BTW, givcrypt should only be used for generating the entire IV.

If you're trying to adjust the IV, e.g. adding bits to it as
is done for CTR for IPsec then that should be done through the
usual ablkcipher interface by just wrapping around the encrypt
and decrypt functions.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
