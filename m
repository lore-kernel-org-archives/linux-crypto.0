Return-Path: <SRS0=NTKo=2I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75112C2D0BF
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 16:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49738218AC
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 16:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eFouNkPT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfLRQfu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Dec 2019 11:35:50 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40964 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfLRQfs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Dec 2019 11:35:48 -0500
Received: by mail-ed1-f67.google.com with SMTP id c26so2160150eds.8
        for <linux-crypto@vger.kernel.org>; Wed, 18 Dec 2019 08:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FMqMKRVCOcjZgE/EV3cPuX6L8AH27Rm+Sh8f62ETxcQ=;
        b=eFouNkPT+BVqLskLEk9g7X/YCueGVws1Y4L7OAdK67iYfuw5Q3JA28QRS8d/LWFrDG
         1PI0GaIys/kiZnyYwXJr83Bv5EsUHu3bADQCvrKc+yqTejvNWp7QIJtShLaEEWXU6HZS
         gtG2/bpkanXeXAJmHX5+l8j7bSOHLYl8HcMu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FMqMKRVCOcjZgE/EV3cPuX6L8AH27Rm+Sh8f62ETxcQ=;
        b=KVaWuvpU38rjnS3iOr2wVtvQrsNz3NLnWshDq0nBCXm3tGBLDka2Y3/iC6WrDty2wf
         VRnmh40j2b38q7gwn/XzENQ2jXsbFcWKJOnJRJSmsFgZnsoac2acPaU3YLny6+Mw3kwE
         gbn8psiqR0DacD8EIHa8GECvEnSONCp2g2Rhhi3b+NDcIvxKAhAml6O2WGC5y3Jx1k4Y
         qn75u6uaTSlCKIOIFxQTjZ4iUjyPN2M7Ud1BjncrSawC9B3jdj6aYfqxfg3bf8oeq5oK
         kE+0CxdJRGP769SAvCLbW0YExZwTgd5fQLVnytstHPo25nycMc7PZNrfVqavwRPlPD3B
         0ElQ==
X-Gm-Message-State: APjAAAUXpqKv5kkKJX0/PI5WJjyma7XRyxInbPS+e3ZKo/poNAucA5Wg
        jxKiGhz09rvBImJxC2GeUrzolb8MaEc=
X-Google-Smtp-Source: APXvYqymshP/pKeippfkwklt0k1e9FMGJoTKjDfIrzJdy7Mwwym6VYO5HedIRAVeB2LUldcsTrcSfA==
X-Received: by 2002:a17:906:a394:: with SMTP id k20mr3609354ejz.216.1576686945988;
        Wed, 18 Dec 2019 08:35:45 -0800 (PST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id m5sm49324ede.10.2019.12.18.08.35.43
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:35:44 -0800 (PST)
Received: by mail-wr1-f48.google.com with SMTP id w15so3008209wru.4
        for <linux-crypto@vger.kernel.org>; Wed, 18 Dec 2019 08:35:43 -0800 (PST)
X-Received: by 2002:a5d:51cc:: with SMTP id n12mr3908491wrv.177.1576686943371;
 Wed, 18 Dec 2019 08:35:43 -0800 (PST)
MIME-Version: 1.0
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191205000957.112719-2-thgarnie@chromium.org> <20191218124604.GE24886@zn.tnic>
In-Reply-To: <20191218124604.GE24886@zn.tnic>
From:   Thomas Garnier <thgarnie@chromium.org>
Date:   Wed, 18 Dec 2019 08:35:32 -0800
X-Gmail-Original-Message-ID: <CAJcbSZE56E_JqWpxvpHd194SAVn0fGJRiJWmLy=zfOyTthsGCg@mail.gmail.com>
Message-ID: <CAJcbSZE56E_JqWpxvpHd194SAVn0fGJRiJWmLy=zfOyTthsGCg@mail.gmail.com>
Subject: Re: [PATCH v10 01/11] x86/crypto: Adapt assembly for PIE support
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 18, 2019 at 4:46 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Dec 04, 2019 at 04:09:38PM -0800, Thomas Garnier wrote:
> > Change the assembly code to use only relative references of symbols for the
> > kernel to be PIE compatible.
> >
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
>
> FFS, how many times do we have to talk about this auto-sprinkled
> sentence?!
>
> https://lkml.kernel.org/r/20190805163202.GD18785@zn.tnic

In the last discussion, we mentioned Ingo (and other people) asked us
to include more information for context. I don't care about having it
or not, just want to ensure people understand why the change is made.

>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
