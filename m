Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDF3C2D0E2
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 13:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05EBA239A1
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 13:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgIVNXv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 09:23:51 -0400
Received: from verein.lst.de ([213.95.11.211]:44626 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgIVNXv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 09:23:51 -0400
Received: by verein.lst.de (Postfix, from userid 2005)
        id A38CE68B02; Tue, 22 Sep 2020 15:23:45 +0200 (CEST)
Date:   Tue, 22 Sep 2020 15:23:44 +0200
From:   Torsten Duwe <duwe@lst.de>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Nicolai Stange <nstange@suse.de>, linux-crypto@vger.kernel.org,
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
        Roman Drahtmueller <draht@schaltsekun.de>,
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
Message-ID: <20200922132344.GA2728@lst.de>
References: <20200921075857.4424-1-nstange@suse.de> <8618155.4vTCxPXJkl@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8618155.4vTCxPXJkl@tauon.chronox.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 21, 2020 at 10:40:37AM +0200, Stephan Mueller wrote:
> Am Montag, 21. September 2020, 09:58:16 CEST schrieb Nicolai Stange:
> 
> > - people dislike the approach of having two competing implementations for
> >   what is basically the same functionality in the kernel.
> 
> Is this really so bad considering the security implications on this topic? We 
> also have multiple file systems, multiple memory allocators, etc...

Exactly. I thought Linux was about the freedom of choice. Some people choose
to get a FIPS certification for their Linux-based products, which mostly
means to restrict crypto capabilities to an "allowed" set, granted. But in
this case people might opt for some sort of "entropy QA". I find it hard to
accept that this option is suppressed, especially if it's because of personal
antipathy of the maintainer about the origin of this change and not for
technical reasons. Restrictions on cryptographic functionality are ok, but
health tests on entropy sources are not?

I do understand people's reluctance after the dual-ECC DRBG desaster, but
OTOH SElinux is generally considered an improvement. Definitely not
everything coming from that direction is tainted.

A big portion of this patch set is cleanup, another one said introduction of
entropy source monitoring. This is important, no matter what your attitude
towards certifications might be.

	Torsten

