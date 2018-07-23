From: Ken Moffat <zarniwhoop73@googlemail.com>
Subject: Does /dev/urandom now block until initialised ?
Date: Mon, 23 Jul 2018 04:43:01 +0100
Message-ID: <CANVEwpbaU5=wMT_iSh9XrkmbLvqKjx4+v6PDizamaY0gWvk-mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Theodore Y. Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Ted,

last week you proposed an rfc patch to gather entropy from the CPU's
hwrng, and I was pleased - until I discovered one of my stalling
desktop machines does not have a hwrng.  At that point I thought that
the problem was only from reading /dev/random, so I went away to look
at persuading the immediate consumer (unbound) to use /dev/urandom.

Did that, no change.  Ran strace from the bootscript, confirmed that
only /dev/urandom was being used, and that it seemed to be blocking.
Thought maybe this was the olnl problematic bootscript, tried moving
it to later, but hit the same problem on chronyd (again, seems to use
urandom). And yes, I probably should have started chronyd first
anyway, but that's irrelevant to this problem.

BUT: I'm not sure if I've correctly understood what is happening.
It seems to me that the fix for CVE-2018-1108 (4.17-rc1, 4.16.4)
means /dev/urandom will now block until fully initialised.

Is that correct and intentional ?

If so, to get the affected desktop machines to boot I seem to have
some choices:

1. Wait for two and a half minutes (timed on the kaveri, the haswell
seemed to take a similar time).

2. Sit at the keyboard and start thumping it once userspace has
started.

3. For the haswell, apply your patch and trust that the CPU has not
been backdored

4. Run haveged.

The latter certainly lets it boot in a reasonable time, but people
who understand this seem to regard it as untrustworthy.  For users
of /dev/urandom that is no big deal, but does it not mean that the
values from /dev/random will be similarly untrustworthy and
therefore I should not use this machine for generating long-lived
secure keys ?

TIA.

=C4=B8en
