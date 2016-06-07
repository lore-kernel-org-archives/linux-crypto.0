From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/1] crypto: engine: permit to enqueue ashash_request
Date: Tue, 7 Jun 2016 18:31:39 +0800
Message-ID: <20160607103139.GA325@gondor.apana.org.au>
References: <1464873212-15426-1-git-send-email-clabbe.montjoie@gmail.com>
 <1464873212-15426-2-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, baolin.wang@linaro.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59901 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbcFGKcD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 06:32:03 -0400
Content-Disposition: inline
In-Reply-To: <1464873212-15426-2-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 02, 2016 at 03:13:32PM +0200, LABBE Corentin wrote:
>
>  static int omap_aes_prepare_req(struct crypto_engine *engine,
> -				struct ablkcipher_request *req)
> +				struct crypto_async_request *areq)
>  {
> +	struct ablkcipher_request *req = ablkcipher_request_cast(areq);

You're still doing casting in the driver.

I want this to be moved into the crypto engine API.  There should
be separate function pointers for each request type.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
