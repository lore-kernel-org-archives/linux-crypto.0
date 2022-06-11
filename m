Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367B2C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jun 2022 19:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiFKTYv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Jun 2022 15:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiFKTYu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Jun 2022 15:24:50 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562D46C576
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jun 2022 12:24:49 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id s12so3950310ejx.3
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jun 2022 12:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=eDX4YPI3skPtrMHLN/aI+LITSLK4NDifJrwE3YqyBD8=;
        b=JguE9HK8hf8slWcR5xn6yotU/1f0tuKATFdShO4up01A44xhRlhyqnlEsUtrJpMyhY
         ivEMDGjuWe5lhPovWwxEdr6vdX5PGg5Qf/PxqclXrsrSBLaIu+zVHF5TPGMgyg7C93Pj
         DQSn8sq3AnxfSPI1KLZ71JcD29EZgevzNzB1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=eDX4YPI3skPtrMHLN/aI+LITSLK4NDifJrwE3YqyBD8=;
        b=S7O+RQtnvcHgwF6YfoblMBEzkFozApbEKSBwBalvixfkpaoyzYrMVILAlD21FlnwDP
         FbQom/Jh6+JNXXZ5NcBm81fipGH6YVqNYgafh3/wopG43pYSJhaXc862QhFzhNPry2IO
         vlsWvRpHKZ5WQlfTLgTsj/xSmJRLDeSgq+2teG1IUDv91VoxpuPkqt/VA/s4jjhHNRq6
         9ZAKewT6hvKLtED1Dy6/ho4gkVjsV3vZJhvLbuC2Ilnqoond+wmxO+s1r9gizgJZyUBK
         6gRdRRz8KMkdLnvMMxMluntm79Xjj+OnVj8E33k70YYW7DK575KUWcdqNFhuLCYaV+Wc
         8dcQ==
X-Gm-Message-State: AOAM531Jm0LWlK0l8K5OJVEUl5TC2rPKeRB0n16k7LjQbBCmGTjzxdHI
        WIOsIbAJURKoe0s26n5oJTgPQbHUx/6Cgsx6
X-Google-Smtp-Source: ABdhPJwkDRWobhLb16qHGl98SuxrbfnQBoo4Ne9jW3rkJDhlR8AZWMGJpMhLeglHot4R1qJlfxObSQ==
X-Received: by 2002:a17:906:d8b8:b0:711:c73e:906b with SMTP id qc24-20020a170906d8b800b00711c73e906bmr31823857ejb.225.1654975487648;
        Sat, 11 Jun 2022 12:24:47 -0700 (PDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com. [209.85.221.43])
        by smtp.gmail.com with ESMTPSA id d11-20020a50c88b000000b0042bd6630a14sm1868814edh.87.2022.06.11.12.24.46
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jun 2022 12:24:47 -0700 (PDT)
Received: by mail-wr1-f43.google.com with SMTP id k16so2470375wrg.7
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jun 2022 12:24:46 -0700 (PDT)
X-Received: by 2002:a5d:414d:0:b0:213:be00:a35 with SMTP id
 c13-20020a5d414d000000b00213be000a35mr42667754wrq.97.1654975486223; Sat, 11
 Jun 2022 12:24:46 -0700 (PDT)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 Jun 2022 12:24:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjxqgeG2op+=W9sqgsWqCYnavC+SRfVyopu9-31S6xw+Q@mail.gmail.com>
Message-ID: <CAHk-=wjxqgeG2op+=W9sqgsWqCYnavC+SRfVyopu9-31S6xw+Q@mail.gmail.com>
Subject: blake2b_compress_one_generic() stack use with gcc-12
To:     Eric Biggers <ebiggers@google.com>,
        David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On an i386 build, I now get

  crypto/blake2b_generic.c: In function =E2=80=98blake2b_compress_one_gener=
ic=E2=80=99:
  crypto/blake2b_generic.c:109:1: warning: the frame size of 2640
bytes is larger than 2048 bytes [-Wframe-larger-than=3D]

probably due to upgrading to gcc-12. But who knows - it's been several
months since I bothered to do a 32-bit build, so maybe it was
something else.

That stack frame is disgusting on x86-64 too, but at least a bit less
so (it's "only" 592 bytes there). I assume there are fewer spills due
to more registers or something, and then gcc doesn't go all crazy.

The actual data arrays it uses should use 256 bytes plus a few other
things, so the expansion due to spilling(?) is truly ludicrous.

I assumed it was some debug option causing the compiler to not re-use
spill slots or something like that. We've had that before. But
disabling KASAN did nothing for the stack use. Neither did disabling
UBSAN or the gcc plugins.

I then started to think it's the same issue that clang hit, and that
Arnd fixed with 0c0408e86dbe ("crypto: blake2b - Fix clang
optimization for ARMv7-M"), but adding -fno-unroll-loops
-fno-peel-loops didn't do anything either. Neither did adding a

  #pragma GCC unroll 0

where the clang #pragma is.

So this is a "Help me, Obi-Wan Kenobi. You're my only hope" email.

Anybody got any ideas?

It's worth noting that clang does much better. On both i386 and
x86-64, it does a stack frame of just over 400 bytes. So this very
much is about gcc.

                  Linus
