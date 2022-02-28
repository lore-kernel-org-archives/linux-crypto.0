Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05BCC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 19:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiB1T0z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiB1T0y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 14:26:54 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339B9114FEA
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:26:09 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id t14so18805573ljh.8
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k5Nq2+gFOwIAZZv1z8A5AiR5tZQQa62jzNlsasSMp48=;
        b=hA07tqoOhzsc3WOqNCaR4tUruW+rdsfqY8YOw2mN7ILGOov8LZJfGyOH0+67N/0EaR
         4t/JTBCib0ytZP3PxoAumfh81bQl7oYkHnLaS7IusFI7m+FXPGCuZ+b2epjKsi5SuwbN
         6G/m+gkEWqvwTgFEdCkiL46LSGGVnwGjPchjI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k5Nq2+gFOwIAZZv1z8A5AiR5tZQQa62jzNlsasSMp48=;
        b=fhpbtvL7wHqkfJsOTOuPSH3UL5nA+C8F+TphUJRlxT0i8pgLdU24B3fLUFWUTq1D06
         7FCkgXxpHFDyb5dNUcQF2YAaEImhn8yz3ab+1TYY20VSXs/6XuGvtugmuCN085ntf625
         UM49x+C7bdstWeW3RFFufUFn1JiKYxRDPkCG7KgI3Tc86kbxiXixIOfofWZaxHK4j7d2
         kldGmhToENj6gAtWECXdXtyFIZaaRNc4GixN59Ea4N2pLqEOOvmKNLI6+UQhshTHuO1i
         7ESRvVmx3THZYjbct3oeo6bCEc3AYBwy7vRZLvSMH5nqOrEzawQX4m9Khmq0YvI7Y0jv
         U+Cw==
X-Gm-Message-State: AOAM5322i5RAUAzgR18Ipmhlr5s2wEaEgm5gX+ABgUHtYVKbpPG5PS+K
        4ZX8JvhyI0osrOgJAOW7LVDUpun46GtBOznfo8c=
X-Google-Smtp-Source: ABdhPJyx7ldHO6wPwVqCukEXkHyqjErsapicYT74I+Sb5+3fVf7Yg/FOq9MOdEU8Kcg39UMnim13mw==
X-Received: by 2002:a2e:9048:0:b0:246:1988:3105 with SMTP id n8-20020a2e9048000000b0024619883105mr15304905ljg.404.1646076367160;
        Mon, 28 Feb 2022 11:26:07 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id o25-20020a2e7319000000b002461a53f353sm1482391ljc.111.2022.02.28.11.26.05
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 11:26:05 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id bu29so23251946lfb.0
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:26:05 -0800 (PST)
X-Received: by 2002:a05:6512:3042:b0:437:96f5:e68a with SMTP id
 b2-20020a056512304200b0043796f5e68amr14128474lfb.449.1646076365434; Mon, 28
 Feb 2022 11:26:05 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
 <20220219210354.GF59715@dread.disaster.area> <CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
 <YhN76/ONC9qgIKQc@silpixa00400314> <CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
In-Reply-To: <CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 28 Feb 2022 11:25:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
Message-ID: <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
Subject: Re: Intel QAT on A2SDi-8C-HLN4F causes massive data corruption with
 dm-crypt + xfs
To:     Kyle Sanderson <kyle.leet@gmail.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dave Chinner <david@fromorbit.com>, qat-linux@intel.com,
        Linux-Kernal <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 28, 2022 at 12:18 AM Kyle Sanderson <kyle.leet@gmail.com> wrote:
>
> Makes sense - this kernel driver has been destroying users for many
> years. I'm disappointed that this critical bricking failure isn't
> searchable for others.

It does sound like we should just disable that driver entirely until
it is fixed.

Or at least the configuration that can cause problems, if there is
some particular sub-case. Although from a cursory glance and the
noises made in this thread, it looks like it's all of the 'qat_aeads'
cases (since that uses qat_alg_aead_enc() which can return -EAGAIN),
which effectively means that all of the QAT stuff.

So presumably CRYPTO_DEV_QAT should just be marked as

        depends on BROKEN || COMPILE_TEST

or similar?

              Linus
