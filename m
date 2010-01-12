From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: IXP4xx: Fix whitespace problems in ixp4xx_crypto.
Date: Tue, 12 Jan 2010 19:09:19 +0100
Message-ID: <m33a2b19gw.fsf@intrepid.localdomain>
References: <m34omu3rf7.fsf@intrepid.localdomain>
	<m3iqb93lvy.fsf@intrepid.localdomain>
	<20100112171159.GI3056@elara.bln.innominate.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Christian Hohnstaedt <chohnstaedt@innominate.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:54806 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab0ALSJW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2010 13:09:22 -0500
In-Reply-To: <20100112171159.GI3056@elara.bln.innominate.local> (Christian
	Hohnstaedt's message of "Tue, 12 Jan 2010 18:12:00 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christian Hohnstaedt <chohnstaedt@innominate.com> writes:

>>  static struct npe *npe_c;
>> -static struct dma_pool *buffer_pool = NULL;
>> -static struct dma_pool *ctx_pool = NULL;
>> +static struct dma_pool *buffer_pool;
>> +static struct dma_pool *ctx_pool;
>>  
>> -static struct crypt_ctl *crypt_virt = NULL;
>> +static struct crypt_ctl *crypt_virt;
>
> This is not a whitespace-fix.

Right, that's trivial non-whitespace fix :-)

> The error-path in init_ixp_crypto() depends on them being either NULL
> or correctly allocated.
>
> Or is it guaranteed that static variables are always initially zero ?

Yes, the BSS is cleared at boot (modprobe etc). This simply makes the
on-disk image a bit smaller.

>>  static dma_addr_t crypt_phys;
>>  
>>  static int support_aes = 1;
>
> But this initialization is superflous, since it will be initialized
> before use.

I didn't touch it, but will remove the initialization if it's unneeded,
of course.

>> -	static int idx = 0;
>> +	static int idx;
>
> This static index must be initialized with 0.

It is, same as the crypt_virt and co.

>> -static void free_buf_chain(struct device *dev, struct buffer_desc *buf,u32 phys)
>> +static void free_buf_chain(struct device *dev, struct buffer_desc *buf, u32 phys)
>
> Introduces a line-length > 80.

This limit has been lifted recently :-)

>>  	int num = ARRAY_SIZE(ixp4xx_algos);
>> -	int i,err ;
>> +	int i, err ;
>
> Missed one before the ;

Right.


I will fix/change these, not today but soon. Thanks for looking.
-- 
Krzysztof Halasa
