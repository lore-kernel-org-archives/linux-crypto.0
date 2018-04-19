From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
 support
Date: Thu, 19 Apr 2018 11:25:25 +0800
Message-ID: <20180419032525.6csodbz6lrksyudd@gondor.apana.org.au>
References: <1515542948-24041-1-git-send-email-megha.dey@linux.intel.com>
 <1515542948-24041-2-git-send-email-megha.dey@linux.intel.com>
 <20180118113905.GA19904@gondor.apana.org.au>
 <1516322661.2526.3.camel@megha-Z97X-UD7-TH>
 <20180316145351.GA6231@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C13267@ORSMSX111.amr.corp.intel.com>
 <20180418110115.v2w3o5yfv4u3gc4r@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C13DDE@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "Dey, Megha" <megha.dey@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C440BA31B54DCD4AAC682D2365C8FEE738C13DDE@ORSMSX111.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 19, 2018 at 12:54:16AM +0000, Dey, Megha wrote:
>
> Yeah I think I misunderstood. I think what you mean is to remove mcryptd.c completely and avoid the extra layer of indirection to call the underlying algorithm, instead call it directly, correct?
> 
> So currently we have 3 algorithms registered for every multibuffer algorithm:
> name         : __sha1-mb
> driver       : mcryptd(__intel_sha1-mb)
> 
> name         : sha1
> driver       : sha1_mb
> 
> name         : __sha1-mb
> driver       : __intel_sha1-mb
> 
> If we remove mcryptd, then we will have just the 2?

It should be down to just one, i.e., the current inner algorithm.
It's doing all the scheduling work already so I don't really see
why it needs the wrappers around it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
