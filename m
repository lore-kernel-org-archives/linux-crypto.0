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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38700C48BDF
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 02:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A032613AD
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 02:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhFNCfO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 22:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhFNCfO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 22:35:14 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48B4C061574
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 19:32:59 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id 11so5751772plk.12
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 19:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=hi1JkwtFcpKCljuihi5pbntE8L1PdYXhYCCxSqZJjbw=;
        b=cadI8RVIufgbtI7nDCbP1PxiS+dcSzYHd7a1QHyQdCWpfebHWJefpohUsDTd15qt+4
         0wo7kjIGmj558pX1WFit0dx9YG5OIlrZ5dFSbydvVQw3ySG+c4FehKWsK9KavAE+1tIB
         gLK9kg/WH3QdU+p82Fhl1RMueCONHvUCyxPtXTu26ROxFql/EcLNkOPKg77JjanIW5jX
         MNc3qEK+hQIfQiyNhi29dg7o4mXstdjgb+MPOqEqbPWb9ejPcKm2e4kTVSWynApHprnt
         AfORwT2rliB14+fpi8Y8UKfx8wodUb9QdMR3biQN2SUqk2CaaKvn0eHMY+Ydwjd9i/h0
         im5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=hi1JkwtFcpKCljuihi5pbntE8L1PdYXhYCCxSqZJjbw=;
        b=sSl+Uzv/0Luw2bVLPFrTjiGBwrN0Q0ZzK7qdOdPbPFV75WYf2ognA1iNNStnVOjwsw
         53v7BGrQDdG2OoYRhaB3XA4oucamE48/g3/A8jrhoAuHFwG+HGeogVVEWKZxsrsbyzHj
         K5kcQ3s7xcf0kgx5CJtrtNYh5wWfvisOXypcVjH1Mi/W8tXXoJbszBbwS5R8BcXO6L8N
         zBqbUE0h7kymHWJoRVBzd7kU1RwlQz7jLJr3dtWEoEH9eDt3RzdlNekGb/sXCkNx/z21
         KKrcMXLFRrGXLBET2REvRA3x3hx0xOIUBcZYd+3W1I/EMAqLKwS280ONreryhEou4BWe
         /flw==
X-Gm-Message-State: AOAM530PVIiRq9/moHGIoB3depqnW9yAGJuRkKenkdx6HbOReFwloos3
        kyX3GSTMbpXFoPkCi5GpOXk=
X-Google-Smtp-Source: ABdhPJylIBqRXHV+bdoDmlhtyr0Kfnnibus2eXBUmY+L31Lx57+nhTH0BkqVoWjLepGuQ/75xcvF2Q==
X-Received: by 2002:a17:90a:2b46:: with SMTP id y6mr11397874pjc.157.1623637979365;
        Sun, 13 Jun 2021 19:32:59 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id p19sm15285144pjv.21.2021.06.13.19.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 19:32:59 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:32:54 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 09/17] powerpc/vas: Define QoS credit flag to allocate
 window
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
        <64c8e95b25f58c5e05c98765dab2bc8eb9b1483d.camel@linux.ibm.com>
In-Reply-To: <64c8e95b25f58c5e05c98765dab2bc8eb9b1483d.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623637934.3ehnhbfou2.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 13, 2021 9:00 pm:
>=20
> PowerVM introduces two different type of credits: Default and Quality
> of service (QoS).
>=20
> The total number of default credits available on each LPAR depends
> on CPU resources configured. But these credits can be shared or
> over-committed across LPARs in shared mode which can result in
> paste command failure (RMA_busy). To avoid NX HW contention, the
> hypervisor ntroduces QoS credit type which makes sure guaranteed
> access to NX esources. The system admins can assign QoS credits
> or each LPAR via HMC.
>=20
> Default credit type is used to allocate a VAS window by default as
> on PowerVM implementation. But the process can pass
> VAS_TX_WIN_FLAG_QOS_CREDIT flag with VAS_TX_WIN_OPEN ioctl to open
> QoS type window.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>

Flag name looks good now. Again I don't have the spec, so

Acked-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

> ---
>  arch/powerpc/include/uapi/asm/vas-api.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/include/uapi/asm/vas-api.h b/arch/powerpc/inclu=
de/uapi/asm/vas-api.h
> index ebd4b2424785..7c81301ecdba 100644
> --- a/arch/powerpc/include/uapi/asm/vas-api.h
> +++ b/arch/powerpc/include/uapi/asm/vas-api.h
> @@ -13,11 +13,15 @@
>  #define VAS_MAGIC	'v'
>  #define VAS_TX_WIN_OPEN	_IOW(VAS_MAGIC, 0x20, struct vas_tx_win_open_att=
r)
> =20
> +/* Flags to VAS TX open window ioctl */
> +/* To allocate a window with QoS credit, otherwise use default credit */
> +#define VAS_TX_WIN_FLAG_QOS_CREDIT	0x0000000000000001
> +
>  struct vas_tx_win_open_attr {
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
