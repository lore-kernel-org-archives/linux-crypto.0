Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2B54218B0
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 08:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778835221; cv=none; b=s5TBbQf5rMrLw4RAD6iRvNDIAYGINznfDLEVtojbfCQyvJMHGet4RPEQNpTvW1zKQb3wjFoH7oEtp3bBWaPoz77TeJRc/g/xV7qyPuNFYb9sybDdX6x7fYwep0ti2NdGSzLu6GfzP2Q7+tHS+VeE7Bs2n4851CerUvP/8Hu5/Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778835221; c=relaxed/simple;
	bh=Vu/zUiuQtSz0qzX1sPZPdPeJG0v+/EfU8BrqUjfe6hE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RWAvS84De9D7EAIp1crvP7EdsD7Sz9cQbV8qXBejlNhrfzCOINWuIqn4UESU5dOP+vN2WXVbEpGskAep+h/J8BXbUjEHwy6ACNQC3Mhvvup2nf+JYizfRp0MDywnA1H4Ft+bQLlPMRQ1NqTez9iojD1qtG3AeSQ81YQlJKqDQ2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aCtwK+5e; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D9yaoV5O; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aCtwK+5e";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D9yaoV5O"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F4oGwl655515
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 08:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tH2KVZjWsrVlDUo1bDYgkQP/brqgWYGNDeftetOYBH0=; b=aCtwK+5eQdOW519g
	C+ciCGSGioEVKu7PEssJSkrXzNF87eRwrVP8qmR7JxwARIb3llVx4KbEXi9UUpIV
	s0ni8CX/P7Uf8ct/2pvgCC1VNo9v7VpVLhYVi1vgsYRVV3/tXLeO6gM9ziMzBEpp
	LM3XIft7n/cNgmrtECX4lxJMlyULEjt7Yy7IroM7BYzb2YiFHeQadVo724VIt0c/
	TWtbtGedLKVbsNIqDnGh/uGtGiun7fR7KfMCQz5EZ83K2Xme9tA+WaDC+8JR8no8
	mMK1PGd9adc4+wy1Fi8sCm0dfdcFt17eCE68wlhgSmXkPD6eXeClD4lb4rw7e1Y0
	RtsoFw==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1pthng-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 08:53:39 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-6314a8f1befso362748137.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 01:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778835218; x=1779440018; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tH2KVZjWsrVlDUo1bDYgkQP/brqgWYGNDeftetOYBH0=;
        b=D9yaoV5OA1o+EjoaOoT914DfN8TfbH24PeqK9s9FX1GPLQlPqjejPOWEP8OouShD8a
         VWa3hS+iPwrVxJR5iiV/mVKJAMui9M/8ZiEy27zbIdaeES5mHjIiWJ2M8p2rY3QITHwH
         FnZ8nXZXVDEIsH0WnqU/7hb0jULnIFbZnO3jBu6rH1vSXJI0W40MXeY4ov2LlReIF1zM
         UC3kdPHXdXCj/AALpCUZtkqsBCZP72cKMZtSuFgdLhTj4dirL4jKkGl+dMOXXMyD/qd1
         Txd7f5YM46ljIDa3Gr/pku59SN6M2f5R3pfigBbxaU6dSQ69W3R9evodqG5El/fnF9Gx
         KksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778835218; x=1779440018;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tH2KVZjWsrVlDUo1bDYgkQP/brqgWYGNDeftetOYBH0=;
        b=mXs6laConhZCP+BKvkba7k07AHRlrUmec6tAU+geT3tja5LXgwXbpaKmJNmIPc9DVb
         2YuuGQhJdGowHdAM8BrLEehgBBUxqJu1OxqZzkk1U6gGLV7IZsZjCKigbo1+hr0v8A29
         lpconrDnuPxUo9w8+7HOIQnMSO1ce+U875iexDkbIP+AaA5jNaXBLJJ7VeXwOyubOF3l
         Y7QjfC89gmb6rGJ4T6g6VEqms418+nvjgd+0v4XTmmlU471fIRObIvccdvgqIdboxwMl
         XbT0IRAXsy5jjftkRNqz08O/Y/f/eTi+GpYUaq1Wu3e1BICKKCxAYdqp/DwBPckIJWJN
         xoUA==
X-Forwarded-Encrypted: i=1; AFNElJ+MK00bszT+dxFVxdUB+/97vbr0WMNiGE3wTFvTw+gBFvEHi80TjW60G4nVAa1GCCYPcbw/uguKvwGx4CU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcejsJuUpovda+nyBT2kst6CKFPGl4WATVTF40u3Mm/cBnzEvF
	vm91QpB8x265HV/mEMfMQHvh7zRkttuLUkzuBa/pm0x7sKKadv0SzvJ4GUkwFthoagB2AeYgOnM
	gjePisSGrqEEKobOpCVppfgM4pMbAK6QUYOCRRjgb4tZGSw4uC94lFBS9wUr1/32gxT/ALMRJ7/
	I=
X-Gm-Gg: Acq92OG6iG/U3l75jM9wyfLdiq2SuIutD73E9wE0iwor2zlJgfUvMsASaetEr9yjWrm
	VJEs/fSepoEkVv6iPqeo2WSYoX6Zi0gAOqQ64veC9jH2LZGh43AO7YgCRhJhO7HijbKJNEYzTnj
	bvC5QHa7w41W2y62TvZS/afGdP34pLslM3WWF/eJjRpFCcovzUlG8fOyigZwWXOMbuGvCRhQRqo
	SJ2x0bFWTo6qcONvxZpItFeUWVxpf/cJLKbormFHYzasmPaYIFIT2M/X0Fgvz1X131aj2uASqkD
	AWfjP+07pKHTFwguDDtoheSJFJpq0D4n6LQ3gYMygq5Y+DpSIZLNg01zJop/kyrHnzjvgIbYSjR
	LKH3aa70eDNSObdEFBFy/lCVfCQlLxdz3cKb8R/OuKwrhZckv4gYB3wzqIq5XPxe+9R458O1VZA
	cUlbI=
X-Received: by 2002:a05:6102:1148:b0:631:2a09:94c0 with SMTP id ada2fe7eead31-63a3cc0ccdfmr363784137.2.1778835218277;
        Fri, 15 May 2026 01:53:38 -0700 (PDT)
X-Received: by 2002:a05:6102:1148:b0:631:2a09:94c0 with SMTP id ada2fe7eead31-63a3cc0ccdfmr363773137.2.1778835217880;
        Fri, 15 May 2026 01:53:37 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4bd2f5csm195204766b.3.2026.05.15.01.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 01:53:36 -0700 (PDT)
Message-ID: <90398d50-6674-40ed-8ace-a2edc3acca97@oss.qualcomm.com>
Date: Fri, 15 May 2026 10:53:34 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: shikra: Add TRNG support
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com>
 <20260514-shikra_rng-v1-2-4ea721a1429a@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260514-shikra_rng-v1-2-4ea721a1429a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: LbFqTmMvvAO8C3vXgJRH7N7h6QM-5NiC
X-Proofpoint-ORIG-GUID: LbFqTmMvvAO8C3vXgJRH7N7h6QM-5NiC
X-Authority-Analysis: v=2.4 cv=GrhyPE1C c=1 sm=1 tr=0 ts=6a06df13 cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=ziO0MC-R6CyBOfdU2qsA:9 a=QEXdDO2ut3YA:10
 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDA4OSBTYWx0ZWRfX2kKzSTEdyVKv
 MfFpKhYXeK1WHtf4wL40vyiyEAClQlI0Ip//vr7Mtp0W1AsbekpGvrAGCbiksFjJ+v/MAlyf/GW
 UkcYdtfLGLIZOfzuyKq8GgcPDG8Rh/m/UykBv3Q4PVZ9kO60HJ48X1JnjOJjyyJrH/bTYyULF6I
 PEBPHj74yTBgc/Gu2FsU2LKAlss5mjImP6cfM8fBa08GERf4A/uF5gbeebYVAs8Qz7G3B536Hdo
 WvvhSoo8onDeQxEQKbPItokIDXOrnVANpatRIEbSbhSMd19PX7TFB6CgIcyj2Ozl2oOdeB3UW4H
 CHrGXbfaMpvyiBA3gwxyhxcM6Sf8FUqwQnX7QY1O16RSU47H46YOffosrWh4fOB+7IglbGdYBCA
 V54mn4E97ozLpvxayE2XdpHuMFceMXAZC94FtQehO8gM8S00A2wL/wYSbloheMqV8dEOWH39qSr
 q+lxF3UjdKWfiDKakDA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0
 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150089

On 5/14/26 3:16 PM, Kuldeep Singh wrote:
> Add True Random Number Generator(TRNG) node for shikra.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
