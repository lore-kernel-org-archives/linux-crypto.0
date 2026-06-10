Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E39344029;
	Wed, 10 Jun 2026 17:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781112336; cv=none; b=VRjlmVzub36AVPMpYZ9NH+1XYDwMvuLOx2hDFGW3IKGchOw45t1JjaqwJFvcC7CPD2sFluXitAIxV9p5hSRtLjPbztbD5MC7WN9AIWGi/w8dGNP7sZySM2RvCZpCnFmUqOoT56pfHY8MRUhYRv4ktn/Y5C7Z5T6s+DF1Fc3H/gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781112336; c=relaxed/simple;
	bh=ctDYKw/RE/k5fFvvH93Bmv37N3o+1x8KRcJXvMZok+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BUFqtVV26FQXXWjiH+o6qD6XuApYTtrlyJVNI2MCq92ZcI8aZlpGtsRX5q2bQjluqQfyS6igLakwuEu9y0xaRKX/ryQuTmGbBoVbdhujtEHer20ClrzZUCIRkyyVcqU9HYOUs1k2WfgDYg8xMlz3p6wV5PRBSHRTIIxk5vodTpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BuMqwock; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BuMqwock"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A8sdRH3020105;
	Wed, 10 Jun 2026 17:25:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7Rs8z9
	qQFYJHf5jg3SAMftiLRVVW9NIjWvVWrExzk38=; b=BuMqwockYej0wn5b9/vJNm
	s9isaDIZ/IkSnixwgcEPjyxPDa4WeBc9tShS9RiRjUo8m+LLy6JWwwbRbYqN7Wbr
	meV9EFIl3oe4QyNrgngdD+cHHe4m/awnsGpDcDgr9ntN673e2irW17lv+sfvf8mr
	FZm2sS5ELYwk4J+HDZ0fpRK7ETsrSyRHf+le3rYNg/m4K6H4II0YRuvCJqGselGU
	1X4o9nixGRzhjJ+PQRliP0L/ZipdwJrIDQKv42II7lKKRKHo/N9Dfp6UB6SEChdX
	/oVX834DwwYNRZGXfJdzPWaJtFjx3uM5jDF+eJRnBg57PSoDCdVGUSth5S5iP6Uw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4emb7qt90r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 17:25:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65AHJdKE006591;
	Wed, 10 Jun 2026 17:25:25 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4en03g7f84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 17:25:25 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65AHPPdQ25887338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jun 2026 17:25:25 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E3DD58056;
	Wed, 10 Jun 2026 17:25:25 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1FC958052;
	Wed, 10 Jun 2026 17:25:24 +0000 (GMT)
Received: from [9.47.158.153] (unknown [9.47.158.153])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Jun 2026 17:25:24 +0000 (GMT)
Message-ID: <37806a6a-1dd9-478f-aa93-02d231fc0d40@linux.ibm.com>
Date: Wed, 10 Jun 2026 13:25:24 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ecc - Optimize vli additive operations using
 compiler builtins
To: Fabian Blatter <fabianblatter09@gmail.com>, lukas@wunner.de,
        ignat@linux.win, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260607112435.42804-1-fabianblatter09@gmail.com>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20260607112435.42804-1-fabianblatter09@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=HppG3UTS c=1 sm=1 tr=0 ts=6a299e07 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=EG7EwXfyWvgXmjHjImMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3fZ4yJRtnBf69MoCCNgpnikWI_N1cYUB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDE2MSBTYWx0ZWRfX/I7u9/bZD7Vm
 TGJujjbV8F4phtWuUnwa9EFVP+bKbJ/F8Ukky3EyK44YTK7ssunxhfUd5KiiyIb10rlaY1GidSp
 PgHEma4r/tBDni1VBAQJk/mZlbnRuuicRGpynagsifA5spCDzuk8er9ENyCwpy7bdVBPx9UQnwa
 DLD7AVqMpFELsvipjtYUBf/YWFdAMTMskb95xJp5bsSn0eEAT1sjuw0i8i01lxAPvbtV2u5yb9j
 j/3MsKFw+rBkhV5BNdrXV7jVIu0UHCKJrr8viEEjLL1hxfWpcViaeCBu0y6XBfPqaUVvOAY5E1X
 tMa8rR/7q/aMkk7oTgMdUbfdnFci6HFybZ0/csmpvRjKCOlUSz0MwP1cl9alGUG/69r2L7Kk03y
 zxFoJW8aCYpAP4O+Y9oiY9kxdXhrszjzOjedQcgCxHAZ7KkuZlbgtp509qyEBmpb9h01UlK9bEy
 wBaysFzwXG8frECAn3Q==
X-Proofpoint-ORIG-GUID: ZJe6tdlrdt0UWyRE3zNXBBVECiZNQNjB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_03,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100161



On 6/7/26 7:24 AM, Fabian Blatter wrote:
> Replace the software carry flag emulation with compiler builtins.
> 
> Even the newest compilers struggle with taking advantage of the
> hardware carry flag. Compiler builtins allow the compiler to
> much more easily achieve this while still remaining constant-time.
> 
> This yields an approximately 6-7% performance improvement
> on the ecc_gen_privkey, ecc_make_pub_key and crypto_ecdh_shared_secret
> functions on x86_64 on all curve sizes.
> 
> Additionally, the code becomes much more readable.
> 
> Signed-off-by: Fabian Blatter <fabianblatter09@gmail.com>

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

