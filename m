From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: calculte md5 sum?
Date: Thu, 29 May 2008 08:28:24 +1000
Message-ID: <E1K1U88-0003wA-00@gondolin.me.apana.org.au>
References: <379e30200805281013g4d75dcf4vf4eaa8e0645f1e43@mail.gmail.com>
Cc: linux-crypto@vger.kernel.org
To: tobias.koeck@gmail.com (Tobias Koeck)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54527 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752656AbYE1W21 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 May 2008 18:28:27 -0400
In-Reply-To: <379e30200805281013g4d75dcf4vf4eaa8e0645f1e43@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tobias Koeck <tobias.koeck@gmail.com> wrote:
> I'm programming on a netfilter module and need to use the kernel md5
> sum functions to calculate a md5 sum from some integers.
> 
> I'm still searching for a decent documenation (kerneli.org seems to be
> down) and some example how to do it.
> 
> Has anybody an idea or a small example how to implement this?

Start by looking at how others use it:

	grep crypto_hash net/*/*.c

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
