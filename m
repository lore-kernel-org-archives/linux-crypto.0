Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A246ECAAD8
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 14:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiIPOZq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 10:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiIPOZX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 10:25:23 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEC89FAAB
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 07:25:18 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id a3so23841764lfk.9
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 07:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KDdbJY+6Lwuy0ZMU2F8sRoi82Pbj6XOA2IBLb/eM6QI=;
        b=KXcEsEm30D38YxlIGLkoYYPnodQAmfcqk8DkXGK46gKBXp/A2XcbeDg0gTIbWt6pM8
         j12ShDHRzqATdHQQxaSUZWHeWpKdhBKB5nRSvtm45ITz4MiJJxIidPT9iitoRhhy30Zw
         +KRC78zutPHNQxYvCSSpiPwahuY1ljCPJjbW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KDdbJY+6Lwuy0ZMU2F8sRoi82Pbj6XOA2IBLb/eM6QI=;
        b=KqenCVO+XkJ65ARSllEIVQ6Z3sFvQdE++XiaN9S6GGMw+AGhiwvtBLENhiD2A3nlz4
         RnlTmQ+Zq3QO8dUYrpm8XdBOAqHo7WwXPqSc5yNmhF+3LcSMOxNePfcp60t2y6wSq8vq
         f7omGKH2zKo/18pVEtjvQKetMDgYwk9AcxFog7Nrjp0GwgRDVsjHE1bGJzunlPD8/BTe
         34S9EtPkqNOyaMLA+MwGqA8/cAuT15mIvW3sPOAmgwQjh2SSu1YtCIzpW2jWRbphsWUO
         SyNiajKAsFovyZz8PCXGqAylqt6cdH7IN9NswWa8GTXFrzz423ugwSch0+ibB9Zhv21+
         JDCg==
X-Gm-Message-State: ACrzQf0bKWGP1j6WB38HVs1qA9mwl17YBAxgyEmna6kpKUQ8TSvPZX2m
        JAQL0YqYbcKXG9YEHrsWpKf2XKwLXQnU36OS
X-Google-Smtp-Source: AMsMyM6WH9QwFWpQojDNMzQKoW0yPU2qOrprrzLeWysqLm7VJ9eRlSf5geKaSnfV/aNdukG/01UQfg==
X-Received: by 2002:a05:6512:10d6:b0:49a:1fc0:cc62 with SMTP id k22-20020a05651210d600b0049a1fc0cc62mr1886108lfg.138.1663338316593;
        Fri, 16 Sep 2022 07:25:16 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id b13-20020a056512070d00b0049464d89e40sm3506423lfs.72.2022.09.16.07.25.11
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 07:25:13 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id bn9so26165931ljb.6
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 07:25:11 -0700 (PDT)
X-Received: by 2002:a2e:a602:0:b0:264:5132:f59 with SMTP id
 v2-20020a2ea602000000b0026451320f59mr1620436ljp.0.1663338310469; Fri, 16 Sep
 2022 07:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220915002235.v2.1.I7c0a79e9b3c52584f5b637fde5f1d6f807605806@changeid>
 <YyNIOg1mtnzQz1H7@zx2c4.com> <CAG-rBijUSQ-kA0-pS=JCVX9ydeaSCd9Ub=yryGk4zsbcv3dTzQ@mail.gmail.com>
 <YyQWPcxG1Xc1qRWE@owl.dominikbrodowski.net>
In-Reply-To: <YyQWPcxG1Xc1qRWE@owl.dominikbrodowski.net>
From:   Sven van Ashbrook <svenva@chromium.org>
Date:   Fri, 16 Sep 2022 10:24:58 -0400
X-Gmail-Original-Message-ID: <CAM7w-FV8Vn_jUz1ExA5HHVz66sDzYw4vZw9EoxCHuGh_Fm3YiQ@mail.gmail.com>
Message-ID: <CAM7w-FV8Vn_jUz1ExA5HHVz66sDzYw4vZw9EoxCHuGh_Fm3YiQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] random: move add_hwgenerator_randomness()'s wait
 outside function
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Olivia Mackall <olivia@selenic.com>,
        Alex Levin <levinale@google.com>,
        Andrey Pronin <apronin@google.com>,
        Stephen Boyd <swboyd@google.com>,
        Rajat Jain <rajatja@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Petr Mladek <pmladek@suse.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dominik,

On Fri, Sep 16, 2022 at 2:24 AM Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
>
> Indeed, our patches address different issues. I'm fine with both approaches,
> i.e. my patches to be based on Sven's, or the other way round.

Sounds good! May I suggest then that you try to rebase your patch on top of
mine. With a bit of luck, it will become simpler, with fewer kthread related
footguns. I am available to help review.

If your patch becomes more complicated however, we'll work the other way
around.

How does that sound?
Sven
