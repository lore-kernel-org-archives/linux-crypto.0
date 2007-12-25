From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: New Crypto Hardware
Date: Tue, 25 Dec 2007 15:32:02 +0800
Message-ID: <20071225073202.GA31076@gondor.apana.org.au>
References: <E1IrkmY-0007gp-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603EB866F@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4059 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751206AbXLYHcG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Dec 2007 02:32:06 -0500
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D603EB866F@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 21, 2007 at 09:41:11AM -0800, Loc Ho wrote:
> Hi Herbert,
> 
> Begin of next year, I will be start adding asynchronous hashing support.
> I would like to check with you before I start. Besides modeled after
> crypto async block cipher, do you have any suggestion?

Thanks for looking into this.

What I'd like to see is to have the hash context moved into
the request.  This is necessary for us to support simultanenous
hash operations on the same tfm.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
