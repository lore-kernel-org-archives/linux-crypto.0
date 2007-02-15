From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 22:32:40 +0100
Message-ID: <20070215213240.GG13958@stusta.de>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <20070214194112.5bec3110.akpm@linux-foundation.org> <20070215041345.GA15654@redhat.com> <200702152055.l1FKtfTY012824@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	torvalds@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org,
	linux-crypto@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58018 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161403AbXBOVcf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Feb 2007 16:32:35 -0500
Content-Disposition: inline
In-Reply-To: <200702152055.l1FKtfTY012824@turing-police.cc.vt.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 15, 2007 at 03:55:41PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 14 Feb 2007 23:13:45 EST, Dave Jones said:
> > One argument in its favour is aparently Red Hat isn't the only vendor
> > with something like this.  I've not investigated it, but I hear rumours
> > that suse has something similar.  Having everyone using the same code
> > would be a win for obvious reasons.
> 
> Another argument in its favor is that it actually allows the kernel to
> implement *real* checking of module licenses and trumps all the proposals
> to deal with MODULE_LICENSE("GPL\0Haha!").  A vendor (or user) that wants
> to be *sure* that only *really really* GPL modules are loaded can simply
> refuse to load unsigned modules - and then refuse to sign a module until
> after they had themselves visited the source's website, verified that the
> source code was available under GPL, and so on.
> 
> Remember - the GPL is about the availability of the source.  And at modprobe
> time, the source isn't available.  So you're left with two options:
> 
> 1) Trust the binary to not lie to you about its license.
> 2) Ask a trusted 3rd party (usually, the person/distro that built the kernel)
> whether they've verified the claim that it's really GPL.

There are different opinions whether the "complete source code" of the 
GPLv2 includes in such cases public keys, making it questionable whether 
your example will survive at court in all jurisdictions.

E.g. remember that gpl-violations.org has already successfully enforced 
the publication of public keys for "firmware only loads signed kernels" 
cases by threatening companies to otherwise take legal actions in 
Germany.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
