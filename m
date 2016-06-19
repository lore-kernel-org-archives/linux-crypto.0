From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Sun, 19 Jun 2016 21:36:14 +0200
Message-ID: <20160619193614.GA26146@amd>
References: <2754489.L1QYabbYUc@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33906 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcFSTgS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Jun 2016 15:36:18 -0400
Content-Disposition: inline
In-Reply-To: <2754489.L1QYabbYUc@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun 2016-06-19 17:58:41, Stephan Mueller wrote:
> Hi Herbert, Ted,
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

Dunno. It is very similar to existing rng, AFAICT. And at the very
least, constants in existing RNG could be tuned to provide "entropy at
the boot time".

So IMO this should be re-done as tweaks to existing design, not as
completely new RNG.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
