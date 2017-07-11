From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 1/2] staging: ccree: remove unnecessary cast on kmalloc
Date: Tue, 11 Jul 2017 16:44:42 +0300
Message-ID: <CAOtvUMd6LrRTddMfuGYg81K9EwX08SZeEYOta7ipUNAjSk2ZKg@mail.gmail.com>
References: <20170709054337.GA9031@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:36582 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755423AbdGKNon (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jul 2017 09:44:43 -0400
Received: by mail-yw0-f193.google.com with SMTP id l21so7139138ywb.3
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jul 2017 06:44:43 -0700 (PDT)
In-Reply-To: <20170709054337.GA9031@embeddedgus>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 9, 2017 at 8:43 AM, Gustavo A. R. Silva
<garsilva@embeddedor.com> wrote:
> The assignment operator implicitly converts a void pointer to the type of the
> pointer it is assigned to.
>
> This issue was detected using Coccinelle and the following semantic patch:
>
> @@
> expression * e;
> expression arg1, arg2;
> type T;
> @@
>
> - e=(T*)
> + e=
> kmalloc(arg1, arg2);
>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

For both patches:

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

> ---
>  drivers/staging/ccree/ssi_buffer_mgr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
> index b35871e..18a8694 100644
> --- a/drivers/staging/ccree/ssi_buffer_mgr.c
> +++ b/drivers/staging/ccree/ssi_buffer_mgr.c
> @@ -1725,8 +1725,7 @@ int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata)
>         struct buff_mgr_handle *buff_mgr_handle;
>         struct device *dev = &drvdata->plat_dev->dev;
>
> -       buff_mgr_handle = (struct buff_mgr_handle *)
> -               kmalloc(sizeof(struct buff_mgr_handle), GFP_KERNEL);
> +       buff_mgr_handle = kmalloc(sizeof(struct buff_mgr_handle), GFP_KERNEL);
>         if (!buff_mgr_handle)
>                 return -ENOMEM;
>
> --
> 2.5.0
>

Thanks,
Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
