Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0262A28312E;
	Wed, 18 Jun 2025 09:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750238601; cv=none; b=pSDJkeEIJ5zxK+AnBBffw9ei715ddo/bTAHVlZsjntSRkjBvqqsLgx1JkjUxWnWrKOoLLtX52wNf4ikBP/4umdwoo1JGLVWUeP0b4qgRsELA9CYg9RIR/aK6M+hUO2WEVHATxHIgnzr51+0tPO8TNw9opeRs83FhdArKTlT1znM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750238601; c=relaxed/simple;
	bh=JavD1KzpGHieQU66YpbMJu/ampn960qv9QqB+bSKf1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H0/YEKoN7p5zq+G+tX+xCwh82I68wmNuFQjPM68Q5uN3LQkE1MdfE0MZ3eSxHUyPvq4LfaLcn431W65DFfVIF72Cz/bjW4mfHu9gAur+WWFc4YGLl5P0HukAVo4VGz3yW6u9U47iOExc2qoZSuE0JZ4K9Zozwz4L4SbByEj+Mhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c4EIFk93; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c4EIFk93"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I2cSai024164;
	Wed, 18 Jun 2025 09:23:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XRtOmZ
	WY1jg65w996itKDswtFk3UIO4w+fkn/1GKpR0=; b=c4EIFk932jvqFn1+8+eou+
	8GVAsPJqgWqz8cnqKlEdthtJ1LPLol0v9xq1Sz39y+r6xRgAzZE15Iy3MC4OVqvE
	20cLUb6o7bC0BS6eInpezBI1d9/0w09ynUB1ybIF1f+sHVUfpOz01n3a7QhFpO2W
	K6N71kk9+mMSSoxx3MBn1OWSob80yaW+CAXFf+1MuJ06XU/H+BruUKGosNVhOxO9
	6xYIn9zV4eDaHkq4XoG8kAgO0pnWtc9ZhiLae3nrN36Eo5vAHxU8u8DibAMsWGPi
	Vk8wEj4ztG7D5g6zaDBjtJmnk7td90Z2XMnUyPv1VuIFgy40YdUioIAHAqe2FC/w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 478ygndkb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 09:23:15 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55I8DZtH000863;
	Wed, 18 Jun 2025 09:23:15 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 479mdp872h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 09:23:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55I9NBNc56426962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 09:23:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 749E720049;
	Wed, 18 Jun 2025 09:23:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 177FC20040;
	Wed, 18 Jun 2025 09:23:11 +0000 (GMT)
Received: from [9.111.39.61] (unknown [9.111.39.61])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Jun 2025 09:23:11 +0000 (GMT)
Message-ID: <9c8ad07a-108e-416f-852a-f516c81537d5@linux.ibm.com>
Date: Wed, 18 Jun 2025 11:23:10 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 4/6] crypto: api - Add crypto_ahash_tested() helper
 function
To: Harald Freudenberger <freude@linux.ibm.com>, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        ifranzki@linux.ibm.com, fcallies@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com
References: <20250617134440.48000-1-freude@linux.ibm.com>
 <20250617134440.48000-5-freude@linux.ibm.com>
Content-Language: de-DE
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250617134440.48000-5-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA4MCBTYWx0ZWRfX5dSACOVQA/hg K2eV65SMxx8+BF6RIszp9fWDZ4SWh4vk+YABoTGM1ng4I0ZlsBFkLfQ6bo6G0p2JbjeL0vxBM0R w9uspgFImtc/pdJE/iQR4OiSu8iSkFs/roYR/KQHwRStQ01vKpGkwWPhkFEt57/cp4xQQyhxami
 MUt7LbJ9RQSuybUbBYDK8JdtA1PNPITAE0iHRdIOH+my2CHLJ+AIOjj2Eiqgv7jnYUv8BQ7DoPj JOebk5CwBdw3GIaiELZlh+rsNMRwbQBTPCD0LX8Tmw2rPzT8mMefNM+SIO8OuRljkqdx3unkj9A /R/iBmdTuqqbzv0gp/+hVhykFNpVAgryg0KiTs4e6D6xoyYEe6Oe4qTNkg4yUxNvuFlNd2lootS
 +V22bYImOk/DesRQYq48fXlTrN8jvFmkhrSasRAppwRdxGl2e8K53UXaA1/YnQgMUddgHtpe
X-Authority-Analysis: v=2.4 cv=fYSty1QF c=1 sm=1 tr=0 ts=68528583 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=FNyBlpCuAAAA:8 a=w4HzK-rsqA_2YikTyBoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-ORIG-GUID: iPhqi7HLg8qOp1Ts4bMNffbHRZBx8UOX
X-Proofpoint-GUID: iPhqi7HLg8qOp1Ts4bMNffbHRZBx8UOX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_03,2025-06-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=616 lowpriorityscore=0 adultscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506180080

On 17/06/2025 15:44, Harald Freudenberger wrote:
> Add a little inline helper function
>     crypto_ahash_tested()
> to the internal/hash.h header file to retrieve the tested
> status (that is the CRYPTO_ALG_TESTED bit in the cra_flags).
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>

Please change the ordering. Suggested-by: first, Signed-off-by: second.

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

