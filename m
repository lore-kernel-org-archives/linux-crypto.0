From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 22:01:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0702152143470.14458@scrub.home>
References: <Pine.LNX.4.64.0702151530260.14458@scrub.home>
 <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
 <32081.1171560770@redhat.com> <Pine.LNX.4.64.0702151901380.14458@scrub.home>
 <Pine.LNX.4.63.0702151155330.9862@qynat.qvtvafvgr.pbz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
	akpm@osdl.org, herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
	davej@redhat.com, arjan@infradead.org, linux-crypto@vger.kernel.org
To: David Lang <david.lang@digitalinsight.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from scrub.xs4all.nl ([194.109.195.176]:52674 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161260AbXBOVCe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Feb 2007 16:02:34 -0500
In-Reply-To: <Pine.LNX.4.63.0702151155330.9862@qynat.qvtvafvgr.pbz>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Thu, 15 Feb 2007, David Lang wrote:

> this issue, and these holes keep comeing up in discussions, why can't these
> holes be closed? I seem to remember seeing patches that would remove /dev/kmem
> being sent to the list, but they weren't accepted into the kernel (and I seem
> to remember people being against the concept of removeing them, not against
> techincal details of the patches. but this was many years ago)

1. It depends on the ratio of added code and its usefulness. I must assume 
the first patch didn't even make it to the kernel due to its size, so I 
think it's not unreasonable to explore the alternatives.
2. There are many ways to load an unauthorized module, thus you have to 
prevent any modification of the kernel not just in memory but also on 
disk.

bye, Roman
