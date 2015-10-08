From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qce: dma_map_sg can handle chained SG
Date: Thu, 8 Oct 2015 22:23:14 +0800
Message-ID: <20151008142314.GB25166@gondor.apana.org.au>
References: <20151001140106.GC27726@gondor.apana.org.au>
 <1443765662-21638-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, cristian.stoica@freescale.com, axboe@fb.com,
	dan.j.williams@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39194 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbbJHOX1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 10:23:27 -0400
Content-Disposition: inline
In-Reply-To: <1443765662-21638-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 02, 2015 at 08:01:02AM +0200, LABBE Corentin wrote:
> The qce driver use two dma_map_sg path according to SG are chained
> or not.
> Since dma_map_sg can handle both case, clean the code with all
> references to sg chained.
> 
> Thus removing qce_mapsg, qce_unmapsg and qce_countsg functions.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
