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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514DCC433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03C4161421
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhEJGUA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 02:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhEJGT7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 02:19:59 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC35CC061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 23:18:55 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id p12so12528111pgj.10
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 23:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=iMj5Um8f+G5xPbwOX4gj2TuSJu85tSxJ1UAz8uEezeM=;
        b=gG+2CR8A4ijBIDqvpLcEE5kvSqUx5iwX4wy6GnmwelZXhsbmVkX5tHOb5S/HGeh9jo
         bGJRPMNAeSFI3jKEVH+YGqlTm4+NDq8oAO+2U+BUNQ6BzY7Y7eaUFAO6RrygwhTod5g/
         8G+1Qy8L0uH9R3V3LAtKSCqq85IKfoa3Lo3wu6dxV/lFADfcSY3eih2huXjtd1bcjNO7
         Ijrm3psdgUpOdOJxdSPZXr74N0FcKi3YV5IRKzOLAB5pmFehwDfkd+7PDK78qcuvEI9m
         tqMyYfuvk/DZ9mDClrKyUefaBEJcBlY78lSVVGczSzjTYwhcxEAS9FBOlKf1JeHe7aR8
         PfFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=iMj5Um8f+G5xPbwOX4gj2TuSJu85tSxJ1UAz8uEezeM=;
        b=qJZVh0ogsOEe+R7kLYcsawXs3zeR/JYhHRVjPQn00nr2JZU02WBbqqrCG7NxIiCKXj
         j5ocwcwvqqa6YXUG757cqNYBHeDLLwoMG8JWF5HbK6PR6rXvmLWOanSYi4A9Xg1C7hlb
         c3bF3eRJXwIhxIgniM4hyp6PK5bPEYp1CgfrU+dbB6EZvciU/hUwgp3kvDSgwnpQC+U7
         oS18/RDqVqh409YyMWtQZHIf+ocBwF+56anSVnYLGTjVeNbl31CZUQCCDckZt+FDGwsd
         6B3sJJUux1Bq/3RSnaJ7zPzIXjMzdHgFqH/zAv8kqWTxGx/4doK8Gj3oTOT12B00Rnrk
         mXCQ==
X-Gm-Message-State: AOAM533pnmE7EIeqLXTg/Iczi0B6nSn+kXAZLlQ4ubQVzwCW/BXBlslU
        iDaALubu3SkboxxXZsfo2HQ=
X-Google-Smtp-Source: ABdhPJyDaq2sgoKaRT41RqK20giwj8q8m/idFMKEcSXPqqEdbLg5ye+EPXVnmx+shMjcg2u9YMv5pg==
X-Received: by 2002:a63:130b:: with SMTP id i11mr2817250pgl.267.1620627535151;
        Sun, 09 May 2021 23:18:55 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id bx12sm18488375pjb.1.2021.05.09.23.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:18:54 -0700 (PDT)
Date:   Mon, 10 May 2021 16:18:49 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 10/16] powerpc/pseries/vas: Integrate API with
 open/close windows
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <4b66c4eea2c0213be658180c987d81f3bb82293d.camel@linux.ibm.com>
In-Reply-To: <4b66c4eea2c0213be658180c987d81f3bb82293d.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620627261.4i7ukw5i5a.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:08 am:
>=20
> This patch adds VAS window allocatioa/close with the corresponding
> HCALLs. Also changes to integrate with the existing user space VAS
> API and provide register/unregister functions to NX pseries driver.
>=20
> The driver register function is used to create the user space
> interface (/dev/crypto/nx-gzip) and unregister to remove this entry.
>=20
> The user space process opens this device node and makes an ioctl
> to allocate VAS window. The close interface is used to deallocate
> window.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/vas.h          |   5 +
>  arch/powerpc/platforms/book3s/Kconfig   |   2 +-
>  arch/powerpc/platforms/pseries/Makefile |   1 +
>  arch/powerpc/platforms/pseries/vas.c    | 212 ++++++++++++++++++++++++
>  4 files changed, 219 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/va=
s.h
> index d15784506a54..aa1974aba27e 100644
> --- a/arch/powerpc/include/asm/vas.h
> +++ b/arch/powerpc/include/asm/vas.h
> @@ -270,6 +270,11 @@ struct vas_all_capabs {
>  	u64     feat_type;
>  };
> =20
> +int plpar_vas_query_capabilities(const u64 hcall, u8 query_type,
> +				 u64 result);
> +int vas_register_api_pseries(struct module *mod,
> +			     enum vas_cop_type cop_type, const char *name);
> +void vas_unregister_api_pseries(void);
>  #endif
> =20
>  /*
> diff --git a/arch/powerpc/platforms/book3s/Kconfig b/arch/powerpc/platfor=
ms/book3s/Kconfig
> index 51e14db83a79..bed21449e8e5 100644
> --- a/arch/powerpc/platforms/book3s/Kconfig
> +++ b/arch/powerpc/platforms/book3s/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  config PPC_VAS
>  	bool "IBM Virtual Accelerator Switchboard (VAS)"
> -	depends on PPC_POWERNV && PPC_64K_PAGES
> +	depends on (PPC_POWERNV || PPC_PSERIES) && PPC_64K_PAGES
>  	default y
>  	help
>  	  This enables support for IBM Virtual Accelerator Switchboard (VAS).
> diff --git a/arch/powerpc/platforms/pseries/Makefile b/arch/powerpc/platf=
orms/pseries/Makefile
> index c8a2b0b05ac0..4cda0ef87be0 100644
> --- a/arch/powerpc/platforms/pseries/Makefile
> +++ b/arch/powerpc/platforms/pseries/Makefile
> @@ -30,3 +30,4 @@ obj-$(CONFIG_PPC_SVM)		+=3D svm.o
>  obj-$(CONFIG_FA_DUMP)		+=3D rtas-fadump.o
> =20
>  obj-$(CONFIG_SUSPEND)		+=3D suspend.o
> +obj-$(CONFIG_PPC_VAS)		+=3D vas.o
> diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platform=
s/pseries/vas.c
> index 35946fb02995..0ade0d6d728f 100644
> --- a/arch/powerpc/platforms/pseries/vas.c
> +++ b/arch/powerpc/platforms/pseries/vas.c
> @@ -222,6 +222,218 @@ int plpar_vas_query_capabilities(const u64 hcall, u=
8 query_type,
>  		return -EIO;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(plpar_vas_query_capabilities);
> +
> +/*
> + * Allocate window and setup IRQ mapping.
> + */
> +static int allocate_setup_window(struct vas_window *txwin,
> +				 u64 *domain, u8 wintype)
> +{
> +	int rc;
> +
> +	rc =3D plpar_vas_allocate_window(txwin, domain, wintype, DEF_WIN_CREDS)=
;
> +	if (rc)
> +		return rc;
> +
> +	txwin->wcreds_max =3D DEF_WIN_CREDS;
> +
> +	return 0;
> +}
> +
> +static struct vas_window *vas_allocate_window(struct vas_tx_win_open_att=
r *uattr,
> +					      enum vas_cop_type cop_type)
> +{
> +	long domain[PLPAR_HCALL9_BUFSIZE] =3D {VAS_DEFAULT_DOMAIN_ID};
> +	struct vas_ct_capabs *ct_capab;
> +	struct vas_capabs *capabs;
> +	struct vas_window *txwin;
> +	int rc;
> +
> +	txwin =3D kzalloc(sizeof(*txwin), GFP_KERNEL);
> +	if (!txwin)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/*
> +	 * A VAS window can have many credits which means that many
> +	 * requests can be issued simultaneously. But phyp restricts
> +	 * one credit per window.
> +	 * phyp introduces 2 different types of credits:
> +	 * Default credit type (Uses normal priority FIFO):
> +	 *	A limited number of credits are assigned to partitions
> +	 *	based on processor entitlement. But these credits may be
> +	 *	over-committed on a system depends on whether the CPUs
> +	 *	are in shared or dedicated modes - that is, more requests
> +	 *	may be issued across the system than NX can service at
> +	 *	once which can result in paste command failure (RMA_busy).
> +	 *	Then the process has to resend requests or fall-back to
> +	 *	SW compression.
> +	 * Quality of Service (QoS) credit type (Uses high priority FIFO):
> +	 *	To avoid NX HW contention, the system admins can assign
> +	 *	QoS credits for each LPAR so that this partition is
> +	 *	guaranteed access to NX resources. These credits are
> +	 *	assigned to partitions via the HMC.
> +	 *	Refer PAPR for more information.
> +	 *
> +	 * Allocate window with QoS credits if user requested. Otherwise
> +	 * default credits are used.
> +	 */
> +	if (uattr->flags & VAS_WIN_QOS_CREDITS)
> +		capabs =3D &vcapabs[VAS_GZIP_QOS_FEAT_TYPE];
> +	else
> +		capabs =3D &vcapabs[VAS_GZIP_DEF_FEAT_TYPE];
> +
> +	ct_capab =3D &capabs->capab;
> +
> +	if (atomic_inc_return(&ct_capab->used_lpar_creds) >
> +			atomic_read(&ct_capab->target_lpar_creds)) {
> +		pr_err("Credits are not available to allocate window\n");
> +		rc =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * The user space is requesting to allocate a window on a VAS
> +	 * instance (or chip) where the process is executing.
> +	 * On powerVM, domain values are passed to pHyp to select chip /
> +	 * VAS instance. Useful if the process is affinity to NUMA node.
> +	 * pHyp selects VAS instance if VAS_DEFAULT_DOMAIN_ID (-1) is
> +	 * passed for domain values.
> +	 */
> +	if (uattr->vas_id =3D=3D -1) {
> +		/*
> +		 * To allocate VAS window, pass same domain values returned
> +		 * from this HCALL.
> +		 */
> +		rc =3D plpar_hcall9(H_HOME_NODE_ASSOCIATIVITY, domain,
> +				  VPHN_FLAG_VCPU, smp_processor_id());
> +		if (rc !=3D H_SUCCESS) {
> +			pr_err("HCALL(%x): failed with ret(%d)\n",
> +			       H_HOME_NODE_ASSOCIATIVITY, rc);
> +			goto out;
> +		}
> +	}
> +
> +	/*
> +	 * Allocate / Deallocate window HCALLs and setup / free IRQs
> +	 * have to be protected with mutex. Otherwise, since IRQ is freed
> +	 * after deallocate HCALL, may see the case where window ID and
> +	 * fault interrupt could be reused before free IRQ (for the old
> +	 * window) in kernel. It can result in setup IRQ fail for the
> +	 * new window.
> +	 */

It's a bit difficult to understand that comment.

The window deallocate is protected with the mutex, then the mutex
gets dropped. Some time later presumably the IRQ gets freed.

What prevents the window ID from being reused in between?

Thanks,
Nick

> +	mutex_lock(&vas_pseries_mutex);
> +	rc =3D allocate_setup_window(txwin, (u64 *)&domain[0],
> +				   ct_capab->win_type);
> +	mutex_unlock(&vas_pseries_mutex);
> +	if (rc)
> +		goto out;
> +
> +	/*
> +	 * Modify window and it is ready to use.
> +	 */
> +	rc =3D plpar_vas_modify_window(txwin);
> +	if (!rc)
> +		rc =3D vas_reference_task(&txwin->task);
> +	if (rc)
> +		goto out_free;
> +
> +	txwin->lpar.win_type =3D ct_capab->win_type;
> +	mutex_lock(&vas_pseries_mutex);
> +	list_add(&txwin->lpar.win_list, &capabs->list);
> +	mutex_unlock(&vas_pseries_mutex);
> +
> +	return txwin;
> +
> +out_free:
> +	plpar_vas_deallocate_window(txwin->winid);
> +out:
> +	atomic_dec(&ct_capab->used_lpar_creds);
> +	kfree(txwin);
> +	return ERR_PTR(rc);
> +}
> +
> +static u64 vas_paste_address(void *addr)
> +{
> +	struct vas_window *win =3D addr;
> +
> +	return win->lpar.win_addr;
> +}
> +
> +static int deallocate_free_window(struct vas_window *win)
> +{
> +	int rc =3D 0;
> +
> +	rc =3D plpar_vas_deallocate_window(win->winid);
> +	if (!rc)
> +		kfree(win->lpar.name);
> +
> +	return rc;
> +}
> +
> +static int vas_deallocate_window(void *addr)
> +{
> +	struct vas_window *win =3D (struct vas_window *)addr;
> +	struct vas_ct_capabs *capabs;
> +	int rc =3D 0;
> +
> +	if (!win)
> +		return -EINVAL;
> +
> +	/* Should not happen */
> +	if (win->lpar.win_type >=3D VAS_MAX_FEAT_TYPE) {
> +		pr_err("Window (%u): Invalid window type %u\n",
> +				win->winid, win->lpar.win_type);
> +		return -EINVAL;
> +	}
> +
> +	capabs =3D &vcapabs[win->lpar.win_type].capab;
> +	mutex_lock(&vas_pseries_mutex);
> +	rc =3D deallocate_free_window(win);
> +	if (rc) {
> +		mutex_unlock(&vas_pseries_mutex);
> +		return rc;
> +	}
> +
> +	list_del(&win->lpar.win_list);
> +	atomic_dec(&capabs->used_lpar_creds);
> +	mutex_unlock(&vas_pseries_mutex);
> +
> +	vas_drop_reference_task(&win->task);
> +
> +	kfree(win);
> +	return 0;
> +}
> +
> +static struct vas_user_win_ops vops_pseries =3D {
> +	.open_win	=3D vas_allocate_window,	/* Open and configure window */
> +	.paste_addr	=3D vas_paste_address,	/* To do copy/paste */
> +	.close_win	=3D vas_deallocate_window, /* Close window */
> +};
> +
> +/*
> + * Supporting only nx-gzip coprocessor type now, but this API code
> + * extended to other coprocessor types later.
> + */
> +int vas_register_api_pseries(struct module *mod, enum vas_cop_type cop_t=
ype,
> +			     const char *name)
> +{
> +	int rc;
> +
> +	if (!copypaste_feat)
> +		return -ENOTSUPP;
> +
> +	rc =3D vas_register_coproc_api(mod, cop_type, name, &vops_pseries);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(vas_register_api_pseries);
> +
> +void vas_unregister_api_pseries(void)
> +{
> +	vas_unregister_coproc_api();
> +}
> +EXPORT_SYMBOL_GPL(vas_unregister_api_pseries);
> =20
>  /*
>   * Get the specific capabilities based on the feature type.
> --=20
> 2.18.2
>=20
>=20
>=20
