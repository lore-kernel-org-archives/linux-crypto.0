Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F15295DAF;
	Fri, 23 May 2025 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748012340; cv=none; b=efXfeDJMg7QweoDa4kPjWWJpM5EyTir2OsYu1rtPsdANeMwT36tHL53m7OXderbytGOpEEgkjDefjXaDQFkEirGEpC11A7iBleCrTZr5ZFwDDSFW81iHQSLDTX7dE04A/my9O4mZdm9yXmiLC5moI8M+n89l/L4PIUPtDxbes58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748012340; c=relaxed/simple;
	bh=W5Vw/zoUASJ77l8ev9oIm6zzb0Ieq8xSEw7bEpBZKNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oGo3RWqFg5m+Iw1lXrmDWaKeLtpYuLb1qPfkndXLBwnMT2iHL1MSvwjmsSBkJ+AXUoJcPejQPOHIDuaLXjn/Od1Bm8bwKOVaSVtWQvda1XyMqDvNC9Ab6gkHZcN3xtLqRR0kLOXat/i/z/eozIn9cJjbXB/OCYv+xO4fK8dqGA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kkktF7S2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kkktF7S2"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54NA8KBk030272;
	Fri, 23 May 2025 14:58:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=D/Eug2
	pQoOq+/M19wPDt0HHCsahF+PAhPEdgG2q1WO8=; b=kkktF7S2kU0bNZqUoB24PM
	+NxhKZSWJI90IldZ0wP+A6DrppkrH0ehod+GgXBktL692X1ELpKGcSwQsx/cVNLn
	LcveMIJcq9TP7O9B+aCqByn+lNeykIz3zm+AxXc5DACn8aCIlmxNme8w+LxDvOM1
	Cgavmt9s7iXURtkfYpW1XxxEt3NY0ZG/wHtJ1y2mk8vscFqdwcuMKYFKFc+nxwRy
	mXeK+hYRy3PxL7zEjSVYWa+l4cQiB/GECSCvvAvVv/CNhH6xSKPCAyZmO87riwCR
	+blTdw19QRUYweMN6gJDtDNqTbAxTjvhStv9vZEAGShnfCekwmVrI4UNlUtUnuMw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t669p0nd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 14:58:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NEsH0B024710;
	Fri, 23 May 2025 14:58:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwkrf20a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 14:58:54 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54NEwpXP54919462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 14:58:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F085D20043;
	Fri, 23 May 2025 14:58:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9021A20040;
	Fri, 23 May 2025 14:58:50 +0000 (GMT)
Received: from [9.111.78.193] (unknown [9.111.78.193])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 14:58:50 +0000 (GMT)
Message-ID: <f1f6a579-109d-4ea7-a9d4-774a520d6459@linux.ibm.com>
Date: Fri, 23 May 2025 16:58:50 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/6] crypto: ahash - make hash walk functions from
 ahash.c public
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com
References: <20250522085755.40732-1-freude@linux.ibm.com>
 <20250522085755.40732-2-freude@linux.ibm.com>
Content-Language: en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250522085755.40732-2-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=RrPFLDmK c=1 sm=1 tr=0 ts=68308d30 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=w4HzK-rsqA_2YikTyBoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: w_K2uBQ6lqGMgCJqMrIxQwEJcJQwPw6F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDEzMCBTYWx0ZWRfX5eph+2zk8EsR 0rhA6xlMyd+oL5ehYZ+wlF58zR2AhRtRwPSsyaR16yIeqfiJd1RH77ZP1hkgebeiOYQUhVfF1dd 3tmRip6D6DQdGe9uK2Oua4Q1FqR0kH3+1rTjrIc2OH2AizQzQR7Zv7wBB3phHAmG5AuJgtRhKfw
 XHZx5g05VDAcGAkFPcFeilUP8yE3XoY2BaF4qOLSIER3+XKm0aG9lJfDKyRI0Crr2mnHn3OeWnI Q5M9+jTA8nlDgdHTW8qUL1qI3Kn+zk7soqUORTFPAz+clAm4sRHdzbtxtDUZm8w/F/prwwszLCt 8Kjj7TCyMBc67UuxQA6Ye9lyMN0ILNeXkU3tOchjiiC9IkuuhvrLSCH+vDqwzgA9zm3U7Q+IFJf
 XMEsD9Kk0m3vhPNKpY3Wy5Qu3EJ2enHgyCpJMlmdFhkVWSQ5fQX8d6CUwZHF8vt3tRSyNRJN
X-Proofpoint-GUID: w_K2uBQ6lqGMgCJqMrIxQwEJcJQwPw6F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=623 suspectscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230130

On 22/05/2025 10:57, Harald Freudenberger wrote:
> Make the hash walk functions
>   crypto_hash_walk_done()
>   crypto_hash_walk_first()
>   crypto_hash_walk_last()
> public again.
> These functions had been removed from the header file
> include/crypto/internal/hash.h with commit 7fa481734016
> ("crypto: ahash - make hash walk functions private to ahash.c")
> as there was no crypto algorithm code using them.
> 
> With the upcoming crypto implementation for s390 phash

reword: phash -> phmac

> these functions will be exploited and thus need to be
> public within the kernel again.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

Acked-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

