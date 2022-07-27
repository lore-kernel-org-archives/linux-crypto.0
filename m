Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA7AC04A68
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jul 2022 21:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiG0V7y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Jul 2022 17:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiG0V7y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Jul 2022 17:59:54 -0400
Received: from brightrain.aerifal.cx (brightrain.aerifal.cx [216.12.86.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A294D830
        for <linux-crypto@vger.kernel.org>; Wed, 27 Jul 2022 14:59:52 -0700 (PDT)
Date:   Wed, 27 Jul 2022 17:59:49 -0400
From:   Rich Felker <dalias@libc.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        Michael@phoronix.com, linux-crypto@vger.kernel.org, jann@thejh.net
Subject: Re: arc4random - are you sure we want these?
Message-ID: <20220727215949.GM7074@brightrain.aerifal.cx>
References: <20220725153303.GF7074@brightrain.aerifal.cx>
 <878rohp2ll.fsf@oldenburg.str.redhat.com>
 <20220725174430.GI7074@brightrain.aerifal.cx>
 <CAPBLoAe89Pwt=F_jcZirVXQA7JtugV+5+BWHBt0RaZka1y0K=g@mail.gmail.com>
 <20220725184929.GJ7074@brightrain.aerifal.cx>
 <YuCa1lDqoxdnZut/@mit.edu>
 <a5b6307d-6811-61b6-c13d-febaa6ad1e48@linaro.org>
 <YuEwR0bJhOvRtmFe@mit.edu>
 <87v8rid8ju.fsf@oldenburg.str.redhat.com>
 <YuGc3O88Zxb5HkxY@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuGc3O88Zxb5HkxY@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 27, 2022 at 04:15:24PM -0400, Theodore Ts'o via Libc-alpha wrote:
> On Wed, Jul 27, 2022 at 02:49:57PM +0200, Florian Weimer wrote:
> > * Theodore Ts'o:
> > 
> > > But even if you didn't take the latest kernels, I think you will find
> > > that if you actually benchmark how many queries per second a real-life
> > > secure web server or VPN gateway, even the original 5.15.0 /dev/random
> > > driver was plenty fast enough for real world cryptographic use cases.
> > 
> > The idea is to that arc4random() is suitable in pretty much all places
> > that have historically used random() (outside of deterministic
> > simulations).  Straight calls to getrandom are much, much slower than
> > random(), and it's not even the system call overhead.
> 
> What are those places?  And what are their performance and security
> requirements?  I've heard some people claim that arc4random() is
> supposed to provide strong security guarantees.  I've heard others
> claim that it doesn't, or at least glibc was planning on disclaiming
> security guaranteees.  So there seems to be a lack of clarity about
> the security requirements.

The only place I've heard of a viable "soft requirement" for real
entropy is for salting the hash function used in hash table maps to
harden them against DoS via intentional collisions. This is a small
but arguably legitimate usage domain. Most use of random() is not
this, and should not be this -- the value of deterministic execution
for ability to reproduce crashes, debug, etc. is real, and the value
of actual entropy vs a deterministic-seeded prng is imaginary.

The purpose of arc4random has always been *cryptographically secure*
entropy, not "gratuitously replace random() and break reproducible
behavior because the programmer does not understand the difference".
Nobody should be advocating for using these functions for anything
except secure secrets.

Rich
