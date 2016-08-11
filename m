From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Thu, 11 Aug 2016 17:36:32 -0400
Message-ID: <20160811213632.GL10626@thunk.org>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46354 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbcHKVgt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2016 17:36:49 -0400
Content-Disposition: inline
In-Reply-To: <4723196.TTQvcXsLCG@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 11, 2016 at 02:24:21PM +0200, Stephan Mueller wrote:
> 
> The following patch set provides a different approach to /dev/random which
> I call Linux Random Number Generator (LRNG) to collect entropy within the Linux
> kernel. The main improvements compared to the legacy /dev/random is to provide
> sufficient entropy during boot time as well as in virtual environments and when
> using SSDs. A secondary design goal is to limit the impact of the entropy
> collection on massive parallel systems and also allow the use accelerated
> cryptographic primitives. Also, all steps of the entropic data processing are
> testable. Finally massive performance improvements are visible at /dev/urandom
> and get_random_bytes.
> 
> The design and implementation is driven by a set of goals described in [1]
> that the LRNG completely implements. Furthermore, [1] includes a
> comparison with RNG design suggestions such as SP800-90B, SP800-90C, and
> AIS20/31.

Given the changes that have landed in Linus's tree for 4.8, how many
of the design goals for your LRNG are still left not yet achieved?

Reading the paper, you are still claiming huge performance
improvements over getrandomm and /dev/urandom.  With the use of the
ChaCha20 (and given that you added a ChaCha20 DRBG as well), it's not
clear this is still an advantage over what we currently have.

As far as whether or not you can gather enough entropy at boot time,
what we're really talking about how how much entropy we want to assume
can be gathered from interrupt timings, since what you do in your code
is not all that different from what the current random driver is
doing.  So it's pretty easy to turn a knob and say, "hey presto, we
can get all of the entropy we need before userspace starts!"  But
justifying this is much harder, and using statistical tests isn't
really sufficient as far as I'm concerned.

Cheers,

						- Ted
