From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sun4i-ss: add missing statesize
Date: Mon, 9 Nov 2015 11:58:48 +0800
Message-ID: <20151109035848.GA2163@gondor.apana.org.au>
References: <1447006457@msgid.manchmal.in-ulm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: maxime.ripard@free-electrons.com, clabbe.montjoie@gmail.com,
	davem@davemloft.net, wens@csie.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-sunxi@googlegroups.com, stable@vger.kernel.org
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42649 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbKID7N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Nov 2015 22:59:13 -0500
Content-Disposition: inline
In-Reply-To: <1447006457@msgid.manchmal.in-ulm.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de> wrote:
>
> Fixes: should rather point to the commit that caused the breakage in my
> opinion. Which did this by intention:

Absolutely not.  That patch is correct and if you revert that
you will simply end up registering a broken driver into the system
that may then lead to crashes that can be triggered from user-space.

> | commit 8996eafdcbad149ac0f772fb1649fbb75c482a6a
> | Author: Russell King <rmk+kernel@arm.linux.org.uk>
> | Date:   Fri Oct 9 20:43:33 2015 +0100
> | 
> |     crypto: ahash - ensure statesize is non-zero
> (...)
> +     This patch adds a check to prevent these drivers from registering
> +     ahash algorithms until they are fixed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
