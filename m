Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0374F3AF67C
	for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 09:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776419666; cv=none; b=BBGSc07YKPdJ4jeyR1RAJISqZEbPDHiXal/hFQQqNLQrgtfddp0ne5cWkNUvkHmttyR8V5DwXhYN9+GxJNJW4VhI5tZ1chVljHC/K5wInEGZ8eKePOxmjBlaXB0LSVEyGbt0imDAptJ0oYyApQKNlzueWZ3qxyVxdC0wJA9fb54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776419666; c=relaxed/simple;
	bh=zY1uJ0AaPChwbCkJzKQs7C36HEuyLGmvoneiqqT47+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HIXpULxMS6RBJVhZyjCOJ4kIbXVAjgw5bGNEHTmNznsKTgz1SciQXB04yx/ZolCXK5B6QFnYY0Kg3F1v1Yv+kOoLQtLeNHCVctNSsDnAm+CEYUz3dFm1NkHP8ASBZ8Ze1VQlsZ/Ee6BQEGFpZ6rBGGooeUWec7+k0HP3LGsxvHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KyF7QI+l; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d1VHrUGm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KyF7QI+l";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d1VHrUGm"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63H8LJsT1872475
	for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 09:54:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TSqyZYtczbrMJAR9r8mAgtofBSnvKj7JQnZ8roG/Yxc=; b=KyF7QI+lyqmHgPTu
	v406XyggDMMwAB2+uUEPfBGpFn9/O5Yu1PozWD1AQ/GII6rXED6DS9Lmn0iHXy/O
	Afx1tuvUlOXoXl21LgEJtmSZjigkLQ9WcqgZYNnaZ5Ebc5CMxQc1en3SVvRnfZZn
	pmzeOHdTKUxup6DcLMzplas9ptesSk+ybXOW8PMgqIdOOMz70MjO4hzO87ncrRhy
	rGdLSl7YolSYAfdZfvIgKiyw88kVpEoo2V7inuD8TTRAHLtf/adRH6ZpjbCTTx4y
	5lkd0jSQyBZIG5w56iJ4w1NgLDLMPFJ2pXQH/IhyfbbsCXe4vbeFmSozadjTXEZp
	dqWcPg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dk2knbfua-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 09:54:23 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b250d3699aso9956435ad.2
        for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 02:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776419663; x=1777024463; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TSqyZYtczbrMJAR9r8mAgtofBSnvKj7JQnZ8roG/Yxc=;
        b=d1VHrUGmHMHxZfysGI4Ah2lpC+L9QRXMXSCs7FGO0LebxKwSZ2bTaxifRul8AKP8Wo
         WDkD3f0IBE1CR9yVWgZWl6Ce+8AXatkHE1F4Auo3UCieVxHwZ0pScg7+rIrMT1dTQzMX
         O4795CEu30OMRdDtkyL9j0E1cr0f81098ehhcRrtIrG5b3vcAiOYFH1WhCRN1CMd940S
         D8vdfkPSwgOlE7RmR1ZsSVciExWboV0JVL/uJj6noz/FNaXiahAXUPYqLKsQmluHlo2x
         pbGl2khzcx6zjUpawyUysoCAscpz7GOEHKaG80HU+Iwls2ATxRxeqPI173Az/ZqbYxDe
         gIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776419663; x=1777024463;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TSqyZYtczbrMJAR9r8mAgtofBSnvKj7JQnZ8roG/Yxc=;
        b=mbhH1U0paEco6xHIaYfoKdJgR8gvNM7/56cQ4vf54vZe3YpmY9ypHcXTqOnr6HCQ4x
         KQTFGkimfodR7E/zYz/PYabXpoD+Y4l6O/Pcv4JtPhPMrADo31/CM+bTUn2jL2+D4AWe
         uyBPIqO6z9uPQefIAZlZn0y2xWvh8rapq+ynbZcsqX6ulvvevz8d6rXovcGqGTshytdH
         nHgkUqxXn++dQ6U52dxHKBXReTUVPfUod38VltmbmrjpfTbz/g4D7nbmi4dwbTvzjFV6
         tR6WH3q62tmbxvuAQ+IqEWZNdO+Lg515Tl6AKdryg/sYuewZ6AkKDqdFrKHV0dbYNAAM
         sxUA==
X-Forwarded-Encrypted: i=1; AFNElJ/+iVF4ySetGlWYW9Z2+yjyC7kHFR6pfohaW91Sy+fl48KV+oaV17Jn87KDxUJqadVBCG/RX+7Y4FnLgQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqKHdcSY5iAl3Ucu0FFVMNXM8mTy4B1zkfZG2iPnbYpgsGWHSb
	O71AAPPZ5pC6u/BZlmMlpgz7ZQa7l22fZKdfCZqXeB67xppdw6y4xFKABnTkkiABU/BfN283ydE
	KL+FtehEUN6syFSG8+00RwomXyD/aZ+iNbdkHSCX5mLrEHciIL4P7XOYRCCZLmFDvkfU=
X-Gm-Gg: AeBDievW0d4q+SqEylHNT7HBkfKF5FBdnoiAg4yvEuKv5C2hhPgwVRRGRuZGXZLhrf3
	1zLjSkzuBPLmLn+xmUGtqPWjQQiBrlqBind48tvzzlKL9Gu3/XdjAmvRvRfLEEbRNuFEsHhEN3j
	Z/GYfUQAjmVvsZnZwjbtdYNI4odtHsPhswZnIlsALARHTivnEfd1+RvYwj3qSGjgrQ4zw/n1e4y
	vF4sWt4j7RB/qv6lleQx32frcDNT5Bjeu7am4xbHqV0OuE+eBfCJNjUURE82LzWfcQvlKrrjRBI
	JdlVS3JF5BoHqA2JvCLcjSS4P4hVvtMZhFRHSW34gkzI6S1PRSBhNoFeEIB5q2muv46nLcpE12F
	RfsU5CANnMnLjhgOudIrVums7IGKm9xW8K+7wTj6Ms0deed5W1c3w/GVDlklkVw==
X-Received: by 2002:a17:903:1ac6:b0:2b0:c90f:44b2 with SMTP id d9443c01a7336-2b5f9e8252bmr23808475ad.12.1776419662892;
        Fri, 17 Apr 2026 02:54:22 -0700 (PDT)
X-Received: by 2002:a17:903:1ac6:b0:2b0:c90f:44b2 with SMTP id d9443c01a7336-2b5f9e8252bmr23808055ad.12.1776419662459;
        Fri, 17 Apr 2026 02:54:22 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0cbaasm15911585ad.54.2026.04.17.02.54.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2026 02:54:22 -0700 (PDT)
Message-ID: <3b65a6c0-bbe4-4b57-aea1-f4070ca1db99@oss.qualcomm.com>
Date: Fri, 17 Apr 2026 15:24:16 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Document the Glymur
 crypto engine
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
 <20260416-glymur_crypto_enablement-v1-1-75e768c1417c@oss.qualcomm.com>
 <20260417-portable-proud-dragonfly-6bdd9a@quoll>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260417-portable-proud-dragonfly-6bdd9a@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: ufiUFvmzZGiRUnZq3eXMCwxZXfonNUpy
X-Authority-Analysis: v=2.4 cv=XNoAjwhE c=1 sm=1 tr=0 ts=69e20350 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=CM-kEsVbLXR1AP68oKIA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: ufiUFvmzZGiRUnZq3eXMCwxZXfonNUpy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDA5OCBTYWx0ZWRfX0Qxey7iB1490
 5CkEM+S+SJXQfDneKOEhXwh0qEO2wiw6gVjgpxlwlXQvYpRwkPLEcK7TpT04pA5tp8BLcKRUGqC
 w0SBBWhL7cZe6rrnU87tXJWHcOkIUOUgMNjuKZDNaJ3FADw5fLOAurD3y64FTmRDJziXegDNu8l
 MFPE9+0sNi2c63FuelO0GlJRRDafXzcnCcwM2RuXjlASlIibQmWGjUdWVDa0Y5az1zaqOr0WD/c
 WlPW394n3fcpiXls6TmamTEHds+Zz23hePS68MSYKLtI7aqXNeAH4RyBWigNLCUymOxT1layyQh
 n2pgZgiIWAmAl1TDPUPc5poYG+oNJe0oK9fKsy0rnb+XZmIG1xsBm0Hbp+cYFiWSEAnhncoL4nu
 tBVjNPbQz6AmcsXF/5uaTcfHDuYq3aypXaTreHM5dOpmajzeGMRaklFi7cuVkvX567uCymynnod
 desJuzJWEFRoqz9lGoA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_04,2026-04-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604170098



On 4/17/2026 3:17 PM, Krzysztof Kozlowski wrote:
> On Thu, Apr 16, 2026 at 06:37:20PM +0530, Harshal Dev wrote:
>> Document the crypto engine on Glymur platform.
>>
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
>>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>>  1 file changed, 1 insertion(+)
>>
> 
> Poor commit msg, but none of previous patches were doing it better, so:

Noted, I'll try to do better next time.

Regards,
Harshal

> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> 
> Best regards,
> Krzysztof
> 

