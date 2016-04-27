From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 27 Apr 2016 14:03:14 -0400
Message-ID: <20160427180314.24643.qmail@ns.horizon.com>
References: <20160427002346.12354.qmail@ns.horizon.com>
Cc: herbert@gondor.apana.org.au, linux@horizon.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sandyinchina@gmail.com, smueller@chronox.de, tytso@mit.edu
To: andi@firstfloor.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:46512 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752916AbcD0SDQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Apr 2016 14:03:16 -0400
In-Reply-To: <20160427002346.12354.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andi Kleen wrote:
> There is also the third problem of horrible scalability of /dev/random
> output on larger systems, for which patches are getting ignored.

I came up with some very pretty code to fix this, which
tried to copy_to_user with a lock held.

After all my attempts to fix that fatal flaw resulted in much uglier
code I set it aside for a while in the hopes that inspiration would
strike.

and it's still sitting unfinished.  :-(

But I want to finish it, honest!  This latest discussion has
made me acutely conscious of it.

The fact that the scope of changes just got bigger doesn't help of
course, but I *have* picked it up again.
