From: Andi Kleen <andi@firstfloor.org>
Subject: Re: random(4) changes
Date: Mon, 25 Apr 2016 12:35:32 -0700
Message-ID: <20160425193531.GC13997@two.firstfloor.org>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
 <31776489.IE3eGLxohC@positron.chronox.de>
 <20160425173825.GB13997@two.firstfloor.org>
 <7735834.PWhNOHfhKX@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7735834.PWhNOHfhKX@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> > > If it is the latter, can you explain where the scalability issue comes in?
> > 
> > A single pool which is locked/written to does not scale. Larger systems
> > need multiple pools
> 
> That would imply that even when you have a system with 1000 CPUs, you want to 
> have a large amount of random numbers. Is this the use case?

That is right. Large systems do more work than small systems.
If the system is for example handling SSL connections it needs
more random numbers to handle more connections.

BTW the problems happen long before 1000 CPUs, more like 12-18 cores
competing.

Also today's large system is tomorrow's small systems. The
systems affected are actually not that large anymore.

The original numbers

Without patchkit:

1 node:  1x
2 nodes: 0.75x
3 nodes: 0.55x
4 nodes: 0.42x

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
