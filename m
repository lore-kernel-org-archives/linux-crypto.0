Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0C4C4363D
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 10:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D691B20870
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 10:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgJGKiP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Oct 2020 06:38:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:59692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgJGKiP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Oct 2020 06:38:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E3F07B2F3;
        Wed,  7 Oct 2020 10:38:12 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Torsten Duwe <duwe@lst.de>, "Theodore Y.  Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
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
        Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST SP800-90B compliance
References: <20200921075857.4424-1-nstange@suse.de>
        <20201002123836.GA14807@lst.de> <20201007042409.GE912@sol.localdomain>
Date:   Wed, 07 Oct 2020 12:38:10 +0200
In-Reply-To: <20201007042409.GE912@sol.localdomain> (Eric Biggers's message of
        "Tue, 6 Oct 2020 21:24:09 -0700")
Message-ID: <87pn5upbhp.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> On Fri, Oct 02, 2020 at 02:38:36PM +0200, Torsten Duwe wrote:
>>
>> Would some maintainer please comment on potential problems or
>> shortcomings?
>> 
>
> Well, very people are experts in the Linux RNG *and* have time to review large
> patchsets, especially when three people are all proposing conflicting changes.
> And those that might be able to review these patches aren't necessarily
> interested in compliance with particular government standards.

To make it clear: I'm personally not really enthusiastic about some of
the restrictions imposed by SP800-90 either and Jason certainly has a
point with his concerns about "subpar crypto" ([1]). However, at the
same time I'm acknowledging that for some users FIPS compliance is
simply a necessity and I don't see a strong reason why that shouldn't be
supported, if doable without negatively affecting !fips_enabled users.


> Note that having multiple RNG implementations would cause fragmentation, more
> maintenance burden, etc.  So IMO, that should be a last resort.  Instead we
> should try to find an implementation that works for everyone.  I.e., at least to
> me, Nicolai's patchset seems more on the right track than Stephan's patchset...

I suppose that this concern about fragmentation is among the main
reasons for reservations against Stephan's LRNG patchset and that's why
I posted this RFC series here for comparison purposes. But note that, as
said ([2]), it's incomplete and the only intent was to provide at least
a rough idea on what it would take to move the current /dev/random
implementation towards SP800-90 -- I was hoping for either a hard NACK
or something along the lines of "maybe, go ahead and let's see".


> However, not everyone cares about "compliance".  So any changes for "compliance"
> either need to have a real technical argument for making the change, *or* need
> to be optional (e.g. controlled by fips_enabled).

Fully agreed.


> AFAICS, this patchset mostly just talks about NIST SP800-90B compliance, and
> doesn't make clear whether the changes make the RNG better, worse, or the same
> from an actual technical perspective.
>
> If that was properly explained, and if the answer was "better" or at least
> "not worse", I expect that people would be more interested.

The goal was not to negatively affect !fips_enabled users, but as
outlined in the cover letter ([2]), a performance impact had been
measured on ARMv7. This probably isn't something which couldn't get
sorted out, but I see no point in doing it at this stage, because
- there's still quite some stuff missing for full SP800-90 compliance
  anyway, c.f. the overview at the end of [2] and
- such optimizations would have bloated this patchset even more,
  e.g. for making fips_enabled a static_key, which should certainly go
  into a separate series.

User visible effects set aside, an obvious downside of SP800-90
compliance would be the increase in code size and the associated
maintenance burden.

That being said, I can imagine that those boot health tests could also
get enabled for !fips_enabled users in the future, if wanted: rather
than inhibiting /dev/random output on failure, a warning would get
logged instead.  Whether or not this would be seen as an improvement
is for others to judge though.

Thanks,

Nicolai


[1] https://lkml.kernel.org/r/CAHmME9rMXORFXtwDAc8yxj+h9gytJj6DpvCxA-JMAAgyOP+5Yw@mail.gmail.com
[2] https://lkml.kernel.org/r/20200921075857.4424-1-nstange@suse.de

-- 
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg), GF: Felix Imendörffer
