From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Tue, 26 Apr 2016 20:55:28 +0200
Message-ID: <1948798.MKebf3xYm7@positron.chronox.de>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com> <20160426030735.GD28496@thunk.org> <20160426184439.GA8162@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53718 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbcDZSzc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2016 14:55:32 -0400
In-Reply-To: <20160426184439.GA8162@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 26. April 2016, 20:44:39 schrieb Pavel Machek:

Hi Pavel,

> Hi1
> 
> > > When dropping the add_disk_randomness function in the legacy
> > > /dev/random, I
> > > would assume that without changes to add_input_randomness and
> > > add_interrupt_randomness, we become even more entropy-starved.
> > 
> > Sure, but your system isn't doing anything magical here.  The main
> > difference is that you assume you can get almost a full bit of entropy
> > out of each interrupt timing, where I'm much more conservative and
> > assume we can only get 1/64th of a bit out of each interrupt timing.
> 
> Maybe 1/64th of a bit is a bit too conservative? I guess we really
> have more than one bit of entropy on any system with timestamp
> counter....
> 
> Making it 1/2 of bit (or something) should be very easy way to improve
> entropy early during boot...

I can easily settle on 1/2 bit here. The LRNG currently uses 0.9 bits which 
are based on measurements plus a safety margin. But I see no issue to even 
lower it further to, say, 1/2.

But simply enlarging the heuristic for the interrupt processing of the legacy 
/dev/random is a challenge IMHO. The key issue is the following:

When the legacy /dev/random receives one [block|HID] event, the following 
happens:

- add_[disk|input]_randomness assigns a time stamp containing majority of the 
entropy plus jiffies plus the event value and mix that triplet into the input 
pool

- for the very same event add_interrupt_randomness is also triggered and 
records the time stamp (plus jiffies, the instruction pointer and one 
register). Again, the majority of the entropy comes from the time stamp.

Both invocations are applied to the same event where the majority of entropy 
for each invocation is derived from a time stamp. It is clear that the 
invocation of both are highly correlated. So is the time stamp both 
invocations obtain. Thus, the time stamp of either one must not be credited 
with high entropy content.

If the credited entropy for an interrupt raises, the credited entropy for 
add_[disk|block]_randomness must be decreased. That is the core issue why I 
came up with a separate way of recording these events.

Ciao
Stephan
