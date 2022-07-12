Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA8FC43334
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jul 2022 14:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbiGLOgX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jul 2022 10:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiGLOfs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jul 2022 10:35:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90F7B93FE;
        Tue, 12 Jul 2022 07:35:45 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CDBuiW007915;
        Tue, 12 Jul 2022 14:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=kGyzR2fpyeLcBebTuOi+d7JoZMaKSe8+x0WfdvqQfUg=;
 b=fiyQsI2qa0GpRBUEFNxr/mxL/X0zAJdWa/rPpUvfMBB/yoeAifZsdOZjVjYbyd9ouk1W
 pH5ypuPnqlahBvtci/N9ghVNsUfYVoqiKZoWmns41B1DfEph+AdXrFkG6G4FqWmZPOCv
 7YwVl6FHA+3fCNW1U2ggm5LLCwekeERXDEiMuxYRfeS51j58FMVFRfVPqnsXS0O3ySEK
 Id96mRcuyEX0s6Mn2yjfGs0f6OJyKS+3PuubCguoG7KuSJZdGlMttdccnMEF3w9LXRU3
 BGFKHkbXUbDSQPULyp0YHgxZC5h9llSn5ea4sgPJiQFqPVgBujm0JT8+TmAg0GT1epdk JA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h98jvm4ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 14:35:44 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26CEKWgu029571;
        Tue, 12 Jul 2022 14:35:44 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3h71a9kxk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 14:35:44 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26CEZgel25297300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 14:35:42 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61730BE053;
        Tue, 12 Jul 2022 14:35:42 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05DEBBE04F;
        Tue, 12 Jul 2022 14:35:41 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jul 2022 14:35:41 +0000 (GMT)
MIME-Version: 1.0
Date:   Tue, 12 Jul 2022 16:35:41 +0200
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        jchrist@linux.ibm.com, dengler@linux.ibm.com
Subject: Re: [PATCH] s390/archrandom: remove CPACF trng invocations in
 interrupt context
Reply-To: freude@linux.ibm.com
In-Reply-To: <Ys1olOgaw44dXeiT@zx2c4.com>
References: <20220712100829.128574-1-freude@linux.ibm.com>
 <Ys1Loyu21C48Zm6n@zx2c4.com>
 <4881578c512c5420315abfef47068df0@linux.ibm.com>
 <Ys1olOgaw44dXeiT@zx2c4.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <ac816519f9d8f4948434acb0db631041@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dlYjzzuukjachh3QThN5XbF1vkp6nh0M
X-Proofpoint-ORIG-GUID: dlYjzzuukjachh3QThN5XbF1vkp6nh0M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_08,2022-07-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=87 mlxscore=87 malwarescore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=-83
 impostorscore=0 clxscore=1015 spamscore=87 bulkscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120056
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-07-12 14:27, Jason A. Donenfeld wrote:
> Hi Harald,
> 
> On Tue, Jul 12, 2022 at 02:09:35PM +0200, Harald Freudenberger wrote:
>> > You've gone through the troubles of confirming experimentally what
>> > in_task() does, but that doesn't answer *why* it should be disallowed
>> > variously in each one of these contexts.
>> 
>> I think, I showed this. The only real occurrences remaining for the
>> arch_get_random_seed_long() call is within softirq context when the
>> network layer tries to allocate some skb buffers. My personal feeling
>> about this is that it does not hurt - but I asked our network guys
>> and their feedback is clear: no way - every delay there may cause
>> high bandwidth traffic to stumble and this is to be absolutely 
>> avoided.
>> However, they can't give me any measurements.
>> 
>> So yes, the intention is now with checking for in_task() to prevent
>> the trng call in hard and soft interrupt context. But still I'd like
>> to meet your condition to provide good random at kernel startup.
> 
> That's too bad, but okay.
> 
> Final question: do you see any of the in_task() vs in_whatever()
> semantics changing if arch_get_random_words{,_seed}() is ever
> implemented, which would reduce the current multitude of calls to the
> trng to a single call?
> 
> Jason

Hm, no, I can't see a way to provide trng random data in any whatever
interrupt context for the next future. The only enabler would be to
use a buffer ... I started to get in contact with our hardware guys
to make the trng data internally buffered and this the invocation
could be in no time give back random data. But this may be a
hardware development thing for the next machine generation.

Thanks Jason for your work

Regards
Harald Freudenberger
