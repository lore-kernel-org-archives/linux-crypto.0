From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sun4i-ss: add missing statesize
Date: Mon, 9 Nov 2015 15:38:10 +0800
Message-ID: <20151109073745.GA3106@gondor.apana.org.au>
References: <1447054026-4243-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
	wens@csie.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49083 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbKIHiW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Nov 2015 02:38:22 -0500
Content-Disposition: inline
In-Reply-To: <1447054026-4243-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 09, 2015 at 08:27:06AM +0100, LABBE Corentin wrote:
> sun4i-ss implementaton of md5/sha1 is via ahash algorithms.
> A recent change make impossible to load them without giving statesize.
> This patch specifiy statesize for sha1 and md5.
> 
> Fixes: 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")

Nack.  As I said this commit is absolutely correct and if you really
have to slap on a fixes header then make it the original changeset
that added the driver.  It's the driver that's broken, not the API.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
