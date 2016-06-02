From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: engine: permit to enqueue ashash_request
Date: Thu, 2 Jun 2016 11:12:13 +0200
Message-ID: <20160602091213.GA2521@Red>
References: <1464615122-16685-1-git-send-email-clabbe.montjoie@gmail.com>
 <1464615122-16685-2-git-send-email-clabbe.montjoie@gmail.com>
 <20160602083258.GB15226@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, baolin.wang@linaro.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34902 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbcFBJMS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 05:12:18 -0400
Content-Disposition: inline
In-Reply-To: <20160602083258.GB15226@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 02, 2016 at 04:32:59PM +0800, Herbert Xu wrote:
> On Mon, May 30, 2016 at 03:32:01PM +0200, LABBE Corentin wrote:
> > The current crypto engine allow only ablkcipher_request to be enqueued.
> > Thus denying any use of it for hardware that also handle hash algo.
> > 
> > This patch convert all ablkcipher_request references to the
> > more general crypto_async_request.
> > 
> > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> 
> First of all your patches break bisection which is unacceptable.
> 

How do I break bisection ?

> Secondly you should not be casting generic requests to a specific type.
> 
I didnt add any request type check since omap use engine only for ciphers.
My view if usage of crypt_one_request() if hash and ciphers coule be used is to test
crypto_tfm_alg_type(areq->tfm) to check which alg is used (CRYPTO_ALG_TYPE_AHASH vs CRYPTO_ALG_TYPE_ABLKCIPHER)

For example, this is my setted crypt_one_request function:
int handle_request(struct crypto_engine *engine, struct crypto_async_request *areq)
{
        int rtype;
        struct ahash_request *hreq;
        struct ablkcipher_request *breq;
        int err = -EINVAL;
        rtype = crypto_tfm_alg_type(areq->tfm);
        switch (rtype) {
        case CRYPTO_ALG_TYPE_AHASH:
                hreq = ahash_request_cast(areq);
                err = sun4i_ss_hash(hreq);
                break;
        case CRYPTO_ALG_TYPE_ABLKCIPHER:
                breq = ablkcipher_request_cast(areq);
                err = sun4i_ss_cipher(breq);
        }
        crypto_finalize_request(engine, areq, err);
        return 0;
}


> Assuming a single engine only has to deal with one type of requests,
> what you could do is to create a separate engine type for each
> crypto type that you want to support.
> 

So, if my hwcrypto can handle hash and ciphers, I need to have two engine and each crypt_one_request()/hash_one_request()
need to lock the engine.
Having only one engine that handle all types permit to avoid this locking.

Regards
