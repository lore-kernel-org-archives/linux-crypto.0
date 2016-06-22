From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Wed, 22 Jun 2016 15:25:06 +0200
Message-ID: <10276045.g3Gar43YLo@tauon.atsec.com>
References: <1466007463.20087.11.camel@redhat.com> <2650602.0p6Dj5APxb@positron.chronox.de> <5df01797-ccf2-f7fb-5d39-15602a4a306a@gmail.com>
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
In-Reply-To: <5df01797-ccf2-f7fb-5d39-15602a4a306a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 22. Juni 2016, 08:54:16 schrieb Austin S. Hemmelgarn:

Hi Austin,

> You're not demonstrating it's inherently present in the architecture,

I am not demonstrating it, interesting statement. I take different arches from 
different vendors which were developed independently from each other and I see 
the phenomenon to an equal degree in all of them.

So, this is no demonstration in your eyes? Interesting conclusion.

Yes, I do not have the statement that gate X or function Y in a CPU is the 
trigger point. Thus the absolute root cause to the unpredictable phenomenon is 
yet unknown to me. I am hunting that -- I spoke with hardware folks from 3 
different major chip vendors yet and they all have difficulties in explaining 
it. One vendor is currently helping me dissecting the issue.
> 
> > I do not care about the form factor of the test system server, desktop or
> > embedded systems nor do I care about the number of attached devices -- the
> > form factor and number of attached devices is the differentiator of what
> > you call embedded vs server vs desktop.
> 
> I don't care about form factor, I care about the CPU, and embedded
> systems almost always have simpler CPU designs (not including all the
> peripherals they love to add in on-die).  Your own analysis indicates
> that your getting entropy from the complex interaction of the different
> parts of the CPU.  Such complexities are less present in simpler CPU
> designs.

My RNG has two safety measures to detect noise source failures (again, they 
are documented): during startup and at runtime. In both cases, no data will be 
produced. But for chips where the self tests pass, we can surely harvest that 
unpredictable phenomenon.

And funnily: these health tests would scream loudly in dmesg if the noise 
source would not work. Note, in more recent kernels, the RNG is used in a lot 
of configurations and I have only received one complaint that the health test 
indicated a bad noise source. That was a very special system where a 
separation kernel did funky things.

So, as of now, it rather makes sense that you refer me to some embedded 
devices that you think will be a challenge. I do not like to theorize.

For me, embedded devices are something like a Rasperry PI or the MIPS system 
which are tested.

> >> Android barely counts as an embedded system anymore, as many Android
> > 
> > Then read F.28ff -- these are truly embedded systems (i.e. the routers
> > that I have on my desk)
> 
> 1. I'm actually rather curious what router you managed to get Android
> running on.
> 2. This is still an insanely small sample size compared to the rest of
> your results.

I think this will be the last answer for now from my side: I ask you to read 
my document as I really do not want to restate 150+ pages here!

This machine is no Android system but an AVM FritzBox router system that is 
very popular in Germany, as referenced in the document. It runs with highly 
modified Linux system -- as documented.

And instead of complaining about the test sample, you should help us by doing 
more testing, if you feel that the health tests in the RNG are insufficient.


Besides, if you really worried about the lower bound I mentioned in the 
appendix F, use the oversampling rate turning knob 
jent_entropy_collector_alloc as documented. Finally, if that is not of your 
liking, generate a bit more data with the Jitter RNG than you think you need 
entropy wise.

Ciao
Stephan
