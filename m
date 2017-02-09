From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: Don't overwrite CRNG state in crng_initialize()
Date: Thu, 9 Feb 2017 13:32:42 -0500
Message-ID: <20170209183242.kcntklvafcgmfkxl@thunk.org>
References: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com>
 <20170209041931.xgkmysquazppiewx@thunk.org>
 <20170209081322.GA17535@rincewind>
 <20170209175600.pnyn7e3iypmd5sis@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Alden Tondettar <alden.tondettar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170209175600.pnyn7e3iypmd5sis@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

OK, I figured out what is going on with your test results.

If you use qemu-system-x86_64 **without** --enable-kvm, then on both
the Debian Jessie version of qemu as well as the Debian Stretch
version of qemu, crng_fast_load() will be called _twice_ before
crng_initialize has a chance to be called.  At least for my kernel
configuration and my CPU.

If you're using a different kernel configuration and a slower CPU,
such that when qemu is doing instruction by instruction emulation,
which slows down the boot sequence **massively**, then that probably
explains your results.

I'm not sure if there are any real life use cases where someone would
be insane enough to use virtualization without enabling KVM, but at
least we know what is happening now.

This makes me feel better, because I've looked at kernel boot messags
from a variety of systems, from big data center servers to laptops to
mobile handsets, and I had **never** seen the sequence of crng
initialization messages that you had been reporting.

						- Ted
