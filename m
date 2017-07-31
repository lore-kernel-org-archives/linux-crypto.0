From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] ccree: Removed a sparse warning in ssi_fips.h
Date: Mon, 31 Jul 2017 08:13:41 +0300
Message-ID: <CAOtvUMeL+dee4vH66ZYhkSHxYfO6O-i0___sOdQng0xkMsFT1Q@mail.gmail.com>
References: <1501424133-27810-1-git-send-email-rishabheudyptula@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
To: rishabh hardas <rishabheudyptula@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:38291 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbdGaFNn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 01:13:43 -0400
Received: by mail-it0-f65.google.com with SMTP id h199so13981291ith.5
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jul 2017 22:13:42 -0700 (PDT)
In-Reply-To: <1501424133-27810-1-git-send-email-rishabheudyptula@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Rishabh,

Thanks you for spotting this.

On Sun, Jul 30, 2017 at 5:15 PM, rishabh hardas
<rishabheudyptula@gmail.com> wrote:
> Sparse was giving out a warning 'warning: symbol 'cc_set_ree_fips_status' was not declared. Should it be static?'
> which has been removed by making it static.
>
> Signed-off-by: rishabh hardas <rishabheudyptula@gmail.com>
> ---
>  drivers/staging/ccree/ssi_fips.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
> index 369ddf9..846bd55 100644
> --- a/drivers/staging/ccree/ssi_fips.h
> +++ b/drivers/staging/ccree/ssi_fips.h
> @@ -40,7 +40,7 @@ static inline int ssi_fips_init(struct ssi_drvdata *p_drvdata)
>  }
>
>  static inline void ssi_fips_fini(struct ssi_drvdata *drvdata) {}
> -void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
> +static void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
>  void fips_handler(struct ssi_drvdata *drvdata) {}
>
>  #endif /* CONFIG_CRYPTO_FIPS */
> --
> 2.7.4
>

A better modifier here would be "static inline". While you're at it
you can also apply it to the fips_handler() function below.

Also, please use a descriptive title, maybe: "declare compiled out
func  static inline"

Last, please CC ALL the appropriate mailing lists. Use the kernel
get_maintainer script to find out which if you are unsure.

Thanks again,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
