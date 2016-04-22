From: Sandy Harris <sandyinchina@gmail.com>
Subject: random(4) changes
Date: Fri, 22 Apr 2016 18:27:48 -0400
Message-ID: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Stephan Mueller <smueller@chronox.de>
To: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Stephan has recently proposed some extensive changes to this driver,
and I proposed a quite different set earlier. My set can be found at:
https://github.com/sandy-harris

This post tries to find the bits of both proposals that seem clearly
worth doing and entail neither large implementation problems nor large
risk of throwing out any babies with the bathwater.

Unfortunately, nothing here deals with the elephant in the room -- the
distinctly hard problem of making sure the driver is initialised well
enough & early enough. That needs a separate post, probably a separate
thread. I do not find Stepan's solution to this problem plausible and
my stuff does not claim to deal with it, though it includes some
things that might help.

I really like Stephan's idea of simplifying the interrupt handling,
replacing the multiple entropy-gathering calls in the current driver
with one routine called for all interrupts. See section 1.2 of his
doc. That seems to me a much cleaner design, easier both to analyse
and to optimise as a fast interrupt handler. I also find Stephan's
arguments that this will work better on modern  systems -- VMs,
machines with SSDs, etc. -- quite plausible.

Note, though, that I am only talking about the actual interrupt
handling, not the rest of Stephan's input handling code: the parity
calculation and XORing the resulting single bit into the entropy pool.
I'd be happier, at least initially, with a patch that only implemented
a single-source interrupt handler that gave 32 or 64 bits to existing
input-handling code.

Stephan: would you want to provide such a patch?
Ted: would you be inclined to accept it?

I also quite like Stephan's idea of replacing the two output pools
with a NIST-approved DBRG, mainly because this would probably make
getting various certifications easier. I also like the idea of using
crypto lib code for that since it makes both testing & maintenance
easier. This strikes me, though, as a do-when-convenient sort of
cleanup task, not at all urgent unless there are specific
certifications we need soon.

As for my proposals, I of course think they are full of good ideas,
but there's only one I think is really important.

In the current driver -- and I think in Stephan's, though I have not
looked at his code in any detail, only his paper -- heavy use of
/dev/urandom or the kernel get_random_bytes() call can deplete the
entropy available to /dev/random. That can be a serious problem in
some circumstances, but I think I have a fix.

You have an input pool (I) plus a blocking pool (B) & a non-blocking
pool (NB). The problem is what to do when NB must produce a lot of
output but you do not want to deplete I too much. B & NB might be
replaced by DBRGs and the problem would not change.

B must be reseeded before very /dev/random output, NB after some
number of output blocks. I used #define SAFE_OUT 503 but some other
number might be better depending how NB is implemented & how
paranoid/conservative one feels.

B can only produce one full-entropy output, suitable for /dev/random,
per reseed but B and NB are basically the same design so B can also
produce SAFE_OUT reasonably good random numbers per reseed. Use those
to reseed NB.and you reduce the load on I for reseeding NB from
SAFE_OUT (use I every time NB is reseeded) to SAFE_OUT*SAFE_OUT (use I
only to reseed B).

This does need analysis by cryptographers, but at a minimum it is
basically plausible and, even with some fairly small value for
SAFE_OUT, it greatly alleviates the problem.
