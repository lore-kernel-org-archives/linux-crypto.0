From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2] staging: ccree: Use __func__ instead of function name
Date: Tue, 11 Jul 2017 16:40:03 +0300
Message-ID: <CAOtvUMerfaZj8zzooUM0Kvn0qntGo8RR3rRUH_UZz70wyL-orA@mail.gmail.com>
References: <20170629141829.GA29662@kroah.com> <1498756125-3330-1-git-send-email-karthik@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        sunil.m@techveda.org
To: karthik@techveda.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34846 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932430AbdGKNkE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jul 2017 09:40:04 -0400
Received: by mail-yw0-f193.google.com with SMTP id z21so7142802ywz.2
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jul 2017 06:40:04 -0700 (PDT)
In-Reply-To: <1498756125-3330-1-git-send-email-karthik@techveda.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Karthik ,

Thank you for the patch.

On Thu, Jun 29, 2017 at 8:08 PM,  <karthik@techveda.org> wrote:
> From: Karthik Tummala <karthik@techveda.org>
>
> Fixed following checkpatch.pl warning:
>         WARNING: Prefer using '"%s...", __func__' to using
> the function's name, in a string
>
> It is prefered to use '%s & __func__' instead of function
> name for logging.
>
> Signed-off-by: Karthik Tummala <karthik@techveda.org>
> ---
> Changes for v2:
> v1 was a patch series, which consisted of two patches in which
> second one was already submitted by Gilad Ben-Yossef, so dropped
> that one.
>
> Patch generated on staging-testing as suggested by Greg-K H.
> ---
>  drivers/staging/ccree/ssi_aead.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
> index 1fc0b05..1168161 100644
> --- a/drivers/staging/ccree/ssi_aead.c
> +++ b/drivers/staging/ccree/ssi_aead.c
> @@ -1886,7 +1886,7 @@ static int config_gcm_context(struct aead_request *req)
>                                 (req->cryptlen - ctx->authsize);
>         __be32 counter = cpu_to_be32(2);
>
> -       SSI_LOG_DEBUG("config_gcm_context() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n", cryptlen, req->assoclen, ctx->authsize);
> +       SSI_LOG_DEBUG("%s() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n", __func__, cryptlen, req->assoclen, ctx->authsize);
>
>         memset(req_ctx->hkey, 0, AES_BLOCK_SIZE);
>
> @@ -2198,7 +2198,7 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
>         struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
>         int rc = 0;
>
> -       SSI_LOG_DEBUG("ssi_rfc4106_gcm_setkey()  keylen %d, key %p\n", keylen, key);
> +       SSI_LOG_DEBUG("%s()  keylen %d, key %p\n", __func__, keylen, key);
>
>         if (keylen < 4)
>                 return -EINVAL;
> @@ -2216,7 +2216,7 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
>         struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
>         int rc = 0;
>
> -       SSI_LOG_DEBUG("ssi_rfc4543_gcm_setkey()  keylen %d, key %p\n", keylen, key);
> +       SSI_LOG_DEBUG("%s()  keylen %d, key %p\n", __func__, keylen, key);
>
>         if (keylen < 4)
>                 return -EINVAL;
> --
> 1.9.1
>

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
