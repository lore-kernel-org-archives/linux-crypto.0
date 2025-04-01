Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A334120D4E1
	for <linux-crypto@vger.kernel.org>; Tue,  1 Apr 2025 16:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743525638; cv=none; b=AoxyWiLMjA64S77AUj/CeAHQmzjlqad7qOlFoQJDKTeXedTHAjd/loP9f3Gg89dqHcPMGg3uG1gxAjnOK/5uN2w9wLoLsSdioso8wsBTxSHZQYLgKiLhH4RZU3+91vQSulvzZ9JgoR03U1vSm3vsmdSl+u0vp1hmJqJWQsqvnSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743525638; c=relaxed/simple;
	bh=UHpWWs+DyipNZHEV2Nkr4YRS5WpwRh+UNqWpXhbSsXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YE2n0cxkGz72aldI8gkx3uWkRLOfotAs2Fko+PG+hpRVXFxWnR0UM4t8nR1Q+xGjYZTPB9BSSGwwnCZi4jAdQZ6MnTnK32SkcKlEt4s5yaMCDKoIbU9svJDXrdbU5RUedet5A5qgL7bUgIEze26IxSIMC7zBxfNEds2jJjxONlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a70nKcpy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a70nKcpy"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 531CBwS7015028
	for <linux-crypto@vger.kernel.org>; Tue, 1 Apr 2025 16:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/379CuoW3tzmnDJsyDy/0ujjjwBPjP0Zru4t6cZwrYI=; b=a70nKcpyHh8Ft3MK
	dAD1X5izfpBIhtoGopYSOCahmi0n/Sq6Nkx0hsZlFYduFuTaETSouFmSZjc1AZRl
	V8xXi1mMY+bsO86eCY+XYoKBOwdmMXaWGW7XRGrDRAZV8ud2Sfemshdks444K2vo
	TpKaeqxWM5f1Yuo49+LWgWJr/MbdgaSYD9UCDNGB2y5GQlFel6gOn3skxSyAvo60
	ruOzjxomi9pBdxTKhTpduCIXfzjl7FsG1KjkjeZ93YqL0QF+1d8umK/JpQSLrHIE
	6k7uwa3BW7PJyaWjbJ62qeWSvkfjx2cLZTkh57ej9u+8lWJw6urK+hHaUyy5SUs7
	4R52yA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45p7tvgpe3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 01 Apr 2025 16:40:36 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c5466ca3e9so34975485a.2
        for <linux-crypto@vger.kernel.org>; Tue, 01 Apr 2025 09:40:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743525632; x=1744130432;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/379CuoW3tzmnDJsyDy/0ujjjwBPjP0Zru4t6cZwrYI=;
        b=CzoHTLDonBuCRvooRI2anZBqOz337B9dC9wBazyzPO4SkTt5AAgBFI3ggZvW9mAWvs
         CaYvXOfGk4mDvgo8yEOOu1rfaxyFQux3hmkgb4HUxAl5InRiZcuKxvqP9XqveCjkwjXg
         GJC6hnDYPxuS0d/9heAM5VAHiRUcJgSvk+ESPSlyGLfuJt+k/POhjLa9129h+Alzb0LC
         9+5K6KERXONa5l19O5XKgd5TTj+zMudb6N0iXseWgRoIx3p0uAxuukBDG7gbSrhxwSK9
         ViuuXxy7Sj+GGfTfHbFfzFLAQ/fiVnVLZzkbLbhmctooEbsFdqmtOMxEjIHsG+sUs+Gv
         Vsmg==
X-Forwarded-Encrypted: i=1; AJvYcCUfFNzCNvtXYqiTEfpn0un4j47VwP2nmGDVp8Zq84+5qzsrcEdSfnC1Oe1Tgup7ePXi9GSSHnXs+hcwHSg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwedGH0reZqpQYTCeLxG5KHZ1TtlAZbM9oHgu3SaIVpxOhYEQlV
	nHOvzCqWhWG/pv5T7VQyRXlr3II1Ztb8e6pQCBNlGG/H9UYdSm/rRcJZ+gKBOvKwF8Roqauoby8
	Lc2CoEIVVRMjQ1Iv0Slr1+kXx7irx2gXtmTbbjg6JgB7jnZhWN28JtNdwdqY3dxI=
X-Gm-Gg: ASbGnctntDy1vP7NU6EVYB3tUq9Q8OVpEbImNYO8UfU1Vno1k6zxASWctgAShMWfuh1
	UBkxCzvD1harQiB4Vwdx4+6HdxlOqxwPjpdmXJbAGaUKkk/knlHgbOgvvXt2BtclgunH8IFR+Gs
	wOHu35YxTxULLae1MTa56Om4OorPK4PIAeh4HfC3uFzLSEHlxp7amk/yvlszCpRwkm4LnC24ud8
	Rk7R6nGUVos3D3u4+xlgW3i5NIWAyX8h3FwU4x7plzsZJeHLyIYp89ErnmH/mSTsgSPn1zQ9mTp
	vAhjTHMwty4XWh35RkSPKOsUTxxGq6UZD8HJqxDHK2+abXlAJZblO4pibxKkDjeya5gVzQ==
X-Received: by 2002:a05:620a:2806:b0:7c5:8f40:3316 with SMTP id af79cd13be357-7c75c904636mr166845885a.6.1743525632706;
        Tue, 01 Apr 2025 09:40:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKdu3svWPD4gijx0TLoynI97bgyGfAj18omhMqo9yqcZrBylhTXjcw7OpbvttjPcNFzPQb6Q==
X-Received: by 2002:a05:620a:2806:b0:7c5:8f40:3316 with SMTP id af79cd13be357-7c75c904636mr166844285a.6.1743525632324;
        Tue, 01 Apr 2025 09:40:32 -0700 (PDT)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7192ea05fsm784381966b.86.2025.04.01.09.40.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 09:40:31 -0700 (PDT)
Message-ID: <25bd3c63-5231-437d-8e81-9e2198dfa0d3@oss.qualcomm.com>
Date: Tue, 1 Apr 2025 18:40:29 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: qcs615: add QCrypto nodes
To: Abhinaba Rakshit <quic_arakshit@quicinc.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250318-enable-qce-for-qcs615-v2-0-c5e05fe22572@quicinc.com>
 <20250318-enable-qce-for-qcs615-v2-2-c5e05fe22572@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250318-enable-qce-for-qcs615-v2-2-c5e05fe22572@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=OIon3TaB c=1 sm=1 tr=0 ts=67ec1704 cx=c_pps a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=rugxzkDQvrqM6iDmQMkA:9 a=QEXdDO2ut3YA:10
 a=cf2_AmsjeD8A:10 a=IoWCM6iH3mJn3m4BftBB:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: 0RvqE38PeLz2QYkQhziu-QwvD7_hrzuu
X-Proofpoint-GUID: 0RvqE38PeLz2QYkQhziu-QwvD7_hrzuu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-01_06,2025-04-01_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=695 lowpriorityscore=0 malwarescore=0 mlxscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504010103

On 3/18/25 10:43 AM, Abhinaba Rakshit wrote:
> Add the QCE and Crypto BAM DMA nodes.
> 
> Signed-off-by: Abhinaba Rakshit <quic_arakshit@quicinc.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
