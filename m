Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB21C05021
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 20:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjITUc5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjITUc5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 16:32:57 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8CBBB
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 13:32:50 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-501eec0a373so503855e87.3
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 13:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1695241969; x=1695846769; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5A++2mX03Hcr44T/e+yZZvTQBTnG7Z4Hfb7UlqgoOko=;
        b=YMjYRY95n4dtmUUyj4b3Onf3Qo3OH0YWYvz934nDlbdOXTzVRSnsp8Je9qouD0wLdX
         k2V4uWO2kjfUsDKybhFpTA5S9udQMCISYEzCi1eRUFBKWcEzNTZZ/ToIhshm9Osp4dOU
         b0LkCjGexgQULI75zpoXaIYC+1Bul3yJcC2qc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695241969; x=1695846769;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5A++2mX03Hcr44T/e+yZZvTQBTnG7Z4Hfb7UlqgoOko=;
        b=SRj21W8XNwdI8ciCcDI7E27y1NQAWxLBdxcP7m9JWuB4ZzUmhwm7EgTAm2zmFrtkJo
         u/EjhiKbeg9/t9RtM6FnNgUPttS3fLLEAvGhiK/iH0pbb91XxmiHQazslQC25Gfu6ODw
         C7etb6HmSrTtlnLQK3nGKAZfM7qGAySxQcumVgBtO01qKAJG4CLYcL8bzxWeC/9ULYYN
         WWwcRRZ8St9YlvRp7iiAnvfmK16Khiu6r5aSFA31ISHHGGw5ra6foIl/frFVF65zl6bt
         iXMxYngezlLksU8icx5uWvta/id40deYiKy8k6CfbYrl8KT/kFAiw/siaqsnuYF1BBJ1
         5wVQ==
X-Gm-Message-State: AOJu0YyQ1NxXbjI2QWKTb5i/Eq9lgHIRc5wEKRtl8aWVjoT3jSYtUx+H
        sBEwMfJdbkbQNvhPIFvU6mJRRO0ZJ6L2ldLPa1J8/136
X-Google-Smtp-Source: AGHT+IEmIWkdOSmTWrPihDF26X3q7EdwZ+ieVKVBmmE/nrTJOnuFe9XBQ7EziQ1f1wu8KF0vZTAIxw==
X-Received: by 2002:a19:4347:0:b0:502:a55b:c2d7 with SMTP id m7-20020a194347000000b00502a55bc2d7mr2396210lfj.60.1695241968730;
        Wed, 20 Sep 2023 13:32:48 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id n1-20020a056512388100b00502af40d9efsm2815027lft.261.2023.09.20.13.32.47
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 13:32:47 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-502a4f33440so518858e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 13:32:47 -0700 (PDT)
X-Received: by 2002:a05:6512:39ca:b0:503:7c0:ae96 with SMTP id
 k10-20020a05651239ca00b0050307c0ae96mr4520271lfu.20.1695241967063; Wed, 20
 Sep 2023 13:32:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230920060615.GA2739@sol.localdomain> <CAHk-=wja26UmHQCu48n_HN5t5w3fa6ocm5d_VrJe6-RhCU_x9A@mail.gmail.com>
 <20230920193203.GA914@sol.localdomain> <CAHk-=wicaC9BhbgufM_Ym6bkjrRcB7ZXSK00fYEmiAcFmwN3Kg@mail.gmail.com>
 <20230920202126.GC914@sol.localdomain>
In-Reply-To: <20230920202126.GC914@sol.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 20 Sep 2023 13:32:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgu4a=ckih8+JgfwYPZcp-uvc1Nh2LTGBSzSVKMYRk+-w@mail.gmail.com>
Message-ID: <CAHk-=wgu4a=ckih8+JgfwYPZcp-uvc1Nh2LTGBSzSVKMYRk+-w@mail.gmail.com>
Subject: Re: [RFC] Should writes to /dev/urandom immediately affect reads?
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Sept 2023 at 13:21, Eric Biggers <ebiggers@kernel.org> wrote:
>
> It seems that what you're claiming (in addition to the RNG always being
> initialized quickly on platforms that are "relevant", whatever that means) is
> that once the RNG is "initialized", there's no need to reseed it anymore.

No. You are literally putting words in my mouth that I at no point
even implied. You're making up an argument.

I *LITERALLY* am asking a very simple question: WHO DO YOU EVEN CARE
ABOUT THIS "IMMEDIATE" EFFECT.

Give me a real reason. Give me *any* reason.

Don't try to turn this into some other discussion. I'm asking WHY DOES
ANY OF THIS MATTER?

The immediacy has changed several times, as you yourself lined up. And
as far as I can tell, none of this matter in the least.

> The question is, given that, shouldn't the RNG also reseed right
> away when userspace explicitly adds something to it

I don't see that there is any "given" at all.

We do re-seed regularly. I'm not arguing against that.

I'm literally arguing against applying random changes without giving
any actual reason for them.

Which is why I'm asking "why do you care"? Give em a *reason*. Why
would a user space write matter at all?

It was why I also asked about entropy. Because *if* you argue that the
user-space write contains entropy, then that would be a reason.

You didn't.

You argue that the current behavior hasn't been the universal behavior. I agree.

But considering that we've switched behaviors apparently at least
three times, and at no point did it make any difference, my argument
is really that without a *REASON*, why would we switch behavior *four*
times?

Is it just "four changes is better than three"?

             Linus
