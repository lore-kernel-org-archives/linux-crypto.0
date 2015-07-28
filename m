From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: correct error check of kthread_run call
Date: Tue, 28 Jul 2015 15:03:02 +0800
Message-ID: <20150728070302.GA25287@gondor.apana.org.au>
References: <1437736410-39227-1-git-send-email-schwidefsky@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34953 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbbG1HDN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jul 2015 03:03:13 -0400
Content-Disposition: inline
In-Reply-To: <1437736410-39227-1-git-send-email-schwidefsky@de.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 24, 2015 at 01:13:30PM +0200, Martin Schwidefsky wrote:
> The kthread_run() function can return two different error values
> but the hwrng core only checks for -ENOMEM. If the other error
> value -EINTR is returned it is assigned to hwrng_fill and later
> used on a kthread_stop() call which naturally crashes.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
