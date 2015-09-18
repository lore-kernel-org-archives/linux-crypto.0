From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/caam: add backlogging support
Date: Fri, 18 Sep 2015 21:24:43 +0800
Message-ID: <20150918132443.GG7638@gondor.apana.org.au>
References: <1442434361-15123-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	mircea.pop@freescale.com
To: Alex Porosanu <alexandru.porosanu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41235 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbbIRNYt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 09:24:49 -0400
Content-Disposition: inline
In-Reply-To: <1442434361-15123-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 16, 2015 at 11:12:41PM +0300, Alex Porosanu wrote:
> caam_jr_enqueue() function returns -EBUSY once there are no
> more slots available in the JR, but it doesn't actually save
> the current request. This breaks the functionality of users
> that expect that even if there is no more space for the request,
> it is at least queued for later execution. In other words, all
> crypto transformations that request backlogging
> (i.e. have CRYPTO_TFM_REQ_MAY_BACKLOG set), will hang. Such an
> example is dm-crypt.
> The current patch solves this issue by setting a threshold after
> which caam_jr_enqueue() returns -EBUSY, but since the HW job ring
> isn't actually full, the job is enqueued.
> Caveat: if the users of the driver don't obey the API contract which
> states that once -EBUSY is received, no more requests are to be
> sent, eventually the driver will reject the enqueues.

This isn't what MAY_BACKLOG is supposed to do.  For a given tfm
at least one MAY_BACKLOG request must be accepted.  So you can't
just start dropping requests after your queue fills up.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
