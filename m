From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
 support
Date: Thu, 26 Apr 2018 17:44:45 +0800
Message-ID: <20180426094445.4jiwondmtbenepo2@gondor.apana.org.au>
References: <1515542948-24041-1-git-send-email-megha.dey@linux.intel.com>
 <1515542948-24041-2-git-send-email-megha.dey@linux.intel.com>
 <20180118113905.GA19904@gondor.apana.org.au>
 <1516322661.2526.3.camel@megha-Z97X-UD7-TH>
 <20180316145351.GA6231@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C13267@ORSMSX111.amr.corp.intel.com>
 <20180418110115.v2w3o5yfv4u3gc4r@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C13DDE@ORSMSX111.amr.corp.intel.com>
 <20180419032525.6csodbz6lrksyudd@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C270FC@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "Dey, Megha" <megha.dey@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C440BA31B54DCD4AAC682D2365C8FEE738C270FC@ORSMSX111.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 25, 2018 at 01:14:26AM +0000, Dey, Megha wrote:
> 
> Is there any existing implementation of async crypto algorithm that uses the above approach? The ones I could find are either sync, have an outer and inner algorithm or use cryptd.
> 
> I tried removing the mcryptd layer and the outer algorithm and some plumbing to pass the correct structures, but see crashes.(obviously some errors in the plumbing)

OK, you can't just remove it because the inner algorithm requires
kernel_fpu_begin/kernel_fpu_end.  So we do need two layers but I
don't think we need cryptd or mcryptd.

The existing simd wrapper should work just fine on the inner
algorithm, provided that we add hash support to it.

> I am not sure if we remove mcryptd, how would we queue work, flush partially completed jobs or call completions (currently done by mcryptd) if we simply call the inner algorithm.

I don't think mcryptd is providing any real facility to the flushing
apart from a helper.  That same helper can live anywhere.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
