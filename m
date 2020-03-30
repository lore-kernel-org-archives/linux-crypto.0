Return-Path: <SRS0=TSvm=5P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B328DC2D0E9
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Mar 2020 09:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93A68206CC
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Mar 2020 09:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbgC3JEK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Mar 2020 05:04:10 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:60073 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729834AbgC3JEJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Mar 2020 05:04:09 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N7hrw-1jEs7m0zOk-014hGU; Mon, 30 Mar 2020 11:04:08 +0200
Received: by mail-qt1-f174.google.com with SMTP id i3so14383748qtv.8;
        Mon, 30 Mar 2020 02:04:07 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1ZfmrLeo7mXOS6ML5HdbVESq9t83mmZf8dPWTGzNuZZtoCaCGP
        lmLv+ll/zvF10LN3f9SVmla5sz8mJ4c2D1c/na8=
X-Google-Smtp-Source: ADFU+vvF6z0qsmRemaK4uJsmFwsYBMd2e+M1G6Z9k97e3bDi+XT2BPv6JkE4QiR9NycOEetI9qUmn3RN/5VoUaWoUEk=
X-Received: by 2002:aed:3b4c:: with SMTP id q12mr10572345qte.18.1585559047035;
 Mon, 30 Mar 2020 02:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200330083643.28824-1-yuehaibing@huawei.com>
In-Reply-To: <20200330083643.28824-1-yuehaibing@huawei.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 30 Mar 2020 11:03:51 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2DTx7Pjj8DLkwrnHxvB8YQC=999_EaefbT0X09Lktdjg@mail.gmail.com>
Message-ID: <CAK8P3a2DTx7Pjj8DLkwrnHxvB8YQC=999_EaefbT0X09Lktdjg@mail.gmail.com>
Subject: Re: [PATCH -next] crypto: hisilicon - Fix build error
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Hongbo Yao <yaohongbo@huawei.com>,
        Mao Wenan <maowenan@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:StBv4DeS8j4pJVubvPn/STK8Ixjh7AI0ftdSsdb1Q2QanMGYjo1
 tpdqiSWpqG5OIrqogupHCc6RaMSlwNuLP4AmOggmR5E0vdccySNhKFdDs4d6/qYtuFlU3hq
 E/4KaHTSFcnnY2kEaHrYGZQZ1D8mQwI9q8WUofGoste8O6/6Zxk9gXV3uQkkgtzeMX2M/Rc
 foQL/E8pDBX7mcp05q6bw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tWytsc1cTjY=:CLVlteC1nwWlR7iRKOjmMP
 52eT4/u//aH3djSujPacNBq/dtLltAp5bGCSOi/e0+lsGADeMxl0McHy2qPUePyfPhPkBJqBx
 CMQ1/5lIbL/h42gkwiCJDrkox59jSApDJ0TW5Euw4O2Z9YvBAds9q7cXTyl4izW4Qa6AMSM1H
 w3EjbBhULFNG6N51e59JH1yUtMKy8v6iWK3gSlTqLmYMs/RTCwrk2L3/sFlK1lHaoeH1mCQLS
 3omnSlOqkPB2nivUzg1/w0f8RRlPpHeZ1Rx2z8WKT8vETv5EXv6eLAIBNovLqhhBi0brvF2tJ
 ho9N2MSBD7jy+qkj8IsqzZXgr8S8X3Ot8m5FXvS0h2PKydf53NCRsIPfkpBP7l/SKVYDnnn0U
 Ito4vP3JrP/vnkQ0bRZzy1PD80oiqxbg4Rtc+g2//uIdjn6YSHhFHdDeJt8khgQkl7juOepzG
 QcQIPQmcjezrAHcQB5PAmEzc4m0gnic5UnR3S7sEJbvLr68HJeZcn1CWcTZAm2PnuQyDWPmwn
 3NTYttIk5ZcNK0BF1niql4umynRq6hYJAcuQbyEq+IwVJIbcGpXRZy/GDTg6IPYJwlMyq0DIi
 sPjWFz7UabKgESKqrlG8LO91fJLkTuRvgNjkklc24er/gIDeSA+DcunJdK8orr7UTkVA5qt4W
 WWUVFtooNamp6Yp4TEPgGCpalNqj6YQTN8uV23VuBzKGcn2YZEzZKom790n3SoGj6Ap3GQusX
 ZBVCzxyLAb/w9py0XCYe4bLN0Uuu8UKZQWb35AuNzVDWOqvSb1cOET+DfujLkk7kGqYY+dHqd
 dIlMCfzN0GoY1xOF/dKazbNpoKiK/W2GzTKArtvuuwPoZxIxfU=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 30, 2020 at 10:39 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> When UACCE is m, CRYPTO_DEV_HISI_QM cannot be built-in.
> But CRYPTO_DEV_HISI_QM is selected by CRYPTO_DEV_HISI_SEC2
> and CRYPTO_DEV_HISI_HPRE unconditionally, which may leads this:
>
> drivers/crypto/hisilicon/qm.o: In function 'qm_alloc_uacce':
> drivers/crypto/hisilicon/qm.c:1579: undefined reference to 'uacce_alloc'
>
> Add Kconfig dependency to enforce usable configurations.
>
> Fixes: 47c16b449921 ("crypto: hisilicon - qm depends on UACCE")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Looks correct to me (based on having fixed many similar issues is other
places, not because of specific knowledge on this driver).

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

> ---
>  drivers/crypto/hisilicon/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index 095850d01dcc..f09c6cf7823e 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -27,6 +27,7 @@ config CRYPTO_DEV_HISI_SEC2
>         select CRYPTO_SHA256
>         select CRYPTO_SHA512
>         depends on PCI && PCI_MSI
> +       depends on UACCE || UACCE=n
>         depends on ARM64 || (COMPILE_TEST && 64BIT)
>         help
>           Support for HiSilicon SEC Engine of version 2 in crypto subsystem.
> @@ -58,6 +59,7 @@ config CRYPTO_DEV_HISI_ZIP
>  config CRYPTO_DEV_HISI_HPRE
>         tristate "Support for HISI HPRE accelerator"
>         depends on PCI && PCI_MSI
> +       depends on UACCE || UACCE=n
>         depends on ARM64 || (COMPILE_TEST && 64BIT)
>         select CRYPTO_DEV_HISI_QM
>         select CRYPTO_DH
> --
> 2.17.1
>
>
