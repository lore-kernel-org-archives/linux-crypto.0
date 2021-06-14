Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC13C48BDF
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 02:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC6F06138C
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 02:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhFNCMo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 22:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhFNCMo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 22:12:44 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D844C061574
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 19:10:28 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ei4so8840122pjb.3
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 19:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=15ldIVvj9LmAylouxv5UZkBwzfCuJp9jdtHMZjMbuQ4=;
        b=lWEnkvFkT7h8ltz++Z5Vcv9KlO3p+XHgfH0k1KYg566bUombxMGcBHSkEtUKsdjG/Q
         xYiFV1mpuceRMbQMlbB8z4DGoigx3oM5yr/xBHJIOMCaHwRsCl0KDx5GIRZDuXGuBWg4
         WF1Qiic1ytfsgvBRKUVc9xPogmT5HbmsdcgGszh/g8g+1MePj9tjFnEuOnkfB3swaYNw
         QN2I02XIzvoh7SHMtrAwKEyYGQsMifASX14yJZliqxqQ811GQuTFD8u37Hk4vO2Ig3oa
         g3/0k0PapCueGCoTjDXxrC7t6n5mO0zpDUqK6sYfyrF+N7XncQ1wb/bHd/o/EGzZFTp5
         FvBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=15ldIVvj9LmAylouxv5UZkBwzfCuJp9jdtHMZjMbuQ4=;
        b=dxMhl6loOKLp9hYczFCe1OK8f3R9AE4T6IpVm4UF4uMeGUuA6xs8bEyRLZU6w3tqPV
         ZcqgjjNFg6xgBWSelIe7a/7vkKIVjEDRTKgwAv22xqIShl518TxBGo3ruWQa5hOatrXP
         YasE1w+ygzdPq3BRTrLiU1Vk0evyMZ1flGL+LbexlsdioWPEoAtnOcfU6AF8e1BOlG9v
         m8v96peKwmQRmDTCsDB+mHBYLiTYCcE+dypa/tMjZ4+MZG91iLMnFKRTSjjRDnXptoqt
         HS3LxzFk6Ys+EascvtmKro8+OQ90bQ784Yyx+/Cd3jWvNHxzZyB6WdEBDq8T3ND5MgH4
         WUBQ==
X-Gm-Message-State: AOAM530RH9IHvQtEHoDf8E1LEb+uDMYEMZBCGuQaXbQVKneipoA7vrh1
        4jNX49duidsHn70VnIiRWWw=
X-Google-Smtp-Source: ABdhPJxDBSGLejuCsDzpGxCMDvHS3ueZX1Kz/58AdAGu6FS2OOHOKGONsPiVaf3hfMfYdpqF6dlV8Q==
X-Received: by 2002:a17:90a:af95:: with SMTP id w21mr21203276pjq.72.1623636628192;
        Sun, 13 Jun 2021 19:10:28 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id x20sm10828598pfh.112.2021.06.13.19.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 19:10:27 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:10:22 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 02/17] powerpc/vas: Move VAS API to book3s common
 platform
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
        <ab39540c383d93a0a4dec847fe21586450decf5f.camel@linux.ibm.com>
In-Reply-To: <ab39540c383d93a0a4dec847fe21586450decf5f.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623636258.dm4veqnlj5.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 13, 2021 8:55 pm:
>=20
> Using the same /dev/crypto/nx-gzip interface for both powerNV and
> pseries. So this patch creates platforms/book3s/ and moves VAS API
> to that directory. The actual functionality is not changed.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>

Just a minor nit with the wording of the changelog.

The pseries platform will share vas and nx code and interfaces with the=20
powernv platform, so create the arch/powerpc/platforms/book3s/ directory=20
and move VAS API code there. Functionality is not changed.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  arch/powerpc/platforms/Kconfig                    |  1 +
>  arch/powerpc/platforms/Makefile                   |  1 +
>  arch/powerpc/platforms/book3s/Kconfig             | 15 +++++++++++++++
>  arch/powerpc/platforms/book3s/Makefile            |  2 ++
>  .../platforms/{powernv =3D> book3s}/vas-api.c       |  2 +-
>  arch/powerpc/platforms/powernv/Kconfig            | 14 --------------
>  arch/powerpc/platforms/powernv/Makefile           |  2 +-
>  7 files changed, 21 insertions(+), 16 deletions(-)
>  create mode 100644 arch/powerpc/platforms/book3s/Kconfig
>  create mode 100644 arch/powerpc/platforms/book3s/Makefile
>  rename arch/powerpc/platforms/{powernv =3D> book3s}/vas-api.c (99%)
>=20
> diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kcon=
fig
> index 7a5e8f4541e3..594544a65b02 100644
> --- a/arch/powerpc/platforms/Kconfig
> +++ b/arch/powerpc/platforms/Kconfig
> @@ -20,6 +20,7 @@ source "arch/powerpc/platforms/embedded6xx/Kconfig"
>  source "arch/powerpc/platforms/44x/Kconfig"
>  source "arch/powerpc/platforms/40x/Kconfig"
>  source "arch/powerpc/platforms/amigaone/Kconfig"
> +source "arch/powerpc/platforms/book3s/Kconfig"
> =20
>  config KVM_GUEST
>  	bool "KVM Guest support"
> diff --git a/arch/powerpc/platforms/Makefile b/arch/powerpc/platforms/Mak=
efile
> index 143d4417f6cc..0e75d7df387b 100644
> --- a/arch/powerpc/platforms/Makefile
> +++ b/arch/powerpc/platforms/Makefile
> @@ -22,3 +22,4 @@ obj-$(CONFIG_PPC_CELL)		+=3D cell/
>  obj-$(CONFIG_PPC_PS3)		+=3D ps3/
>  obj-$(CONFIG_EMBEDDED6xx)	+=3D embedded6xx/
>  obj-$(CONFIG_AMIGAONE)		+=3D amigaone/
> +obj-$(CONFIG_PPC_BOOK3S)	+=3D book3s/
> diff --git a/arch/powerpc/platforms/book3s/Kconfig b/arch/powerpc/platfor=
ms/book3s/Kconfig
> new file mode 100644
> index 000000000000..34c931592ef0
> --- /dev/null
> +++ b/arch/powerpc/platforms/book3s/Kconfig
> @@ -0,0 +1,15 @@
> +# SPDX-License-Identifier: GPL-2.0
> +config PPC_VAS
> +	bool "IBM Virtual Accelerator Switchboard (VAS)"
> +	depends on (PPC_POWERNV || PPC_PSERIES) && PPC_64K_PAGES
> +	default y
> +	help
> +	  This enables support for IBM Virtual Accelerator Switchboard (VAS).
> +
> +	  VAS devices are found in POWER9-based and later systems, they
> +	  provide access to accelerator coprocessors such as NX-GZIP and
> +	  NX-842. This config allows the kernel to use NX-842 accelerators,
> +	  and user-mode APIs for the NX-GZIP accelerator on POWER9 PowerNV
> +	  and POWER10 PowerVM platforms.
> +
> +	  If unsure, say "N".
> diff --git a/arch/powerpc/platforms/book3s/Makefile b/arch/powerpc/platfo=
rms/book3s/Makefile
> new file mode 100644
> index 000000000000..e790f1910f61
> --- /dev/null
> +++ b/arch/powerpc/platforms/book3s/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_PPC_VAS)	+=3D vas-api.o
> diff --git a/arch/powerpc/platforms/powernv/vas-api.c b/arch/powerpc/plat=
forms/book3s/vas-api.c
> similarity index 99%
> rename from arch/powerpc/platforms/powernv/vas-api.c
> rename to arch/powerpc/platforms/book3s/vas-api.c
> index 98ed5d8c5441..cfc9d7dd65ab 100644
> --- a/arch/powerpc/platforms/powernv/vas-api.c
> +++ b/arch/powerpc/platforms/book3s/vas-api.c
> @@ -10,9 +10,9 @@
>  #include <linux/fs.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <linux/io.h>
>  #include <asm/vas.h>
>  #include <uapi/asm/vas-api.h>
> -#include "vas.h"
> =20
>  /*
>   * The driver creates the device node that can be used as follows:
> diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platfo=
rms/powernv/Kconfig
> index 619b093a0657..043eefbbdd28 100644
> --- a/arch/powerpc/platforms/powernv/Kconfig
> +++ b/arch/powerpc/platforms/powernv/Kconfig
> @@ -33,20 +33,6 @@ config PPC_MEMTRACE
>  	  Enabling this option allows for runtime allocation of memory (RAM)
>  	  for hardware tracing.
> =20
> -config PPC_VAS
> -	bool "IBM Virtual Accelerator Switchboard (VAS)"
> -	depends on PPC_POWERNV && PPC_64K_PAGES
> -	default y
> -	help
> -	  This enables support for IBM Virtual Accelerator Switchboard (VAS).
> -
> -	  VAS allows accelerators in co-processors like NX-GZIP and NX-842
> -	  to be accessible to kernel subsystems and user processes.
> -
> -	  VAS adapters are found in POWER9 based systems.
> -
> -	  If unsure, say N.
> -
>  config SCOM_DEBUGFS
>  	bool "Expose SCOM controllers via debugfs"
>  	depends on DEBUG_FS
> diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platf=
orms/powernv/Makefile
> index be2546b96816..dc7b37c23b60 100644
> --- a/arch/powerpc/platforms/powernv/Makefile
> +++ b/arch/powerpc/platforms/powernv/Makefile
> @@ -18,7 +18,7 @@ obj-$(CONFIG_MEMORY_FAILURE)	+=3D opal-memory-errors.o
>  obj-$(CONFIG_OPAL_PRD)	+=3D opal-prd.o
>  obj-$(CONFIG_PERF_EVENTS) +=3D opal-imc.o
>  obj-$(CONFIG_PPC_MEMTRACE)	+=3D memtrace.o
> -obj-$(CONFIG_PPC_VAS)	+=3D vas.o vas-window.o vas-debug.o vas-fault.o va=
s-api.o
> +obj-$(CONFIG_PPC_VAS)	+=3D vas.o vas-window.o vas-debug.o vas-fault.o
>  obj-$(CONFIG_OCXL_BASE)	+=3D ocxl.o
>  obj-$(CONFIG_SCOM_DEBUGFS) +=3D opal-xscom.o
>  obj-$(CONFIG_PPC_SECURE_BOOT) +=3D opal-secvar.o
> --=20
> 2.18.2
>=20
>=20
>=20
