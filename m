Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24AFC4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 12:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B92F20719
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 12:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgJBMjV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 08:39:21 -0400
Received: from verein.lst.de ([213.95.11.211]:52210 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBMjV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 08:39:21 -0400
Received: by verein.lst.de (Postfix, from userid 107)
        id 258BB68C4E; Fri,  2 Oct 2020 14:39:19 +0200 (CEST)
Received: from lst.de (p5b0d8779.dip0.t-ipconnect.de [91.13.135.121])
        by verein.lst.de (Postfix) with ESMTPSA id 90E8467354;
        Fri,  2 Oct 2020 14:38:40 +0200 (CEST)
Date:   Fri, 2 Oct 2020 14:38:36 +0200
From:   Torsten Duwe <duwe@lst.de>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-crypto@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
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
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
Message-ID: <20201002123836.GA14807@lst.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Almost two weeks passed and these are the "relevant" replies:

Jason personally does not like FIPS, and is afraid of
"subpar crypto". Albeit this patch set strictly isn't about
crypto at all; the crypto subsystem is in the unlucky position
to just depend on a good entropy source.

Greg claims that Linux (kernel) isn't about choice, which is clearly
wrong.

And this is all ???

There are options for stack protection. I can see bounds checking
and other sanity checks all over the place. And doing a similar thing
on entropy sources is a problem?

Admittedly, if entropy sources fail, the kernel will happily remain
running. No bad immediate effects in userland will arise. Only some
cryptographic algorithms, otherwise very decent, will run on
unneccessarily weak keys, probably causing some real-world problems.
Does anybody care?
The NIST and the BSI do, but that does not mean their solutions are
automatically wrong or backdoored.

There is now a well layed-out scheme to ensure quality randomness,
and a lot of work here has been put into its implementation.

Would some maintainer please comment on potential problems or
shortcomings? Otherwise a "Thanks, applied" would be appropriate, IMO.

	Torsten

