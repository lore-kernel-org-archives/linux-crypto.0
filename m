Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA291C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 20:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiCVUoM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 16:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiCVUoM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 16:44:12 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9BB7523E
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 13:42:43 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id k21so15282085lfe.4
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 13:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2U9MBMr+1/uM/VxRs4MdeE4RwpAAvsI7P/hOZkh3NDc=;
        b=fCNY/BolP7QFEI2E0i5Od5B6ze3g0v6AZHkuuWB94UFzHknCYmVASkXg7Wz6WggffZ
         BpK/5sPNmAEPzbEW1Cpwu/1yzLvFavPbUVek4kcWFUhsYkm1IKbXTuaX4Qzi0d6kluSP
         Jy1h/b/dTzXEPW2O2PiifN8B5S4BdpypKJPl8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2U9MBMr+1/uM/VxRs4MdeE4RwpAAvsI7P/hOZkh3NDc=;
        b=F0uMNzETJoNn+6F0yNirJE4wQO1xO/BT1dYCKivUxeVS/9OYmOaOdjPcsbiVaKozJE
         YlLL8qa0vP995Nfvq5yDEtWrTw7J6IP9RAoj9y6yBVcNiaOI+Xg+hSKJWHAa0oR89QK2
         iFH2+y/o0SNplqmL6fvSzC796SVDPnFebOzuWKqYhtVC6HAd1chitKrYxB/PcZB/xbIk
         AnDNZo7RT6DASuNND13Fy1gtkyVp9LQ2KMnFtQPSmJvEoHNm1T4wSA82rpibEMGz8tSr
         n3Nk+1OeQBROBu+oFiQxHQPm0cNEgWFlFJUI4uasjhuEJ2cxXysHuqOa8Xwga46EiwDS
         QiXg==
X-Gm-Message-State: AOAM532cdTn04vAKg/DD1uXGWElzWMtpD2SL0zc03lDGNdQhqZyhMcWX
        0M9ipBE+npE/jBNUYmhwijBUKgasySgBzvrSKcA=
X-Google-Smtp-Source: ABdhPJwchPX90o1M45eWYCII8EZZ38hnzHVZIlTvLfWHLQuU/VoAgGN9QOC6SmVIAdPo6prXlcuiBg==
X-Received: by 2002:ac2:4e71:0:b0:448:2f38:72ac with SMTP id y17-20020ac24e71000000b004482f3872acmr19554791lfs.594.1647981761345;
        Tue, 22 Mar 2022 13:42:41 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id 206-20020a2e09d7000000b00247eb27d491sm2450932ljj.103.2022.03.22.13.42.40
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 13:42:40 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 5so13621208lfp.1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 13:42:40 -0700 (PDT)
X-Received: by 2002:ac2:4203:0:b0:448:8053:d402 with SMTP id
 y3-20020ac24203000000b004488053d402mr19150741lfh.687.1647981759939; Tue, 22
 Mar 2022 13:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220322191436.110963-1-Jason@zx2c4.com>
In-Reply-To: <20220322191436.110963-1-Jason@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Mar 2022 13:42:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgSRk_-Nh5gtDKZj_fKya1NKry1Y5jdejfKNPnB+Pr4cw@mail.gmail.com>
Message-ID: <CAHk-=wgSRk_-Nh5gtDKZj_fKya1NKry1Y5jdejfKNPnB+Pr4cw@mail.gmail.com>
Subject: Re: [PATCH] random: allow writes to /dev/urandom to influence fast init
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Theodore Ts'o" <tytso@mit.edu>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 22, 2022 at 12:15 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> @@ -1507,6 +1507,8 @@ static int write_pool(const char __user *ubuf, size_t count)
>                 }
>                 count -= len;
>                 ubuf += len;
> +               if (unlikely(crng_init == 0 && !will_credit))
> +                       crng_pre_init_inject(block, len, false);
>                 mix_pool_bytes(block, len);
>                 cond_resched();
>         }

Ugh. I hate that whole crng_pre_init_inject() dance.

We already mix the data into the input_pool with that 'mix_pool_bytes()' call.

So what I think the real fix is, is to just make urandom_read() use
the input_pool data directly for initializing the state.

IOW, why isn't the patch along the lines of just making
crng_make_state() take the data from the input pool instead, when
crng_ready() isn't set?

As a broken example patch, something like the appended (except that
doesn't build, because 'input_pool' is declared later)?

So take this purely as a conceptual patch, not a real patch.

(Yeah, I think this also means that code that currently does that

                crng_pre_init_inject(pool, sizeof(pool), true);
                mix_pool_bytes(pool, sizeof(pool));

should do those two operations in the reverse order, so that the input
pool is always updated before that crng_pre_init_inject() dance).

Maybe I'm missing something. But it seems kind of silly to use
base_crng AT ALL before crng_ready(). Why not use the pool we have
that *is* actually updated (that 'input_pool')?

                Linus

@@ -374,19 +374,14 @@ static void crng_make_state(u32
chacha_state[CHACHA_STATE_WORDS],
        /*
         * For the fast path, we check whether we're ready, unlocked first, and
         * then re-check once locked later. In the case where we're really not
-        * ready, we do fast key erasure with the base_crng directly, because
-        * this is what crng_pre_init_inject() mutates during early init.
+        * ready, we do fast key erasure with the input pool directly.
         */
        if (!crng_ready()) {
-               bool ready;
-
-               spin_lock_irqsave(&base_crng.lock, flags);
-               ready = crng_ready();
-               if (!ready)
-                       crng_fast_key_erasure(base_crng.key, chacha_state,
-                                             random_data, random_data_len);
-               spin_unlock_irqrestore(&base_crng.lock, flags);
-               if (!ready)
+               spin_lock_irqsave(&input_pool.lock, flags);
+               crng_fast_key_erasure(input_pool.key, chacha_state,
+                                     random_data, random_data_len);
+               spin_unlock_irqrestore(&input_pool.lock, flags);
+               if (!crng_ready())
                        return;
        }
