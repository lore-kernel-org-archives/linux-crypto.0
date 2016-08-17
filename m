From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Wed, 17 Aug 2016 07:21:19 +0200
Message-ID: <1951611.sxsEZ06mGE@tauon.atsec.com>
References: <4723196.TTQvcXsLCG@positron.chronox.de> <2672856.NsbgmUcCJx@tauon.atsec.com> <2f43d23f-5fbe-9653-fc1c-489db1c7bde4@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, Ted Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>, Joe Perches <joe@perches.com>,
	Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "H. Peter Anvin" <hpa@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36636 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbcHQFVX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2016 01:21:23 -0400
In-Reply-To: <2f43d23f-5fbe-9653-fc1c-489db1c7bde4@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 16. August 2016, 15:28:45 CEST schrieb H. Peter Anvin:

Hi Peter,

> > 
> > There are two motivations for that:
> > 
> > - the current /dev/random is compliant to NTG.1 from AIS 20/31 which
> > requires (in brief words) that entropy comes from auditible noise
> > sources. Currently in my LRNG only RDRAND is a fast noise source which is
> > not auditible (and it is designed to cause a VM exit making it even
> > harder to assess it). To make the LRNG to comply with NTG.1, RDRAND can
> > provide entropy but must not become the sole entropy provider which is
> > the case now with that change.
> > 
> > - the current /dev/random implementation follows the same concept with the
> > exception of 3.15 and 3.16 where RDRAND was not rate-limited. In later
> > versions, this was changed.
> 
> I'm not saying it should be *sole*.  I am questioning the value in
> limiting it, as it seems to me that it could only ever produce a worse
> result.

It is not about the limiting of the data. It is all about the entropy estimate 
for those noise sources and how they affect the entropy estimator behind /dev/
random. If that fast noise source injects large amount of data but does not 
increase the entropy estimator, it is of no concern.

Ciao
Stephan
