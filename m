From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Fri, 23 Jan 2015 09:23:03 +1100
Message-ID: <20150122222302.GA10895@gondor.apana.org.au>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de>
 <20150120031704.GB10475@gondor.apana.org.au>
 <40625395.stBBYbAQtz@tachyon.chronox.de>
 <54C1403D.1010608@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54C1403D.1010608@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 22, 2015 at 10:23:57AM -0800, Tadeusz Struk wrote:
>
> No, I thought that the agreement was that we don't want to allow user
> space to use these helpers directly, right? Am I missing something?

Yes but we should also fix this so that it's a proper aead
algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
