Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA44377A80;
	Thu,  6 Aug 2026 04:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785991844; cv=none; b=blq8Yi2Lb78WqaVbV2EezSSRWMP7uog4A8CGCFEEfzIrzIrUVBzO0xfAlIYSlz9u6PmPOZG8wan99jnY2WiVkZ/a5Eka5cZDBHTxcWp3qByXprASTXtm5iFTJU4smc3atiMCA+l+3P6cQVYHzRJLuiUgZFsPLNfTeR1PcKLLJmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785991844; c=relaxed/simple;
	bh=CVrrbRDp9btK0z6Gh4upLgpFo6JcZIbyZBwWG8gqRL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OsGlSl3fmiba0sULpVcZYQZWumPiZSfPiZMomELYO6BYb+TL9EEixbYm8OUD4YNaSS4SPa3CU7ZZo28WfXSIX8I2ZWAYurGj0ooUSK/szFfona0JdLZNDDXNCICYJ7UfiUCLfV5YRjUQ0u0yYtRd7KiRsAQaJTKr6sYVC5gSrVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VBC62gVV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VBC62gVV"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675Nlndx1143329;
	Thu, 6 Aug 2026 04:50:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HgQiFH
	7oItMtch1gvDVDF9lpdcNiy/dYeqSypPr6SDU=; b=VBC62gVVYLJiUm6ULxddDM
	U9f1iDxwJseFlpq99uoLiHWzEwFvXs95aA+3jlMd8M+PfoeIfk0nBNbeM3/1HDdw
	J7wHZFaB0lk4hGTbts071hvko17rlPhvHkSUoWSzz5qfJL6H70orkSY5KAICKwFW
	FsxSZd5hPVBe5C6OYzrigfGTkq75+24bdDt5n11d8fZh+lTN5lxKCN8rpxbueNry
	q9Lh+OLOiIC6qKJAwkg3VMRSw5W9sbtQ9Nze9ZRMxmk0peYDA8voTJqberX/Yddt
	Dnhe+ecKzIdgySu/R7fZ9OTorbgpURylWIeP0hVIpw3jM57SMacs1OaohAQx6IrA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8euwt3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 04:50:41 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6764fGg5013050;
	Thu, 6 Aug 2026 04:50:40 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4k9p6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 04:50:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6764oai840501552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 04:50:36 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 036962004D;
	Thu,  6 Aug 2026 04:50:36 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D23E320043;
	Thu,  6 Aug 2026 04:50:35 +0000 (GMT)
Received: from [9.224.87.205] (unknown [9.224.87.205])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 04:50:35 +0000 (GMT)
Message-ID: <55386814-ffb8-4410-aafe-2a1d244809f6@linux.ibm.com>
Date: Thu, 6 Aug 2026 06:50:35 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] s390/crypto: Fix return code handling at
 skcipher_walk_done in PAES algorithms
To: Harald Freudenberger <freude@linux.ibm.com>, dengler@linux.ibm.com,
        ifranzki@linux.ibm.com
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260805155458.14925-1-freude@linux.ibm.com>
 <20260805155458.14925-2-freude@linux.ibm.com>
Content-Language: en-GB
From: Finn Callies <fcallies@linux.ibm.com>
In-Reply-To: <20260805155458.14925-2-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D_ccCrzrv5CfTU95b5-R19W2sh2HHcP6
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDAzMyBTYWx0ZWRfXywX5f3SIzg/B
 aDfqVKrdB0kyFN3voWKcPPDlSqqo3CSZBwks+9bXYpfyV1btNUWxt40WMBIJ//eWCjAIUsSUjPa
 ybKP8bv5cDnWM9cCBP32SFAmXvNnSDg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDAzMyBTYWx0ZWRfXz/h61kDCEjpP
 AZ2odFY9ChBFdBdvLA/Q1WrDLdMuvPtig36FlJPlQQ5qhT4bhuG2BnCcH5h9bfE6OUyUrGyvNMX
 6jh1q3vIrFw2EcJjZfWxJwjUJcOvUVJVi7txfQlZTg0+Qjh2vaoD40LZPicFwFqczdjx47Voufs
 T39KFBahLYOEeBavQgztO8GR/9wb5OOCRhdhbO0VPXW/amgz7YVOjF8HQ1aUrs6biUXKt9kQjsS
 oWrLyTlmcupXsSTJo7KDahLc6jSz4V+B5gUQbheycslN7Kw9H7Q6+zvTA9M3XcHzNADGORZU7wt
 IsIBtvXcqifwBRBzFgE9xpUkDlIfjk3ZgO7vZBFnTgjwcU+ucrpffPsHOS54hhslW9363WgRMa5
 gCxiLF8lvfrlq9KItCOeezJoo28pmju7eytL8xBPy8ehsaFZDc41d6hK442pUdt4Nx9pZag+w3Z
 VtPSKD2r2ZHLdRtxQJg==
X-Proofpoint-GUID: D_ccCrzrv5CfTU95b5-R19W2sh2HHcP6
X-Authority-Analysis: v=2.4 cv=KfzidwYD c=1 sm=1 tr=0 ts=6a7412a1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=mGMtxAEF_H-nh_TH674A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1011 priorityscore=1501 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060033



On 05.08.26 17:54, Harald Freudenberger wrote:
> All the 4 PAES cipher processing loops were not checking the return
> value of skcipher_walk_done() immediately after calling it. This could
> lead to error masking when both the walk operation failed and a
> subsequent key conversion was needed (k < n condition).
> 
> Add immediate error checks after skcipher_walk_done() in all main
> processing loops (ECB, CBC, CTR, XTS modes) to ensure walk errors are
> properly propagated and not masked by subsequent operations.
> 
> With that comes a slight rework around the skcipher_walk_done()
> invocation. It is now necessary to check if the walk has already been
> finalized (walk->nbytes is then 0) or not to avoid double
> de-allocation of resources held by the walk.
> 
> Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 6.16+
> ---
>   arch/s390/crypto/paes_s390.c | 38 +++++++++++++++++++++++++-----------
>   1 file changed, 27 insertions(+), 11 deletions(-)

[ snip ]

LGTM
Reviewed-by: Finn Callies <fcallies@linux.ibm.com>

