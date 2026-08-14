Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6E247010F;
	Fri, 14 Aug 2026 13:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786714351; cv=none; b=FHiQcHQ/Qk/OYz7K2dzL6UZZdCnBi74Hy/t38yKacsiFE5lqNHldV9/BLpcjoqLlTr10o7hbxgmlRKgddXOOuOTKeVtXzagCtwXflqXhzLJ6uRIbxlwcazNknflCFf+qF4uJBHFEwXbbEMQltfYHoiRj4YfnU3fdZIBMpQgpN5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786714351; c=relaxed/simple;
	bh=gxHgPKKDsp4s3j3aspbb4eL5vC7P03+RgGdgXoNRdw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mD8/VJlEmeQv7X/6DafPUMCdZ+U7kLD7qcPt5lZfTBqHDwL+2MlkuS8XuXU5qb0RWdbBCf9/CwNNTfVAF0V8f5m+YWJwCnKxAIAhyfrYKHvNykktxmJEA1eveZ9P3oIaouS86silBtwDqtRCDcJkBNo8dD1jFtznueAi+ZJA5tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y/mrSmdD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y/mrSmdD"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EB1jIW984647;
	Fri, 14 Aug 2026 13:32:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7/kSo6
	htA/H+CcZPauBm8is3eicsWLT+4E+xjNW9Gb0=; b=Y/mrSmdDLJvoSFHeLd5zsS
	rK6UqI/v0c8AY2E9EYJDOcAydbJzw2GMUXx24hCW8dbdQUF9ykz7RAi4ABtGPc+Y
	lY2VDndm563h3gXB+kNJFajRZj6fTnr0/TUDPsCjcwLqfF1PKEpoJQFkVas58LRu
	JLYR150gxIIZS9pe2SNSCrJzhyI1F8TgEQGCAYWuzFFa3wBAtwuIDI9uTZYRtDfn
	mcOcb5hBVw4x7c6NfAAZtKvJrpQIHjp5rRhg3Qd9lCZm/3iYvZUqQao0tmc18EFi
	8ZrONkLtG1WNcUXKV+4H4ZEQJA8kQeg0rzzdN9DCkcLQOK3RpCzsjwUkujEhd0gg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvnwktam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 13:32:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EDQqxR028332;
	Fri, 14 Aug 2026 13:32:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxg9hfcn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 13:32:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EDWLSl42402164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 13:32:21 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5603020043;
	Fri, 14 Aug 2026 13:32:21 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE53820040;
	Fri, 14 Aug 2026 13:32:20 +0000 (GMT)
Received: from [9.111.74.75] (unknown [9.111.74.75])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 13:32:20 +0000 (GMT)
Message-ID: <b19ea855-9909-49f4-867f-67dc3357d719@linux.ibm.com>
Date: Fri, 14 Aug 2026 15:32:20 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] s390/crypto: Fix missing scrub of temp buffers
 with AES ctr and gcm algorithm
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260814123711.61145-1-freude@linux.ibm.com>
 <20260814123711.61145-3-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260814123711.61145-3-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=RsP16imK c=1 sm=1 tr=0 ts=6a7f18ea cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=T_O0lcmcSonZr7JI6ZAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: br52cBdbb5dzQkubuq5iWBEDVUBroc4D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEwMyBTYWx0ZWRfX6jVPHiZNigB+
 HsZmIu/L8PdcxahqYrS4L9PSNsFgUEWo7VZpyJ5rZH24QBFD6CQf0i7MTeUoQahliluwfGpu/vG
 oQuG4VJAUXr6aFDyml/8z/y/4tFXdbK7n+ODpDITwYzxUEA6gVORD9ga82jTmTODEdgrX+wkix1
 1Xljy/rJH807F2qXQQP0zMGbgWNFXWdAFuwD5my7o6Uh7CWRVnNpTj0OWWxnNCdtV/UdZKeq8rM
 mPsvvntCvmF6qFFutiNBddgAG1s5+J7F27NDw9OWTc7CuLzkE8sv8M8Iv1g8N4UB2Y3k5tECzQ2
 7JvQOQnIB8luO9xbb1s/eQTiBahyscX2Cmr05p0smZtfANLLBVPSj/a6548nDZXJzzlFKkRkwv1
 F8KwbDdWmX1vMpflb9qjkqdEVFqoruipRj340eg7ep/I6zAvASICwLu8XhFLvB0c9XMLk9pY/vB
 nJAGna7u7/+KBEW0tIg==
X-Proofpoint-ORIG-GUID: br52cBdbb5dzQkubuq5iWBEDVUBroc4D
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEwMyBTYWx0ZWRfXzEeIimMvMqOw
 GEJ6HKNNbxuKygr62Teu2drUVnBMDxy3jRr58fqc31yvhjUfcAkRBI7bNdOM9+msteed9env0ZE
 1H5YnIIejvmx8YI3taOmFacdI7zsb+Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140103

On 8/14/26 14:37, Harald Freudenberger wrote:
> In function ctr_aes_crypt() there is a buffer used to process
> remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
> thus could lead to expose of unwanted data. When the buffer is used
> explicitly scrub it at the end of the code block to avoid exposure of
> maybe sensitive data.
> 
> In a similar way the function gcm_aes_crypt() hat an error path where
> the CPACF param block was not scrubbed. Instead of return early now
> these error paths go to end of function where explicit scrubbing is
> done. Similar with the buffers which are part of the gcm_sg_walk
> structs from the variables gw_in and gw_out.
> 
> Fixes: d07f951903fa ("crypto: s390/aes - Fix buffer overread in CTR mode")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 6.8+

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

