From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: random(4) changes
Date: Sat, 23 Apr 2016 22:03:23 -0400
Message-ID: <20160424020323.GD20980@thunk.org>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60860 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbcDXCDa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 Apr 2016 22:03:30 -0400
Content-Disposition: inline
In-Reply-To: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 22, 2016 at 06:27:48PM -0400, Sandy Harris wrote:
> 
> I really like Stephan's idea of simplifying the interrupt handling,
> replacing the multiple entropy-gathering calls in the current driver
> with one routine called for all interrupts. See section 1.2 of his
> doc. That seems to me a much cleaner design, easier both to analyse
> and to optimise as a fast interrupt handler.

The current /dev/random driver *already* has a fast interrupt handler,
and it was designed specifically to be very fast and very lightweight.

It's a fair argument that getting rid of add_disk_randomness()
probably makes sense.  However, add_input_randomness() is useful
because it is also mixing in the HID input (e.g., the characters typed
or the mouse movements), and that is extremely valuable and I wouldn't
want to get rid of this.

> In the current driver -- and I think in Stephan's, though I have not
> looked at his code in any detail, only his paper -- heavy use of
> /dev/urandom or the kernel get_random_bytes() call can deplete the
> entropy available to /dev/random. That can be a serious problem in
> some circumstances, but I think I have a fix.

So /dev/urandom, or preferentially, the getrandom(2) system call,
which will block until the entropy pool is initialized, is designed to
be a CRNG.  We use the entropy accounting for the urandom pool as a
hueristic to know how aggressively to pull the random pool and/or
things like hwrandom (since pulling entropy from the TPM does have
costs, for example power utilization for battery-powered devices).

We already throttle back how much we pull from the input pool if it is
being used heavily, specifically to avoid this problem.

Cheers,

					- Ted
