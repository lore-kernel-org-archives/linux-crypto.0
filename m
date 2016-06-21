From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Tue, 21 Jun 2016 20:04:32 +0200
Message-ID: <1900555.p3fYFz9p7D@positron.chronox.de>
References: <1466007463.20087.11.camel@redhat.com> <1526644.Bum3kD6iTD@tauon.atsec.com> <5d1a9ce4-a2e5-4ec7-9ca8-22d75281025f@gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5d1a9ce4-a2e5-4ec7-9ca8-22d75281025f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 21. Juni 2016, 13:51:15 schrieb Austin S. Hemmelgarn:

Hi Austin,

> 
> >> 2. Quite a few systems have a rather distressingly low lower bound and
> >> still get accepted by your algorithm (a number of the S/390 systems, and
> >> a handful of the AMD processors in particular).
> > 
> > I am aware of that, but please read the entire documentation where the
> > lower and upper boundary comes from and how the Jitter RNG really
> > operates. There you will see that the lower boundary is just that: it
> > will not be lower, but the common case is the upper boundary.
> 
> Talking about the common case is all well and good, but the lower bound
> still needs to be taken into account.  If the test results aren't
> uniformly distributed within that interval, or even following a typical
> Gaussian distribution within it (which is what I and many other people
> would probably assume without the data later in the appendix), then you
> really need to mention this _before_ the table itself.  Such information
> is very important, and not everyone has time to read everything.

Then read chapter 5 as mentioned above the table. What you read was an 
appendix that is supposed to supplement to that chapter and not a full-fledged 
documentation.

And quickly glancing over that table to make a judgment is not helpful for 
such topic.

> 
> >> 5. You discount the Pentium Celeron Mobile CPU as old and therefore not
> >> worth worrying about.  Linux still runs on 80486 and other 'ancient'
> >> systems, and there are people using it on such systems.  You need to
> >> account for this usage.
> > 
> > I do not account for that in the documentation. In real life though, I
> > certainly do -- see how the Jitter RNG is used in the kernel.
> 
> Then you shouldn't be pushing the documentation as what appears to be
> your sole argument for including it in the kernel.

I understand you read Appendix F -- but that document is 150+ pages in size 
with quite a bit of information and you judge it based on an appendix 
providing supplemental data?

Note, I pointed you to this appendix at the starting question where you wanted 
to see test results on execution timing variations on ARM and MIPS.
> 
> >> 6. You have a significant lack of data regarding embedded systems, which
> >> is one of the two biggest segments of Linux's market share.  You list no
> >> results for any pre-ARMv6 systems (Linux still runs on and is regularly
> >> used on ARMv4 CPU's, and it's worth also pointing out that the values on
> >> the ARMv6 systems are themselves below average), any MIPS systems other
> >> than 24k and 4k (which is not a good representation of modern embedded
> >> usage), any SPARC CPU's other than UltraSPARC (ideally you should have
> >> results on at least a couple of LEON systems as well), no tight-embedded
> >> PPC chips (PPC 440 processors are very widely used, as are the 7xx and
> >> 970 families, and Freescale's e series), and only one set of results for
> >> a tight-embedded x86 CPU (the Via Nano, you should ideally also have
> >> results on things like an Intel Quark).  Overall, your test system
> >> selection is not entirely representative of actual Linux usage (yeah,
> >> ther'es a lot of x86 servers out there running Linux, there's at least
> >> as many embedded systems running it too though, even without including
> >> Android).
> > 
> > Perfectly valid argument. But I programmed that RNG as a hobby -- I do not
> > have the funds to buy all devices there are.
> 
> I'm not complaining as much about the lack of data for such devices as I
> am about you stating that it will work fine for such devices when you
> have so little data to support those claims.  Many of the devices you

Little data, interesting statement for results on 200+ systems including all 
major CPU arches all showing information leading in the same directions.

> have listed that can be reasonably assumed to be embedded systems are
> relatively modern ones that most people would think of (smart-phones and
> similar).  Such systems have almost as much if not more interrupts as
> many desktop and server systems, so the entropy values there actually do

Please re-read the documentation: the testing and the test analysis remove 
outliers from interrupts and such to get a worst-case testing.

> make some sense.  Not everything has this luxury.  Think for example of
> a router.  All it will generally have interrupts from is the timer
> interrupt (which should functionally have near zero entropy because it's
> monotonic most of the time) and the networking hardware, and quite
> often, many of the good routers operate their NIC's in polling mode,
> which means very few interrupts (which indirectly is part of the issue
> with some server systems too), and therefore will have little to no
> entropy there either.  This is an issue with the current system too, but
> you have almost zero data on such systems systems yourself, so you can't
> argue that it makes things better for them.

It would be good to read the documentation in full -- the RNG does not rest on 
interrupts.

Ciao
Stephan
