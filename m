From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: sahara - use the backlog
Date: Wed, 8 Apr 2015 22:25:03 +0800
Message-ID: <20150408142503.GB30541@gondor.apana.org.au>
References: <1428419622-1263-1-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40027 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbbDHOZG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 10:25:06 -0400
Content-Disposition: inline
In-Reply-To: <1428419622-1263-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 07, 2015 at 05:13:41PM +0200, Steffen Trumtrar wrote:
> With commit
> 
> 	7e77bdebff5cb1e9876c561f69710b9ab8fa1f7e crypto: af_alg - fix backlog handling
> 
> in place, the backlog works under all circumstances where it previously failed, atleast
> for the sahara driver. Use it.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
