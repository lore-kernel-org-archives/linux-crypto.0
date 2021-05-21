Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1C7C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 07:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F8C76135B
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 07:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbhEUHbs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 03:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235903AbhEUHbr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 03:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0635C6135B
        for <linux-crypto@vger.kernel.org>; Fri, 21 May 2021 07:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621582224;
        bh=Vxjwouvxq6rNGxtkLbiMYG0YM6Ycre5uYgRy02M203U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=D9+pqZ1WMLZOd90zipYJrvlRfQTW9z4zTZUPz7Oypgb2bhSQoxjKa+7UhyZp97ovU
         ddx48nfaWMedo2jDqPw9AVzwkjnoH4mzrkJYmPzWViqj7Oj9hsMWt0KN10i77qF1y7
         MGiW6XgJS+j19PcvHiLP8BJbSVlynnOaIat5S38VXtEf3YxBhXKOlKnKb3VzdBpaaz
         Ov7J5Bz2uDZvl9l4MpoGGTjH1aBVt36nmRtutRLNjDgHZWw912aS/VZvOJLHRGP03D
         +MPm2WGny4tB6XPo2Q1QXvGjxea7HIpGO4V6HeDTVFm91IiTgsN08BXVEwIGh7beSR
         XlgG1bkgX8Ezw==
Received: by mail-oo1-f49.google.com with SMTP id e27-20020a056820061bb029020da48eed5cso4369809oow.10
        for <linux-crypto@vger.kernel.org>; Fri, 21 May 2021 00:30:23 -0700 (PDT)
X-Gm-Message-State: AOAM530W8GjMA3K39G65z8dkdkpFo2YydoROOVvTuMZRkMfpy426sKLQ
        0opzEdaAzfEci0J/li3MNtWzwcaKOld+UGp7QOA=
X-Google-Smtp-Source: ABdhPJyi3fiAwL0EZ9NHi/V28W/Z2K5AtcelTQyT/dDuMlM9dkM5xjRgnajalpRR+L1yjgYwzdRBFN6Z396b1FG8Ak4=
X-Received: by 2002:a4a:300b:: with SMTP id q11mr4591366oof.45.1621582223455;
 Fri, 21 May 2021 00:30:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210519112239.33664-1-ardb@kernel.org> <20210519112239.33664-3-ardb@kernel.org>
 <20210519112930.sgy3trqczyfok7mn@gondor.apana.org.au> <CAMj1kXGsxFzx8XTwhBRma_eSmnAHDZHox9X+SYDn0JYfPBVbYg@mail.gmail.com>
 <20210519115146.bmrlfrchmz5tt2e2@gondor.apana.org.au>
In-Reply-To: <20210519115146.bmrlfrchmz5tt2e2@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 21 May 2021 09:30:11 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF9jGE+OuQfQqQrmd36j3ipduVOu7ciOg51PSZpfs6jxQ@mail.gmail.com>
Message-ID: <CAMj1kXF9jGE+OuQfQqQrmd36j3ipduVOu7ciOg51PSZpfs6jxQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] crypto: aead - disallow en/decrypt for non-task or
 non-softirq context
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 19 May 2021 at 13:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, May 19, 2021 at 01:36:37PM +0200, Ard Biesheuvel wrote:
> >
> > So if we do need to check this, we should check it here. If we don't,
> > then we can drop these patches.
>
> Historically other things would break in nasty ways if you tried
> to do crypto in hard IRQ contexts, e.g., overwritten kmap slots
> back when we had individual slots for each context, but I don't
> think we've ever found anyone crazy enough to do that to warrant
> a run-time check.
>
> I'd just leave it out for now.
>

Fair enough. Would you like me to resend the series with these patches
left out Or are you ok to just take the remaining ones (assuming there
are no issues reported with those)?
