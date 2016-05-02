From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/3] random: add interrupt callback to VMBus IRQ handler
Date: Mon, 02 May 2016 11:14:25 +0200
Message-ID: <1465960.gVT9QnQ1pA@tauon.atsec.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu> <1462170413-7164-4-git-send-email-tytso@mit.edu> <CAH8yC8nFUm6-+AhYWCHiLCucCbcOu5Hba21tzAaonVyH6OZOAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54432 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbcEBJO2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 05:14:28 -0400
In-Reply-To: <CAH8yC8nFUm6-+AhYWCHiLCucCbcOu5Hba21tzAaonVyH6OZOAA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 2. Mai 2016, 05:00:47 schrieb Jeffrey Walton:

Hi Jeffrey,

> On Mon, May 2, 2016 at 2:26 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > From: Stephan Mueller <smueller@chronox.de>
> > 
> > The Hyper-V Linux Integration Services use the VMBus implementation for
> > communication with the Hypervisor. VMBus registers its own interrupt
> > handler that completely bypasses the common Linux interrupt handling.
> > This implies that the interrupt entropy collector is not triggered.
> > ...
> 
> Stephan correctly identified the problem of virtualized environments
> in his paper, but there does not appear to be any real defenses in
> place for VM rollback attacks.

The issue the patch addresses is only that on Hyper-V with para-virt drivers, 
the /dev/random implementation does not receive interrupts.

The issue of rollback (if you refer to activating an earlier saved image of 
the guest) is a real issue the guest cannot do anything about it that is 
effective (i.e. the guest can do without the help of the VMM). Note, rollback 
is just a special case of a much broader issue of the duplication of the RNG 
state by the VMM (be it snapshots, move of a guest to another VMM, 
suspend/resume, ...). However, the patch to enable interrupts does not seem to 
be related to that issue as interrupts are not re-issued in case of rollbacks, 
are they?

Ciao
Stephan
