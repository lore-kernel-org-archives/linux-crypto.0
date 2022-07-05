Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E22AC43334
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 16:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiGEQ2K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 12:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiGEQ2J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 12:28:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8AC19292;
        Tue,  5 Jul 2022 09:28:08 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265F8KLU023107;
        Tue, 5 Jul 2022 16:28:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZOS+cyw8ltQYhxCHzb2fpRmRlXRFeB+SL1hdJvGLMMQ=;
 b=jSRnR+gM8WgkA25EzP66tSi3amKcjegFgbaEY8X2f1h3k3zdqqo2od0JwvUIoBGn1xPh
 iN4Z/UBhyXTCeeHioio3XoLvi+SiK9OZBqP0jtwbjTD70w0oKVFSgds7PHqn1+Uq+WZj
 p2Dx3LI0okoUrRp+ZJJwf4iRVRzva9hbE+olKP5SWR/OY554zr3o6Yq3EQgX2qQ/NtWA
 I8Q2OeJObC5A3Z7SFWwJl9dkltFYrwWtXu6z8f550gnUhgiqM238/lvDP6fDzGa5MY9m
 vd6UOU/kyL97qLJ1sTk1Xq3tWLHSYsq3CuvquciAhtfAxIL4Yve+k4Idrv2DOZG41jmN kg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4phxv6j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 16:28:08 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265GLWw4012273;
        Tue, 5 Jul 2022 16:28:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3h2dn9499n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 16:28:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265GS2MC10354962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 16:28:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A3AB42047;
        Tue,  5 Jul 2022 16:28:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00FF242045;
        Tue,  5 Jul 2022 16:28:02 +0000 (GMT)
Received: from [9.171.76.195] (unknown [9.171.76.195])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 16:28:01 +0000 (GMT)
Message-ID: <aafbb400-d0cb-99de-8b10-3c39c7b9bae5@linux.ibm.com>
Date:   Tue, 5 Jul 2022 18:27:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 1/1] s390/arch_random: Buffer true random data
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220705112712.4433-1-dengler@linux.ibm.com>
 <20220705112712.4433-2-dengler@linux.ibm.com> <YsQ6OOrOWPhdynoM@zx2c4.com>
 <9a0561c0-68f7-b630-4440-3ca32bf28dc2@linux.ibm.com>
 <YsRUowTs9n98p9EL@zx2c4.com>
From:   Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <YsRUowTs9n98p9EL@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qgYA0DPcrU-2UIB2xpPzetGkyf1BrzK4
X-Proofpoint-GUID: qgYA0DPcrU-2UIB2xpPzetGkyf1BrzK4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_13,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=786 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050069
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

On 05/07/2022 17:11, Jason A. Donenfeld wrote:
> Hi Holger,
> 
> On Tue, Jul 05, 2022 at 04:58:30PM +0200, Holger Dengler wrote:
>> It is true, that the performance of the instruction is not really
>> relevant, but only for calls outside of an interrupt context. I did
>> some ftrace logging for the s390_random_get_seed_long() calls, and -
>> as you said - there are a few calls per minute. But there was also
>> some repeating calls in interrupt context. On systems with a huge
>> interrupt load, this can cause severe performance impacts. I've no
> 
> It'd be interesting to know more about this. The way you get
> arch_random_get_seed_long() from irq context is:
> 
> get_random_{bytes,int,long,u32,u64}()
>   crng_make_state()
>     crng_reseed() <-- Rarely
>       extract_entropy()
>         arch_get_random_seed_long()
> 
> So if an irq user of get_random_xx() is the unlucky one in the minute
> span who has to call crng_reseed() then, yea, that'll happen. But I
> wonder about this luck aspect. What scenarios are you seeing where this
> happens all the time? Which driver is using random bytes *so* commonly
> from irq context? Not that, per say, there's anything wrong with that,
> but it could be eyebrow raising, and might point to de facto solutions
> that mostly take care of this.

I saw a few calls in interrupt context during my tracing, but I didn't look to see which ones they were. Let me figure that out in the next few days and provide more information on that.

> One such direction might be making a driver that does such a thing do it
> a little bit less, somehow. Another direction would be preferring
> non-irqs to handle crng_reseed(), but not disallowing irqs entirely,
> with a patch something like the one below. Or maybe there are other
> ideas.

Reduce the number of trng in interrupt context is a possibility, but - in my opinion - only one single trng instruction call in interrupt context in one too much.

For the moment, I would propose to drop the buffering but also return false, if arch_random_get_seed_long() is called in interrupt context.

diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index 2c6e1c6ecbe7..711357bdc464 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -32,7 +32,8 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)

 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
-       if (static_branch_likely(&s390_arch_random_available)) {
+       if (static_branch_likely(&s390_arch_random_available) &&
+           !in_interrupt()) {
                cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
                atomic64_add(sizeof(*v), &s390_arch_random_counter);
                return true;

(on-top of your commit, without our buffering patch)

> 
> But all this is to say that having some more of the "mundane" details
> about this might actually help us.
> 
> Jason
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index e3dd1dd3dd22..81df8cdf2a62 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -270,6 +270,9 @@ static bool crng_has_old_seed(void)
>  	static bool early_boot = true;
>  	unsigned long interval = CRNG_RESEED_INTERVAL;
> 
> +	if (in_hardirq())
> +		interval += HZ * 10;
> +
>  	if (unlikely(READ_ONCE(early_boot))) {
>  		time64_t uptime = ktime_get_seconds();
>  		if (uptime >= CRNG_RESEED_INTERVAL / HZ * 2)
> 

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com
