From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: dma_map_sg can handle chained SG
Date: Thu, 1 Oct 2015 22:01:06 +0800
Message-ID: <20151001140106.GC27726@gondor.apana.org.au>
References: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 23, 2015 at 01:55:24PM +0200, LABBE Corentin wrote:
> 
> Hello
> 
> Some drivers use two dma_map_sg path according to SG are chained or not.
> Since dma_map_sg can handle both case, this patch series clean all code
> with references to sg chained.
> 
> Note that I could only compile test sahara and caam patch.
> And none could be tested due to lack oh hardware.

Patches 1,3-4 applied.  Please resubmit patch 2 once you've completed
it.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
