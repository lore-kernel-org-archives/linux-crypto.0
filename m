Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B871EC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 11:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FC05207E8
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 11:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595934372;
	bh=dbTjJ9TIdgE8aB9RTWLGqKff12TKLi+ffpHOk3wSl+U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Gbc/mA3owJkJbA6YjILRA2vhv0+jfuBr9aH0pDmUW93mPH+EBhq8MX/fhgkzs/WnD
	 K36KjJCAx0F2tyC+iZnWwjBSSMSOcsX9zvfH0fL6terqQwNBBDl3G6mQ1mqhXWe373
	 PatJpzF9noAjZ1ghcMT0dmWsse97rcUm8kkqB8pQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgG1LGL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 07:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbgG1LGL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 07:06:11 -0400
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B5DB20775
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 11:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595934370;
        bh=dbTjJ9TIdgE8aB9RTWLGqKff12TKLi+ffpHOk3wSl+U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VMp0cUgH0m1KIhjkWpKfq7mA3ROogJ60W+5MY5fhBsV5ECvwP22BLdz8/T4ymls2V
         41ckEkED7oKP+c53QLOM/7K3BkS5MqlHvlUdUPCGlCyfPieWgT0LLDW0nQXFWaxgeZ
         eyq8wAqPQO1bPzMGtnag4ls6GR0cP04h2fY6E2u0=
Received: by mail-oi1-f172.google.com with SMTP id q4so5349167oia.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 04:06:10 -0700 (PDT)
X-Gm-Message-State: AOAM5306vf8K02QOqTOOIK7D+p/Toh32oIfM7EzaQvxQPcu6KibmN8xO
        CFZnkLQtGZNLLrSg+9lOoQukkvCFpBskW92ObUo=
X-Google-Smtp-Source: ABdhPJzYLM+4lGQQgjwtaU7NHzTabKZSkotVxYp93/P9VdVzto8Fxvu+3YB47asNnPOh9/6pQu/B7KDjSZbWhiyEyt4=
X-Received: by 2002:aca:cc0a:: with SMTP id c10mr3109386oig.174.1595934369842;
 Tue, 28 Jul 2020 04:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200728071746.GA22352@gondor.apana.org.au> <E1k0Jsq-0006I8-1l@fornost.hmeau.com>
In-Reply-To: <E1k0Jsq-0006I8-1l@fornost.hmeau.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 28 Jul 2020 14:05:58 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHoKQhMjHxsGk55xEu+FF87Bu2CGqFWPcp-G6RLUFFAHg@mail.gmail.com>
Message-ID: <CAMj1kXHoKQhMjHxsGk55xEu+FF87Bu2CGqFWPcp-G6RLUFFAHg@mail.gmail.com>
Subject: Re: [v3 PATCH 3/31] crypto: cts - Add support for chaining
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 28 Jul 2020 at 10:18, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> As it stands cts cannot do chaining.  That is, it always performs
> the cipher-text stealing at the end of a request.  This patch adds
> support for chaining when the CRYPTO_TM_REQ_MORE flag is set.
>
> It also sets final_chunksize so that data can be withheld by the
> caller to enable correct processing at the true end of a request.
>

But isn't the final chunksize a function of cryptlen? What happens if
i try to use cts(cbc(aes)) to encrypt 16 bytes with the MORE flag, and
<16 additional bytes as the final chunk?


> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>
>  crypto/cts.c |   19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/crypto/cts.c b/crypto/cts.c
> index 3766d47ebcc01..67990146c9b06 100644
> --- a/crypto/cts.c
> +++ b/crypto/cts.c
> @@ -100,7 +100,7 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
>         struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>         struct skcipher_request *subreq = &rctx->subreq;
> -       int bsize = crypto_skcipher_blocksize(tfm);
> +       int bsize = crypto_skcipher_chunksize(tfm);
>         u8 d[MAX_CIPHER_BLOCKSIZE * 2] __aligned(__alignof__(u32));
>         struct scatterlist *sg;
>         unsigned int offset;
> @@ -146,7 +146,7 @@ static int crypto_cts_encrypt(struct skcipher_request *req)
>         struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
>         struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
>         struct skcipher_request *subreq = &rctx->subreq;
> -       int bsize = crypto_skcipher_blocksize(tfm);
> +       int bsize = crypto_skcipher_chunksize(tfm);
>         unsigned int nbytes = req->cryptlen;
>         unsigned int offset;
>
> @@ -155,7 +155,7 @@ static int crypto_cts_encrypt(struct skcipher_request *req)
>         if (nbytes < bsize)
>                 return -EINVAL;
>
> -       if (nbytes == bsize) {
> +       if (nbytes == bsize || req->base.flags & CRYPTO_TFM_REQ_MORE) {
>                 skcipher_request_set_callback(subreq, req->base.flags,
>                                               req->base.complete,
>                                               req->base.data);
> @@ -181,7 +181,7 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
>         struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>         struct skcipher_request *subreq = &rctx->subreq;
> -       int bsize = crypto_skcipher_blocksize(tfm);
> +       int bsize = crypto_skcipher_chunksize(tfm);
>         u8 d[MAX_CIPHER_BLOCKSIZE * 2] __aligned(__alignof__(u32));
>         struct scatterlist *sg;
>         unsigned int offset;
> @@ -240,7 +240,7 @@ static int crypto_cts_decrypt(struct skcipher_request *req)
>         struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
>         struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
>         struct skcipher_request *subreq = &rctx->subreq;
> -       int bsize = crypto_skcipher_blocksize(tfm);
> +       int bsize = crypto_skcipher_chunksize(tfm);
>         unsigned int nbytes = req->cryptlen;
>         unsigned int offset;
>         u8 *space;
> @@ -250,7 +250,7 @@ static int crypto_cts_decrypt(struct skcipher_request *req)
>         if (nbytes < bsize)
>                 return -EINVAL;
>
> -       if (nbytes == bsize) {
> +       if (nbytes == bsize || req->base.flags & CRYPTO_TFM_REQ_MORE) {
>                 skcipher_request_set_callback(subreq, req->base.flags,
>                                               req->base.complete,
>                                               req->base.data);
> @@ -297,7 +297,7 @@ static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
>         ctx->child = cipher;
>
>         align = crypto_skcipher_alignmask(tfm);
> -       bsize = crypto_skcipher_blocksize(cipher);
> +       bsize = crypto_skcipher_chunksize(cipher);
>         reqsize = ALIGN(sizeof(struct crypto_cts_reqctx) +
>                         crypto_skcipher_reqsize(cipher),
>                         crypto_tfm_ctx_alignment()) +
> @@ -359,11 +359,12 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
>                 goto err_free_inst;
>
>         inst->alg.base.cra_priority = alg->base.cra_priority;
> -       inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
> +       inst->alg.base.cra_blocksize = 1;
>         inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
>
>         inst->alg.ivsize = alg->base.cra_blocksize;
> -       inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
> +       inst->alg.chunksize = alg->base.cra_blocksize;
> +       inst->alg.final_chunksize = inst->alg.chunksize * 2;
>         inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
>         inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
>
