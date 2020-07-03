Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5FEC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 13:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E0EA20760
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 13:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U1tx+Nh2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgGCNdq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgGCNdq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jul 2020 09:33:46 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFECCC08C5C1
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2020 06:33:45 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s10so32662878wrw.12
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2020 06:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4CUkejNQ9hzeyTgPJK7NXp6e16zz9O+Bis7lft+1r/w=;
        b=U1tx+Nh2qb2U9GdchuUAPHPOSKiOYMS1HqF3GrtuiohOTQppEIc658msTLfkLZdcwy
         3S1BoC9Uottsq9Ow+DuGW2/KQiDTkehFa0Iq3ET7JztxmKNzLZBGQ+Uo+qv/733+MuJm
         336hHUy7G+CgI7/kHK+n6EcdwZTZqduTb+bB6XibsTtU9mvqkSrruFsAgCjGyq5/IA6j
         lfgOtW33ebeJPa70APSMABByGk1eh29P9DX/vgZlbyKcpgPpKR9sih72iMbCNIiPFbru
         px2doiiCq1gmgVpw50b/3djE947ot1sunvt1bI/9+AVzpx7wdNFxn8cXFSEzlKNgpOUJ
         1cpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4CUkejNQ9hzeyTgPJK7NXp6e16zz9O+Bis7lft+1r/w=;
        b=f7U7QH1Sa/0K25D0CvorrSOS54qKQDO411nSCbx70y958Z7e9rpyE7NpCV5iuxWSGf
         vBOs73k0bgravfUMtarlbyPvZani+Y56dm2NvUqh1Y2tQaFE3rPc69+WgXn/puDDEbHx
         6v/4SuBdOVKLEobnz4CfEpGwqA+1eoJJiUbifhPxdbmBP+fl1H3DHfYXZu+Mh7Kwodmw
         6Hcf9bnIoK3RTwE+Exo0Yi+nuN5uPCMRoYuZ55e6GhSEKrekpeKyR3+P6tJ4B+7d6i+c
         5C2/XNUludUTlmsyzzV+u53E5TvVCLdbvbrBc//1tKIwZXYG4MqlncF+E/Zi6EnX2MAv
         l++Q==
X-Gm-Message-State: AOAM5305GquIAoTaWV/RK+Nyd005X0MMx7ty75qWzcQ/qVpdEgC2B/NQ
        WheqfVhcpjknzUi8d0hSNVIfdy3E/esrC65oCohT4Zuy
X-Google-Smtp-Source: ABdhPJxdLKepDh4uwm8PTY/GF/LxpKJPEP8bPlNPiEqJLKZRHLr+Czkq+nJZr+KlFQo4TLdIO3iUm99y6+yKxOX4KeA=
X-Received: by 2002:adf:a34a:: with SMTP id d10mr12733820wrb.59.1593783224721;
 Fri, 03 Jul 2020 06:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <TU4PR8401MB121625D980E4FEF13345BD12F66A0@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <TU4PR8401MB121625D980E4FEF13345BD12F66A0@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Fri, 3 Jul 2020 21:33:29 +0800
Message-ID: <CACXcFmkHJD+utZ8qKTrj7kwq6xY4M2tosFSdXX_L-2C-72OjaA@mail.gmail.com>
Subject: Re: No ESP response
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Bhat, Jayalakshmi Manjunath <jayalakshmi.bhat@hp.com> wrote:

> We are executing a simple ping test on our device in transport mode.

I wrote this 20 years ago. Does it help?
https://www.freeswan.org/freeswan_trees/freeswan-2.06/doc/faq.html#cantping
