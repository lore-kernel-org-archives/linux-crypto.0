From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Mon, 25 Apr 2016 19:25:55 +0200
Message-ID: <31776489.IE3eGLxohC@positron.chronox.de>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com> <87twipn05w.fsf@tassilo.jf.intel.com>
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
Received: from mail.eperm.de ([89.247.134.16]:53582 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbcDYRZ7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 13:25:59 -0400
In-Reply-To: <87twipn05w.fsf@tassilo.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 25. April 2016, 09:06:03 schrieb Andi Kleen:

Hi Andi,

> Sandy Harris <sandyinchina@gmail.com> writes:
> 
> There is also the third problem of horrible scalability of /dev/random
> output on larger systems, for which patches are getting ignored.
> 
> https://lkml.org/lkml/2016/2/10/716
> 
> Ignoring problems does not make them go away.

I have seen your patches, but I am not fully sure I understand the root cause. 
is the noise source handling the issue or the random number generation the 
issue?

If it is the latter, can you explain where the scalability issue comes in?
> 
> -Andi


Ciao
Stephan
