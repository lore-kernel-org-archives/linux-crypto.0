From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Tue, 21 Jun 2016 07:17:43 +0200
Message-ID: <3213943.8fHWQDGiN1@tauon.atsec.com>
References: <20160620184403.21972.qmail@ns.sciencehorizons.net> <10477997.AvJKPRy4pc@positron.chronox.de> <20160621051255.GG9848@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: George Spelvin <linux@sciencehorizons.net>, andi@firstfloor.org,
	cryptography@lakedaemon.net, herbert@gondor.apana.org.au,
	hpa@linux.intel.com, joe@perches.com, jsd@av8n.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@horizon.com, pavel@ucw.cz, sandyinchina@gmail.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37528 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbcFUFSs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 01:18:48 -0400
In-Reply-To: <20160621051255.GG9848@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. Juni 2016, 01:12:55 schrieb Theodore Ts'o:

Hi Theodore,

> On Mon, Jun 20, 2016 at 09:00:49PM +0200, Stephan Mueller wrote:
> > The time stamp maintenance is the exact cause for the correlation: one HID
> > event triggers:
> > 
> > - add_interrupt_randomness which takes high-res time stamp, Jiffies and
> > some pointers
> > 
> > - add_input_randomness which takes high-res time stamp, Jiffies and HID
> > event value
> > 
> > The same applies to disk events. My suggestion is to get rid of the double
> > counting of time stamps for one event.
> > 
> > And I guess I do not need to stress that correlation of data that is
> > supposed to be entropic is not good :-)
> 
> What is your concern, specifically?  If it is in the entropy
> accounting, there is more entropy in HID event interrupts, so I don't
> think adding the extra 1/64th bit of entropy is going to be problematic.

My concern is that interrupts have *much* more entropy than 1/64th. With a 
revaluation of the assumed entropy in interrupts, we will serve *all* systems 
much better and not just systems with HID.

As said, I think we heavily penalize server type and VM environments against 
desktop systems by crediting entropy in large scale to HID and conversely to a 
much lesser degree to interrupts.
> 
> If it is that there are two timestamps that are closely correleated
> being added into the pool, the add_interrupt_randomness() path is
> going to mix that timestamp with the interrupt timings from 63 other
> interrupts before it is mixed into the input pool, while the
> add_input_randomness() mixes it directly into the pool.  So if you
> think there is a way this could be leveraged into attack, please give
> specifics --- but I think we're on pretty solid ground here.

I am not saying that there is an active attack vector. All I want is to 
revalue the entropy in one interrupt which can only be done if we drop the HID 
time stamp collection.

Ciao
Stephan
