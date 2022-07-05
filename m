Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BB8C43334
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 14:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiGEO6k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 10:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiGEO6j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 10:58:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D38140DB;
        Tue,  5 Jul 2022 07:58:38 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265EjvVr027449;
        Tue, 5 Jul 2022 14:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y3jDeNk9KPTZ+ANrlUNPxfYLf6ojQp5hQvxuuZxFMs4=;
 b=GoJkn23rovuO0rXfl6AnkaZqR4w1M7FWOz0g3/SHID9qm60GbfXTCJvJl7/CfrXJLAfx
 aDfyt5nnnX4cTH5hVPZ6W12QvajAHKAzERMhjrtlKSO2LdF3YnBu8AGHGfVrbGDKuLn/
 B1rvb+ktEl21SIyGY8IoWVHP+anQUFzN+TniNhR2AQT4WqUZbHuCCSsfvJYLgVjshtWs
 gbIHgW2kpK6WOb83IFQRK1u0PT3MyKA3UPYjUBtJHkGoYLptltnRfKIHxe7P3/sS5Ntr
 ykzQy7TknZVxfpSV8DI/n3YIgo9+k2e4d12q510EcOg9wcpQj2Irwrs0q7FvqYRK+CuY fg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4pwe91m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 14:58:37 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265Ep1ig017186;
        Tue, 5 Jul 2022 14:58:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3h2dn8u4nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 14:58:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265EwXQD24969726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 14:58:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B70442041;
        Tue,  5 Jul 2022 14:58:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F87F4203F;
        Tue,  5 Jul 2022 14:58:32 +0000 (GMT)
Received: from [9.171.76.195] (unknown [9.171.76.195])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 14:58:32 +0000 (GMT)
Message-ID: <9a0561c0-68f7-b630-4440-3ca32bf28dc2@linux.ibm.com>
Date:   Tue, 5 Jul 2022 16:58:30 +0200
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
From:   Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <YsQ6OOrOWPhdynoM@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xvtIG_GcdClxQN5g4RgVKeTcshOLgqmY
X-Proofpoint-GUID: xvtIG_GcdClxQN5g4RgVKeTcshOLgqmY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_11,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=710 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050062
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

On 05/07/2022 15:18, Jason A. Donenfeld wrote:
> Hi Holger,
> 
> On Tue, Jul 05, 2022 at 01:27:12PM +0200, Holger Dengler wrote:
>> The trng instruction is very expensive and has a constant runtime for
>> getting 0 to 32 bytes of (conditioned) true random data. Calling trng for
>> in arch_get_random_seed_long() for each 8 bytes is too time-consuming,
>> especially if it is called in interrupt context.
>>
>> This implementation buffers the trng data and deliver parts of it to the
> 
> This patch seems to be repeating the same mistake I just cleaned up.
> Specifically, an advantage of a CPU RNG is that it can always provide
> *fresh* entropy, so that if, say, the system state is dumped, the CPU
> will continue to provide fresh new uncompromised values. When you buffer
> those values, they cease to be fresh.

You're right, the buffering has the disadvantage, that the random data for the non-first callers are not fresh. But if we only want to have fresh data here, we should avoid this call in interrupt context completely (see below).

> But more realistically, have you benchmarked this and seen that it's
> actually required? These functions are called once at boot, and then
> when the RNG is reseeded, which happens around once a minute. That's
> pretty darn rare. When you consider all the cycles that are completed
> over the course of a minute, whatever the cost of the TRNG is seems
> pretty negligible.

It is true, that the performance of the instruction is not really relevant, but only for calls outside of an interrupt context. I did some ftrace logging for the s390_random_get_seed_long() calls, and - as you said - there are a few calls per minute. But there was also some repeating calls in interrupt context. On systems with a huge interrupt load, this can cause severe performance impacts. I've no concrete performance measurements at the moment, but - as I said - the trng instruction on s390 takes a lot of time and in interrupt context the interrupts are disabled for the complete runtime of the instruction.

> So anyway, maybe it'd be best to look at the "big picture" problem you
> want to solve, rather than what looks to me like an attempt to solve a
> problem that doesn't exist. Or maybe it does? If so, I'd be interested
> to know when and how and where and such.

The optimization of the trng calls was not the main goal, but we (Harald and I) thought about how can we provide trng data to in-interrupt callers as well, without doing the trng instruction call in the interrupt context itself. At the moment, I don't see any possibility to do both, fresh data and prevent trng calls in interrupt context BUT provide trng data for in-interrupt-callers. But I'm always open for new ideas.

If the data must be fresh, I would propose not to use any trng-generated data for in-interrupt callers.

> 
> Jason

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com
