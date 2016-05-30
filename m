From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 2/2] crypto: omap: convert to the new cryptoengine API
Date: Mon, 30 May 2016 10:20:01 +0800
Message-ID: <CAMz4kuJuR+UOTxA8y3em9tevubZZaFLpwCkXNsMQy1dJAPV=XQ@mail.gmail.com>
References: <1463563285-11742-1-git-send-email-clabbe.montjoie@gmail.com>
	<1463563285-11742-3-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:34165 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbcE3CUC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 May 2016 22:20:02 -0400
Received: by mail-yw0-f178.google.com with SMTP id c127so152098857ywb.1
        for <linux-crypto@vger.kernel.org>; Sun, 29 May 2016 19:20:01 -0700 (PDT)
In-Reply-To: <1463563285-11742-3-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 May 2016 at 17:21, LABBE Corentin <clabbe.montjoie@gmail.com> wrote:
> Since the crypto engine has been converted to use crypto_async_request
> instead of ablkcipher_request, minor changes are needed to use it.

I think you missed the conversion for omap des driver, please rebase
your patch. Beyond that I think you did a good job for crypto engine
if Herbert applied it.

>
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/omap-aes.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index d420ec7..1368ab1 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -530,7 +530,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
>
>         pr_debug("err: %d\n", err);
>
> -       crypto_finalize_request(dd->engine, req, err);
> +       crypto_finalize_request(dd->engine, &req->base, err);
>  }
>
>  static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
> @@ -603,14 +603,15 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
>                                  struct ablkcipher_request *req)
>  {
>         if (req)
> -               return crypto_transfer_request_to_engine(dd->engine, req);
> +               return crypto_transfer_request_to_engine(dd->engine, &req->base);
>
>         return 0;
>  }
>
>  static int omap_aes_prepare_req(struct crypto_engine *engine,
> -                               struct ablkcipher_request *req)
> +                               struct crypto_async_request *areq)
>  {
> +       struct ablkcipher_request *req = ablkcipher_request_cast(areq);
>         struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
>                         crypto_ablkcipher_reqtfm(req));
>         struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
> @@ -653,8 +654,9 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
>  }
>
>  static int omap_aes_crypt_req(struct crypto_engine *engine,
> -                             struct ablkcipher_request *req)
> +                             struct crypto_async_request *areq)
>  {
> +       struct ablkcipher_request *req = ablkcipher_request_cast(areq);
>         struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
>                         crypto_ablkcipher_reqtfm(req));
>         struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
> --
> 2.7.3
>



-- 
Baolin.wang
Best Regards
