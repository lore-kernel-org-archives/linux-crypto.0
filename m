From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/8] random: trigger random_ready callback upon crng_init
 == 1
Date: Tue, 17 Jan 2017 23:12:50 -0500
Message-ID: <20170118041250.x7wszcasd4dplj3h@thunk.org>
References: <3254875.f5A5oHPdxF@positron.chronox.de>
 <3576149.HSfW5KObBF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55818 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750893AbdAREPi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2017 23:15:38 -0500
Content-Disposition: inline
In-Reply-To: <3576149.HSfW5KObBF@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 27, 2016 at 11:39:57PM +0100, Stephan Müller wrote:
> The random_ready callback mechanism is intended to replicate the
> getrandom system call behavior to in-kernel users. As the getrandom
> system call unblocks with crng_init == 1, trigger the random_ready
> wakeup call at the same time.

It was deliberate that random_ready would only get triggered with
crng_init==2.

In general I'm assuming kernel callers really want real randomness (as
opposed to using prandom), where as there's a lot of b.s. userspace
users of kernel randomness (for things that really don't require
cryptographic randomness, e.g., for salting Python dictionaries,
systemd/udev using /dev/urandom for non-cryptographic, non-security
applications etc.)

						- Ted
