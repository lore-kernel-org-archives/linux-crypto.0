From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Does /dev/urandom now block until initialised ?
Date: Mon, 23 Jul 2018 11:16:08 -0400
Message-ID: <20180723151608.GE3358@thunk.org>
References: <CANVEwpbaU5=wMT_iSh9XrkmbLvqKjx4+v6PDizamaY0gWvk-mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
To: Ken Moffat <zarniwhoop73@googlemail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANVEwpbaU5=wMT_iSh9XrkmbLvqKjx4+v6PDizamaY0gWvk-mg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 23, 2018 at 04:43:01AM +0100, Ken Moffat wrote:
> Ted,
> 
> last week you proposed an rfc patch to gather entropy from the CPU's
> hwrng, and I was pleased - until I discovered one of my stalling
> desktop machines does not have a hwrng.  At that point I thought that
> the problem was only from reading /dev/random, so I went away to look
> at persuading the immediate consumer (unbound) to use /dev/urandom.
> 
> Did that, no change.  Ran strace from the bootscript, confirmed that
> only /dev/urandom was being used, and that it seemed to be blocking.
> Thought maybe this was the olnl problematic bootscript, tried moving
> it to later, but hit the same problem on chronyd (again, seems to use
> urandom). And yes, I probably should have started chronyd first
> anyway, but that's irrelevant to this problem.

Nope, /dev/urandom still doesn't block.  Are you sure it isn't caused
by something calling getrandom(2) --- which *will* block?

We intentionally left /dev/urandom non-blocking, because of backwards
compatibility.

> BUT: I'm not sure if I've correctly understood what is happening.
> It seems to me that the fix for CVE-2018-1108 (4.17-rc1, 4.16.4)
> means /dev/urandom will now block until fully initialised.
> 
> Is that correct and intentional ?

No, that's not right.  What the fix does is more accurately account
for the entropy accounting before getrandom(2) would become
non-blocking.  There were a bunch of things we were doing wrong,
including assuming that 100% of the bytes being sent via
add_device_entropy() were random --- when some of the things that were
feeding into it was the (fixed) information you would get from running
dmidecode (e.g., the fixed results from the BIOS configuration data).

Some of those bytes might not be known to an external adversary (such
as your CPU mainboard's serial number), but it's not exactly *Secret*.

> If so, to get the affected desktop machines to boot I seem to have
> some choices...

Well, this probably isn't going to be popular, but the other thing
that might help is you could switch distro's.  I'm guessing you run a
Red Hat distro, probably Fedora, right?

The problem which most people are seeing turns out to be a terrible
interaction between dracut-fips, systemd and a Red Hat specific patch
to libgcrypt for FIPS/FEDRAMP compliance:

https://src.fedoraproject.org/rpms/libgcrypt/blob/master/f/libgcrypt-1.6.2-fips-ctor.patch#_23

Uninstalling dracut-fips and recreating the initramfs might also help.

One of the reasons why I didn't see the problem when I was developing
the remediation patch for CVE-2018-1108 is because I run Debian
testing, which doesn't have this particular Red Hat patch.

> The latter certainly lets it boot in a reasonable time, but people
> who understand this seem to regard it as untrustworthy.  For users
> of /dev/urandom that is no big deal, but does it not mean that the
> values from /dev/random will be similarly untrustworthy and
> therefore I should not use this machine for generating long-lived
> secure keys ?

This really depends on how paranoid / careful you are.  Remember, your
keyboard controller was almost certainly built in Shenzhen, China, and
Matt Blaze published a paper on the Jitterbug in 2006:

	http://www.crypto.com/papers/jbug-Usenix06-final.pdf

In practice, after 30 minutes of operation, especially if you are
using the keyboard, the entropy pool *will* be sufficiently
randomized, whether or not it was sufficientl randomized at boot.  The
real danger of CVE-2018-1108 was always long-term keys generated at
first boot.  That was the problem that was discussed in the "Mining
your p's and q's: Detection of Widespread Weak Keys in Network
Devices" (see https://factorable.net).

So generating long-lived keys means (a) you need to be sure you trust
all of the software on the system --- some very paranoid people such
as Bruce Schneier used a freshly installed machine from CD-ROM that
was never attached to the network before examining materials from
Edward Snowden, and (b) making sure the entropy pool is initialized.

Remember we are constantly feeding input from the hardware sources
into the entropy pool; it doesn't stop the moment we think the entropy
pool is initialized.  And you can always mix extra "stuff" into the
entropy pool by echoing the results of say, taking series of dice
rolls, aond sending it via the "cat" or "echo" command into
/dev/urhandom.

So it should be possible to use the machine for generated long lived
keys; you might just need to be a bit more careful before you do it.
It's really keys generated automatically at boot that are most at risk
--- and you can always regenerate the host SSH keys after a fresh
install.  In fact, what I have done in the past when I first login to
a freshly created Cloud VM system is to run command like "dd
if=/dev/urandom count=1 bs=256 | od -x", then login to VM, and then
run "cat > /dev/urandom", and cut and paste the results of the od -x
output into the guest VM, to better initialize the entropy pool on the
VM before regenerating the host SSH keys.

Cheers,

					- Ted
