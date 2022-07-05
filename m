Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D73C43334
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 17:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiGERrs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 13:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiGERrr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 13:47:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818D91DA60;
        Tue,  5 Jul 2022 10:47:46 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265GoWNe027944;
        Tue, 5 Jul 2022 17:47:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xP6EvhJHSIVlx0Vjph8NPwyfuRz1b1SjJhWMAVht9Es=;
 b=KwKWNCZ4cSdVr1JWZHlmauZDPLcvrBv5R5vShYoaBoQkwpE7rO+t3DHZ4Cw6Cmzb/SJT
 1zBhUwShOvTekmv5jVd64Y2AdRf3DDiC80tg2xRb5l6+vohN7cFWd4VuKauS8gqDoE71
 JUKcfZlj/i1bB6Bgvy39pYFIPdE+Jnr4jDFhZJeuLrfAtvFG6chjtwOEJKrTkDN4E6PU
 GrIsfMqOqSUf47a+Bo+MXiV5BwCJs07hnX4AHAcdXCu/pB0f9i5EB6f5qluvFSONnOQ5
 MaxNYBI6w9pgVa34fjXfA+UHMX4t5NQHWC4C/BdOvrlRxAMzpeyJee9oQBRiZH89YnJG qA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4s61sdwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 17:47:45 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265HZYEl008267;
        Tue, 5 Jul 2022 17:47:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3h2dn8vb2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 17:47:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265Hleh710813896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 17:47:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00D9042042;
        Tue,  5 Jul 2022 17:47:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F4914203F;
        Tue,  5 Jul 2022 17:47:39 +0000 (GMT)
Received: from [9.171.76.195] (unknown [9.171.76.195])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 17:47:39 +0000 (GMT)
Message-ID: <30e681b2-a411-cdb1-4b46-243db25abeef@linux.ibm.com>
Date:   Tue, 5 Jul 2022 19:47:37 +0200
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
 <aafbb400-d0cb-99de-8b10-3c39c7b9bae5@linux.ibm.com>
 <YsRoXObdpCNbtpHS@zx2c4.com>
From:   Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <YsRoXObdpCNbtpHS@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h8mwWmFMrB7huOB_h80MG51nvJxj6ORP
X-Proofpoint-ORIG-GUID: h8mwWmFMrB7huOB_h80MG51nvJxj6ORP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_14,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=971 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050076
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

On 05/07/2022 18:35, Jason A. Donenfeld wrote:
> Hi Holger,
> 
> On Tue, Jul 05, 2022 at 06:27:59PM +0200, Holger Dengler wrote:
>> I saw a few calls in interrupt context during my tracing, but I didn't
>> look to see which ones they were. Let me figure that out in the next
>> few days and provide more information on that.
> 
> One thing to keep in mind is that it's used at boot time, when
> technically IRQs are turned off, so it appears like interrupt context
> depending on which way you squint. But boot time obviously isn't a
> problem. So be sure that's not the usage you're seeing.

Ok, let me check this. I will also think about the tree-wide cleanup you mentioned in an earlier mail. It looks, that s390 could fill the block.rdseed with a single call.

>> For the moment, I would propose to drop the buffering but also return
>> false, if arch_random_get_seed_long() is called in interrupt context.
> 
> As a last ditch, maybe that's best. Maybe... Do you know off hand how
> many cycles each call takes?

I don't know the exact number of cycles, but as I mentioned in the coverletter, the trng instruction is one of the specialties of the s390 platform. It looks like an instruction, but it is some kind of firmware executed (it is called millicode). These kind of long-running instructions are also interruptable and can resume.

A trng call runs for minimal ~20-190us for 32 bytes. 20us on newer machine generations, 190us on older ones. These are not 100% exact measurements, but the dimension should be correct.

> 
>> diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
>> index 2c6e1c6ecbe7..711357bdc464 100644
>> --- a/arch/s390/include/asm/archrandom.h
>> +++ b/arch/s390/include/asm/archrandom.h
>> @@ -32,7 +32,8 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
>>
>>  static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
>>  {
>> -       if (static_branch_likely(&s390_arch_random_available)) {
>> +       if (static_branch_likely(&s390_arch_random_available) &&
>> +           !in_interrupt()) {
> 
> in_interrupt() is deprecated. You want in_hardirq() here. You'll also
> want to verify that this doesn't prevent random_init() from working.
> 
> Jason

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com
