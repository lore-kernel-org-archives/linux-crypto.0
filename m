Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82607C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jul 2022 12:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiGLMJm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jul 2022 08:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiGLMJj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jul 2022 08:09:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B354505E;
        Tue, 12 Jul 2022 05:09:38 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CBxma8023718;
        Tue, 12 Jul 2022 12:09:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : reply-to : in-reply-to : references : message-id : content-type
 : content-transfer-encoding : mime-version; s=pp1;
 bh=dNMgEsia0wuGHbHmztRbKkT7w8fy4LyQoeq5vMLGd0I=;
 b=M4I4/AvwDjxll5EB4Mc+kG1mvERvu+kNxgHlQAYtfMDXZ1GMJFhFchEZV7UKw3cVbBI0
 hHrB1icKlwNh1tlECzbx34tD4fOwR/l6v60sJgHzlgcWT6XWTXCKJz3lD+Lca8LXsk2z
 Sk1YVvrr3TH7BYa0BmsPotKNf7wTNYEFYjXxHlN7dmE9FGiKmM5Il3J6QF4H903sglu1
 GDuALuEnujDXmMHoswtjxCOvyoIlcpvGxfApElX7fPupmp8nR4nuZTzJNyFYwyoUcsgC
 MRSfHrr18JFvOZcSPKNl/jrrwGYo3srmPEXynNom4C/EG4pYZspZu1TWJmt2CdMW4EKp gw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h98jvgcq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 12:09:37 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26CC6o1a026956;
        Tue, 12 Jul 2022 12:09:37 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3h71a9tucd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 12:09:37 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26CC9Zeb27197822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 12:09:35 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90A23AC05E;
        Tue, 12 Jul 2022 12:09:35 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C7ECAC059;
        Tue, 12 Jul 2022 12:09:35 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jul 2022 12:09:35 +0000 (GMT)
Date:   Tue, 12 Jul 2022 14:09:35 +0200
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        jchrist@linux.ibm.com, dengler@linux.ibm.com
Subject: Re: [PATCH] s390/archrandom: remove CPACF trng invocations in
 interrupt context
Reply-To: freude@linux.ibm.com
In-Reply-To: <Ys1Loyu21C48Zm6n@zx2c4.com>
References: <20220712100829.128574-1-freude@linux.ibm.com>
 <Ys1Loyu21C48Zm6n@zx2c4.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <4881578c512c5420315abfef47068df0@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kqkoYwfMK9JiOrw0w6n0IxdwIJ25Dqzb
X-Proofpoint-ORIG-GUID: kqkoYwfMK9JiOrw0w6n0IxdwIJ25Dqzb
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_08,2022-07-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=395
 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120046
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-07-12 12:23, Jason A. Donenfeld wrote:
> Hi Harald,
> 
> On Tue, Jul 12, 2022 at 12:08:29PM +0200, Harald Freudenberger wrote:
>> This patch introduces two things:
>> 1) The arch_get_random_seed_int() implementation now always
>>    returns false. There is no user in the whole kernel using
>>    this function.
> 
> Please do not do this. It has nothing to do with the rest of the patch,
> but also this isn't really the right place to decide on that. As we
> discussed last week with the arch_get_random_words{,_seed} branch of 
> the
> conversation - 
> https://lore.kernel.org/all/YsQ%2FvZSkzWPLwIte@zx2c4.com/
> - there are a few things that might be suboptimal about the API. When 
> we
> fix these, I'd prefer for it to be done in some coherent step. What
> you're doing here is just gimping the present API, which preemptively
> rots the entire thing and *forces* us to remove it for all 
> architectures
> since it would become non-dependable. And I don't like having our hands
> be forced here. I'd much rather carefully consider this.
> 
> So please remove this snippet.

Ok, will do.

> 
>> 2) For the arch_get_random_seed_long() make sure the CPACF trng
>>    instruction is never called in any interrupt context.
> 
> I don't object overly loudly to this. However, based on your comment in
> https://lore.kernel.org/all/7e65130c6e66ce7a9f9eb469eb7e64e0@linux.ibm.com/
> , I was under the impression that this wasn't necessary. If you think 
> it
> is, it'd be useful to show some measured latency numbers on actual
> systems. Otherwise it seems like premature optimization? Anyway, if you
> have solid rationale, I'm fine with this as I mentioned in the other
> thread. I'm just a bit confused now on the particulars of the "why" 
> part
> given your earlier comment.
> 
>> This is done by adding an additional condition in_task().
> 
> That doesn't seem right. Instead use `!in_hardirq()`, or perhaps
> `!in_nmi() && !in_hardirq()`? Otherwise you also disallow this when
> serving softirqs, which based on the discussion, I don't think you
> really want to do. Or do you? Without actual latency measurements and a
> real world look at the implications, it's hard to see what we're after.
> 
>> which confirms that the call is in softirq context. So in_task() 
>> covers exactly
>> the cases where we want to have CPACF trng called: not in nmi, not in 
>> hard irq,
>> not in soft irq but in normal task context and during kernel init.
> 
> You've gone through the troubles of confirming experimentally what
> in_task() does, but that doesn't answer *why* it should be disallowed
> variously in each one of these contexts.

I think, I showed this. The only real occurrences remaining for the
arch_get_random_seed_long() call is within softirq context when the
network layer tries to allocate some skb buffers. My personal feeling
about this is that it does not hurt - but I asked our network guys
and their feedback is clear: no way - every delay there may cause
high bandwidth traffic to stumble and this is to be absolutely avoided.
However, they can't give me any measurements.

So yes, the intention is now with checking for in_task() to prevent
the trng call in hard and soft interrupt context. But still I'd like
to meet your condition to provide good random at kernel startup.

> 
> Regards,
> Jason

Regards,
Harald Freudenberger
