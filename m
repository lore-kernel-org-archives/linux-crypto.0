Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE109C2D0B1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 08:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81C8120720
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 08:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iEsaXv9E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgBFIyq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 03:54:46 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:40626 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgBFIyq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 03:54:46 -0500
Received: by mail-wm1-f41.google.com with SMTP id t14so5944982wmi.5;
        Thu, 06 Feb 2020 00:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=n8K6Uk60ZBI22hEL5Rq+bbY+6RRavZ414qeizloZ1Yc=;
        b=iEsaXv9ELIvSxdNO3w56aQeUZ95VKct3OWPJOlOyiRswf1qJYdioOUJS4NkWQBvA16
         l6EP7XpsczRW0tf+bFPfcOZZpb53tuyrDr/sxJIIbhrndPGWhXteM9864ah2C8wmbqYr
         +GEbqmq2uxsgdgLP1cnpDNGEBeVzyFqQOmA0tjDmtwxmLEbctqQpyUwfmrJreAjQClP0
         gWlMzd0LYOMF9IAHKcW02I5nou4tOK7PtN7VX+KbchhE8h25hiUHVmVA0rZMZfF1xm0g
         f6G80yXwXcrO447ciY9tqeLgbniLoMkmFtbpG8udWeOU+qZ5OFpD7NBUxSxMCDnrbZdD
         4jlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=n8K6Uk60ZBI22hEL5Rq+bbY+6RRavZ414qeizloZ1Yc=;
        b=R1EMhHmLncowRy+82Jlrgozy6LL/lYUWLSKoNPs2Rd0/SXmPCUmrZX7X4gmSZ6Du2r
         qXII2DwYJbBpDzURyYsq6JGNsoGEGtGqOCexbJ112TKREcizF955D48orQkllQXzmyFu
         35Nm1lx64GoXQ8K/zU5Me3jYsMBdXjX82MD3/iJIpWNdkuJ5rSjghfee7eYmA6L9mv8E
         fQmuMAvEG6G+Ux8JPSUgOYfMOjuJaF+8BC9pOC87eXuVm9sIqvY+T6VDOEmamN8pGaRS
         61CdZ4HOdQYaHAYX2wje+cLgHS5HK+Wxd8VeW8CN95bMHyImH1gqFEkE9sb4t1oOiEWa
         ht5g==
X-Gm-Message-State: APjAAAVTu0i7HUT9+5cXwMAlQZW7Fxa5KvkEgb+ftVvdTugB+xYNDyiz
        NVn8nVtXi0SkZ9QlzBlRLSuVOQ91
X-Google-Smtp-Source: APXvYqwGrkdbWZi5uo1ZImUiYwhGbqUfEEM+1TB3yLqMY2OIOGQTLTtzw0RCIUwnukOPumL6loee+g==
X-Received: by 2002:a05:600c:285:: with SMTP id 5mr3189763wmk.120.1580979284401;
        Thu, 06 Feb 2020 00:54:44 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 11sm2989068wmb.14.2020.02.06.00.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 00:54:43 -0800 (PST)
Date:   Thu, 6 Feb 2020 09:54:42 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [BUG] crypto: export() overran state buffer on test vector
Message-ID: <20200206085442.GA5585@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

When working on adding hash support on sun8i-ce, I made a simple version which always fallback.
but booting it lead to this:
[   52.274278] sun8i-ce 1c15000.crypto: Register sha1
[   52.279286] sun8i-ce 1c15000.crypto: sun8i_hash_crainit statesize is 96
[   52.285933] sun8i-ce 1c15000.crypto: Fallback for sha1-sun8i-ce is sha1-ce
[   52.312423] shash_default_export descsize=104
[   52.316021] alg: ahash: sha1-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\" statesize=96
[   52.333189] sun8i-ce 1c15000.crypto: Register sha224
[   52.338387] sun8i-ce 1c15000.crypto: sun8i_hash_crainit statesize is 104
[   52.345097] sun8i-ce 1c15000.crypto: Fallback for sha224-sun8i-ce is sha224-ce
[   52.371865] shash_default_export descsize=112
[   52.375459] alg: ahash: sha224-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\" statesize=104
[   52.393039] sun8i-ce 1c15000.crypto: Register sha256
[   52.398219] sun8i-ce 1c15000.crypto: sun8i_hash_crainit statesize is 104
[   52.404937] sun8i-ce 1c15000.crypto: Fallback for sha256-sun8i-ce is sha256-ce
[   52.431476] shash_default_export descsize=112
[   52.435073] alg: ahash: sha256-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\" statesize=104

For sha1, sha224 and sha256, my driver fail to pass the test.
This is due to the fact that export() (and so shash_async_export/shash_default_export) use crypto_shash_descsize() as length but selftest expect it to be statesize.

Just in case, this is my export code:
int sun8i_hash_crainit(struct crypto_tfm *tfm)
{
        struct sun8i_hash_tfm_ctx *op = crypto_tfm_ctx(tfm);
        struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
        struct sun8i_ce_alg_template *algt;

        memset(op, 0, sizeof(struct sun8i_hash_tfm_ctx));

        crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm), sizeof(struct sun8i_hash_reqctx));

        op->fallback_tfm = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0, CRYPTO_ALG_NEED_FALLBACK);
        if (IS_ERR(op->fallback_tfm)) {
                dev_err(algt->ce->dev, "Fallback driver cound no be loaded\n");
                return PTR_ERR(op->fallback_tfm);
        }
        dev_info(op->ce->dev, "%s statesize is %u\n", __func__, algt->alg.hash.halg.statesize);
        dev_info(op->ce->dev, "Fallback for %s is %s\n",
                crypto_tfm_alg_driver_name(tfm),
                crypto_tfm_alg_driver_name(&op->fallback_tfm->base));
        return 0;
}

int sun8i_hash_init(struct ahash_request *areq)
{
        struct sun8i_hash_reqctx *rctx = ahash_request_ctx(areq);
        struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
        struct sun8i_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);

        memset(rctx, 0, sizeof(struct sun8i_hash_reqctx));

        ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
        rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;

        return crypto_ahash_init(&rctx->fallback_req);
}

int sun8i_hash_export(struct ahash_request *areq, void *out)
{
        struct sun8i_hash_reqctx *rctx = ahash_request_ctx(areq);
        struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
        struct sun8i_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);

        ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
        rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
                                                                                
        return crypto_ahash_export(&rctx->fallback_req, out);                   
}

Regards
