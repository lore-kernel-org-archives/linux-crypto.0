From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Patch V5 1/7] crypto: Multi-buffer encryption infrastructure
 support
Date: Fri, 23 Jun 2017 16:32:00 +0800
Message-ID: <20170623083200.GA29882@gondor.apana.org.au>
References: <1492721440-3698-1-git-send-email-megha.dey@linux.intel.com>
 <1492721440-3698-2-git-send-email-megha.dey@linux.intel.com>
 <20170424090024.GA20535@gondor.apana.org.au>
 <1496951574.8042.15.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496951574.8042.15.camel@megha-Z97X-UD7-TH>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 08, 2017 at 12:52:54PM -0700, Megha Dey wrote:
>
> I will move this code to the mcryptd.c.
> 
> About the naming scheme, could you give me an example where the internal
> and external algorithm have the same name? I tried searching but did not
> find any.
> 
> When the outer and inner algorithm have the same name, I see a crash
> when testing using tcrypt. This is because the wrong algortihm (with a
> higher priority) is being picked up in __crypto_alg_lookup.  
> 
> Inner alg:
> Currently:
> alg name:__cbc(aes), driver name:__cbc-aes-aesni-mb
> 
> expected:
> alg name:cbc(aes), driver name: cbc-aes-aesni-mb
> 
> Outer alg:
> Currently:
> alg name:cbc(aes), driver name:cbc-aes-aesni-mb
> 
> expected:
> alg name:cbc(aes), driver name:mcryptd-cbc-aes-aesni-mb

This all looks right.  So I'm not sure why you're getting the crash.
We're relying on the INTERNAL flag to ensure the internal algorithm
is not picked up except when we strictly ask for it.

In fact I see something fishy in your testmgr code (the last patch
in the series I think).  It's setting the INTERNAL bit when
allocating tfms, that does not look right.

The only one that should be setting this is mcryptd.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
