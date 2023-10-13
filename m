Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA558CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Oct 2023 14:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjJMOkU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Oct 2023 10:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbjJMOkU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Oct 2023 10:40:20 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C40195
        for <linux-crypto@vger.kernel.org>; Fri, 13 Oct 2023 07:40:18 -0700 (PDT)
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C3D074033F
        for <linux-crypto@vger.kernel.org>; Fri, 13 Oct 2023 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1697208016;
        bh=4Q8qjtTOqM69UGB+qq5ucuXcWb20VRz1rn7B8+UgamA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=AHTFyC4Dy4Hm9lUhRO/+0ht1VWNm5xzeCPc+jMQXRDMt+VS7K8RLkypgv/jy3S5Hl
         XBKZTgX3/V52lG0iwS+Hi06RSeYaGWoYeLnP/cJJQVaIQWxxs1OmDc/+nMjMYbbwnV
         l9cRrO7GeqcMscG8vkHWZysmB25zeSVlVdgrIZvRxcI1STHho80jC67QI1+omZDvPS
         sMPhZyRAeNqNA3iCLKKk0Ak02B0pt2K3d5URYG4MMAVcIJ4ZaH18g4qPuSzD1zo3WG
         v6cGyxsQ4QIosoq3iivcGDTLVaJux3GK4gG4CQ4h+lSgWjexB3f5ygo3JISu/IWX0X
         ZWTbQFXYkW+IQ==
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-313c930ee0eso1250029f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Oct 2023 07:40:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697208016; x=1697812816;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Q8qjtTOqM69UGB+qq5ucuXcWb20VRz1rn7B8+UgamA=;
        b=f0bolsA+RcoJ69zsviG2/GNedEOmowPa/vtTG/u1E7rqirNlwoudu5D+r48J1uaK9y
         nuSknmtBMU+4B37WaTIMB77nM+JBA3L8XxVVmxC51D8NvB10GaNT3Xt1++TLp/Tl8uUr
         4ec2LfCOYagMdWOazp3xHDdSvN/fphNCf1e3JobURhjIGsYDo3DpJa52eHas3Sra/69f
         fLFH2SREDdzLmBSVgyIdPMKuJgibj4jIdZg1KlghNV8azE/Dc0MiOEE9t0dWggfIVL0v
         /B1CCqMCGXDkkN0CS4TvUR157DsKj7coEHZod6hQtNz8+VX+yMWnXFwiahuA7LvNIU0U
         6F+Q==
X-Gm-Message-State: AOJu0Ywbd4b2vUzAdBVVQpRSFA0og5PKJL4eFUMH9jeb24zOdIJNActx
        kpihwUaY6HgVScSh1gad8/W6sbA1Zlavo7+lKIJTkSUIS9/KOZKDarCuXatbIJntANa4wpZRvqH
        KdM+49rU47VLiJon6F5o7lPD4H1uP4mvFJZkzvVIxTdGCXtVHlOngvL+6KA==
X-Received: by 2002:adf:b613:0:b0:32d:9876:571c with SMTP id f19-20020adfb613000000b0032d9876571cmr2165040wre.63.1697208016295;
        Fri, 13 Oct 2023 07:40:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNMtvOMfvtHRsCfuYjDaRp2+xKVftk4EeEH80Pl99DSkhNsK0NT6vWxwfIWZRNNCDwt+rGXII5LrykndHgnuQ=
X-Received: by 2002:adf:b613:0:b0:32d:9876:571c with SMTP id
 f19-20020adfb613000000b0032d9876571cmr2165019wre.63.1697208016003; Fri, 13
 Oct 2023 07:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20231008040140.1647892-1-dimitri.ledkov@canonical.com>
 <ZSkeWHdOAOfjtpwJ@gondor.apana.org.au> <2e52c8b4-e70a-453f-853a-1962c8167dfa@gmail.com>
In-Reply-To: <2e52c8b4-e70a-453f-853a-1962c8167dfa@gmail.com>
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Date:   Fri, 13 Oct 2023 15:39:40 +0100
Message-ID: <CADWks+aV+QzJo8LQt9eD4YSghF+Ez7iDx8zzz_hfL_2am2zLNA@mail.gmail.com>
Subject: Re: [PATCH] crypto: remove md4 driver
To:     Denis Kenzior <denkenz@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        James Prestwood <prestwoj@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 13 Oct 2023 at 15:37, Denis Kenzior <denkenz@gmail.com> wrote:
>
> Hi Herbert,
>
> On 10/13/23 05:39, Herbert Xu wrote:
> > On Sun, Oct 08, 2023 at 05:01:39AM +0100, Dimitri John Ledkov wrote:
> >> No internal users left and cryptographically insecure. Users should
> >> upgrade to something else, e.g. sha256 blake3.
> >>
> >> Some drivers have their own full or partial md4 implementation without
> >> using crypto/md4.
> >>
> >> Userspace code search indicates a few copies of hash_info.h
> >> https://codesearch.debian.net/search?q=HASH_ALGO_MD4&literal=1 without
> >> need for MD4.
> >>
> >> Preserve uapi hash algorithm indexes and array length, but rename the
> >> MD4 enum.
> >>
> >> Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
> >> ---
> >>   crypto/Kconfig                 |   6 -
> >>   crypto/Makefile                |   1 -
> >>   crypto/hash_info.c             |   4 +-
> >>   crypto/md4.c                   | 241 ---------------------------------
> >>   crypto/tcrypt.c                |  12 --
> >>   crypto/testmgr.c               |   6 -
> >>   crypto/testmgr.h               |  42 ------
> >>   include/uapi/linux/hash_info.h |   2 +-
> >>   8 files changed, 3 insertions(+), 311 deletions(-)
> >>   delete mode 100644 crypto/md4.c
> >
> > Patch applied.  Thanks.
>
> Does this patch break userspace?

I will check all of the below and get back to you.

>
> Here's a thread regarding MD4 the last time its removal was attempted:
> https://lore.kernel.org/linux-crypto/20210818144617.110061-1-ardb@kernel.org/
>
> Please note that iwd does use MD4 hashes here:
> https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/checksum.c#n63
>
> https://git.kernel.org/pub/scm/network/wireless/iwd.git/tree/src/eap-mschapv2.c#n165
>
> Regards,
> -Denis



-- 
okurrr,

Dimitri
