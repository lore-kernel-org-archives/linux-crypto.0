From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Date: Fri, 11 Oct 2013 23:28:35 -0400
Message-ID: <20131012032835.GC30680@thunk.org>
References: <2579337.FPgJGgHYdz@tauon>
 <CACXcFm=qdv9ktjYDGo+L=ssh+tCs7vVniznNpXyWVTBSB1CMRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45092 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab3JLD2m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Oct 2013 23:28:42 -0400
Content-Disposition: inline
In-Reply-To: <CACXcFm=qdv9ktjYDGo+L=ssh+tCs7vVniznNpXyWVTBSB1CMRg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

I haven't had a chance to look at your paper in detail, yet, but a
quick scan has found a huge red flag for me that puts the rest of your
analysis in severe doubt for me.

You say that you got really good results and perfect statistical
entropy on a number of platforms, including on an MIPS embedded
system.  You also say that you are harvesting jitter by using
get_cycles() yes?

Well, on the MIPS platform, here is the definition of get_cycles:

static inline cycles_t get_cycles(void)
{
	return 0;
}

So if you are getting great entropy results when in effect you
couldn't possibly be harvesting any jitter at all, then something is
really, Really, REALLY wrong with your tests.

One might be that you are just getting great statistical results
because of the whitening step.  This is why I have very little faith
in statistical tests of randomness, given that they will return
perfect results for the following "random number generator"

	AES_ENCRYPT(i++, NSA_KEY)

Regards,

					- Ted
