From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam: add backlogging support
Date: Tue, 10 May 2016 17:46:22 +0800
Message-ID: <20160510094622.GA15860@gondor.apana.org.au>
References: <1462540733-2170-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto-owner@vger.kernel.org,
	horia.geanta@nxp.com, alexandru.porosanu@nxp.com,
	scott.wood@nxp.com, cata.vasile@nxp.com
To: Catalin Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54357 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbcEJJqf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 May 2016 05:46:35 -0400
Content-Disposition: inline
In-Reply-To: <1462540733-2170-1-git-send-email-cata.vasile@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Catalin Vasile <cata.vasile@nxp.com> wrote:
> caam_jr_enqueue() function returns -EBUSY once there are no more slots
> available in the JR, but it doesn't actually save the current request.
> This breaks the functionality of users that expect that even if there is
> no more space for the request, it is at least queued for later
> execution. In other words, all crypto transformations that request
> backlogging (i.e. have CRYPTO_TFM_REQ_MAY_BACKLOG set), will hang. Such
> an example is dm-crypt. The current patch solves this issue by setting a
> threshold after which caam_jr_enqueue() returns -EBUSY, but since the HW
> job ring isn't actually full, the job is enqueued.
> 
> Signed-off-by: Alexandru Porosanu <alexandru.porosanu@nxp.com>
> Tested-by: Catalin Vasile <cata.vasile@nxp.com>

This is not acceptable.  The request that triggers EBUSY must
be allowed to queue.  As the number of tfms is unlimited you
can't just put them onto the hardware queue and hope that it
works out.

You should use a software queue instead.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
