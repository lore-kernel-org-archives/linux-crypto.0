From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Tue, 18 Jul 2017 17:08:16 -0400
Message-ID: <20170718210816.o6c4iziaqj5dnnd3@thunk.org>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
 <150039607.torZXMN7kc@positron.chronox.de>
 <20170718085212.GB25267@kroah.com>
 <1780567.qGdv4EjEMp@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36506 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbdGRVIU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 17:08:20 -0400
Content-Disposition: inline
In-Reply-To: <1780567.qGdv4EjEMp@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 18, 2017 at 04:37:11PM +0200, Stephan Müller wrote:
> > 
> > > I have stated the core concerns I have with random.c in [1]. To remedy
> > > these core concerns, major changes to random.c are needed. With the past
> > > experience, I would doubt that I get the changes into random.c.
> > > 
> > > [1] https://www.spinics.net/lists/linux-crypto/msg26316.html
> > 
> > Evolution is the correct way to do this, kernel development relies on
> > that.  We don't do the "use this totally different and untested file
> > instead!" method.
> 
> I am not sure I understand your reply. The offered patch set does not rip out 
> existing code. It adds a replacement implementation which can be enabled 
> during compile time. Yet it is even disabled per default (and thus the legacy 
> code is compiled).

I've been trying to take the best features and suggestions from your
proposal and integrating them into /dev/random already.  Things that
I've chosen not take is basically because I disbelieve that the Jitter
RNG is valid.  And that's mostly becuase I trust Peter Anvin (who has
access to Intel chip architects, who has expressed unease) more than
you.  (No hard feelings).

So I have been trying to do the evolution thing already.  

> I see such a development approach in numerous different kernel core areas: 
> memory allocators (SLAB, SLOB, SLUB), process schedulers, IRQ schedulers.

But we don't have two VFS layers or two MM layers.  We also don't have
two implementations of printk.

I'm obviously biased, but I don't see I see the Raison d'Etre for
merging LRNG into the kernel.

						- Ted
