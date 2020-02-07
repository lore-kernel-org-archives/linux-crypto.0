Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7B5C2D0B1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 06:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 270A8214AF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 06:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581058643;
	bh=zTSBQNt4eq3J71YmoyHl3b2Ibnp+d/1SMhq+z2V2aj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2b48NPowq7/DZ7rWx7iolBo/EMMdKkzLLSMVaiqyWCRuEF+/zSPW/Uleyg6Znf4er
	 GZM7exagDMnBDq2ffcyp4kMWFzTnKvN/kFABVITXn3OyeFvAnt1vTdtiSUFYtEdkoj
	 PQylaW/A+ipn2W3ERgqObialUs5n1ubyZdXR0wIs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgBGG5W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 01:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgBGG5W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 01:57:22 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE5920726;
        Fri,  7 Feb 2020 06:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581058641;
        bh=zTSBQNt4eq3J71YmoyHl3b2Ibnp+d/1SMhq+z2V2aj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GvmjZXISOJ3OLa2bXHHiCeq8bBInKZU+XsQU1q216RDyC5AUtT9UQOxLT1Yckafku
         UwXl9ubccSdjwBSmVcgnVbi69czGiUKRsWBQD1EMRBHcJdxC879MFqIAVqDdIcpjjZ
         M/LuGr01YFaZAFV/Ymxh8iAqvdTM67c1eUIcEpsU=
Date:   Thu, 6 Feb 2020 22:57:19 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] crypto: export() overran state buffer on test vector
Message-ID: <20200207065719.GA8284@sol.localdomain>
References: <20200206085442.GA5585@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206085442.GA5585@Red>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 06, 2020 at 09:54:42AM +0100, Corentin Labbe wrote:
> Hello
> 
> When working on adding hash support on sun8i-ce, I made a simple version which always fallback.
> but booting it lead to this:
> [   52.274278] sun8i-ce 1c15000.crypto: Register sha1
> [   52.279286] sun8i-ce 1c15000.crypto: sun8i_hash_crainit statesize is 96
> [   52.285933] sun8i-ce 1c15000.crypto: Fallback for sha1-sun8i-ce is sha1-ce
> [   52.312423] shash_default_export descsize=104
> [   52.316021] alg: ahash: sha1-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\" statesize=96
> [   52.333189] sun8i-ce 1c15000.crypto: Register sha224
> [   52.338387] sun8i-ce 1c15000.crypto: sun8i_hash_crainit statesize is 104
> [   52.345097] sun8i-ce 1c15000.crypto: Fallback for sha224-sun8i-ce is sha224-ce
> [   52.371865] shash_default_export descsize=112
> [   52.375459] alg: ahash: sha224-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\" statesize=104
> [   52.393039] sun8i-ce 1c15000.crypto: Register sha256
> [   52.398219] sun8i-ce 1c15000.crypto: sun8i_hash_crainit statesize is 104
> [   52.404937] sun8i-ce 1c15000.crypto: Fallback for sha256-sun8i-ce is sha256-ce
> [   52.431476] shash_default_export descsize=112
> [   52.435073] alg: ahash: sha256-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\" statesize=104
> 
> For sha1, sha224 and sha256, my driver fail to pass the test.
> This is due to the fact that export() (and so shash_async_export/shash_default_export) use crypto_shash_descsize() as length but selftest expect it to be statesize.

That doesn't appear to actually be the problem.  shash_default_export() does
assume descsize == statesize, but it's only used when that's the case.
See shash_prepare_alg().  

> Just in case, this is my export code:
> int sun8i_hash_crainit(struct crypto_tfm *tfm)
> {
>         struct sun8i_hash_tfm_ctx *op = crypto_tfm_ctx(tfm);
>         struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
>         struct sun8i_ce_alg_template *algt;
> 
>         memset(op, 0, sizeof(struct sun8i_hash_tfm_ctx));
> 
>         crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm), sizeof(struct sun8i_hash_reqctx));
> 
>         op->fallback_tfm = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0, CRYPTO_ALG_NEED_FALLBACK);
>         if (IS_ERR(op->fallback_tfm)) {
>                 dev_err(algt->ce->dev, "Fallback driver cound no be loaded\n");
>                 return PTR_ERR(op->fallback_tfm);
>         }
>         dev_info(op->ce->dev, "%s statesize is %u\n", __func__, algt->alg.hash.halg.statesize);
>         dev_info(op->ce->dev, "Fallback for %s is %s\n",
>                 crypto_tfm_alg_driver_name(tfm),
>                 crypto_tfm_alg_driver_name(&op->fallback_tfm->base));
>         return 0;
> }
> 
> int sun8i_hash_init(struct ahash_request *areq)
> {
>         struct sun8i_hash_reqctx *rctx = ahash_request_ctx(areq);
>         struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
>         struct sun8i_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
> 
>         memset(rctx, 0, sizeof(struct sun8i_hash_reqctx));
> 
>         ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
>         rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
> 
>         return crypto_ahash_init(&rctx->fallback_req);
> }
> 
> int sun8i_hash_export(struct ahash_request *areq, void *out)
> {
>         struct sun8i_hash_reqctx *rctx = ahash_request_ctx(areq);
>         struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
>         struct sun8i_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
> 
>         ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
>         rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
>                                                                                 
>         return crypto_ahash_export(&rctx->fallback_req, out);                   
> }

It seems the actual problem is that you're doing the export using a fallback
algorithm, which may have a statesize different from the one you're setting.

But I'm not sure what you should do here, since the correct statesize can only
be known when a tfm is allocated, not when the algorithm is registered.

Possibly statesize needs to be made a property of the tfm (struct crypto_ahash
and crypto_shash) rather than the algorithm (struct hash_alg_common).

But are you sure you actually need a fallback algorithm for any hash algorithms
in your driver in the first place?

- Eric
