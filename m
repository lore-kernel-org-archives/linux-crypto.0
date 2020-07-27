Return-Path: <SRS0=C5/f=BG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1078FC433E3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 11:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4FA520786
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 11:36:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aGr5q/9Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgG0LgY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgG0LgX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jul 2020 07:36:23 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42371C061794;
        Mon, 27 Jul 2020 04:36:21 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id x9so16834226ljc.5;
        Mon, 27 Jul 2020 04:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3duE7OBR2T4N2tYjRvsITkGu0zyZUrsrEinPE6byIJA=;
        b=aGr5q/9QRAMaUt3j5VfbR3OdspD6ClP8KdgJUfmnmzsunPsBqGa5S9naW8YgBF/zwA
         xk7mCre8gB5IbfeUa3zGFNF80ldeRdn79TISRGf+kftzYbjhBna3K5cPwBEv8QmiDqns
         Eo1HRkKLdsARNMMznT6RAODNxdr2N0NiebCEwrOd4xHSWUDUrfiny+NM0DKHM3CxxbDA
         4McAvoF2Ps7yD3wZq0QzvcBLQXxtVOSswIGiwuMiyQd/6e92DcK0KyXC/LN0EPpdxHHl
         QtkCkh55wJjZ/9fPeyRlUoAaPUKJMpe917jU3ni6GSooU4CSsDX+8sMZqP9+0CW+Ttqq
         iq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3duE7OBR2T4N2tYjRvsITkGu0zyZUrsrEinPE6byIJA=;
        b=SfXXH3H3WD7VWQ19KwEYH4upPiyVdgd9Eeci7v8a+Cp5KUxmC+EXzwY+yFrD47g7Jy
         fFJKMzqZSzEjU3hnshdLqqiUBhqbUPVH2hJGACWDOJ2EFlotjFF1OYZfh3/KP8AeRUg0
         88LPgYGKBURXWq7yfggydKyT49qTaLVmslCUX1rHhRmpzmziu2O1Vd1PPnTNGafVqYCh
         LleLEqCRskfPVa2w+BnPG3ug+MdjskRQj3ZJxhct0oqpNOgRD7JG33YI9Tj9bj5Lp0oQ
         DarIe2SrGLj8mm9Y4YWIsL9iDZhDh50c08qNYjss7U0xcQfs3wOn89AKapok3UY16DOR
         OotA==
X-Gm-Message-State: AOAM532bNfkaDlTKhhIiwZPd3XtbVh6K9rfCRt4UchO/eQof4lQTfwSo
        z77CwDJnx2PZA3juYGmR3EspSHSBQ0G7PM1oZ2M=
X-Google-Smtp-Source: ABdhPJySdoA0YQZX3SzX76PZs+yXIx9uSU6Htm2i166nkcxAQA1159Pl7aChK9+bUVbcPdHRJ+ZUOND1IY6QjMMDCyA=
X-Received: by 2002:a2e:a168:: with SMTP id u8mr9049888ljl.178.1595849779599;
 Mon, 27 Jul 2020 04:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200727105718.26225-1-ceggers@arri.de> <20200727105718.26225-2-ceggers@arri.de>
In-Reply-To: <20200727105718.26225-2-ceggers@arri.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 27 Jul 2020 08:36:08 -0300
Message-ID: <CAOMZO5ASnj7SpjjAEpWjRK-vMpFFKU00=rxKeBtaMSKE9pkX1g@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: dts: imx6ull: Add rngb node
To:     Christian Eggers <ceggers@arri.de>,
        Horia Geanta Neag <horia.geanta@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Anson Huang <Anson.Huang@nxp.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Christian,

On Mon, Jul 27, 2020 at 8:00 AM Christian Eggers <ceggers@arri.de> wrote:
>
> The RNGB block on 6ull has no major differences, but it has no
> switchable clock.

Horia has already sent a patch series that adds imx6ull rngb support:
https://lkml.org/lkml/2020/7/23/173
