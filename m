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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B593EC47092
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 03:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD64613D7
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 03:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFCDis (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:38:48 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:37574 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFCDir (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Jun 2021 23:38:47 -0400
Received: by mail-pg1-f174.google.com with SMTP id t9so4073312pgn.4
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jun 2021 20:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=eplu6+3m32y+oXsd08ipLefS4knOWz1lB/tEGu9xnXg=;
        b=A8NzwCPes2ko8XVaZXKVTFU8+T7c/u/3rlfEn/sD4nSNtsCu6unVovWoFmML+FSwYz
         6TMGgQ1RQ1dtdfTtIWswEKhtThNEzXdbOYPKEnHKjp8yOY5DxNgaXnqT/uN41UA2b2Jo
         +d1LQWw2q4akOwAitsYTisUkXvYXCjFPXzVTNqx1nanZLcCmQVFdrIHXeoocb31HF6+e
         rQlf0RGOp8d9LLK3J+J/4TjmBL45O8f5dYEYf3iAJHTi9nDIfSG6ByLAsaIM+SJcf4ui
         jxY2M3WzxJGpk99N2XnUQVQpqh0BkGuYKshGYkKs3bvpZ2BEar/kZpjVd+hsOEY7kyrK
         8ObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=eplu6+3m32y+oXsd08ipLefS4knOWz1lB/tEGu9xnXg=;
        b=HBaXK2lfnwbywz1RFKV2Vq4UCsPOVr9agzSibDHocCYz86Zt50C3vqG4V+TUWjdR+w
         ZFS+4hU8498STrHETKJ1XoHbDQbA4/S/wFOGZpZx9y30qGePkvUqm2PK7RU67vhWSBBc
         sotgYZyLgGwnA9ETQet46lz+eNIFWE0fsLzh42FsT6xvhH0sGBJGXliApdrwvP+kKw6e
         qpP+iDvOj7knxw2/l+XhIEM8bYW+mPwfF7K/VfsdzyKGfwPLFLl/MHrId4WTQdQj4FPa
         kr4jiqyzOJQ9mIBN2EnLgRncTvcrm6FCMEtaQHizbZqkcC+i8ZTl4ERA/7EIGoNNdyvH
         tYBw==
X-Gm-Message-State: AOAM532Ev6rgjs0FQSIHvdsont8qjTeSHtnt1z79FkjHyJkBZLsfggIg
        l/1d7CgHqq6o47WJZKoLMFxOOpjZMbShMQ==
X-Google-Smtp-Source: ABdhPJzSopDFk0JXM92OlbC93P2eLzxvHHS2RGiJJqlJ6Yn4iV6HXIQomOJOeK86HpxTHlBs1zfETg==
X-Received: by 2002:aa7:96fc:0:b029:2e9:e827:928f with SMTP id i28-20020aa796fc0000b02902e9e827928fmr14845169pfq.49.1622691142239;
        Wed, 02 Jun 2021 20:32:22 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id c21sm820675pfi.44.2021.06.02.20.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 20:32:21 -0700 (PDT)
Date:   Thu, 03 Jun 2021 13:32:16 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 01/16] powerpc/vas: Move VAS API to book3s common
 platform
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     hbabu@us.ibm.com
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
        <5933dd793bf0d0d1389877715d936cc321ee86d1.camel@linux.ibm.com>
In-Reply-To: <5933dd793bf0d0d1389877715d936cc321ee86d1.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1622690127.w2gelsayfa.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of May 21, 2021 7:28 pm:
>=20
> Using the same /dev/crypto/nx-gzip interface for both powerNV and
> pseries. So this patch creates platforms/book3s/ and moves VAS API
> to that directory. The actual functionality is not changed.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/vas.h                    |  3 +++
>  arch/powerpc/platforms/Kconfig                    |  1 +
>  arch/powerpc/platforms/Makefile                   |  1 +
>  arch/powerpc/platforms/book3s/Kconfig             | 15 +++++++++++++++
>  arch/powerpc/platforms/book3s/Makefile            |  2 ++

If Michael is happy with the new directory structure then fine by me.

>  .../platforms/{powernv =3D> book3s}/vas-api.c       |  2 +-
>  arch/powerpc/platforms/powernv/Kconfig            | 14 --------------
>  arch/powerpc/platforms/powernv/Makefile           |  2 +-
>  8 files changed, 24 insertions(+), 16 deletions(-)
>  create mode 100644 arch/powerpc/platforms/book3s/Kconfig
>  create mode 100644 arch/powerpc/platforms/book3s/Makefile
>  rename arch/powerpc/platforms/{powernv =3D> book3s}/vas-api.c (99%)
>=20
> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/va=
s.h
> index e33f80b0ea81..3be76e813e2d 100644
> --- a/arch/powerpc/include/asm/vas.h
> +++ b/arch/powerpc/include/asm/vas.h
> @@ -162,6 +162,9 @@ int vas_copy_crb(void *crb, int offset);
>   */
>  int vas_paste_crb(struct vas_window *win, int offset, bool re);
> =20
> +void vas_win_paste_addr(struct vas_window *window, u64 *addr,
> +			int *len);
> +
>  /*
>   * Register / unregister coprocessor type to VAS API which will be expor=
ted
>   * to user space. Applications can use this API to open / close window

If you do this, then the prototype should be removed from=20
arch/powerpc/platforms/powernv/vas.h

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
> index 000000000000..bed21449e8e5
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
> +	  VAS allows accelerators in co-processors like NX-GZIP and NX-842
> +	  to be accessible to kernel subsystems and user processes.
> +	  VAS adapters are found in POWER9 and later based systems.
> +	  The user mode NX-GZIP support is added on P9 for powerNV and on
> +	  P10 for powerVM.

The changelog has changed. The last sentence is difficult to understand=20
(also please consistently capitalise PowerNV and PowerVM). Is it=20
supposed to say that PPC_VAS will provide user-mode NX-GZIP support on=20
P9 PowerNV systems and P10 PowerVM systems? If you respin the patch for
the prototype...

  This enables support for IBM Virtual Accelerator Switchboard (VAS).

  VAS devices are found in POWER9-based and later systems, they provide
  access to accelerator coprocessors such as NX-GZIP and NX-842. This
  driver allows the kernel to use NX-GZIP and NX-842 accelerators, and
  user-mode APIs for the NX-GZIP accelerator on POWER9 PowerNV and
  POWER10 PowerVM platforms. <here is a userspace library you can use>
  etc

Thanks,
Nick
