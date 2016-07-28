From: Nicolai Stange <nicstange@gmail.com>
Subject: Re: lib/mpi: BUG: sleeping function called from invalid context on next-20160726
Date: Thu, 28 Jul 2016 09:40:17 +0200
Message-ID: <87invqp5we.fsf@gmail.com>
References: <87d1lyiygu.fsf@gmail.com>
	<20160728052917.GA811@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Nicolai Stange <nicstange@gmail.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160728052917.GA811@gondor.apana.org.au> (Herbert Xu's message
	of "Thu, 28 Jul 2016 13:29:17 +0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Wed, Jul 27, 2016 at 11:05:05PM +0200, Nicolai Stange wrote:
>> 
>> with linux-next-20160726, I get this:
>> 
>>  BUG: sleeping function called from invalid context at /mnt/scratch/nic/linux-next/mm/slab.h:388
>
> Does this patch help?

Yes, works like a charm now!


>> I would have sent a patch, but there is another point which puzzles me
>> in mpi_read_raw_from_sgl():
>> 
>>   [...]
>>   const u8 *buff;
>>   [...]
>>   sg_miter_start(&miter, sgl, ents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
>> 
>>   lzeros = 0;
>>   len = 0;
>>   while (nbytes > 0) {
>>   	while (len && !*buff) {
>>   		lzeros++;
>>   		len--;
>>   		buff++;
>>   	}
>> 
>> 
>> Thus, buff isn't initialized before its first use? Or am I misreading
>> something here?
>
> On the first entry len is zero therefore we will go to the end of the
> loop and initialise buff.

Hah! Thanks, although being obvious, I didn't see this...


Thanks,

Nicolai
