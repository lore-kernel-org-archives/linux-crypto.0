Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D20FC48BE6
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 03:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EE78613AB
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 03:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhFNDhk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 23:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbhFNDhk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 23:37:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468EAC061574
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 20:35:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id v11so5819101ply.6
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 20:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=QMp92nPw8lMVr4SttM8MWMUzPqMupFY25Uo/dcGnhGQ=;
        b=EJrqYkdwKe8w232aXFL2CV4rtRe0zY7ViWLyXPID+vfNanLCcQG1Obw2/YiQCUD4bH
         u+J/8h1/al/+5AhS2XJL77c9q1M2E4z8JL9RBqDLK4SC42pOt14fZ08f7sxfgG2NPLsf
         p1jaCiU6cmaRDOnZWZQ2eXZ89DhJ2TA4xrRtMHcLxXfpj1E9VRJLqTkJ2355dDBUL/bQ
         HWvVIa2V13apLAhSNA6sQXROfzyFotXbzWQKrjqHW+9V6EMQ4032DgvLIrM1KpueV+Q1
         zbPk8aUOElcp9aCrAUjDGbHqcqowk8p85HWYruWENHywMmERhTxsc73M9XjalBXvxWsj
         vUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=QMp92nPw8lMVr4SttM8MWMUzPqMupFY25Uo/dcGnhGQ=;
        b=G2KokSb1RoX613kHFarv2922dVayBF60vZNW0DGHd+ABCZgyKOZ3HYaSOhSdOotRWw
         iYZlQjfg4Gag2nJX1DJNY7eDkGkzlV0OT8iEWgCPqIXD0nrCcUY7cSiNdRcQajlIGSAp
         3iRICZdtMX8FjTHCZ1W4UaYFuxeDIXGJgP2Q1gCiRrIKC6RX4D5O4mnVvT4n2pqcPXL6
         jqf/FfesT7wKcIcvwS5RlI2yRlNKKu4ReTtgJRD7SwHCX/1vFTpxxYITXbgo5WDqcKT/
         ppKcm/Ji+GDZ2mMxToOJ8stZIQW6oTAf9zogO7V3P1IChiyRkb1SsK+0jtGd2FFNf5qD
         7lQw==
X-Gm-Message-State: AOAM531wFS+/DmhxYLENZJtPAQLN2ywL6iadeLauvy39HbXe1gNRbCj1
        Pw+MvKSAqtu06CARuZrBZfw=
X-Google-Smtp-Source: ABdhPJy22twUgEp75uqvLFNGSbEOyoATWgRcn52SBgta4UzC15mv5TABWQUPueYiQ3eP2oWZDsJ4Vw==
X-Received: by 2002:a17:90b:380a:: with SMTP id mq10mr11513569pjb.79.1623641737850;
        Sun, 13 Jun 2021 20:35:37 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id v67sm11001826pfb.193.2021.06.13.20.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 20:35:37 -0700 (PDT)
Date:   Mon, 14 Jun 2021 13:35:32 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 15/17] crypto/nx: Register and unregister VAS interface
 on PowerVM
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
        <0fe93c925b9e5517f55121f51074de425feb5236.camel@linux.ibm.com>
In-Reply-To: <0fe93c925b9e5517f55121f51074de425feb5236.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623641719.fj26uclcqk.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 13, 2021 9:04 pm:
>=20
> The user space uses /dev/crypto/nx-gzip interface to setup VAS
> windows, create paste mapping and close windows. This patch adds
> changes to create/remove this interface with VAS register/unregister
> functions on PowerVM platform.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Nicholas Piggin <npiggin@gmail.com>

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
