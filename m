From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: engine: permit to enqueue ashash_request
Date: Thu, 2 Jun 2016 16:32:59 +0800
Message-ID: <20160602083258.GB15226@gondor.apana.org.au>
References: <1464615122-16685-1-git-send-email-clabbe.montjoie@gmail.com>
 <1464615122-16685-2-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, baolin.wang@linaro.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464615122-16685-2-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 30, 2016 at 03:32:01PM +0200, LABBE Corentin wrote:
> The current crypto engine allow only ablkcipher_request to be enqueued.
> Thus denying any use of it for hardware that also handle hash algo.
> 
> This patch convert all ablkcipher_request references to the
> more general crypto_async_request.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

First of all your patches break bisection which is unacceptable.

Secondly you should not be casting generic requests to a specific type.

Assuming a single engine only has to deal with one type of requests,
what you could do is to create a separate engine type for each
crypto type that you want to support.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
