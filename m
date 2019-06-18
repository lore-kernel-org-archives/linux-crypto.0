Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB24C31E5B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 18:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D3D8214AF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 18:40:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sa184rYS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbfFRSkc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 14:40:32 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40864 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730002AbfFRSkb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 14:40:31 -0400
Received: by mail-io1-f68.google.com with SMTP id n5so32188151ioc.7
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 11:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uz6vgs3GOxjbM3AuIshCCTudGsU2NjDzL7vFSt7v/cQ=;
        b=sa184rYSkOu0dqqQXNHk6+itUzlQAxXj+dBN9nFQYozP6bKOI/e0TaH30OYZBzug8V
         6NxKKJpwowcYPFc+doF6gb9RXdOfBXXxOxP+x43JFA0J/sLQkzERYuctYX+jbR3LsR1n
         DoYJ+s19h5ihqAhBlXkUM2Vqfnfy1BkqofQLWDEiC9iiLcF/SZbfeHkroYUtPoLXE5Xb
         5uVzl2kyQGH/gaUHhE8vf0bnWmEnyROPwPLvpTM79VUKnO4VFwV6rl6DjMsg+zymS6T1
         BpMMmk+ZuaemIaG2YJZNz7gdKRpvlA6JTPyIz6fwQ39dmT08kLG4jVdwREqBOjx8aEy2
         Zn6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uz6vgs3GOxjbM3AuIshCCTudGsU2NjDzL7vFSt7v/cQ=;
        b=RCYxjtmH/Q+Cus1RMa5UGNLF4vtBltmIGFjE7ckSUgg9XdOWd+wJA+ZSlU4hIgptE6
         w0ryup+nFihLVOD8gfHTAJm5BsDqN2OUmzobPaCKS3VPmQq2q2Z4ne7x5APCEF95l/gY
         /zlP5N5noiz0lf/ZgE+QRVdXFYLG7ibyo7LLw6lkvjkZ1MsBy/JXhXrFzO/YQmZZkcu8
         3fOL7CEolqh4fkLaYG+/Cm4kRjTpd7l7ybbPs85KgGT2fKiBocglWRvYJNWIGuCFn0vO
         +b7z83T2x4fmnIIvtJwk3uWC5ouKHQeu+eG98ZaEHX1C5FZYxC0rboAlctnf3OSxNsEl
         gjGw==
X-Gm-Message-State: APjAAAXcgkkWQaWoPS1G32kR15LqWz8STfHNPTJkUtkOcRZlipokyv9q
        ewPxPQPqXITe/XROdFAshAAlidmM9urlJC7k3XPFzw==
X-Google-Smtp-Source: APXvYqwrtYX7T9EQVi5nKj6iCPZHozRcRdsgD/IsbB8GUzkC3o294t480Avwkz8omW/Kn7dPl9QBNPGfhgfxtPfZqH0=
X-Received: by 2002:a5d:8794:: with SMTP id f20mr19039445ion.128.1560883230081;
 Tue, 18 Jun 2019 11:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
 <20190618093207.13436-3-ard.biesheuvel@linaro.org> <20190618182253.GK184520@gmail.com>
In-Reply-To: <20190618182253.GK184520@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 18 Jun 2019 20:40:18 +0200
Message-ID: <CAKv+Gu-xBCe09B1=GvXBH3V-p7=fOZcdL5pvFi5v19LT0J4KHA@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: fastopen: use endianness agnostic representation
 of the cookie
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 18 Jun 2019 at 20:22, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jun 18, 2019 at 11:32:07AM +0200, Ard Biesheuvel wrote:
> > Use an explicit little endian representation of the fastopen
> > cookie, so that the value no longer depends on the endianness
> > of the system. This fixes a theoretical issue only, since
> > fastopen keys are unlikely to be shared across load balancing
> > server farms that are mixed in endiannes, but it might pop up
> > in validation/selftests as well, so let's just settle on little
> > endian across the board.
> >
> > Note that this change only affects big endian systems.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  include/linux/tcp.h     |  2 +-
> >  net/ipv4/tcp_fastopen.c | 16 ++++++++--------
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> >
>
> What about the TCP_FASTOPEN_KEY option for setsockopt and getsockopt?  Those
> APIs treat the key as an array of bytes (let's say it's little endian), so
> doesn't it need to be converted to/from the CPU endianness of siphash_key_t?
>

Yeah, good point.

Can we first agree on whether we care about this or not? If so, i can spin a v2.
