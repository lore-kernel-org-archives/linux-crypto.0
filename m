From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Wed, 27 Apr 2016 19:47:33 +0200
Message-ID: <2710105.QN8ttzUxoi@positron.chronox.de>
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
Received: from mail.eperm.de ([89.247.134.16]:53794 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbcD0Rrj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Apr 2016 13:47:39 -0400
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

I have ported the NUMA logic to the LRNG. It instantiates the secondary DRBG 
once for each NUMA node just like your patch.

Though, the initialization of the instances of the secondary DRBGs is 
different. I serialize the initialization such that one DRBG instance is 
seeded at a time from the primary DRBG.

I tested the code by using the per-CPU logic instead of per-NUMA node. This 
test shows that all works fine.

I then changed it to use a per NUMA node instance. It works on my test systems 
which instantiate the DRBG only once as I only have one node.

May I ask you to test that code on your system as I do not have access to a 
NUMA system? I will release a new version shortly.

Ciao
Stephan
