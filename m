From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Mon, 25 Apr 2016 19:56:17 +0200
Message-ID: <7735834.PWhNOHfhKX@positron.chronox.de>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com> <31776489.IE3eGLxohC@positron.chronox.de> <20160425173825.GB13997@two.firstfloor.org>
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
Received: from mail.eperm.de ([89.247.134.16]:53596 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791AbcDYR4V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 13:56:21 -0400
In-Reply-To: <20160425173825.GB13997@two.firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 25. April 2016, 10:38:25 schrieb Andi Kleen:

Hi Andi,

> On Mon, Apr 25, 2016 at 07:25:55PM +0200, Stephan Mueller wrote:
> > Am Montag, 25. April 2016, 09:06:03 schrieb Andi Kleen:
> > 
> > Hi Andi,
> > 
> > > Sandy Harris <sandyinchina@gmail.com> writes:
> > > 
> > > There is also the third problem of horrible scalability of /dev/random
> > > output on larger systems, for which patches are getting ignored.
> > > 
> > > https://lkml.org/lkml/2016/2/10/716
> > > 
> > > Ignoring problems does not make them go away.
> > 
> > I have seen your patches, but I am not fully sure I understand the root
> > cause. is the noise source handling the issue or the random number
> > generation the issue?
> 
> Noise source handling is fine, the problem is the global locking on the
> entropy pools when generating random numbers.
> 
> > If it is the latter, can you explain where the scalability issue comes in?
> 
> A single pool which is locked/written to does not scale. Larger systems
> need multiple pools

That would imply that even when you have a system with 1000 CPUs, you want to 
have a large amount of random numbers. Is this the use case?

Or is simply the presence of 1000 CPUs an issue for "normal" loads on 
/dev/urandom?
> 
> -Andi


Ciao
Stephan
