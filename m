Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826F4C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 14:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BFF561053
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 14:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhKBOYk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhKBOYh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 10:24:37 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BDAC0613F5
        for <linux-crypto@vger.kernel.org>; Tue,  2 Nov 2021 07:22:02 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id j5so2637387lja.9
        for <linux-crypto@vger.kernel.org>; Tue, 02 Nov 2021 07:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GDaXd54uUw4cuAEtFwh6e0QjRhac1tHiBl7h6VYXG/c=;
        b=QJn/USQbVp/0vR8XPnX2DMLOk3xYoQA/IM8xLrQIehB8YQx5EukbUbA/mJHcXBpby3
         XB3CU9KVNX2xorF1SURYNJchcROb84nHp/wT4k3RkvubbLHpcf5umpqh7oT/YGBrFg5o
         5bIGMLq+CBa1V7G1XxdUCu8mhgI45tMVNGe1/xU7swzROHApnGGzelcn63q4fPmgWgk3
         an6jWvsRGND6+sKSiZ5kcbhF8zSsbwYfbT9H+tEVWWATJ7EsoeVELfZM+/g0xmBQf0lP
         hMTu50wKJp1inyMNK9NUStV8uJdPfgikGifEmJ77hVT/rA/o6gK6IprmIib98NvDsNkN
         lZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GDaXd54uUw4cuAEtFwh6e0QjRhac1tHiBl7h6VYXG/c=;
        b=RqVLOkiHN98SMa8B3l8P1oUw8uPoni87oh4FAkPXxtAtKF37hx/Ng3MHWG64IDJ4dm
         DOtrxfq6jJ87Gp7s0dgu5Tr8mEbAlOVoQQ9qORv/3VnKpaJAgRGniyr8xamELwweYOS4
         te1/udRoYiLQc8LYogVfyCpUI/11R//wlHzwX0TsgKwOWFbJ2/Ue1cmhPT06mS9Kryww
         L7C01QgR4j0P8TWqxuPJo1fndJyDRjXgPIXRQyFSv0kCB/0heEvCjjIiSpbGqLmuj4jg
         11S5b+0eXlaa5a8Bpks+8pcV76h7Y8N68saCm5y/z+l6XnOMt9uPrhc8bP18JYd5pwwb
         oKDQ==
X-Gm-Message-State: AOAM530sxPJGDePjBGNiE8KeMU517oJLDAuI342NYIGyClcSQ3PQqjM7
        Maqn59vsr5hTaGD22YoRFR+Z3sy3dSlYLxh3c77+2Q==
X-Google-Smtp-Source: ABdhPJyf0eK9gsVbstxK6js4ihBySx4yiEGuDCPLxe50BGOWH3Y5s+lTtWl2LNOgFBO2Yteg9XCwseMfb1l8C1YqPzs=
X-Received: by 2002:a2e:161c:: with SMTP id w28mr38245243ljd.132.1635862920249;
 Tue, 02 Nov 2021 07:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211101172127.3060453-1-pgonda@google.com> <20211101172127.3060453-5-pgonda@google.com>
 <952fa937-d139-bd90-825c-f7dfca8d8cb9@amd.com> <CAMkAt6qdNWP-Ka1N=0d16Q1TrbHPXPEkdLoxC8ndsyid-dqA6Q@mail.gmail.com>
 <d6fc38fa-1caa-289a-ae92-102a96638560@amd.com>
In-Reply-To: <d6fc38fa-1caa-289a-ae92-102a96638560@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 2 Nov 2021 08:21:48 -0600
Message-ID: <CAMkAt6qBGckrBje6B0i5JTD5cK9ASViAZZrAPOcyzHmpVnmRdg@mail.gmail.com>
Subject: Re: [PATCH V2 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 1, 2021 at 2:02 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 11/1/21 2:18 PM, Peter Gonda wrote:
> > On Mon, Nov 1, 2021 at 12:41 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >> On 11/1/21 12:21 PM, Peter Gonda wrote:
>
> ...
>
> >>> +
> >>> +     fp = filp_open(init_ex_path, O_RDONLY, 0);
> >>> +     if (IS_ERR(fp)) {
> >>> +             const int ret = PTR_ERR(fp);
> >>
> >> I don't think you need the "const" here.
> >
> > Sounds good, removed. I normally default to consting a variable if I
> > don't expect/want it to change. What guidance should I be following
> > here?
>
> Heh, I don't know... I guess since its in such a short scope it just read
> easier to me.  But, you're correct, const is appropriate here, so I guess
> feel free to leave it in if you want.

Thanks! I'll remove it here to be more consistent with this file.

>
> >
> >>
>
> ...
>
> >> "SEV: write successful to NV file\n"
> >
> > Updated all messages. Should have noted the "SEV: .." format.
>
> It's not like we were very consistent originally, but it would be nice to
> have the new messages start to maintain a consistency.
>
> Thanks,
> Tom
>
> >
