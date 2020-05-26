Return-Path: <SRS0=zQvQ=7I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE16C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 07:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8B220888
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 07:18:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CedWHmXc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgEZHSL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 May 2020 03:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgEZHSK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 May 2020 03:18:10 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58721C03E97E
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2020 00:18:10 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id f5so2181618wmh.2
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2020 00:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=GEr8mOSqsPFk72RdWe7hixeBbOnS/tMn2BfamP39YnY=;
        b=CedWHmXcVkIPLH/3Uv1GkRSuMN/LpNS14R7z7qv+ppNpt6xge0H4bYOXcnH/VirYNq
         qqTwfApelcNdbe0qwST9693eBpim6OaGF3roLWEaj88v1n+u7gAu3bFFcF+HkEC1UYC3
         ECnpv+qb64f2W1lEgQJEfaekJ2e0i1mV+KTh122d1h6y0GvPenECxur0JRMdQ7rjM6an
         2+XDdLiyW7bRYCWI579xTLOKQhG688lYHscYoxnJ7L1E08x6C9HbUnll3XZuDfsL1Dmu
         KnstMOGZVeSaSC6a4S59o2Ub08OMLiWqZ6M4LtmcjufPMCcI+LTSkQxE+1RA3zWyWJqj
         TvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=GEr8mOSqsPFk72RdWe7hixeBbOnS/tMn2BfamP39YnY=;
        b=Md69TpGYSvtOQINsU3Jxn7G+5b9a5EPzoDpdqQAepS+w1QSjFYqFKpeZRVHyAn2g83
         mxP2vvFESJKxUaugQXVDUyNLDLFlXzq1SpGaSYYxhZuXMUVl28vLnQDxC4RgTNDt0u/+
         1D8MseC4bOWsE/ETpZUTXh3FbTsayMGUj0/dzMz+gfFpucaq9aXNQFIv7CmqtvID5vYk
         edNiCJY4NB0aON3jpIQ/TLL+9BmG8t+S6kCn2fp969WH8G6c31uwcVb4F+rCyiMI7eMf
         XTnN6iblh5uj5XhHHB6ftoZTy1IWycjpQE6PGALAjSPVSdItZvNHziGG++SEwSA24Olt
         eVpA==
X-Gm-Message-State: AOAM532FCCzGCR8MncrZuVXUYCHh2VypMdjMMHbcpHdts6lwJie0jeex
        OtpiZioiTxSuRigo0ljxUxh36DG29iNO7J4efRGG8fwh
X-Google-Smtp-Source: ABdhPJzD6rUCCBIyzqUDNHfEDbuhI0Rsb4NsYajQyQG+unHNfVb6pbIbDt2weTe6wUoNq7M6h6VKIrRwY+bZv2GHlN0=
X-Received: by 2002:a1c:6042:: with SMTP id u63mr15834wmb.65.1590477488747;
 Tue, 26 May 2020 00:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <CANpvso4V67SBKn9+SXc+H=r-H-up+GWt77K4jH5HJx9k+sR+hA@mail.gmail.com>
In-Reply-To: <CANpvso4V67SBKn9+SXc+H=r-H-up+GWt77K4jH5HJx9k+sR+hA@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 26 May 2020 15:17:54 +0800
Message-ID: <CACXcFmkYtSeRMNTr=NXGK06MUyEnvaFqe_9Q11kWZq=f1ZdE_A@mail.gmail.com>
Subject: Re: Looking for an open-source thesis idea
To:     Eric Curtin <ericcurtin17@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Curtin <ericcurtin17@gmail.com> wrote:

> Hope I'm not bothering you. I'm looking for a masters thesis idea, ...

> I'm really liking this
> new QUIC (UDP) protocol as an alternative to TCP over TLS. And with
> the growth of new modern secure protocols like Wireguard. I was
> wondering, would it be an idea to do a monolithic secure TCP protocol
> (as an alternative to TCP over TLS) as a small thesis project or is it
> as hard as the guys at Google make is sound?
>
> "Because TCP is implemented in operating system kernels, and middlebox
> firmware, making significant changes to TCP is next to impossible."

I'm inclined to agree with the Google folk on that. However, what about
IPsec? That was designed to secure anything-over-IP so it should be
a more general solution. The FreeS/WAN project added opportunistic
encryption for wider availability
https://freeswan.org/freeswan_trees/freeswan-2.06/doc/intro.html#goals

Today some opportunistic encryption protocols -- SMTP-over-TLS and
HTTPS Everywhere -- are quite widespread but my impression is
that opportunistic IPsec is not. Would adding it to an open source
router be a thesis-sized project? Or, since routers likely have IPsec
already, just making it easier to deploy?

> I'm open to any other suggestions also for my thesis :)

Linux's OOM killer strikes me as a spectacularly ugly kluge,
but people who are certainly more knowledgeable and likely
more competent seem to think it is necessary. Is there a
thesis in examining it, looking at how other Unix-like systems
handle the problem & perhaps implementing an alternative
for Linux?
