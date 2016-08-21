From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Sun, 21 Aug 2016 11:14:39 +0800
Message-ID: <20160821031439.GA392@gondor.apana.org.au>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
 <20160811213632.GL10626@thunk.org>
 <20160817214254.GA22438@amd>
 <20160818172712.GA22054@thunk.org>
 <20160818183923.GA24817@amd>
 <20160819024947.GA10888@thunk.org>
 <20160819055612.GA20427@gondor.apana.org.au>
 <605855f7-2990-f118-c07c-ef20cfcc43fb@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        Stephan Mueller <smueller@chronox.de>, sandyinchina@gmail.com,
        Jason Cooper <cryptography@lakedaemon.net>,
        John Denker <jsd@av8n.com>, Joe Perches <joe@perches.com>,
        George Spelvin <linux@horizon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "H. Peter Anvin" <hpa@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41349 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbcHUDPZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Aug 2016 23:15:25 -0400
Content-Disposition: inline
In-Reply-To: <605855f7-2990-f118-c07c-ef20cfcc43fb@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 19, 2016 at 10:20:18AM -0700, H. Peter Anvin wrote:
> On 08/18/16 22:56, Herbert Xu wrote:
> > On Thu, Aug 18, 2016 at 10:49:47PM -0400, Theodore Ts'o wrote:
> >>
> >> That really depends on the system.  We can't assume that people are
> >> using systems with a 100Hz clock interrupt.  More often than not
> >> people are using tickless kernels these days.  That's actually the
> >> problem with changing /dev/urandom to block until things are
> >> initialized.
> > 
> > Couldn't we disable tickless until urandom has been seeded? In fact
> > perhaps we should accelerate the timer interrupt rate until it has
> > been seeded?
> > 
> 
> The biggest problem there is that the timer interrupt adds *no* entropy
> unless there is a source of asynchronicity in the system.  On PCs,
> traditionally the timer has been run from a completely different crystal
> (14.31818 MHz) than the CPU, which is the ideal situation, but if they
> are run off the same crystal and run in lockstep, there is very little
> if anything there.  On some systems, the timer may even *be* the only
> source of time, and the entropy truly is zero.

Sure, but that's orthorgonal to what Ted was talking about above.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
