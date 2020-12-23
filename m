Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00F2C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 12:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AFC32246B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 12:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgLWMa2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 07:30:28 -0500
Received: from verein.lst.de ([213.95.11.211]:34298 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgLWMa2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 07:30:28 -0500
Received: by verein.lst.de (Postfix, from userid 107)
        id 5E81F68B02; Wed, 23 Dec 2020 13:29:46 +0100 (CET)
Received: from blackhole.lan (p5b33f4d5.dip0.t-ipconnect.de [91.51.244.213])
        by verein.lst.de (Postfix) with ESMTPSA id 7358267357;
        Wed, 23 Dec 2020 13:28:52 +0100 (CET)
Date:   Wed, 23 Dec 2020 13:28:51 +0100
From:   Torsten Duwe <duwe@lst.de>
To:     Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephan =?UTF-8?B?TcO8bGxlcg==?= <smueller@chronox.de>,
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
        Ard Biesheuvel <ardb@kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>, simo@redhat.com
Subject: Re: drivers/char/random.c needs a (new) maintainer
Message-ID: <20201223132851.55d19271@blackhole.lan>
In-Reply-To: <20201218132519.kj3nz7swsx7vvlr5@valinor.lan>
References: <20201130151231.GA24862@lst.de>
        <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
        <20201130165339.GE5364@mit.edu>
        <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
        <20201218132519.kj3nz7swsx7vvlr5@valinor.lan>
Organization: LST e.V.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 18 Dec 2020 10:25:19 -0300
Marcelo Henrique Cerri <marcelo.cerri@canonical.com> wrote:

> Hi, Ted and Jason.
> 
> Any updates on that?
> 
> I don't believe Torsten's concerns are simply about *applying* patches
> but more about these long periods of radio silence. That kills

Exactly. I could live with replies in the style of "old" Linus like:
"Your code is crap, because it does X and Y". Then I knew how to
proceed. But this extended silence slows things down a lot.

> collaboration and disengage people. More than simply reviewing patches
> I would expect a maintainer to give directions and drive the
> community. Asking Jason to review Nicolai's patches was a step towards
> that, but I believe we still could benefit from better communication.

Even regarding this I'm not so sure it was a good idea. Jason seems to
narrow the proposed changes down to "FIPS certification", when it
actually is a lot more. I think his motivation suffers because of his
personal dislike.

> Besides Nicolai's RFC, are you also planning to take another look at
> Stephan's patches?

Yes, please advise! For important, major changes the maintainer should
ping the contributors, not vice versa. Not even to mention the bunch of
minor changes pending, some even acked by independent developers.

	Torsten
