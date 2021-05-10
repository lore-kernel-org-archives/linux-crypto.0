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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC9DC433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E34161421
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhEJFzM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 01:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhEJFzM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 01:55:12 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81393C061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 22:54:08 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h20so8589433plr.4
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 22:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=tR7xbEi9c29/x8eJIiHRmINurN5BHiF2ey4jlgTK/Pk=;
        b=KH1SwilXvtXlZAiLyCwvi+Ot9VVWOawIXsHFy0/0SKIc35/u+sV/z5i4KtW7C9nCon
         OzNs3cI+QKy55PN4dJj1SPdfDo7a7q+z8MR196JHZFp1VoL8XghRwv4FRTOuue2Aufvm
         IwQpblSvXnwB1AoeYBQJ+IAil/6y5XeeFt0Qz5HLVcgoMf3zPUJvoOiCIX5j9xTpS/97
         IMsmfvd+O6GemP7h7tOTLRL0Rboyg2NvnZU54sB7AnWGlGH3Y6GKjYvQMRRgxdQDekXb
         51vilZ5RhE/9e7AYwHvBfN0N33MrEK2PPdOHe0A6hCAHsbMsiEb3UInH/R1ZnGS9uV/3
         xubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=tR7xbEi9c29/x8eJIiHRmINurN5BHiF2ey4jlgTK/Pk=;
        b=KDnBL05obhzCCaEvd5LpOORCcnLmiwd3M8e9MCvboMKbGj5R3D7KPiJCPMqOGVRUgr
         7iMDBHAmWY3Sh4exg7STaKqBAvrSWuSHyS2xgkV+SLhKSk7owJ5kbn9ky0C9odIA5n4o
         Tp3e/R8mx18JlSYWGHWQ2a4diMk7C0JtHAA7Ak+ArJHP5ACZGOHgb5ldId+7QXJ8zCqP
         zyQRbZH3bz0r8ZLs5oQqZio5HePfUDEFWSFhBU6sZNzYahANszP8OqGTDm2OPuRLaEZL
         puSPgeeDcxYCDvUA7Q2NyfGznuJuAdo3P2kTJHChz7cym25CpuMKjJf23dPG3b8hm2c0
         SwJw==
X-Gm-Message-State: AOAM531D5BwjzjiRqJlOmOm3V+e8+btoiJI/L5Or+2fnO+HUZmMD/s7+
        tdmhvNmZvnqzulEjsDWClfrGFHqyUrk=
X-Google-Smtp-Source: ABdhPJwC2cknlj0R+/+Nu9uYefhcPSxTHmIleg4vPMSoywZqbkZ+562g4e5nw2cw3Zbeen0dQtG5QQ==
X-Received: by 2002:a17:903:184:b029:ee:c8eb:55b8 with SMTP id z4-20020a1709030184b02900eec8eb55b8mr23150347plg.39.1620626047978;
        Sun, 09 May 2021 22:54:07 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id i8sm73032pjs.54.2021.05.09.22.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 22:54:07 -0700 (PDT)
Date:   Mon, 10 May 2021 15:54:02 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 07/16] powerpc/vas: Define QoS credit flag to allocate
 window
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <90328d5aa92016434f3061ec7cadc812ea2c5dbc.camel@linux.ibm.com>
In-Reply-To: <90328d5aa92016434f3061ec7cadc812ea2c5dbc.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620625758.4u2ddwmbaj.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:06 am:
>=20
> pHyp introduces two different type of credits: Default and Quality
> of service (QoS).
>=20
> The total number of default credits available on each LPAR depends
> on CPU resources configured. But these credits can be shared or
> over-committed across LPARs in shared mode which can result in
> paste command failure (RMA_busy). To avoid NX HW contention, phyp
> introduces QoS credit type which makes sure guaranteed access to NX
> resources. The system admins can assign QoS credits for each LPAR
> via HMC.
>=20
> Default credit type is used to allocate a VAS window by default as
> on powerVM implementation. But the process can pass VAS_WIN_QOS_CREDITS


There's some interchanging of pHyp and PowerVM in the series.

PowerVM is probably the better term to use, with uppercase P.
Unless you mean PAPR or pseries etc.

I think you can say the PAPR VAS spec has two different types of=20
credits, rather than say a specific hypervisor is introducing them.

> flag with VAS_TX_WIN_OPEN ioctl to open QoS type window.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/include/uapi/asm/vas-api.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/include/uapi/asm/vas-api.h b/arch/powerpc/inclu=
de/uapi/asm/vas-api.h
> index ebd4b2424785..eb7c8694174f 100644
> --- a/arch/powerpc/include/uapi/asm/vas-api.h
> +++ b/arch/powerpc/include/uapi/asm/vas-api.h
> @@ -13,11 +13,15 @@
>  #define VAS_MAGIC	'v'
>  #define VAS_TX_WIN_OPEN	_IOW(VAS_MAGIC, 0x20, struct vas_tx_win_open_att=
r)
> =20
> +/* Flags to VAS TX open window ioctl */
> +/* To allocate a window with QoS credit, otherwise default credit is use=
d */
> +#define	VAS_WIN_QOS_CREDITS	0x0000000000000001
> +
>  struct vas_tx_win_open_attr {

Some consistency of naming might help, VAS_TX_WIN_FLAG_QOS_CREDIT.

>  	__u32	version;
>  	__s16	vas_id;	/* specific instance of vas or -1 for default */
>  	__u16	reserved1;
> -	__u64	flags;	/* Future use */
> +	__u64	flags;
>  	__u64	reserved2[6];
>  };
> =20
> --=20
> 2.18.2
>=20
>=20
>=20
