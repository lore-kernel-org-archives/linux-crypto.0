Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96376198E9B
	for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 08:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747987349; cv=none; b=DFRbWqzsQrX/EPCK+zmaUYgQDPKmAWtKVKd/VOatnQw5I0jMxJLfwCDOHiPyqYXcPYDswPuWK21AtaJLuKfa6cThJ7vzKg/y8oR3CYhnRbprqW+3ij+1mOi5sgLsj2AcOPY8bHJErebwfAOqQUujeLL3y0kPWXyx4H4sxiGEOYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747987349; c=relaxed/simple;
	bh=oy4e4ihx7fPvQkb6NL7keRmXqNj78wbBtBTUIGPUZ4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ndLw60UNRyJzYhhjQ5jXkRnZgyB3Bh3cJHm6binX5dVoRqLgkrMv8ruS2mfq5snRg5z84/+XxUoCtlrVhrb7B/VcME2+Cr4y8Studll4v3IGwX0m261T0RvHenXDYW3zK+OYpRpzao1hu4/Bqboo49ueLNwgvA4iHD9AQz2CQks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bYB5VwHq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bYB5VwHq"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54MNW5NZ024713;
	Fri, 23 May 2025 08:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=b9HNKD
	jDWxE8w2AzofAcz/4sdbGmxsFBs20Vb3q9aXA=; b=bYB5VwHqf2cVNLausJg4g5
	9OPejtUxIDwfc5GiQun96xRPpiX3lprguJvOCH6WyenRX+gdlOhSjGunzeAn/euU
	+dhdoEAYH5A/pSU4EqDQ5zj7P6Nv85fu+349ETolLFPZauh25KWTbSKZFKm1jwIl
	Nu9tJvB/PBiAjcdBiCyBMpQ/ddRx5ry6Z67lqHvw1N2eguS8q+yi/XzhxuFzeFx/
	3JnY2++QnXS/qoDP3LuhozXL4cgQOstaUvlMV/enylM8/jFIqsp/+C5S7PF+tOqy
	kYqdFrflR0ac3jYuEmfvgIeodTxSsKEDTXKFLNqul9YMIAUe+lWtRd01ZJoWiC7A
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sxhweftb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 08:02:23 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54N5bqiG015497;
	Fri, 23 May 2025 08:02:22 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnnnkdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 08:02:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54N82IKJ50921932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 08:02:18 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 76E012004D;
	Fri, 23 May 2025 08:02:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 553F720040;
	Fri, 23 May 2025 08:02:18 +0000 (GMT)
Received: from [9.111.148.185] (unknown [9.111.148.185])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 08:02:18 +0000 (GMT)
Message-ID: <152288d2-a034-4594-a5cc-d46faf34ac24@linux.ibm.com>
Date: Fri, 23 May 2025 10:02:18 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CI: Selftest failures of s390 SHA3 and HMAC on next kernel
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>
References: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>
 <aDAM9LKOWSKBbIUn@gondor.apana.org.au>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <aDAM9LKOWSKBbIUn@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDA3MyBTYWx0ZWRfX8H9YAOo39tMk B1AI9yWuEHaQn++E5ApHHNUmaU8C5VkiCdO+UB3sKuQTjGQN0ntmT7u0HZwxcbswjmqUiugV3KM vc403sHCBC7krTjh/3scnLwHEXocTDtRYCMSl3vAvB6KcxGGrjeImtWNdJ58C9KUx1OWOTa/jmc
 93SeVTpLfq/wQqQIKehUqGvmZqHnTVrh5sWKbXfYRj+Idh8RL29nBCBpO6Xe+2hCfYMinwKza/G qJHAT34AUwZTIMwk6wsAaSsvJUqsIkSTuSjlCJCT2tvErb+NxcCJXG+2Ea/FUc9S5ODRX5WJIQC 06BJZN+f9AGplXTXQaUemmRl7UyfJZpuqbgWzr3gbHeeJRXY9KTPEWxZFfAFicnTD4gbRDf+5+8
 /LxDMb82bBI4BxaX48AqbHkl+RWgaYirKT2IbBmtliAxhZc86VB+PGr65oKd0qZWgc3BSFbF
X-Proofpoint-GUID: UemPp6lOeox6sbCnl5Hiofw9KRGIRfLT
X-Authority-Analysis: v=2.4 cv=O685vA9W c=1 sm=1 tr=0 ts=68302b8f cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=pENMx6WK00e7tXqaNCkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: UemPp6lOeox6sbCnl5Hiofw9KRGIRfLT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_02,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=982
 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230073

On 23.05.2025 07:51, Herbert Xu wrote:
> On Thu, May 22, 2025 at 04:13:59PM +0200, Ingo Franzki wrote:
>> Hi Herbert,
>>
>> in tonight's CI run the self-tests of the s390x kernel ciphers for SHA-3 and HMAC (with SHA-2) started to fail on the next kernel.
>> This must be something the came into the next kernel just recently (yesterday). It did not fail before tonight.
>>
>> Affected modules: sha3_512_s390, sha3_256_s390, and hmac_s390.
>> Not affected are: sha512_s390 and sha1_s390. 
>> sha256/sha224 no longer exist as module, probably due to the move to be a library now. 
>> All SHA-2 digest self-tests pass, but strangely, the HMAC with SHA-2 self-tests fail....
> 
> It's probably the export/import format tests.  Please try reverting
> 
> 	18c438b228558e05ede7dccf947a6547516fc0c7
> 
> and see if the problem goes away.  If it does then I'll revert that
> for now and figure out why the s390 export format is still different.

Yes, indeed, reverting this commit makes the problem to go away. 

> 
> Thanks,


-- 
Ingo Franzki
eMail: ifranzki@linux.ibm.com  
Tel: ++49 (0)7031-16-4648
Linux on IBM Z Development, Schoenaicher Str. 220, 71032 Boeblingen, Germany

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM DATA Privacy Statement: https://www.ibm.com/privacy/us/en/
