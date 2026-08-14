Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C0846EF64;
	Fri, 14 Aug 2026 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786714275; cv=none; b=m/E7ngQs/9DOeQqA84x+ehgIGpAA+A31cKPvOGsMekvS3iB5jTUuNf4+hiCHnNo4adCOZIedv66ow9hgOnAEL+YdaRgos82XivsxtnspyonieXo7UnpLXEjHkUHD6hGSGmB+Co6hd3i7qOFSDDA25MtyST6KbakqmNLq/STrS5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786714275; c=relaxed/simple;
	bh=E7kwzFbxokPAG9ufOoWfh9lxo7CYh/M4nVDzO5vPBlI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OsQTg9JyU3oZF0CQL9/MeeznRn4qe9jofXsKaRfZ/OS3Z8M0IEnVTCNsl3apt1hUVkh+YMJd6DxspCp3URl3ZaTliR95vOGhidWzCX/PqExJq0qpSblFwfTbd2+kClL1dfhJmllNvzol3iAdRtSL2/F8OuYZ5qiz32M3JWPuxuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sUsDzhI5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sUsDzhI5"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EB1wVP3274170;
	Fri, 14 Aug 2026 13:30:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=N9qR+U
	ikPvqQ6ZYgBrBXqPDCyjHXHk5HWi0ifDaXz9Y=; b=sUsDzhI5nL9NEMPwGh42Jd
	7hOs3UpFvEnXJ7yee45ikWSbihf7q4yiQInlVAdQ1EJwJsK7OSWnKWrB82xoTWUS
	waSCVuqJP5JikXaNYjygMUwbFvJPqds6QRLjGchDTMk1p3UJy29Sy2rm4nOwTVcV
	63dH3hisUcZ8ouLPcZXWu2WgSO1A9VfMkCx/F/+5AI4g4K6SGxO99+SbY89VWadv
	qGz1q7+InRptoPflaIxYobgO9cVz1/CXhkmVuM7xz+ApzegRPKec4aqgcUBs7xZN
	McYNGdBqlw3ghmYwjpkCh8a+CChRGn8DX5PgxcuvGzjWbEr2TPh9IPsNndtkWBFw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvk0cxrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 13:30:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EDQJ88031799;
	Fri, 14 Aug 2026 13:30:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxfsk7e3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 13:30:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EDUrTC50528756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 13:30:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2C4C20040;
	Fri, 14 Aug 2026 13:30:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A081D20043;
	Fri, 14 Aug 2026 13:30:52 +0000 (GMT)
Received: from [9.111.74.75] (unknown [9.111.74.75])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 13:30:52 +0000 (GMT)
Message-ID: <f14cfb86-8d99-41ff-9ebd-31421f1e3871@linux.ibm.com>
Date: Fri, 14 Aug 2026 15:30:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] s390/crypto: Fix skcipher_walk return code
 handling in aes_s390
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260814123711.61145-1-freude@linux.ibm.com>
 <20260814123711.61145-2-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260814123711.61145-2-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA5OSBTYWx0ZWRfX3Cfu+QJ2eO28
 1w5bGPrx5YClvUYDgszg1AApnhjrNMYuYasOzXgg7HR6XXNKCJtczLXXP86ryi/Suo4+NaXVoNT
 q08ectMAHXGnmW38UPdN5qTDEn78U+FF8zYAPYL7VXrv8fvVEx6LT5gM4O+Plar94xjr2Ox8xTq
 tkum9/wA/dDC6l0pIZEoOmbHKQG7dIur8v3vzNwuqkmieh8R/0DhqQ5D6Kv6BIpNq2jVTpUsg9t
 SNxOslEnqKtXL+U5of81pY/7721xkwIh0wg40VFbF8C4ZjMIWBy4HLflxXrqOI56mfX0EJcdE4X
 aVhOOK7oKxwyDBLLxMfr1RQh/T+9Z0Jm3El/c9uPOanS0o76YC+hVnVXezE1+wkao7HyQdFLSaj
 x5dakD3zWXPJmFxOQIrD22d5nZeIDRaAwe9cs4ZJYk8klDC7aKyphshVSB15hvjLLVBiDQgFkOA
 WYPs4GwO8BF8XTcK1Ag==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA5OSBTYWx0ZWRfX4iJAYrwPm/k5
 IufcK2WhF3couaassgU1RcAJfLHJENLnEhwRksxrioeomZD+3t/+QpdeFQjpdWU6MOBM+ArJTC0
 BDIF8KLX3sx4HNvv9g/GuZsFY+WOMOk=
X-Authority-Analysis: v=2.4 cv=RqD16imK c=1 sm=1 tr=0 ts=6a7f1892 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=bx6gCwCgHWRvor7s2BUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zgiPjhLxNE0A:10
X-Proofpoint-GUID: Xd9E7p4NTFL7NI6MYiuSJL0nUj6hIwdk
X-Proofpoint-ORIG-GUID: Xd9E7p4NTFL7NI6MYiuSJL0nUj6hIwdk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608140099

On 8/14/26 14:37, Harald Freudenberger wrote:
> The return codes from skcipher_walk_virt() were not properly checked
> before entering the processing loops in ecb_aes_crypt() and ctr_aes_crypt().
> If skcipher_walk_virt() fails, the walk structure may be in an undefined
> state, and attempting to process data could lead to incorrect behavior
> or accessing uninitialized memory.
> 
> Add proper return code checking to ensure correct handling of the walk
> initialization and walk advance and eventually return to the caller
> with that return code.
> 
> Fixes: 7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 5.5+

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

