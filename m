Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FE33368A7;
	Tue, 18 Aug 2026 07:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038335; cv=none; b=qB8oMYR/W4mgxkmrBJFQre/35m4b+0fY8wQdFWDprqaGKwduy2dlL4EprP1YwJAcbBKbGB1r9Vc5zCU5pO3Izp6WjD/HVK+/KH23Mfd/kVq4UARFmvC/abnBTwqf7BP98UwnPmUcWCvKTfkWuUBCfRZIxEhy4RvZ6iper/+I100=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038335; c=relaxed/simple;
	bh=PovKqV1wR6YVqWMIKbAT2E2RHFpdbvh0HTPSHDXxDpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HvwRdCbD0Mqc754pOls7EQqhZfgESRFrfN+5WhVPc/oj66cel2svhduST2Ya7L+AMw7xTnNLYfKRn6qW2YccscM2wMn8IkcLYtC2sX7te/oOd5L8MyxMIafiVaiN09wQ9wt4zxExeBD4u30Vl8N34hSu2GKEvHYkemiXdWPsX24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GdejFXTg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GdejFXTg"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HM22Rb2527318;
	Tue, 18 Aug 2026 07:32:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4/A7sk
	cYOhJ1SGgd2S3BoFXlEOW7ERoEKZ1Pp2MgNY4=; b=GdejFXTgTZKHiCop1yumHl
	kUPQv44Eep+jXNDG5qM3Z/kK4DMZRxgiKpZ2Gju635fWEQYKHhXC2+x4TWlqe0qQ
	F94fz7u1Bjil8UPYrkufnGni6YWHJXLhsxgZOEJrjWMslBOdb14K+uqijDkZYY9v
	qyfWclTivCL1xBW5fPKkIw3jdvaNAzKym5CKnbY35COuZC8c8zS83cBt9y2T1HVW
	0hdh+VTAB7Mpe2V17riLi658I6uFGKNLOiheIkPQaW4TeYVzVWcEuF4kpTjqy4xb
	mrLH+y/ZKCS+pX4J726dKbsZd2qjOKnT3oS1aWIl4+X1WSF1eLbj0mDj7nePtT9A
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2dhkxmk5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 07:32:12 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67I7QMHY025787;
	Tue, 18 Aug 2026 07:32:12 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xh1y0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 07:32:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67I7W7ib45547976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 07:32:08 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8DA620043;
	Tue, 18 Aug 2026 07:32:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A56A920040;
	Tue, 18 Aug 2026 07:32:07 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Aug 2026 07:32:07 +0000 (GMT)
Message-ID: <aa6f0aee-2ecb-4426-b281-698ccf29e890@linux.ibm.com>
Date: Tue, 18 Aug 2026 09:32:07 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] s390/crypto: Fix missing scrub of temp buffers
 with PAES algorithm
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260817141654.77940-1-freude@linux.ibm.com>
 <20260817141654.77940-3-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260817141654.77940-3-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA1NSBTYWx0ZWRfXz9aOhHlYrIzw
 BvnFRHKiuzS9GPP7qwt87nzrPFNEKp9r96mcCWT+EndIZd/WdVQ3s3HKyXAERAKBXjCWccO6/Hj
 rD9Uq3cXJ6AtiewkNPXt6nRj6MnUsHxKv4FfalPDWekry/Z1v2NYDKZDQAhO3IKlcx1M+v8rgMC
 8ZyhRTNFC/gBE4nN+AXSnRav/7qq/v2C01QU03oCC7EXfjiS2I1rwD60wqCxWtZk79wFhzZeGeA
 8B0zIzB2MT1TkqS4u7lp/SS510xcHlxjwtUZ8gt7nw3kCG5+j0aSbN8UJJKQ8Ocl69GAxLpN+2D
 6fP2Q0PvA78IQ5H2PX6s4laeFXv1dw9hbF0YP0CadjZggqvrxBO7fEl4mp2bVfWKzV5r0mx7hmC
 omsLusu+8MGspgXly14JGET98qshnV++TBRKTPhDuPsxmBZ1FNcpNOWXJ0ElE79PuWmWXHM2nHk
 qTnGEDq5udw62HaDcVA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA1NSBTYWx0ZWRfX0D/VRgKHqKBI
 xzdREronXVxSxsPGSfJzEpeR0M2ypp/YNBGehyBn8js8fUbQtf9Si1k19jaqg+b8fDvGJnPFEG7
 ySdP/BjxvGbeniGlh80bgSfLfHVILBE=
X-Authority-Analysis: v=2.4 cv=JKkLdcKb c=1 sm=1 tr=0 ts=6a840a7c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=w1AT7bSVAAv4mFVDG_gA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: HrXgx7_tRgrXkqGjeRIrvrgT2DX37Rdb
X-Proofpoint-GUID: HrXgx7_tRgrXkqGjeRIrvrgT2DX37Rdb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608180055

On 8/17/26 16:16, Harald Freudenberger wrote:
> In function ctr_paes_do_crypt() there is a buffer used to process
> remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
> thus could lead to expose of unwanted data. Rework the code to
> explicitly scrub the buffer at the end of the function to avoid
> exposure of maybe sensitive data.
> 
> In function __xts_2keys_prep_param() change the existing scrub to
> clean the whole param block instead of just the key field.
> 
> Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 6.16+

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

