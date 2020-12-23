Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E44C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 14:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C8D621D79
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 14:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgLWOdu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 09:33:50 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:59529 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgLWOdu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 09:33:50 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d384b19b;
        Wed, 23 Dec 2020 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Io97KoT2j7fFJotgUUvzrUqa2Fs=; b=W4yfNf
        DK9bpU0jmM48T0SxjV+mlpxoJdqoVrWhV7FvACcDI7ZnpR7nrIEZmiHI7VkyjyEV
        4YKwZPrWXBsR/izUJsioqXlrUfErXy6qr0gLUKzaYSojKrvoil8UWy4qwJkdV4vn
        eP84gLsa0zmG+ZgqnJ5SutjLdLhuV/UraS0K1z/Vzg6KdJfdwpDv//JjRYtNCmkC
        CETvOc7D77HhSoujAJbDdKJOp5hVLxB/F0tgbmlEitEekkMSN8ZaH4Z9SBqkYE/K
        unFKyQB+Cvj+ldTlY/V+ic/kDJRNvQ5mlr4MLoaeeh1+zfGXO0xZRio4SPmDjzks
        wLbNkZXJaRW0n9Bw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7db949a5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 23 Dec 2020 14:24:35 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id a16so14747620ybh.5;
        Wed, 23 Dec 2020 06:33:07 -0800 (PST)
X-Gm-Message-State: AOAM532iUhGsJx2fpR7HHDz7Ku8oJQ+rzudBOoDt2fggfhA8GBwebKFk
        g+jPWsevxS4EAL1Ai2usJUcuRrwW5d0+HCJj4p0=
X-Google-Smtp-Source: ABdhPJw7i8d5iEIXttO/QVmZY12Qr9HAJyMwlDNwLzajdLyZHEmgxeBea/AGlLWEmrAt/27a69foGdtbtoXFZCLvBzg=
X-Received: by 2002:a5b:78d:: with SMTP id b13mr36070834ybq.123.1608733985640;
 Wed, 23 Dec 2020 06:33:05 -0800 (PST)
MIME-Version: 1.0
References: <20201130151231.GA24862@lst.de> <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
 <20201130165339.GE5364@mit.edu> <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
 <20201218132519.kj3nz7swsx7vvlr5@valinor.lan> <20201223132851.55d19271@blackhole.lan>
 <20201223151014.57caf98b@ezekiel.suse.cz>
In-Reply-To: <20201223151014.57caf98b@ezekiel.suse.cz>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 23 Dec 2020 15:32:55 +0100
X-Gmail-Original-Message-ID: <CAHmME9ooV1HRGO4bLsNKqv1EjDsUYsM6TcMbmEL=4CejTB+1ZQ@mail.gmail.com>
Message-ID: <CAHmME9ooV1HRGO4bLsNKqv1EjDsUYsM6TcMbmEL=4CejTB+1ZQ@mail.gmail.com>
Subject: Re: drivers/char/random.c needs a (new) maintainer
To:     Petr Tesarik <ptesarik@suse.cz>
Cc:     Torsten Duwe <duwe@lst.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Willy Tarreau <w@1wt.eu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        And y Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, simo@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 23, 2020 at 3:17 PM Petr Tesarik <ptesarik@suse.cz> wrote:
> Upfront, let me admit that SUSE has a vested interest in a FIPS-certifiable Linux kernel.

Sorry, but just because you have a "vested interest", or a financial
interest, or because you want it does not suddenly make it a good
idea. The idea is to have good crypto, not to merely check some boxes
for the bean counters.

For example, it's very unlikely that future kernel RNGs will move to
using AES, due to the performance overhead involved on non-table-based
implementations, and the lack of availability of FPU/AES-NI in all the
contexts we need. NT's fortuna machine can use AES, because NT allows
the FPU in all contexts. We don't have that luxury (or associated
performance penalty).

I would, however, be interested in a keccak-based construction. But
just using the keccak permutation does not automatically make it
"SHA-3", so we're back at the same issue again. FIPS is simply not
interesting for our requirements.

Jason
