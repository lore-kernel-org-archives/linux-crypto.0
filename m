From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 2/3] SCRIPTS: s/should/must/ for all ERRORs
Date: Wed, 10 Feb 2010 21:22:00 -0800
Message-ID: <20100210212200.1e83b7c5.rdunlap@xenotime.net>
References: <1265762465-21114-1-git-send-email-richih.mailinglist@gmail.com>
	<20100210084908.ad315b9b.rdunlap@xenotime.net>
	<2d460de71002100959j49c25e37n11a8870454251d84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Walker <dwalker@fifo99.com>,
	linux-kernel@vger.kernel.org
To: Richard Hartmann <richih.mailinglist@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:38640 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750832Ab0BKFWF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Feb 2010 00:22:05 -0500
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-crypto@vger.kernel.org>; Wed, 10 Feb 2010 21:22:01 -0800
In-Reply-To: <2d460de71002100959j49c25e37n11a8870454251d84@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 10 Feb 2010 18:59:11 +0100 Richard Hartmann wrote:

> PS: As I am new to the whole concept of touching the large scary kernel
> let me use this opportunity to ask if I should expect answers on the
> other patch emails or if they are just merged zsh-style: Silently and
> you will notice what went through when you pull a few days later.

OK, since nobody else has tried to answer this, I'll give it a shot.

It happens many different ways in linux-kernel land, mostly depending on
who is doing the merging, and it's really up to the subsystem or driver
maintainer.

If Andrew Morton merges a patch into his mmotm patchset, you'll get an email
confirmation of it, but this just means that it's in the mmotm patches for
testing, not necessarily for merging into the mainline kernel tree.

If you send a networking patch and David S. Miller merges it, you will get
both an acknowledgement of that and you can see the patch's status at
http://patchwork.ozlabs.org/project/netdev/list/

Same for multimedia driver patches, but view their status at
http://patchwork.kernel.org/project/linux-media/list/

I don't recall if Andy Whitcroft acks checkpatch patches or not, but
you should note that checkpatch is not his highest priority job
(but I'm not trying to speak for him).

If you send patches for the staging or USB or stable pr serial/tty trees,
GregKH will usually ack them when they are merged.

If you send patches for ATA drivers, Jeff Garzik will usually ack them when
they are merged.

If you send patches for the SCSI drivers/subsystem, good luck, the SCSI
mailing list is the best place to find out their status.

If you send patches for parts of Documentation/ that are obviously not
cared for by someone else, I'll try to get to them, but that's not my
highest priority either.  I will ack them if/when I merge them.

I guess if it's not clear to you or anyone else, most Linux maintainers
also have other jobs that they usually need to do...

HTH.  If you have specific questions, ask away, or maybe Andy can tell us
about checkpatch patches.

---
~Randy
