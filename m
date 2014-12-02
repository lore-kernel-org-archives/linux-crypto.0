From: "George Spelvin" <linux@horizon.com>
Subject: Re: Is ansi_cprng.c supposed to be an implmentation of X9.31?
Date: 1 Dec 2014 23:55:18 -0500
Message-ID: <20141202045518.27813.qmail@ns.horizon.com>
References: <2067542.hCsFeEhKF1@tauon>
Cc: herbert@gondor.apana.org.au, jarod@redhat.com,
	linux-crypto@vger.kernel.org, nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:46606 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752717AbaLBEzU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2014 23:55:20 -0500
In-Reply-To: <2067542.hCsFeEhKF1@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>> The other one, which I have to think *very* hard about, is whether
>> using the same seed material as /dev/random in this much weaker
>> cryptographic construction will introduce a flaw in *it*.

> I have no idea what you are referring to here. The caller is requred to 
> seed the DRNG. Typically that is done with a call to get_random_bytes. 
> As Neil mentioned, the X9.31 DRNG implementation does not seed itself.

Er, yes it does.  Not the key, but the IV vector V[].

Here's the closest thing I can find on-line to a direct quote
from the ANSI Spec:

http://www.untruth.org/~josh/security/ansi931rng.PDF

"Let DT be a date/time vector which is updated on each iteration."

This timestamp is a source of continuous reseed material.  The spec
doesn't impose specific resolution requirements, but it's hopefully
obvious that the finer, the better.  The goal is a vector which changes
per iteration.

There are limitations due to its finite entropy and lack of catastrophic
reseeding, as Kelsey & Schneier pointed out:

https://www.schneier.com/paper-prngs.html

but it is intended as an entropy source.

Hopefully very soon I'll have a patch series to post.  (Unfortunately,
I just managed to oops my kernel and need to reboot to continue testing.)

If I don't do much more, it'll be patch 13/17 in the series.  I think
the use of get_random_int() is a good compromise between the raw
random_get_entropy() timestamp and the (too heavy) get_random_bytes().
