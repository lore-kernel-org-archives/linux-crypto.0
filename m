From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Tue, 16 Aug 2016 07:45:13 +0200
Message-ID: <2672856.NsbgmUcCJx@tauon.atsec.com>
References: <4723196.TTQvcXsLCG@positron.chronox.de> <2c3286c8-7150-12db-937d-b6407d50d748@linux.intel.com>
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
Received: from mail.eperm.de ([89.247.134.16]:36364 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbcHPFpR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 01:45:17 -0400
In-Reply-To: <2c3286c8-7150-12db-937d-b6407d50d748@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. August 2016, 13:42:54 CEST schrieb H. Peter Anvin:

Hi H,

> On 08/11/16 05:24, Stephan Mueller wrote:
> > * prevent fast noise sources from dominating slow noise sources
> > 
> >   in case of /dev/random
> 
> Can someone please explain if and why this is actually desirable, and if
> this assessment has been passed to someone who has actual experience
> with cryptography at the professional level?

There are two motivations for that:

- the current /dev/random is compliant to NTG.1 from AIS 20/31 which requires 
(in brief words) that entropy comes from auditible noise sources. Currently in 
my LRNG only RDRAND is a fast noise source which is not auditible (and it is 
designed to cause a VM exit making it even harder to assess it). To make the 
LRNG to comply with NTG.1, RDRAND can provide entropy but must not become the 
sole entropy provider which is the case now with that change.

- the current /dev/random implementation follows the same concept with the 
exception of 3.15 and 3.16 where RDRAND was not rate-limited. In later 
versions, this was changed.

Ciao
Stephan
