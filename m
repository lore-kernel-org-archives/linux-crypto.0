Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD49FC4361B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F70222BB
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388501AbgLNUu2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733124AbgLNUu1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:50:27 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796DCC0613D3
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:49:47 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id w13so33670295lfd.5
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yjX3o6xsyCaRUXsi679rrY59nTFovxClxEsS5QsmetY=;
        b=XjtwLkAai12lTlnZPVGu410mAuM6h7pvrrsWQtnfyC+fVZDlR06SHMnbqxBQ7mlCD2
         O5QFsMoATEz1Fg1a2rba6L5kRW7vKfPSB+6Y8bNbfs6TnHzYFEiYTpk0nFnuKI8a/45V
         EP/9F3u3S9UlH8OTDO0A6KqVZinxKJN52Ny+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yjX3o6xsyCaRUXsi679rrY59nTFovxClxEsS5QsmetY=;
        b=KZnCDYd5nLUBalXY9/RBRUWdkI0/GY5Ry0xUjgVYETLfq3yHhAoWoZo3i+Ea266ZFc
         EiOOnOupbWzqvtqhCEUgueiQ0LcSbItJWRUpqcjlKBmP/NVjLaUJJS6mAVKpr7g0L/I+
         aRUBHpDXIqlaehdNZDgP6ri9gS9F9OwujW5zVL6x8JXh/Ictp3Jj8T2h1lEa+AdK0Ng6
         cwzCW1ng2NNtN94iNHGAajm2ev1CEgZu5WPYdr6vLsKd9057VbUuS80EJVS2/rARafa6
         /75M0L5wJvVNuqOIo4MUKXNhyB2HvUUtVGRrbdLqRMVGpL73FPbedq9l+vXqD/t6Efvw
         /0dQ==
X-Gm-Message-State: AOAM533+2q4OntiZk0B/Ch8AQ1ln30mheY56AJmxsursfBhtNc2GlT7g
        A0XQYnRjvhgLI6Ai0wtApQx4KF0bj76xcQ==
X-Google-Smtp-Source: ABdhPJwPwKFqSfeYdKhtnno1T5ZLPFnqRvbeG8zdbOcMKBiXsns4SMe5g+ZB/UfP3SOVS/24sus7sg==
X-Received: by 2002:a05:6512:789:: with SMTP id x9mr5616996lfr.487.1607978985422;
        Mon, 14 Dec 2020 12:49:45 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id 6sm2449326ljq.69.2020.12.14.12.49.43
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 12:49:43 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id o19so8049766lfo.1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:49:43 -0800 (PST)
X-Received: by 2002:a2e:b4af:: with SMTP id q15mr11323303ljm.507.1607978983041;
 Mon, 14 Dec 2020 12:49:43 -0800 (PST)
MIME-Version: 1.0
References: <2659836.1607940186@warthog.procyon.org.uk>
In-Reply-To: <2659836.1607940186@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 14 Dec 2020 12:49:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wido5stGfFtRzmW19bB1w2XQAuY8oxUtFN2ZWdk2Grq-w@mail.gmail.com>
Message-ID: <CAHk-=wido5stGfFtRzmW19bB1w2XQAuY8oxUtFN2ZWdk2Grq-w@mail.gmail.com>
Subject: Re: [GIT PULL] keys: Collected minor fixes and cleanups
To:     David Howells <dhowells@redhat.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Ben Boeckel <mathstuf@gmail.com>,
        Denis Efremov <efremov@linux.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Jann Horn <jannh@google.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Tom Rix <trix@redhat.com>, YueHaibing <yuehaibing@huawei.com>,
        keyrings@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 14, 2020 at 2:04 AM David Howells <dhowells@redhat.com> wrote:
>
> Here's a set of minor fixes/cleanups that I've collected from various
> people for the next merge window.

This doesn't even build.

And no, that's not because of some merge error on my part. Just to
verify, I tried to build the head of what you sent me (commit
1b91ea77dfeb: "certs: Replace K{U,G}IDT_INIT() with
GLOBAL_ROOT_{U,G}ID") and it fails the same way.

  In file included from ./include/linux/cred.h:13,
                   from security/integrity/ima/ima_mok.c:12:
  security/integrity/ima/ima_mok.c: In function =E2=80=98ima_mok_init=E2=80=
=99:
  ./include/linux/key.h:292:29: warning: passing argument 7 of
=E2=80=98keyring_alloc=E2=80=99 makes pointer from integer without a cast
[-Wint-conversion]
  .. ten more lines of warnings..
  security/integrity/ima/ima_mok.c:36:26: error: too many arguments to
function =E2=80=98keyring_alloc=E2=80=99
     36 |  ima_blacklist_keyring =3D keyring_alloc(".ima_blacklist",
        |                          ^~~~~~~~~~~~~

so these "fixes" have clearly had absolutely zero testing, haven't
been in linux-next, and are completely broken.

The bug was introduced by commit 33c36b2053de ("certs: Fix blacklist
flag type confusion"), which changed the IMA code without actually
testing it.

I suspect the fix is trivial (change the "," to "|"), but I will not
be pulling this - or anything else that hasn't been in linux-next -
from you this merge window.

The pain just isn't worth it, but more importantly, you simply need to
get your workflow in order, and not send me completely untested
garbage that hasn't even been compiled.

               Linus
