Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E5E31DD82;
	Mon, 20 Oct 2025 14:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760970249; cv=none; b=HzGYIuJ62ZY8GmYew9/vo8ZA984UJxbizxlp/9xsDh31MLO7IEwXJUVj15gcK+6QBpjpnQstJwvR4WqjY5oHKKmNGPrLJsO9YmAIqXEih1XU/zNDnFjOH71zlFvCOAsjQ95XE90E/orw5bMgMxh6Y5JqQ3FSubdg6TohpcnQVzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760970249; c=relaxed/simple;
	bh=yjaNgHiB686AU9MYY0jxbk2QdLrO/ArFLB4xXQkkrQA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OrHZouJ6z/2Ml92cMzk4PqRczTWulL9xPxSLkIDkGqMNR/19BXvBVg6AWuAnEtX5E0XyNbMiR+KopSqxsMXIpacqYx25XlgGxjSLQcSY516GjuinkMKtu6JM/S2FJHZ90pkEMZd6NGQpD2DIBsFTN/LSQV0xUhUzL4GaBtPcnaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tjXa3BmH; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tjXa3BmH"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KDK4p7017502;
	Mon, 20 Oct 2025 14:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=lu2+e1
	JrNwjm4w5JqiQAtevBk6ezsFtqM0xfwb3L/VY=; b=tjXa3BmHBBoIE+wmqP/MZx
	LYWCrKiMVFehBQDTjQWMNuS3wYuqNokzizPSGYw3TRj1muzGTLlPxbaA9RHhOSwg
	B0yodU5AsLAx2xmGYnZKjDtpZW5f773l5PhGIn/kDfk5rtovnHMMQChwBtlJuRR0
	Omm+lj+Jx4D5LUEq1S3O7iu2V0i83kSiKjvolmx251Yyo2TQJTxw4f5IMcDhlpDV
	L2ShZF41lqkLdAMBHsAERIqf+cJlyg3fTg0I0y1dwycvxXL6K8+al2NaqRKSNo11
	QoireIY8OgmDKg7bnVRVhe9YFNRoaoke4tFfQHQDUnx0PUu3elMlGGRsGLZE6JvA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vgupw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 14:23:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59KBQ5vg024686;
	Mon, 20 Oct 2025 14:23:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vpqjp0p8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 14:23:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59KENsHx27263372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:23:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF9B120043;
	Mon, 20 Oct 2025 14:23:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9458520040;
	Mon, 20 Oct 2025 14:23:54 +0000 (GMT)
Received: from [9.111.135.235] (unknown [9.111.135.235])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Oct 2025 14:23:54 +0000 (GMT)
Message-ID: <48b8205d-96e4-4ed9-b8df-8cbdb305e661@linux.ibm.com>
Date: Mon, 20 Oct 2025 16:23:42 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/17] lib/crypto: s390/sha3: Migrate optimized code into
 library
From: Holger Dengler <dengler@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Ingo Franzki <ifranzki@linux.ibm.com>
References: <20251020005038.661542-1-ebiggers@kernel.org>
 <20251020005038.661542-16-ebiggers@kernel.org>
 <51fc91b6-3a6e-44f7-ae93-aef0bcb48964@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <51fc91b6-3a6e-44f7-ae93-aef0bcb48964@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3gcsP6YNnx9uH9bxnaVlScEk32ZbDY4m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX5GP2ZyrzfV8k
 CD7A+7IogP0brIFtbCSSO7FMMACu7q+fHrAYvWy2QAqSNKdHoZ2gKOcl/r2tY+bcHJth2KGtr3N
 gqNIiVc9NS/fC6lyepXqRWWJ3J8QIUZkQErM0s3ibeJaRp+Y4Ki2slQnRqmThtM7UQSxg4HZZfY
 YV2m/8CULVI1BMFO19KL7wvJbrdQZwdFsmqmjgePCcplzdyAxZx+ocwkeMuic2lLlwgTB63fzyq
 c47U1eHYzGpdrQnz/Vd8vSxfl4wj3OTk61bMnT0PDM8HXzyYn3ogM2JNOCrD/Om3C+oQIR+lydO
 HVVAt1Kqk4Uvb3t3efFLL5ITojLEqz8XOZk7bK6ZsmPlne1MWi0slUSeuJGytRdVw8W0x+Nr4LD
 I3JJJvEJ2e53bRMXKPuCkDxkM6UMHg==
X-Authority-Analysis: v=2.4 cv=MIJtWcZl c=1 sm=1 tr=0 ts=68f645ff cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=a1n8l1vKblwj1NcKW7YA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 3gcsP6YNnx9uH9bxnaVlScEk32ZbDY4m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022

On 20/10/2025 16:00, Holger Dengler wrote:
> On 20/10/2025 02:50, Eric Biggers wrote:
>> Instead of exposing the s390-optimized SHA-3 code via s390-specific
>> crypto_shash algorithms, instead just implement the sha3_absorb_blocks()
>> and sha3_keccakf() library functions.  This is much simpler, it makes
>> the SHA-3 library functions be s390-optimized, and it fixes the
>> longstanding issue where the s390-optimized SHA-3 code was disabled by
>> default.  SHA-3 still remains available through crypto_shash, but
>> individual architectures no longer need to handle it.
>>
>> Note that the existing code used both CPACF_KIMD_SHA3_224 and
>> CPACF_KIMD_SHA3_256 after checking for just CPACF_KIMD_SHA3_256, and
>> similarly for 384 and 512.  I've preserved that behavior.
>>
>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> The current code also cover a performance feature, which allows (on supported hardware, e.g. z17) to skip the ICV initialization. The support has been introduced with 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements"). Unfortunately, this patch removes this support. Was this intended?
> 
> The get this feature back, we need to hook also into the init() function, set the according bit for the first message block and skip the initialization of the ICV.

And it would - performance wise - make some sense on s390 to replace also the sha3_xxx() functions. The init()/update()/final() sequence is not necessary on s390, as it can all be processed by one single KLMD instruction call.

> 
> Please also add me and Harald Freudenberger to the cc: list for this patch.
> 

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

