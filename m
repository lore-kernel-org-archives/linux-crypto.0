From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/6] crypto: sun4i-ss: fix a few signed warning
Date: Tue, 16 Aug 2016 17:50:23 +0800
Message-ID: <20160816095023.GB27042@gondor.apana.org.au>
References: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
	wens@csie.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43414 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbcHPJui (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 05:50:38 -0400
Content-Disposition: inline
In-Reply-To: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 10, 2016 at 11:45:29AM +0200, LABBE Corentin wrote:
> The variable i is always checked against unsigned value and cannot be
> negative.
> This patch set it as unsigned.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
