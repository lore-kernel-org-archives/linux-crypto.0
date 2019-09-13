Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A975C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 15:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 068982084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 15:27:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UXFvLAVa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388963AbfIMP1D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 11:27:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37841 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388231AbfIMP1C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 11:27:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id r195so3240224wme.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dow7yyNJ6pGUQjK4NegObzuzbNq0ZCz1AJMdGOcz4Dg=;
        b=UXFvLAVaUJay/ZUpfh3oGJiKZgL2twGD7fXmSdehnch+xJawusAK7ny1DKXikGYCNP
         lF4LATUYHejbY3NBt3Ch30f7gW+R8JLVNkdwka2kx3CBCyNiTLdgbcwGLpKyV5sZxyn9
         W6s1FwJ6fzhUvVGdppB3iLGkCRmkQR7zg1P5YAf+j3rvZoi18JM5FfzqvgZvQV5pvpiJ
         sYp0e2emikH8vBItpmxya1a1qxz2VFr7QMbM2rMlOPla8xHfcCTd7opIhOfHEi/ezn08
         VH7CVa1QUjS9pdl9saCowbnyEE8nSraNI+kIJCXFzXs6e65yx5qe/yKSTWUMVyA/2R3Y
         LvIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dow7yyNJ6pGUQjK4NegObzuzbNq0ZCz1AJMdGOcz4Dg=;
        b=qfXZ0XqukxgnapECLJZkU0KYjpPMHo2vdnFAe/n4AVfdI5h6mtbc3FAY5+0YcdpBNL
         zKhpIkhmfTT3L4spII4EUG9Y3f7lb5rMky6zJMfEoS6tcpdB2PPXEyZJa6uLt8xhhFip
         MyjdQZyeRJSnpLQlRINXllCmG8Qwk+4D2Nt+PYefeOP+etji9mEJKW2RfkVb8SA1Uz0W
         Rwj1dPC5eW/gnYI/JRhypzdT5wBfpBcLZeMcEZ3MnieMw+qoaTZLoNqbIE/fiP2hcBha
         5iit+xdw33WDZpfZP+F0rFxnYDUUNqU0FPhaiy5F8e58eSqrChX2vuTdZ2YfoxWUaKbh
         xq4w==
X-Gm-Message-State: APjAAAWy38e+LW0wy0JAs1qO9+t8veeNKZQbrTWjjCEySpNFQH3rHR6m
        wt4uAMbUnp0KcIF2VTEW4PNiskad6vJ+7aUeeDs+Gw==
X-Google-Smtp-Source: APXvYqxlU9q4IjfOJ3bgLGWU48YbnVD+OF8+Y/ZLbfq+MYYYLFbWlcnt11bV2YgeaNwEjoyhdjhOuFEwttBEH1IWnJs=
X-Received: by 2002:a7b:c451:: with SMTP id l17mr3490967wmi.61.1568388419686;
 Fri, 13 Sep 2019 08:26:59 -0700 (PDT)
MIME-Version: 1.0
References: <1568383406-8009-1-git-send-email-pvanleeuwen@verimatrix.com> <1568383406-8009-2-git-send-email-pvanleeuwen@verimatrix.com>
In-Reply-To: <1568383406-8009-2-git-send-email-pvanleeuwen@verimatrix.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 13 Sep 2019 16:26:37 +0100
Message-ID: <CAKv+Gu_qMDxNDYnMOmV1mA4+JwX3eAB3B-4aC=YJ07oZrz+wCg@mail.gmail.com>
Subject: Re: [PATCH 1/3] crypto: inside-secure - Added support for authenc HMAC-SHA1/DES-CBC
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 13 Sep 2019 at 16:06, Pascal van Leeuwen <pascalvanl@gmail.com> wrote:
>
> This patch adds support for the authenc(hmac(sha1),cbc(des)) aead
>
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Please make sure your code is based on cryptodev/master before sending
it to the list.

-- 
Ard.

> ---
>  drivers/crypto/inside-secure/safexcel.c        |  1 +
>  drivers/crypto/inside-secure/safexcel.h        |  1 +
>  drivers/crypto/inside-secure/safexcel_cipher.c | 45 ++++++++++++++++++++++++++
>  3 files changed, 47 insertions(+)
>
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index 12cb939..617c70b 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1195,6 +1195,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
>         &safexcel_alg_hmac_sha3_256,
>         &safexcel_alg_hmac_sha3_384,
>         &safexcel_alg_hmac_sha3_512,
> +       &safexcel_alg_authenc_hmac_sha1_cbc_des,
>  };
>
>  static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> index 82953b3..b020e27 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -895,5 +895,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
>  extern struct safexcel_alg_template safexcel_alg_hmac_sha3_256;
>  extern struct safexcel_alg_template safexcel_alg_hmac_sha3_384;
>  extern struct safexcel_alg_template safexcel_alg_hmac_sha3_512;
> +extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des;
>
>  #endif
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index bf2b1f9..435f184 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -348,6 +348,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>         struct safexcel_crypto_priv *priv = ctx->priv;
>         struct crypto_authenc_keys keys;
>         struct crypto_aes_ctx aes;
> +       u32 tmp[DES_EXPKEY_WORDS];
>         u32 flags;
>         int err = -EINVAL;
>
> @@ -367,6 +368,16 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>
>         /* Encryption key */
>         switch (ctx->alg) {
> +       case SAFEXCEL_DES:
> +               if (keys.enckeylen != DES_KEY_SIZE)
> +                       goto badkey;
> +               err = des_ekey(tmp, key);
> +               if (unlikely(!err && (tfm->crt_flags &
> +                                     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS))) {
> +                       tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
> +                       goto badkey_expflags;
> +               }
> +               break;
>         case SAFEXCEL_3DES:
>                 if (keys.enckeylen != DES3_EDE_KEY_SIZE)
>                         goto badkey;
> @@ -1854,6 +1865,40 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
>         },
>  };
>
> +static int safexcel_aead_sha1_des_cra_init(struct crypto_tfm *tfm)
> +{
> +       struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +       safexcel_aead_sha1_cra_init(tfm);
> +       ctx->alg = SAFEXCEL_DES; /* override default */
> +       return 0;
> +}
> +
> +struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des = {
> +       .type = SAFEXCEL_ALG_TYPE_AEAD,
> +       .algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA1,
> +       .alg.aead = {
> +               .setkey = safexcel_aead_setkey,
> +               .encrypt = safexcel_aead_encrypt,
> +               .decrypt = safexcel_aead_decrypt,
> +               .ivsize = DES_BLOCK_SIZE,
> +               .maxauthsize = SHA1_DIGEST_SIZE,
> +               .base = {
> +                       .cra_name = "authenc(hmac(sha1),cbc(des))",
> +                       .cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des",
> +                       .cra_priority = SAFEXCEL_CRA_PRIORITY,
> +                       .cra_flags = CRYPTO_ALG_ASYNC |
> +                                    CRYPTO_ALG_KERN_DRIVER_ONLY,
> +                       .cra_blocksize = DES_BLOCK_SIZE,
> +                       .cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
> +                       .cra_alignmask = 0,
> +                       .cra_init = safexcel_aead_sha1_des_cra_init,
> +                       .cra_exit = safexcel_aead_cra_exit,
> +                       .cra_module = THIS_MODULE,
> +               },
> +       },
> +};
> +
>  static int safexcel_aead_sha1_ctr_cra_init(struct crypto_tfm *tfm)
>  {
>         struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> --
> 1.8.3.1
>
