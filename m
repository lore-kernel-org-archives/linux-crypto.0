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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5AEC47082
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 04:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19A6613E6
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 04:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFCEtL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 00:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhFCEtK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 00:49:10 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1576DC06174A
        for <linux-crypto@vger.kernel.org>; Wed,  2 Jun 2021 21:47:15 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x73so3957958pfc.8
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jun 2021 21:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=5BxQCzlM1E2ndPb7NDda4MnVd7oyXumKn79J+591Mjs=;
        b=ciYmpOGYU6wkezLHGPUp1EdmFDk+UVzBngVaYTGsZdWHpyK5bVnh7uGgaWgsqyEx32
         7VLV9Ry/Z94yrhovcdZ6OizedEAfKywyqHDi8hH40z/AfKnUKRMMrlnzgwsyPYY3Mpe0
         NwzM/uDDA1UtzZ3Y6fKZ9CcSQjcw4BZnEirVv0dPHIbvk1WZTj8DIWSZGaJ0d4aIqN5c
         XiSzx/v0KI3xBg3B9juzifI9eHjWOQDaTdjDj8m/fH2MwkzcRyBecBazCFtCIgvovt2x
         GxVJoIdCxl9mu87Nv4MU8b88Z30AhqTaXW4R8S1T7m6hQIReC2YlgbxWbI5XGL5nLAzN
         fFFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=5BxQCzlM1E2ndPb7NDda4MnVd7oyXumKn79J+591Mjs=;
        b=kLfaUTk/jxHGfELeHwc5Vg26VGu6nV5gt5IzW1L09I5J6E9FHHL5JqtfwlPqeMbR6R
         mJ703hamniNMybgRuQhVlfkoqXkOtBw0Kq1LBHGDCgoMcAjVE/RR1FEWgINyGev4H8UB
         2FIXoprfLRzz7PcGXZIuN7kj9D3OqQtqxmsDpYqNFhBo9HzEcjKxJ3P01Ol9xo4V932T
         7xmuqpiPas5Y/dgVRwmlnbpyHE67KG5EKW1D9sN3vHqgvjy/ERQ2t0EAQSHGioY8zXDT
         39vZTX04FHFG6RExYt3NApM+aHnAoOnhiukLKqKMtsvd6Xw67wCi8W8Rd8POSGC2UkYF
         srxg==
X-Gm-Message-State: AOAM530O1/SjdKFgLZsN37nOumFh3DI2IZX/ycgBn9MlBC8MnINSVPVq
        D4AhpMVPUNOae29VJNTnKl/KBk4R+bI=
X-Google-Smtp-Source: ABdhPJxRvuhsr8GUvnRhzQ/mKC8d6yh4IoLE5FRb7PJfWhuJaVfDsm2vhoq6hnVJXmIBC0ahFepX3w==
X-Received: by 2002:a63:fe53:: with SMTP id x19mr37866486pgj.372.1622695634534;
        Wed, 02 Jun 2021 21:47:14 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id j17sm998721pff.77.2021.06.02.21.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:47:14 -0700 (PDT)
Date:   Thu, 03 Jun 2021 14:47:09 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 07/16] powerpc/pseries/vas: Define VAS/NXGZIP HCALLs
 and structs
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
        <4d1a19311883c2ac6620633721ecc81d753f26c8.camel@linux.ibm.com>
In-Reply-To: <4d1a19311883c2ac6620633721ecc81d753f26c8.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1622695206.q32wg4puuh.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of May 21, 2021 7:34 pm:
>=20
> This patch adds HCALLs and other definitions. Also define structs
> that are used in VAS implementation on powerVM.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/hvcall.h    |   7 ++
>  arch/powerpc/include/asm/vas.h       |  32 ++++++++
>  arch/powerpc/platforms/pseries/vas.h | 110 +++++++++++++++++++++++++++
>  3 files changed, 149 insertions(+)
>  create mode 100644 arch/powerpc/platforms/pseries/vas.h
>=20
> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm=
/hvcall.h
> index e3b29eda8074..7c3418d1b5e9 100644
> --- a/arch/powerpc/include/asm/hvcall.h
> +++ b/arch/powerpc/include/asm/hvcall.h
> @@ -294,6 +294,13 @@
>  #define H_RESIZE_HPT_COMMIT	0x370
>  #define H_REGISTER_PROC_TBL	0x37C
>  #define H_SIGNAL_SYS_RESET	0x380
> +#define H_ALLOCATE_VAS_WINDOW	0x388
> +#define H_MODIFY_VAS_WINDOW	0x38C
> +#define H_DEALLOCATE_VAS_WINDOW	0x390
> +#define H_QUERY_VAS_WINDOW	0x394
> +#define H_QUERY_VAS_CAPABILITIES	0x398
> +#define H_QUERY_NX_CAPABILITIES	0x39C
> +#define H_GET_NX_FAULT		0x3A0
>  #define H_INT_GET_SOURCE_INFO   0x3A8
>  #define H_INT_SET_SOURCE_CONFIG 0x3AC
>  #define H_INT_GET_SOURCE_CONFIG 0x3B0
> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/va=
s.h
> index 49bfb5be896d..371f62d99174 100644
> --- a/arch/powerpc/include/asm/vas.h
> +++ b/arch/powerpc/include/asm/vas.h
> @@ -181,6 +181,7 @@ struct vas_tx_win_attr {
>  	bool rx_win_ord_mode;
>  };
> =20
> +#ifdef CONFIG_PPC_POWERNV
>  /*
>   * Helper to map a chip id to VAS id.
>   * For POWER9, this is a 1:1 mapping. In the future this maybe a 1:N
> @@ -248,6 +249,37 @@ void vas_win_paste_addr(struct vas_window *window, u=
64 *addr,
>  int vas_register_api_powernv(struct module *mod, enum vas_cop_type cop_t=
ype,
>  			     const char *name);
>  void vas_unregister_api_powernv(void);
> +#endif
> +
> +#ifdef CONFIG_PPC_PSERIES
> +
> +/* VAS Capabilities */
> +#define VAS_GZIP_QOS_FEAT	0x1
> +#define VAS_GZIP_DEF_FEAT	0x2
> +#define VAS_GZIP_QOS_FEAT_BIT	PPC_BIT(VAS_GZIP_QOS_FEAT) /* Bit 1 */
> +#define VAS_GZIP_DEF_FEAT_BIT	PPC_BIT(VAS_GZIP_DEF_FEAT) /* Bit 2 */
> +
> +/* NX Capabilities */
> +#define VAS_NX_GZIP_FEAT	0x1
> +#define VAS_NX_GZIP_FEAT_BIT	PPC_BIT(VAS_NX_GZIP_FEAT) /* Bit 1 */
> +#define VAS_DESCR_LEN		8
> +
> +/*
> + * These structs are used to retrieve overall VAS capabilities that
> + * the hypervisor provides.
> + */
> +struct hv_vas_all_caps {

...

> +
> +/*
> + * Use to get feature specific capabilities from the
> + * hypervisor.
> + */
> +struct hv_vas_ct_caps {

...

> +/*
> + * To get window information from the hypervisor.
> + */
> +struct hv_vas_win_lpar {

Are any of these names coming from PAPR? If not, then typically we don't=20
use hv_ kind of prefixes for something we got from the hypervisor, but
rather something that's hypervisor privileged or specific information
about the hypervisor perhaps (which is not the same as what the=20
hypervisor may or may not advertise to the guest).

So if these are all capabilities and features the hypervisor advertises=20
to the LPAR, I think the hv_ should be dropped.

Otherwise seems okay. I would be careful of the "lpar" name. I think=20
it's okay in this situation where the hypervisor advertises features to=20
the partition, but in other parts of the vas code you call it pseries_
but you also have some lpar_ bits. So aside from interacting with PAPR
APIs, it would be safe to consistently use pseries for your driver and
type names.

Thanks,
Nick
