From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: crypto: return codes
Date: Sat, 09 Oct 2010 23:34:43 -0400
Message-ID: <1286681683.2666.21.camel@localhost.localdomain>
References: <20101009012913.GA2829@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57739 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335Ab0JJDeq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Oct 2010 23:34:46 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o9A3Z9or015254
	for <linux-crypto@vger.kernel.org>; Sat, 9 Oct 2010 23:35:09 -0400
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o9A3YjDm138986
	for <linux-crypto@vger.kernel.org>; Sat, 9 Oct 2010 23:34:45 -0400
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o9A3cYQx020232
	for <linux-crypto@vger.kernel.org>; Sat, 9 Oct 2010 21:38:34 -0600
In-Reply-To: <20101009012913.GA2829@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2010-10-09 at 09:29 +0800, Herbert Xu wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > Hi,
> > 
> > Looking at different examples of the same crypto call, it's unclear
> > whether it only returns negative error values. Some examples only test
> > for negative values, while others test for not 0. tcrypt.c does "if
> > (ret)".  Would appreciate some clarification.
> 
> Unless the call can return positive values then it makes no
> difference.  Which particular call are you talking about?
> 
> Cheers,

Just to name a few: crypto_hash_init(), crypto_hash_update(),
crypto_hash_final(). Also crypto_blkcipher_decrypt/encrypt().  Would be
nice to know definitively that they return < 0 on error and 0 for
success.

thanks!

Mimi
