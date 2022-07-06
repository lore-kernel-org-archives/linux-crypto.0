Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E03DC43334
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 18:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiGFS36 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 14:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiGFS35 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 14:29:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618CBE6;
        Wed,  6 Jul 2022 11:29:56 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266I2pNt026835;
        Wed, 6 Jul 2022 18:29:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5q6jbx68SS0unOLPjlUpw6Z3TUhj8RD1hsIdZAHbL2k=;
 b=UZp3tHdPL2h0j1lqkou+6iNTQJVuWChyAI3hfcnelNF6GABBL0zZmVQBI22y0bK1ZVa3
 jga0TN2U2KVYtH0FLbGlhgKBAdRfs0Uv1476wem0n1Vct3HTi8/7OgJXl2oSVvwxvmLT
 OJ44LxidBvfxFidVigekJ34VsleyiwuikmX/n8VyEmaQCjE/8wmbeeg6ESJFLiel4GmP
 cDhJ1Zb2QhcGYJOeY3de5qdFottXDtk1sr0ZDn24+w9IzkgJ4FSmHUuKC6OMVc8F8NP+
 iOBHF95QvbpY2D+12A75Kq+ck6C/58dWnTEJGz6xuoA6ox/OlhAZkoANmUVFeSAqsot5 cw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5et81fn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 18:29:55 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 266ILJkc015356;
        Wed, 6 Jul 2022 18:29:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3h4v6592hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 18:29:53 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 266ITn2825035128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 18:29:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD598A404D;
        Wed,  6 Jul 2022 18:29:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D8C9A4053;
        Wed,  6 Jul 2022 18:29:49 +0000 (GMT)
Received: from [9.171.61.129] (unknown [9.171.61.129])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Jul 2022 18:29:49 +0000 (GMT)
Message-ID: <386ec16c-2561-2fcf-2eea-deaab45f349c@linux.ibm.com>
Date:   Wed, 6 Jul 2022 20:29:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v1 1/1] s390/arch_random: Buffer true random data
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Harald Freudenberger <freude@linux.ibm.com>
Cc:     Holger Dengler <dengler@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220705112712.4433-1-dengler@linux.ibm.com>
 <20220705112712.4433-2-dengler@linux.ibm.com> <YsQ6OOrOWPhdynoM@zx2c4.com>
 <9a0561c0-68f7-b630-4440-3ca32bf28dc2@linux.ibm.com>
 <YsRUowTs9n98p9EL@zx2c4.com>
 <aafbb400-d0cb-99de-8b10-3c39c7b9bae5@linux.ibm.com>
 <7e65130c6e66ce7a9f9eb469eb7e64e0@linux.ibm.com> <YsW3qWkIwXboHgim@zx2c4.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <YsW3qWkIwXboHgim@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gxHJEsEoH6RK9Iq8mDNXIpP5NADBNeKX
X-Proofpoint-GUID: gxHJEsEoH6RK9Iq8mDNXIpP5NADBNeKX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=951 clxscore=1011 impostorscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207060071
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Am 06.07.22 um 18:26 schrieb Jason A. Donenfeld:
> Hi Harald,
> 
> On Wed, Jul 06, 2022 at 06:18:27PM +0200, Harald Freudenberger wrote:
>> On 2022-07-05 18:27, Holger Dengler wrote:
>>> Hi Jason,
>>>
>>> On 05/07/2022 17:11, Jason A. Donenfeld wrote:
>>>> Hi Holger,
>>>>
>>>> On Tue, Jul 05, 2022 at 04:58:30PM +0200, Holger Dengler wrote:
>>>>> It is true, that the performance of the instruction is not really
>>>>> relevant, but only for calls outside of an interrupt context. I did
>>>>> some ftrace logging for the s390_random_get_seed_long() calls, and -
>>>>> as you said - there are a few calls per minute. But there was also
>>>>> some repeating calls in interrupt context. On systems with a huge
>>>>> interrupt load, this can cause severe performance impacts. I've no
>>>>
>>>> It'd be interesting to know more about this. The way you get
>>>> arch_random_get_seed_long() from irq context is:
>>>>
>>>> get_random_{bytes,int,long,u32,u64}()
>>>>    crng_make_state()
>>>>      crng_reseed() <-- Rarely
>>>>        extract_entropy()
>>>>          arch_get_random_seed_long()
>>>>
>>>> So if an irq user of get_random_xx() is the unlucky one in the minute
>>>> span who has to call crng_reseed() then, yea, that'll happen. But I
>>>> wonder about this luck aspect. What scenarios are you seeing where
>>>> this
>>>> happens all the time? Which driver is using random bytes *so* commonly
>>>> from irq context? Not that, per say, there's anything wrong with that,
>>>> but it could be eyebrow raising, and might point to de facto solutions
>>>> that mostly take care of this.
>>>
>>> I saw a few calls in interrupt context during my tracing, but I didn't
>>> look to see which ones they were. Let me figure that out in the next
>>> few days and provide more information on that.
>>>
>>>> One such direction might be making a driver that does such a thing do
>>>> it
>>>> a little bit less, somehow. Another direction would be preferring
>>>> non-irqs to handle crng_reseed(), but not disallowing irqs entirely,
>>>> with a patch something like the one below. Or maybe there are other
>>>> ideas.
>>>
>>> Reduce the number of trng in interrupt context is a possibility, but -
>>> in my opinion - only one single trng instruction call in interrupt
>>> context in one too much.
>>>
>>> For the moment, I would propose to drop the buffering but also return
>>> false, if arch_random_get_seed_long() is called in interrupt context.
>>>
>>> diff --git a/arch/s390/include/asm/archrandom.h
>>> b/arch/s390/include/asm/archrandom.h
>>> index 2c6e1c6ecbe7..711357bdc464 100644
>>> --- a/arch/s390/include/asm/archrandom.h
>>> +++ b/arch/s390/include/asm/archrandom.h
>>> @@ -32,7 +32,8 @@ static inline bool __must_check
>>> arch_get_random_int(unsigned int *v)
>>>
>>>   static inline bool __must_check arch_get_random_seed_long(unsigned
>>> long *v)
>>>   {
>>> -       if (static_branch_likely(&s390_arch_random_available)) {
>>> +       if (static_branch_likely(&s390_arch_random_available) &&
>>> +           !in_interrupt()) {
>>>                  cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
>>>                  atomic64_add(sizeof(*v), &s390_arch_random_counter);
>>>                  return true;
>>>
>>> (on-top of your commit, without our buffering patch)
>>>
>>>>
>>>> But all this is to say that having some more of the "mundane" details
>>>> about this might actually help us.
>>>>
>>>> Jason
>>>>
>>>> diff --git a/drivers/char/random.c b/drivers/char/random.c
>>>> index e3dd1dd3dd22..81df8cdf2a62 100644
>>>> --- a/drivers/char/random.c
>>>> +++ b/drivers/char/random.c
>>>> @@ -270,6 +270,9 @@ static bool crng_has_old_seed(void)
>>>>   	static bool early_boot = true;
>>>>   	unsigned long interval = CRNG_RESEED_INTERVAL;
>>>>
>>>> +	if (in_hardirq())
>>>> +		interval += HZ * 10;
>>>> +
>>>>   	if (unlikely(READ_ONCE(early_boot))) {
>>>>   		time64_t uptime = ktime_get_seconds();
>>>>   		if (uptime >= CRNG_RESEED_INTERVAL / HZ * 2)
>>>>
>>
>> Hi Holger and Jason
>> I tried to find out what is the reason of the invocations in interrupt
>> context.
>> First I have to admit that there is in fact not much of
>> arch_get_random_seed_long()
>> invocation any more in the recent kernel (5.19-rc5). I see about 100
>> invocations
>> within 10 minutes with an LPAR running some qperf and dd dumps on dasds
>> test load.
>> About half of these invocations is in interrupt context. I
>> dump_stack()ed some of
>> these and I always catch the function
>> kfence_guarded_alloc()
>>     prandom_u32_max()
>>       prandom_u32()
>>         get_random_u32()
>>           _get_random_bytes()
>>             crng_make_state()
>>               crng_reseed()
>>                 extract_entropy()
>>                   arch_get_random_seed_long()
>>
>> However, with so few invocations it should not make any harm when there
>> is a
>> even very expensive trng() invocation in interrupt context.
>>
>> But I think we should check, if this is really something to backport to
>> the older
>> kernels where arch_get_random_seed_long() is called really frequency.
> 
> I backported the current random.c design to old kernels, so the
> situation there should be the same as in 5.19-rc5.
> 
> So if you feel such rare usage is find even in_hardirq(), then I suppose
> there's nothing more to do here?

I think up to 190µs in interrupt can result in unwanted latencies. Yes it does not
happen that often and it is smaller than most timeslices of hypervisors.
So I would likely turn that question around
what happens if we return false if in_hardirq is true? Any noticeable
delays in code that uses random numbers?
