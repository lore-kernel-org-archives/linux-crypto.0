Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEDDC63777
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 08:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79D4F24656
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 08:31:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oqbOES1g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgKQIau (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 03:30:50 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:55607 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKQIau (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 03:30:50 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bb1a5b34;
        Tue, 17 Nov 2020 08:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=z/RXovRLSYOedThve1IBUcWgk2A=; b=oqbOES
        1gmR16J90s6+lsQpH2tXN85o1+mb2Jhk1/1Ho5jdS3wSbdIkZ1gVp5b6Kfbf2CUD
        SXqzMC4+zGiYNkhPYfMHfgW9KO0YD8gEGR6oFwKUr+Ir5onOOIvcISD+UQTCCLsw
        eqGrl1vHaQPTwr203yOk9v1fJJsVqE23g5RW7HArObv58+LxcSZSjUAZnGx3Lbjh
        0UJmgdb2fgAc43/eQadCXDCRAqQSwPRrEdGJPebMpO4BHCOKs2L2W/MyyM5RbKaO
        54sjt6ADJKzY2dm7Qd5+AB2t+hh15sG7TP7GJuVgdBEy7cQpG7hzeUnj2xh+3ILp
        5/18VDjDdklN7hig==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7c4eff84 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 17 Nov 2020 08:26:58 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id 2so18150281ybc.12;
        Tue, 17 Nov 2020 00:30:47 -0800 (PST)
X-Gm-Message-State: AOAM531/008h6tQGHSxCLv1I0zbruZVw7VDBoJLncqqj3A7gn/NUrdbS
        NKkRH5k/jygvemuiNG2zfMDKuEniz0UiV1IHkVQ=
X-Google-Smtp-Source: ABdhPJxmPVcYu351aXbEk7YtUdCUEBVBnwD81zerLN4rS1+tvRv/82D5tbscpCF/X+kmZfpPTwikQVWAmzs1lwDI+lg=
X-Received: by 2002:a25:df05:: with SMTP id w5mr34289479ybg.20.1605601846472;
 Tue, 17 Nov 2020 00:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20201117021839.4146-1-a@unstable.cc>
In-Reply-To: <20201117021839.4146-1-a@unstable.cc>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 17 Nov 2020 09:30:35 +0100
X-Gmail-Original-Message-ID: <CAHmME9q8k26a9rn72KTfcJw0kJ0iMdob6BBsAsyYBzvfYjRtQQ@mail.gmail.com>
Message-ID: <CAHmME9q8k26a9rn72KTfcJw0kJ0iMdob6BBsAsyYBzvfYjRtQQ@mail.gmail.com>
Subject: Re: [PATCH cryptodev] crypto: lib/chacha20poly1305 - allow users to
 specify 96bit nonce
To:     Antonio Quartulli <a@unstable.cc>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Antonio Quartulli <antonio@openvpn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Nack.

This API is meant to take simple integers, so that programmers can use
atomic64_t with it and have safe nonces. I'm also interested in
preserving the API's ability to safely encrypt more than 4 gigs of
data at once. Passing a buffer also encourages people to use
randomized nonces, which isn't really safe. Finally, there are no
in-tree users of 96bit nonces for this interface. If you're after a
cornucopia of compatibility primitives, the ipsec stuff might be more
to your fitting. Or, add a new simple function/api. But adding
complexity to users of the existing one and confusing future users of
it is a non-starter. It's supposed to be deliberately non-awful to
use.
