Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3663C4332E
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Jan 2021 03:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C592820936
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Jan 2021 03:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbhACD4m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 22:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbhACD4m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 22:56:42 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72B3C0613CF
        for <linux-crypto@vger.kernel.org>; Sat,  2 Jan 2021 19:56:01 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id z5so21966778iob.11
        for <linux-crypto@vger.kernel.org>; Sat, 02 Jan 2021 19:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=+3Fn6grRwKyQvko0qPAZ5KMuHHj/r6GkAi3Zdjcn39c=;
        b=vevUPZcWSkVymGhNAGU+FUWlJcBOgyt+lpo4wm6y4lzYN53lr32jexcwnVA4F6B6XK
         D/OC4LRZU0drDRETO/2Acv7ZTJEUWaiHOnaBTphAWIvdM99iGK8mHEpGLoMadoqJLa+f
         FstW0u7bKh963H9wqHDEKN437iq3ZLg8kK7k4ouhaX0j4EqYioiWu5KzQf2jUTcsouUZ
         weZ8OjD04pxEqPiAlJObjPF6lQl3FfUqnMJb5gEQ+cUGAu1tMp0/YN1LiWzRf2MCQQuz
         o4MYNmL+gl8GMMNyLKuP1erPk0vNxLs81jBHHs/VKFjFjp1DhxzJzmFEY9StSHaqHGI8
         tWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=+3Fn6grRwKyQvko0qPAZ5KMuHHj/r6GkAi3Zdjcn39c=;
        b=fsX37K5lHdNGWmgx13fGKOngEkCEE7zGRyx/02MxGGzz8b0hEItpKg5sg+sc5lxtmU
         rLlX9Vq8OY/9gYGeFB+klcAlYn23vax3lkmczptvyCjOnNMikmQR9bB4DROK8xkteXhh
         6wnw5Fzy/KcEEz0cHvuwyIRptMlqcQWYUXhuYgRj/JJV2xxQkrXNNs2uRoDrjoz1AA2c
         AkS3Of9BMJjmFzpwoWFl5DCQzu218v3tC1YVjNAcXRvKGYqbmZB7ejHbmpy4eO87Luqj
         y6/IFbOy83idIVYoH0D2coNx1r70lz1QzRO45goQhrg42F3aM31nP5Jj57bJxyt/AXvF
         oR+A==
X-Gm-Message-State: AOAM5334T+kFFY4tPVPIye6xIIU6vtXm59RM6s/I5pn37IOkxjhT6cTM
        ml97lS1sAeQP+rQdlh3mBcn69ma3m9iv85qsMUjPL4QFGD8=
X-Google-Smtp-Source: ABdhPJxokZ7GoFB9jiUWfeEbIPYRbtBFkxcx+slrJsp1QsEX8FmntBpRsMFR+GH3LkeRy+oskXV4lRBcZtsOkGgUfaw=
X-Received: by 2002:a05:6638:25d4:: with SMTP id u20mr58048590jat.54.1609646161080;
 Sat, 02 Jan 2021 19:56:01 -0800 (PST)
MIME-Version: 1.0
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Sat, 2 Jan 2021 22:55:35 -0500
Message-ID: <CAH8yC8knjfUR2S1NUhWWwBOovvCTWKQ1_MkowVSeRVPKfe-O4w@mail.gmail.com>
Subject: Loss of performance in RDRAND and RDSEED?
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Everyone,

I was performing some benchmarking today. On a Skylake Core-i5-6400
machine, and in the past (May 30, 2020), I would see these performance
numbers:

  RDRAND: 67 MB/s, ~38 cpb
  RDSEED: 24 MB/s, ~105 cpb

I ran the same benchmarks today (January 2 2020) and the benchmark
program reported:

  RDRAND: 7 MB/s, ~360 cpb
  RDSEED: 7 MB/s, ~360 cpb

I checked out the same code from the past (May 30, 2020) and the
numbers stayed the same:

  RDRAND: 7 MB/s, ~360 cpb
  RDSEED: 7 MB/s, ~360 cpb

SSE2, SSE4, AVX, AES-NI, SHA-NI, etc are OK.

The hardware is the same, but the OS was upgraded from Fedora 32 to
Fedora 33. The kernel and possibly intel-microcode have changed
between May 2020 and January 2021.

I'm aware of this problem with AMD's RDRAND and RDSEED, but it doesn't
affect Intel machines:
https://bugzilla.kernel.org/show_bug.cgi?id=85911 (so there should not
be any remediations in place).

My question is, is anyone aware of what may be responsible for the
performance loss?

Thanks in advance,

Jeff
