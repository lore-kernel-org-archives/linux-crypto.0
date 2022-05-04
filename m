Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949FAC433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  4 May 2022 20:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356198AbiEDUOB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 May 2022 16:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345790AbiEDUOA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 May 2022 16:14:00 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9F12737
        for <linux-crypto@vger.kernel.org>; Wed,  4 May 2022 13:10:23 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id v4so3061637ljd.10
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 13:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O0/hKmkvb5BoU0+UFK3i+vBfCGj7h/+eV5+6M1+ExZM=;
        b=OzBXWUbjQ+080MWC14jdCnBvwXL5uDnkzacs7MfgTd/OEo/P0xDEmgLRYvFfLeTaQx
         JCb2df+pPiKnY5JtAeaEC8UDsr9bOvUNWpODCHqcjIQi993kY6I7kPmVvju01wuAsTcG
         +NgW70KB4OMXFfc8QJi6r5l0fzPSUGCZdartU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O0/hKmkvb5BoU0+UFK3i+vBfCGj7h/+eV5+6M1+ExZM=;
        b=wwYEd2Qf9qb1Zv3o9W2Y6LShZXm0FAWx62NyVJLD2ugIwiS4MrpOg0lFqQRFizy6se
         Tn1wa1vgtjCV3UMwuqJjD+4QOJL5QftnJniy8i0sdyWsInj9K6IwjgfzAKiK9th0utbz
         674c7hGa2deB+GZIrOGM0kVrYqbeUd3DDENXnlccxyhx4quxar9SoTuzaM8iaL+G0+aq
         lP5cHJwycbb1Dgk7QSWVvY2xmjT8WEzmVBFrIWeBIlvQ5hjlQhC8X8uOxFKZcCjFlrBe
         E0uHaeQaB0lS3ilB3vjhDOlZ1C5JN1aF5QLLAsMDzZdG4V9nts/K8tL5lWeRjXQOwQlR
         8Nng==
X-Gm-Message-State: AOAM532uyM3vLQlo1R1mgsSJujJez16M3KmD/YFKTL47HUd31CeS0sOP
        kllLJu/bra66zAe18PHISgzUzu5vPWBjMpNrWUc=
X-Google-Smtp-Source: ABdhPJzn4H7u8QzffLRzSHT/wElXtmYk9OmuBkHK1XPKwvmQ4WklX7inKFlHw9djpDyMmXhLMWxAXA==
X-Received: by 2002:a2e:b8c2:0:b0:250:61c6:8398 with SMTP id s2-20020a2eb8c2000000b0025061c68398mr7162728ljp.378.1651695021410;
        Wed, 04 May 2022 13:10:21 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id k8-20020a2eb748000000b0024f3d1dae91sm1762995ljo.25.2022.05.04.13.10.20
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 13:10:20 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id s27so3088899ljd.2
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 13:10:20 -0700 (PDT)
X-Received: by 2002:a2e:914d:0:b0:24f:6374:3eba with SMTP id
 q13-20020a2e914d000000b0024f63743ebamr10017408ljg.506.1651695019712; Wed, 04
 May 2022 13:10:19 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com> <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com> <CAAfxs77yaLvWx9KnkDZX7E1eDm9N-NVJn5n8=mCK9BU-cSob=A@mail.gmail.com>
In-Reply-To: <CAAfxs77yaLvWx9KnkDZX7E1eDm9N-NVJn5n8=mCK9BU-cSob=A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 4 May 2022 13:10:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjLRo-6PbhbvMUDojbMo=L+2jc5VpCYTyF-LGxZPhUngA@mail.gmail.com>
Message-ID: <CAHk-=wjLRo-6PbhbvMUDojbMo=L+2jc5VpCYTyF-LGxZPhUngA@mail.gmail.com>
Subject: Re: [PATCH v2] hex2bin: make the function hex_to_bin constant-time
To:     Stafford Horne <shorne@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Andy Shevchenko <andy@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Snitzer <msnitzer@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 4, 2022 at 12:58 PM Stafford Horne <shorne@gmail.com> wrote:
>
> I have uploaded a diff I created here:
>   https://gist.github.com/54334556f2907104cd12374872a0597c
>
> It shows the same output.

In hex_to_bin itself it seems to only be a difference due to some
register allocation (r19 and r3 switched around).

But then it gets inlined into hex2bin and there changes there seem to
be about instruction and basic block scheduling, so it's a lot harder
to see what's going on.

And a lot of constant changes, which honestly look just like code code
moved around by 16 bytes and offsets changed due to that.

So I doubt it's hex_to_bin() that is causing problems, I think it's
purely code movement. Which explains why adding a nop or a fake printk
fixes things.

Some alignment assumption that got broken?

               Linus
