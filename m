Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FF9C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Mar 2022 18:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241899AbiCXSDP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Mar 2022 14:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiCXSDO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Mar 2022 14:03:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A30CB53C4;
        Thu, 24 Mar 2022 11:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49301B82403;
        Thu, 24 Mar 2022 18:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7551C340F0;
        Thu, 24 Mar 2022 18:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648144900;
        bh=6YSptuyb/nPo61g6P7HGPQKpojq+QMPFUW9m0WrmURE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vB1xjy2xksJGdNhsZR0L1pgmxXo9R8tXW74OtHNK7h+gkBp5baK3v3ClAUMBJcmtp
         nhPI7DgyPjCo3xuCaTuk10FG/mB3d95wy0lA/Zu6K9I1mB0rUabMlQG3YQUek0hDuF
         y1mLISX5G9gVpgTZVJ8ZgmcO0S7gFFNyLo70bGDRFn3RMYtU5ZhgL92H+SLwijt7k3
         vjj42dkriKs0ZX1OcaAf9K1TO8cYijldSr0pPtWRiriEDkLY+pzgH8JLDomFhXTBUm
         hsUrRDwXE+TlZ0mQNmiwV8s44dehEZKyCgTcwokvL76RRh7oaRnS+om9g41Tzg24TG
         GxzKWB01Xkmhg==
Date:   Thu, 24 Mar 2022 18:01:38 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] random: allow writes to /dev/urandom to influence fast
 init
Message-ID: <YjyyAm9pyOp9Fyqi@gmail.com>
References: <20220322191436.110963-1-Jason@zx2c4.com>
 <1648009787.fah6dos6ya.none@localhost>
 <CAHmME9rsvxczJrhPwRX6nyrh9NB2AuJqkEKrTLx-G-T1J6_czQ@mail.gmail.com>
 <7cde489e73c8448b95a1b7bc6ed1d75b@AcuMS.aculab.com>
 <CAHmME9rxV-WLBCGyMRwba_8nF_onRfBi0+-xz84-HLNfee=R3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rxV-WLBCGyMRwba_8nF_onRfBi0+-xz84-HLNfee=R3Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 01:53:03PM -0600, Jason A. Donenfeld wrote:
> Hi David,
> 
> On Wed, Mar 23, 2022 at 8:01 AM David Laight <David.Laight@aculab.com> wrote:
> >
> > From: Jason A. Donenfeld
> > > Sent: 23 March 2022 04:48
> > ...
> > > - Plenty of things are seeding the RNG correctly, and buildroot's
> > > shell script is just "doing it wrong".
> > >
> > > On that last point, I should reiterate that buildroot's shell script
> > > still isn't actually initializing the RNG, despite what it says in its
> > > echo; there's never been a way to initialize the RNG from a shell
> > > script, without calling out to various special purpose ioctl-aware
> > > binaries.
> >
> > Perhaps the very first write after boot could be assumed to
> > be valid initialisation data?
> > (On top of a few other tests.)
> 
> I addressed this already earlier. That approach does not work. Too
> many things already pass in garbage, not expecting for it to be
> credited, but just contributory. /dev/urandom writes simply has never
> had the semantics one would want for credited seeding. Adding a
> heuristic like this will break users.
> 

Just to give an example of this, one of the first things that Android does at
boot time is copy the kernel command line into /dev/urandom:
https://android.googlesource.com/platform/system/core/+/refs/heads/android12-release/rootdir/init.rc#122

It would certainly be undesirable if that started crediting entropy, given that
the command line might not contain much entropy, or any at all.

(And yes, copying the kernel command line into /dev/urandom is redundant in
kernels v4.14 and later due to https://git.kernel.org/linus/33d72f3822d7ff8a.
But this is going to be kept around for a while longer due to older kernels.)

- Eric
