From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: aesni - fix failing setkey for rfc4106-gcm-aesni
Date: Thu, 25 Jun 2015 11:59:04 -0700
Message-ID: <558C4F78.8020806@intel.com>
References: <20150624141421.30466.28034.stgit@tstruk-mobl1> <20150625142525.GA10550@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24485 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbbFYS7R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 14:59:17 -0400
In-Reply-To: <20150625142525.GA10550@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/25/2015 07:25 AM, Herbert Xu wrote:
> On Wed, Jun 24, 2015 at 07:14:21AM -0700, Tadeusz Struk wrote:
>> rfc4106(gcm(aes)) uses cbc(aes) to generate hash key. cbc(aes) needs
>> chainiv, but the chainiv gets initialized after aesni_intel when both
>> are statically linked so the setkey fails.
>> This patch forces aesni_intel to be initialized after chainiv.
>>
>> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> 
> Aha, this could indeed the explain the setkey error that Linus
> saw.  Once the AEAD conversion is complete this would actually
> become unnecessary because seqiv for blkcipher would disappear.

Yes, after the conversion is finished we can revert this patch.

> 
> Linus, could you confirm that you have AESNI built into the kernel
> and not as a module?
> 
> However, this is still brittle because you have the same ordering
> issue with ctr.  IOW aesni may be registered before ctr.  In fact
> you don't actually need ctr here.  You could just replace it with
> plain aes plus a xor.

So this will fix it for ctr too.

> 
> That should be more robust as you can then just use aesni for the
> aes and you wouldn't depend on anything external to aesni.
> 
> Could you make a patch for that Tadeusz?

I can start working on this after my vacation
