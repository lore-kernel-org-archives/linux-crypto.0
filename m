Return-Path: <SRS0=z7PZ=EE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF52C388F7
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Oct 2020 00:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADF02207DE
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Oct 2020 00:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388468AbgJ2AXt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Oct 2020 20:23:49 -0400
Received: from verein.lst.de ([213.95.11.211]:45358 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388466AbgJ1Wh2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Oct 2020 18:37:28 -0400
Received: by verein.lst.de (Postfix, from userid 107)
        id 9202368C65; Wed, 28 Oct 2020 18:52:06 +0100 (CET)
Received: from blackhole.lan (p5b33f9d6.dip0.t-ipconnect.de [91.51.249.214])
        by verein.lst.de (Postfix) with ESMTPSA id 73EA367357;
        Wed, 28 Oct 2020 18:51:22 +0100 (CET)
Date:   Wed, 28 Oct 2020 18:51:17 +0100
From:   Torsten Duwe <duwe@lst.de>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Stephan =?UTF-8?B?TcO8bGxlcg==?= <smueller@chronox.de>,
        Willy Tarreau <w@1wt.eu>, linux-crypto@vger.kernel.org,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>, marcelo.cerri@canonical.com,
        simo@redhat.com
Subject: Re: [PATCH v36 00/13] /dev/random - a new approach
Message-ID: <20201028185117.74300988@blackhole.lan>
In-Reply-To: <3073852.aeNJFYEL58@positron.chronox.de>
References: <20200921075857.4424-1-nstange@suse.de>
        <2961243.vtBmWVcJkq@tauon.chronox.de>
        <20201016172619.GA18410@lst.de>
        <3073852.aeNJFYEL58@positron.chronox.de>
Organization: LST e.V.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 19 Oct 2020 21:28:50 +0200
Stephan Müller <smueller@chronox.de> wrote:
[...]
> * Sole use of crypto for data processing:
[...]
>  - The LRNG uses only properly defined and implemented cryptographic
>    algorithms unlike the use of the SHA-1 transformation in the
> existing /dev/random implementation.
> 
>  - Hash operations use NUMA-node-local hash instances to benefit large
>    parallel systems.
> 
>  - LRNG uses limited number of data post-processing steps
[...]
> * Performance
> 
>  - Faster by up to 75% in the critical code path of the interrupt
> handler depending on data collection size configurable at kernel
> compile time - the default is about equal in performance with
> existing /dev/random as outlined in [2] section 4.2.

[...]
>  - ChaCha20 DRNG is significantly faster as implemented in the
> existing /dev/random as demonstrated with [2] table 2.
> 
>  - Faster entropy collection during boot time to reach fully seeded
>    level, including on virtual systems or systems with SSDs as
> outlined in [2] section 4.1.
> 
> * Testing
[...]

So we now have 2 proposals for a state-of-the-art RNG, and over a month
without a single comment on-topic from any `get_maintainer.pl`

I don't want to emphasise the certification aspects so much. The
interrelation is rather that those certifications require certain code
features, features which are reasonable per se. But the current code is
lagging way behind.

I see the focus namely on performance, scalability, testability and
virtualisation. And it certainly is an advantage to use the code
already present under crypto, with its optimisations, and not rely
on some home brew.

Can we please have a discussion about how to proceed?
Ted, Greg, Arnd: which approach would you prefer?

	Torsten

