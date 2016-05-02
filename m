From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] random: add interrupt callback to VMBus IRQ handler
Date: Mon, 2 May 2016 08:56:09 -0400
Message-ID: <20160502125609.GF4770@thunk.org>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-4-git-send-email-tytso@mit.edu>
 <CAH8yC8nFUm6-+AhYWCHiLCucCbcOu5Hba21tzAaonVyH6OZOAA@mail.gmail.com>
 <1465960.gVT9QnQ1pA@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: noloader@gmail.com, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35612 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbcEBM4S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 08:56:18 -0400
Content-Disposition: inline
In-Reply-To: <1465960.gVT9QnQ1pA@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 02, 2016 at 11:14:25AM +0200, Stephan Mueller wrote:
> The issue of rollback (if you refer to activating an earlier saved image of 
> the guest) is a real issue the guest cannot do anything about it that is 
> effective (i.e. the guest can do without the help of the VMM). Note, rollback 
> is just a special case of a much broader issue of the duplication of the RNG 
> state by the VMM (be it snapshots, move of a guest to another VMM, 
> suspend/resume, ...). However, the patch to enable interrupts does not seem to 
> be related to that issue as interrupts are not re-issued in case of rollbacks, 
> are they?

Rollback is just a much broader issue of how can you maintain security
when the VMM is run by the NSA, and can do arbitrary things to mess
with the security of the guest OS (including reading keys straight out
of guest kernel memory, etc.).   Hint: you can't.  :-)

If we are talking about someone who is realistically trying to do
something useful with duplicating VMM state, I'm not aware of anyone
who is actually trying to clone a running VMM in order to launch new
worker nodes.  People will clone disk snapshots to rapidly bring up
rapid nodes, and so making sure we have a way to handle cases where
you can't count on /var/state/random.seed on being useful is
important.  The usual answer is to use something like virtio-rng, but
all of the answers are going to assume that the host system is
trustworthy.

If you are worried about a potential attack where the CIA has cut a
deal with Amazon AWS just as the NSA did with RSADSI and DUAL-EC DRBG,
you might as well go home...

						- Ted
