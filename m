From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/5] random: fix crng_ready() test
Date: Thu, 17 May 2018 16:53:27 -0400
Message-ID: <20180517205327.GB15263@thunk.org>
References: <20180413013046.404-1-tytso@mit.edu>
 <1699469.KmO53oa8XU@tauon.chronox.de>
 <20180413125313.GA2633@thunk.org>
 <4393662.RPWnPK42dp@tauon.chronox.de>
 <20180413170037.GA28721@thunk.org>
 <6bb4d4cb-aafa-7440-0dc3-40faf647ec89@csail.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        rostedt@goodmis.org
To: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6bb4d4cb-aafa-7440-0dc3-40faf647ec89@csail.mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 16, 2018 at 05:07:08PM -0700, Srivatsa S. Bhat wrote:
> 
> On a Photon OS VM running on VMware ESXi, this patch causes a boot speed
> regression of 5 minutes :-( [ The VM doesn't have haveged or rng-tools
> (rngd) installed. ]
> 
> [    1.420246] EXT4-fs (sda2): re-mounted. Opts: barrier,noacl,data=ordered
> [    1.469722] tsc: Refined TSC clocksource calibration: 1900.002 MHz
> [    1.470707] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x36c65c1a9e1, max_idle_ns: 881590695311 ns
> [    1.474249] clocksource: Switched to clocksource tsc
> [    1.584427] systemd-journald[216]: Received request to flush runtime journal from PID 1
> [  346.620718] random: crng init done
> 
> Interestingly, the boot delay is exacerbated on VMs with large amounts
> of RAM. For example, the delay is not so noticeable (< 30 seconds) on a
> VM with 2GB memory, but goes up to 5 minutes on an 8GB VM.
> 
> Also, cloud-init-local.service seems to be the one blocking for entropy
> here.

So the first thing I'd ask you to investigate is what the heck
cloud-init-local.service is doing, and why it really needs
cryptographic grade random numbers?

> It would be great if this CVE can be fixed somehow without causing boot speed
> to spuike from ~20 seconds to 5 minutes, as that makes the system pretty much
> unusable. I can workaround this by installing haveged, but ideally an in-kernel
> fix would be better. If you need any other info about my setup or if you have
> a patch that I can test, please let me know!

So the question is why is strong random numbers needed by
cloud-init-local, and how much do you trust either haveged and/or
RDRAND (which is what you will be depending upon if you install
rng-tools).  If you believe that Intel and/or the NSA hasn't
backdoored RDRAND[1], or you believe that because Intel processor's
internal cache architecture isn't publically documented, and it's
Soooooooo complicated that no one can figure it out (which is what you
will be depending upon if you if you choose haveged), be my guest.  I
personally consider the latter to be "security via obscu7rity", but
others have different opinions.

[1] As an aside, read the best paper from the 37th IEEE Symposium on
Security and Privacy and weep:

https://www.computerworld.com/article/3079417/security/researchers-built-devious-undetectable-hardware-level-backdoor-in-computer-chips.html

If it turns out that the security if your VM is critically dependent
on what cloud-init-local.service is doing, and you don't like making
those assumptions, then you may need to ask VMWare ESXi to make
virtio-rng available to guest OS's, and then make Photon OS depend on
a secure RNG available to the host OS.

Best regards,

						- Ted
