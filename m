Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF76C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 10:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A41B20870
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 10:14:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="28YirW/+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbfCYKOO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 06:14:14 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:53095 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730549AbfCYKOO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 06:14:14 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6d936f1f;
        Mon, 25 Mar 2019 09:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=/t8kcAuz/aTASjlxRhypzUSwSK4=; b=28YirW
        /+UyK3aFHwWrha1jb3ZRfiZ3EGjJ7fBbS80FQTn4jp9Yp5qVAi2wbnhNEYcForhg
        tqj0tshegHhXWQFgaPS9fswzhvDPB/Qn5ivapK4iIQvG45k2BkRrkqQmBjfet8In
        auQMFzfyGQQ7mEhV6xT4ZfS9oVU17kCOyN9ub365CVkwkP7qTCAHx09A4WGFWKjK
        Q5s3BnX7o+RuvW3zHzhmyXhA+Z7Z+vjIuJVsCZ66h55Fq4jfmpEGUZupPn5zd4JF
        GUCiKmgJySLGziJQ92DuYkbewublrtzJ14pX+4rxk1m+PWBPrmiRAh/iTqXWVC+k
        HmHwvPuD70tCgMlA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8f75ca5b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 25 Mar 2019 09:52:04 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id j10so1016613otq.0;
        Mon, 25 Mar 2019 03:14:11 -0700 (PDT)
X-Gm-Message-State: APjAAAUaeC/AWep3qW6KYm4+97z8DBS3TBEX5KRVwJLrSbUGmZpaivgH
        f1To/7J0ye8Evhy8t8MMlNGPX4zZVwY2mZlUsIw=
X-Google-Smtp-Source: APXvYqz87dRaXacF9kVwij5FW+GniMxPywn23ZcAebL2bL3FYNJYlmZzecsCfsl1tj3DPDBnq0ZTS4NgJxnROErp2cg=
X-Received: by 2002:a9d:5501:: with SMTP id l1mr17184484oth.143.1553508851035;
 Mon, 25 Mar 2019 03:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190322071122.6677-1-Jason@zx2c4.com> <20190322071122.6677-20-Jason@zx2c4.com>
 <20190324.200254.1946143057733371048.davem@davemloft.net>
In-Reply-To: <20190324.200254.1946143057733371048.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 25 Mar 2019 11:13:59 +0100
X-Gmail-Original-Message-ID: <CAHmME9pG3y9YBswMjczW-NskSRoX5Z-VJbaaQ23rQ+NcLf-7Qg@mail.gmail.com>
Message-ID: <CAHmME9pG3y9YBswMjczW-NskSRoX5Z-VJbaaQ23rQ+NcLf-7Qg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 19/19] net: WireGuard secure network tunnel
To:     David Miller <davem@davemloft.net>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Dave,

Thanks for the comments.

On Mon, Mar 25, 2019 at 1:03 AM David Miller <davem@davemloft.net> wrote:
> Said another way: "The code isn't optimal with my compiler on my computer
> unless I force inline this" is not a valid reason to use __always_inline

Hah, that was my rationale exactly. Okay, no problem, I'll remove
those. And if I can't find a way to make the compiler to do the right
thing without it, and nothing looks overly insane, then I'll fix gcc
bugs separately.

> > +             ((u64 *)dst)[0] = be64_to_cpu(((const __be64 *)src)[0]);
> > +             ((u64 *)dst)[1] = be64_to_cpu(((const __be64 *)src)[1]);
>
> Are 'dst' and 'src' both 64-bit aligned?  If not you'll get traps on some cpus.

Yes, they are.

>
> > +     __skb_queue_head_init(&packets);
> > +     if (!skb_is_gso(skb)) {
> > +             skb->next = NULL;
>
> Why?  Direct ->next and ->prev pointer accesses should never be used,
> along with anything that assumes what the implentation of skb lists
> looks like.
>
> Always use the helpers instead.

Ack, will do.

> > --- /dev/null
> > +++ b/drivers/net/wireguard/hashtables.c
>
> No way.
>
> Do not invent your own hashtables, we have several generic versions in
> tree and in particular rhashtable.
>
> If the generic kernel facilities have a weakness, fix that instead of
> rolling an entire new hashtable implementation.

That file might be poorly named; I'm certainly not implementing my own
hashtable, but rather using <linux/hashtable.h>. The file simply has
the various accessors for it that does the proper locking and
reference counting associated with the things inserted into the
vanilla <linux/hashtable.h> hashtable. I'll rename the file to
something more descriptive.

Jason
