Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60E227E07E;
	Thu, 30 Jul 2026 07:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397673; cv=none; b=KDxFr/JJnXheQ1ZV7YSGTlhpdgdnEIf8TID6h1TTOlOszJg3kHWz5ntsCSt08P28OyoMqcmd8WO6pR1aQoxy1TnQRl7ssJMvgK/TQgRxDVfqNKcfHwLzDla0uO8JUAvD5PKAYRkB3rw0KpZUpVsLkxDrYV3O4fnDHYhw35vKYWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397673; c=relaxed/simple;
	bh=7eNGpkG3x+WLpBqMYwOCFW9vENEisQvBVUZJSO/cP34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GWi1E0yn/TaXQGuD7YzlZzF6ZmObdagf3k648eWmncVKJ0Kvt7eHHC3Izx2lDdx8tmdm9d4gSn6ZOQ+mrrrQ4rk1YAqTyog+qjZhEtUVLteDr4bIPu5j9FTCoEaMkGP3CJyP5PPNSmYCRo9Wpg/YDcJPXOU895hYt1dlxI5mnDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=esRuQKIb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="esRuQKIb"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6lgrd2300625;
	Thu, 30 Jul 2026 07:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IuYvL4
	4OEHlrqrUDgeIkze2oMAhjd/UFCPUoXSXC3jM=; b=esRuQKIbIoOBW0OGQwiv6I
	booAbcYMK38UW06y8dWUFQ6kj18C+HVZfeyOKl37TMsR2n+kyNaZRT0+zAbBWFRj
	cTmNySM2fsLp6He0JPFbhUVe5vBROWSBeJ6j8PH5aBZPwWOeZQTaguzsyT2xxCvY
	yyATeS7+QCvnEjVPHUCLsaDDFU2X84I1JzIr9WONa7EHoMAVVjlzRAfVthi5HtOo
	4jZUDYrGdAK5FwskcUwdnVRAeVtJePJ/AEaR4ejggAWSXT0S46mSrbOT3dg7Zdox
	un9Y/cRx0wSV2v0S5aJ/ZJp6totvyuc16BGk5Q1wpzALI7lR4szcNxqegYuspTMQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0xxnns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 07:47:41 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U7fGq4012872;
	Thu, 30 Jul 2026 07:47:40 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn9pgj5wj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 07:47:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U7lYTt26935776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 07:47:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD5972004D;
	Thu, 30 Jul 2026 07:47:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6604520040;
	Thu, 30 Jul 2026 07:47:31 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 07:47:31 +0000 (GMT)
Message-ID: <d2a02f29-4ffb-4364-9eaf-aba1e74114ba@linux.ibm.com>
Date: Thu, 30 Jul 2026 09:47:31 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] s390/crypto: Replace cond_resched() with msleep(1)
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
References: <20260730052907.2607026-1-hca@linux.ibm.com>
 <20260730052907.2607026-2-hca@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260730052907.2607026-2-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XWUETPjGWHhdWS6AdEQuhPAIzirnb-Th
X-Proofpoint-ORIG-GUID: XWUETPjGWHhdWS6AdEQuhPAIzirnb-Th
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA1NSBTYWx0ZWRfXwd9D0O7Ur6ix
 lO7hhI2MQ40ThZdjkD1GQOLtH4kUAo8Uf2QVyX8bpmgec+p90uMXKX+WEZTepisu3u0RXwXfmUD
 qsUaKbLp0+77fvkTwpQAUBN2x8446BI=
X-Authority-Analysis: v=2.4 cv=dYuwG3Xe c=1 sm=1 tr=0 ts=6a6b019d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=yrk_x9XpjdM9187dwwsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA1NSBTYWx0ZWRfX9FijXlw18+Ri
 Zw3Sz8gSga1BreKzut55pm7VmP/iztR7mzJFIidtWgqvziKKy4Bi94Ko5z6Mu/IuvULAHINKCNG
 L6sXf6bm7MMCUt1Jb4KGZBfXiSZQ6zQKJZq8biIRn/I/6wF/IP5iD8QAXBofmZr1LA3Z24pdKwU
 1qsrZSMc5/tM1/Qo67hcyrXtJ8fQBrMnMwLADgn7A2eGyboi/fbjrDWtK8RTLUbOe3qqslMkNHn
 ywmF3jvw56rB87EDmawOFPe7el3XM0OU2Xyt67akYBBQimIsQsF7Vl2VidbCsFZubXxKEu/2ZIV
 SlEwP4oqKCo00lnvknCGYcDR0a66DzEBkma37urrL2J5iQTTJBdfCQId+26KXQyOJyIYBwixxYZ
 lKgLvowhQfn2R+j/h+vvAcvUViFwhJvrDLcFYvbtoZN1Z2RH5otLwqujR3CV8mbvM5zBm/gqp1v
 qtrT969eGrnyo5aURwg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 phishscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300055

On 7/30/26 07:29, Heiko Carstens wrote:
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

As in v2
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

