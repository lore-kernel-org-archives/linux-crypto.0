Return-Path: <SRS0=zC9F=ED=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51F3C4363A
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Oct 2020 21:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54F6421582
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Oct 2020 21:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603921348;
	bh=diRpUytNGr4vcLPj80uDkTMwdSI1HzXRNGWbFmZNeE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=oilMlGyBhajF5TBxGO8tmXp3buzZSVKSRub/9B2BZ+synCvbceq6yzFhekYq6xPk9
	 xtYZOUkcxpMCJ0yHKKyonzJThyMgGQoeO/uH7aVy6OqmdxTC9mIjRXjdCQhmqJ2mSt
	 n51dSW9VJaRTZewjVPo2PtjuWy95oBRcA6iYjw9M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgJ1Vm1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgJ1VmZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Oct 2020 17:42:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4916124804;
        Wed, 28 Oct 2020 18:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603908397;
        bh=diRpUytNGr4vcLPj80uDkTMwdSI1HzXRNGWbFmZNeE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L1PUX5qJV3wrtoiw3Awx/J+kAC9EjUHUAglD5hffuzyV53Hpkp+mPkP+JXr35QK7c
         4jcgeKlnR1Uz4YpSQXrMBKUV/1DYWtIJ6C5d2/4Y76zd20lMFTX47E16FohUOYzfWs
         32G2AlRPxoQEZu2HTsTdMnRz/0KmfVzygY7KSfEI=
Date:   Wed, 28 Oct 2020 19:07:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Torsten Duwe <duwe@lst.de>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
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
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>, simo@redhat.com
Subject: Re: [PATCH v36 00/13] /dev/random - a new approach
Message-ID: <20201028180728.GA2831268@kroah.com>
References: <20200921075857.4424-1-nstange@suse.de>
 <2961243.vtBmWVcJkq@tauon.chronox.de>
 <20201016172619.GA18410@lst.de>
 <3073852.aeNJFYEL58@positron.chronox.de>
 <20201028185117.74300988@blackhole.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201028185117.74300988@blackhole.lan>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 28, 2020 at 06:51:17PM +0100, Torsten Duwe wrote:
> On Mon, 19 Oct 2020 21:28:50 +0200
> Stephan Müller <smueller@chronox.de> wrote:
> [...]
> > * Sole use of crypto for data processing:
> [...]
> >  - The LRNG uses only properly defined and implemented cryptographic
> >    algorithms unlike the use of the SHA-1 transformation in the
> > existing /dev/random implementation.
> > 
> >  - Hash operations use NUMA-node-local hash instances to benefit large
> >    parallel systems.
> > 
> >  - LRNG uses limited number of data post-processing steps
> [...]
> > * Performance
> > 
> >  - Faster by up to 75% in the critical code path of the interrupt
> > handler depending on data collection size configurable at kernel
> > compile time - the default is about equal in performance with
> > existing /dev/random as outlined in [2] section 4.2.
> 
> [...]
> >  - ChaCha20 DRNG is significantly faster as implemented in the
> > existing /dev/random as demonstrated with [2] table 2.
> > 
> >  - Faster entropy collection during boot time to reach fully seeded
> >    level, including on virtual systems or systems with SSDs as
> > outlined in [2] section 4.1.
> > 
> > * Testing
> [...]
> 
> So we now have 2 proposals for a state-of-the-art RNG, and over a month
> without a single comment on-topic from any `get_maintainer.pl`
> 
> I don't want to emphasise the certification aspects so much. The
> interrelation is rather that those certifications require certain code
> features, features which are reasonable per se. But the current code is
> lagging way behind.
> 
> I see the focus namely on performance, scalability, testability and
> virtualisation. And it certainly is an advantage to use the code
> already present under crypto, with its optimisations, and not rely
> on some home brew.
> 
> Can we please have a discussion about how to proceed?
> Ted, Greg, Arnd: which approach would you prefer?

Greg and Arnd are not the random driver maintainers, as is now correctly
shown in the 5.10-rc1 MAINTAINERS file, so I doubt we (well at least I)
have any say here, sorry.

good luck!

greg k-h
