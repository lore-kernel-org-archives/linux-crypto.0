From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Tue, 21 Jun 2016 01:12:55 -0400
Message-ID: <20160621051255.GG9848@thunk.org>
References: <20160620184403.21972.qmail@ns.sciencehorizons.net>
 <10477997.AvJKPRy4pc@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@sciencehorizons.net>, andi@firstfloor.org,
	cryptography@lakedaemon.net, herbert@gondor.apana.org.au,
	hpa@linux.intel.com, joe@perches.com, jsd@av8n.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@horizon.com, pavel@ucw.cz, sandyinchina@gmail.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52418 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbcFUFNs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 01:13:48 -0400
Content-Disposition: inline
In-Reply-To: <10477997.AvJKPRy4pc@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 20, 2016 at 09:00:49PM +0200, Stephan Mueller wrote:
> 
> The time stamp maintenance is the exact cause for the correlation: one HID 
> event triggers:
> 
> - add_interrupt_randomness which takes high-res time stamp, Jiffies and some 
> pointers
> 
> - add_input_randomness which takes high-res time stamp, Jiffies and HID event 
> value
> 
> The same applies to disk events. My suggestion is to get rid of the double 
> counting of time stamps for one event.
> 
> And I guess I do not need to stress that correlation of data that is supposed 
> to be entropic is not good :-)

What is your concern, specifically?  If it is in the entropy
accounting, there is more entropy in HID event interrupts, so I don't
think adding the extra 1/64th bit of entropy is going to be problematic.

If it is that there are two timestamps that are closely correleated
being added into the pool, the add_interrupt_randomness() path is
going to mix that timestamp with the interrupt timings from 63 other
interrupts before it is mixed into the input pool, while the
add_input_randomness() mixes it directly into the pool.  So if you
think there is a way this could be leveraged into attack, please give
specifics --- but I think we're on pretty solid ground here.

Cheers,

						- Ted
