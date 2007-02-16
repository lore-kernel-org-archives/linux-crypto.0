From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Fri, 16 Feb 2007 21:27:58 +0100
Message-ID: <1171657678.12771.645.camel@laptopd505.fenrus.org>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
	 <20070215221304.GB6602@ucw.cz>  <20070216202135.GA22121@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, David Howells <dhowells@redhat.com>,
	torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946126AbXBPU2J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Feb 2007 15:28:09 -0500
In-Reply-To: <20070216202135.GA22121@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


> 
> The restricted dev/mem patches we've had in Fedora for a while
> do the right thing, but they're a bit crufty (in part due to
> drivers/char/mem.c being a bit of a mess before we even start
> patching it).  I've had "clean these up for upstream" on my
> todo for a while. I might get around to it one of these days.


the real thing is that /dev/mem is too many things for too many people.
Fundamentally it has 3 components
1) ram-but-not-kernel data: basically BIOS datastructures
2) kernel visible ram: user/kernel data, this has all the nasty cache
coherency issues. This is also a "debug only" use, and "rootkit only"
sometimes ;) 
3) MMIO space: this really should not be used anymore, sysfs provides a
MUCH better interface and it also breaks if you have enforcing IOMMU's
in the system... it can't really work since the kernel doesn't get told
which device is being accessed

unless we split this up (well the third is split already) it's going to
remain a big mess.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org
