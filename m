From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Async hash reentrancy
Date: Tue, 2 Mar 2010 22:25:04 +0800
Message-ID: <20100302142504.GA3995@gondor.apana.org.au>
References: <DDB181A6E7B893429D83CAC8DDBA74F1076A199007@VMBX108.ihostexchange.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Uri Simchoni <uris@ctera.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53519 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752362Ab0CBOZJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 09:25:09 -0500
Content-Disposition: inline
In-Reply-To: <DDB181A6E7B893429D83CAC8DDBA74F1076A199007@VMBX108.ihostexchange.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Uri Simchoni <uris@ctera.com> wrote:
> Hi,
> 
> I'd like to add sha1/hmac-sha1 support to the Marvell CESA driver. I couldn't see an ahash driver that I can use as a reference. Is there such a driver?

We did have an implementation but it had to be removed because
it wasn't reentrant so it's not a good model for you to follow
anyway.

> Assuming the client code is using the init->update->final sequence (and not just the digest call):
> - Should it be using it on the same ahash_request object? (probably yes - that's the whole point...)

Yes.

> - If the same ahash_request object is used, it means the driver has to save the SG info per such call, it cannot simply queue the ahash_request as is often done in crypto drivers, right? I mean, the req->src is changing between crypto_ahash_update() calls.

First of all to support init/update/final at all, your hardware
must be able to provide partial hash results in a "standard"
format.  See the export/import interface in sha1 for how that
should work.

Now if your hardware is only able to produce a final result, then
you should simply implement finup + digest, and do the update
operations using a software fallback.

To answer your actual question, a single request supports only one
outstanding operation at a time.  So it is illegal for the user
to issue a new update operation prior to the previous completing.

IOW you have nothing to worry about.

> - Same for callback? (.complete pointer)

Ditto.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
