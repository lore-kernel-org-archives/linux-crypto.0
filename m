From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Mon, 20 Jun 2016 07:51:59 +0200
Message-ID: <3817952.8FvMDE0Kc7@tauon.atsec.com>
References: <2754489.L1QYabbYUc@positron.chronox.de> <20160619193614.GA26146@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37348 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbcFTFwG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 01:52:06 -0400
In-Reply-To: <20160619193614.GA26146@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 19. Juni 2016, 21:36:14 schrieb Pavel Machek:

Hi Pavel,

> On Sun 2016-06-19 17:58:41, Stephan Mueller wrote:
> > Hi Herbert, Ted,
> > 
> > The following patch set provides a different approach to /dev/random which
> > I call Linux Random Number Generator (LRNG) to collect entropy within the
> > Linux kernel. The main improvements compared to the legacy /dev/random is
> > to provide sufficient entropy during boot time as well as in virtual
> > environments and when using SSDs. A secondary design goal is to limit the
> > impact of the entropy collection on massive parallel systems and also
> > allow the use accelerated cryptographic primitives. Also, all steps of
> > the entropic data processing are testable. Finally massive performance
> > improvements are visible at /dev/urandom and get_random_bytes.
> 
> Dunno. It is very similar to existing rng, AFAICT. And at the very
> least, constants in existing RNG could be tuned to provide "entropy at
> the boot time".

The key differences and thus my main concerns I have with the current design 
are the following items. If we would change them, it is an intrusive change. 
As of now, I have not seen that intrusive changes were accepted. This led me 
to develop a competing algorithm.

- Correlation of noise sources: as outlined in [1] chapter 1, the three noise 
sources of the legacy /dev/random implementation have a high correlation. Such 
correlation is due to the fact that a HID/disk event at the same time produces 
an IRQ event. The time stamp (which deliver the majority of entropy) of both 
events are correlated. I would think that the maintenance of the fast_pools 
partially breaks that correlation to some degree though, yet how much the 
correlation is broken is unknown.

- Awarding IRQs only 1/64th bit of entropy compared to HID and disk noise 
sources is warranted due to the correlation. As I try to show, IRQs have a 
much higher entropy rate than what they are credited currently. But we cannot 
set that value higher due to the correlation issue. That means, currently we 
prefer desktop machines over server type systems since servers usually have no 
HID. In addition, with SSDs or virtio-disks the disk noise source is 
deactivated (again, common use cases for servers). Hence, server environments 
are heavily penalized. (Note, awarding IRQ events one bit of entropy is the 
root cause why my approach claims to be seeded very fast during boot time. 
Furthermore, as outlined in [1] chapter 1 and 2, IRQ events are entropic even 
in virtual machines which implies that even in VMs, my approach works well.)

- I am not sure the current way of crediting entropy has anything to do with 
its entropy. It just happen to underestimate our entropy so it does not hurt. 
I see no sensible reason why the calculation of an entropy estimate rests on 
the first/second and third derivation of the Jiffies -- the Jiffies hardly 
deliver any entropy and therefore why should they be a basis for entropy 
calculation?

- There was a debate around my approach assuming one bit of entropy per 
received IRQ. I am really wondering about that discussion when there is a much 
bigger "forcast" problem with the legacy /dev/random: how can we credit HIDs 
up to 11 bits of entropy when the user (a potential adversary) triggers these 
events? I am sure I would be shot down with such an approach if I would 
deliver that with a new implementation.

- The delivery of entropic data from the input_pool to the (non)blocking_pools 
is not atomic (for the lack of better word), i.e. one block of data with a 
given entropy content is injected into the (non)blocking_pool where the output 
pool is still locked (the user cannot obtain data during that injection time). 
With Ted's new patch set, two 64 bit blocks from the fast_pools are injected 
into the ChaCha20 DRNG. So, it is clearly better than previously. But still, 
with the blocking_pool, we face that issue. The reason for that issue is 
outlined in [1] 2.1. In the pathological case with an active attack, 
/dev/random could have a security strength of 2 * 128 bits of and not 2^128 
bits when reading 128 bits out of it (the numbers are for illustration only, 
it is a bit better as /dev/random is woken up at random_read_wakeup_bits 
intervals -- but that number can be set to dangerous low levels down to 8 
bits).


[1] http://www.chronox.de/lrng/doc/lrng.pdf

Ciao
Stephan
