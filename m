Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF8A38D3F9;
	Tue, 11 Aug 2026 10:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786443244; cv=none; b=o1xWR25ui0LWBIjmfIYMo9RPTTLRlRijAS2A7L/4vl9jzx34Cehuep4cf6NdoSv4IyQnfVdiWNPh/V8/K5T+oYJPbBdU+JkGLm2E+XT4rcUP5BYDZ78rw5H+mUXOVHkPQLfoCcQWwW/xAh67RRFmF47VJis+BvV4SF6h8q7oyMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786443244; c=relaxed/simple;
	bh=BejbUcJjbW25ZxVE2vQlLocoggtLdXBB0JJ9ey071t4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sRAmUFTl2KinA/MlXi4qtrDxjqoBvxjPdinMypzqRnxuT1+iP/MxTylp5fW8IwMVbERcodsYhnMa3NjCVWop5a2x3lyboup72OMT5v0NMNEPKs8MLBqWL2L43/4BqQG1nR1E/uxcJgJsSbeFXVbYtlgIXwg4YzweCCwRae69QdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=csLFFvVi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="csLFFvVi"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AN1tHS3000255;
	Tue, 11 Aug 2026 10:14:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0LWf2G
	lSlP2WbCo8lhdyydGvBRDohCGN0Pgau+H8TPw=; b=csLFFvViyChgZtYWEqZHGh
	OtbxMRzXwuguqbtjWd88q8W1OBctUAf17qGHKKpNmy4+17PQhRFOHDq08TdstEja
	LBGG7UGlxxBgh1B+ymDWhhnNbMYjql+G7xmMVeUEuJedzmiDHkZZXhC1sMjozWXw
	W5XGmTuOXZbUVyT1C89C+/WVqZw6zkHxlNJaLaa80N37aMZ/UkT9QDyI1f6yPThK
	3gGATWHfWBK7xzPZeWgT897zLE4RmXml75kkazNZfLWrhniwSpLhgq8acqblPGcC
	/nIO2/W5r8EG6VkTLOCV6b7zwYkgSJtCWt8qZl//3pDQbOkzflbJlRBeBsP2mSRg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvnw3r34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 10:14:01 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67BABFwN027092;
	Tue, 11 Aug 2026 10:14:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxf5w0kg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 10:14:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67BADuiK51118348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Aug 2026 10:13:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EF962004D;
	Tue, 11 Aug 2026 10:13:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 418EE20040;
	Tue, 11 Aug 2026 10:13:56 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Aug 2026 10:13:56 +0000 (GMT)
Message-ID: <608b807e-5887-43eb-9598-2a87827350ee@linux.ibm.com>
Date: Tue, 11 Aug 2026 12:13:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] s390/crypto: Explicit scrub temp buffer in AES ctr
 mode algorithm
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260806084950.17679-1-freude@linux.ibm.com>
 <20260806084950.17679-3-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260806084950.17679-3-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=RsP16imK c=1 sm=1 tr=0 ts=6a7af5e9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=lyOGLLBlSGA56w-zKboA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: YvywRbD1aIcqQVkgRxyTp-M4AYmKLMQe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA4MyBTYWx0ZWRfX2k9YeU1fjHZ/
 7PXDS9DHgoQ+BCoedzxCELD8jcjJpcZqk1tU9TS2eIrf7ECp5+/yBvvVImDfZ9bcqmcNb1EDloI
 mt5QGVmswUdTLh//rLYuLjYyI4JmbwwZL+8ki269VEOhIUBIzCA/p7RpkGArODilsgu1xOp58Ug
 jIN1XVXbSGd7CfwUPCGPEdBLgnESIBnXHVNqd1SOhSZYWORZUeDU5CbUpEhKiVq9M0/WdhBUXif
 j1s4GksXCDnxmrKIKOcaqsZHUMELCzMlbtvtwcl7X09NsEw2ZuO9hb1WY6gHr3Lh/d8E91C56mv
 zu0PWfWjl4twlDc6VaOry8ctNCf9U+U9beCWJIglGbermIfZmriin3d7AIL6CnHqTDDKwQxRkgg
 nWIJ2uZXFnjNaZYFL0VS8k9X3lNgYJ1nlpAF1tc7pMnV4z7uRmTBBgCihVOUm0pXQa2v7vZI8c+
 utiEW+fuq68+aOLiCVA==
X-Proofpoint-ORIG-GUID: YvywRbD1aIcqQVkgRxyTp-M4AYmKLMQe
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA4MyBTYWx0ZWRfXw/AOXvAb7KvW
 WonEwvrpsIEYJxEVVCjqP/GB9UuYuBLxuSXWXpLS9Z3VpGg+wVgEiznH3qboftn4CA6EcbubwFt
 VWFJxtt2snzI2zBKFdfgTTYtF7J+J1E=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608110083

On 8/6/26 10:49, Harald Freudenberger wrote:
> In function ctr_aes_crypt() there is a buffer used to process
> remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
> thus could lead to expose of unwanted data.
> 
> When the buffer is used explicitly scrub it at the end of the code
> block to avoid exposure of maybe sensitive data.
> 
> Fixes: d07f951903fa ("crypto: s390/aes - Fix buffer overread in CTR mode")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 6.8+

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

