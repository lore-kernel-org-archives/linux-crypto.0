From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 6/6] crypto: add jitterentropy RNG
Date: Thu, 23 Apr 2015 16:26:23 +0200
Message-ID: <4170874.MzN8F3hvVD@myon.chronox.de>
References: <5054521.el7mZro33c@myon.chronox.de> <3179693.vMYTrm5f8Q@myon.chronox.de> <1429798711.2927.8.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au,
	Andreas Steffen <andreas.steffen@strongswan.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Sandy Harris <sandyinchina@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429798711.2927.8.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 23. April 2015, 16:18:31 schrieb Paul Bolle:

Hi Paul,

> On Thu, 2015-04-23 at 16:08 +0200, Stephan Mueller wrote:
> > Other patches that are in the kernel that I wrote (e.g.
> > the crypto/drbg.c) have the same license as above, but use
> > MODULE_LICENSE("GPL") -- Thus I would think that leaving it as is should
> > be
> > ok.
> 
> Why not submit the trivial patches to make the license comment and the
> MODULE_LICENSE() macro match in those files too?

Well, ok, I can do that.

I will wait for further comments on the patch set before I resubmit the patch 
set with the license change as suggested.
> 
> Thanks,
> 
> 
> Paul Bolle


-- 
Ciao
Stephan
