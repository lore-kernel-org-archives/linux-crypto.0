Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7603BFAFA;
	Fri, 31 Jul 2026 07:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785483915; cv=none; b=uTFAhDNQ+68MMBcd65eDmY71k6NCALgwwYOlIdE6LQoREV8C39AgtNK1duiPwJTCXyWBjI1NJYVSTbnNYOfWZmsEkYCcDOfIwKmbRmTYm0gpNS1VRDiKzzXl7HdpZ6fpnaS/GeeqQkLPyQqJKsX3A459Uc8fmOdbpKzz4Mus5KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785483915; c=relaxed/simple;
	bh=4LngTOzl5y9ofSKdgd24PhhELt2UnKGchWIbesx/X1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GjL6CNboQCb1GEwfFS/1Dd4oA2epTrmoiqKuOMcFsFJNb2t04tH+4TbiGNEeXrHzXendupwOis+WqxPj7bAH07HoMYhfDp7NE9+1X5BRGe98+A80r8+2Zmlw9izUzYFdkyLZsgsFgBn2JtuTApuQiNgbCDzxFOmOBgCd5m05orU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CPvUzo93; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CPvUzo93"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V5IhQH855844;
	Fri, 31 Jul 2026 07:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FlmPDO
	W1vx10zqQjdwQ5FLATwQugCEBbuIKjtSWI+8g=; b=CPvUzo93qyXUE1RXp8OlxI
	SttyCM69yJQllAVYpAaaSmbHKJ9snyq5s8Q007t02ar8yoLXOpv7IHhjMCAgbwDF
	YfdI1vnL6m6lp7OAaT0Va0t9JHhLG9GGkpQ84l0XA6qow4/JeyJPkXnGNDi9IuJk
	EVoagOdOK9PekoiQ1mfAt+RA+JjpjfhFoBfqXLrhTeU7TPkO2iKNAIT5nGUSEKhX
	BGtXn4RPxBo7ENorqlXOrWrmdgk0fHcOeiZ6MEmj41d6jIshhflBayi5+5PeAI+F
	4P+6KBGOsTb8G2LUuE1GYXhjPRTmDWaBmPad5jz4knUkk0oPbpwuuCfnnTJ/dUyQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyjjwtk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 07:45:03 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66V7fGAT019621;
	Fri, 31 Jul 2026 07:45:02 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhpwsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 07:45:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66V7iwTX25166492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 07:44:58 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2B4A20040;
	Fri, 31 Jul 2026 07:44:58 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B35120043;
	Fri, 31 Jul 2026 07:44:58 +0000 (GMT)
Received: from [9.111.59.130] (unknown [9.111.59.130])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jul 2026 07:44:57 +0000 (GMT)
Message-ID: <18c36e42-8f96-479c-8152-2da3f5034f04@linux.ibm.com>
Date: Fri, 31 Jul 2026 09:44:57 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] s390/crypto: Replace cond_resched() with msleep(1)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260730052907.2607026-1-hca@linux.ibm.com>
 <20260730052907.2607026-2-hca@linux.ibm.com>
 <20260730101157.GQ49951@noisy.programming.kicks-ass.net>
 <39570813-27b0-40f9-89c5-8e2dce05e2f0@linux.ibm.com>
 <20260730124819.GA776954@noisy.programming.kicks-ass.net>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260730124819.GA776954@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA1MCBTYWx0ZWRfX3FJjt2H+ex9H
 fS0cM0SfhEtU176ZUG/xS9gBI0Rl25zN2ZeMDsyKSxrR+v/7cPJi5ZKpqW+CYil+Z7C4rJFLh4I
 rKnqv/WZGYKyaMogOeSLCmm7I9XGRzI=
X-Proofpoint-GUID: vPsBqPZYPbljEapnlNxsbBXHCWkjXoZr
X-Proofpoint-ORIG-GUID: vPsBqPZYPbljEapnlNxsbBXHCWkjXoZr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA1MCBTYWx0ZWRfX0Skj6xfEsyt7
 h8F1hCs/N9pFlch3KczXZb/c2zRXR8Gizd53TpXEjeuO6yufS+oehcBCR73yKXaOgBt/J3p697P
 DChgkcBOai7p2EqiQONwG7fgROPg0dp5wp4bzyUgrywZvyO7R6VexDNNpF3q/YqJ0x3b4JiEkRm
 v3GIgsp5uIroeGyycLkNG81lrcM1L+gQDxXu8WJAvWDe79hqzXTIIZBupIpEjzciGIxb83dhXKO
 BAej1r7UkNtfeZYHjRD8faRu6IlZF5tQxrVfZ4ivFpQ5gx4+o+XR/0ouG793G6dcoCuaxgas3qg
 3AJqQ6Y+30ZENJGiAIxX4Ru/kFqHboBke1KnxvAiv230ufCaCdFfcbmPhLkwqf4tydaKZNr2Us0
 ypOBmzci6dmNiR0+P5RJPFZHn1BbZKi8CTNJCOzUEQOZ1GONtQs6vnueMbAwst2NV2O+jx0YcOm
 ilhFPj1G1qLb4nzXw3Q==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a6c527f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=TCxBX146pXdEmVMj1BsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310050

On 7/30/26 14:48, Peter Zijlstra wrote:
> On Thu, Jul 30, 2026 at 01:34:31PM +0200, Holger Dengler wrote:
>> Peter,
>>
>> On 7/30/26 12:11, Peter Zijlstra wrote:
>>> On Thu, Jul 30, 2026 at 07:29:04AM +0200, Heiko Carstens wrote:
>>>> With [1] cond_resched() is always compiled away and becomes a no-op.
>>>>
>>>> The comments for all cond_resched() calls in crypto code however indicate
>>>> that the current process should be scheduled away to avoid instant
>>>> re-invocation of a callback. This is not what cond_resched() would do or
>>>> did.
>>>>
>>>> Instead of just removing the cond_resched() calls, replace them with
>>>> msleep() calls, as suggested by Holger Dengler. This forces the current
>>>> task to be scheduled away (sleeps) like originally intended.
>>>>
>>>> [1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
>>>>
>>>> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
>>>> ---
>>>>  arch/s390/crypto/paes_s390.c  | 8 ++++----
>>>>  arch/s390/crypto/phmac_s390.c | 4 ++--
>>>>  2 files changed, 6 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
>>>> index 8cfe6166c193..511cb6105436 100644
>>>> --- a/arch/s390/crypto/paes_s390.c
>>>> +++ b/arch/s390/crypto/paes_s390.c
>>>> @@ -555,7 +555,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
>>>>  		 * To avoid immediately re-invocation of this callback,
>>>>  		 * tell the scheduler to voluntarily give up the CPU here.
>>>>  		 */
>>>> -		cond_resched();
>>>> +		msleep(1);
>>>>  		pr_debug("rescheduling request\n");
>>>>  		return -ENOSPC;
>>>>  	} else if (rc) {
>>>
>>> I am somewhat conflicted on this. It will add a 'random' delay to this
>>> crypto user (which might be real-time task) that is not related to the
>>> actual event this is waiting for.
>>>
>>> That is, it could be that this key expiration thing is sorted way faster
>>> than this one milisecond.
>>>
>>> Is there nothing the crypto layer can do that is more clever; like a
>>> condition variable on the key update when -ENOSPC is returned or
>>> something.
>>
>> Let me give a bit of background here: The protected key can only get
>> invalid, if the linux instance (z/VM or KVM guest) is moved to another
>> hypervisor on a different machine (aka life guest relocation). In such a
>> case, the crypto accelerator card and the host has to exchange the "real
>> key", which is wrapped by the host and handed back to the guest as the
>> re-newed protected key. Unfortunately there is no asynchronous trigger
>> on completion, you have to re-try (and maybe get another "in progress"
>> return).
>>
>> And as if that weren't bad enough, if this key exchange between card and
>> host is the first one, card and host has to instanciate a secure
>> communication channel (including a key exchange for the transport layer).
>>
>> I agree, this sounds rally bad for real-time tasks. But we're talking
>> about 2nd-level virtualization (with non-real-time hypervisors below)
>> and about cases, which can only happen right after a guest relocation to
>> another machine. Would the current solution be acceptable under these
>> circumstances?
> 
> Yes, guest migration is very likely far more disruptive than most
> anything else. Perhaps clarify the code comment to include some of this
> explanation?

I agree, the comment is not telling all main key points. What about the
following?

/*
 * Protected key expired due to relocation to another
 * host. The long runnning re-wrap has no asynchronous
 * completion notification, so polling is required.
 * Trigger a re-schedule of this request by returning
 * -ENOSPC ("hardware queue full") to the crypto engine.
 * To avoid immediately re-invocation of this callback,
 * tell scheduler to voluntarily give up the CPU here.
 */

(I would leave it up to Heiko to merge the comment in his series, or let
Harald/me do it in a separate patch)

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

