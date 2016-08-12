From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Fri, 12 Aug 2016 15:22:08 -0400
Message-ID: <20160812192208.GA30280@thunk.org>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
 <20160811213632.GL10626@thunk.org>
 <6876524.OiXCMsNJHH@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6876524.OiXCMsNJHH@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 12, 2016 at 11:34:55AM +0200, Stephan Mueller wrote:
> 
> - correlation: the interrupt noise source is closely correlated to the HID/
> block noise sources. I see that the fast_pool somehow "smears" that 
> correlation. However, I have not seen a full assessment that the correlation 
> is gone away. Given that I do not believe that the HID event values (key 
> codes, mouse coordinates) have any entropy -- the user sitting at the console 
> exactly knows what he pressed and which mouse coordinates are created, and 
> given that for block devices, only the high-resolution time stamp gives any 
> entropy, I am suggesting to remove the HID/block device noise sources and 
> leave the IRQ noise source. Maybe we could record the HID event values to 
> further stir the pool but do not credit it any entropy. Of course, that would 
> imply that the assumed entropy in an IRQ event is revalued. I am currently 
> finishing up an assessment of how entropy behaves in a VM (where I hope that 
> the report is released). Please note that contrary to my initial 
> expectations, the IRQ events are the only noise sources which are almost 
> unaffected by a VMM operation. Hence, IRQs are much better in a VM 
> environment than block or HID noise sources.

The reason why I'm untroubled with leaving them in is because I beieve
the quality of the timing information from the HID and block devices
is better than most of the other interrupt sources.  For example, most
network interfaces these days use NAPI, which means interrupts get
coalesced and sent in batch, which means the time of the interrupt is
latched off of some kind of timer --- and on many embeded devices
there is a single oscillator for the entire mainboard.  We only call
add_disk_randomness for rotational devices (e.g., only HDD's, not
SSD's), after the interrupt has been recorded.  Yes, most of the
entropy is probably going to be found in the high entropy time stamp
rather than the jiffies-based timestamp, especially for the hard drive
completion time.

I also tend to take a much more pragmatic viewpoint towards
measurability.  Sure, the human may know what she is typing, and
something about when she typed it (although probably not accurately
enough on a millisecond basis, so even the jiffies number is going to
be not easily predicted), but the analyst sitting behind the desk at
the NSA or the BND or the MSS is probably not going to have access to
that information.

(Whereas the NSA or the BND probably *can* get low-level information
about the Intel x86 CPU's internal implementation, which is why I'm
extremely amused by the arugment --- "the internals of the Intel CPU
are **so** complex we can't reverse engineer what's going on inside,
so the jitter RNG *must* be good!"  Note BTW that the NSA has only
said they won't do industrial espionage for economic for economic
gain, not that they won't engage in espionage against industrial
entities at all.  This is why the NSA spying on Petrobras is
considered completely fair game, even if it does enrage the
Brazillians.  :-)

> - entropy estimate: the current entropy heuristics IMHO have nothing to do 
> with the entropy of the data coming in. Currently, the min of first/second/
> third derivative of the Jiffies time stamp is used and capped at 11. That 
> value is the entropy value credited to the event. Given that the entropy 
> rests with the high-res time stamp and not with jiffies or the event value, I 
> think that the heuristic is not helpful. I understand that it underestimates 
> on average the available entropy, but that is the only relationship I see. In 
> my mentioned entropy in VM assessment (plus the BSI report on /dev/random 
> which is unfortunately written in German, but available in the Internet) I 
> did a min entropy calculation based on different min entropy formulas 
> (SP800-90B). That calculation shows that we get from the noise sources is 
> about 5 to 6 bits. On average the entropy heuristic credits between 0.5 and 1 
> bit for events, so it underestimates the entropy. Yet, the entropy heuristic 
> can credit up to 11 bits. Here I think it becomes clear that the current 
> entropy heuristic is not helpful. In addition, on systems where no high-res 
> timer is available, I assume (I have not measured it yet), the entropy 
> heuristic even overestimates the entropy.

The disks on a VM are not rotational disks, so we wouldn't be using
the add-disk-randomness entropy calculation.  And you generally don't
have a keyboard on a mouse attached to the VM, so we would be using
the entropy estimate from the interrupt timing.

As far as whether you can get 5-6 bits of entropy from interrupt
timings --- that just doesn't pass the laugh test.  The min-entropy
formulas are estimates assuming IID data sources, and it's not at all
clear (in fact, i'd argue pretty clearly _not_) that they are IID.  As
I said, take for example the network interfaces, and how NAPI gets
implemented.  And in a VM environment, where everything is synthetic,
the interrupt timings are definitely not IID, and there may be
patterns that will not detectable by statistical mechanisms.

> - albeit I like the current injection of twice the fast_pool into the 
> ChaCha20 (which means that the pathological case where the collection of 128 
> bits of entropy would result in an attack resistance of 2 * 128 bits and 
> *not* 2^128 bits is now increased to an attack strength of 2^64 * 2 bits), /
> dev/urandom has *no* entropy until that injection happens. The injection 
> happens early in the boot cycle, but in my test system still after user space 
> starts. I tried to inject "atomically" (to not fall into the aforementioned 
> pathological case trap) of 32 / 112 / 256 bits of entropy into the /dev/
> urandom RNG to have /dev/urandom at least seeded with a few bits before user 
> space starts followed by the atomic injection of the subsequent bits.

The early boot problem is a hard one.  We can inject some noise in,
but I don't think a few bits actually does much good.  So the question
is whether it's faster to get to fully seeded, or to inject in 32 bits
of entropy in the hopes that this will do some good.  Personally, I'm
not convinced.  So the tack I've taken is to have warning messages
printed when someone *does* draw from /dev/urandom before it's fully
seeded.  In many cases, it's for entirely bogus, non-cryptographic
reasons.  (For example, Python wanting to use a random salt to protect
against certain DOS attacks when Python is being used in a web server
--- a use case which is completely irrelevant when it's being used by
systemd generator scripts at boot time.)

Ultimately, I think the right answer here is we need help from the
bootloader, and ultimately some hardware help or some initialization
at factory time which isn't too easily hacked by a Tailored Access
Organization team who can intercept hardware shipments.  :-)

> A minor issue that may not be of too much importance: if there is a user 
> space entropy provider waiting with select(2) or poll(2) on /dev/random (like 
> rngd or my jitterentropy-rngd), this provider is only woken up when somebody 
> pulls on /dev/random. If /dev/urandom is pulled (and the system does not 
> receive entropy from the add*randomness noise sources), the user space 
> provider is *not* woken up. So, /dev/urandom spins as a DRNG even though it 
> could use a topping off of its entropy once in a while. In my jitterentropy-
> rngd I have handled the situation that in addition to a select(2), the daemon 
> is woken up every 5 seconds to read the entropy_avail file and starts 
> injecting data into the kernel if it falls below a threshold. Yet, this is a 
> hack. The wakeup function in the kernel should be placed at a different 
> location to also have /dev/urandom benefit from the wakeup.

Either /dev/urandom is a DRBG or is it isn't.  If it's a DRBG then you
don't need to track the entropy of the DRBG at all.  In fact, the
concept doesn't even really make sense for DRBG's.  Since we will be
reseeding the DRBG every five minutes if it is in constant use, there
will be plenty of opportunity to pull from a rngd or some other
hw_random device.

> Finally, one remark which I know you could not care less: :-) 
> 
> I try to use a known DRNG design that a lot of folks have already assessed -- 
> SP800-90A (and please, do not hint to the Dual EC DRBG as this issue was 
> pointed out already by researcher shortly after the first SP800-90A came out 
> in 2007). This way I do not need to re-invent the wheel and potentially 
> forget about things that may be helpful in a DRNG. To allow researchers to 
> assess my ChaCha20 DRNG. that used when no kernel crypto API is compiled. 
> independently from the kernel, I extracted the ChaCha20 DRNG code into a 
> standalone DRNG accessible at [1]. This standalone implementation can be 
> debugged and studied in user space. Moreover it is a simple copy of the 
> kernel code to allow researchers an easy comparison.

SP800-90A consists of a high level architecture of a DRBG, plus some
lower-level examples of how to use that high level architecture
assuming you have a hash function, or a block cipher, etc.  But it
doesn't have an example on using a stream cipher like ChaCha20.  So
all you can really do is follow the high-level architecture.  Mapping
the high-level architecture to the current /dev/random generator isn't
hard.  And no, I don't see the point of renaming things or moving
things around just to make the mapping to the SP800-90A easier.

       	      	      	       	       	  - Ted
