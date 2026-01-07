Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB1332ED27
	for <linux-crypto@vger.kernel.org>; Wed,  7 Jan 2026 13:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767793669; cv=none; b=fItbgFUFUU045sLyOaRRELpOJAGOkffp+SSwYtsl0iLoF8hVO95mSJXTFdSYwNKALTJnQUAGme3WdHf8Ey/c0WalZMI/NcmLHGgxrf6RHel0sq4AqdBHpuFAC5k/deBKX5ClPHxJ5rmnf9cCCviOZlpA3nwrqyWZHFbJ+SdFJh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767793669; c=relaxed/simple;
	bh=VGE45WNxQDTO014blHHjIi5tZVWuHW3PG7dXHce6NLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WmBSz21I9E+3xSSf0vHS2Sig4ghVgeha3tXOTO7q9BcIKKM7JY24tIZaz50dYGtfwBYDASiY24uXXn+OcOls2LzmO6GU6n/L3zGAdmngWpuO8nFrGD6UwcacRbgW27f8saw1WdrKBxd5vCQgUoDxot9lPZQRWe4CZqvLNnZnIaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lWviJchN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ReiK0p8r; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lWviJchN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ReiK0p8r"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6078dqEv2577905
	for <linux-crypto@vger.kernel.org>; Wed, 7 Jan 2026 13:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UgZSlnstuL+bWNOM3fLTFdzNQEvh4E0HKjNHVKtgJqc=; b=lWviJchNA/PsdJa2
	68HBFGAAEZATXJ31rW+2RG6l43QqyyRaxzF684XJltEXQSM/ozKObb9cw4aBVQpH
	aWTUCpkY7u9lVShSCiU8NyIbZtzl+Kb5NljkVbDKlx3x6xLL3ZME8NFKgL2XZNHz
	XWqL3dpqT74RhVzHVCJyvzBDMRPw2zZhrXr1qGLIPo04Htpt+kHmU7pzXK121ySt
	46ymjU6S0c79H1QjB4Qn33d/6CC1z1vlTugIxOV6l9O+WuApMaVjuEbkYi1VJN2d
	sLswJmRgRDpritd/ExnaDdVPkFVGh3WOHJxQD42tNFMuka43qg7ikNffbNf8XaD6
	YpCB/Q==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bhm658w5k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 13:47:32 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b222111167so38858285a.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 05:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767793652; x=1768398452; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UgZSlnstuL+bWNOM3fLTFdzNQEvh4E0HKjNHVKtgJqc=;
        b=ReiK0p8rv6lbD4R1+H4CcSbkWKoBEZEQNOz7h5ZTQiuh41UBCPzS9p1/KiRx/nEar3
         KMwiGmXLRR5AC18mK8Osi3xUwh1sQkzaDYt5gmiHzb8MHg9lha0O+5uzRpaB8so5X8IZ
         XuLcD+UBFYXE96gjcxccFSkBd3Bd4m0t+Jd0mf/O+Um8w7lggIueVoOzug30GnCu4yfq
         XAWg7rIhP6sD1FFzau/xX9CIIr45q7SHRVyJ3nMsaYzq6CwjilW6TWIPwuTJY203MJth
         Tvw5aDOnNcOiLNYU50rjkwlTyQt0jcMNRJjMwPe6uWUj5IXKFQpKOb0Pi+AcDg+QtHQB
         9Obg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767793652; x=1768398452;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UgZSlnstuL+bWNOM3fLTFdzNQEvh4E0HKjNHVKtgJqc=;
        b=IS7Irh4QE9OUaoFbjkO+RCXKzjJl3QG77x2HeGSvdCyVLP1sI5PMx3y9soTeu7q7hy
         G516zxWI52LUJC2oWG0wwjK/uKlB7euq4OU1Xfapk8AfVyW43NPpUfuBForNNTpe3HPf
         e7LfLIUl5KGog1IBmE33WKYDFhrqDOoyrEzV4mE0ZDVcAN1bIeeSF1XoB8bTReagPZ+v
         9tgoC4u6F7G0ecqA62DRornDtD110eDtd3gjAbzeiHP0jUdUTEVFlz0oDlZelvmM78JD
         /DUk5mD4sqvqYGNjqioEm/hUJgu7dxk7yGfqy6gdgHKlVmg8KAfG81jtHFSLnk32LnUb
         fQ5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUYea7dOVQxjFweVjVJ0mKTOsDCu2xybD3EAzTlzOTyRXj8axUu3AVWbNotXgLGoQtwQHE8pwIJns8Eemg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw87aMgZunkj9e2KwbnOc7dYAdcXrwsS8vd85V6JlcxONF0dDmF
	ZlBV+MjmpJkrCNmz85IlZ6JjnhxlM7JfA1pBL2CgkvEnEXDvx3mmr4C3SZd1X3u3zPGWf5+jhmg
	nBRnnsgZSUkUFkFLxdXqRh8+UaXKFany0w+pbDeuTQ3i9mnO5OEeXcxUeO+54zAw1N2E=
X-Gm-Gg: AY/fxX5iCOgQwrimU1KRv1ehSAy2iOBqAwi9w587gd30GA12OBSRQW03+ZJx/BWs8Zj
	LOgnMTPehM4CYFbcCGvYz6VqFdapKwcGmhVGs44ljM3fAsWhQx2udgDm0Tc+kQBYI/eOcPUqdzM
	NxvHdEkbC6Mjq4iPo+yHk+GywfyhQDjelkAV6oHtOVp1RjBURyr0qU7YxkyuVmbwLhGOwbIK+7K
	XSKb+aZQMNH0l53XsCVOELVdznORXNnvv0SnO7tJYD1QQVYdCtP6xF1nLjAsFfAC7UjzOEe3Gsb
	YOHpaXqnhiWsTliEfm7nFvW1ULQnD4/wj/M1Mb/8z9td5b0x5TpG3pzwiBeUVneZbsBwSkIhGX3
	a1C+TvzjciI35UUmAPG1M45nhtFKbB0zufcRPZIHLJf8HfMxgu2nRy/60V5UuojvcmCo=
X-Received: by 2002:a05:622a:143:b0:4f1:b3c0:2ae7 with SMTP id d75a77b69052e-4ffb49a0042mr24372051cf.6.1767793652357;
        Wed, 07 Jan 2026 05:47:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEqSd85JPwhEJMYgx6YhAsjKJYD9xSuGfuAYyKuY5Za86pnaJzUy8cquRaa93zxCj87b0H2UA==
X-Received: by 2002:a05:622a:143:b0:4f1:b3c0:2ae7 with SMTP id d75a77b69052e-4ffb49a0042mr24371741cf.6.1767793651855;
        Wed, 07 Jan 2026 05:47:31 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf6d5e0sm4665696a12.31.2026.01.07.05.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 05:47:31 -0800 (PST)
Message-ID: <0b27c56c-3aac-4b26-80f5-f8cc52abb66d@oss.qualcomm.com>
Date: Wed, 7 Jan 2026 14:47:26 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] phy: qcom-qmp-ufs: Add Milos support
To: Luca Weiss <luca.weiss@fairphone.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-4-6982ab20d0ac@fairphone.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260107-milos-ufs-v1-4-6982ab20d0ac@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=XpL3+FF9 c=1 sm=1 tr=0 ts=695e63f4 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8
 a=RTUAgidmgk2qeza8I2cA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-ORIG-GUID: 3cCSN6siG8bXRnG3q8vzFhz75ck6PLx7
X-Proofpoint-GUID: 3cCSN6siG8bXRnG3q8vzFhz75ck6PLx7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDEwMyBTYWx0ZWRfX1LC/NJyWscr7
 mVU6fQ+g2pIGAm3CK4fqn6T+2UlpXmMc1p0831e4OrsTm3LfHcN4UtdtSfSqBn3Oip3QVk6V7W/
 EVZZ6gqSuj2Ios4mbg75NKoeyLHsQXFG/09iTtyt1xjz+d1ZYt4KMtkCgXWiFxwguyUimximRqk
 hLllXBGM42AS7NIQoJrPFLVF08Z6njXLPdzLmvHUsOaTBL7rt7kw2f8AFIfec2arMgSHzwnlqFy
 6nv/vNeAA+31n8PP78pvpNe4X2yfUGHdwh6IdpQh5+I5LRzZxj8UR+O+Iyrp1PMPaOSWmYjP+ZD
 uSam+Cr1QqmTHa0290fgelYLlo/60fzEg62pB1lahsIzhJbm4LPq3NxW6OTQZi/2ruA4tva1lBc
 YQupLlbUIbVf6zTotJzuOIJqMzOYD7nCQCUvXCyCoh1aU2lJgLVtDdSdUd0sqb9XyzEQjNKgrn1
 JcC/LYzRkGVrixE/VKw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601070103

On 1/7/26 9:05 AM, Luca Weiss wrote:
> Add the init sequence tables and config for the UFS QMP phy found in the
> Milos SoC.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---

Matches the latest hw team recommendations!

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad

