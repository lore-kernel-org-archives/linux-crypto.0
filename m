From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] crypto: qce: dma_map_sg can handle chained SG
Date: Thu, 1 Oct 2015 21:58:01 +0800
Message-ID: <20151001135801.GA27726@gondor.apana.org.au>
References: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
 <1443009328-12478-3-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, axboe@fb.com, cristian.stoica@freescale.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46116 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbbJAN6Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 09:58:16 -0400
Content-Disposition: inline
In-Reply-To: <1443009328-12478-3-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 23, 2015 at 01:55:26PM +0200, LABBE Corentin wrote:
> The qce driver use two dma_map_sg path according to SG are chained
> or not.
> Since dma_map_sg can handle both case, clean the code with all
> references to sg chained.
> 
> Thus removing qce_mapsg, qce_unmapsg and qce_countsg functions.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

This patch doesn't compile as you missed out on a hunk in sha.c.

Please fix and resubmit.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
