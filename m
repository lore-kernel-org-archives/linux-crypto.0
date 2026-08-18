Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6356F3B71C6;
	Tue, 18 Aug 2026 10:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787050127; cv=none; b=o/+CWVJW1i4rhIj4gyKBGEH7mO4UR2ZtnP878f4z5sPWqVXYjXTpQcq0Ulj3BD9AaKEjqWYYF9J7fMegNguHHTfnucPII5U+wbjwSmo7pTJGWfHB11uw6yyhpBuolWrrEdT+OmbR1fu5dLhj+dOIufjJbnME4NutSBTZIokdpVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787050127; c=relaxed/simple;
	bh=S2M4yWLL/P+a0cQwCFXmor7/IXa63t8PNQLjGws3vYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TlFyqvnFG62Yg4Ku3lvwnHLz5RblAwTZzksKkFH5q7pU5Poc3q5q+myq4fQlSP/g+Y4hV/0G3Figj2KAkirmZyTTH5uSMudgjPZw6YfoGEuPFEs+zgiI4cxms0Qz5/uvQHr3BMQfVfZFUE9Qn05nBYvexDkxnLffXpJeE4PmqSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jX7rHjiK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jX7rHjiK"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67IAW9Uk4174625;
	Tue, 18 Aug 2026 10:48:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5RP4ou
	JYee/sR6dXzt41LaQi9czUFlekxi9n+yHYWJU=; b=jX7rHjiKj1KaB+dNxqbU9V
	EKDHbAw8uPlmAsegSktqnTxyL9CAJbPXPueZHmhIrOCnfnot9QCgNCmnJCMwtB1S
	j1Z3fxtFY1h86BUQvAp3+/f5Ul3a3bJO+tu16JSy70ukzHgOAWqtJQXb4ncQlO4k
	4HpWF/ooFVtcEWR0b+EYON8WX2WP+j7fRbr4COawag+ryLCsstyQEkjczT2LYVlD
	onANUg3RCNJV+aimAzXVha4A9t5OhtsRyzi+zIos1MuBmVUbbVX/nJwjWP3MjzWq
	llSFA/y5Rfmy1PrcFhl5bpZsgDHvyhX4EWgrb0R2hqYdIjlwI9ewdvFuMjHYBERg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fm3qnbc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 10:48:45 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67IAfO0C019868;
	Tue, 18 Aug 2026 10:48:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g34ngajep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 10:48:44 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67IAmeSP44368172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 10:48:41 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D421620043;
	Tue, 18 Aug 2026 10:48:40 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A89E020040;
	Tue, 18 Aug 2026 10:48:40 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Aug 2026 10:48:40 +0000 (GMT)
Message-ID: <d260517f-948d-4e51-a1d7-2556ca9e2ee7@linux.ibm.com>
Date: Tue, 18 Aug 2026 12:48:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] s390/crypto: Fix handling of EBUSY in PAES when
 req is pushed to crypto engine
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260817141654.77940-1-freude@linux.ibm.com>
 <20260817141654.77940-6-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260817141654.77940-6-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4SQ4UmRNjj6eD98t6ileeGvVxr-SRnpQ
X-Proofpoint-ORIG-GUID: 4SQ4UmRNjj6eD98t6ileeGvVxr-SRnpQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA3NyBTYWx0ZWRfX+QCVxZ1vQU8y
 mRTFIco88EciPQk073BzN2LkWQ9VDpgwWyTOGTwepp0FzgdnqZLqiWcwNsf8N/efjBtYi9XOWP6
 fSP08G4ByoimZ7K+5EsgW/8AHL51G0Q=
X-Authority-Analysis: v=2.4 cv=WtQb99fv c=1 sm=1 tr=0 ts=6a84388d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=YZS7CHmu1dlvhWUSdaMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA3NyBTYWx0ZWRfX38W0VO8TtRxH
 X5yzjcJe+dUUGVcy+g3WzTgEX4HBYUnROVSIfKkHPRRqBwHzyhJs9+J9qUhBehsqwOaXec2xdtJ
 YPqDjybjHqKVZg+VOw8r0OjdC+fchqmeFT4kUwwT4mU6zUK9Rk3HVg4HWriwhsfQgjC9rn1YBKj
 oVonbzP+FDyt7UVAnL59vQBGzQm5aSsRvMD7xUt4CkMs/Ny/bsaH+dLkSjMWdWtkI/uTGpNSIyq
 ATguYb3o2aoPyuLIdxGGzzhDWztqOfHCfwXSnJoRiHf8IYYEKaBY/HsmGrG1LwIbXD7psLSRNw2
 FiSd+jKy9AKPWrrdXFkjY6jEq5e14dXJl2qXKMgKKXyYwN45GumX/QBX2Q1NcoOYQmoRx52f7lf
 5FJ4xDUegfI5AAJ2oJUnb3mba+Zc4I5K2O5qWFc1Rd+4PEyxgh5noOovK2DWRTr0+8XxaYUxVSl
 jjhFWKZo1zdhl12BrBg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608180077

On 8/17/26 16:16, Harald Freudenberger wrote:
> When a request is transferred to the engine via
> crypto_transfer_skcipher_request_to_engine() there are two return
> codes signaling a successful transfer: EINPROGRESS and EBUSY. However
> the correct handling of EBUSY was missing and has been added as a
> return code indicating a successful transfer to the crypto engine.

Please rework 5/6 and 6/6 again, as the handling of rc in the
synchronous and asynchronous path differ. As discussed, you may split
both paths in separate functions or so.

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

