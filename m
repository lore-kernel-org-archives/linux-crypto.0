Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35EBFC282C5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 12:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02FEE2184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 12:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="wtE7yITG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfAWM6g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 07:58:36 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:45126 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfAWM6g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 07:58:36 -0500
Received: by mail-ua1-f66.google.com with SMTP id e16so658251uam.12
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 04:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SKiTehzyUlwJV0b2BKwZAroAqyP7BP93rdA3qUyv8K0=;
        b=wtE7yITG9nC0MKUTE1uCkJhlgvNuDODsGQc+7d0xdAjyicQ7J1inMNAW5JNctY5BT2
         g1cQuchqogEy/xNENLUgv+qmkeVWW4i9eLSozBElRfRI+sRb7IFvgo/pbc0xrWnXrvDS
         7xTN1Kh+spAMsU3/cVtvSIJo2/zJI1LE1mU1nmJfo7Z4LJ7sqsOrFkTufo4I6TVjq1mO
         ifH620Cic3pmPQhuAoW9/HjmYHUAlY/m21Bd2TtoVXaqt8oTEct8USVnaMK6YJR5ulsJ
         fzoY5yNfmZxa/P9i9OwCx3eTbOZlfXMP+vmgXB3+ZmUb8PPJ5E3ExdbVoEjWFQuUA8TS
         K8tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SKiTehzyUlwJV0b2BKwZAroAqyP7BP93rdA3qUyv8K0=;
        b=eLlCjqVh//tUy/YO+oP74kOi4CIa9oGX4rCZ3x5Bu/JtRQFR16tOE7mHkuhBxmlA75
         1mBRmfXcr3MnaumhYkc43xYHxU9TSp1jfgm+rHBVHNQi0pBwxDMa8D7GJMV7ZHjsyhOf
         Aa4Zvsis1/PoReIfO3tRj/iC//gzxEbCM2rjtUzKZtbniWa83fXPllEylLYFw7rQ3DG6
         TT5P+lCz1E0QFKn3X5GPJSLgQ81iXHEmwpBUeY2ePYpE0W3B2CoGGBWhrn0fVumf//T5
         SlrqNcObF9goTVlu2QQ1wK1XWlE3D/8n/epsiNsHGwSMo1ycisdsH1BfoAVtnatVIy0D
         z5uQ==
X-Gm-Message-State: AJcUukdeK3D88FtC31VWPzb4IYn4f6GNnKDMG2/P1SirqqYR6V9Swoj6
        sCpdOQbEygZJEhFzIgwl1LK9W8sfG2HWM6plBodtdA==
X-Google-Smtp-Source: ALg8bN5jfIsuJQn2h0/RVZ74q4dkjnHMPoPDoWPYVjMjlUrX0/gq/YvtfhKNyVOTstk+vGaGudq5vj/UJJiivf7P0IU=
X-Received: by 2002:ab0:7493:: with SMTP id n19mr786352uap.115.1548248314009;
 Wed, 23 Jan 2019 04:58:34 -0800 (PST)
MIME-Version: 1.0
References: <20190122151422.14204-1-gregkh@linuxfoundation.org> <20190122151422.14204-3-gregkh@linuxfoundation.org>
In-Reply-To: <20190122151422.14204-3-gregkh@linuxfoundation.org>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 23 Jan 2019 14:58:22 +0200
Message-ID: <CAOtvUMc92ghc4LjHYJ7z9r11Om82rw=mNdAqA1GYJMxmuUqCLw@mail.gmail.com>
Subject: Re: [PATCH 2/7] crypto: ccrree: no need to check return value of
 debugfs_create functions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Yael Chemla <yael.chemla@foss.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Tue, Jan 22, 2019 at 5:14 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.



I get the part about not failing loading the driver just because some
debugs entry isn't available,  but wont it be weird if
debugfs_create_dir() fails but  debugfs_create_regset32() succeeds and
we suddenly have weird files in the debugfs root dir?
Not the end of the world of course but maybe it's better to avoid
trying to create the files if the directory is not available?

Thanks,
Gilad

>
> Cc: Yael Chemla <yael.chemla@foss.arm.com>
> Cc: Gilad Ben-Yossef <gilad@benyossef.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/crypto/ccree/cc_debugfs.c | 22 +++-------------------
>  drivers/crypto/ccree/cc_debugfs.h |  8 ++------
>  drivers/crypto/ccree/cc_driver.c  |  7 +------
>  3 files changed, 6 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_=
debugfs.c
> index 5ca184e42483..5fa05a7bcf36 100644
> --- a/drivers/crypto/ccree/cc_debugfs.c
> +++ b/drivers/crypto/ccree/cc_debugfs.c
> @@ -39,11 +39,9 @@ static struct debugfs_reg32 debug_regs[] =3D {
>         CC_DEBUG_REG(AXIM_MON_COMP),
>  };
>
> -int __init cc_debugfs_global_init(void)
> +void __init cc_debugfs_global_init(void)
>  {
>         cc_debugfs_dir =3D debugfs_create_dir("ccree", NULL);
> -
> -       return !cc_debugfs_dir;
>  }
>
>  void __exit cc_debugfs_global_fini(void)
> @@ -56,7 +54,6 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
>         struct device *dev =3D drvdata_to_dev(drvdata);
>         struct cc_debugfs_ctx *ctx;
>         struct debugfs_regset32 *regset;
> -       struct dentry *file;
>
>         debug_regs[0].offset =3D drvdata->sig_offset;
>         debug_regs[1].offset =3D drvdata->ver_offset;
> @@ -74,22 +71,9 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
>         regset->base =3D drvdata->cc_base;
>
>         ctx->dir =3D debugfs_create_dir(drvdata->plat_dev->name, cc_debug=
fs_dir);
> -       if (!ctx->dir)
> -               return -ENFILE;
> -
> -       file =3D debugfs_create_regset32("regs", 0400, ctx->dir, regset);
> -       if (!file) {
> -               debugfs_remove(ctx->dir);
> -               return -ENFILE;
> -       }
>
> -       file =3D debugfs_create_bool("coherent", 0400, ctx->dir,
> -                                  &drvdata->coherent);
> -
> -       if (!file) {
> -               debugfs_remove_recursive(ctx->dir);
> -               return -ENFILE;
> -       }
> +       debugfs_create_regset32("regs", 0400, ctx->dir, regset);
> +       debugfs_create_bool("coherent", 0400, ctx->dir, &drvdata->coheren=
t);
>
>         drvdata->debugfs =3D ctx;
>
> diff --git a/drivers/crypto/ccree/cc_debugfs.h b/drivers/crypto/ccree/cc_=
debugfs.h
> index 5b5320eca7d2..01cbd9a95659 100644
> --- a/drivers/crypto/ccree/cc_debugfs.h
> +++ b/drivers/crypto/ccree/cc_debugfs.h
> @@ -5,7 +5,7 @@
>  #define __CC_DEBUGFS_H__
>
>  #ifdef CONFIG_DEBUG_FS
> -int cc_debugfs_global_init(void);
> +void cc_debugfs_global_init(void);
>  void cc_debugfs_global_fini(void);
>
>  int cc_debugfs_init(struct cc_drvdata *drvdata);
> @@ -13,11 +13,7 @@ void cc_debugfs_fini(struct cc_drvdata *drvdata);
>
>  #else
>
> -static inline int cc_debugfs_global_init(void)
> -{
> -       return 0;
> -}
> -
> +static inline void cc_debugfs_global_init(void) {}
>  static inline void cc_debugfs_global_fini(void) {}
>
>  static inline int cc_debugfs_init(struct cc_drvdata *drvdata)
> diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_d=
river.c
> index 8ada308d72ee..662738e53ced 100644
> --- a/drivers/crypto/ccree/cc_driver.c
> +++ b/drivers/crypto/ccree/cc_driver.c
> @@ -538,13 +538,8 @@ static struct platform_driver ccree_driver =3D {
>
>  static int __init ccree_init(void)
>  {
> -       int ret;
> -
>         cc_hash_global_init();
> -
> -       ret =3D cc_debugfs_global_init();
> -       if (ret)
> -               return ret;
> +       cc_debugfs_global_init();
>
>         return platform_driver_register(&ccree_driver);
>  }
> --
> 2.20.1
>


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
