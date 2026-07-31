Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F56544C641;
	Fri, 31 Jul 2026 18:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785522720; cv=none; b=Rck+IC9OWBFqDozK1hNNItIrX6Csp7GTcEns0yXTWHDDqCLbp7FQ/pPmP8OqztwMti5g0qsuMcvY4yTQRwJQZ9pcXtLGldpd0yIf8gaYkWUwAVGJzMzpPFh5cA3JOH9j96FGr46bRSxjDrdDCV1rYZq/At78pImJfoyS4K8+6Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785522720; c=relaxed/simple;
	bh=8t6FGRmqZ3w/otFpd6LcXsk/5g3F9di4dDavEUSQGJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qn78mEyCl6K4xxj+1gOJgQhWlt9EAVH3Lx4zzlDZs++aayyTAr0K70VJ2i9441Mgu2vMPuyq9IoGfdiKn+NY2WJXKx0hsi0oJvGhuRElGpCV/v+ZxNjJ4nR0dnDPZwLuAIUt64XSqqE5Rk4H9osYcob3aDyTH9HPpMOELRXWcm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WrlSsg2D; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WrlSsg2D"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFlWdf402301;
	Fri, 31 Jul 2026 18:31:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=N8atrp
	DnKaW3CfL8zzEr1ep4hhFrwON0IQJE41M0dVM=; b=WrlSsg2DJ53awHcSAZoNEe
	Tee2kNNX390OpoHNhF71ilcxuA3O7/ENgmhBTrw09JewVsdegduAzsTkT1dgtZYQ
	avb4VjRfDStZvEEtZCmbj1Onziz9W1wmoBGZJVPWC7qNMeKpYj2RTcOOLJ53Q5Qp
	wFyswfZiEv/h9+uNIfS0EqX+VDSIpV+8rGMvXvljvG1tz0BaBs98OCuyjMZzqliE
	PavuoPCqWN4H/PgliHNCkPurnnBf2/48kE8nadqvPo9u/DBgGw224Bk2TaFfAmd4
	yCP4d7R+ym98g7+cCrNHcEiJGG89g5YV5BNfPkbcrNE9nTjoTpVXiqgfpHFaLztA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuycxffy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 18:31:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VIQE9B000694;
	Fri, 31 Jul 2026 18:31:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5ygvve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 18:31:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VIVfJH15335832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 18:31:41 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24B7220040;
	Fri, 31 Jul 2026 18:31:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BFFD20043;
	Fri, 31 Jul 2026 18:31:40 +0000 (GMT)
Received: from [9.111.59.130] (unknown [9.111.59.130])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jul 2026 18:31:40 +0000 (GMT)
Message-ID: <be21ec15-c4f2-4aee-9e8a-99ac08e8d94d@linux.ibm.com>
Date: Fri, 31 Jul 2026 20:31:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] s390/crypto: Replace cond_resched() with msleep(1)
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260731165004.2758105-1-hca@linux.ibm.com>
 <20260731165004.2758105-2-hca@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260731165004.2758105-2-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qmNpm7Yff2khN1KKGzLtRSER5HcD9M5E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE0MCBTYWx0ZWRfX01MnrqXmJddI
 rMvHvL2y48s0QW/B8+jqw1qdXr6pkLj+IMXoHjoXQJ8fNXprmytDOYVPIzfgtnyQpdehq22G5xH
 ocX43oA/wHuW4Ku7V0HL464w9C9k1PlT0CIaa2aaQTa9Wf9bi5Q9bU6HgBxukLoLWgpgMSWtChB
 hynUACoX1rdbc4bR1YNESyWcTtqrGgCekPqnQwQbCkxZo4ijAigzgUKlsKov1kdQv+rXTWBn39p
 g15+slC85cTlNQczQmpMrdJjlB98Z2xCYp9/I3t+lSnfa4rEUiovt7jmXzsAC9PYRx/CcKcKGBc
 0xuQN2GvVFa8RvvNcE5W3kvrUnprnNsYDfHX6vwda0+n1v3q3XFC+HQYIm6oiKtsT1JgHRVeFWd
 1l7q9fKSNWk/lLkSVRnhNzA+boLjmi/oLFJB7Zu9usCHHH7/+8F5g5FGZyze4I9uXSDMeEiCB5N
 fJvCxYVXTwWAex76C0Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE0MCBTYWx0ZWRfXxObk9OS7aMNP
 Xoed+hLmYxFQGtdXaGkNTfnq1xtP1oe0cc1qFSvGv091Xa+/Jr4U9Nx1VjkQFNZqMMAfhAfFoZd
 Fsk8AHfGOR5ofUcS0VHdqY0+h0vPfeo=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a6cea12 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=WsHKUha7AAAA:8 a=JfrnYn6hAAAA:8 a=_3GpxjzQIKxmPKiwiJwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=H4LAKuo8djmI0KOkngUh:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: qmNpm7Yff2khN1KKGzLtRSER5HcD9M5E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310140

On 7/31/26 18:50, Heiko Carstens wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> With [1] cond_resched() is always compiled away and becomes a no-op.
> 
> The comments for all cond_resched() calls in crypto code however indicate
> that the current process should be scheduled away to avoid instant
> re-invocation of a callback. This is not what cond_resched() would do or
> did.
> 
> Instead of just removing the cond_resched() calls, replace them with
> msleep() calls, as suggested by Holger Dengler. This forces the current
> task to be scheduled away (sleeps) like originally intended.
> 
> Holger provided information why this intended [2]:
> "
> Let me give a bit of background here: The protected key can only get
> invalid, if the Linux instance (z/VM or KVM guest) is moved to another
> hypervisor on a different machine (aka life guest relocation). In such a
> case, the crypto accelerator card and the host has to exchange the "real
> key", which is wrapped by the host and handed back to the guest as the
> re-newed protected key. Unfortunately there is no asynchronous trigger
> on completion, you have to re-try (and maybe get another "in progress"
> return).
> 
> And as if that weren't bad enough, if this key exchange between card and
> host is the first one, card and host has to instantiate a secure
> communication channel (including a key exchange for the transport layer).
> "
> 
> [1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
> [2] https://lore.kernel.org/all/39570813-27b0-40f9-89c5-8e2dce05e2f0@linux.ibm.com/
> [3] https://lore.kernel.org/all/20260731084027.GE776954@noisy.programming.kicks-ass.net/
> 
> [hca@linux.ibm.com: took Peter's patch [3] and provided commit message]
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

