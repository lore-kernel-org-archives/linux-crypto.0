Return-Path: <SRS0=NTKo=2I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C8CC43603
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 10:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F44E24650
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 10:13:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mmfco3fv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfLRKNC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Dec 2019 05:13:02 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41749 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfLRKM7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Dec 2019 05:12:59 -0500
Received: by mail-qt1-f195.google.com with SMTP id k40so1506868qtk.8
        for <linux-crypto@vger.kernel.org>; Wed, 18 Dec 2019 02:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ws9LGLaoc3+Hm+PZ5CI8rYmVt90u1n7ZUCQR2tNutFk=;
        b=Mmfco3fvj38HtPlrRpC6OWceno0UGchQsnFEUuj30sDWL7f5S1cWZNjicm9tNKOHDx
         0UCCd7rSVPIJlXhYG1FLDxnCjs6n1pLE5x9irdfNa+OaYxE9X5x2EgzTFJOr4wkm6HCi
         fxEstdYMF/Nn+3ocy++q8Zq9njFEKgTpbnFR6RdlEjc/uPDLTu0XOe7cnwSLk1c0tTvJ
         GXjYqkqJ0zYrzx93fdlCHqsZZ4NCyFgNkh9bCK05CEtqJwrdGllS1QcTrOvUVAJCJuCz
         JJtNlHyGTSPG2ksEmpvfoB4ee1AP0MHnT3wL9x/C/9phcxvsjXv0J6f8yIS/qQq4CGyG
         uQ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ws9LGLaoc3+Hm+PZ5CI8rYmVt90u1n7ZUCQR2tNutFk=;
        b=pzB1P7GYwmHvhHejf2zGl4wd0wH9lj64ckVzI7RlbOzC/YykBhe3aTj1DoVEttly6Q
         QtUXP0e3hNl6QRhl2us3RjBgdA8h/GyE08iZH35wmxK/YVTvT2ecQfjvXuj03hLNFtDj
         xF51TWyHGiFrShsd1s4UAafttCXB0aCnRAJnKzjdIIiRB+Ab8nrsp4Nq2mZPxNKERa4o
         l4IeSSqG+Y33k8AO7g6yjsKCIU2nlq93eK/9mYMqQ1eZlExFNF83h5hiNswFss7GKV0J
         bms5W3REhtdhzy6aR0E4CCYz6JI7/7+sMcZX0KZLGNJQxZqdKd30vzmPlaBBDFZwi9Xu
         1xmw==
X-Gm-Message-State: APjAAAWU4WqhzT2tuWiixdt+2EMy7h9JW11MDatKhbJ57tyZzp8jjzMB
        hrAWoVnLjDeaYk12w+Jcw7C7Yql7pwoccbO7CVmbRA==
X-Google-Smtp-Source: APXvYqypdYEsGrKFOy8FIj3tJ3oEE00rNcAYDvs1HpbdD3RFNsMIqLxEt1d2URPTxJCc/7+w+KwLHGiDud0X4uFJ5q0=
X-Received: by 2002:ac8:24c1:: with SMTP id t1mr1375386qtt.257.1576663977714;
 Wed, 18 Dec 2019 02:12:57 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com>
In-Reply-To: <20191208232734.225161-1-Jason@zx2c4.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 18 Dec 2019 11:12:46 +0100
Message-ID: <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 9, 2019 at 12:28 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> WireGuard is a layer 3 secure networking tunnel made specifically for
> the kernel, that aims to be much simpler and easier to audit than IPsec.
> Extensive documentation and description of the protocol and
> considerations, along with formal proofs of the cryptography, are
> available at:
>
>   * https://www.wireguard.com/
>   * https://www.wireguard.com/papers/wireguard.pdf
>
> This commit implements WireGuard as a simple network device driver,
> accessible in the usual RTNL way used by virtual network drivers. It
> makes use of the udp_tunnel APIs, GRO, GSO, NAPI, and the usual set of
> networking subsystem APIs. It has a somewhat novel multicore queueing
> system designed for maximum throughput and minimal latency of encryption
> operations, but it is implemented modestly using workqueues and NAPI.
> Configuration is done via generic Netlink, and following a review from
> the Netlink maintainer a year ago, several high profile userspace tools
> have already implemented the API.
>
> This commit also comes with several different tests, both in-kernel
> tests and out-of-kernel tests based on network namespaces, taking profit
> of the fact that sockets used by WireGuard intentionally stay in the
> namespace the WireGuard interface was originally created, exactly like
> the semantics of userspace tun devices. See wireguard.com/netns/ for
> pictures and examples.
>
> The source code is fairly short, but rather than combining everything
> into a single file, WireGuard is developed as cleanly separable files,
> making auditing and comprehension easier. Things are laid out as
> follows:
>
>   * noise.[ch], cookie.[ch], messages.h: These implement the bulk of the
>     cryptographic aspects of the protocol, and are mostly data-only in
>     nature, taking in buffers of bytes and spitting out buffers of
>     bytes. They also handle reference counting for their various shared
>     pieces of data, like keys and key lists.
>
>   * ratelimiter.[ch]: Used as an integral part of cookie.[ch] for
>     ratelimiting certain types of cryptographic operations in accordance
>     with particular WireGuard semantics.
>
>   * allowedips.[ch], peerlookup.[ch]: The main lookup structures of
>     WireGuard, the former being trie-like with particular semantics, an
>     integral part of the design of the protocol, and the latter just
>     being nice helper functions around the various hashtables we use.
>
>   * device.[ch]: Implementation of functions for the netdevice and for
>     rtnl, responsible for maintaining the life of a given interface and
>     wiring it up to the rest of WireGuard.
>
>   * peer.[ch]: Each interface has a list of peers, with helper functions
>     available here for creation, destruction, and reference counting.
>
>   * socket.[ch]: Implementation of functions related to udp_socket and
>     the general set of kernel socket APIs, for sending and receiving
>     ciphertext UDP packets, and taking care of WireGuard-specific sticky
>     socket routing semantics for the automatic roaming.
>
>   * netlink.[ch]: Userspace API entry point for configuring WireGuard
>     peers and devices. The API has been implemented by several userspace
>     tools and network management utility, and the WireGuard project
>     distributes the basic wg(8) tool.
>
>   * queueing.[ch]: Shared function on the rx and tx path for handling
>     the various queues used in the multicore algorithms.
>
>   * send.c: Handles encrypting outgoing packets in parallel on
>     multiple cores, before sending them in order on a single core, via
>     workqueues and ring buffers. Also handles sending handshake and cookie
>     messages as part of the protocol, in parallel.
>
>   * receive.c: Handles decrypting incoming packets in parallel on
>     multiple cores, before passing them off in order to be ingested via
>     the rest of the networking subsystem with GRO via the typical NAPI
>     poll function. Also handles receiving handshake and cookie messages
>     as part of the protocol, in parallel.
>
>   * timers.[ch]: Uses the timer wheel to implement protocol particular
>     event timeouts, and gives a set of very simple event-driven entry
>     point functions for callers.
>
>   * main.c, version.h: Initialization and deinitialization of the module.
>
>   * selftest/*.h: Runtime unit tests for some of the most security
>     sensitive functions.
>
>   * tools/testing/selftests/wireguard/netns.sh: Aforementioned testing
>     script using network namespaces.
>
> This commit aims to be as self-contained as possible, implementing
> WireGuard as a standalone module not needing much special handling or
> coordination from the network subsystem. I expect for future
> optimizations to the network stack to positively improve WireGuard, and
> vice-versa, but for the time being, this exists as intentionally
> standalone.
>
> We introduce a menu option for CONFIG_WIREGUARD, as well as providing a
> verbose debug log and self-tests via CONFIG_WIREGUARD_DEBUG.

Hi Jason, Dave,

Some late feedback on CONFIG_WIREGUARD_DEBUG.

Does it really do "verbose debug log"? I only see it is used for
self-tests and debug checks:

linux$ grep DEBUG drivers/net/wireguard/*.c
drivers/net/wireguard/allowedips.c: WARN_ON(IS_ENABLED(DEBUG) && *len >= 128);
drivers/net/wireguard/allowedips.c: WARN_ON(IS_ENABLED(DEBUG) && len
>= 128);                      \
drivers/net/wireguard/main.c:#ifdef DEBUG
drivers/net/wireguard/noise.c: WARN_ON(IS_ENABLED(DEBUG) &&

There are 3 different things:
 - boot self-tests
 - additional debug checks
 - verbose logging

In different contexts one may enable different sets of these.
In particular in fuzzing context one absolutely wants additional debug
checks, but not self tests and definitely no verbose logging. CI and
various manual scenarios will require different sets as well.
If this does verbose logging, we won't get debug checks as well during
fuzzing, which is unfortunate.
Can make sense splitting CONFIG_WIREGUARD_DEBUG into 2 or 3 separate
configs (that's what I see frequently). Unfortunately there is no
standard conventions for anything of this, so CIs will never find your
boot tests and fuzzing won't find the additional checks...
