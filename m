Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58133C47082
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 15:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E05561185
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 15:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhFEPe7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Jun 2021 11:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhFEPe7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Jun 2021 11:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50F0561185
        for <linux-crypto@vger.kernel.org>; Sat,  5 Jun 2021 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622907191;
        bh=xaucdI7pVO9lMCy5zn4XOS8h//oGcDSXo3V+CdfJh44=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SDPzw7aulFgyzqSk1pk4zrBrE3y/bt/KH9DBbiIYBpUdpXiRy6qgCUIG7aiWW/A1J
         6O274hm8REDQyMuuiO8HwoV0akfB78Kw7EbBelRDV1ltQylAXE/XSQnGq9ZzfwY6O2
         esgpYEvLuTST1iznCC2KAkq/m4wzAbF9boZOgIycn7P3qppb/olS1j8aMyaSqTLaiT
         eRvT6AbtstXddS7XKoKktybAlr+0cPz1O9/vMIzwL2HybLpvhgwUv0ek6YsOnKIcsl
         OPptVgizd7Ik+369a5Qk9/5RQ5BUHcaBYwP/5a9R9yrciQQd687eXjnhFzfHu+T+1R
         K6nbEKe7gPAdA==
Received: by mail-ot1-f46.google.com with SMTP id t10-20020a05683022eab0290304ed8bc759so12091195otc.12
        for <linux-crypto@vger.kernel.org>; Sat, 05 Jun 2021 08:33:11 -0700 (PDT)
X-Gm-Message-State: AOAM533lGN/Fx+6kiqZNR7hD40oXc5mE5B5CgDtvURoBK/8PHDysPXBO
        BHIcs91SPrkp7e8r45bfUW7kWVXydUVyocqD2gk=
X-Google-Smtp-Source: ABdhPJzX49H8Dj5qlZrxI1sI1EWwAlW0zNS1vHEdecwetvOeEpW9NHjDYlpYXh+oJM4ybruLgxO/4vWDqPMQKtT27kc=
X-Received: by 2002:a9d:6d0e:: with SMTP id o14mr1356951otp.90.1622907190620;
 Sat, 05 Jun 2021 08:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <bc3c139f-4c0c-a9b7-ae00-59c2f8292ef8@linaro.org>
In-Reply-To: <bc3c139f-4c0c-a9b7-ae00-59c2f8292ef8@linaro.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 5 Jun 2021 17:32:59 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGRb=_tozRAMA+ZFbAHU4P7ocLbWq+B3s0ngoRoo82V6g@mail.gmail.com>
Message-ID: <CAMj1kXGRb=_tozRAMA+ZFbAHU4P7ocLbWq+B3s0ngoRoo82V6g@mail.gmail.com>
Subject: Re: Qualcomm Crypto Engine performance numbers on mainline kernel
To:     Thara Gopinath <thara.gopinath@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Thara,

On Fri, 4 Jun 2021 at 18:49, Thara Gopinath <thara.gopinath@linaro.org> wrote:
>
>
> Hi All,
>
> Below are the performance numbers from running "crypsetup benchmark" on
> CE algorithms in the mainline kernel. All numbers are in MiB/s. The
> platform used is RB3 for sdm845 and MTPs for rest of them.
>
>
>                         SDM845    SM8150     SM8250     SM8350
> AES-CBC (128)
> Encrypt / Decrypt       114/106  36/48       120/188    133/197
>
> AES-XTS (256)
> Encrypt / Decrypt       100/102  49/48       186/187    n/a
>

The CPU instruction based ones are apparently an order of magnitude
faster, and are synchronous so their latency should be lower.

So, as Eric already pointed out IIRC, there doesn't seem to be much
value in enabling this IP in Linux - it should not be the default
choice/highest priority, and it is not obvious to me whether/when you
would prefer this implementation over the CPU based one. Do you have
any idea how many queues it has, or how much data it can process in
parallel? Are there other features that stand out?
