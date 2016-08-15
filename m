From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Mon, 15 Aug 2016 08:13:06 +0200
Message-ID: <1756772.RGD5U4JGHJ@tauon.atsec.com>
References: <4723196.TTQvcXsLCG@positron.chronox.de> <6876524.OiXCMsNJHH@tauon.atsec.com> <20160812192208.GA30280@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36004 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbcHOGNM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2016 02:13:12 -0400
In-Reply-To: <20160812192208.GA30280@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 12. August 2016, 15:22:08 CEST schrieb Theodore Ts'o:

Hi Theodore,

> On Fri, Aug 12, 2016 at 11:34:55AM +0200, Stephan Mueller wrote:
> > - correlation: the interrupt noise source is closely correlated to the
> > HID/
> > block noise sources. I see that the fast_pool somehow "smears" that
> > correlation. However, I have not seen a full assessment that the
> > correlation is gone away. Given that I do not believe that the HID event
> > values (key codes, mouse coordinates) have any entropy -- the user
> > sitting at the console exactly knows what he pressed and which mouse
> > coordinates are created, and given that for block devices, only the
> > high-resolution time stamp gives any entropy, I am suggesting to remove
> > the HID/block device noise sources and leave the IRQ noise source. Maybe
> > we could record the HID event values to further stir the pool but do not
> > credit it any entropy. Of course, that would imply that the assumed
> > entropy in an IRQ event is revalued. I am currently finishing up an
> > assessment of how entropy behaves in a VM (where I hope that the report
> > is released). Please note that contrary to my initial
> > expectations, the IRQ events are the only noise sources which are almost
> > unaffected by a VMM operation. Hence, IRQs are much better in a VM
> > environment than block or HID noise sources.
> 
> The reason why I'm untroubled with leaving them in is because I beieve
> the quality of the timing information from the HID and block devices
> is better than most of the other interrupt sources.  For example, most
> network interfaces these days use NAPI, which means interrupts get
> coalesced and sent in batch, which means the time of the interrupt is
> latched off of some kind of timer --- and on many embeded devices

According to my understanding of NAPI, the network card sends one interrupt 
when receiving the first packet of a packet stream and then the driver goes 
into polling mode, disabling the interrupt. So, I cannot see any batching 
based on some on-board timer where add_interrupt_randomness is affected.
 
Can you please elaborate?

> there is a single oscillator for the entire mainboard.  We only call
> add_disk_randomness for rotational devices (e.g., only HDD's, not
> SSD's), after the interrupt has been recorded.  Yes, most of the
> entropy is probably going to be found in the high entropy time stamp
> rather than the jiffies-based timestamp, especially for the hard drive
> completion time.
> 
> I also tend to take a much more pragmatic viewpoint towards
> measurability.  Sure, the human may know what she is typing, and
> something about when she typed it (although probably not accurately
> enough on a millisecond basis, so even the jiffies number is going to
> be not easily predicted), but the analyst sitting behind the desk at
> the NSA or the BND or the MSS is probably not going to have access to
> that information.

Well, injecting a trojan to a system in user space as unprivileged user that 
starts some X11 session and that can perform the following command is all you 
need to get to the key commands of the console.

xinput list |   grep -Po 'id=\K\d+(?=.*slave\s*keyboard)' |   xargs -P0 -n1 
xinput test

That is fully within reach of not only some agencies but also other folks. It 
is similar for mice.

> 
> (Whereas the NSA or the BND probably *can* get low-level information
> about the Intel x86 CPU's internal implementation, which is why I'm
> extremely amused by the arugment --- "the internals of the Intel CPU
> are **so** complex we can't reverse engineer what's going on inside,
> so the jitter RNG *must* be good!"  Note BTW that the NSA has only

Sure, agencies may know the full internals of a CPU like they know the full 
internals of the Linux kernel with the /dev/random implementation or just like 
they know the full internals of AES. But they do not know the current state of 
the system. And the cryptographic strength comes from that state.

When you refer to my Jitter RNG, I think I have shown that its strength comes 
from the internal state of the CPU (states of the internal building blocks 
relative to each other which may cause internal wait states, state of branch 
prediction or pipelines, etc.) and not of the layout of the CPU.

> said they won't do industrial espionage for economic for economic
> gain, not that they won't engage in espionage against industrial
> entities at all.  This is why the NSA spying on Petrobras is
> considered completely fair game, even if it does enrage the
> Brazillians.  :-)
> 
> > - entropy estimate: the current entropy heuristics IMHO have nothing to do
> > with the entropy of the data coming in. Currently, the min of
> > first/second/
> > third derivative of the Jiffies time stamp is used and capped at 11. That
> > value is the entropy value credited to the event. Given that the entropy
> > rests with the high-res time stamp and not with jiffies or the event
> > value, I think that the heuristic is not helpful. I understand that it
> > underestimates on average the available entropy, but that is the only
> > relationship I see. In my mentioned entropy in VM assessment (plus the
> > BSI report on /dev/random which is unfortunately written in German, but
> > available in the Internet) I did a min entropy calculation based on
> > different min entropy formulas (SP800-90B). That calculation shows that
> > we get from the noise sources is about 5 to 6 bits. On average the
> > entropy heuristic credits between 0.5 and 1 bit for events, so it
> > underestimates the entropy. Yet, the entropy heuristic can credit up to
> > 11 bits. Here I think it becomes clear that the current entropy heuristic
> > is not helpful. In addition, on systems where no high-res timer is
> > available, I assume (I have not measured it yet), the entropy heuristic
> > even overestimates the entropy.
> 
> The disks on a VM are not rotational disks, so we wouldn't be using
> the add-disk-randomness entropy calculation.  And you generally don't
> have a keyboard on a mouse attached to the VM, so we would be using
> the entropy estimate from the interrupt timing.

On VMs, the add_disk_randomness is always used with the exception of KVM when 
using a virtio disk. All other VMs do not use virtio and offer the disk as a 
SCSI or IDE device. In fact, add_disk_randomness is only disabled when the 
kernel detects:

- SDDs

- virtio

- use of device mapper

(Btw we should be thankful that this is done on Hyper-V as we would have a 
fatal state in a very common use case where /dev/random would have collected 
no entropy and /dev/urandom would have provided bogus data before the patch 
for using the VMBus interrupts was added.)
> 
> As far as whether you can get 5-6 bits of entropy from interrupt
> timings --- that just doesn't pass the laugh test.  The min-entropy

May I ask what you find amusing? When you have a noise source for which you 
have no theoretical model, all you can do is to revert to statistical 
measurements.

> formulas are estimates assuming IID data sources, and it's not at all
> clear (in fact, i'd argue pretty clearly _not_) that they are IID.  As

Sure, they are not IID based on the SP800-90B IID verification tests. For 
that, SP800-90B has non-IID versions of the min entropy calculations. See 
section 9.1 together with 9.3 of SP800-90B where I used those non-IID 
formulas.

Sure, it is "just" some statistical test. But it is better IMHO than to brush 
away available entropy entirely just because "my stomach tells me it is not 
good".

Just see the guy that sent an email to linux-crypto today. His MIPS /dev/
random cannot produce 16 bytes of data within 4 hours (which is similar to 
what I see on POWER systems). This raises a very interesting security issue: /
dev/urandom is not seeded properly. And we all know what folks do in the wild: 
when /dev/random does not produce data, /dev/urandom is used -- all general 
user space libs (OpenSSL, libgcrypt, nettle, ...) seed from /dev/urandom per 
default.

And I call that a very insecure state of affairs.

> I said, take for example the network interfaces, and how NAPI gets

As mentioned above, I do not see NAPI as an issue for interrupt entropy.

> implemented.  And in a VM environment, where everything is synthetic,
> the interrupt timings are definitely not IID, and there may be
> patterns that will not detectable by statistical mechanisms.

As mentioned, to my very surprise, I found that interrupts are the only thing 
in a VM that works extremely well even under attack scenarios. VMMs that I 
quantiatively tested include QEMU/KVM, VirtualBox, VMWare ESXi and Hyper-V. 
After more research, I came to the conclusion that even on the theoretical 
side, it must be one of the better noise sources in a VM.

Note, this was the key motivation for me to start my own implementation of /
dev/random.
> 
> > - albeit I like the current injection of twice the fast_pool into the
> > ChaCha20 (which means that the pathological case where the collection of
> > 128 bits of entropy would result in an attack resistance of 2 * 128 bits
> > and *not* 2^128 bits is now increased to an attack strength of 2^64 * 2
> > bits), / dev/urandom has *no* entropy until that injection happens. The
> > injection happens early in the boot cycle, but in my test system still
> > after user space starts. I tried to inject "atomically" (to not fall into
> > the aforementioned pathological case trap) of 32 / 112 / 256 bits of
> > entropy into the /dev/ urandom RNG to have /dev/urandom at least seeded
> > with a few bits before user space starts followed by the atomic injection
> > of the subsequent bits.
> The early boot problem is a hard one.  We can inject some noise in,
> but I don't think a few bits actually does much good.  So the question
> is whether it's faster to get to fully seeded, or to inject in 32 bits

I am not talking about the 32 bits. We can leave the current 64 bits for the 
first seed.

I am concerned about the *two* separate injections of 64 bits. It should 
rather be *one* injection of at least 112 bit (or 128 bits). This is what I 
mean with "atomic" operation here.

> of entropy in the hopes that this will do some good.  Personally, I'm
> not convinced.  So the tack I've taken is to have warning messages
> printed when someone *does* draw from /dev/urandom before it's fully
> seeded.  In many cases, it's for entirely bogus, non-cryptographic
> reasons.  (For example, Python wanting to use a random salt to protect
> against certain DOS attacks when Python is being used in a web server
> --- a use case which is completely irrelevant when it's being used by
> systemd generator scripts at boot time.)
> 
> Ultimately, I think the right answer here is we need help from the
> bootloader, and ultimately some hardware help or some initialization
> at factory time which isn't too easily hacked by a Tailored Access
> Organization team who can intercept hardware shipments.  :-)

I agree. But we can still try to make the Linux side good as possible to cover 
people who do not have the luxury to control the hardware.
> 
[...]
> 
> > Finally, one remark which I know you could not care less: :-)
> > 
> > I try to use a known DRNG design that a lot of folks have already assessed
> > -- SP800-90A (and please, do not hint to the Dual EC DRBG as this issue
> > was pointed out already by researcher shortly after the first SP800-90A
> > came out in 2007). This way I do not need to re-invent the wheel and
> > potentially forget about things that may be helpful in a DRNG. To allow
> > researchers to assess my ChaCha20 DRNG. that used when no kernel crypto
> > API is compiled. independently from the kernel, I extracted the ChaCha20
> > DRNG code into a standalone DRNG accessible at [1]. This standalone
> > implementation can be debugged and studied in user space. Moreover it is
> > a simple copy of the kernel code to allow researchers an easy comparison.
> 
> SP800-90A consists of a high level architecture of a DRBG, plus some
> lower-level examples of how to use that high level architecture
> assuming you have a hash function, or a block cipher, etc.  But it
> doesn't have an example on using a stream cipher like ChaCha20.  So
> all you can really do is follow the high-level architecture.  Mapping
> the high-level architecture to the current /dev/random generator isn't
> hard.  And no, I don't see the point of renaming things or moving
> things around just to make the mapping to the SP800-90A easier.

Unfortunately I have seen subtle problems with DRNG implementations -- and a 
new one will emerge in the not too far future... There are examples of that 
and I like tests against reference implementations.

For example, the one key problem I have with the ChaCha20 DRNG is the 
following: when final update of the internal state is made for enhanced 
prediction resistance, ChaCha20 is used to generate one more block. That new 
block has 512 bits in size. In your implementation, you use the first 256 bits 
to inject it back into ChaCha20 as key. I use the entire 512 bits. I do not 
know whether one is better than the other (in the sense that it does not loose 
entropy). But barring any real research from other cryptographers, I guess we 
both do not know. And I have seen that such subtle issues may lead to 
catastrophic problems.

Thus, knowing valid DRNG designs may cover 99% of a new DRNG design. But the 
remaining 1% usually gives you the creeps.

Ciao
Stephan
