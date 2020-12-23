Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D986C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 16:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2317A22AAF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 16:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgLWQNX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 11:13:23 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:43381 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgLWQNX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 11:13:23 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3f69d1df;
        Wed, 23 Dec 2020 16:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=23j/ro/omc+K4mkuzhNgYX2FZxM=; b=On/eTE
        gPYJkYIs2BR/TqifUzqYEOfJwbLiyGYyr7xqE+nL5nuLFIGZ5Q/iP6IiNoYgr6JC
        GXfdxMRa3ZpzwFDQQG667xD3DqKS2KMMT8WOebkeU/iU/xuo3iZgdi5VXZESwXmu
        fxqk2CeDJKwmYfi3nXHnWpvFvf/gxf4w9zmJWCzSB4xGfyZwKHkR6+Qqta1ZW+Fw
        C//zU+TE5FyRGt3LUtIxH+9YF+X0k1HdqLMrK033YbUpySdh9a/vykTDT8F6bcfB
        bqfUXcu/OjhuGJ4p0MXKpdXHXIeAp2vHbZvATPImMSw1hYd9xiro6QcsYPjtvBA6
        LmOxDHoUBdmdFj0w==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2312aa93 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 23 Dec 2020 16:04:06 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id v67so30855ybi.1;
        Wed, 23 Dec 2020 08:12:38 -0800 (PST)
X-Gm-Message-State: AOAM532DKmS7rL6jrRnvcv08eabGbDGSYPjz3oPXjos8BymlQC7GzbEP
        OD78+EQJkdiaeSMXqFZ+GKSlwuR8wfWOSz5r1bU=
X-Google-Smtp-Source: ABdhPJxDWhGj7/8vz7+ShPV+WT7rQZnLHkriPqtBNsJmX+vTPV/r2/2yNJUrZAkKoMNR4Ffaps9YGnbbDMhR3Kx6W+M=
X-Received: by 2002:a5b:78d:: with SMTP id b13mr36642356ybq.123.1608739957120;
 Wed, 23 Dec 2020 08:12:37 -0800 (PST)
MIME-Version: 1.0
References: <20201130151231.GA24862@lst.de> <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
 <20201130165339.GE5364@mit.edu> <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
 <20201218132519.kj3nz7swsx7vvlr5@valinor.lan> <20201223132851.55d19271@blackhole.lan>
 <20201223151014.57caf98b@ezekiel.suse.cz> <CAHmME9ooV1HRGO4bLsNKqv1EjDsUYsM6TcMbmEL=4CejTB+1ZQ@mail.gmail.com>
 <20201223170057.7c8fd710@ezekiel.suse.cz> <CAHmME9oE4sHC2hxMYFRz1xFMTKxBJub74Tka6KkfYOUfMjLSUA@mail.gmail.com>
In-Reply-To: <CAHmME9oE4sHC2hxMYFRz1xFMTKxBJub74Tka6KkfYOUfMjLSUA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 23 Dec 2020 17:12:26 +0100
X-Gmail-Original-Message-ID: <CAHmME9oDA1ch3_3EdVhEHAE5Rk7QxMwS8g9e87aet_8ohEJ3Gw@mail.gmail.com>
Message-ID: <CAHmME9oDA1ch3_3EdVhEHAE5Rk7QxMwS8g9e87aet_8ohEJ3Gw@mail.gmail.com>
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

On Wed, Dec 23, 2020 at 5:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Peter,
>
> On Wed, Dec 23, 2020 at 5:01 PM Petr Tesarik <ptesarik@suse.cz> wrote:
> > I never suggested that this should serve as a supportive argument. I was just trying to be honest about our motivations.
> >
> > I'm a bit sad that this discussion has quickly gone back to the choice of algorithms and how they can be implemented.
>
> Why are you sad? You are interested in FIPS. FIPS indicates a certain
> set of algorithms. The ones most suitable to the task seem like they'd
> run into real practical problems in the kernel's RNG.
>
> That's not the _only_ reason I'm not keen on FIPS, but it does seem
> like a very basic one.
>
> Jason

And just to add to that: in working through Nicholai's patches (an
ongoing process), I'm reminded of his admonishment in the 00 cover
letter that at some point chacha20 will have to be replaced, due to
FIPS. So it seems like that's very much on the table. I brought it up
here as an example ("For example, " is how I began that sentence), but
it is a concern. If you want to make lots of changes for cryptographic
or technical reasons, that seems like a decent way to engage. But if
the motivation for each of these is the bean counting, then again, I'm
pretty wary of churn for nothing. And if that bean counting will
eventually lead us into bad corners, like the concerns I brought up
about FPU usage in the kernel, then I'm even more hesitant. However, I
think there may be good arguments to be made that some of Nicholai's
patches stand on their own, without the FIPS motivation. And that's
the set of arguments that are compelling.

Jason
