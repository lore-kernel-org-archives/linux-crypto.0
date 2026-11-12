Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794483796;
	b=fPEh7f2PKcF+7/eSikxTXPiZuqjjTwPF3h7ojkpii/le76FHSVObKE/06U564jsfy+wu
	 gSTF/6gpbkhrkTL86f/EzI1tfgawqOipqSEpQS8V3s148R6BtX73I4K/oj5r0MvW25E+Z
	 e1snJVUqQ/BdCRHSQa6VmVVniHcb8PLEw5a6D7XZl6bIbRneGMEx5Da5YMSDDaqg7fLzG
	 lxUabOECFhoZ0ls2fIml8JXGHaVmrOfkdIlpizLfI8ljU1Ut0sTZiZeOcvVI+wVJOnqRG
	 eTE3X7TEvVhppraK40FYKREErqY7mi2MBE67v1QIiCaucTF3f/rUCMiQIj8oxx+kFlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794483796;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/UsmZJteRaFetcrcRELxgEEeGkrhNoxIFJFDkJKP6UA=;
	b=i4cGAIvJng3F2TmZJt9kemFiOSnZtynLWj/W/xIq+VWW5KO3+BnL0IoXSNSdhx7H8NHp
	 eIEHNoW+KgAx/UPgi++E71Ole1Ak0S2KTttCIYmJPUm0XuJUhUDz4Q78f7+k93h7DK0ls
	 0cxHPdZadZBzB5XpMEMAMdQAUa6U2CzZev5ZojpbdBarWwp71A6dDpLZnxrAXR013aGPB
	 hgGolCgqXgTX06JtR56IVDe3b+qYV0nRlGWrlE0/OjySHb8b9/6BxOvAB6h8p+WXBih0e
	 femyUv1OyItf0HEO31qZferp/ZsJO1TdfiaMQqbOFqiJZUN6jZd/qeyJ18f9xLeJv1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jMyJkN6c;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dlNsDC7e;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412E2606A331
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 11:43:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 412E2606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jMyJkN6c;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dlNsDC7e
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC9CEj82514242
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 11:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/UsmZJteRaFetcrcRELxgEEeGkrhNoxIFJFDkJKP6UA=; b=jMyJkN6cn3Pey+t6
	4FJSf4pRce+aHImgnkYtusCwP5HDljsirOVP2QTdMrAV6kBAr7289H+ZHBoKdeOw
	9IWJZJJX/jOgqMN0zxnghXIn7ThYL2KLzrumuYKMLIPhEPlVW2HDS8u/Ao9M7zj9
	zrNIOGksuyAkbXeMV3mRZK9RS8YQEcRsnb59S9hhkZBhOoyaCHqJps38hV7qG/J3
	Xe0tX2YXi7UH3Cq9zjlNgVKQMzG+DERrpC6OVP6dqGgR6AaNYZ6S4DQuO2Z7Nnq1
	eKTroqerpmhAOp2aF3PGjbHQPNv4WxucwcLMG1jZyIt/5SI/oJ/pHcvdMri8hA3T
	4qeRqQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvwm1ud1s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 11:43:15 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b1755b2f26so2074708a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 03:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794483795; x=1795088595; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/UsmZJteRaFetcrcRELxgEEeGkrhNoxIFJFDkJKP6UA=;
        b=dlNsDC7efncryoB6kjy/7n+VYE/nkSwEwEj1uVqyFzjCB5/N7xOeOS2SOsotpnsmDs
         /zBKWzphEipaPiGEnIWVzkPXo+k6TR+iTJTXyct9EynZ954r/O5tKIkYlLXOlckIhDip
         mTihcpmqA/j8CmzG6aFa3IxqmQW+P6hwwURZKdpt+fRvg4ullNRNV5dmkq1TwSrX58oS
         qEm2sDrdgYS5pD0l3sLul99Lgp0i/jLys5hcOtpu8saC4qtWbaW7ozwhAI3dtPfRWQA6
         YlktiKdzCiFpAyygV0I/FDVdYtuq/+7XoV9MppP69D80tNZyf069PhumW3fwG6SmZD0u
         wK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794483795; x=1795088595;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/UsmZJteRaFetcrcRELxgEEeGkrhNoxIFJFDkJKP6UA=;
        b=sGhO2xYSuVcbknILTUDpaJGDIMaxsjpkSEWyCN3l8zXrTRZVcpKoW5KyEqqCVKQKqM
         uLU2D1IlVw4Wz8fu3IJiv8TFzl+5zkDPFJozyrKdC3Ze/5IrkHD4iM7wbgL1FCnV/Cnu
         fxdJcHs4jMlsnMHfbZWdeVoOtfPKO3PqEzaAhRfE9GTC9mfF+RVI/3ciUD9GHhDIOKdo
         tSNz8/TzrRLuS3A7iAZUzIYMgqiFwHvIUXGy6Bb+VCvYxpK/A1/U1SbOHh28fRiQg3kd
         zi2Ed5EzCqT8ZLxWbaroyIhwMHdetmb5KuysCLd3kWFr/eZszbeX8LAn0aHQ9OGUY5VL
         I9CA==
X-Forwarded-Encrypted: i=1; AL+hErHXTRybTxpQvG1O64gDhgQ7rImDu3uE+WHVZzO+Aw6sAno6Ni2uJKmdT3a2yF35jNCI3rOki5IGexTRVGw=@vger.kernel.org
X-Gm-Message-State: APuU4Z9oarsDG9NNPGT/sPygcCpgRmlN1ymvQugfzWAuAHIMuFvTOV06
	liCgPh9R1OKWOjB2KnwD+akKf6OWFYrc+Ke1FTEShUvQ+rD/hmXT2gKC1l60z/otmfI4pgzuydI
	cCoU0a65tqUPr67HIh9e8t0G1RMspteIOcRVzhRkL4qazVwRekoDbYA6XlTUdZ5tBhRg=
X-Gm-Gg: AYBFou10RBMFSSO9eHMCScbonaQbKWqd2Gmx7DYMC0Kis8skyK/Gg62N85NV8kEx0VZ
	aTPySMAjeEpl/7vVsNJBm6couxT3/Vm//SS+U4cFN9egivq1VxHw/5k9ZgU47du+JC3kJPuOoki
	FsN0ZREaO2U4idGpLmrIYLvG75MG94uUwhpJC9KAW4cxmnWDYKtGW6pwrCMcjA9FiVioZwflW9i
	vSL8P5h9MHq+yreydNd0uRs2BJ4Jam3va2rsXumd2S5cWpSKqgC5vp+yoOFpiaeTHdn+pD0Sqdt
	xei8ZMJTnY+NfRIG1fHWqC1r/yXuHzVcsfXeHw/2XoW0wTbugV0w7FAdhlawSmKdqDkv1bIyVwr
	bpgeRwjFcNjCUrM0aziavjRo8wkbHWklDYjSpCBxdplMz+deppsCBDbIvxw3b3tgxDpPKDjDjfs
	K1k10=
X-Received: by 2002:a17:90b:3c06:b0:3a8:7096:9b48 with SMTP id 98e67ed59e1d1-3b182df2f25mr4726551a91.1.1794483794733;
        Thu, 12 Nov 2026 03:43:14 -0800 (PST)
X-Received: by 2002:a17:90b:3c06:b0:3a8:7096:9b48 with SMTP id 98e67ed59e1d1-3b182df2f25mr4726519a91.1.1794483794297;
        Thu, 12 Nov 2026 03:43:14 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c8b2cdsm4350657a91.16.2026.11.12.03.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 03:43:13 -0800 (PST)
Message-ID: <d60b437e-b1df-4a9d-be3a-a53c2a369f84@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 17:13:07 +0530
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] ICE: Enable runtime PM support
To: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <CAPx+jO_ywfJUAGs6Zo8yJyTpqui=qN-T9qqWN2hKCyeegAeF=A@mail.gmail.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <CAPx+jO_ywfJUAGs6Zo8yJyTpqui=qN-T9qqWN2hKCyeegAeF=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=KsnYSmWN c=1 sm=1 tr=0 ts=6af5a653 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=wrTd7Yo2M8a-6LQTD2sA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: Wn2cVFGnmKJRwPw9U796VesufC2fD9bj
X-Proofpoint-ORIG-GUID: Wn2cVFGnmKJRwPw9U796VesufC2fD9bj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA0NiBTYWx0ZWRfX+zZeLFBe3eBI
 g+M9NZMdX985Rmi3sbx5K+q0IJJAAHn/aAUYq9PMzkwTylUPXZwFt8ULWm6bcIGihFospQFaPUB
 c+i1EK3zjoIxCVTFCpT13QkMiAgDv2jWMLO/eLl4tRZ5jZuUu3B4IEnuqyeiK4irxzJrMwFz5ak
 BJphf2AC1I5dKsbkMVS5UXd3PQcWYPCzJM1+sL0jxu75s+ObCLTb2AQxSXyD2VCxxoRRq66+DYG
 RnmihA6BCTjeHV/L3v9+FfgJSD4OqP8hWck2so7Vm/KBrjf88oHCx9PzVanXabYDGDOsFqAksuV
 3Bw1iDZa1XQxwmVNX+j2I4TU45X7ibtK/iJEMHItF1rOOXnSXayPpOMezOx01qWpLebi8bOwK/q
 6EE0gSx8sD0WMjJiStRAL8bIzG1yOCGFK7UCAx0cWr8MIQel5VQaLmk1Vt5lgZXqIQeZgWCS0yt
 g4bot5/nKzho8sKAVow==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA0NiBTYWx0ZWRfX3DkriWq7DsHP
 rXT6Exp/su/V+GNVNp7xEB3Zq0HfXYVpuaXwBDlkpz2woWOxM4U5/8WufTUvmpAor31UBpJwOru
 WjMeB6Q6uA5BmNu9xur1gK369yuTrB8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611120046

>> Merge strategy:
>> Patch 1/3 and 2/3 are storage driver fixes and should be available
>> before patch 3/3 lands otherwise will result in bootup crash.
> 
> Then it's perhaps better to send patch1 and patch2 first to get them
> landed as fixes and for stable kernels, then when that is done, please
> resubmit patch3 separately.

Sure, storage fixes are currently not tagged to stable versions in
current series. Let me add tag in v2 and drop patch 3/3 from this series
currently.

-- 
Regards
Kuldeep

