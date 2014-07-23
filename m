From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 01/10] crypto: testmgr - avoid DMA mapping from text,
 rodata, stack
Date: Wed, 23 Jul 2014 11:49:37 +0300
Message-ID: <53CF7721.60608@freescale.com>
References: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
	<1405082095-30146-2-git-send-email-horia.geanta@freescale.com>
 <20140722173710.d9956cf5b8a9757eab955b9e@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:42990
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756986AbaGWIuC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jul 2014 04:50:02 -0400
In-Reply-To: <20140722173710.d9956cf5b8a9757eab955b9e@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/23/2014 1:37 AM, Kim Phillips wrote:
> On Fri, 11 Jul 2014 15:34:46 +0300
> Horia Geanta <horia.geanta@freescale.com> wrote:
> 
>> +++ b/crypto/testmgr.c
>> @@ -198,13 +198,20 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
>>  	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
>>  	unsigned int i, j, k, temp;
>>  	struct scatterlist sg[8];
>> -	char result[64];
>> +	char *result = NULL;
>> +	char *key = NULL;
> 
> these needn't be initialized, here and elsewhere.

I was under the impression that this is needed for kfree on some exit
paths, but indeed it's not the case.

> 
>>  	struct ahash_request *req;
>>  	struct tcrypt_result tresult;
>>  	void *hash_buff;
>>  	char *xbuf[XBUFSIZE];
>>  	int ret = -ENOMEM;
>>  
>> +	result = kmalloc(64, GFP_KERNEL);
> 
> s/64/MAX_DIGEST_SIZE
> 
>> +++ b/crypto/testmgr.h
>> @@ -32,7 +32,7 @@
>>  #define MAX_DIGEST_SIZE		64
>>  #define MAX_TAP			8
>>  
>> -#define MAX_KEYLEN		56
>> +#define MAX_KEYLEN		160
>>  #define MAX_IVLEN		32
> 
> this change could use a blurb in the commit message.

I'll send a v2 only for current patch, if Herbert is ok with this.

> 
> Other than that, this series gets my:
> 
> Acked-by: Kim Phillips <kim.phillips@freescale.com>
> 
> Thanks!

Thanks for reviewing, testing.

Horia
