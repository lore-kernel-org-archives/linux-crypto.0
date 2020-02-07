Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E6DC352A2
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 10:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B885206CC
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 10:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cz036zNL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgBGKrE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 05:47:04 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:40407 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgBGKrE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 05:47:04 -0500
Received: by mail-wr1-f54.google.com with SMTP id t3so2070067wru.7;
        Fri, 07 Feb 2020 02:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vihhkM3cjNfJ7+zDL+cP7K8N6569xYSRREcWllK4iDk=;
        b=cz036zNLcNTQwykCoPwezXZPyqpwU18OJIT8S2CVfBz3uJK0kbO2cf0KetM/z7B1rz
         qiyLiWYhbNdzg72QELONo4iksAILZyy68zADFAytRaGaY1h/l9+CS0pRLPyIDmGI0Yix
         If6MrvLczQIHQe62VCSvHU2LVg8a6cwdRfJ+iY1f6QHVOdguc6hsUgRHRWNGtsWFqCYH
         Cmjp5RAItXO/iZvhR07MNkNCcZNSKnzBfiPAc/i47rI0Zf5Wq3azWXmhRqFHESsSDoB6
         hwrBve8TOtf8GfBB4qqlQmJjp9rHYTWdLhRL9HHByG9js57yT4lX0o4aXpTcn/OT1Mf0
         wZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vihhkM3cjNfJ7+zDL+cP7K8N6569xYSRREcWllK4iDk=;
        b=E/I1yf5nk1m+E2Gmas3ZEIrHchc/pArYVMyHwc866uCWDgq8iZoFTOBHaOcP/4doLd
         p2h2fOBm4gA6kJ91WnTAm2q/8yAiVhrmHjkKZKXCbIkoeZRRCQJw4tiJ1xmcAuK0MVYe
         zyvmlGaBQyF6IoqiD0o6KCSB7wzLthWRnrF+SwwDyBjaBrf+rvWPb204+APJLyHAUHYr
         I9fIY2lsYH6bmkgxlI2lLjxdtIspzWDTyX2jkCWl9uxg8bOkaOfcbArZ8Rsa5eoXTM3v
         pE/ibHah5JfVWPkXyuhqoxYR8vQWRUch5Uh5Nq7NFKzPmKkUWvjk6GlFC8E+nCiwGqp0
         vpRA==
X-Gm-Message-State: APjAAAVnAitbGgMLm9fOohjZq7/5Q/80G2ylbqSh8NqLa9APmWNrIGuZ
        dODy8FDkK6q5hc46WFmxU+W92sm8
X-Google-Smtp-Source: APXvYqxM4QoR3bADCDvE3nCZA/eWQrnNGKeqRV5MW+VfnNeqtIPb30czXNHomLkzv0Apgy+ypsLI1A==
X-Received: by 2002:adf:ab49:: with SMTP id r9mr4175556wrc.351.1581072421527;
        Fri, 07 Feb 2020 02:47:01 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id m9sm2870038wrx.55.2020.02.07.02.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 02:47:01 -0800 (PST)
Date:   Fri, 7 Feb 2020 11:46:59 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] crypto: export() overran state buffer on test vector
Message-ID: <20200207104659.GA10979@Red>
References: <20200206085442.GA5585@Red>
 <20200207065719.GA8284@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207065719.GA8284@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 06, 2020 at 10:57:19PM -0800, Eric Biggers wrote:
> On Thu, Feb 06, 2020 at 09:54:42AM +0100, Corentin Labbe wrote:
> > Hello
> > 
> > When working on adding hash support on sun8i-ce, I made a simple version which always fallback.
> > but booting it lead to this:
> > [   52.274278] sun8i-ce 1c15000.crypto: Register sha1
> > [   52.279286] sun8i-ce 1c15000.crypto: sun8i_hash_crainit statesize is 96
> > [   52.285933] sun8i-ce 1c15000.crypto: Fallback for sha1-sun8i-ce is sha1-ce
> > [   52.312423] shash_default_export descsize=104
> > [   52.316021] alg: ahash: sha1-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\" statesize=96
> > [   52.333189] sun8i-ce 1c15000.crypto: Register sha224
> > [   52.338387] sun8i-ce 1c15000.crypto: sun8i_hash_crainit statesize is 104
> > [   52.345097] sun8i-ce 1c15000.crypto: Fallback for sha224-sun8i-ce is sha224-ce
> > [   52.371865] shash_default_export descsize=112
> > [   52.375459] alg: ahash: sha224-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\" statesize=104
> > [   52.393039] sun8i-ce 1c15000.crypto: Register sha256
> > [   52.398219] sun8i-ce 1c15000.crypto: sun8i_hash_crainit statesize is 104
> > [   52.404937] sun8i-ce 1c15000.crypto: Fallback for sha256-sun8i-ce is sha256-ce
> > [   52.431476] shash_default_export descsize=112
> > [   52.435073] alg: ahash: sha256-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\" statesize=104
> > 
> > For sha1, sha224 and sha256, my driver fail to pass the test.
> > This is due to the fact that export() (and so shash_async_export/shash_default_export) use crypto_shash_descsize() as length but selftest expect it to be statesize.
> 
> That doesn't appear to actually be the problem.  shash_default_export() does
> assume descsize == statesize, but it's only used when that's the case.
> See shash_prepare_alg().  
> 
> > Just in case, this is my export code:
> > int sun8i_hash_crainit(struct crypto_tfm *tfm)
> > {
> >         struct sun8i_hash_tfm_ctx *op = crypto_tfm_ctx(tfm);
> >         struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
> >         struct sun8i_ce_alg_template *algt;
> > 
> >         memset(op, 0, sizeof(struct sun8i_hash_tfm_ctx));
> > 
> >         crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm), sizeof(struct sun8i_hash_reqctx));
> > 
> >         op->fallback_tfm = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0, CRYPTO_ALG_NEED_FALLBACK);
> >         if (IS_ERR(op->fallback_tfm)) {
> >                 dev_err(algt->ce->dev, "Fallback driver cound no be loaded\n");
> >                 return PTR_ERR(op->fallback_tfm);
> >         }
> >         dev_info(op->ce->dev, "%s statesize is %u\n", __func__, algt->alg.hash.halg.statesize);
> >         dev_info(op->ce->dev, "Fallback for %s is %s\n",
> >                 crypto_tfm_alg_driver_name(tfm),
> >                 crypto_tfm_alg_driver_name(&op->fallback_tfm->base));
> >         return 0;
> > }
> > 
> > int sun8i_hash_init(struct ahash_request *areq)
> > {
> >         struct sun8i_hash_reqctx *rctx = ahash_request_ctx(areq);
> >         struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
> >         struct sun8i_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
> > 
> >         memset(rctx, 0, sizeof(struct sun8i_hash_reqctx));
> > 
> >         ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
> >         rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
> > 
> >         return crypto_ahash_init(&rctx->fallback_req);
> > }
> > 
> > int sun8i_hash_export(struct ahash_request *areq, void *out)
> > {
> >         struct sun8i_hash_reqctx *rctx = ahash_request_ctx(areq);
> >         struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
> >         struct sun8i_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
> > 
> >         ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
> >         rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
> >                                                                                 
> >         return crypto_ahash_export(&rctx->fallback_req, out);                   
> > }
> 
> It seems the actual problem is that you're doing the export using a fallback
> algorithm, which may have a statesize different from the one you're setting.
> 

Should not be a problem since all stuff before export is done by the fallback.

> But I'm not sure what you should do here, since the correct statesize can only
> be known when a tfm is allocated, not when the algorithm is registered.
> 
> Possibly statesize needs to be made a property of the tfm (struct crypto_ahash
> and crypto_shash) rather than the algorithm (struct hash_alg_common).
> 
> But are you sure you actually need a fallback algorithm for any hash algorithms
> in your driver in the first place?
> 

My goal is to do like n2-crypto/rk3288crypto/etc..., fallback for init/update/final/finup and only do stuff with digest().
So I have just exactly copied what they do.

Regards
