Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89CA4C64E8A
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 15:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3421220725
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 15:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgK3PNQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Nov 2020 10:13:16 -0500
Received: from verein.lst.de ([213.95.11.211]:44748 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbgK3PNQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Nov 2020 10:13:16 -0500
Received: by verein.lst.de (Postfix, from userid 2005)
        id 3702A6736F; Mon, 30 Nov 2020 16:12:32 +0100 (CET)
Date:   Mon, 30 Nov 2020 16:12:32 +0100
From:   Torsten Duwe <duwe@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>,
        Willy Tarreau <w@1wt.eu>, linux-crypto@vger.kernel.org,
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
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        And y Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>, ardb@kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>, simo@redhat.com
Subject: drivers/char/random.c needs a (new) maintainer
Message-ID: <20201130151231.GA24862@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus!

AFAIK it's legit to bother you directly with issues like this one?

I see certifications as the mere messengers here which tell us that
our /dev/random is technologically outdated. Input entropy amounts are
guesstimated in advance, obviously much too conservatively, compiled in
and never checked thereafter; the whitening is done using some home-
grown hash function derivative and other non-cryptographic, non-standard
operations.

All of this does not affect the Linux kernel directly, it will compile
happily, and will run smoothly with all given crypto apps. Only new
crypto keys are generated slower than necessary or, much worse, might
contain less entropy than required because something broke down
unnoticed.  In that case, problems would arise only much later, but in
the real world and with much graver impact. I would rather like to see
the Linux /dev/random being reliable, whether certified or not. If it
provided that reliable entropy fast that would be even cooler. If it
was at least possible to get approval from a standardization body
(without forcing this onto all users, of course) that would be optimal.

Meanwhile there's quite a maintenance backlog; minor fixes are
pending, medium-sized cleanups are ignored and major patch sets to add
the missing features are not even discussed. (I'm deliberately not
including links here to avoid excessive finger pointing.)

I'd like to believe that Ted is too busy working on ext4, but,
especially on explicit request, a "hold on, I'm busy, will get at it
later" or "right, someone wants to take over?" would be appropriate
IMHO. It is also not helpful to object to or ignore all changes which
might benefit certifications just for that sole reason and because of
personal aversion. No reply at all yields exactly the same result as
having no maintainer at all, hence the subject.

Could you please try to get a definite answer from him? I know there
is at least one person (probably more) with enough enthusiasm and
expertise who would happily take over, should that turn out to be a
problem.

Thanks,

	Torsten

