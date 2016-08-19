From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Fri, 19 Aug 2016 13:56:12 +0800
Message-ID: <20160819055612.GA20427@gondor.apana.org.au>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
 <20160811213632.GL10626@thunk.org>
 <20160817214254.GA22438@amd>
 <20160818172712.GA22054@thunk.org>
 <20160818183923.GA24817@amd>
 <20160819024947.GA10888@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        Stephan Mueller <smueller@chronox.de>, sandyinchina@gmail.com,
        Jason Cooper <cryptography@lakedaemon.net>,
        John Denker <jsd@av8n.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Joe Perches <joe@perches.com>,
        George Spelvin <linux@horizon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56603 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbcHSF5Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2016 01:57:16 -0400
Content-Disposition: inline
In-Reply-To: <20160819024947.GA10888@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 18, 2016 at 10:49:47PM -0400, Theodore Ts'o wrote:
>
> That really depends on the system.  We can't assume that people are
> using systems with a 100Hz clock interrupt.  More often than not
> people are using tickless kernels these days.  That's actually the
> problem with changing /dev/urandom to block until things are
> initialized.

Couldn't we disable tickless until urandom has been seeded? In fact
perhaps we should accelerate the timer interrupt rate until it has
been seeded?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
