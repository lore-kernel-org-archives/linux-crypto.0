Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A92F410D24;
	Thu, 30 Jul 2026 11:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411287; cv=none; b=re9yCJx5aXRff25ahm/HP7HiAibXOqRBxFkXMwW2/Tie5nAefdStBOslDSz3+7YYUCaH5d4P+8xBY+xfAiZI/S8qGr2oCTrNzfkCG1oQkzFocfYG4wxv4mmAAB7SRr0W9XHN66wY5VVFxCYzh/31B7ZfKRI3pcLq3DY4R8Vf+3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411287; c=relaxed/simple;
	bh=fZV59fNhXu4Wh0j6giBgv27AD6aj39rpSIuWb5WBfEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fdrlcsOILEgt8iYS67rlFeQ8474B4BXFfQbYbArCBTaAuk+hqynvd7lBvCCN1XPo9s9bGBWFzi1we3wwMA2wK4HK5Da885RLQBkN5uwV7j9tOiksBtdiYc3FVR8mY7hiPCvbULgk09rlvkPARIsu5IK/zn9nk5WgS9h1l+ow/A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qnQB5Xl0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qnQB5Xl0"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UAHxNp846258;
	Thu, 30 Jul 2026 11:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=82/Iz9
	QOAM773M75QL8FheOWFaPVv13KCdaeeO8EOag=; b=qnQB5Xl0UgHiwbaPD2b70j
	03r+ZBhZoLmFmFfiJ8x5P5QOhPAF4pL0ZYJ6ghcspcaUEc/H9Up+ba6V+3DkNYQS
	Pmk8hZIxIQwAqBzxxq/rFFpoCpEMYsNktQUIdsXXuH+j2Ybt6OOEbyHmyB8gNNmp
	nbLOhwzuSmYPiAG7kXmv33DBxYqt+BDRdT3Dg/Kzakcru6R7Hv2Y3msoVraYwQZk
	xjAvq12ABVslOaiqosz5pPZBmzNSvVje8dSUOznuCki4D1Ep9TwWbx78HoHdime/
	qL/L5pqKwXa5M+wIpQgjo215nBsX39ggUX9tQUfFmWC05iRkiarlNHoZXBVD0w7w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuycqcdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 11:34:36 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66UBQJxA016526;
	Thu, 30 Jul 2026 11:34:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn9pgjwu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 11:34:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UBYWgO13500688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 11:34:32 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFD7A20043;
	Thu, 30 Jul 2026 11:34:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9AE0220040;
	Thu, 30 Jul 2026 11:34:31 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 11:34:31 +0000 (GMT)
Message-ID: <39570813-27b0-40f9-89c5-8e2dce05e2f0@linux.ibm.com>
Date: Thu, 30 Jul 2026 13:34:31 +0200
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
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260730101157.GQ49951@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hiqQkvn8PvBnI17F-vxIjYpzSOMyp8Bo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA4NCBTYWx0ZWRfXx1vtqZPeqfXu
 COYGtKwcC2hD0UGlzC9fkJnTKnsQeK/cTd5aqbnajkzMhwDw67WRI2KAzrtNjRA93c2OP8P7lMK
 rIgr4gNvefp3xzaHmCRbUCJ9vdvfJx2T3pYKAuH+W7wXtrHzGH8uZMwia3pt12pDH3bIMSHf419
 QTGF13Vo/DMAOv0YyPidOX1al0qfG89LOJkaA6VHeWo0Ua15xTzFx7U2B5wXZR+NzsSY2AJGyAI
 r1gtMLv70r327VczkA6G0OdlY3ekOV7yDjq6IUWkprO490BZuf8c/zSHpohk0D2RPfrMEWsa1N+
 DmScpiPBTrZ/4nmVFr6YKfr4j+j0EVCYelWIvl6hsRUqnzK3yLCXvcEJvPI7KZcWJWuJeXzk/PB
 UA1SOLMthWdyQbMO5N2AXKd0lqlzAPDM0x2VCE0QNAUpeLCfIqY67U2eJwVOAepRoxDyozWKHry
 KXMclZRUHeGaDo9A01Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA4NCBTYWx0ZWRfX//qOuzKBorKB
 6Z2cm0lR+qiOogkJJ9oXs1IFK3BISaMFhSes/wPFjr42OQVPX5iQHgDdFfe5c9IeGFAW5jBysUj
 4mNAXq7ZkKFygm7VxgvLjGRTiHK1lK8=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a6b36cc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=ZkYAL_Nd9JtXCKDLLNsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: hiqQkvn8PvBnI17F-vxIjYpzSOMyp8Bo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_03,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300084

Peter,

On 7/30/26 12:11, Peter Zijlstra wrote:
> On Thu, Jul 30, 2026 at 07:29:04AM +0200, Heiko Carstens wrote:
>> With [1] cond_resched() is always compiled away and becomes a no-op.
>>
>> The comments for all cond_resched() calls in crypto code however indicate
>> that the current process should be scheduled away to avoid instant
>> re-invocation of a callback. This is not what cond_resched() would do or
>> did.
>>
>> Instead of just removing the cond_resched() calls, replace them with
>> msleep() calls, as suggested by Holger Dengler. This forces the current
>> task to be scheduled away (sleeps) like originally intended.
>>
>> [1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
>>
>> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
>> ---
>>  arch/s390/crypto/paes_s390.c  | 8 ++++----
>>  arch/s390/crypto/phmac_s390.c | 4 ++--
>>  2 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
>> index 8cfe6166c193..511cb6105436 100644
>> --- a/arch/s390/crypto/paes_s390.c
>> +++ b/arch/s390/crypto/paes_s390.c
>> @@ -555,7 +555,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
>>  		 * To avoid immediately re-invocation of this callback,
>>  		 * tell the scheduler to voluntarily give up the CPU here.
>>  		 */
>> -		cond_resched();
>> +		msleep(1);
>>  		pr_debug("rescheduling request\n");
>>  		return -ENOSPC;
>>  	} else if (rc) {
> 
> I am somewhat conflicted on this. It will add a 'random' delay to this
> crypto user (which might be real-time task) that is not related to the
> actual event this is waiting for.
> 
> That is, it could be that this key expiration thing is sorted way faster
> than this one milisecond.
> 
> Is there nothing the crypto layer can do that is more clever; like a
> condition variable on the key update when -ENOSPC is returned or
> something.

Let me give a bit of background here: The protected key can only get
invalid, if the linux instance (z/VM or KVM guest) is moved to another
hypervisor on a different machine (aka life guest relocation). In such a
case, the crypto accelerator card and the host has to exchange the "real
key", which is wrapped by the host and handed back to the guest as the
re-newed protected key. Unfortunately there is no asynchronous trigger
on completion, you have to re-try (and maybe get another "in progress"
return).

And as if that weren't bad enough, if this key exchange between card and
host is the first one, card and host has to instanciate a secure
communication channel (including a key exchange for the transport layer).

I agree, this sounds rally bad for real-time tasks. But we're talking
about 2nd-level virtualization (with non-real-time hypervisors below)
and about cases, which can only happen right after a guest relocation to
another machine. Would the current solution be acceptable under these
circumstances?

> This all sounds like a horrible hack one way or the other.

Ähh, yes... :)

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

