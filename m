From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 3/8] random: trigger random_ready callback upon crng_init == 1
Date: Wed, 18 Jan 2017 18:09:14 +0100
Message-ID: <1721766.rHn5SRrCCO@tauon.atsec.com>
References: <3254875.f5A5oHPdxF@positron.chronox.de> <3576149.HSfW5KObBF@positron.chronox.de> <20170118041250.x7wszcasd4dplj3h@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55586 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750874AbdARRKL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2017 12:10:11 -0500
In-Reply-To: <20170118041250.x7wszcasd4dplj3h@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 17. Januar 2017, 23:12:50 CET schrieb Theodore Ts'o:

Hi Theodore,

> On Tue, Dec 27, 2016 at 11:39:57PM +0100, Stephan Müller wrote:
> > The random_ready callback mechanism is intended to replicate the
> > getrandom system call behavior to in-kernel users. As the getrandom
> > system call unblocks with crng_init == 1, trigger the random_ready
> > wakeup call at the same time.
> 
> It was deliberate that random_ready would only get triggered with
> crng_init==2.
> 
> In general I'm assuming kernel callers really want real randomness (as
> opposed to using prandom), where as there's a lot of b.s. userspace
> users of kernel randomness (for things that really don't require
> cryptographic randomness, e.g., for salting Python dictionaries,
> systemd/udev using /dev/urandom for non-cryptographic, non-security
> applications etc.)

Users of getrandom want to ensure that they get random data from a DRNG that 
is seeded, just like in-kernel users may want if they choose the callback-
approach.

I do not understand why there should be different treatment of in-kernel vs 
user space callers in that respect.

(And yes, I do not want to open a discussion whether crng_init==1 can 
considered as a sufficiently seeded DRNG as such discussion will lead 
nowhere.)

Ciao
Stephan
