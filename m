From: "George Spelvin" <linux@sciencehorizons.net>
Subject: Re: [PATCH v5 1/4] siphash: add cryptographically secure PRF
Date: 16 Dec 2016 17:13:52 -0500
Message-ID: <20161216221352.26899.qmail@ns.sciencehorizons.net>
References: <20161216204358.nlwifgcqnu6pitxs@thunk.org>
Cc: ak@linux.intel.com, davem@davemloft.net, David.Laight@aculab.com,
        djb@cr.yp.to, ebiggers3@gmail.com, hannes@stressinduktion.org,
        Jason@zx2c4.com, jeanphilippe.aumasson@gmail.com,
        kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, luto@amacapital.net,
        netdev@vger.kernel.org, tom@herbertland.com,
        torvalds@linux-foundation.org, vegard.nossum@gmail.com
To: linux@sciencehorizons.net, tytso@mit.edu
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:13679 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1758588AbcLPWNy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Dec 2016 17:13:54 -0500
In-Reply-To: <20161216204358.nlwifgcqnu6pitxs@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> What should we do with get_random_int() and get_random_long()?  In
> some cases it's being used in performance sensitive areas, and where
> anti-DoS protection might be enough.  In others, maybe not so much.

This is tricky.  The entire get_random_int() structure is an abuse of
the hash function and will need to be thoroughly rethought to convert
it to SipHash.  Remember, SipHash's security goals are very different
from MD5, so there's no obvious way to do the conversion.

(It's *documented* as "not cryptographically secure", but we know
where that goes.)

> If we rekeyed the secret used by get_random_int() and
> get_random_long() frequently (say, every minute or every 5 minutes),
> would that be sufficient for current and future users of these
> interfaces?

Remembering that on "real" machines it's full SipHash, then I'd say that
64-bit security + rekeying seems reasonable.

The question is, the idea has recently been floated to make hsiphash =
SipHash-1-3 on 64-bit machines.  Is *that* okay?


The annoying thing about the currently proposed patch is that the *only*
chaining is the returned value.  What I'd *like* to do is the same
pattern as we do with md5, and remember v[0..3] between invocations.
But there's no partial SipHash primitive; we only get one word back.

Even
	*chaining += ret = siphash_3u64(...)

would be an improvement.

Although we could do something like

	c0 = chaining[0];
	chaining[0] = c1 = chaining[1];

	ret = hsiphash(c0, c1, ...)

	chaining[1] = c0 + ret;
