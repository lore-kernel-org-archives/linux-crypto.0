From: Steve Lin <steven.lin1@broadcom.com>
Subject: Re: [PATCH] crypto: brcm: fix spelling mistake: "genereate" -> "generate"
Date: Fri, 24 Feb 2017 07:57:04 -0500
Message-ID: <CA+Jmh7EfHs8W7noZZk0OBAKc3Ut8-DikD64FkbYZB2kZ-8xYAg@mail.gmail.com>
References: <20170222235138.8531-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:35359 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbdBXNDg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2017 08:03:36 -0500
Received: by mail-qt0-f174.google.com with SMTP id x35so15890982qtc.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2017 05:03:35 -0800 (PST)
In-Reply-To: <20170222235138.8531-1-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Looks good, thanks!

Acked-by: Steve Lin <steven.lin1@broadcom.com>

On Wed, Feb 22, 2017 at 6:51 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> trivial fix to spelling mistake in pr_err message
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/crypto/bcm/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
> index 0502f46..430c557 100644
> --- a/drivers/crypto/bcm/util.c
> +++ b/drivers/crypto/bcm/util.c
> @@ -312,7 +312,7 @@ int do_shash(unsigned char *name, unsigned char *result,
>         }
>         rc = crypto_shash_final(&sdesc->shash, result);
>         if (rc)
> -               pr_err("%s: Could not genereate %s hash", __func__, name);
> +               pr_err("%s: Could not generate %s hash", __func__, name);
>
>  do_shash_err:
>         crypto_free_shash(hash);
> --
> 2.10.2
>
