Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 601C6C47096
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 05:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3580C613EE
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 05:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhFCFC2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:02:28 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:41881 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhFCFC2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 01:02:28 -0400
Received: by mail-pf1-f171.google.com with SMTP id x73so3978485pfc.8
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jun 2021 22:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=wP8kwWHvWPOSW3Kxg0y5i10MeeFhZ5W8gU40UHd6LVk=;
        b=QpYPrtZi34g2iPYCmRMlWxtW9XBnrY+oeGgWWi9RDUIirPnvEWtjlNh3l0UtluNu1t
         IxsfJ03eN2U9wMAMGuc15m9s/NJxsXrIdHijIEjLpO4NtT45PNM/dfgoBq65WzW6oBHg
         EApYdyV+Qw5G6qLvrB4QIevFNzTqWSdQZ0v8bGC3bG3U4Yiqdk05izROlnLlC11EFova
         yy40mAGUb2JUyeG5YXDY9iDaH8EnaPNfu2W4H/Dpwzug1wLjwQH+0UT5NH3Y3Os/LnYM
         D3VP6diqnkr6Fn9kQRV+POUTwOYgU+72PR2dmYzzkl+Ph10QE3FkLiIoR+q+8MV1rXaD
         DuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=wP8kwWHvWPOSW3Kxg0y5i10MeeFhZ5W8gU40UHd6LVk=;
        b=rlP+hzFqEsSjbtkg2KOh8Wi5EGFKwTrzxKFR1c9fVOtbcPc8vAlyb0+Myad4012Hef
         v9dEjB/e12yMvlbtsAt5NHBJrS5cqLgOdWWmR0YmJ/F3X0IZh9P7yioTyraiUTQ0Lqo8
         yD27+q2VH+U22yqtSyMGxcG3YYoAvOBNeu32Oqv2yzE42u5DO4Q3Z4OO45Vyjg3nM3lt
         Ie/NwCm2i6RnTyIQ/0niCF/PEvn4BSmQSza/mrlHO61nqLFcXNWfvMSZ0XGnHb0VqpPf
         GQEusLUlYFb0K4D4q9xiRdDMjbWKajevWjUpyvB0vbFHgKgZEGOPjkLSbZcVdvNAEiZU
         1mqg==
X-Gm-Message-State: AOAM533HidIyfD9nvUb+Pk3QV0AQ+athxxrcl3dDypOHDpD52LqSp/FN
        UpVZWu8af2aBH6Zcifya+AF0oqDP/aA=
X-Google-Smtp-Source: ABdhPJy+ldXCfckWAtAmrnYX3/p5DGgrvukhHO4fWZvH8wTPxP3vHI6u1y15Zp0e1S2Aua1EGX9qOA==
X-Received: by 2002:a62:51c2:0:b029:2e9:e4c5:2a74 with SMTP id f185-20020a6251c20000b02902e9e4c52a74mr15858037pfb.51.1622696369006;
        Wed, 02 Jun 2021 21:59:29 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id q91sm910669pja.50.2021.06.02.21.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:59:28 -0700 (PDT)
Date:   Thu, 03 Jun 2021 14:59:23 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 14/16] crypto/nx: Register and unregister VAS interface
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
        <af17f1cd30b9bbece7e160d78fb83fe5e0e823f5.camel@linux.ibm.com>
In-Reply-To: <af17f1cd30b9bbece7e160d78fb83fe5e0e823f5.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1622696256.om3tqko8hq.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of May 21, 2021 7:41 pm:
>=20
> Changes to create /dev/crypto/nx-gzip interface with VAS register
> and to remove this interface with VAS unregister.
>=20

Could you include why the change is done, or what goes wrong without it?

Thanks,
Nick

> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/nx/Kconfig             | 1 +
>  drivers/crypto/nx/nx-common-pseries.c | 9 +++++++++
>  2 files changed, 10 insertions(+)
>=20
> diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
> index 23e3d0160e67..2a35e0e785bd 100644
> --- a/drivers/crypto/nx/Kconfig
> +++ b/drivers/crypto/nx/Kconfig
> @@ -29,6 +29,7 @@ if CRYPTO_DEV_NX_COMPRESS
>  config CRYPTO_DEV_NX_COMPRESS_PSERIES
>  	tristate "Compression acceleration support on pSeries platform"
>  	depends on PPC_PSERIES && IBMVIO
> +	depends on PPC_VAS
>  	default y
>  	help
>  	  Support for PowerPC Nest (NX) compression acceleration. This
> diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx=
-common-pseries.c
> index cc8dd3072b8b..9a40fca8a9e6 100644
> --- a/drivers/crypto/nx/nx-common-pseries.c
> +++ b/drivers/crypto/nx/nx-common-pseries.c
> @@ -9,6 +9,7 @@
>   */
> =20
>  #include <asm/vio.h>
> +#include <asm/vas.h>
> =20
>  #include "nx-842.h"
>  #include "nx_csbcpb.h" /* struct nx_csbcpb */
> @@ -1101,6 +1102,12 @@ static int __init nx842_pseries_init(void)
>  		return ret;
>  	}
> =20
> +	ret =3D vas_register_api_pseries(THIS_MODULE, VAS_COP_TYPE_GZIP,
> +				       "nx-gzip");
> +
> +	if (ret)
> +		pr_err("NX-GZIP is not supported. Returned=3D%d\n", ret);
> +
>  	return 0;
>  }
> =20
> @@ -1111,6 +1118,8 @@ static void __exit nx842_pseries_exit(void)
>  	struct nx842_devdata *old_devdata;
>  	unsigned long flags;
> =20
> +	vas_unregister_api_pseries();
> +
>  	crypto_unregister_alg(&nx842_pseries_alg);
> =20
>  	spin_lock_irqsave(&devdata_mutex, flags);
> --=20
> 2.18.2
>=20
>=20
>=20
