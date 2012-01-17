From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Getting vom synch to asynch algorithms
Date: Tue, 17 Jan 2012 20:58:02 +1100
Message-ID: <20120117095802.GA16325@gondor.apana.org.au>
References: <CB38925E.3194%markus.stockhausen@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Markus Stockhausen <markus.stockhausen@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40257 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2AQJ6H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Jan 2012 04:58:07 -0500
Content-Disposition: inline
In-Reply-To: <CB38925E.3194%markus.stockhausen@gmx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Markus Stockhausen <markus.stockhausen@gmx.de> wrote:
> 
> Maybe someone can enlighten me. These days a pcrypt module was mentioned
> that could help, but my router has only on CPU so there is no load to
> distribute. What will be the best way to make the kernel stable with
> high encryption CPU load?

pcrypt might actually work although for your purpose cryptd
would be the better option.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
