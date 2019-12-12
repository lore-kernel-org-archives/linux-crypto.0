Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D7DC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 15:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D4CE214D8
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 15:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gVYdVOKd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbfLLPfS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 10:35:18 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:58369 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729467AbfLLPfS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 10:35:18 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 94dc94eb
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 14:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=zLTv40VoGYFkQaUW7aW/IfcqO8Q=; b=gVYdVO
        KdCSTbQnb5LgWbEh0q2/riiWvYI0XJ7BjejR3FvL5D3VuclpJpWOta0HVEDHLKdG
        IaU5Guk79+EqG6xuGKuQcuOY+KX4ck8oUYReOlbvAJEkLcHv2zHWU19uupF3rC5v
        /EqCCBG/UBsHLwrEulnW1ABWMeVG/051jRmzHQTaXkDcc6olSE/OULdgW9XQqHf5
        IiOjTaejhT9EXhmM3hWQmUWlP0CZAGdkwPzkJzOShZKROrKtl/FpUMAt8wgqdpeP
        y8QEGwkMvEz2phB86KyI16O3M/LS2MpaCE/+HI/TEyI9VTGSI692zcDRcsem4t9w
        NRPABgeLar2DJhew==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5fc12e04 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 14:39:28 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id a124so722526oii.13
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 07:35:16 -0800 (PST)
X-Gm-Message-State: APjAAAUD4pA8NHXUIu8Dr+f01pLd2AOzjkOipPtOgEqIPDIMdqwDOcxa
        8tPyNf2MalzXG5id2GhpScngXICCKgBsrRPQ0j4=
X-Google-Smtp-Source: APXvYqzsD8V8qJH42/QreQik2+aTxvvMVPhkMnGLVJ7wuaKixu+cdMSks506DKl/ZFzjJDfjZ1h7nQlOCUXE1MFDm/M=
X-Received: by 2002:aca:5143:: with SMTP id f64mr5146134oib.66.1576164915842;
 Thu, 12 Dec 2019 07:35:15 -0800 (PST)
MIME-Version: 1.0
References: <20191211170936.385572-1-Jason@zx2c4.com> <20191212093008.217086-1-Jason@zx2c4.com>
 <d55e0390c7187b09f820e123b05df1e5e680df0b.camel@strongswan.org>
 <CAHmME9ovvwX3Or1ctRH8U5PjpNNMe9ixOZLi3F0vbO9SqA04Ow@mail.gmail.com>
 <CAHmME9reEXXSmQr+6vPM1cwr+pjvwPwJ5n3UZ0BUSjO2kQQcNg@mail.gmail.com>
 <CAKv+Gu80EVN-_aHPSYUu=0TvFJERBMKFvQS-gce3z_jx=X7www@mail.gmail.com>
 <CAHmME9oQ-Yj2WWuvNj1KNm=d4+PgnVFOusnh8HG0=yYWdi2UXQ@mail.gmail.com> <7d30f7c912a5565b1c26729b438c1a95286fcf56.camel@strongswan.org>
In-Reply-To: <7d30f7c912a5565b1c26729b438c1a95286fcf56.camel@strongswan.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 16:35:04 +0100
X-Gmail-Original-Message-ID: <CAHmME9rP_AAH6=R7ZRPnu3UPTvZ+c32-XYOr2jstSyQvCaQhnA@mail.gmail.com>
Message-ID: <CAHmME9rP_AAH6=R7ZRPnu3UPTvZ+c32-XYOr2jstSyQvCaQhnA@mail.gmail.com>
Subject: Re: [PATCH crypto-next v2 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
To:     Martin Willi <martin@strongswan.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 12, 2019 at 4:30 PM Martin Willi <martin@strongswan.org> wrote:
> > The principle advantage of this patchset is the 64x64 code
>
> If there are platforms / code paths where this code matters, all fine.

It does matter.

>
> But the 64-bit version adds a lot of complexity because of the
> different state representation and the conversion between these states.
> I just don't think the gain (?) justifies that added complexity.

No, there's no conversion between the state representation, or any
complexity like that added.

I think if anything, the way this patch works, we wind up with
something easier to audit and look at. You can examine
poly1305-donna32.c and poly1305-donna64.c side-by-side and compare
line-by-line, as clean and isolate implementations. And this is very
well-known code too.
