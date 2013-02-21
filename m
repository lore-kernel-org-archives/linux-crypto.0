From: Phil Carmody <pc+lkml@asdf.org>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Date: Thu, 21 Feb 2013 16:07:12 +0200
Message-ID: <20130221140712.GA11550@fatphil.org>
References: <51157686.9000404@chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 87-119-183-129.tll.elisa.ee ([87.119.183.129]:37745 "EHLO
	fatphil.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab3BUOSJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 09:18:09 -0500
Content-Disposition: inline
In-Reply-To: <51157686.9000404@chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Apologies if this is misthreaded, I had to hand-craft the headers.

> The patch offers an entropy generator based on CPU timing jitter. The 
> entropy collector has the following properties:
> 
> * it does not maintain any state and therefore does not need any seed

What is this "pool" if it's not "state"?

> /* Entropy pool of the RNG which is filled upon each request for entropy */
> struct rand_data

And, from looking at jitterentropy_entropy_calc(), it seems to think that
the [source producing the] following sequence of timestamps:

1000, 1010, 1030, 1050, 1060, 1080, 1090, 1110, 1120, ...
i.e. with absolutely metronomic deltas of 10, 20, 10, 20, 10, 20, ...

has 4 bit of entropy per reading. I hope I don't have to explicitly say
that it clearly it has 0 bits of entropy.

Entropy harvesting is quite hard - entropy estimation is unimaginably harder.
Phil
-- 
"In a world of magnets and miracles" 
-- Insane Clown Posse, Miracles, 2009. Much derided.
"Magnets, how do they work"
-- Pink Floyd, High Hopes, 1994. Lauded as lyrical geniuses.
