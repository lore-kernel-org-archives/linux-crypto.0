Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81150C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 19 May 2022 06:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbiESGLT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 May 2022 02:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbiESGLT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 May 2022 02:11:19 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A1433351
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2022 23:11:13 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id c12so5662877eds.10
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2022 23:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=gYhBmt2DJjuovlj8cEVjJWatfYnYEnvKQvTR5wcx1jM=;
        b=YFceBQS8mdD5J7xJrp0GhLhnihLf4RzLsf1jFD7Mix84dFO2uMABu/ljD2xqQ4Zi4H
         EY372DX7GhDHFXFteZXj/A28uVAmCY2NcPWw7CDSV75+bT8YgP9I/bNjv6VoKA55nm6I
         sCt8/C5g4GPhhiJkRjKkGyVkhopif+1Cbndc40zakzt8IahxRl+1cJHMwxnGnLgYb1Ih
         xk+2OO9gcp17MDpJN2Zy98Y9GJD1nvSMGr3uVrJx9tzklkmAeA4FPdMHz2Yp3sWMYqiv
         NY6ED63DQvxIGJarL0SaPFlgfCPH8AqGQQCh/K5ZNGA2yB73j+tTzYRGY14sgGKYf5JW
         m9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=gYhBmt2DJjuovlj8cEVjJWatfYnYEnvKQvTR5wcx1jM=;
        b=QJugtN51BdtMdVlkYhyw7SWu9arO8ZEyWncGTQC892AOpDE0bEP5pgxy5jAD8mnwI2
         8OfebNTM7d9o6Eo3x/MTK4QKQQ4Y+uUu1uYVYT/SvjWyWHv5pbAniSJyb++A8Fb28orP
         JMZ8//iin76Fb9IVb+Wv7CBejYq48xfugRAv7wKXBBOGbkkNfu8WBvfRaAUH654dOQAN
         xUnytSeYkPV1RNOkwsbVMd7um6xcDrC1ViGLY143oC0PokjF6u9t5dBf6QCO+yrnE/b0
         ymcKVtw5c6fkYuxFjw/4lMK67CgrCAdF2JX/D6UsWy2zjf9dT6yHqnI3Fo7Y33KkXJRZ
         ahJw==
X-Gm-Message-State: AOAM530/o/E/FA6aQvPBzAvwckZ6bt9qcAmYZXmlNhMS+Kxsmmwtoyqo
        ik5GPXYR4VsOGBzbvYJDOV0/0KUH+tID0OR0BbHas47n
X-Google-Smtp-Source: ABdhPJx+uwCciM0/DTmqHsJ+92m0GgQNzVIeRBmzC9iP8j5ZBQuJ310amaYX5jrav8mcRNi1Id0mm3LZWkS6dGWy6CI=
X-Received: by 2002:a05:6402:17c1:b0:428:8016:d98d with SMTP id
 s1-20020a05640217c100b004288016d98dmr3602582edy.5.1652940672175; Wed, 18 May
 2022 23:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <CACXcFm=y9dR5DONeoLq1OQZp7fiFTEYTn_ir=c4S=UfyxTGWpQ@mail.gmail.com>
In-Reply-To: <CACXcFm=y9dR5DONeoLq1OQZp7fiFTEYTn_ir=c4S=UfyxTGWpQ@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 19 May 2022 14:10:59 +0800
Message-ID: <CACXcFmn2wKVf7eh-qYsgp3x-acrf0=c8ur-UARcht5Dd3=epYg@mail.gmail.com>
Subject: Re: [RFC] random: use blake2b instead of blake2s?
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sandy Harris <sandyinchina@gmail.com> wrote:

> The original random.c used a 4k-bit input pool, ...

> Blake comes in two variants, blake2s and blake2b; ...
>
> To me, it looks like switching to 2b would be an obvious improvement,
> though not at all urgent.

I'd actually go a bit further and have 2k bits of input pool,
two blake2b contexts; probably make inputs alternate
between them. It would also be possible to put each
input into both pools.

For output, have a flip-flop variable and alternate between
the pools with some sequence like:
: mix some extra entropy into pool
: generate 512 bits output
: mix that back into the other 2b context
: 8-round chacha on output
: mix output into chacha context

Mixing output from one context into the other ties the
two together so in effect we have a 2k-bit input pool.

Chacha is designed to be non-invertible so the
8-round instance prevents a rather unlikely
attack. Even if an enemy manages to get the
chacha state & infer some of the rekeying inputs,
they do not get direct access to blake output.
They would need to repeatedly break chacha8
to get any data that might let them attack blake.
