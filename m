Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34287C4363D
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 17:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D11CE23600
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 17:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIVRto (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:49:44 -0400
Received: from verein.lst.de ([213.95.11.211]:45712 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbgIVRto (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 13:49:44 -0400
Received: by verein.lst.de (Postfix, from userid 107)
        id 8B2AD68AFE; Tue, 22 Sep 2020 19:49:41 +0200 (CEST)
Received: from blackhole.lan (p5b33f9ec.dip0.t-ipconnect.de [91.51.249.236])
        by verein.lst.de (Postfix) with ESMTPSA id AD5CC67357;
        Tue, 22 Sep 2020 19:48:56 +0200 (CEST)
Date:   Tue, 22 Sep 2020 19:48:49 +0200
From:   Torsten Duwe <duwe@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stephan Mueller <smueller@chronox.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Nicolai Stange <nstange@suse.de>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
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
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
Message-ID: <20200922194849.12d2c8ae@blackhole.lan>
In-Reply-To: <20200922162152.GB2299429@kroah.com>
References: <20200921075857.4424-1-nstange@suse.de>
        <8618155.4vTCxPXJkl@tauon.chronox.de>
        <20200922132344.GA2728@lst.de>
        <20200922162152.GB2299429@kroah.com>
Organization: LST e.V.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 22 Sep 2020 18:21:52 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Tue, Sep 22, 2020 at 03:23:44PM +0200, Torsten Duwe wrote:
> > On Mon, Sep 21, 2020 at 10:40:37AM +0200, Stephan Mueller wrote:
> > > Am Montag, 21. September 2020, 09:58:16 CEST schrieb Nicolai
> > > Stange:
> > > 
> > > > - people dislike the approach of having two competing
> > > > implementations for what is basically the same functionality in
> > > > the kernel.
> > > 
> > > Is this really so bad considering the security implications on
> > > this topic? We also have multiple file systems, multiple memory
> > > allocators, etc...
> > 
> > Exactly. I thought Linux was about the freedom of choice.
> 
> http://www.islinuxaboutchoice.com/
> 
> :)

Talk is cheap.

gzip -dc /proc/config.gz | wc -l
9789

:-P
	Torsten
