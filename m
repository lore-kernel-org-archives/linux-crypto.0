Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AAE6C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77EEC60232
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhKARTZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 13:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKARTY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 13:19:24 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E8BC061714
        for <linux-crypto@vger.kernel.org>; Mon,  1 Nov 2021 10:16:51 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 205so30460678ljf.9
        for <linux-crypto@vger.kernel.org>; Mon, 01 Nov 2021 10:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/z/u7zrhOOb0248ofbLp+UtjDibZ2pd/j9KJOwRj3AU=;
        b=T5LhsjeiajoRGWvWTMxBGyKDuGLmnF1yY6CIXbvM+oM71imu6/5kIfSpd9Y6bGro2T
         nW52jpDGjEUSPDbFLlXgCNMv2GymAhXvaXKC2LBJ2FmAsRDMkew25MXYqqMvleDcBFDe
         X9eYzjaTR62rmNQScRQbyskGLF9r1wNkfYVIYt9dsuurd7HnlcK3PAbe4D+15NR9jebk
         laF3iFQ4u5Ref+xRJetOtvABneLODG+QepiEEzdXYyD24n2HzasIoOXxZOzKe34PJzbX
         YLSQgDluMceUsJWjypmuMPOkt1l/V9Ojd7NVtEkQIYZoHfv6121SrZVQ2IfbYMiToIba
         Ex7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/z/u7zrhOOb0248ofbLp+UtjDibZ2pd/j9KJOwRj3AU=;
        b=37RGKrc2SJYfgOTWAtdq1bD87oidsBhdex3HQZmX6DHDB1+yNeWxuCuYBSSN5iwqTG
         Qo7d2vw8a3l2yO1UfdMCgth0wvNkTLX8UHiPgqE47zsJCBNL1IAovYgrHfygMTbYzZ+v
         hyJpLpUNyNKMukxHo+axhA4ztURt78TUrXxyiO4htKf2/H1E9dw+QEGgeSLkNc6hu/Tp
         DVA3S4ljHVBfPC+mhKwnEBAktqaDu1fTz8CFHuDpxKaWE+KLnOTtZKig4gnJbNAxcrBH
         s8vtKIf79ZGGYGP8e7EeRFsiwa5igZ1Eq57ncmklIKNbAvLyCWCFx5Xph/N3Q8VgnpNm
         pS3Q==
X-Gm-Message-State: AOAM533YYAlq4EQ50vwjSmAFM1R1fFrjc/UL9/Sf5jYNDsFXHntkrUSz
        2Wv/shTps7q8wo2HH7ceGB5HrB4xqAJNzN/UuPiLwA==
X-Google-Smtp-Source: ABdhPJxdu3XY4tmRL1HtFXzkcsHDUwJgVUrYiYO9BPYkeVI4cZOU2Otj7lhLiApTrcxv7pSE7jYPKdwBQfoHLK5su6M=
X-Received: by 2002:a2e:9ca:: with SMTP id 193mr32630607ljj.83.1635787009104;
 Mon, 01 Nov 2021 10:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <20211028175749.1219188-1-pgonda@google.com> <20211028175749.1219188-5-pgonda@google.com>
 <c2076ecf-8b30-c96e-2169-bc1f031d309e@amd.com> <CAMkAt6rKZx=S7tRuNo-dnHw_iJ2uiDp1nzL-WiAgD+uQo+aCyA@mail.gmail.com>
 <SN6PR12MB27981792BC31C8FB0CB169B5F7879@SN6PR12MB2798.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB27981792BC31C8FB0CB169B5F7879@SN6PR12MB2798.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 1 Nov 2021 11:16:37 -0600
Message-ID: <CAMkAt6qHsAsbFsew+tijvbJNvabEiL2=iMNUxTAacL8qRH8rMw@mail.gmail.com>
Subject: Re: [PATCH 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     "Relph, Richard" <Richard.Relph@amd.com>
Cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Allen, John" <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 29, 2021 at 1:26 PM Relph, Richard <Richard.Relph@amd.com> wrote:
>
> [AMD Official Use Only]
>
>
>
> > Does SHUTDOWN modify the SPI/NV area? Otherwise a separate comment about
> > why it is included below.
>
> Double checked the FW doc looks like it does not. Richard can you
> confirm? If it doesn't I'll remove this case.
>
> Peter,
>     SHUTDOWN does NOT modify the SPI or write to the NV area in memory.
>  Richard

Thanks! I'll leave it out of this conditional.
