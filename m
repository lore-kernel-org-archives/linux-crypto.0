From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
 support
Date: Fri, 11 May 2018 12:45:30 +0800
Message-ID: <20180511044530.n6ht3mpvg22hqny5@gondor.apana.org.au>
References: <20180316145351.GA6231@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C13267@ORSMSX111.amr.corp.intel.com>
 <20180418110115.v2w3o5yfv4u3gc4r@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C13DDE@ORSMSX111.amr.corp.intel.com>
 <20180419032525.6csodbz6lrksyudd@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C270FC@ORSMSX111.amr.corp.intel.com>
 <20180426094445.4jiwondmtbenepo2@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C4291E@ORSMSX111.amr.corp.intel.com>
 <20180507093511.jscgnk436e3ba4un@gondor.apana.org.au>
 <C440BA31B54DCD4AAC682D2365C8FEE738C60300@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "Dey, Megha" <megha.dey@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C440BA31B54DCD4AAC682D2365C8FEE738C60300@ORSMSX111.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 11, 2018 at 01:24:42AM +0000, Dey, Megha wrote:
> 
> Are you suggesting that the SIMD wrapper, will do what is currently being done by the ' mcryptd_queue_worker ' function (assuming FPU is not disabled) i.e dispatching the job to the inner algorithm?
> 
> I have got rid of the mcryptd layer( have an inner layer, outer SIMD layer, handled the pointers and completions accordingly), but still facing some issues after removing the per cpu mcryptd_cpu_queue.

Why don't you post what you've got and we can work it out together?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
