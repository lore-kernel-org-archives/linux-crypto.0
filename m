From: "Dey, Megha" <megha.dey@intel.com>
Subject: RE: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
 support
Date: Wed, 25 Apr 2018 01:14:26 +0000
Message-ID: <C440BA31B54DCD4AAC682D2365C8FEE738C270FC@ORSMSX111.amr.corp.intel.com>
References: <1515542948-24041-1-git-send-email-megha.dey@linux.intel.com>
 <1515542948-24041-2-git-send-email-megha.dey@linux.intel.com>
 <20180118113905.GA19904@gondor.apana.org.au>
 <1516322661.2526.3.camel@megha-Z97X-UD7-TH>
 <20180316145351.GA6231@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C13267@ORSMSX111.amr.corp.intel.com>
 <20180418110115.v2w3o5yfv4u3gc4r@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C13DDE@ORSMSX111.amr.corp.intel.com>
 <20180419032525.6csodbz6lrksyudd@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180419032525.6csodbz6lrksyudd@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



>-----Original Message-----
>From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
>Sent: Wednesday, April 18, 2018 8:25 PM
>To: Dey, Megha <megha.dey@intel.com>
>Cc: linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org;
>davem@davemloft.net
>Subject: Re: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
>support
>
>On Thu, Apr 19, 2018 at 12:54:16AM +0000, Dey, Megha wrote:
>>
>> Yeah I think I misunderstood. I think what you mean is to remove mcryptd.c
>completely and avoid the extra layer of indirection to call the underlying
>algorithm, instead call it directly, correct?
>>
>> So currently we have 3 algorithms registered for every multibuffer algorithm:
>> name         : __sha1-mb
>> driver       : mcryptd(__intel_sha1-mb)
>>
>> name         : sha1
>> driver       : sha1_mb
>>
>> name         : __sha1-mb
>> driver       : __intel_sha1-mb
>>
>> If we remove mcryptd, then we will have just the 2?
>
>It should be down to just one, i.e., the current inner algorithm.
>It's doing all the scheduling work already so I don't really see why it needs the
>wrappers around it.

Hi Herbert,

Is there any existing implementation of async crypto algorithm that uses the above approach? The ones I could find are either sync, have an outer and inner algorithm or use cryptd.

I tried removing the mcryptd layer and the outer algorithm and some plumbing to pass the correct structures, but see crashes.(obviously some errors in the plumbing)

I am not sure if we remove mcryptd, how would we queue work, flush partially completed jobs or call completions (currently done by mcryptd) if we simply call the inner algorithm.

Are you suggesting these are not required at all? I am not sure how to move forward.

>
>Cheers,
>--
>Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
>http://gondor.apana.org.au/~herbert/
>PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
