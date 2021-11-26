Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25001C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 15:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354212AbhKZPQn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 10:16:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35238 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349060AbhKZPOm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 10:14:42 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 10:14:42 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84685622A6;
        Fri, 26 Nov 2021 15:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0206C004E1;
        Fri, 26 Nov 2021 15:03:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mJBP9B08"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1637939009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RH8/qH8grAa6gFEGBxQ5rymfbgwNueBjT+21OQOzhO4=;
        b=mJBP9B085u3tSvmelxK1VgANWcawy3/lGtl4GeeSLlZI5s8gHBZtUkdXnN7jVumqfaNf3S
        SaCfj3w9KE1VAu5TaoFdEdZocJwR0w/ikxlPO5HRXeEHIar3GdhYb4dEvl8O32PwD/4Sso
        T4OkvJjfloWGdrP6rR9SX4osMmZy290=
Received: by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id 5640c36e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 26 Nov 2021 15:03:29 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id x32so20908223ybi.12;
        Fri, 26 Nov 2021 07:03:29 -0800 (PST)
X-Gm-Message-State: AOAM533Jc8AG4ZsG6sgWQ8vTj/1jLSjXI4/ouleog9dw08dDLwkbX73i
        Wm2KdUbuZwyQaf8qEjegsv5qcRcvTL5JXYN+MNI=
X-Google-Smtp-Source: ABdhPJx4z9oxLEVwBzAuJQgoS1YMUVgfcuYfJ61Ct1d3EdlZFvLtdJRHAMiQkBFnhPiP2eyW9n08VvC6TS5Xzypnxk8=
X-Received: by 2002:a25:acd4:: with SMTP id x20mr16332521ybd.416.1637939007316;
 Fri, 26 Nov 2021 07:03:27 -0800 (PST)
MIME-Version: 1.0
References: <20211126143329.2689618-1-arnd@kernel.org>
In-Reply-To: <20211126143329.2689618-1-arnd@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 26 Nov 2021 10:03:16 -0500
X-Gmail-Original-Message-ID: <CAHmME9rotnZRzqeD43FJmSX6-i2CwvUVpXHrFkLGt+qVVdxK7A@mail.gmail.com>
Message-ID: <CAHmME9rotnZRzqeD43FJmSX6-i2CwvUVpXHrFkLGt+qVVdxK7A@mail.gmail.com>
Subject: Re: [PATCH] crypto: siphash - use _unaligned version by default
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Arnd,

It looks like Ard's old patch never got picked up so you're dusting it
off. It looks like you're doing two things here -- moving from an
ifndef to a much nicer IS_ENABLED, and changing the logic a bit. In
trying to understand the logic part, I changed this in my buffer:

-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-       if (!IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
+       if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+           !IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
                return __hsiphash_unaligned(data, len, key);
        return ___hsiphash_aligned(data, len, key);

into this:

-       if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
-           !IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
+       if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+           !IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
                return __hsiphash_unaligned(data, len, key);
        return ___hsiphash_aligned(data, len, key);

This way I can actually think about what's happening here.

So with the old one, we use the faster aligned version if *either* the
CPU has efficient unaligned access OR the bytes are statically known
to be aligned. This seems sensible.

On the new one, we use the faster aligned version if *both* the bytes
are statically known to be aligned (ok) AND the CPU doesn't actually
support efficient unaligned accesses (?). This seems kind of weird.

It also means that CPUs with fast aligned accesses wind up calling the
slower code path in some cases. Is your supposition that the compiler
will always optimize the slow codepath to the fast one if the CPU it's
compiling for supports that? Have you tested this on all platforms?

Would it make sense to instead just fix clang-13? Or even to just get
rid of CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS for armv6 or undef
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS for armv6 just in this file or
maybe less messy, split CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS into
two ifdefs that more sense for our usage?

Jason
