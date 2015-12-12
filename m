From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: crypto/nx842: Ignore queue overflow informative error
Date: Fri, 11 Dec 2015 18:02:35 -0800
Message-ID: <566B803B.5050608@linux.vnet.ibm.com>
References: <1449388004.2096.12.camel@hbabu-laptop> <CALZtONCw9+wvSQ+vwsvSWa_itR-G9ZBkuXftzNHV9oTd8YZFaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: pair@us.ibm.com, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"David S. Miller" <davem@davemloft.net>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:39994 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbbLLCCq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Dec 2015 21:02:46 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
	Fri, 11 Dec 2015 21:02:45 -0500
In-Reply-To: <CALZtONCw9+wvSQ+vwsvSWa_itR-G9ZBkuXftzNHV9oTd8YZFaw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/07/2015 11:34 AM, Dan Streetman wrote:
> On Sun, Dec 6, 2015 at 2:46 AM, Haren Myneni <haren@linux.vnet.ibm.com> wrote:
>>
>> NX842 coprocessor sets bit 3 if queue is overflow. It is just for
>> information to the user. So the driver prints this informative message
>> and ignores it.
>>
>> Signed-off-by: Haren Myneni <haren@us.ibm.com>
>>
>> diff --git a/arch/powerpc/include/asm/icswx.h b/arch/powerpc/include/asm/icswx.h
>> index 9f8402b..d1a2a2d 100644
>> --- a/arch/powerpc/include/asm/icswx.h
>> +++ b/arch/powerpc/include/asm/icswx.h
>> @@ -164,6 +164,7 @@ struct coprocessor_request_block {
>>  #define ICSWX_INITIATED                (0x8)
>>  #define ICSWX_BUSY             (0x4)
>>  #define ICSWX_REJECTED         (0x2)
>> +#define ICSWX_BIT3             (0x1)   /* undefined or set from XERSO. */
> 
> Since this isn't defined by the icswx rfc workbook, it probably
> shouldn't go here, it would make more sense to put it into nx-842.h
> and call it something like "ICSWX_NX_QUEUE_OVERFLOW" or similar
> NX-specific meaningful name.

This bit is defined in icswx RFC. Hence I think we should define this in icswx.h.

"Bit 3 of CR0 is undefined or set from XERSO."

Please ignore this patch. Talking to HW team, whenever gets floating point overflow from FPU, XER[S0] will be set and it stays until other FPU operation is executed. It is typical behaviour on powerpc. ixswx RFC says coprocessor can set this XER[S0] to bit 3 and NX is doing this. I think it should have ignored this bit.
 
"An implementation is permitted to set bit 3 of CR0 from XERSO."

So,the issue is not queue overflow problem, but NX is copying XER[S0] which is no use and nothing to do with compression. We need to ignore this bit since it can be set with other valuable return status. I will repost new patch with the proper description. 

Thanks
Haren 
 

> 
>>
>>  static inline int icswx(__be32 ccw, struct coprocessor_request_block *crb)
>>  {
>> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
>> index 9ef51fa..321b8e8 100644
>> --- a/drivers/crypto/nx/nx-842-powernv.c
>> +++ b/drivers/crypto/nx/nx-842-powernv.c
>> @@ -442,6 +442,15 @@ static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
>>                              (unsigned int)ccw,
>>                              (unsigned int)be32_to_cpu(crb->ccw));
>>
>> +       /*
>> +        * NX842 coprocessor uses 3rd bit to report queue overflow which is
>> +        * not an error, just for information to user. So, ignore this bit.
>> +        */
> 
> a meaningfully named bit define means you don't need to explain it
> with a comment :-)
> 
> However, I suggest that you do explain *why* a queue overflow isn't an
> error - either here or (probably better) at the #define of the bit -
> because that isn't obvious.
> 
>> +       if (ret & ICSWX_BIT3) {
>> +               pr_info_ratelimited("842 coprocessor queue overflow\n");
> 
> if it's not an error, should this be pr_debug_ratelimited instead?
> What is an end user expected to do if they see this msg in the log?
> 
>> +               ret &= ~ICSWX_BIT3;
>> +       }
>> +
>>         switch (ret) {
>>         case ICSWX_INITIATED:
>>                 ret = wait_for_csb(wmem, csb);
>>
>>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
