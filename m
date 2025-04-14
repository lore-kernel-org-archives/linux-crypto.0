Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1514B1B21A7;
	Mon, 14 Apr 2025 10:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744625704; cv=none; b=bE7Yv9r43hveKmO9qrnDLwTQ+QRST0eEIv0JLNcUMq18Z9p/07nbbPdCuQAfsZ+qfANN2G0KTpMAU6FdqV+0a+kAdCosQPQCNPrTsUF2h5J6gGY/nFB2ul8GL5hZM+KX1Hftjxj00ourXZSHOLK9E8LYpbUaTjjTfIdkPJWUcd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744625704; c=relaxed/simple;
	bh=6yyQGKU3WOn2H8YygF4qBZnR8Qh04Ax1uE/2gTuO+Jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h2gVqx05kHzCDUtNi2SPxLBDqdSAm2s9bzkHIH5x0UG/XWdGHwB5riFmxP/fq5IaXP32qy2kzyBQQxTM2zz5/iQVNQ7A1wx8buQ8ICNNPgjuZGiv6OViSD8YJTKvZjIp6Thpxbu/9pvPv9yfVNt7Pmq4GpKLkCnJP+V3KxCU07w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XOdYTaal; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XOdYTaal"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53DL3j6g009871;
	Mon, 14 Apr 2025 10:15:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YHSbBm
	gC2vKkt1iW4PLAmpJKdTS9yagU6UjQM4AiLIs=; b=XOdYTaalvi5dGCXjKC1kpN
	KDWcwPXdlRpifnuwWFle6gLAiD2FKHGALVOdh2KK1XP0fonMAkd9cHexDOOLxHYK
	AcEtTK+CaO/11jCtaJKOtDz6BtEnIklIX13cCFONse0jb7ZsEhkx1En9kjpTpB7N
	QizQgWJu7WlFURWuffzn21xdAaNtQgmxTjJS6yEzmCPmPwz34XJNt3hRK1EBf0eS
	iE2SkTXoIuPLYZLWhKrqE3YO91Q/8fyZgbwH0xx1X/O2uLEdDNJ2QOfgfDKmHyiU
	heTLI4MOUNaNqMKVH+edjUAGXZRvB7DR5/wvhV24DBi6Uyq6th+Q9yX1PdE1GPEQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 460muftpga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Apr 2025 10:15:00 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53E7bWiV030910;
	Mon, 14 Apr 2025 10:14:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4603gndr4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Apr 2025 10:14:59 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53EAEttH55116268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Apr 2025 10:14:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA28F20076;
	Mon, 14 Apr 2025 10:14:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 67A7D20075;
	Mon, 14 Apr 2025 10:14:55 +0000 (GMT)
Received: from [9.171.15.155] (unknown [9.171.15.155])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 14 Apr 2025 10:14:55 +0000 (GMT)
Message-ID: <a6207daa-ad95-4cc0-9d9a-204453dc04cf@linux.ibm.com>
Date: Mon, 14 Apr 2025 12:14:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] s390/cpacf: Rework cpacf_pcc() to return condition
 code
To: Harald Freudenberger <freude@linux.ibm.com>, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com, fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
References: <20250401145048.52564-1-freude@linux.ibm.com>
 <20250401145048.52564-2-freude@linux.ibm.com>
Content-Language: en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250401145048.52564-2-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VTFFitV_minUbHGX1H65pL0PZxcEqubz
X-Proofpoint-ORIG-GUID: VTFFitV_minUbHGX1H65pL0PZxcEqubz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-14_03,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 spamscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=563 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504140072

On 01/04/2025 16:50, Harald Freudenberger wrote:
> Some of the pcc sub-functions have a protected key as
> input and thus may run into the situation that this
> key may be invalid for example due to live guest migration
> to another physical hardware.
> 
> Rework the inline assembler function cpacf_pcc() to
> return the condition code (cc) as return value:
>   0 - cc code 0 (normal completion)
>   1 - cc code 1 (prot key wkvp mismatch or src op out of range)
>   2 - cc code 2 (something invalid, scalar multiply infinity, ...)
> Note that cc 3 (partial completion) is handled within the asm code
> and never returned.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

