Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC3DC05023
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 20:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjITUlt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjITUls (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 16:41:48 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D48C2
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 13:41:42 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-5041bb9ce51so482726e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 13:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1695242501; x=1695847301; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mn4MY7BtYrdUSVLDctKd++v/twQTrdcS02f+zA6JnXU=;
        b=N0TyW2m5FkG67Q8ZN/SkoEjP+AFtKxNSVMtCWC3GEFfCqbDcfRk18IE42xbzvxIcC4
         lvatrxKSqwJ//fhW6I2D6+FwAHYVE7qh/9unzuzFS4WyXiCsQ99FPkdElEdo2iVXYX6R
         bBjSs5R5+0maogRvO+vFdaKWqr2Qa0JjGk4UQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695242501; x=1695847301;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mn4MY7BtYrdUSVLDctKd++v/twQTrdcS02f+zA6JnXU=;
        b=isqMzJjEb0v9RbudRlCPGHdZL97biTMGcFop6frI5xm4KbpB+F9vTVCTXdMB4uH517
         MXslLhA7F9DQGAqeClb0qMYN1DxkA1v04ubs+EBezBKN+IYGd/MC+WnyW3iQxUROx4K7
         9Kfz8tw+7UPZRHj5sNtddTx4KSxX6kyo6gFrpDF0ThzDpIHNydrWLXNNBRt24xwDsdet
         UGE4PS5psm6IHqoNLhHdaSF38mGx13RhHEOldsrPDtV4IvhD5VM9Vt/9Rrw5Yw65GVDt
         LBZzwFkKhZPj3Q7aDPF2P1Ix6D8u3Vw5ZoUnmh0LLR+wpnUxUSUHmDAqsTMaQ35YUQ0B
         l4ZA==
X-Gm-Message-State: AOJu0YyF1IqyQUa58hVKe+3EjfjJaOVBg0lBefZf1ATOGui6I4Hha8Gg
        xizoyXpeq8fzYIcACsfefFo9WO+pHp5hoS1V2YOmcRon
X-Google-Smtp-Source: AGHT+IEORE1AfkKIygt4VrfNH5h8I3c3O8T/CnaDxA6t0yf06qKwGdklCVOEH0nyhVv0jSq0Qjelog==
X-Received: by 2002:a05:6512:475:b0:4fe:8c4:44fb with SMTP id x21-20020a056512047500b004fe08c444fbmr3252979lfd.38.1695242500753;
        Wed, 20 Sep 2023 13:41:40 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id a19-20020a056512201300b005030b40aa56sm1770330lfb.173.2023.09.20.13.41.40
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 13:41:40 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5041bb9ce51so482699e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 13:41:40 -0700 (PDT)
X-Received: by 2002:a19:2d04:0:b0:503:3675:9ba with SMTP id
 k4-20020a192d04000000b00503367509bamr2690524lfj.26.1695242499688; Wed, 20 Sep
 2023 13:41:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230920060615.GA2739@sol.localdomain> <CAHk-=wja26UmHQCu48n_HN5t5w3fa6ocm5d_VrJe6-RhCU_x9A@mail.gmail.com>
 <20230920193203.GA914@sol.localdomain> <CAHk-=wicaC9BhbgufM_Ym6bkjrRcB7ZXSK00fYEmiAcFmwN3Kg@mail.gmail.com>
 <20230920202126.GC914@sol.localdomain> <CAHk-=wgu4a=ckih8+JgfwYPZcp-uvc1Nh2LTGBSzSVKMYRk+-w@mail.gmail.com>
In-Reply-To: <CAHk-=wgu4a=ckih8+JgfwYPZcp-uvc1Nh2LTGBSzSVKMYRk+-w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 20 Sep 2023 13:41:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+nAmcXV=Xz6fkDpazne+n+iFfGsnS=p9PjVLiEjiSvQ@mail.gmail.com>
Message-ID: <CAHk-=wh+nAmcXV=Xz6fkDpazne+n+iFfGsnS=p9PjVLiEjiSvQ@mail.gmail.com>
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

On Wed, 20 Sept 2023 at 13:32, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It was why I also asked about entropy. Because *if* you argue that the
> user-space write contains entropy, then that would be a reason.

To clarify - the jitter entropy question was related to that same
basic issue: if this was meant to be a way to mitigate the lack of
jitter entropy on some platform you care about, that would again
possibly be a reason to care.

Considering that we apparently haven't cared for the last 7 years, I'm
still a bit surprised, but whatever.

What I *don't* want is just more voodoo discussions about /dev/*random
behavior that doesn't have a technical reason for it.

                Linus
