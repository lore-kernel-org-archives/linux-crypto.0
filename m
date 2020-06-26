Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECB1C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 18:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1821D206DD
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593195331;
	bh=9LZcPr01AwXdBok4ZS2ZJD8Se8kdpKRRRb62pqWtIlY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=UOq/yDekWg97swvFh8NOfEK3cVNAgfKXrKLmS9iGh1fuRjRGjt9zKMwcKk+Q204cM
	 TComHU2EC/4fTnitA05oVKqgjdLkfhkcnAJynYGq8HTQKhTo5rJETpMVdha7VS+oP4
	 CZhN7e/ga107mwvubb43sNTOut7e9ZUrjw+6nmeI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgFZSPa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 14:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgFZSPa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 14:15:30 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1562C206DD
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jun 2020 18:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593195329;
        bh=9LZcPr01AwXdBok4ZS2ZJD8Se8kdpKRRRb62pqWtIlY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dZPHQZMEDCxrWsQYfAWu/HYT3y7YfArBbRg7Gg1k20HHEcHl3h4I8PfUi2fVtyS/H
         W9xIwE+8An1gdRHUnJa8p3QTOkYxokKLiWwS4BcTbdllte0YmZpCumfw6zTg3VZYIF
         Nf/rjUol41KHxvwD5uVMe0QtwDqyWIYqrtvGC1Qk=
Received: by mail-oi1-f173.google.com with SMTP id l63so8788922oih.13
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jun 2020 11:15:29 -0700 (PDT)
X-Gm-Message-State: AOAM531wHg6b5VSJ5s8fJ9eMb1GHCAY9QWPME+Io/smWczFFeqXxJjUH
        YnmNX2wy1WziKOiAHtvc8Gw401yNjqjCqrR7ezY=
X-Google-Smtp-Source: ABdhPJx3YUNKQ/ADBt1i2kDU3b5qWrIenewVx2GtHzvMRdJgKtULanrgpJdFeNPNxaniCoPgp3toZxTWPdTIBCc3DFY=
X-Received: by 2002:aca:ba03:: with SMTP id k3mr3445760oif.33.1593195328433;
 Fri, 26 Jun 2020 11:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200626080429.155450-1-giovanni.cabiddu@intel.com> <20200626080429.155450-5-giovanni.cabiddu@intel.com>
In-Reply-To: <20200626080429.155450-5-giovanni.cabiddu@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 26 Jun 2020 20:15:16 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGu4_Fp=0i9FUJuRUknsUrf0Ci=r9gMb5+Zf+hVXN4-rw@mail.gmail.com>
Message-ID: <CAMj1kXGu4_Fp=0i9FUJuRUknsUrf0Ci=r9gMb5+Zf+hVXN4-rw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] crypto: qat - fallback for xts with 192 bit keys
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        qat-linux@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 26 Jun 2020 at 10:04, Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> Forward requests to another provider if the key length is 192 bits as
> this is not supported by the QAT accelerators.
>
> This fixes the following issue reported by the extra self test:
> alg: skcipher: qat_aes_xts setkey failed on test vector "random: len=3204
> klen=48"; expected_error=0, actual_error=-22, flags=0x1
>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_algs.c | 67 ++++++++++++++++++++++--
>  1 file changed, 64 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> index 77bdff0118f7..5e8c0b6f2834 100644
> --- a/drivers/crypto/qat/qat_common/qat_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> @@ -88,6 +88,8 @@ struct qat_alg_skcipher_ctx {
>         struct icp_qat_fw_la_bulk_req enc_fw_req;
>         struct icp_qat_fw_la_bulk_req dec_fw_req;
>         struct qat_crypto_instance *inst;
> +       struct crypto_skcipher *ftfm;
> +       bool fallback;
>  };
>
>  static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
> @@ -994,12 +996,25 @@ static int qat_alg_skcipher_ctr_setkey(struct crypto_skcipher *tfm,
>  static int qat_alg_skcipher_xts_setkey(struct crypto_skcipher *tfm,
>                                        const u8 *key, unsigned int keylen)
>  {
> +       struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
>         int ret;
>
>         ret = xts_verify_key(tfm, key, keylen);
>         if (ret)
>                 return ret;
>
> +       if (keylen >> 1 == AES_KEYSIZE_192) {
> +               ret = crypto_skcipher_setkey(ctx->ftfm, key, keylen);
> +               if (ret)
> +                       return ret;
> +
> +               ctx->fallback = true;
> +
> +               return 0;
> +       }
> +
> +       ctx->fallback = false;
> +
>         return qat_alg_skcipher_setkey(tfm, key, keylen,
>                                        ICP_QAT_HW_CIPHER_XTS_MODE);
>  }
> @@ -1066,9 +1081,19 @@ static int qat_alg_skcipher_blk_encrypt(struct skcipher_request *req)
>
>  static int qat_alg_skcipher_xts_encrypt(struct skcipher_request *req)
>  {
> +       struct crypto_skcipher *stfm = crypto_skcipher_reqtfm(req);
> +       struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(stfm);
> +       struct skcipher_request *nreq = skcipher_request_ctx(req);
> +
>         if (req->cryptlen < XTS_BLOCK_SIZE)
>                 return -EINVAL;
>
> +       if (ctx->fallback) {
> +               memcpy(nreq, req, sizeof(*req));
> +               skcipher_request_set_tfm(nreq, ctx->ftfm);
> +               return crypto_skcipher_encrypt(nreq);
> +       }
> +
>         return qat_alg_skcipher_encrypt(req);
>  }
>
> @@ -1134,9 +1159,19 @@ static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
>
>  static int qat_alg_skcipher_xts_decrypt(struct skcipher_request *req)
>  {
> +       struct crypto_skcipher *stfm = crypto_skcipher_reqtfm(req);
> +       struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(stfm);
> +       struct skcipher_request *nreq = skcipher_request_ctx(req);
> +
>         if (req->cryptlen < XTS_BLOCK_SIZE)
>                 return -EINVAL;
>
> +       if (ctx->fallback) {
> +               memcpy(nreq, req, sizeof(*req));
> +               skcipher_request_set_tfm(nreq, ctx->ftfm);
> +               return crypto_skcipher_decrypt(nreq);
> +       }
> +
>         return qat_alg_skcipher_decrypt(req);
>  }
>
> @@ -1200,6 +1235,23 @@ static int qat_alg_skcipher_init_tfm(struct crypto_skcipher *tfm)
>         return 0;
>  }
>
> +static int qat_alg_skcipher_init_xts_tfm(struct crypto_skcipher *tfm)
> +{
> +       struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       int reqsize;
> +
> +       ctx->ftfm = crypto_alloc_skcipher("xts(aes)", 0, CRYPTO_ALG_ASYNC);

Why are you only permitting synchronous fallbacks? If the logic above
is sound, and copies the base.complete and base.data fields as well,
the fallback can complete asynchronously without problems.

Note that SIMD s/w implementations of XTS(AES) are asynchronous as
well, as they use the crypto_simd helper which queues requests for
asynchronous completion if the context from which the request was
issued does not permit access to the SIMD register file (e.g., softirq
context on some architectures, if the interrupted context is also
using SIMD)


> +       if (IS_ERR(ctx->ftfm))
> +               return PTR_ERR(ctx->ftfm);
> +
> +       reqsize = max(sizeof(struct qat_crypto_request),
> +                     sizeof(struct skcipher_request) +
> +                     crypto_skcipher_reqsize(ctx->ftfm));
> +       crypto_skcipher_set_reqsize(tfm, reqsize);
> +
> +       return 0;
> +}
> +
>  static void qat_alg_skcipher_exit_tfm(struct crypto_skcipher *tfm)
>  {
>         struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> @@ -1227,6 +1279,15 @@ static void qat_alg_skcipher_exit_tfm(struct crypto_skcipher *tfm)
>         qat_crypto_put_instance(inst);
>  }
>
> +static void qat_alg_skcipher_exit_xts_tfm(struct crypto_skcipher *tfm)
> +{
> +       struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> +
> +       if (ctx->ftfm)
> +               crypto_free_skcipher(ctx->ftfm);
> +
> +       qat_alg_skcipher_exit_tfm(tfm);
> +}
>
>  static struct aead_alg qat_aeads[] = { {
>         .base = {
> @@ -1321,14 +1382,14 @@ static struct skcipher_alg qat_skciphers[] = { {
>         .base.cra_name = "xts(aes)",
>         .base.cra_driver_name = "qat_aes_xts",
>         .base.cra_priority = 4001,
> -       .base.cra_flags = CRYPTO_ALG_ASYNC,
> +       .base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
>         .base.cra_blocksize = AES_BLOCK_SIZE,
>         .base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
>         .base.cra_alignmask = 0,
>         .base.cra_module = THIS_MODULE,
>
> -       .init = qat_alg_skcipher_init_tfm,
> -       .exit = qat_alg_skcipher_exit_tfm,
> +       .init = qat_alg_skcipher_init_xts_tfm,
> +       .exit = qat_alg_skcipher_exit_xts_tfm,
>         .setkey = qat_alg_skcipher_xts_setkey,
>         .decrypt = qat_alg_skcipher_xts_decrypt,
>         .encrypt = qat_alg_skcipher_xts_encrypt,
> --
> 2.26.2
>
