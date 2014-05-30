From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [QUESTION] Crypto queue handling
Date: Fri, 30 May 2014 17:56:00 +0800
Message-ID: <20140530095600.GD12760@gondor.apana.org.au>
References: <201405261758.19425.marex@denx.de>
 <201405261816.58803.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Pantelis Antoniou <panto@antoniou-consulting.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36728 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaE3J4E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 05:56:04 -0400
Content-Disposition: inline
In-Reply-To: <201405261816.58803.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 26, 2014 at 06:16:58PM +0200, Marek Vasut wrote:
>
> So, we call backlog->complete() , but who did actually ever process the request 
> stored in the queue->backlog ? To me, it seems like the request was never 
> processed, but we complete it.

Nobody.  This is meant to indicate to the user that the queue now has
space for submission.  The backlogged request must be resubmitted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
