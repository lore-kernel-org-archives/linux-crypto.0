From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Tue, 26 Apr 2016 14:01:10 +0200
Message-ID: <1925716.MouNeQh8Ln@positron.chronox.de>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com> <7735834.PWhNOHfhKX@positron.chronox.de> <20160425193531.GC13997@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53668 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbcDZMBN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2016 08:01:13 -0400
In-Reply-To: <20160425193531.GC13997@two.firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 25. April 2016, 12:35:32 schrieb Andi Kleen:

Hi Andi,

> > > > If it is the latter, can you explain where the scalability issue comes
> > > > in?
> > > 
> > > A single pool which is locked/written to does not scale. Larger systems
> > > need multiple pools
> > 
> > That would imply that even when you have a system with 1000 CPUs, you want
> > to have a large amount of random numbers. Is this the use case?
> 
> That is right. Large systems do more work than small systems.
> If the system is for example handling SSL connections it needs
> more random numbers to handle more connections.
> 
> BTW the problems happen long before 1000 CPUs, more like 12-18 cores
> competing.
> 
> Also today's large system is tomorrow's small systems. The
> systems affected are actually not that large anymore.
> 
> The original numbers
> 
> Without patchkit:
> 
> 1 node:  1x
> 2 nodes: 0.75x
> 3 nodes: 0.55x
> 4 nodes: 0.42x

I have changed the LRNG now such that a multiple instantiation of the 
secondary DRBG can be implemented with very limited amount of code.

Thus, the proposal you have for the nonblocking_pool can be adapted.

Yet I have not implemented such duplication as I first would like to see 
whether the initial proposal of my LRNG is considered acceptable.

Ciao
Stephan
