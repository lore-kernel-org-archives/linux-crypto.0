From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: random(4) changes
Date: Mon, 25 Apr 2016 21:00:58 -0400
Message-ID: <20160426010058.GB28496@thunk.org>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
 <87twipn05w.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Stephan Mueller <smueller@chronox.de>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39324 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbcDZBBL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 21:01:11 -0400
Content-Disposition: inline
In-Reply-To: <87twipn05w.fsf@tassilo.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 25, 2016 at 09:06:03AM -0700, Andi Kleen wrote:
> Sandy Harris <sandyinchina@gmail.com> writes:
> 
> There is also the third problem of horrible scalability of /dev/random
> output on larger systems, for which patches are getting ignored.
> 
> https://lkml.org/lkml/2016/2/10/716
> 
> Ignoring problems does not make them go away.

Sorry, too much travel, deadlines and conference this spring.  I
haven't forgot them.

						- Ted
