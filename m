Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3B3C04A68
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Jul 2022 15:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbiG3PtD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Jul 2022 11:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiG3PtD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Jul 2022 11:49:03 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C4D15A18
        for <linux-crypto@vger.kernel.org>; Sat, 30 Jul 2022 08:49:02 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a7so253181ejp.2
        for <linux-crypto@vger.kernel.org>; Sat, 30 Jul 2022 08:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=YJCZuifYbBHHVUq8hg52oBQXwufMLlt5AWoYuTd/5Rw=;
        b=au15hpWWy8nTU6PUXBhTIhRkZrhjaE650nazkqq0yf5pJGpsrnZVd3qTIKQerPinE3
         /eCD+niBPu+FM6F6SFD4oEkIwkmQ2ZnRFYvYy0CB3YaeXXAuhjx246hyZHON5mmtuAiw
         6Ejwde6oSlpwSvQhvaA1a6wskcrFNLrUW7RIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=YJCZuifYbBHHVUq8hg52oBQXwufMLlt5AWoYuTd/5Rw=;
        b=UIOGctSEPcFB7Nd+n/4QZzN9ZPWLIDqjJLbR9MwyFhxdfETHXssljhONYWubry2nQL
         GtAxBRDF2J8BIoIvn68yd4lIlctLyXC9ztlYgiwJ46DZi7ZUKX4O9/x8jrJd/35UpEGl
         NVNYbbdYRNXGPo5Zam/ThGs7pNegLAFyhiFWtlFDnz7yjOzJPZN6WkCngxngLgz0Xg2T
         ygyTHpfF1amLPeuTv7MwlCBWRyKj0f6gJHk6Af1+OTr1PfCEj0nMEM5GUtkf+dciMJ3y
         2hjpMFmEhlMMvu0zD0eXfj6H1QbPGv74zvFzJeX5UCyrXqQ0M66LtAL9pfECvgUWTCrX
         BEVw==
X-Gm-Message-State: AJIora/zTzZDgDG0guI9bU4N+Ro+nyWOk1+Zkv2S+fDXbN+XOg3D0hAW
        UiEiKpwpu2ujP2vyN+oJYt3dPPf8R3jyNZBs
X-Google-Smtp-Source: AGRyM1swCprA1TLF90oWLGMkeiFQAYhnQXfDS8NMMNbplarI9DXj6LKkW7uSVfpS/ae3wCHC2Utsrg==
X-Received: by 2002:a17:906:58d5:b0:72f:2b21:eb20 with SMTP id e21-20020a17090658d500b0072f2b21eb20mr6676935ejs.508.1659196140353;
        Sat, 30 Jul 2022 08:49:00 -0700 (PDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id o24-20020a170906769800b0073061212425sm223278ejm.179.2022.07.30.08.48.59
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jul 2022 08:48:59 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso5437701wma.2
        for <linux-crypto@vger.kernel.org>; Sat, 30 Jul 2022 08:48:59 -0700 (PDT)
X-Received: by 2002:a05:600c:21d7:b0:3a3:2088:bbc6 with SMTP id
 x23-20020a05600c21d700b003a32088bbc6mr6044685wmj.68.1659196138936; Sat, 30
 Jul 2022 08:48:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220729145525.1729066-1-Jason@zx2c4.com>
In-Reply-To: <20220729145525.1729066-1-Jason@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 30 Jul 2022 08:48:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiLwz=9h9LD1-_yb1+T+u59a2EjTmMvCiGj4A-ZsPN1wA@mail.gmail.com>
Message-ID: <CAHk-=wiLwz=9h9LD1-_yb1+T+u59a2EjTmMvCiGj4A-ZsPN1wA@mail.gmail.com>
Subject: Re: [PATCH RFC v1] random: implement getrandom() in vDSO
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        x86@kernel.org, Nadia Heninger <nadiah@cs.ucsd.edu>,
        Thomas Ristenpart <ristenpart@cornell.edu>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Florian Weimer <fweimer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 29, 2022 at 3:32 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Two statements:
>
>   1) Userspace wants faster cryptographically secure numbers of
>      arbitrary size, big or small.
>
>   2) Userspace is currently unable to safely roll its own RNG with the
>      same security profile as getrandom().

So I'm really not convinced that this kind of thing is something the
kernel should work that hard to help.

And that state allocation in particular looks very random in all the
wrong ways, with various "if I run out of resources I'll just do a
system call" things.

Which just makes me go "just do the system call".

People who are _that_ sensitive to performance can't use this anyway,
unless they know the exact rules of "ok, I only need X state buffers"
(ok, the buckets are probably the more real "sometimes it might fail"
thing). So they basically need to know about the implementation
details - even if it's only about that kind of "only a limited number
of states" thing.

Not to mention that I don't think your patch can work anyway, with
things like "cmpxchg()" not being something you can do in the vdso
because it might have the kernel instrumentation in it.

So this all smells really fragile to me, and honestly, unlike the vdso
things we _do_ have, I don't think I've ever seen getrandom() be a
huge deal performance-wise.

It's just too specialized, and the people who care about performance
can - and do - do special things anyway.

Your patch fundamentally seems to be about "make it easy to not have
to care, and still get high performance", but that's _such_ a small
use-case (the intersection between "don't care" and "really really
need high performance" would seem to be basically NIL).

              Linus
