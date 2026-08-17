Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871113E5EC0;
	Mon, 17 Aug 2026 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978638; cv=none; b=KjDcgKe83gmvJQvgnlgBfxngJL7vyazgb1v3ku6hLMnQwdaFNZQ0Y9XKtsaACU9IKHaibqG+rmoCVzjSUPoDgEcrc4eIL5nkAdHZoT1im/Ge0wAAOb1fcpi50LqDgv2xMLVZa2wltWLvrjH0r8EAeH74QHJuhbuQ5YI8STGgJX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978638; c=relaxed/simple;
	bh=znK68SDJZgfYPhR7uAmine/HghtFy5tW+8jG2MBVd58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1k4OphtMr/1LmtYbSz+D01JyKvixL7HmVxt5T/nloKzXq7IAd+y6cPDfH0q6uUhuonRmM5mW2M/CfXurXqQYv5jKrA+FxvjYr/8eDYP+7bTRAbM/ciNhwZJyhATtb1ni+iFLoYjk2YuHeGRzOXMhh+KOrzeF0e57WGxN2Va5Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pijtbB4Q; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pijtbB4Q"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HCVk4T1392442;
	Mon, 17 Aug 2026 14:57:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=jEMTsvH98q2W5YIHQ3lPiq2fp615gE
	w57KJc6+8OtGc=; b=pijtbB4Qyb/VJQD+b+RAmGqkw6G7dv8Q+UvmWMcxX52ZXs
	WEfZSR59cPWshXzESxG2rsezHiG0FMQ9BuzExLTd2riKOCiIxRGqT/YjW00yXs3x
	Y+V20Z4PESjm/rIzc0diVtmUbu21QOcNJljjU4kK/ayJIOUZyRgPt877bxkxBPgJ
	P0kRVoGPoNNXp3HkbCgSIK2mI437/N1mJ0UsQen3jTsEsUR7wAQf0pC5jHRjkS6o
	pFRAKGWF+6QiwujisXsH4S9nH9zWXtgm+UVUQdcnkP8Q2GcmCdqFI+DxBl9bDb+Z
	6TPRcne+0Vhy48Ua0oxTmGKzj6rkYCceA6UWIloA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fu4jva7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:57:15 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HEuXuQ019598;
	Mon, 17 Aug 2026 14:57:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g32tvxjvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:57:14 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HEvAB815073700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 14:57:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08AF720049;
	Mon, 17 Aug 2026 14:57:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A25D32004B;
	Mon, 17 Aug 2026 14:57:09 +0000 (GMT)
Received: from localhost (unknown [9.111.2.7])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 17 Aug 2026 14:57:09 +0000 (GMT)
Date: Mon, 17 Aug 2026 16:57:08 +0200
From: Vasily Gorbik <gor@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] s390/crypto: Enable CONTEXT_ANALYSIS
Message-ID: <ttjx5j8@ub.hpns>
References: <20260804113736.1423667-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260804113736.1423667-1-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YYMMs9CMSzOMlaXirO45jciVKor9IPn1
X-Authority-Analysis: v=2.4 cv=NLLlPU6g c=1 sm=1 tr=0 ts=6a83214b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=gP54STInbiGPwzblvxgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDExMSBTYWx0ZWRfXyr2RFM0acYaM
 SU2PYU0bIwJSJrX0UhDh6OlY7gVTP42ridpNfaEKvgINaLBM2XgPdRtgt8Io5uS/il8PiKQfsTS
 z07wNX/cyUhe4me2L5P3iDogTWuydRU=
X-Proofpoint-ORIG-GUID: YYMMs9CMSzOMlaXirO45jciVKor9IPn1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDExMSBTYWx0ZWRfX8CA47h5m0uga
 F6YV+eO07uiyfAW+HImkj+ALcWsQHoKRBSA6AffUhH0alLZ+t7SdtYBap/zfrG04alu6AM4hgxh
 u67UHuZwGlN1lmH1qFu/4dc+1Vr5+Gnqv6P/PM2them/yDCO98TIv2PG3yqmZPc9N9Up6qgExar
 /5rcKt2abLKDWCx8ObmAJJ2w0G70G6SdhexvR9ZWsT5iEuUMmmkEpN0kXsLd1IMKFBibi+0HS6p
 TLCJC46BQuKDiTyH5JG/pzxr1APhyHVfaF+Hr5vfUZTWO403YXIYQRXuanWPtyEDYUeQVnWF9mo
 ARhbi8dpzJWKmliXHotEHhVA3X4+NkXlT1sR8YgFIIMsu1Zw+iircQyF4WCt6fS85Dhf32kgBXj
 He1WEyiRqvb0JG+D8zgam9cN+Pn8LFYyss/QQxOTEXAuoDaVEFQMKdcwx4lBx4teGwTQo39zEcx
 xnVtrM+u6X7xd6MSCYQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170111

On Tue, Aug 04, 2026 at 01:37:33PM +0200, Heiko Carstens wrote:
> Enable CONTEXT_ANALYSYS for s390's crypto code.
> 
> Static code checking for acquiring and releasing locks used to be done
> with sparse. That was removed with [1] and replaced with a clang based
> approach [2]. The new approach requires that each subsystem needs to be
> explicitly enabled for checking.
> 
> Do that for s390's crypto code. In order to avoid false positives the
> code has to be slightly reworked, since conditionally acquiring and
> releasing locks does not work with the checker (besides that this is
> sub optimal coding style).
> 
> [1] 5b63d0ae94cc ("compiler-context-analysis: Remove Sparse support")
> [2] 3269701cb256 ("compiler-context-analysis: Add infrastructure for Context Analysis with Clang")
> 
> Note:
> 
> - "Pre-existing issues" reported by AI will not be addressed in the
>   context of this series
> 
> Heiko Carstens (3):
>   s390/crypto: Rework ctr_aes_crypt() to remove conditional locking
>   s390/crypto: Rework ctr_paes_do_crypt() to remove conditional locking
>   s390/crypto: Enable CONTEXT_ANALYSIS
> 
>  arch/s390/crypto/Makefile    |   2 +
>  arch/s390/crypto/aes_s390.c  |  54 +++++++++++-------
>  arch/s390/crypto/paes_s390.c | 104 ++++++++++++++++++++---------------
>  3 files changed, 97 insertions(+), 63 deletions(-)

Applied, thank you!
