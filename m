From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH crypto 2/2] crypto: caam - add allocation failure handling
 in SPRINTFCAT macro
Date: Wed, 23 Apr 2014 19:35:45 +0300
Message-ID: <5357EBE1.9000402@freescale.com>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com>
 <1397815302-15915-2-git-send-email-horia.geanta@freescale.com>
 <201404230156.41234.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <stable@vger.kernel.org>,
	Kim Phillips <kim.phillips@freescale.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:28834
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756730AbaDWQuv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Apr 2014 12:50:51 -0400
In-Reply-To: <201404230156.41234.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/23/2014 2:56 AM, Marek Vasut wrote:
> On Friday, April 18, 2014 at 12:01:42 PM, Horia Geanta wrote:
>> GFP_ATOMIC memory allocation could fail.
>> In this case, avoid NULL pointer dereference and notify user.
>>
>> Cc: <stable@vger.kernel.org> # 3.2+
>
> If I recall correctly, you need to get the patch accepted into mainline before
> sending it for -stable .
>

 From Documentation/stable_kernel_rules.txt
  - To have the patch automatically included in the stable tree, add the tag
      Cc: stable@vger.kernel.org
    in the sign-off area. Once the patch is merged it will be applied to
    the stable tree without anything else needing to be done by the author
    or subsystem maintainer.

>> Cc: Kim Phillips <kim.phillips@freescale.com>
>> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
>> ---
>>   drivers/crypto/caam/error.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
>> index 9f25f5296029..0eabd81e1a90 100644
>> --- a/drivers/crypto/caam/error.c
>> +++ b/drivers/crypto/caam/error.c
>> @@ -16,9 +16,13 @@
>>   	char *tmp;						\
>>   								\
>>   	tmp = kmalloc(sizeof(format) + max_alloc, GFP_ATOMIC);	\
>> -	sprintf(tmp, format, param);				\
>> -	strcat(str, tmp);					\
>> -	kfree(tmp);						\
>> +	if (likely(tmp)) {					\
>> +		sprintf(tmp, format, param);			\
>> +		strcat(str, tmp);				\
>> +		kfree(tmp);					\
>> +	} else {						\
>> +		strcat(str, "kmalloc failure in SPRINTFCAT");	\
>
> This entire macro looks somewhat strange.

I am trying to fix it with minimal changes, so the patch qualifies for 
-stable.

> 1) Can't you just snprintf() into $str + some offset ? Something like:
>     snprintf(str + strlen(str), str_total_sz - strlen(str), format, param);
>

I think this would work. It also gets rid of memory allocation.

Note that strlen(str) is undefined if str is not initialized / 
null-terminated.
However, all code paths seem to touch this line in caam_jr_strstatus():
sprintf(outstr, "%s: ", status_src[ssrc].error);
before reaching SPRINTFCAT macros, so str is null-terminated.

I'll send v2.

> 2) Why is noone checking if the $str has enough space for contents of $tmp ?

All call sites reach this macro via caam_jr_strstatus(tmp, ...), which 
is always called having:
char tmp[CAAM_ERROR_STR_MAX];

CAAM_ERROR_STR_MAX is 302, probably enough according to commit
de2954d66408da3ae34effda777bb564fd17781b (crypto: caam - fix printk 
recursion for long error texts).

Horia
