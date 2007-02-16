From: Olaf Kirch <okir@lst.de>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Fri, 16 Feb 2007 01:15:04 +0100
Message-ID: <20070216001504.GA20951@linux.suse.de>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <200702142214.53625.agruen@suse.de> <200702152034.l1FKYS93012172@turing-police.cc.vt.edu> <200702151412.43758.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valdis.Kletnieks@vt.edu, Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	torvalds@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org,
	linux-crypto@vger.kernel.org
To: Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [62.138.223.154] ([62.138.223.154]:4570 "EHLO
	okir.darmstadt.suse.de" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422876AbXBPAdb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Feb 2007 19:33:31 -0500
Content-Disposition: inline
In-Reply-To: <200702151412.43758.agruen@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 15 February 2007 12:34, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 14 Feb 2007 22:14:53 PST, Andreas Gruenbacher said:
> > I agree, that's really what should happen. We solve this by marking
> > modules as supported, partner supported, or unsupported, but in an
> > "insecure" way, so partners and users could try to fake the support
> > status of a module and/or remove status flags from Oopses, and
> > cryptography wouldn't save us.
>
> Where cryptography *can* save you is that a partner or user can't fake a
> 'Suse Supported' signature without access to the Suse private key.

The user has control over the running kernel, and given enough time
and clue, can circumvent any protection mechanism the vendor comes
up with. And that's a good thing IMO, unless you believe in "trusted
computing" and all those Bigbrotherisms some agencies want to put
in your machines.

So the user is running a system in some state that may or may not
resemble what the vendor shipped. When the machine crashes, the
user is free to munge the oops until it looks like a valid one.

Someone mentioned in this context that you can sign the oops - but to
do that you need a private key. And the whole point of this exercise is
that the user does not have access to that key.

So as far as support is concerned, you're back in square one.
You cannot tell a "genuine" oops produced on a supported kernel
from a doctored one produced on Joe Doe's Garage Kernel.

Olaf
-- 
Olaf Kirch        |  Anyone who has had to work with X.509 has probably
okir@lst.de       |  experienced what can best be described as
------------------+  ISO water torture. -- Peter Gutmann
