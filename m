Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402D43A4503;
	Thu,  9 Apr 2026 08:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775722943; cv=none; b=EpsniydZisCACqL7T/IxxNS3nM9Ex59l7nqQZPjOTJ4VdBOo6oh5iezU7yOTHMFfSBQYVr2JXGA0uRweJXL5pUIrWXAquaR4ERuIFKJ5qjjIcj4trK5i7yLE5vcd+LAGSBUgr7l00SDvIrhRzEoIsGkez4ZM3WlExJXzlpi9YXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775722943; c=relaxed/simple;
	bh=4uAba8OI5T8Go5pGclaJOI0ikIPcUDGzn2OR2CK59cc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lNJFieu8FZiNWmoascKtNgEpG/K9w2RO3g0WrQIYIuJNp2IEobL37E33r8fHsSkW43xQDqzMGKGIArUYodUT4GZVjJehR4GilGvIBpbjV0tQnZzg6QRwliyevrn5/JE0aYjdN2BXrWw7rg2mNVTuYPuPCFAqCj7pC29YdBTziO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rdlvwY+A; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rdlvwY+A"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638IKt762314896;
	Thu, 9 Apr 2026 08:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GQXOWG
	SWDursGskd+z8LEeh4wYGacKmqrxF09Mg4clc=; b=rdlvwY+AqFE5OuzNF2Gfzt
	eSTVX2Lom0FQLgXduASx/bURqNFYegg7679lL1mc2A9frV0lB8xikHG2aDP0kMHF
	cWs53k9gtJrPLyeBych7JmdlOra/j7uuJQT82ZE0KD6lZ8EqJrd1JqZ3Ch/eceJI
	HS88u3C8dAmH9RtUWtVix5081jhZDlmkwUpKrHbdc3AzISfUJ1Nc64RhurtaagwE
	bUJoLv0Qlmji4fbXDimHkkBvOkGfCVioZY747tnToRSMoIrhl2P5G8DQwUb1BlVM
	2MkE8ociG32NJ73wXM5ZTVas6s6REZa59Zr9/giui0T3HPVH7SQxNojp5oOGEidA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2g4067-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 08:22:15 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6397iILj019008;
	Thu, 9 Apr 2026 08:22:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9jt4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 08:22:14 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6398MCZL43909524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 08:22:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69E2620043;
	Thu,  9 Apr 2026 08:22:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F04B20040;
	Thu,  9 Apr 2026 08:22:12 +0000 (GMT)
Received: from [9.52.215.116] (unknown [9.52.215.116])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 08:22:12 +0000 (GMT)
Message-ID: <e1767c51-0bfc-45fa-896e-ac2de0268828@linux.ibm.com>
Date: Thu, 9 Apr 2026 10:22:11 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] crypto: s390 - Remove des and des3_ede code
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <20260326201246.57544-2-ebiggers@kernel.org>
 <09684f23-8937-4fed-b88a-361c9ccef04c@linux.ibm.com>
 <d5fb24534a56017e622ef15272eb2f0cfc6d6de6.camel@physik.fu-berlin.de>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: de-DE, en-US
In-Reply-To: <d5fb24534a56017e622ef15272eb2f0cfc6d6de6.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=FKArAeos c=1 sm=1 tr=0 ts=69d761b7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=w4HzK-rsqA_2YikTyBoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Ngpa_VWaMMY_eVbLJ1I8VR420Ai-6YNB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDA3MiBTYWx0ZWRfX2IdIJZuZ43ds
 CcWlWieupJqxnCUJDCk4db1up+S5M00QF9QQkpMCBPrNIt9j+B/hpXHnnfAq/5Bq7sjG89MdXKy
 4mZ6wcbUsnQZT6rvrLKjjZ35QuNNHzFU9WgiQjZYtR5PBKGxeG+coGomoar39+DGLdEzcwwvcyP
 UWKlQ5UcDPjrAk6HSN8mg/PZze9zcrAa36nHzCN2ZOzON5CbT6Y5OrhAhHrlwytqTpXdRkPQPD2
 YR566c+iVFIi4Ml8AbFlg8UKfLBs9+/AlQrj9U1K7Wts8GRJOiSmfJcMaesOF8kDxRtvmOZbGP8
 /gPDLZZMeZnXtYpG4SU84ix4ZKy9skn/myi7Mq3thUbB5n1ucKeI7POCVa+4PkMtFKc+dlcxopj
 nkwplCbWyryFH81+Pq3Jv0wwr7Is9uP6aZNw9licbhPTcxHgD2oZQgYWtGiOzMIh+O+bhVV6uEc
 FDQo0xMC89k9dOUPePg==
X-Proofpoint-GUID: Ngpa_VWaMMY_eVbLJ1I8VR420Ai-6YNB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_02,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090072

Hi Adrian,

On 09/04/2026 09:29, John Paul Adrian Glaubitz wrote:
> On Thu, 2026-04-09 at 09:08 +0200, Holger Dengler wrote:
>> On 26/03/2026 21:12, Eric Biggers wrote:
>>> Since DES and Triple DES are obsolete, there is very little point in
>>> maintining architecture-optimized code for them.  Remove it.
>>>
>>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>>
>> Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
> 
> Wouldn't it actually make sense to keep the old crypto code so we get
> additional coverage for QEMU's emulation of crypto instructions?

For qemu test coverage on s390, I would prefer the libica [1] test cases,
which covers mostly all functions codes of the CPACF instructions.

If you want to use the kernel code for testing in addition, you may stay with
a kernel version before the code removal.

[1] https://github.com/opencryptoki/libica

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

