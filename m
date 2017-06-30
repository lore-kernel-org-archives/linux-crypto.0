From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure RNG is
 seeded before use
Date: Thu, 29 Jun 2017 23:02:47 -0700
Message-ID: <1498802567.24896.12.camel@haakon3.risingtidesystems.com>
References: <20170606174804.31124-1-Jason@zx2c4.com>
         <2639082.PtrrGWOPPL@positron.chronox.de>
         <1498440189.26123.85.camel@haakon3.risingtidesystems.com>
         <1678474.GnYBdSlWgs@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Lee Duncan <lduncan@suse.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Eric Biggers <ebiggers3@gmail.com>,
        Chris Leech <cleech@redhat.com>, open-iscsi@googlegroups.com,
        target-devel <target-devel@vger.kernel.org>
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43106 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdF3GCt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2017 02:02:49 -0400
In-Reply-To: <1678474.GnYBdSlWgs@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2017-06-26 at 19:38 +0200, Stephan Müller wrote:
> Am Montag, 26. Juni 2017, 03:23:09 CEST schrieb Nicholas A. Bellinger:
> 
> Hi Nicholas,
> 
> > Hi Stephan, Lee & Jason,
> > 
> > (Adding target-devel CC')
> > 
> > Apologies for coming late to the discussion.  Comments below.
> > 
> > On Sun, 2017-06-18 at 10:04 +0200, Stephan Müller wrote:
> > > Am Samstag, 17. Juni 2017, 05:45:57 CEST schrieb Lee Duncan:
> > > 
> > > Hi Lee,
> > > 
> > > > In your testing, how long might a process have to wait? Are we talking
> > > > seconds? Longer? What about timeouts?
> > > 
> > > In current kernels (starting with 4.8) this timeout should clear within a
> > > few seconds after boot.
> > > 
> > > In older kernels (pre 4.8), my KVM takes up to 90 seconds to reach that
> > > seeding point. I have heard that on IBM System Z this trigger point
> > > requires minutes to be reached.
> > 
> > I share the same concern as Lee wrt to introducing latency into the
> > existing iscsi-target login sequence.
> > 
> > Namely in the use-cases where a single node is supporting ~1K unique
> > iscsi-target IQNs, and fail-over + re-balancing of IQNs where 100s of
> > login attempts are expected to occur in parallel.
> > 
> > If environments exist that require non trivial amounts of time for RNG
> > seeding to be ready for iscsi-target usage, then enforcing this
> > requirement at iscsi login time can open up problems, especially when
> > iscsi host environments may be sensitive to login timeouts, I/O
> > timeouts, et al.
> > 
> > That said, I'd prefer to simply wait for RNG to be seeded at modprobe
> > iscsi_target_mod time, instead of trying to enforce randomness during
> > login.
> > 
> > This way, those of use who have distributed storage platforms can know
> > to avoid putting a node into a state to accept iscsi-target IQN export
> > migration, before modprobe iscsi_target_mod has successfully loaded and
> > RNG seeding has been confirmed.
> > 
> > WDYT..?
> 
> We may have a chicken and egg problem when the wait is at the modprobe time. 
> Assume the modprobe happens during initramfs time to get access to the root 
> file system. In this case, you entire boot process will lock up for an 
> indefinite amount of time. The reason is that in order to obtain events 
> detected by the RNG, devices need to be initialized and working. Such devices 
> commonly start working after the the root partition is mounted as it contains 
> all drivers, all configuration information etc.
> 
> Note, during the development of my /dev/random implementation, I added the 
> getrandom-like blocking behavior to /dev/urandom (which is the equivalent to 
> Jason's patch except that it applies to user space). The boot process locked 
> up since systemd wanted data from /dev/urandom while it processed the 
> initramfs. As it did not get any, the boot process did not commence that could 
> deliver new events to be picked up by the RNG.
> 
> As I do not have such an iscsi system, I cannot test Jason's patch. But maybe 
> the mentioned chicken-and-egg problem I mentioned above is already visible 
> with the current patch as it will lead to a blocking of the mounting of the 
> root partition in case the root partition is on an iscsi target.

AFAIK, there are no distro initramfs dependencies for iscsi_target_mod,
and every environment I've ever seen loads iscsi_target_mod after
switching to the real rootfs.

For an iscsi initiator that might not been the case, especially if the
rootfs is running atop a iscsi LUN.

But at least for iscsi-target mode, any blocking during modprobe waiting
for RNG seeding would happen outside of initramfs.
