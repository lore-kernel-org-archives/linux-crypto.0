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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FC2C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B94CE61421
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhEJFuL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 01:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhEJFuL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 01:50:11 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52392C061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 22:49:07 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x188so12847369pfd.7
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 22:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=RCOq1bK6jzBD5n7Izz4k/SW9DNNYxjFxMPItnne+XwQ=;
        b=l0gP6hOHG7yQnnj7bQwHy7B6EaoSuvWpVLSuJVkh1clal3jmbodqizUaVPWGYmRgNy
         WVKW04WFWnEmJdcUq0pBy+8uVEHEA/YrOMu20jHxq0SToOk9xhfbN6vNuzpVekl88JGq
         tsD3XbFslQao7oCf6AwOujDIPvhQcMq44mHs2uFvshxtmDDzHwfSb6zEt7mSkKM98lCZ
         kNALr6g5KsXygKRtWOcgKDMrEZ/ykMKlRU+iauNUN0SBCLAYlk9jcDyvSHcVAErQRxne
         yWwFBAs0dl8P+lV0Mn1RH7sVdIt3n1JptkGvGaqAIdPziwGyWsyAgEaa7TVcybS1q1bC
         y40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=RCOq1bK6jzBD5n7Izz4k/SW9DNNYxjFxMPItnne+XwQ=;
        b=Akh3VudqnRLOfQm4Txvb7QS/1qHcf8jit1GCMo/TS8hKGpjGk2X78/TM0U8gAJAR5N
         iEqLYsSANhHH+ghXZ49nCMJov6aIVVN3guFjAlvHsAAnVOjxWWicO6KgkoYC6Ro4S91Z
         MvfeLL2i84297y7DQdz3c89ZKnen+KgXRdfrjcf/WArALA4K15hEECVGxAs/SC/8O+xG
         GkVSjfPrHpfkQh15KOwtUSIGPgxYwNK0KpwLD2NA3OPVYD/vk64eeZTzbvVhSeZ6ltHW
         /qeUhZ38UJM84+ZJpfYjhRCu0QbvJl/2UXhs3H1PEmdlvj7F7KbsgCTmBCK48/ex3BKL
         5NWw==
X-Gm-Message-State: AOAM533Qw1H4iU1OcvBWuKCSn+Z1JqnqxSPvajAYpVb+JQXINgLzQMLd
        2pgi2s4tsBd2zRChkI/F6SKc2vumW04=
X-Google-Smtp-Source: ABdhPJz7BUU3qFBw/o6DTLVN/NZ14YuJpLDc24lINBkOrZg7+mRw5k0opg0W4TvsGVyv6QIPuN5KOw==
X-Received: by 2002:a62:6202:0:b029:208:f11c:2143 with SMTP id w2-20020a6262020000b0290208f11c2143mr23545434pfb.32.1620625746747;
        Sun, 09 May 2021 22:49:06 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id l64sm10535928pgd.20.2021.05.09.22.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 22:49:06 -0700 (PDT)
Date:   Mon, 10 May 2021 15:49:01 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 06/16] powerpc/pseries/vas: Define VAS/NXGZIP HCALLs
 and structs
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <286ae5f4fdc4fd5620470cb0bf452e827e1f3864.camel@linux.ibm.com>
In-Reply-To: <286ae5f4fdc4fd5620470cb0bf452e827e1f3864.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620625091.ey2jdts2en.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:05 am:
>=20
> This patch adds HCALLs and other definitions. Also define structs
> that are used in VAS implementation on powerVM.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/hvcall.h    |  7 ++
>  arch/powerpc/include/asm/vas.h       | 28 ++++++++
>  arch/powerpc/platforms/pseries/vas.h | 96 ++++++++++++++++++++++++++++
>  3 files changed, 131 insertions(+)
>  create mode 100644 arch/powerpc/platforms/pseries/vas.h
>=20
> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm=
/hvcall.h
> index ed6086d57b22..accbb7f6f272 100644
> --- a/arch/powerpc/include/asm/hvcall.h
> +++ b/arch/powerpc/include/asm/hvcall.h
> @@ -294,6 +294,13 @@
>  #define H_RESIZE_HPT_COMMIT	0x370
>  #define H_REGISTER_PROC_TBL	0x37C
>  #define H_SIGNAL_SYS_RESET	0x380
> +#define	H_ALLOCATE_VAS_WINDOW	0x388
> +#define	H_MODIFY_VAS_WINDOW	0x38C
> +#define	H_DEALLOCATE_VAS_WINDOW	0x390
> +#define	H_QUERY_VAS_WINDOW	0x394
> +#define	H_QUERY_VAS_CAPABILITIES	0x398
> +#define	H_QUERY_NX_CAPABILITIES	0x39C
> +#define	H_GET_NX_FAULT		0x3A0

These should be spaces.

>  #define H_INT_GET_SOURCE_INFO   0x3A8
>  #define H_INT_SET_SOURCE_CONFIG 0x3AC
>  #define H_INT_GET_SOURCE_CONFIG 0x3B0
> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/va=
s.h
> index f928bf4c7e98..d15784506a54 100644
> --- a/arch/powerpc/include/asm/vas.h
> +++ b/arch/powerpc/include/asm/vas.h
> @@ -179,6 +179,7 @@ struct vas_tx_win_attr {
>  	bool rx_win_ord_mode;
>  };
> =20
> +#ifdef CONFIG_PPC_POWERNV
>  /*
>   * Helper to map a chip id to VAS id.
>   * For POWER9, this is a 1:1 mapping. In the future this maybe a 1:N
> @@ -243,6 +244,33 @@ int vas_paste_crb(struct vas_window *win, int offset=
, bool re);
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
> +#define VAS_GZIP_QOS_FEAT_BIT	(1UL << (63 - VAS_GZIP_QOS_FEAT)) /* Bit 1=
 */
> +#define VAS_GZIP_DEF_FEAT_BIT	(1UL << (63 - VAS_GZIP_DEF_FEAT)) /* Bit 2=
 */

Use PPC_BIT for these.

> +
> +/* NX Capabilities */
> +#define	VAS_NX_GZIP_FEAT	0x1
> +#define	VAS_NX_GZIP_FEAT_BIT	(1UL << (63 - VAS_NX_GZIP_FEAT)) /* Bit 1 *=
/
> +#define	VAS_DESCR_LEN		8
> +
> +struct vas_all_capabs_be {
> +		__be64  descriptor;
> +		__be64  feat_type;
> +} __packed __aligned(0x1000);
> +
> +struct vas_all_capabs {
> +	char	name[VAS_DESCR_LEN + 1];
> +	u64     descriptor;
> +	u64     feat_type;
> +};

You're using _be for the struct that is passed to the hcall, and a=20
non-postfixed one for something the driver uses internally? It seems
like buf or buffer, or hv_ prefix is typically used rather than be (host=20
kernel could be BE).

struct hv_query_vas_capabilities_buffer for example.

Does the hcall really require 0x1000 alignment?

> +
> +#endif
> =20
>  /*
>   * Register / unregister coprocessor type to VAS API which will be expor=
ted
> diff --git a/arch/powerpc/platforms/pseries/vas.h b/arch/powerpc/platform=
s/pseries/vas.h
> new file mode 100644
> index 000000000000..208682fffa57
> --- /dev/null
> +++ b/arch/powerpc/platforms/pseries/vas.h
> @@ -0,0 +1,96 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright 2020-21 IBM Corp.
> + */
> +
> +#ifndef _VAS_H
> +#define _VAS_H
> +#include <asm/vas.h>
> +#include <linux/mutex.h>
> +#include <linux/stringify.h>
> +
> +/*
> + * VAS window modify flags
> + */
> +#define	VAS_MOD_WIN_CLOSE	(1UL << 63)
> +#define	VAS_MOD_WIN_JOBS_KILL	(1UL << (63 - 1))
> +#define	VAS_MOD_WIN_DR		(1UL << (63 - 3))
> +#define	VAS_MOD_WIN_PR		(1UL << (63 - 4))
> +#define	VAS_MOD_WIN_SF		(1UL << (63 - 5))
> +#define	VAS_MOD_WIN_TA		(1UL << (63 - 6))
> +#define	VAS_MOD_WIN_FLAGS	(VAS_MOD_WIN_JOBS_KILL | VAS_MOD_WIN_DR | \
> +				VAS_MOD_WIN_PR | VAS_MOD_WIN_SF)
> +
> +#define	VAS_WIN_ACTIVE		0x0
> +#define	VAS_WIN_CLOSED		0x1
> +#define	VAS_WIN_INACTIVE	0x2	/* Inactive due to HW failure */
> +/* Process of being modified, deallocated, or quiesced */
> +#define	VAS_WIN_MOD_IN_PROCESS	0x3
> +
> +#define	VAS_COPY_PASTE_USER_MODE	0x00000001
> +#define	VAS_COP_OP_USER_MODE		0x00000010
> +
> +/*
> + * Co-processor feature - GZIP QoS windows or GZIP default windows
> + */
> +enum vas_cop_feat_type {
> +	VAS_GZIP_QOS_FEAT_TYPE,
> +	VAS_GZIP_DEF_FEAT_TYPE,
> +	VAS_MAX_FEAT_TYPE,
> +};
> +
> +struct vas_ct_capabs_be {
> +	__be64	descriptor;
> +	u8	win_type;		/* Default or QoS type */
> +	u8	user_mode;
> +	__be16	max_lpar_creds;
> +	__be16	max_win_creds;
> +	union {
> +		__be16	reserved;
> +		__be16	def_lpar_creds; /* Used for default capabilities */
> +	};
> +	__be16	target_lpar_creds;
> +} __packed __aligned(0x1000);
> +
> +struct vas_ct_capabs {
> +	char		name[VAS_DESCR_LEN + 1];
> +	u64		descriptor;
> +	u8		win_type;	/* Default or QoS type */
> +	u8		user_mode;	/* User mode copy/paste or COP HCALL */
> +	u16		max_lpar_creds;	/* Max credits available in LPAR */
> +	/* Max credits can be assigned per window */
> +	u16		max_win_creds;
> +	union {
> +		u16	reserved;	/* Used for QoS credit type */
> +		u16	def_lpar_creds; /* Used for default credit type */
> +	};
> +	/* Total LPAR available credits. Can be different from max LPAR */
> +	/* credits due to DLPAR operation */
> +	atomic_t	target_lpar_creds;
> +	atomic_t	used_lpar_creds; /* Used credits so far */
> +	u16		avail_lpar_creds; /* Remaining available credits */
> +};
> +
> +struct vas_capabs {
> +	struct vas_ct_capabs capab;
> +	struct list_head list;
> +};
> +
> +struct vas_win_lpar_be {
> +	__be16	version;
> +	u8	win_type;
> +	u8	status;
> +	__be16	credits;	/* No of credits assigned to this window */
> +	__be16	reserved;
> +	__be32	pid;		/* LPAR Process ID */
> +	__be32	tid;		/* LPAR Thread ID */
> +	__be64	win_addr;
> +	__be32	interrupt;	/* Interrupt when NX request completes */
> +	__be32	fault;		/* Interrupt when NX sees fault */
> +	/* Associativity Domain Identifiers as returned in */
> +	/* H_HOME_NODE_ASSOCIATIVITY */
> +	__be64	domain[6];
> +	__be64	win_util;	/* Number of bytes processed */
> +} __packed __aligned(0x1000);
> +
> +#endif /* _VAS_H */
> --=20
> 2.18.2
>=20
>=20
>=20
