Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2733C3B19DC
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 07:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779174578; cv=none; b=XVcSPKa42UUmsfWDaMNBj8ZLd0SXLNRNefWIEnxcmb+aCU7fxplEmY4oRpZ/sbs0lxljNF6P1+EXiNzA5ayUgwVoMhmKWLc7+gW4zheZ+n2BF9UyD8akNyaRnpuiWP3X1lIZiZ1BdFEp/WuSGej/lJvyn04EXO2b/hvCxAXQBcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779174578; c=relaxed/simple;
	bh=HwXDOwJ/n8kwN5m65KMuiRC57ObOd4uZu5RS7F3aRHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WDRGz2IO9yccsCSODi+39ERJlbdiqsPRBwPBTYSP13pHLzACIYKs5SC7ZyxWLVSTjzxnN7/ZP1a9V7DvRnn75aHjawBCYuXS/RGazT4KkNHLJvECk21GMCumt3Hqz/+2Yi+M1/XC6uUiovULjokkm2vmOM3xZT/VOWDiAufzIy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=k8TnIJgz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KAueQnj/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="k8TnIJgz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KAueQnj/"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64J0frm72975577
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 07:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	flpjn8w2XFi3HDGFXRZoiV0RXVmGTmh3woS4zlIQX2s=; b=k8TnIJgzFnzTAcNk
	Xznrj3F6dsjV/bSW5iDpbg8odUQ1Ym0tIJhj7zRmnUu8YclwkG506SS5Mv4S1e/d
	oOpn6g4mKRqAL4PQSa0k2Uu+B2Lb0CQK30evFwtOxxX12iFnz9c4V7vbosXDVTEo
	kWgnCIwPsmLT48erBtYQnli4qUhxsNQiy0tnQojDVBst2f6p4zoMnd4R0VDmWsCL
	W1R7QJWgDTEj1kzjOja1pA7c4CYtNCKJ6N1/sh/a98aX3wTNM+1eehcrvrzHJOig
	hvN0U8L9wQlO3sYbzOcy1y3vpFJIxwAExe/KvB4h6dJnDqppoYt59kTUNGSw4l+n
	IaK/cA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e84v4b4ef-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 07:09:36 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-365d4d2fa04so2995965a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 00:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779174576; x=1779779376; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=flpjn8w2XFi3HDGFXRZoiV0RXVmGTmh3woS4zlIQX2s=;
        b=KAueQnj/Sk42xz+DEI30livgaBIsFHXbtVokiCm25E1hwRFUn7KDAQcvwcBxzCD5OQ
         o5WOihfokimBXC3uhkz+Go8Aa+wY+vDj8yd8HRwh8yuX07Q4xqvYGGA/GfQ1vBznlJv9
         wO4Dh/DXKgk6s4BsdjiqkOYRACaZnYv44QPRVcz/CB15Hq0VYiWrG802+E9txRrHrDyd
         0VmXl9e4cO/HxtNZ83KXlIVwfI20POZjOk4k9T9YeInHDVcQA82l2n/VTNPD1XcftrWd
         9NDc+aM+2zDJiMnvsBQykusZv0rZgR0Inpv/pWt07W9xYkpZiD+Yqn5i1ifKEsNN8TEv
         fpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779174576; x=1779779376;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=flpjn8w2XFi3HDGFXRZoiV0RXVmGTmh3woS4zlIQX2s=;
        b=NWFiunBCqG1sU3tQIfGsY2YilGhZD9ewqs40ETXFDqPC4BUlRi1R5EDnGEde0X9jxr
         hfBgXAtvmm5YuHX+CJCMiPi7L1y5ChH0XV5BHTUj3j8pEHi86f+MeSgoufrK8DvikihU
         omCglJit4Ql5QbVhVOzdjca3dUiQXnbupFJtx8fWgyW6JgD3/2RA5Mpq9j7+MFO6aFTI
         w/idWylIrQuiyVmVRqelzLf4+59Q7qRrkXsB744hHUaEWMu5Dzq8eq8+WD5QoxbUgkCd
         JIqgsiLRXAFrFk7NYSlUsQgr9eNVL/KhWF2vi+uIGWCiwqczDgpLywUO6gBpSjcnb8s3
         hW6w==
X-Forwarded-Encrypted: i=1; AFNElJ/y+8aPe4ocY18w1VP+Gdme65vT9qSuXhEYxvCqbV5Rdj9HVuATHauHJNA6s/wd3jMjfAP8NcHacBBV30g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuwkhJw4Ij0rc4FpHokp2lMKv8WOF8fa8pY6eW8f35ws4mQqA1
	t4q9ZBn4hZ6Uek2kzTr04kcBsi3ckYifEGV0Ja0qKdB+CbXkRu1DRYgCae2SnvkfrobooXlk78F
	2lzcMw4lAwTjLAN9l7JeJkZZkKLkfAp5YSRSlhB4ffz31JKOg50kQsn3F/vIUSML9pI8=
X-Gm-Gg: Acq92OGCoQDvYEsotZ04y9Mq3SJ6gH//bE216nVyaBBedRr9HMO6gikzMqtvO9tX7Wu
	h64Wt0oB64Zkz+7j1+8NW4jI57jBAYhp8tYl6LPJO9vPzTU2iDInVqIg0c49k4nnN2zIE0DOX4s
	fw+nAhzHCtmqG9bE1L8QF+9XJ3eg2nsEp5+cWx9xV6Ijwt7re0v+nhBpuX66pRdjaUNJPGywfI1
	xQPSoX0K2IRPopXXsPFs3JF9Ueaa0zdIhR5dEsn4rSrkz7WdVIikJvwIuBADntxW+XKmZDhNBEC
	dCJcXP8KoXkONG6aLM+rGRv0e3XPfbgHHFgcswiFYFZ8d+s4IRtIZ1AwO5DhRKILNtLm+OolHWB
	Z6+7aDy+ddAxU0nQjW0jmRy2DPWdTlrfcCTR4JJnYPHgFyAN3KJnk
X-Received: by 2002:a05:6a00:4fc8:b0:82f:48e:241c with SMTP id d2e1a72fcca58-83f33d8ba87mr18630229b3a.23.1779174575620;
        Tue, 19 May 2026 00:09:35 -0700 (PDT)
X-Received: by 2002:a05:6a00:4fc8:b0:82f:48e:241c with SMTP id d2e1a72fcca58-83f33d8ba87mr18630188b3a.23.1779174575082;
        Tue, 19 May 2026 00:09:35 -0700 (PDT)
Received: from [10.92.176.107] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c7f202sm16288753b3a.43.2026.05.19.00.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 00:09:34 -0700 (PDT)
Message-ID: <f40798ef-e066-4814-a26c-729dcdb9f5b1@oss.qualcomm.com>
Date: Tue, 19 May 2026 12:39:27 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] dt-bindings: crypto: qcom-qce: Document the Shikra
 crypto engine
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
 <20260515-shikra_qcrypto-v1-1-80f07b345c29@oss.qualcomm.com>
 <181abfec-a6f9-49d3-9428-21a169a94246@kernel.org>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <181abfec-a6f9-49d3-9428-21a169a94246@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=VJPtWdPX c=1 sm=1 tr=0 ts=6a0c0cb0 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=nVgdB394IWv0AcZ3mQQA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: 4iEEiL6D7G8E1fMnAEoOUz_qTZsyCj9u
X-Proofpoint-GUID: 4iEEiL6D7G8E1fMnAEoOUz_qTZsyCj9u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDA2OCBTYWx0ZWRfX3ms+kopERbSO
 Zsi0/09GTG9Mab09+/zljtIQZ1cTru5fNiJsWbVB9KMh6OiY0zDReY/R5WKt8n3BHAz9MhMU6gx
 mKBVy03CL1lHhCiV2rjTKIKII0VjsvN446MWdLTc8raMvBEaWNolB1MlniQXgDLq2Be0Sd3TlTY
 XNJ0jLUFItDSk+o/rbQ5uxllbSVL57jpbi+BpOWPMMMCwJ7u9HmOSqpG6GtEqhsEWWzB8y1Yltk
 vCaslefIjRkcR+pyGybnj4GSxPl+vSr5ygbXNXyxyepRgqoCM/1zcjUlHs6Sd6VTt7hR7Vzt72D
 eNMiU7yyIHPo/UPUQEYl4I8ROVg9qOXfrDnnXJak8XAAxs12SH0l1Gi8/1o/xnqlnoJmgl8pVQn
 e8qIrepXjPUilRWQoO4AwGJw6MWj7UEA0J/bIbutv3sX7ZagMhrdF9zGDC6t92ZePmF2n0eTrli
 gWUQDOGnfODNwyJMsYw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190068

On 15-05-2026 16:30, Krzysztof Kozlowski wrote:
> On 14/05/2026 21:23, Kuldeep Singh wrote:
>> Document the crypto engine on the Shikra platform.
>>
>> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>> ---
> 
> Same comments as for IPQ, Nord. I gave the same feedback internally more
> than once.

If i understand you correctly, you are looking for more descriptive
commit message?

-- 
Regards
Kuldeep

