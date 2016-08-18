From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Thu, 18 Aug 2016 13:27:12 -0400
Message-ID: <20160818172712.GA22054@thunk.org>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
 <20160811213632.GL10626@thunk.org>
 <20160817214254.GA22438@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Stephan Mueller <smueller@chronox.de>, herbert@gondor.apana.org.au,
        sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
        John Denker <jsd@av8n.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Joe Perches <joe@perches.com>,
        George Spelvin <linux@horizon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42814 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932170AbcHSBSP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2016 21:18:15 -0400
Content-Disposition: inline
In-Reply-To: <20160817214254.GA22438@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 17, 2016 at 11:42:55PM +0200, Pavel Machek wrote:
> 
> Actually.. I'm starting to believe that getting enough entropy before
> userspace starts is more important than pretty much anything else.
> 
> We only "need" 64-bits of entropy, AFAICT. If it passes statistical
> tests, I'd use it... for initial bringup.

Definitely not 64 bits.  Back in *1996* the estimate was that we
needed at least 75-bits in order to be protected against brute force
attacks.  It's been two *deacdes* years later, and granted Moore's law
has ceased to apply in the last couple of years, but I'm sure 64 bits
is not enough.

What is your specific concern vis-a-vis when userspace starts?  We now
print a warning if someone tries to draw from /dev/urandom, and so it
should be easy to see if someone is doing something dangerous.  The
have only been known cases (at last as far asI know where) where some
software was doing something as *insane* as to create keys right out
of the box was.  One was ssh, and at least on a modern Debian system,
that doesn't happen until fairly late in the process:

% systemd-analyze critical-chain ssh.service
The time after the unit is active or started is printed after the "@" character.
The time the unit takes to start is printed after the "+" character.

ssh.service +888ms
└─network.target @31.473s
  └─wpa_supplicant.service @32.958s +770ms
    └─basic.target @19.479s
      └─sockets.target @19.479s
        └─acpid.socket @19.479s
          └─sysinit.target @19.414s
            └─systemd-timesyncd.service @18.079s +1.330s
              └─systemd-tmpfiles-setup.service @17.512s +78ms
                └─local-fs.target @17.501s
                  └─run-user-15806.mount @43.047s
                    └─local-fs-pre.target @16.616s
                      └─systemd-tmpfiles-setup-dev.service @755ms +930ms
                        └─kmod-static-nodes.service @729ms +17ms
                          └─system.slice @653ms
                            └─-.slice @608ms

The other was HP, which was generating an RSA key very shortly after
the first time the printer was powered on.

> We can switch to more conservative estimates when system is fully
> running. But IMO it is very important to get _some_ randomness at the
> begining...

We're doing this already in the latest getrandom(2) implementation.
For the purposes of initializing the crng, we assume that each
interrupt has a single bit of entropy.  So it requires 128 initerrupts
for getrandom(2) to be fully initialized.  I'm actually worried that
this is too high as it is for architectures that don't have a
fine-grained clock.  Given that on many of these embedded platforms
there is a oscillator which drives all of the clocks and subsystems,
it just doesn't make *sense* that than each interrupt could result in
5-6 bits of entropy, no matter what a magical statistical formula
might say.

(Creation of some completely determinsitic sequences that cause the
magical statistcal formulas to claim a vast number of entropy bits is
left as an exercise to the reader.)

Cheers, 

							- Ted
