From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] [eSTREAM] stream: Wrapper for eSTREAM ciphers
Date: Thu, 15 Nov 2007 09:18:07 +0800
Message-ID: <20071115011807.GA21310@gondor.apana.org.au>
References: <fd3e431c0711121159p4eec500fw5a3caec76f07295d@mail.gmail.com> <E1IrkoZ-0007hT-00@gondolin.me.apana.org.au> <fd3e431c0711130925s6b7acddck80dd0054b41d1147@mail.gmail.com> <20071114030740.GA8539@gondor.apana.org.au> <fd3e431c0711141714qbd444f9o2b15973caaf15a3c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4425 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753901AbXKOBSJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Nov 2007 20:18:09 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711141714qbd444f9o2b15973caaf15a3c@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 15, 2007 at 09:14:40AM +0800, Tan Swee Heng wrote:
>
> > Salsa can use the cipher interface because deep down it's a block
> > cipher.  It's just being used in counter mode.
> I might still implement it using the blkcipher interface as it seems
> strange to call it via "ctr(salsa20,..)" as it is meant to be a stream
> cipher after all. I always find "ecb(arc4)" kind of strange. :-)

Actually what I suggested is that you add a wrapper called
salsa20 that then simply calls ctr(...) after constructing the
IV.

It's OK to have two algorithms of the same name provided that
their types are different.  So you can have a salsa20 blkcipher
and also a salsa20 cipher.

We don't really need to have two copies of the ctr code under
crypto :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
