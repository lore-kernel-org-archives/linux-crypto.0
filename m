From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: status of async crypto
Date: Tue, 07 Aug 2007 15:29:44 +0800
Message-ID: <E1IIJVg-0007RB-00@gondolin.me.apana.org.au>
References: <B9FFC3F97441D04093A504CEA31B7C4101AA3B33@msilexch01.marvell.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: rshitrit@marvell.com (Ronen Shitrit)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1310 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753724AbXHGH3r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Aug 2007 03:29:47 -0400
In-Reply-To: <B9FFC3F97441D04093A504CEA31B7C4101AA3B33@msilexch01.marvell.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Ronen Shitrit <rshitrit@marvell.com> wrote:
> Hi Herbert
> 
> I found a mailing thread discussing "combined mode algorithms", I think
> that this is the main missing link for good async support.
> 
> Are you planning that this combined alg mode will support the async API?

Yes that's the main focus right now.

> Is there any progress on this direction?

I'm working on the infrastructure bits, i.e., setting up a
new operation type currently called authenc which sits at
the same level as ablkcipher or hash.  Joy Latten is looking
at CTR, as well as converting IPsec over once the crypto
infrastructure is done.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
