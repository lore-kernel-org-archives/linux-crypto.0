Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF256C25B4E
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Jan 2023 14:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbjAXOIO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Jan 2023 09:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbjAXOIN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Jan 2023 09:08:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3A08A57
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jan 2023 06:08:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 31633CE1B41
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jan 2023 14:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3652C433EF;
        Tue, 24 Jan 2023 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674569288;
        bh=IRV5ZFE+rUMCLY7mK9OI1kvFWme36+e3QocMq7PoXtU=;
        h=In-Reply-To:References:Subject:From:To:Date:From;
        b=aPwNVD1WSxMbHCnmZ9FxbUw6ujytoTpf8gmxx5F9i7B7DX7YNrMw1OWmkJc58fLOf
         gbNqQD2i3qH6NscX8PBZeBXaTDqv+y68334oFswNxHke76A5Tpsl2AbYeaHmW1LlhZ
         iMU1LrdKz0/oQ1aRXsKC1/bSfM/ssbk98reNBmpd4tLyV/s6j1neUxSeEi4TbRoXDU
         /GtGRTCEu1GcfInD2clC3lqYl3MuLa6KLqV+rkvwjWyCre4w8tClAVSLjQZa3fIGKy
         bAx9whqq/FuVL46K3OWPhO4wgEqaJHwsSzixdz/wKBUXFu/kCSXjPBK9a+Cr9mjtzx
         ohh5Ks3sw4p/Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Y8+dwWHIz2058E43@gondor.apana.org.au>
References: <Y8+dwWHIz2058E43@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: safexcel - Use crypto_wait_req
From:   Antoine Tenart <atenart@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Date:   Tue, 24 Jan 2023 15:08:02 +0100
Message-ID: <167456928279.3459.8940827405751584580@kwain.local>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Herbert Xu (2023-01-24 09:58:41)
> This patch replaces the custom crypto completion function with
> crypto_req_done.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!
Antoine

> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/ins=
ide-secure/safexcel.c
> index ae6110376e21..baff0123f919 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -970,17 +970,6 @@ void safexcel_complete(struct safexcel_crypto_priv *=
priv, int ring)
>         } while (!cdesc->last_seg);
>  }
> =20
> -void safexcel_inv_complete(struct crypto_async_request *req, int error)
> -{
> -       struct safexcel_inv_result *result =3D req->data;
> -
> -       if (error =3D=3D -EINPROGRESS)
> -               return;
> -
> -       result->error =3D error;
> -       complete(&result->completion);
> -}
> -
>  int safexcel_invalidate_cache(struct crypto_async_request *async,
>                               struct safexcel_crypto_priv *priv,
>                               dma_addr_t ctxr_dma, int ring)
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/ins=
ide-secure/safexcel.h
> index 6c2fc662f64f..47ef6c7cd02c 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -884,11 +884,6 @@ struct safexcel_alg_template {
>         } alg;
>  };
> =20
> -struct safexcel_inv_result {
> -       struct completion completion;
> -       int error;
> -};
> -
>  void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring);
>  int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
>                                 void *rdp);
> @@ -927,7 +922,6 @@ void safexcel_rdr_req_set(struct safexcel_crypto_priv=
 *priv,
>                           struct crypto_async_request *req);
>  inline struct crypto_async_request *
>  safexcel_rdr_req_get(struct safexcel_crypto_priv *priv, int ring);
> -void safexcel_inv_complete(struct crypto_async_request *req, int error);
>  int safexcel_hmac_setkey(struct safexcel_context *base, const u8 *key,
>                          unsigned int keylen, const char *alg,
>                          unsigned int state_sz);
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/cry=
pto/inside-secure/safexcel_cipher.c
> index 32a37e3850c5..272c28b5a088 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -1091,13 +1091,12 @@ static int safexcel_aead_send(struct crypto_async=
_request *async, int ring,
>  static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm,
>                                     struct crypto_async_request *base,
>                                     struct safexcel_cipher_req *sreq,
> -                                   struct safexcel_inv_result *result)
> +                                   struct crypto_wait *result)
>  {
>         struct safexcel_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
>         struct safexcel_crypto_priv *priv =3D ctx->base.priv;
>         int ring =3D ctx->base.ring;
> -
> -       init_completion(&result->completion);
> +       int err;
> =20
>         ctx =3D crypto_tfm_ctx(base->tfm);
>         ctx->base.exit_inv =3D true;
> @@ -1110,13 +1109,13 @@ static int safexcel_cipher_exit_inv(struct crypto=
_tfm *tfm,
>         queue_work(priv->ring[ring].workqueue,
>                    &priv->ring[ring].work_data.work);
> =20
> -       wait_for_completion(&result->completion);
> +       err =3D crypto_wait_req(-EINPROGRESS, result);
> =20
> -       if (result->error) {
> +       if (err) {
>                 dev_warn(priv->dev,
>                         "cipher: sync: invalidate: completion error %d\n",
> -                        result->error);
> -               return result->error;
> +                        err);
> +               return err;
>         }
> =20
>         return 0;
> @@ -1126,12 +1125,12 @@ static int safexcel_skcipher_exit_inv(struct cryp=
to_tfm *tfm)
>  {
>         EIP197_REQUEST_ON_STACK(req, skcipher, EIP197_SKCIPHER_REQ_SIZE);
>         struct safexcel_cipher_req *sreq =3D skcipher_request_ctx(req);
> -       struct safexcel_inv_result result =3D {};
> +       DECLARE_CRYPTO_WAIT(result);
> =20
>         memset(req, 0, sizeof(struct skcipher_request));
> =20
>         skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -                                     safexcel_inv_complete, &result);
> +                                     crypto_req_done, &result);
>         skcipher_request_set_tfm(req, __crypto_skcipher_cast(tfm));
> =20
>         return safexcel_cipher_exit_inv(tfm, &req->base, sreq, &result);
> @@ -1141,12 +1140,12 @@ static int safexcel_aead_exit_inv(struct crypto_t=
fm *tfm)
>  {
>         EIP197_REQUEST_ON_STACK(req, aead, EIP197_AEAD_REQ_SIZE);
>         struct safexcel_cipher_req *sreq =3D aead_request_ctx(req);
> -       struct safexcel_inv_result result =3D {};
> +       DECLARE_CRYPTO_WAIT(result);
> =20
>         memset(req, 0, sizeof(struct aead_request));
> =20
>         aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -                                 safexcel_inv_complete, &result);
> +                                 crypto_req_done, &result);
>         aead_request_set_tfm(req, __crypto_aead_cast(tfm));
> =20
>         return safexcel_cipher_exit_inv(tfm, &req->base, sreq, &result);
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypt=
o/inside-secure/safexcel_hash.c
> index ca46328472d4..442f887e00ae 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -625,15 +625,16 @@ static int safexcel_ahash_exit_inv(struct crypto_tf=
m *tfm)
>         struct safexcel_crypto_priv *priv =3D ctx->base.priv;
>         EIP197_REQUEST_ON_STACK(req, ahash, EIP197_AHASH_REQ_SIZE);
>         struct safexcel_ahash_req *rctx =3D ahash_request_ctx_dma(req);
> -       struct safexcel_inv_result result =3D {};
> +       DECLARE_CRYPTO_WAIT(result);
>         int ring =3D ctx->base.ring;
> +       int err;
> =20
>         memset(req, 0, EIP197_AHASH_REQ_SIZE);
> =20
>         /* create invalidation request */
>         init_completion(&result.completion);
>         ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -                                  safexcel_inv_complete, &result);
> +                                  crypto_req_done, &result);
> =20
>         ahash_request_set_tfm(req, __crypto_ahash_cast(tfm));
>         ctx =3D crypto_tfm_ctx(req->base.tfm);
> @@ -647,12 +648,11 @@ static int safexcel_ahash_exit_inv(struct crypto_tf=
m *tfm)
>         queue_work(priv->ring[ring].workqueue,
>                    &priv->ring[ring].work_data.work);
> =20
> -       wait_for_completion(&result.completion);
> +       err =3D crypto_wait_req(-EINPROGRESS, &result);
> =20
> -       if (result.error) {
> -               dev_warn(priv->dev, "hash: completion error (%d)\n",
> -                        result.error);
> -               return result.error;
> +       if (err) {
> +               dev_warn(priv->dev, "hash: completion error (%d)\n", err);
> +               return err;
>         }
> =20
>         return 0;
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
