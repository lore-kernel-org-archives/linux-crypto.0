From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [QUESTION] Crypto queue handling
Date: Fri, 30 May 2014 21:41:35 +0800
Message-ID: <20140530134135.GA14778@gondor.apana.org.au>
References: <201405261758.19425.marex@denx.de>
 <20140530093030.GC12760@gondor.apana.org.au>
 <A83C99F8370D4D42BEB2D2B3153A6BBC30807A82@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marek Vasut <marex@denx.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Pantelis Antoniou <panto@antoniou-consulting.com>
To: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36345 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbaE3Nlt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 09:41:49 -0400
Content-Disposition: inline
In-Reply-To: <A83C99F8370D4D42BEB2D2B3153A6BBC30807A82@NASANEXD02C.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 30, 2014 at 01:33:06PM +0000, Hsieh, Che-Min wrote:
> 
> It is nice to know that the request queue is per tfm. We are currently on android-3.10.  I believe all the drivers under drivers/crypto/   don't follow this rule.  At the minimum, our driver qcrypto does not.  Other than backlogging function, does it break anything? How critical is it to fix the driver soon?

Sorry I don't know what I was smoking when I said that but it's
bollocks :)

Marek is quite correct that MAY_BACKLOG users can indefinitely
add to the backlog queue.  However, it is meant to be limited
to one entry per-tfm.

This is because the user is supposed to back off once they get
EBUSY, until they're notified once the backlog entry is popped
off (but not processed, it must be resubmitted).

We don't really do any checking right now as there aren't many
MAY_BACKLOG users.  But if it becomes a problem we can always
add a check to ensure each tfm does not add more than one backlog
request.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
