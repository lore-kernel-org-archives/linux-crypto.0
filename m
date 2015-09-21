From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v3] crypto/caam: add backlogging support
Date: Mon, 21 Sep 2015 11:20:43 +0300
Message-ID: <55FFBDDB.9000500@freescale.com>
References: <1442653336-8527-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <mircea.pop@freescale.com>, <herbert@gondor.apana.org.au>
To: Alex Porosanu <alexandru.porosanu@freescale.com>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0136.outbound.protection.outlook.com ([157.56.111.136]:4371
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756009AbbIUIU7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 04:20:59 -0400
In-Reply-To: <1442653336-8527-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/19/2015 12:02 PM, Alex Porosanu wrote:
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
> For well-behaved CryptoAPI users, like dm-crypt, this is not the
> case, since the processing thread will sleep once -EBUSY is
> received.
> 
> Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
> 
> ---
> v3:
> - as per Herbert's observation, allow only # of backlogging slots
>   transformations w/MAY_BACKLOG flag set to be affined to a JR;
>   the total # of transformations that can be thus allocated is equal
>   to the # of JRs times the # of "backlogging slots". In the standard
>   configuration, this means 16 x 4 = 64 transformations.

This won't work, since CRYPTO_TFM_REQ_MAY_BACKLOG is set per request (at
request setup time), not per tfm.

Horia
