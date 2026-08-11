Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E175386C17;
	Tue, 11 Aug 2026 07:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786431621; cv=none; b=hzftMLZwbTeVaNLMhGG1Ds+Hjdq7sQWLBtYmJ34MOx/R4jX4FT3wEP0hSfzk7YGPtGou/SkRyNh1vUoKL0l3JM+i9D6R4RnGJkZraqye8ZG4edACY8/76v7CwdSQx1b6/14p9mjOzr50GVE9BNjLvcJ7kdrvzyLwE/GmZqpbtEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786431621; c=relaxed/simple;
	bh=6Zbu4v+ABGxBe/LDEpkC9KycDtH3l1+MRKwCAChkEzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PoGI2yxKfGGRlB8K6UOH2qIUFQQRqVNf+hclwxx/1ADkzPhlwojna+xrjDQOLhKh+80TlBFh9lXLL9r9jrCAbXSBijsblA9XXrz/w7Up1Oxz56i2pMSEUjasUmT2mGHMixaDGV9iMLpQEZfH5HXXcAV4AXu4elYjo5e7lCJ49HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tLmu2R65; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tLmu2R65"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AN22Lx1869619;
	Tue, 11 Aug 2026 07:00:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TOGbeK
	M7j578WnDKHb01LcDaoxlZRVU/8pjDp8kmGWk=; b=tLmu2R65Qt/lu7vVjNgXpM
	v16akBH5GyjBHtALvLJvgGpV0WjOG8604VLGTwCAnhda+Vvl+D4GvjECDVfTy3Df
	EJxw9dlevbTXf3cwdp535B+vM9chOSRA5yKT5l3iBBM0YMiP9DBe+o9PtOAUCq3w
	KxIZG8FGe0cU4vjsByHdWkbhQUFMuLoiLk9egPTqqPBEwk5jyBOEYBFe4G9Q0uXL
	ELES2/XXdkKbc21GQ2NmIyTqc3OfJF4Snjc/dbUvLtLxStHPPhSPXAjibN2UxT72
	ItrzFWObkTgc6jtIeYyFhE2iFbNt1Cqrcweb7MG4512zHLywCyda9Xzh1HviHRRg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fyb23mfys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 07:00:06 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67B6uOYg012982;
	Tue, 11 Aug 2026 07:00:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxfsjqxg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 07:00:05 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67B7015A48234926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Aug 2026 07:00:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D89F82004B;
	Tue, 11 Aug 2026 07:00:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A729A20049;
	Tue, 11 Aug 2026 07:00:01 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Aug 2026 07:00:01 +0000 (GMT)
Message-ID: <92bfdf5b-2fbc-4ffd-9f12-982cb8ab12ea@linux.ibm.com>
Date: Tue, 11 Aug 2026 09:00:01 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] s390/crypto: Fix return code handling at
 skcipher_walk_done in PAES algorithms
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260805155458.14925-1-freude@linux.ibm.com>
 <20260805155458.14925-2-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260805155458.14925-2-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XqfK/1F9 c=1 sm=1 tr=0 ts=6a7ac876 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=mGMtxAEF_H-nh_TH674A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA1MyBTYWx0ZWRfXyP24/p/1MLmi
 gCOwbrmVu3v8VTrP1Ag2S00usRUufNX8nPfH0dNXSnuNDz/YsfNNzqzbYAou7ouUDfgJ9g/zjT3
 MMLsh7IAxdp6n9SurMhHy/Q7jKX8kQKs2yQbS2rdiMeRtZUb7aLTIrIwcCiWzLI45es80jP9fiP
 wah4wkSf8rw5+nGeZF1/Ohev1Pl86ikRQXBa0aUCJjjSYmuirNax5hmj5SoNbDSi8c53jL+tx9u
 Z7mxj07YnNIeeHsmm+WWedcqwv/fs4DZaeUjSo3jUfEajvOu8XDpfkdteyT1XddDE0+49CTTRjj
 BIyaZI6mkvLrfIdlVqocEHasghb8t26vzC1u56ZeXkISAY7Yqx7hWO6nkrUMIn2XrvcP3z7E90G
 VSs1gYfSor4YMesfB3/dkbqbUdaNuW8W2PEN8IQ1TpT+RjuIiwys+UfApG6ZVFbKxcebh1Vz+mV
 OYSq7+cY0NWbOJYtgRw==
X-Proofpoint-ORIG-GUID: yxW-ZP2Hv20lGRho1DYHubYwJBhPPg5R
X-Proofpoint-GUID: yxW-ZP2Hv20lGRho1DYHubYwJBhPPg5R
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA1MyBTYWx0ZWRfX8e0LLcyHJE+u
 BfypU9V+7zK936v3NKP8kc62atfbd6o4zxE0DcxYUHLxjRFYW3iXffCStnn//HgpJLkqc/h4Jbe
 WpHrGLfK1fS0ZxTFHV9AF+QRjiY7QGA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608110053

On 8/5/26 17:54, Harald Freudenberger wrote:
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

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

