Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D82C4363C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 04:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2B89214DB
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 04:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602044653;
	bh=HNZgGw5t+zku3ew40cODLileKIhXkp3jSljN6AT8TLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1VoydaNxc5RIhh9/LJIgRFzvt0asokOwpHuWJZYAUDXQMZg+zttx31JGT91MC98ig
	 Ik2UXzzWNrmtyo3LF230JjJbxjKtDhM1ehHLDLVxgHo1Lt5j2/LeA0t9a9KvLhPGjS
	 /0moup93tPcgo4RWpt+n2VieFKkL5nlxySVIARvU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgJGEYN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Oct 2020 00:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJGEYM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Oct 2020 00:24:12 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FAA1208C7;
        Wed,  7 Oct 2020 04:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602044652;
        bh=HNZgGw5t+zku3ew40cODLileKIhXkp3jSljN6AT8TLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=errdOSLLvUuLmIJhiUvORHXPdy4e8M12nUcZNwbqksJZ3hgZcLzDnSs0aVX+gGbxw
         +Oo9U1uMWXrUFFXkGuerRU9SciMb7timjw/YOzmep2l/jRWADGaQJG8q0kko6KBVc3
         OCklyThqJpOyLH+hiRL7yjaC19diNIqmaeAL0xa8=
Date:   Tue, 6 Oct 2020 21:24:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Torsten Duwe <duwe@lst.de>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        Nicolai Stange <nstange@suse.de>,
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
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
Message-ID: <20201007042409.GE912@sol.localdomain>
References: <20200921075857.4424-1-nstange@suse.de>
 <20201002123836.GA14807@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002123836.GA14807@lst.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 02, 2020 at 02:38:36PM +0200, Torsten Duwe wrote:
> Almost two weeks passed and these are the "relevant" replies:
> 
> Jason personally does not like FIPS, and is afraid of
> "subpar crypto". Albeit this patch set strictly isn't about
> crypto at all; the crypto subsystem is in the unlucky position
> to just depend on a good entropy source.
> 
> Greg claims that Linux (kernel) isn't about choice, which is clearly
> wrong.
> 
> And this is all ???
> 
> There are options for stack protection. I can see bounds checking
> and other sanity checks all over the place. And doing a similar thing
> on entropy sources is a problem?
> 
> Admittedly, if entropy sources fail, the kernel will happily remain
> running. No bad immediate effects in userland will arise. Only some
> cryptographic algorithms, otherwise very decent, will run on
> unneccessarily weak keys, probably causing some real-world problems.
> Does anybody care?
> The NIST and the BSI do, but that does not mean their solutions are
> automatically wrong or backdoored.
> 
> There is now a well layed-out scheme to ensure quality randomness,
> and a lot of work here has been put into its implementation.
> 
> Would some maintainer please comment on potential problems or
> shortcomings? Otherwise a "Thanks, applied" would be appropriate, IMO.
> 

Well, very people are experts in the Linux RNG *and* have time to review large
patchsets, especially when three people are all proposing conflicting changes.
And those that might be able to review these patches aren't necessarily
interested in compliance with particular government standards.

Note that having multiple RNG implementations would cause fragmentation, more
maintenance burden, etc.  So IMO, that should be a last resort.  Instead we
should try to find an implementation that works for everyone.  I.e., at least to
me, Nicolai's patchset seems more on the right track than Stephan's patchset...

However, not everyone cares about "compliance".  So any changes for "compliance"
either need to have a real technical argument for making the change, *or* need
to be optional (e.g. controlled by fips_enabled).

AFAICS, this patchset mostly just talks about NIST SP800-90B compliance, and
doesn't make clear whether the changes make the RNG better, worse, or the same
from an actual technical perspective.

If that was properly explained, and if the answer was "better" or at least
"not worse", I expect that people would be more interested.

- Eric
