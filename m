From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Fri, 22 Apr 2016 06:59:32 +0200
Message-ID: <6974210.pKFp51TpM6@tauon.atsec.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de> <20160422025155.GA6690@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53018 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbcDVE7l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Apr 2016 00:59:41 -0400
In-Reply-To: <20160422025155.GA6690@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 21. April 2016, 22:51:55 schrieb Theodore Ts'o:

Hi Theodore,

> I still have a massive problem with the claims that the "Jitter" RNG
> provides any amount of entropy.  Just because you and I might not be
> able to analyze it doesn't mean that somebody else couldn't.  After
> all, DUAL-EC DRNG was very complicated and hard to analyze.  So would
> be something like
> 
>    AES(NSA_KEY, COUNTER++)
> 
> Very hard to analyze indeed.  Shall we run statistical tests?  They'll
> pass with flying colors.
> 
> Secure?  Not so much.

If you are concerned with that RNG, we can easily drop it from the LRNG. The 
testing documented in the writeup disable the Jitter RNG to ensure that only 
the LRNG IRQ collection is tested.

The conclusions regarding timeliness of the seeding, the prevention of 
draining the entropy pool are performed without the Jitter RNG which implies 
that the Jitter RNG can be dropped without harm.

Ciao
Stephan
