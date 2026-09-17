Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37674A204D;
	Thu, 17 Sep 2026 09:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636396; cv=none; b=ZI+onVtlRfaVorKKxOYamjXYdXm6cKE7gX8M/eI7PZr6goc80jADw30gmbW2QQKJlJM2FVASmQzZ/Jxu4M4cCFvUwwapnDpciva9rMD88k6WIgyk0b9OlCKCuyH/v4H02c/N9ICgo4N3lPg+s0hi+WOR9gSs37mgnYa3uwvl3KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636396; c=relaxed/simple;
	bh=6tdv1fQIX48GNjkBOUbNITXfXvuQarY3qABLSJmTviM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JLNaYnWzIVm+3+4neyLJVp888YSc86u23MK/NW3yvGrgA/GDUm++FUNHfJ9jNjVv+6rgxl1pWHu2e6SSzMGtiK2fWYZM0xzE4yzXN+rLqUW3WZndF/s9vD7LeQCS7AMSwFqY5MTB9et1BOnCE3Oc12BmwQeTMlt97sIP72CebXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=K8nr4pLC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="K8nr4pLC"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H61nsI1715746;
	Thu, 17 Sep 2026 09:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OhAZpF
	E45Wv96b50Eo18CRHe6c/DNguzKZ+2qnW74jU=; b=K8nr4pLCwrlwFOQyWa2u+8
	sQv1FPuUWPa2041ETdIqwyLzDzfJiQmoof+yT4dkRhAYgm8rNygYGI5uLPfBMgVJ
	izsBsaTXz8sgSlFQo1JudlpIu2RB6L+0Uqq0F6WDXRPHQNiNUxJgvkXN86zh0odI
	10BuSIHUcdplrrTE5dAXFh2R8/aGwE/+SdgiISDPzGFVA5ySYBAN4bWdWqsUK2WX
	LFut74BzWAEavfHr+ZivXDCuCEVUwHnXOgHMOPWLSZ+sEHww2fUJdPiS+bTKWvjc
	RgRC3kp/iRm87IjFGNa8YoGlYvUcxLWQ4Fgh7+WipEYXOzYrZWV2HYK8eNZ+mVRg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf59f2n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 09:13:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68H65AKd3619060;
	Thu, 17 Sep 2026 09:13:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gr7geh8qq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 09:13:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68H9D66J46530838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Sep 2026 09:13:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CB5C20043;
	Thu, 17 Sep 2026 09:13:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE73A20040;
	Thu, 17 Sep 2026 09:13:05 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 17 Sep 2026 09:13:05 +0000 (GMT)
Message-ID: <5e9a75a1-54f4-4425-806d-55d27569602e@linux.ibm.com>
Date: Thu, 17 Sep 2026 11:13:05 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/1] s390/crypto: Generate iintermediate chaining value
 on export
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik
 <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>, linux-s390@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        ifranzki@linux.ibm.com
References: <20260814142010.259918-1-dengler@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260814142010.259918-1-dengler@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: imIkWFLBH_6-GOziPcWTl2VVFtWQ1cbO
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDEyMyBTYWx0ZWRfX3fl1BaZZc8P8
 5+e2PMhEjJ0f+UYgVCVsOTV9/nI8hAqlBxHBrHf2d4Qr5vR1ouBKiaZCnAFLqJLxP2PFeA20zl0
 DyjyfKUUwc8J0DP5M6IyToVIlHQkiD0=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aabaf26 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=6B41mUtho_lo4dOVP3MA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: imIkWFLBH_6-GOziPcWTl2VVFtWQ1cbO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDEyMyBTYWx0ZWRfX4H7Fus3ZnfQe
 uPJN6/rp8IPC6+nacjg6Ks4GGgi/W4aGDZQkjSlgZn0dmnw9DLABLjAX8N9DY1CHZk4N99XdaGl
 yknjAFN2QrMuaPAS5YtJHSnQMAtzuq8ZQb+1XWtw13B9V/ErQWPcnsUZibOJQg/BgUecz+EwtiQ
 c4ii3qe08OUFyufn1ga3rG0+11Zmu1f6vCb85vK4cjuetmLzJhPWbVSSFrOSixxzPbl+Y189TQi
 D50TiujwzHUMDMzSg55gRriXKLhvG1oq8Vg6G8OIDNwhJins0fnPgmo7lYILgJcbl9h8TB9R8Z3
 lfm4tesv+2Ggzn+f/6WByIY69TNeu5/rrDzOvcTMWYTHfGXMWM2KahPafp0+VyKs99VZ0mBii+b
 50lC3qDyPpWdVLD52OT53OwhQ0GzbrmzSC0KvDtTlRbkYj5auVMnQGMebIO8YSMaaz/KZ7d1EB8
 2EpxFiQiBHhQzCC70Fg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170123

Can someone please pick this series? Either via crypto or s390
maintainers. Thx.
-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

