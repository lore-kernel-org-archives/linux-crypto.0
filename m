Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A26AC64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 22:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE2D620671
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 22:28:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IJOeVEvy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgLAW2q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 17:28:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgLAW2p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 17:28:45 -0500
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68402087C
        for <linux-crypto@vger.kernel.org>; Tue,  1 Dec 2020 22:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606861684;
        bh=oUk3t9aepAO2x9YAWK+7mS8/O2YqOb4mMpEVIf7EkYc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IJOeVEvyx+IQ33/DOhuQtGjVGh88gI98PR/wU3H1Hy4dkekKgGYqVkkeAZTp57xYt
         QFI8IXvacB5IDdAbeiSB5EcG3ySpl1OmF13s2kQ977Yog/zrR3yXsQlRCTqz0tp8PS
         cmapt9t52qwIEz4DSQ1QcuiWKHnk+v8N5Oh+5Az8=
Received: by mail-ot1-f51.google.com with SMTP id j21so3166949otp.8
        for <linux-crypto@vger.kernel.org>; Tue, 01 Dec 2020 14:28:04 -0800 (PST)
X-Gm-Message-State: AOAM532pNpznhwS/X9ExK4uWEg0HCDd1KGZE33NqrNa80laMVT8/ogm5
        ic3VdEF1XkrnXazy3w5sjGaux/Yw+Rt3/E3mEyo=
X-Google-Smtp-Source: ABdhPJw9Lg65IXcUss8m/62MfxtBpNm49+vLMQrjizGraUO+jZcfkG1ozJVRApVY/BA+oT8BOORnjLHOVvyHlcYjto8=
X-Received: by 2002:a05:6830:3099:: with SMTP id f25mr3428489ots.77.1606861683870;
 Tue, 01 Dec 2020 14:28:03 -0800 (PST)
MIME-Version: 1.0
References: <20201201194556.5220-1-ardb@kernel.org> <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au> <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au>
In-Reply-To: <20201201221628.GA32130@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 1 Dec 2020 23:27:52 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
Message-ID: <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@cal-sierra.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 1 Dec 2020 at 23:16, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Dec 01, 2020 at 11:12:32PM +0100, Ard Biesheuvel wrote:
> >
> > What do you mean by just one direction? Ben just confirmed a
>
> The TX direction generally executes in process context, which
> would benefit from an accelerated sync implementation.  The RX
> side on the other hand is always in softirq context.
>

Yes, and in both cases, irq_fpu_usable() will return true, unless RX
and TX are running on the same core.

> > substantial speedup for his use case, which requires the use of
> > software encryption even on hardware that could support doing it in
> > hardware, and that software encryption currently only supports the
> > synchronous interface.
>
> The problem is that the degradation would come at the worst time,
> when the system is loaded.  IOW when you get an interrupt during
> your TX path and get RX traffic that's when you'll take the fallback
> path.
>

I can see how in the general case, this is something you would prefer
to avoid. However, on SMP x86_64 systems that implement AES-NI (which
runs at ~1 cycle per byte), I don't see this as a real problem for
this driver.

What we could do is expose both versions, where the async version has
a slightly higher priority, so that all users that do support the
async interface will get it, and the wifi stack can use the sync
interface instead.
