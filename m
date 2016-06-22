From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Wed, 22 Jun 2016 07:16:04 +0200
Message-ID: <2650602.0p6Dj5APxb@positron.chronox.de>
References: <1466007463.20087.11.camel@redhat.com> <1900555.p3fYFz9p7D@positron.chronox.de> <e7ab11a3-8bc5-ac3f-4034-87f5a8835b02@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	David =?utf-8?B?SmHFoWE=?= <djasa@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37902 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbcFVFQJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 01:16:09 -0400
In-Reply-To: <e7ab11a3-8bc5-ac3f-4034-87f5a8835b02@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. Juni 2016, 15:31:07 schrieb Austin S. Hemmelgarn:

Hi Austin,

> > Little data, interesting statement for results on 200+ systems including
> > all major CPU arches all showing information leading in the same
> > directions.
> Let me try rephrasing this to make it a bit clearer:
> 1. You have lots of data on server systems.
> 2. You have a significant amount of data on desktop/workstation type
> systems.
> 3. You have very little data on embedded systems.
> 
> and here are your arguments:
> A. This works well on server systems.
> B. This works well on desktop systems.
> C. This works well on embedded systems.
> 
> Arguments A and B are substantiated directly by points 1 and 2.
> Argument C is not substantiated thoroughly because of point 3.
> My complaint is about argument C given point 3.

Then let me rephrase what I try to say: my RNG rests on the intrinsic 
functionality of CPUs. When I show that such intrinsic behavior is present in 
various architectures I show that there is a common ground for the basis of 
the RNG.

I tested on all CPUs of all large scale architectures (including the 
architectures that are commonly used for embedded devices) and demonstrated 
that the fundamental phenomenon the RNG rests on is present in all 
architectures.

I do not care about the form factor of the test system server, desktop or 
embedded systems nor do I care about the number of attached devices -- the 
form factor and number of attached devices is the differentiator of what you 
call embedded vs server vs desktop.

Heck, I have written a test that executes the RNG on bare metal (without OS 
and with only a keyboard as device present -- i.e no interrupts are received 
apart from a keyboard), which demonstrates that the phenomenon is present.

Furthermore, chapter 6 of my document analyzes the root cause of the RNG and 
here you see clearly that it has nothing to do with the size of the CPU or its 
attached devices or the size of RAM.

The massive number of x86 tests shall demonstrate the common theme I see: the 
newer the CPU the larger the phenomenon is the RNG rests on.

I use different OSes (including microkernel systems) for testing to 
demonstrate that the OS does not materially change the test results.
> 
> I'm not saying you have insufficient data to support argument A or B,
> only that you have insufficient data to support argument C.

And I think that this statement is not correct. But I would always welcome 
more testing.
> 
> Android barely counts as an embedded system anymore, as many Android

Then read F.28ff -- these are truly embedded systems (i.e. the routers that I 
have on my desk)

> phones can outperform most inexpensive desktop and laptop systems, and
> even some rather expensive laptops.  This leaves the only systems that
> can be assumed without further information to be representative of
> embedded boards to be the ones running Genode, and possibly the MIPS
> systems, which is a total of about 10 results out of hundreds for
> servers and desktops/workstations.


Ciao
Stephan
