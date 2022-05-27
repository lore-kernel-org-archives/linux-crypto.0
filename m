Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DCB2C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 May 2022 22:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241393AbiE0WT3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 18:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiE0WT2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 18:19:28 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FCDAFB35
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 15:19:26 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g20so6966161edj.10
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 15:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KMhlHLYP7vE3OTYjg1puHastlhDiEHeeNRES9OIsddw=;
        b=L/HlVk25DGhCW9YIc9uFaP8JYvEcd5y0FWEhIr2fGr3uXAbbvtW62TA4Dxle7qIG2r
         TLoUWezcgcWTdl2rCmImOLISwVlembrtv5li//CfX2nZNI5la5h8pBW760MA+RbHyYbD
         BMse+oOr+uwNxzUvY7lOup3KbvYYWjAZ3wO7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KMhlHLYP7vE3OTYjg1puHastlhDiEHeeNRES9OIsddw=;
        b=GkRKuKMwmVp1OrTkZq/38egPfWH4nIsdNiMggJGZ6oLveOkWaniON+yUvKnrxO9j/Q
         pda4+38ao0/spAtKn5VfhqLNXzhHNcP6PKOoInU2TrM7DFdJx/YSTEnbuHZTdKReT5Rx
         Z6TuHocV0QPr9TiwDxQXY//lFUjQ0Rp+WB3TM+6p7wJokN0gZJW6UoVDmOfObK/Tza8z
         J1hZZkIekfss5pv48NK+lxY4RrCi7+la14BDihMX3wFiuvij13prn6JjA2nsqszElPEU
         ohse8EwV2KERD69SPDQebijwcUms6bs0f+kd/bv0pqvb7lOP/yz0ES3ZYZd9v60pG03A
         5ymA==
X-Gm-Message-State: AOAM5316/QGTYnAxTUNe8Zk4/pD5aGg0S45e2p6Yis6xnVFj3qbcgiRT
        SB5lw2CahpHrFD4vXdF30PmZ5+1wjeZ24rxR
X-Google-Smtp-Source: ABdhPJxMQAjW8oLNf6IHHHeoRNX6xi0i6KrfJtV3v80Wqi8saSx21qX9NXZkF59X2EBGQhhhVfIl0w==
X-Received: by 2002:a05:6402:1941:b0:413:2b7e:676e with SMTP id f1-20020a056402194100b004132b7e676emr47979873edz.114.1653689964777;
        Fri, 27 May 2022 15:19:24 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id u5-20020a1709064ac500b006fe8b456672sm1821146ejt.3.2022.05.27.15.19.24
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 15:19:24 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id p19so3381826wmg.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 15:19:24 -0700 (PDT)
X-Received: by 2002:a7b:cb91:0:b0:397:3225:244 with SMTP id
 m17-20020a7bcb91000000b0039732250244mr8841820wmi.68.1653689963635; Fri, 27
 May 2022 15:19:23 -0700 (PDT)
MIME-Version: 1.0
References: <202205271557.oReeyAVT-lkp@intel.com> <20220527201931.63955-1-Jason@zx2c4.com>
 <CAHk-=whyH8xx=2LVmOdQDTy9RRqBs_JJz_oMV2+6a2myk8+wow@mail.gmail.com> <CAHmME9oAqBT5bOd94Na-q_tHHNZqVyU7eLk0odei7-KB07VPRA@mail.gmail.com>
In-Reply-To: <CAHmME9oAqBT5bOd94Na-q_tHHNZqVyU7eLk0odei7-KB07VPRA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 27 May 2022 15:19:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiGben+GoVuY2qnqKYR7mn6F9kfUkBbTcOt4K7fjAGnog@mail.gmail.com>
Message-ID: <CAHk-=wiGben+GoVuY2qnqKYR7mn6F9kfUkBbTcOt4K7fjAGnog@mail.gmail.com>
Subject: Re: [PATCH crypto v2] crypto: poly1305 - cleanup stray CRYPTO_LIB_POLY1305_RSIZE
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 27, 2022 at 2:16 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Whoops. I sent this to linux-crypto/Herbert assuming that it'd work
> with the "2 weeks pass and nobody complains --> queued up" flow of
> that list.

Well, it's more like "4 months since I complained about this thing",
so I thought it was overdue and applied it..

That said, I don't think CRYPTO_LIB_POLY1305_GENERIC can be set unless
CRYPTO_LIB_POLY1305 is set. And CRYPTO_ARCH_HAVE_LIB_POLY1305 looks
like a bogus thing to test for too - those two just decide if the
arch-specific one or the generic one should be used.

So I think v1 was actually the right one. Possibly

        depends on CRYPTO_LIB_POLY1305 != n

due to the tristate?


                    Linus
