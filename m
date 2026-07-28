Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653B33438B9;
	Tue, 28 Jul 2026 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785255144; cv=none; b=PQD7gK9lrOYwRqwDp7nRSj6SWh8obisECM3fkO9bRm5EzF8Ebse2nK64so6jmnAek/f2KWKi5x2B4t1/BNXlzp7+aDt/oPdNXPQEyJIil96nAlYjqADEXOd8jgDH+4B4hMZ4hLIs8UY8ETzQuk64z1ZK4x29AkTNrhX5m4pu/io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785255144; c=relaxed/simple;
	bh=XG1U7CefyIGIviYwTaLoipLZ0VFGwwdpgqN1nj7Ty/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SkUQZL0Plnq/1DvxRX77tOmkWgBTGYGmODMk7dyxLBFPSKTH4hlah8cpPpmIxEkmoPX+i4bQvt4lb3NSNbzNGWtRfc6kzqrbZNqjuN5W85oKnEND9y5mlTdu/Cg/ZkyYbtyXEqMrlMKqYiwKQxCEtJ6RTiNhg3+cwinhRXZe4iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FglhDOwO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FglhDOwO"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SEllnS1381329;
	Tue, 28 Jul 2026 16:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4EbVF+
	YUdfdLARgtVI4SK53B3X6l4dcyHdp+OMuXJTI=; b=FglhDOwOe/JIxjbdlOrFTy
	4qVJqC1uYjPOmcoeih1BUrwBNVcEOE19lvxAsU2DaV6koLBUDj2GT975+WquHgvt
	OuIhnSrOj7DcHkHiZz2pRbl/FuHcynL6lP9cVI44+iD2SVJwLCuSYf30+e8n3kNx
	d79A4ipv+zZ6VAsfiEO0IquvrGr7YSPPBtn2dZocuR7iwMrpepVS+q9jAtUett82
	eqywHJXhdsi+679bPpPY8J02tQajAC2hk/h3RLQjf97ZAeAjsjepTWEMYGQ1R32s
	9zVIiTxmyEqslhk00qgMExEPSEaJMGv0bTpaf46Adh4WBN0e/P1LZoSpSjuCsC2A
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0nnm0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 16:12:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66SGBHYf006595;
	Tue, 28 Jul 2026 16:12:13 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhameg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 16:12:13 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66SGC9fZ25690402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 16:12:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6892120040;
	Tue, 28 Jul 2026 16:12:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D890220043;
	Tue, 28 Jul 2026 16:12:08 +0000 (GMT)
Received: from [9.111.67.171] (unknown [9.111.67.171])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jul 2026 16:12:08 +0000 (GMT)
Message-ID: <691c3b78-ee37-4124-9ccb-596abf40f5ce@linux.ibm.com>
Date: Tue, 28 Jul 2026 18:12:08 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] s390/crypto: Replace cond_resched() with msleep(1)
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
References: <20260728150412.3893933-1-hca@linux.ibm.com>
 <20260728150412.3893933-2-hca@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20260728150412.3893933-2-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDE0MCBTYWx0ZWRfX0j46Vqw6QUY1
 WRn+HL+S7mv6JXyYfFS/EfSrVHIw55VaO7YSnZVJIXJqoSmTwenBPdA6uP2b8Jm64aG2IBC4jQF
 nIiRguDSPCPmvJgrH83DgL3U7UCC+Kk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDE0MCBTYWx0ZWRfX68VADulM7ml+
 W0T0vh7Xdx27joXuPA1mXIdkq3Ciger2r7aUaV/lkv9/jH74s1uthuyzUsDkm2ciALoWcYlWElP
 C4vvqYfYL/V+rhsZbsGsjBqj49RNu/eb5wAX97gU9ZbG4RQXObtmNwpSIKIfC4dSFQPNDAoENDQ
 Irm41x0/0UPUvB45wJG3aKSJCcZNqgPWq1L+0E2z2ubAC67V5q2iheUyVT42j3OvqVwNDKUn0wN
 Sdjzn9iZDJQcEb5d4fRntWVd5UBpTrxHXLLBK4o2BtFbSchZJvDzRm5DtV1htVCuZk++vjBNhxT
 g+Thw5nJ68yaoRsGIk3VU6cVTTgRG32NENqxOWZzMh9YlNbQhSWU2hIx1X2t7cigPlji7EeQwaU
 oBke3m2MOLxf2QXupGm98qrl22F0o22nyGFre36yFCkULukYMJ81yodzZh/KCdrgluu7PKcOI2T
 /pRTvTyXxJmfBoK2RZQ==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a68d4de cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=mjqf8U9hpmOmLIFZwjAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: H3WiW01kjuMeBsGwoNNQsoO_t9TJOCAJ
X-Proofpoint-ORIG-GUID: H3WiW01kjuMeBsGwoNNQsoO_t9TJOCAJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280140

On 7/28/26 17:04, Heiko Carstens wrote:
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
> [1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

