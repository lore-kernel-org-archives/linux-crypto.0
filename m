Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B511BC43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 22:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8370D2073D
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 22:04:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GBVpdukN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfLKWEv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 17:04:51 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:51043 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfLKWEu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 17:04:50 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0cd66f8f
        for <linux-crypto@vger.kernel.org>;
        Wed, 11 Dec 2019 21:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=0LKnwa52M0M9
        Z3V6jvjU94UIZRo=; b=GBVpdukNy4vVl1Yj6oN71KqAcXvUXZv++VPsy/4dSgWt
        keFOEVn3fq7I6UA9ju0vBKqsVInOnc7NVsthJY4JvFYguJMuQt4cMf2DT2mM0DRn
        LbBvDNOx0K+/YUmv+0AKsegJUP6tGu9+Lkuf9fVRMtBkpEdIrgOpKHLweFqofEYL
        AK4ja4Agpl6XJ7946rsu73G+MF3NMyOga3VwBCyq5pgtKFGfcc6ZIvk8ZxA/w4+h
        /fdi+mVhmF91VGs2rVj+Ylm1t6q8dIR8gacLu7lz7qOcM3GOtrgJ5op4LuX5bt9s
        si1B5oaNfEPfCoBcqLXXSlZ/FbNt+gUPggKx0g0jaQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f1746d19 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Wed, 11 Dec 2019 21:09:06 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id k14so215177otn.4
        for <linux-crypto@vger.kernel.org>; Wed, 11 Dec 2019 14:04:48 -0800 (PST)
X-Gm-Message-State: APjAAAUw0cvkBcgJ5aZ6JdDMECrLYfgd3/TMFFP70mkREu9l7adOelgi
        NXe6g/d3n5coWyO8w/qBdBZKnFF2F3LzkIOcDdM=
X-Google-Smtp-Source: APXvYqw1BkbN/8niicN13HnrC9RZja8tV02kH69pho+vRiD4aOoeE48J6HR6rm3E6yVvetfgF1x0xGaNrnNhOEalVyU=
X-Received: by 2002:a05:6830:1b6a:: with SMTP id d10mr4400535ote.52.1576101888110;
 Wed, 11 Dec 2019 14:04:48 -0800 (PST)
MIME-Version: 1.0
References: <20191211170936.385572-1-Jason@zx2c4.com> <20191211190615.GC82952@gmail.com>
In-Reply-To: <20191211190615.GC82952@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 11 Dec 2019 23:04:36 +0100
X-Gmail-Original-Message-ID: <CAHmME9oyD+mwOUa7kjx5J5BhgZYVjfpd1S+oXUthZqV52RfMeQ@mail.gmail.com>
Message-ID: <CAHmME9oyD+mwOUa7kjx5J5BhgZYVjfpd1S+oXUthZqV52RfMeQ@mail.gmail.com>
Subject: Re: [PATCH crypto-next v1] crypto: poly1305 - add new 32 and 64-bit
 generic versions
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Eric,

Thanks for the review. I just finished porting the x86_64 code, which
I'll submit alongside v2 tomorrow, pending a night of sleep and some
rereading: https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/=
commit/?h=3Djd/crypto-5.5&id=3D7380dd3ac2b8ea4a2b1b111139426c7d25374bba

On Wed, Dec 11, 2019 at 8:13 PM Eric Biggers <ebiggers@kernel.org> wrote:
> Isn't the existing implementation in the kernel already based on the 32x3=
2 code
> from Andrew Moon?  Can you elaborate on how the new code is different?

It matches the style of the 64x64 one, so that it's easy to compare
them. And, as mentioned in the commit message, it precomputes
s1,s2,s3,s4, speeding up updates.

> You can run the self-tests.  But I tried and it doesn't get past nhpoly13=
05:
>
> [    0.856458] alg: shash: nhpoly1305-generic test failed (wrong result) =
on test vector 1, cfg=3D"init+update+final aligned buffer"

Oh, right, duh. Okay, I'll submit v2 once I get those tests passing. Thanks=
.

> > +void poly1305_core_emit(const struct poly1305_state *state, const u32 =
nonce[4],
> > +                     void *dst);
>
> Adding nonce support here makes the comment above this code outdated.
>
>         /*
>          * Poly1305 core functions.  These implement the =CE=B5-almost-=
=E2=88=86-universal hash
>          * function underlying the Poly1305 MAC, i.e. they don't add an e=
ncrypted nonce
>          * ("s key") at the end.  They also only support block-aligned in=
puts.
>          */

Ack.

> It would be helpful to include comments for the r64 and h64 fields, like =
there
> are for the r and h fields.  What base is being used?

Sure, I'll add comments.


> This assumes the struct poly1305_key is actually part of an array.  This =
is
> probably what's causing the self-tests to fail, since some callers provid=
e only
> a single struct poly1305_key.

Thanks. Good catch.

> Shouldn't this detail be hidden in struct poly1305_key?  Or at least the
> functions should take 'struct poly1305_key key[2]' to make this assumptio=
n
> explicit.

I'll make it explicit. The way things work right now, the desc_ctx is
an array of a .config-number of keys. In some future cleanup, I think
that should basically be opaque instead, but I'll leave this out of
this now, and instead fix up the signatures to make clear what's going
on, and audit all callers.

Jason
