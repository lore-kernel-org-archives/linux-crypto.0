From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 6/6] crypto: add jitterentropy RNG
Date: Thu, 23 Apr 2015 16:18:31 +0200
Message-ID: <1429798711.2927.8.camel@x220>
References: <5054521.el7mZro33c@myon.chronox.de>
	 <5676005.EdpjbaV0S3@myon.chronox.de> <1429797908.2927.5.camel@x220>
	 <3179693.vMYTrm5f8Q@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au,
	Andreas Steffen <andreas.steffen@strongswan.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Sandy Harris <sandyinchina@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3179693.vMYTrm5f8Q@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2015-04-23 at 16:08 +0200, Stephan Mueller wrote:
> Other patches that are in the kernel that I wrote (e.g. 
> the crypto/drbg.c) have the same license as above, but use 
> MODULE_LICENSE("GPL") -- Thus I would think that leaving it as is should be 
> ok.

Why not submit the trivial patches to make the license comment and the
MODULE_LICENSE() macro match in those files too?

Thanks,


Paul Bolle
