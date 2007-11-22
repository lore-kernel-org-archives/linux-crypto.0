From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [0/11] Add IV generators and givcrypt
Date: Thu, 22 Nov 2007 19:31:16 +0800
Message-ID: <20071122113116.GD8781@gondor.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au> <20071122112558.GE2444@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4220 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751977AbXKVLbT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 06:31:19 -0500
Content-Disposition: inline
In-Reply-To: <20071122112558.GE2444@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 02:25:59PM +0300, Evgeniy Polyakov wrote:
>
> Idea and implementation look very good, I have couple of comments on
> patches and one generic comment here: you absolutely have to write at
> least bits of documentation for this new interfaces, how they behave and
> who and how should use it :)

Sorry, when my employer starts paying me to do that or hires
someone to do that for me is when better docs will exist :)

Until that happens why don't you chip in and contribute some
documentation the user?

Of course if you have specific questions about how givcrypt
works or is supposed to be used I'm happy to answer them.

In any case, hopefully when I push out the actual patches for
ESP it might become clearer.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
