From: "Dey, Megha" <megha.dey@intel.com>
Subject: RE: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
 support
Date: Tue, 1 May 2018 22:39:15 +0000
Message-ID: <C440BA31B54DCD4AAC682D2365C8FEE738C4291E@ORSMSX111.amr.corp.intel.com>
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
 <20180426094445.4jiwondmtbenepo2@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426094445.4jiwondmtbenepo2@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



>-----Original Message-----
>From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
>Sent: Thursday, April 26, 2018 2:45 AM
>To: Dey, Megha <megha.dey@intel.com>
>Cc: linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org;
>davem@davemloft.net
>Subject: Re: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
>support
>
>On Wed, Apr 25, 2018 at 01:14:26AM +0000, Dey, Megha wrote:
>>
>> Is there any existing implementation of async crypto algorithm that uses the
>above approach? The ones I could find are either sync, have an outer and
>inner algorithm or use cryptd.
>>
>> I tried removing the mcryptd layer and the outer algorithm and some
>> plumbing to pass the correct structures, but see crashes.(obviously
>> some errors in the plumbing)
>
>OK, you can't just remove it because the inner algorithm requires
>kernel_fpu_begin/kernel_fpu_end.  So we do need two layers but I don't think
>we need cryptd or mcryptd.
>
>The existing simd wrapper should work just fine on the inner algorithm,
>provided that we add hash support to it.

Hi Herbert,

crypto/simd.c provides a simd_skcipher_create_compat. I have used the same template to introduce simd_ahash_create_compat
which would wrap around the inner hash algorithm.

Hence we would still register 2 algs, outer and inner.
>
>> I am not sure if we remove mcryptd, how would we queue work, flush
>partially completed jobs or call completions (currently done by mcryptd) if we
>simply call the inner algorithm.
>
>I don't think mcryptd is providing any real facility to the flushing apart from a
>helper.  That same helper can live anywhere.

Currently we have outer_alg -> mcryptd alg -> inner_alg

Mcryptd is mainly providing the following:
1. Ensuring the lanes(8 in case of AVX2) are full before dispatching to the lower inner algorithm. This is obviously why we would expect better performance for multi-buffer as opposed to the present single-buffer algorithms.
2. If there no new incoming jobs, issue a flush.
3. A glue layer which sends the correct pointers and completions.

If we get rid of mcryptd, these functions needs to be done by someone. Since all multi-buffer algorithms would require this tasks, where do you suggest these helpers live, if not the current mcryptd.c?

I am not sure if you are suggesting that we need to get rid of the mcryptd work queue itself. In that case, we would need to execute in the context of the job requesting the crypto transformation.
>
>Cheers,
>--
>Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
>http://gondor.apana.org.au/~herbert/
>PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
