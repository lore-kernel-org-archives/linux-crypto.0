Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2BDC433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 08:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F015B207C5
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 08:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbhAHInF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 03:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbhAHInE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 03:43:04 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E7AC0612F5;
        Fri,  8 Jan 2021 00:42:24 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id 91so8172213wrj.7;
        Fri, 08 Jan 2021 00:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kM11/a2ZtU2lx1AuIWWMEnbQRiaILH2o+LlIumf/C84=;
        b=XXtL7fEu/Ksu0rrgZA5ERDrn+Xhf93wjnUy+qG0X+g8c2EunbEUC2d9qgohzewOTP+
         HAimR2Mk2dWpC0PwR1KnqMjyX/pMYeUgm6ZtTW/oA9je63niTNjKWAxO1Z8G8njrtxgT
         pSSvNSuNa2aeEJZLromj3Nk/Gmji9whB9aZ9209rMLgJBbUsiE4EEMjePV7iKOZwwdSp
         NDHTElADPBM0pTYcsneP+hxzx9zUoLoA8HhAffTvnglShXY5FDt3fvX8/phv1DrpgNYZ
         qpojvr7y3sC2hSZidhVNypZ06asusVm3KO86AmbbpvvD2vz12CogR992CpWYHflXDfUH
         FXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kM11/a2ZtU2lx1AuIWWMEnbQRiaILH2o+LlIumf/C84=;
        b=mQg8LPNOzkzLN4apyj/aAqtGu3Xmx79n6rN7m78d7RJy15RPMPbsIEoJmvWj9/uXak
         tx+E2z1Yquz/WaxrQVVyrGCW13QjIT+dQDzzu7sdaP8xA/8c4MHiYKaN8d1THR0HLSxK
         cHejDMGl0fcH5cSoglh1HiXAvfsTzJlfhUxnJAL0O/zk36aydNZUdFCOeRx8XoNmlF7e
         a2T1SGDbjHaCfG6VTBijEOtE07Y3mYXrKzWmf8kvA4N4Tk/FKprp4Ttk+Oq6Eroo+WcT
         wm/z/tLLKliQR5PpC1UQQgBBnCqf4DKuiApOulk3CoCETqevqW/AGYxfaPbRWqIRy83r
         fCSQ==
X-Gm-Message-State: AOAM530Xc3GMQXgaR/elmxT/9H57EeGxBGW/feh+leHVdqkrd8zHld0X
        If7xhesR/4V3Ujz95oMRVjhVu2C5cVpW3FURM7A=
X-Google-Smtp-Source: ABdhPJw3VWHrkBwWDmMELLOqnVEQrviRg3kFO5UETQiVyUdTvFBMQi7xzDd4+ApUwwsqUJNv4/EZQEwLQ5hYjmcgL4Q=
X-Received: by 2002:adf:f891:: with SMTP id u17mr2536046wrp.253.1610095343093;
 Fri, 08 Jan 2021 00:42:23 -0800 (PST)
MIME-Version: 1.0
References: <20201130151231.GA24862@lst.de> <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
 <20201130165339.GE5364@mit.edu> <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
 <20201218132519.kj3nz7swsx7vvlr5@valinor.lan> <20201223132851.55d19271@blackhole.lan>
 <20201223151014.57caf98b@ezekiel.suse.cz> <CAHmME9ooV1HRGO4bLsNKqv1EjDsUYsM6TcMbmEL=4CejTB+1ZQ@mail.gmail.com>
 <20201223170057.7c8fd710@ezekiel.suse.cz> <20201224191953.GD22388@amd>
In-Reply-To: <20201224191953.GD22388@amd>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Fri, 8 Jan 2021 16:42:11 +0800
Message-ID: <CACXcFmknEkN7YZrG3uU7Ty35SDxxCwTSU1HcePWCa=xyuUUH+w@mail.gmail.com>
Subject: Re: drivers/char/random.c needs a (new) maintainer
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Petr Tesarik <ptesarik@suse.cz>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Torsten Duwe <duwe@lst.de>,
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

Pavel Machek <pavel@ucw.cz> wrote:

> To play devil's advocate, does RNG subsystem need to evolve? Its task
> is to get random numbers. Does it fail at the task?
>
> Problem is, random subsystem is hard to verify, and big rewrite is
> likely to cause security problems...

Parts of the problem, though, are dead easy in many of today's
environments.

Many CPUs, e,g. Intel, have an instruction that gives random
numbers. Some systems have another hardware RNG. Some
can add one using a USB device or Denker's Turbid
(https://www.av8n.com/turbid/). Many Linux instances run on
VMs so they have an emulated HWRNG using the host's
/dev/random.

None of those is necessarily 100% trustworthy, though the
published analysis for Turbid & for (one version of) the Intel
device seem adequate to me. However, if you use any
of them to scribble over the entire 4k-bit input pool and/or
a 512-bit Salsa context during initialisation, then it seems
almost certain you'll get enough entropy to block attacks.

They are all dirt cheap so doing that, and using them
again later for incremental squirts of randomness, looks
reasonable.

In many cases you could go further. Consider a system
with an intel CPU and another HWRNG, perhaps a VM.
Get 128 bits from each source & combine them using
the 128-bit finite field multiplication from the GSM
authentication. Still cheap & it cannot be worse than
the better of the two sources. If both sources are
anywhere near reasonable, this should produce 128
bits of very high grade random material, cheaply.

I am not suggesting any of these should be used for
output, but using them for initialisation whenever
possible looks obvious to me.
