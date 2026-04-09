Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F178440DFCC
	for <linux-crypto@vger.kernel.org>; Thu,  9 Apr 2026 04:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775708126; cv=none; b=snbYb3RKlcH2aZzxHNJuEJ6/NakNBx/oltuma+U3uUwSSNOgkVqjiDBjrwO8hSBsZPAzKCXFpl/CIpqYaS00eGR63H2yYOOC1KcMIMb5CBMXdoEg6QwtS4iz7wMo57T9jOUnXgPNCUL06U5VF0gT4gpePs8B065cLwZzOptF4QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775708126; c=relaxed/simple;
	bh=xcM7TYtOdQQWWW6utBXDyke3h4LT5QOMSWQ6XwP67Q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWb8l55yeC8y41rgYocpm72sLSMYMrrZrzMkbM6UQNl4puFBzXn6uuu8oyA5b2GICs4P0ATN/dbo7xjCu7rBYpUGucj6PfZ+JEXKnmpLi2wX1rqibjJYsc5LXgb+boXfIArvGYk7wu6H25SrUi3WbHYktM+fqF6VN+Az4ppewug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H4nF5jMt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IAUvmSOd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H4nF5jMt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IAUvmSOd"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638KwLlr4107640
	for <linux-crypto@vger.kernel.org>; Thu, 9 Apr 2026 04:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	z1eDqQSPk8E5KTQI40a3DvbWRJFPZD0z6DXQp1BfF2s=; b=H4nF5jMt7EMS6wje
	x5SX3/0ZUPtAfAfJuiMOWtKILhzeEha4dsNvSJw7dMp9R6nYvhZIqzoKjQqpaMx8
	tiEioC3c+dX4TO4fszbq7ee80wAqSCjxCq+kZzzETes2zavnc8eLC+eLUBCvQe4C
	FotGz2PjFjm9VvE9gytKnFkphCUIHKVBUBsvXSeoMmObCBwJE1DqDVMKpqzsHHei
	iMEK0v67knQMaX7sqJqmP9QpvIQu4FfwDFm6f6qydGIRVOASdjFwzUSm3ms8RsAM
	JKxbx3hf21tOVAUWy24bLOfUm63NTRxuXnGNDsGvH4uury1jPD/+lCa4GcNC/m65
	AMFUhQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ddxhah51v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2026 04:15:23 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b24af7ca99so9260915ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2026 21:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775708123; x=1776312923; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z1eDqQSPk8E5KTQI40a3DvbWRJFPZD0z6DXQp1BfF2s=;
        b=IAUvmSOdUVfHdu1dtvHcUO4RJ8cxn+J6af/Hqwcc+k6t5nu2bLO9tWa14z/Hlg/79E
         sMy61b3MXKPtIVGVk+oDYMqUCTpTMIYFv1S7eobdVlJNznggZUs8RcqasWZwDUCONyaP
         ocOfjzuXFJqwV8K3h15PG3cBYoaEsmZKCUZHuNf+Z5n1uS5NVaAuCd4Ra6ACM5jXto60
         R5E+fnAj3zV+clyTjga6LGapShBXEJK83etXy/TXKdumNNTtpNd4irBmG8zctjpBBX6y
         uZy3emUNDGbUjDJCfD6KyEi0oyXpLBeSrEBHtFxR9EZs6/bYbzVPCFwcuSPl6JiKDQ+Q
         qiuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775708123; x=1776312923;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z1eDqQSPk8E5KTQI40a3DvbWRJFPZD0z6DXQp1BfF2s=;
        b=WwjymUV/TMWd2HU6qbrGUHKaflH6a1Ebd/YnuTvqvGsLE8BrYeuZ6RH1g4xvy5ACi0
         Ogw1C5Lt2OvRL731l67JhcD1tia9cF9fNHYgl5Hojso+hU1bZEvRXmNJPjqKHD0mf74F
         ouRQBLOci+CZTGYtg1pcLcsHxfFPbkA90P63HOSScWAPT5CuAwV1lLW+RzF9wENhUuQh
         eR7X1tB1OGK92x+3/IC5KtrrSIcDAFkGPW0vmrFMYPT4MnqGEa+erXaBp+Z9Vms2n4Kx
         PPPyrfdxogKKjO29vVGpt4tk7kYm1qVeBcpyoN26nszgvr74IDuNbUINuQ+gNODByOxB
         4ORA==
X-Gm-Message-State: AOJu0Yy3K3WOUD1OFEBcTBa+ZGFHbJUKGJy+5dYW/oSjsYRsyj3mo34e
	sggDVRHNROkq50HfV96t5ky9/I/xOpssBzUELfjsqOMLwbuN5fqRbjs52mHD1Sc4ENifiXZnVx/
	+2Zua1/c+AdBxJOK1cWdqpQaXhiu0FVnehsFOijrxaGFXX5OlIea1tc6/u6tW5t4T0xc=
X-Gm-Gg: AeBDieu1TIDsEhLaymyoj3hYJsqgEdHRt1aZRlU+b8og8PegDlCb4vTk53xURnImLwJ
	Tm2xPZZLfLH23Kqc2/h/d5BOcYoxLMxFkQpmTiAmwbY8I/NyWomU1fOqhYIB9L+2C6sBvGMRclH
	nkxoAxxtK+nm5Y0iDI30Jvie919mTA9frCAHV5vGrupShTtXrvrbs/I/G6h9sjU6mCRxWRJBmzH
	ysJFAWqsMqK3wi1csXgtZ6Evnw+GN55SxUPP/hrngraIJYdVHbPVhRRJf3o4gbFbpxP0+Kksk/S
	RBBHd8rQ8+IJOGEMdQ4hW9GSnVJeVNiPcEdHwSmQU4zGJN5hVYzolfE0R3Z3UdRwpUrPmb+CviD
	PfRIJX2JfpXqQvuz/6eYsCxkntzVD0OTWCbtwIVayNptSWOkNt3cb
X-Received: by 2002:a17:903:1b70:b0:2b2:4029:d77c with SMTP id d9443c01a7336-2b281763373mr265628325ad.23.1775708120982;
        Wed, 08 Apr 2026 21:15:20 -0700 (PDT)
X-Received: by 2002:a17:903:1b70:b0:2b2:4029:d77c with SMTP id d9443c01a7336-2b281763373mr265627955ad.23.1775708120443;
        Wed, 08 Apr 2026 21:15:20 -0700 (PDT)
Received: from [10.217.223.92] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27472d098sm211355975ad.13.2026.04.08.21.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 21:15:20 -0700 (PDT)
Message-ID: <5f58a4b7-312a-4cf7-b920-401bbe757e3d@oss.qualcomm.com>
Date: Thu, 9 Apr 2026 09:45:15 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: milos: Add QCrypto nodes
To: Alexander Koskovich <akoskovich@pm.me>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260405-milos-qce-v1-0-6996fb0b8a9c@pm.me>
 <20260405-milos-qce-v1-2-6996fb0b8a9c@pm.me>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260405-milos-qce-v1-2-6996fb0b8a9c@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: LqYfW02eGqT4u0dmER0a8CRj0TSHbAdG
X-Proofpoint-GUID: LqYfW02eGqT4u0dmER0a8CRj0TSHbAdG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAzNSBTYWx0ZWRfX3K6KJlT+of+i
 YcYLHR7iBWgdb0/NCWxINshxR240SBplBcT5a0RQJrtVxIFBM3Vk9vQ5djemDvTxGnne40os97D
 nrvV/GxxhaqouQT0XtIabnVDwkEW1XMRls091B6KGMlposN8XAq+5OKMapVuWo2eJBSA379ZGxZ
 FJXf5Dmmp49UNY8ZLzcM3Y31PlRoo0c5oG+LpGcBuPJrwUhT8+pMCOWUsYPFOmJc4TLrs/leXx7
 EVyXxTLmgWqfyisNpI8qxJv4Y0wTVd9JrePPCNneksQN2aCqqPemEXgTOknohWuXmMMbdnCsTBE
 4Q1NgL3oj9xOz6hOneVpMrwrvMAzTeRQorKTKuEZ0iixTC4kM8vav0sVAVqRZcwE3rAVkYZJt/e
 xejnubECj4nQHRlVrLcjEcD4+xFnk7ghrrHTNDNKcnmapzkVS8ZelXhI+KZyGrgs9vj1hBYbkHk
 7XSNg5Nkq/9GcfB8OMA==
X-Authority-Analysis: v=2.4 cv=BefoFLt2 c=1 sm=1 tr=0 ts=69d727db cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=TCpjqbDHjloqY1tG7BYA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_01,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090035



On 4/6/2026 7:40 AM, Alexander Koskovich wrote:
> Add the QCE and Crypto BAM DMA nodes.
> 
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

