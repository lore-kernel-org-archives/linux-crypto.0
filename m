From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
 support
Date: Mon, 7 May 2018 17:35:11 +0800
Message-ID: <20180507093511.jscgnk436e3ba4un@gondor.apana.org.au>
References: <20180118113905.GA19904@gondor.apana.org.au>
 <1516322661.2526.3.camel@megha-Z97X-UD7-TH>
 <20180316145351.GA6231@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C13267@ORSMSX111.amr.corp.intel.com>
 <20180418110115.v2w3o5yfv4u3gc4r@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C13DDE@ORSMSX111.amr.corp.intel.com>
 <20180419032525.6csodbz6lrksyudd@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C270FC@ORSMSX111.amr.corp.intel.com>
 <20180426094445.4jiwondmtbenepo2@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C4291E@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "Dey, Megha" <megha.dey@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C440BA31B54DCD4AAC682D2365C8FEE738C4291E@ORSMSX111.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 01, 2018 at 10:39:15PM +0000, Dey, Megha wrote:
>
> crypto/simd.c provides a simd_skcipher_create_compat. I have used the same template to introduce simd_ahash_create_compat
> which would wrap around the inner hash algorithm.
> 
> Hence we would still register 2 algs, outer and inner.

Right.

> Currently we have outer_alg -> mcryptd alg -> inner_alg
> 
> Mcryptd is mainly providing the following:
> 1. Ensuring the lanes(8 in case of AVX2) are full before dispatching to the lower inner algorithm. This is obviously why we would expect better performance for multi-buffer as opposed to the present single-buffer algorithms.
> 2. If there no new incoming jobs, issue a flush.
> 3. A glue layer which sends the correct pointers and completions.
> 
> If we get rid of mcryptd, these functions needs to be done by someone. Since all multi-buffer algorithms would require this tasks, where do you suggest these helpers live, if not the current mcryptd.c?

That's the issue.  I don't think mcryptd is doing any of these
claimed functions except for hosting the flush helper which could
really live anywhere.

All these functions are actually being carried out in the inner
algorithm already.

> I am not sure if you are suggesting that we need to get rid of the mcryptd work queue itself. In that case, we would need to execute in the context of the job requesting the crypto transformation.

Which is fine as long as you can disable the FPU.  If not the simd
wrapper will defer the job to kthread context as required.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
