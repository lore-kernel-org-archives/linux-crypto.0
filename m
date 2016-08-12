From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Fri, 12 Aug 2016 11:34:55 +0200
Message-ID: <6876524.OiXCMsNJHH@tauon.atsec.com>
References: <4723196.TTQvcXsLCG@positron.chronox.de> <20160811213632.GL10626@thunk.org>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160811213632.GL10626@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 11. August 2016, 17:36:32 CEST schrieb Theodore Ts'o:

Hi Theodore,

> On Thu, Aug 11, 2016 at 02:24:21PM +0200, Stephan Mueller wrote:
> > The following patch set provides a different approach to /dev/random 
which
> > I call Linux Random Number Generator (LRNG) to collect entropy within the
> > Linux kernel. The main improvements compared to the legacy /dev/random is
> > to provide sufficient entropy during boot time as well as in virtual
> > environments and when using SSDs. A secondary design goal is to limit the
> > impact of the entropy collection on massive parallel systems and also
> > allow the use accelerated cryptographic primitives. Also, all steps of
> > the entropic data processing are testable. Finally massive performance
> > improvements are visible at /dev/urandom and get_random_bytes.
> > 
> > The design and implementation is driven by a set of goals described in 
[1]
> > that the LRNG completely implements. Furthermore, [1] includes a
> > comparison with RNG design suggestions such as SP800-90B, SP800-90C, and
> > AIS20/31.
> 
> Given the changes that have landed in Linus's tree for 4.8, how many
> of the design goals for your LRNG are still left not yet achieved?

The core concerns I have at this point are the following:

- correlation: the interrupt noise source is closely correlated to the HID/
block noise sources. I see that the fast_pool somehow "smears" that 
correlation. However, I have not seen a full assessment that the correlation 
is gone away. Given that I do not believe that the HID event values (key 
codes, mouse coordinates) have any entropy -- the user sitting at the console 
exactly knows what he pressed and which mouse coordinates are created, and 
given that for block devices, only the high-resolution time stamp gives any 
entropy, I am suggesting to remove the HID/block device noise sources and 
leave the IRQ noise source. Maybe we could record the HID event values to 
further stir the pool but do not credit it any entropy. Of course, that would 
imply that the assumed entropy in an IRQ event is revalued. I am currently 
finishing up an assessment of how entropy behaves in a VM (where I hope that 
the report is released). Please note that contrary to my initial 
expectations, the IRQ events are the only noise sources which are almost 
unaffected by a VMM operation. Hence, IRQs are much better in a VM 
environment than block or HID noise sources.

- entropy estimate: the current entropy heuristics IMHO have nothing to do 
with the entropy of the data coming in. Currently, the min of first/second/
third derivative of the Jiffies time stamp is used and capped at 11. That 
value is the entropy value credited to the event. Given that the entropy 
rests with the high-res time stamp and not with jiffies or the event value, I 
think that the heuristic is not helpful. I understand that it underestimates 
on average the available entropy, but that is the only relationship I see. In 
my mentioned entropy in VM assessment (plus the BSI report on /dev/random 
which is unfortunately written in German, but available in the Internet) I 
did a min entropy calculation based on different min entropy formulas 
(SP800-90B). That calculation shows that we get from the noise sources is 
about 5 to 6 bits. On average the entropy heuristic credits between 0.5 and 1 
bit for events, so it underestimates the entropy. Yet, the entropy heuristic 
can credit up to 11 bits. Here I think it becomes clear that the current 
entropy heuristic is not helpful. In addition, on systems where no high-res 
timer is available, I assume (I have not measured it yet), the entropy 
heuristic even overestimates the entropy.

- albeit I like the current injection of twice the fast_pool into the 
ChaCha20 (which means that the pathological case where the collection of 128 
bits of entropy would result in an attack resistance of 2 * 128 bits and 
*not* 2^128 bits is now increased to an attack strength of 2^64 * 2 bits), /
dev/urandom has *no* entropy until that injection happens. The injection 
happens early in the boot cycle, but in my test system still after user space 
starts. I tried to inject "atomically" (to not fall into the aforementioned 
pathological case trap) of 32 / 112 / 256 bits of entropy into the /dev/
urandom RNG to have /dev/urandom at least seeded with a few bits before user 
space starts followed by the atomic injection of the subsequent bits.


A minor issue that may not be of too much importance: if there is a user 
space entropy provider waiting with select(2) or poll(2) on /dev/random (like 
rngd or my jitterentropy-rngd), this provider is only woken up when somebody 
pulls on /dev/random. If /dev/urandom is pulled (and the system does not 
receive entropy from the add*randomness noise sources), the user space 
provider is *not* woken up. So, /dev/urandom spins as a DRNG even though it 
could use a topping off of its entropy once in a while. In my jitterentropy-
rngd I have handled the situation that in addition to a select(2), the daemon 
is woken up every 5 seconds to read the entropy_avail file and starts 
injecting data into the kernel if it falls below a threshold. Yet, this is a 
hack. The wakeup function in the kernel should be placed at a different 
location to also have /dev/urandom benefit from the wakeup.
> 
> Reading the paper, you are still claiming huge performance
> improvements over getrandomm and /dev/urandom.  With the use of the
> ChaCha20 (and given that you added a ChaCha20 DRBG as well), it's not
> clear this is still an advantage over what we currently have.

I agree that with your latest changes, the performance of /dev/urandom is 
comparatively to my implementation, considering the tables 6 and 7 in my 
report. Although the speed of my ChaCha20 DRNG is faster for large block 
sizes (470 vs 210 MB/s for 4096 byte blocks), you rightfully state that the 
large block sizes do not really matter and hence I am not really using it for 
comparison. 

The table 6 and 7 reference the old /dev/urandom using still the SHA-1.
> 
> As far as whether or not you can gather enough entropy at boot time,
> what we're really talking about how how much entropy we want to assume
> can be gathered from interrupt timings, since what you do in your code
> is not all that different from what the current random driver is

Correct. I think I am doing exactly what you do regarding the entropy 
collection minus the caveats mentioned above.

> doing.  So it's pretty easy to turn a knob and say, "hey presto, we
> can get all of the entropy we need before userspace starts!"  But
> justifying this is much harder, and using statistical tests isn't
> really sufficient as far as I'm concerned.

I agree that statistics is one hint only. But as of now I have not seen any 
real explanation why an IRQ event measured with a high-res timer should not 
have 1 bit or 0.5 bits of entropy on average. All my statistical measurements 
(see my LRNG paper, see with my hopefully released VM assessment paper) show 
that the statistical measurement indicates that each high-res time stamp of 
an IRQ has more 4 bits of entropy at least when the system is under attack. 
Both one bit or 0.5 bits is more than enough to have a properly working /dev/
random even in virtual environments, embedded systems, headless systems, 
systems with SSDs, systems using a device mapper, etc. All those type of 
systems are currently subject to heavy penalties because of the collision 
problem I mentioned in the first bullet above.

Finally, one remark which I know you could not care less: :-) 

I try to use a known DRNG design that a lot of folks have already assessed -- 
SP800-90A (and please, do not hint to the Dual EC DRBG as this issue was 
pointed out already by researcher shortly after the first SP800-90A came out 
in 2007). This way I do not need to re-invent the wheel and potentially 
forget about things that may be helpful in a DRNG. To allow researchers to 
assess my ChaCha20 DRNG. that used when no kernel crypto API is compiled. 
independently from the kernel, I extracted the ChaCha20 DRNG code into a 
standalone DRNG accessible at [1]. This standalone implementation can be 
debugged and studied in user space. Moreover it is a simple copy of the 
kernel code to allow researchers an easy comparison.

[1] http://www.chronox.de/chacha20_drng.html

Ciao
Stephan
