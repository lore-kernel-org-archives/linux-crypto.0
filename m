From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [v2 PATCH 6/8] crypto: caam - Convert GCM to new AEAD interface
Date: Thu, 18 Jun 2015 14:18:21 +0300
Message-ID: <5582A8FD.30705@freescale.com>
References: <20150616054551.GA21524@gondor.apana.org.au>
 <E1Z4jpH-0005dy-Et@gondolin.me.apana.org.au> <5581A826.7060907@freescale.com>
 <20150618061734.GA28418@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <ruchika.gupta@freescale.com>, <cristian.stoica@freescale.com>,
	<NiteshNarayanLal@freescale.com>, <jinyanjiang@gmail.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:51712
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754870AbbFRNwN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 09:52:13 -0400
In-Reply-To: <20150618061734.GA28418@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/18/2015 9:17 AM, Herbert Xu wrote:
>>> +static void init_gcm_job(struct aead_request *req,
>>> +			 struct aead_edesc *edesc,
>>> +			 bool all_contig, bool encrypt)
>>> +{
>>> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
>>> +	struct caam_ctx *ctx = crypto_aead_ctx(aead);
>>> +	unsigned int ivsize = crypto_aead_ivsize(aead);
>>> +	u32 *desc = edesc->hw_desc;
>>> +	bool generic_gcm = (ivsize == 12);
>>> +	unsigned int last;
>>> +
>>> +	init_aead_job(req, edesc, all_contig, encrypt);
>>> +
>>> +	/* BUG This should not be specific to generic GCM. */
>>
>> AFAICT, for non-generic GCM uses (RFC4106, RFC4543), cryptlen and/or
>> assoclen are always > 0. That's why the descriptors do not address these
>> cases.
> 
> Of course.  But with the algif_aead interface you need to at least
> ensure that you don't crash or do something silly should the user
> give you such an input.  So my question is what happens when it is
> zero? Does the hardware simply emit an error and recover, or does it
> hang/lock up/do something worse?

To make sure, I've tried this case on HW (with modified tcrypt tests):

caam_jr ffe301000.jr: 4000101c: DECO: desc idx 16: DECO Watchdog timer
timeout error
alg: aead: encryption failed on test 1 for rfc4106-gcm-aes-caam:
ret=-1073745948

caam_jr ffe301000.jr: 4000111c: DECO: desc idx 17: DECO Watchdog timer
timeout error
alg: aead: encryption failed on test 1 for rfc4543-gcm-aes-caam:
ret=-1073746204

The errors are reported by HW and handled by the driver.

> BTW does this actually work on your hardware now?

tcrypt tests pass.
I'll run more tests (IPsec) on my side and report back if I encounter
any issue.

Thanks,
Horia
