Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9B1C77B78
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Apr 2023 09:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbjDTJ4K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Apr 2023 05:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbjDTJ4G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2023 05:56:06 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AB8110
        for <linux-crypto@vger.kernel.org>; Thu, 20 Apr 2023 02:56:03 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ppR18-000Y4B-At; Thu, 20 Apr 2023 17:55:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 20 Apr 2023 17:55:55 +0800
Date:   Thu, 20 Apr 2023 17:55:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH v2 1/2] crypto: jitter - replace LFSR with SHA3-256
Message-ID: <ZEEMK/zlZdz2t7CA@gondor.apana.org.au>
References: <2684670.mvXUDI8C0e@positron.chronox.de>
 <4825604.31r3eYUQgx@positron.chronox.de>
 <2283439.ElGaqSPkdT@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2283439.ElGaqSPkdT@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 10, 2023 at 10:55:13PM +0200, Stephan Müller wrote:
>
> +static int jent_kcapi_init(struct crypto_tfm *tfm)
> +{
> +	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
> +	struct crypto_shash *hash;
> +	struct shash_desc *sdesc;
> +	int size, ret = 0;
> +
> +	/*
> +	 * Use SHA3-256 as conditioner. We allocate only the generic
> +	 * implementation as we are not interested in high-performance. The
> +	 * execution time of the SHA3 operation is measured and adds to the
> +	 * Jitter RNG's unpredictable behavior. If we have a slower hash
> +	 * implementation, the execution timing variations are larger. When
> +	 * using a fast implementation, we would need to call it more often
> +	 * as its variations are lower.
> +	 */
> +	hash = crypto_alloc_shash(JENT_CONDITIONING_HASH, 0, 0);
> +	if (IS_ERR(hash)) {
> +		pr_err("Cannot allocate conditioning digest\n");
> +		return PTR_ERR(hash);
> +	}
> +	rng->tfm = hash;
> +
> +	size = sizeof(struct shash_desc) + crypto_shash_descsize(hash);
> +	sdesc = kmalloc(size, GFP_KERNEL);
> +	if (!sdesc) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	sdesc->tfm = hash;
> +	crypto_shash_init(sdesc);
> +	rng->sdesc = sdesc;
> +
> +	rng->entropy_collector = jent_entropy_collector_alloc(1, 0, sdesc);
> +	if (!rng->entropy_collector)
> +		ret = -ENOMEM;

Is this supposed to fail or not?

> +
> +	spin_lock_init(&rng->jent_lock);
> +	return 0;
> +
> +err:
> +	jent_kcapi_cleanup(tfm);
> +	return ret;
> +}
> +

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
