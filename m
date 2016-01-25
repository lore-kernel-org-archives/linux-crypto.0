From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ANSI X9.31 DRNG is not allowed in FIPS 140-2
Date: Mon, 25 Jan 2016 22:47:17 +0800
Message-ID: <20160125144717.GA8840@gondor.apana.org.au>
References: <2027518.YhRjo0CQ2K@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46943 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbcAYOr3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 09:47:29 -0500
Content-Disposition: inline
In-Reply-To: <2027518.YhRjo0CQ2K@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 05, 2016 at 01:12:21PM +0100, Stephan Mueller wrote:
> As per update of the FIPS 140-2 Annex C supported by SP800-131A, the
> ANSI X9.31 DRNG is not an allowed cipher in FIPS mode any more.
> 
> CC: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
