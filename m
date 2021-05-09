Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04EE7C433ED
	for <linux-crypto@archiver.kernel.org>; Sun,  9 May 2021 00:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB9386101E
	for <linux-crypto@archiver.kernel.org>; Sun,  9 May 2021 00:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhEIAfD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 May 2021 20:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhEIAfD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 May 2021 20:35:03 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42DBC061573
        for <linux-crypto@vger.kernel.org>; Sat,  8 May 2021 17:33:59 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l13so12873670wru.11
        for <linux-crypto@vger.kernel.org>; Sat, 08 May 2021 17:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ib.tc; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=KGrn28FwVBwr1b6Oa0JupShY828cBMo9PaPZ8tgSoaI=;
        b=jFPs3/rbtMHMdB4b83ilE7h+TrTbjm/F4VCrMThM1nqsdRrxZ6c2pF8rUk4yiQyCm0
         kSbky8JDH022OBd89taJfUE44x/BvAgboS2YXuo8ZjEWIk/xfxnrvyqSYbrMygY6CByP
         oQSOkJIdHH8pQtFwnX1vj4YvmgCf4CsKolTIa1/tm8aVIRLZAEi4wPTc8kL3Un1btqaC
         6B/j1ibXtCSTrZTNvU1njqPgosm9duQdTuGHX31mU2MetTJgIb4YmnFICLI+e0A8Nfv6
         2oMOqKPZgI6GPdjVuiu4LjQSPna2R7xrUcos03fe05vuqptV2S1/XSlZ5kuVF2i+FBTs
         aTXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KGrn28FwVBwr1b6Oa0JupShY828cBMo9PaPZ8tgSoaI=;
        b=VHnqvSNXYDIyCrIOqkriVQAs2BS5zRKV7nllHyGZWIdH2FVszRYcx0IS5orfFw1QTj
         LPmsZnbCFAWoSFMAxpkUyl+vObzEZqeONmBS6wP0y5V3ZLYJV1Awb23fjqhElUyvHJgX
         zyIPpWGfto+9hfJCtItwKPA0XKXTBeIFiM0S67SHZAvGICRIjLJ6leXO8DQJTRbh3wng
         BmQDxp44cTF+3H/3TiAmXX8ja5zvne0c/xPegcCkyw38rNK1L/tQo9h5FyiYMFCf2Zpd
         mEXyTO18yni1+ZBo0taaN0U+N2GGlH6FNO737dJtHzz/qfnIe0WN0EBcA/T6RdClepFh
         037g==
X-Gm-Message-State: AOAM530ueI3Hhji4/Ezr/m+afH8+EZQfOkP92a8yzN0dgWp96mF5i/Ws
        2tuh10ffTcU1LdQWgxC9yGrxJnXTiI42RURxvvKB7Seyhc1kjA==
X-Google-Smtp-Source: ABdhPJzoV6kfrRaCXkkoKNWgqBlfd0pdC9ytGo+cxDEvrZAUYLAEqYoSd76VRinOb38SxQFXY3C23E9Xj2hLa+mD5Pc=
X-Received: by 2002:a5d:4452:: with SMTP id x18mr22390789wrr.286.1620520438356;
 Sat, 08 May 2021 17:33:58 -0700 (PDT)
MIME-Version: 1.0
From:   Mike Brooks <m@ib.tc>
Date:   Sat, 8 May 2021 17:33:48 -0700
Message-ID: <CALFqKjSnOWyFjp7NQZKMXQ+TfzXMCBS=y8xnv5GE56SHVr5tCg@mail.gmail.com>
Subject: Lockless /dev/random - Performance/Security/Stability improvement
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Everyone,

I am a cryptographer, a hacker, and exploit developer.  I am an
accomplished security engineer, and I've even hacked Majordomo2, the
maling list we are using now (CVE-2011-0049).

It is highly unusual that /dev/random is allowed to degrade the
performance of all other subsystems - and even bring the system to a
halt when it runs dry.  No other kernel feature is given this
dispensation, and I wrote some code to prove that it isn't necessary.
Due to a lockless design this proposed /dev/random has much higher
bandwidth for writes to the entropy pool.  Furthermore, an additional
8 octets of entropy is collected per syscall meaning that the random
source generated will be difficult to undermine.

This is an experimental subsystem that is easy to compile and to verify:
https://github.com/TheRook/KeypoolRandom

Should compile right after cloning, even on osx or windows - and
feedback is welcome.  I'm making it easy for people to verify and to
discuss this design. There are other cool features here, and I have a
detailed writeup in the readme.
A perhaps heretical view is that this design doesn't require
handle_irq_event_percpu() to produce a NIST-compliant CSPRNG.  Which
is a particularly useful feature for low power usage, or high
performance applications of the linux kernel.   Making this source of
entropy optional is extremely interesting as it appears as though
Kernel performance has degraded substantially in recent releases, and
this feature will give more performance back to the user who should be
free to choose their own security/performance tradeoff.  Disabling the
irq event handler as a source of entropy should not produce an
exploitable condition,  A keypool has a much larger period over the
current entropy pool design, so the concerns around emptying the pool
are non-existent in the span of a human lifetime.

All the best,
Micahel Brooks

https://stackoverflow.com/users/183528/rook
https://stackoverflow.com/tags/cryptography/topusers #9
https://stackoverflow.com/tags/security/topusers #4
