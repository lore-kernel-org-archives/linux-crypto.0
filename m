From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: sahara: set nb_[in|out]_sg as signed int
Date: Mon, 23 Nov 2015 21:05:46 +0800
Message-ID: <20151123130546.GH7866@gondor.apana.org.au>
References: <1447936699-26854-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447936699-26854-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 19, 2015 at 01:38:17PM +0100, LABBE Corentin wrote:
> The two unsigned int variables nb_in_sg and nb_out_sg can be assigned
> signed value (-EINVAL) from sg_nents_for_len().
> Furthermore they are used only by dma_map_sg and dma_unmap_sg which wait
> for an signed int, so they must be set as int.
> 
> Fixes: 6c2b74d4774f ("crypto: sahara - check return value of sg_nents_for_len")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
