From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Sun, 19 Jun 2016 16:47:35 -0400
Message-ID: <CACXcFmmu3aHHdwDFE+OEd5Q4ymLhLcm9ERfk1Lq9ijsMp_Czhw@mail.gmail.com>
References: <2754489.L1QYabbYUc@positron.chronox.de> <20160619193614.GA26146@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36362 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbcFSUrh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Jun 2016 16:47:37 -0400
In-Reply-To: <20160619193614.GA26146@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 19, 2016 at 3:36 PM, Pavel Machek <pavel@ucw.cz> wrote:

>> The following patch set provides a different approach to /dev/random ...
>
> Dunno. It is very similar to existing rng, AFAICT.

I do not think so. A lot of the basic principles are the same of course,
but Stephan is suggesting some real changes. On the other hand, I'm
not sure all of them are good ideas & Ted has already incorporated
some into the driver, so it is debatable how much here is really useful.

> And at the very least, constants in existing RNG could be tuned
> to provide "entropy at the boot time".

No, this is a rather hard problem & just tweaking definitely will
not solve it. Ted's patches, Stephan's, mine, the grsecurity
stuff and the kernel hardening project all have things that
might help, but as far as I can see there is no complete
in-kernel solution yet.

Closest thing I have seen to a solution are Denker's suggestions at:
http://www.av8n.com/computer/htm/secure-random.htm#sec-boot-image

Those, though, require changes to build & installation methods
& it might be hard to get distros & device vendors to do it.

> So IMO this should be re-done as tweaks to existing design, not as
> completely new RNG.

I agree, & I think Stephan has already done some of that.
