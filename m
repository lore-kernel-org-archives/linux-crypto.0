From: "Dey, Megha" <megha.dey@intel.com>
Subject: RE: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
 support
Date: Tue, 17 Apr 2018 18:40:17 +0000
Message-ID: <C440BA31B54DCD4AAC682D2365C8FEE738C13267@ORSMSX111.amr.corp.intel.com>
References: <1515542948-24041-1-git-send-email-megha.dey@linux.intel.com>
 <1515542948-24041-2-git-send-email-megha.dey@linux.intel.com>
 <20180118113905.GA19904@gondor.apana.org.au>
 <1516322661.2526.3.camel@megha-Z97X-UD7-TH>
 <20180316145351.GA6231@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180316145351.GA6231@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



>-----Original Message-----
>From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
>Sent: Friday, March 16, 2018 7:54 AM
>To: Dey, Megha <megha.dey@intel.com>
>Cc: linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org;
>davem@davemloft.net
>Subject: Re: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
>support
>
>On Thu, Jan 18, 2018 at 04:44:21PM -0800, Megha Dey wrote:
>>
>> > So the mcryptd template is in fact completely superfluous.  You can
>> > remove it and just have all the main encrypt/decrypt functions
>> > invoke the underlying encrypt/decrypt function directly and achieve
>> > the same result.
>> >
>> > Am I missing something?
>>
>> Hi Herbert,
>>
>> After discussing with Tim, it seems like the mcryptd is responsible
>> for queuing up the encrypt requests and dispatching them to the actual
>> multi-buffer raw algorithm.  It also flushes the queue if we wait too
>> long without new requests coming in to force dispatch of the requests
>> in queue.
>>
>> Its function is analogous to cryptd but it has its own multi-lane
>> twists so we haven't reused the cryptd interface.
>
>I have taken a deeper look and I'm even more convinced now that mcryptd is
>simply not needed in your current model.
>
>The only reason you would need mcryptd is if you need to limit the rate of
>requests going into the underlying mb algorithm.
>
>However, it doesn't do that all.  Even though it seems to have a batch size of
>10, but because it immediately reschedules itself after the batch runs out,
>it's essentially just dumping all requests at the underlying algorithm as fast
>as they're coming in.  The underlying algorithm doesn't have need throttling
>anyway because it'll do the work when the queue is full synchronously.
>
>So why not just get rid of mcryptd completely and expose the underlying
>algorithm as a proper async skcipher/hash?

Hi Herbert,

Most part of the cryptd.c and mcryptd.c are similar, except the logic used to flush out partially completed jobs
in the case of multibuffer algorithms.

I think I will try to merge the cryptd and mcryptd adding necessary quirks for multibuffer where needed.

Also, in cryptd.c, I see shash interface being used for hash digests, update, finup, setkey etc. whereas we have shifted
to ahash interface for mcryptd. Is this correct?

Thanks,
Megha
 
>
>Thanks,
>--
>Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
>http://gondor.apana.org.au/~herbert/
>PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
