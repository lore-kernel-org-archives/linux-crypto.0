From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix inconsistent assoc dma mapping
 direction
Date: Tue, 14 May 2013 10:38:14 +0800
Message-ID: <20130514023814.GF19306@gondor.apana.org.au>
References: <1368187719-6865-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@freescale.com>,
	Vakul Garg <vakul@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38267 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756527Ab3ENCiQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 22:38:16 -0400
Content-Disposition: inline
In-Reply-To: <1368187719-6865-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 10, 2013 at 03:08:39PM +0300, Horia Geanta wrote:
> req->assoc is dma mapped BIDIRECTIONAL and unmapped TO_DEVICE.
> Since it is read-only for the device, use TO_DEVICE both for mapping
> and unmapping.
> 
> Cc: <stable@vger.kernel.org> # 3.9, 3.8
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

Applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
