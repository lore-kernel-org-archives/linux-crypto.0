Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558AB3ED5DA
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 09:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774950036; cv=none; b=AVcEfpg9diBbK7meh/JJlenVH0TS2L6h5axaP8tbx7S7sMmX6fMEanBWc0YGBXb6wOISV2cxV5Ic9ypdC662Y4UCOSWTfTmCf2Sm/xOP6sSVdmQkDNqWrhpNfI4js7CLvxbUMpYn84RJi9iQ6HuKjyMlT41TLJzZHIChH06qgNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774950036; c=relaxed/simple;
	bh=6TtXtGHuwbeOGc43RV1ox/wCKy7dGy+cBU/v5F7GGuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QLCHYpigExFv+YnLmjz+9+debjQRo7V4q+vjnD1K87iDCADzlEcT77+oKaoEZFc5VAtwP05loIfjnXSfdpcXhN1DhDbQp0DqTdQly1qsBR0e2FP/EVxq8C9acu453qmChatgQyN64NBePnehiew+2zckQBXEbYPL9141NtsBUM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=labxpXx4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OdzHmQgO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="labxpXx4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OdzHmQgO"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62V8CP2V430939
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 09:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oO9fj8VnemesVNw4Kd4kvPTyxIt0YprBH9NBYs6VYwU=; b=labxpXx4emFwd9Yw
	YA7lhLzAwsnly1/7QCm/HoKB4VvxJk5Kd+9ioBAV7C+Q1bSWsvFm8NGPdb7IPM1F
	s7gYkJu+AJTSPV6gPZlURLmaRK5BoJJDFI7oXaAfVBQqNTYiuppLjohFJwODGIcQ
	JM3rfwvQRshKKTeUV06sbxM89gBJLxVaJL9KIM1GqT6DvH+/iNUNsgCV8PS5Hud8
	nugOPtJl3acxB4J+FYMqejbVL235iFwAi561ZOq2YfL6GWECeWw+YunfjAMccSUr
	ktG+r/tV2m7yVXFNV92+i7eHQooqF8TLpLOhMBQsHDRrhMjEtlp/uHfvSPwfJV3/
	vcri9g==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d84bfhs10-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 09:40:34 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b2523e0299so64915345ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 02:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774950033; x=1775554833; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oO9fj8VnemesVNw4Kd4kvPTyxIt0YprBH9NBYs6VYwU=;
        b=OdzHmQgOyB4myKofD7Sd+W3RDBvUMbFZX2FQWPlSNdapC6RPoXxzBswgb75zxyMlpi
         cmKlJVCd81eO7hrciagYFaIACfE92SZYoB8O+C0TSfbFZych+b3nISFtERp3ZteiXbF/
         NPJWLfZKNTcNo+1qhmm2ee67NOxLRbjRlgVCtRLTqFwJrNLSnkNZ+KyFcbCCDBG/NDqZ
         yAYMCXBLSoroO6e0UwP2vSeyyi2+tgU5omRXzIRFIdA8W+GqcM6qfLq+nuqOtVX8nsOn
         2ZPj2MYXyOZsxKKEqoh2CXaHE/Tm1dIL7rWMk0atSOGJXYoupolVXKVuWGzUZIyTZZRN
         Aauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774950033; x=1775554833;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oO9fj8VnemesVNw4Kd4kvPTyxIt0YprBH9NBYs6VYwU=;
        b=KAFYrBtrV8U3+6xUS/t+ZnBeseMmhHERbvUfa5PjtGxLVvf0afRL8XuYiBDmYR3Zzu
         mV0OiTBDKgFlXkeUzUG1PT+UGVYjNGDRZgi8y/VQNZnnVYDMMhCNUNV63DTxxNna57Xk
         0q3n7X1EcxA2EJh0+HsATNjY//caSB0ViCNVG+KMvpsyPAz+cFFhWZ2teVJu0eVjdHcj
         1Ixq6GMxM86gdd/CEVPEKqNvf4zIDC7/q0oKcDfQCOx9ODG5tA72ZgwDbG/QW7NTolwj
         AwYUv6PFCDMae40FI2Ef5FIxWD5ac3qLCUBUwAlqcF/2touVoi1jJtOk0kP2qrFFidsw
         7KwA==
X-Forwarded-Encrypted: i=1; AJvYcCVjFu58QaqFeQ2rqBnIx6wJFt0G5jagIMGOVFnEpaa6d+CcjRDtkMmd4h0D54GUcuiAzAm2wlWUlFPisio=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvDwtvCjsoeAutPYKyQhu4cUMpPBA+ZreKaPQJoDVQSbqGwj6o
	CwFK3b9iVltUEOC8UAk/DM3n1+mbXPlvIQK4XDIf1jbx1qyPpYd3eV8ptcIKB0b51QcmzaVffQH
	OyFbo+RTQatWs8zdZdVgOfaIDsJeHaRPmtL3+jmiA/lkNHDwUuLpmE6cDcFyrwB6DpiU=
X-Gm-Gg: ATEYQzykpFEb36X9aiaA4s5O01O/3Tg7DSt/0ZuDH0qY76JCjjIZTc40O2QCie5/Uax
	9XLYpqZ7WLh7ojhF5v9rCgKorXdhIowBylSwOzwfU3tqCoSu4QCpqHe10vlpfWtHarIuGP+yHqN
	m9tbEu3yCEa0FjQoNku0Cfe1CXkh2V8yRCMksq8hMkEXN3iXQ2vSrCULu00d0mK6wSrPC1dP1K3
	hJMPNdBFh/BINJ65mVNUg1kJEQUI3bZ08KlrBE2zu6YxjLtci0eTgKo35n5jt3Qcw4DGEpFEVVt
	vaAzREKn5NF8g2/VbIOc3pLl8ytUR6fHNfv28vxp7BQ2Kox0l2N5cZh6MCDXqJZCilMK7E+AQDL
	53V0Kv6LBx59C6XhnHtbEpxp3IgirbwKBM9D6+mvNx6tJfGrfU3M=
X-Received: by 2002:a17:902:ef4f:b0:2b0:b1e7:8841 with SMTP id d9443c01a7336-2b0cdcb0990mr168484675ad.32.1774950033393;
        Tue, 31 Mar 2026 02:40:33 -0700 (PDT)
X-Received: by 2002:a17:902:ef4f:b0:2b0:b1e7:8841 with SMTP id d9443c01a7336-2b0cdcb0990mr168484325ad.32.1774950032814;
        Tue, 31 Mar 2026 02:40:32 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427660c7sm106046705ad.44.2026.03.31.02.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 02:40:32 -0700 (PDT)
Message-ID: <2b71dd68-ff35-411e-905d-3ffa2ea3efe4@oss.qualcomm.com>
Date: Tue, 31 Mar 2026 15:10:22 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/11] dt-bindings: crypto: qcom,ice: Fix missing
 power-domain and iface clk
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
 <20260323-qcom_ice_power_and_clk_vote-v4-1-e36044bbdfe9@oss.qualcomm.com>
 <873e8ad2-50cd-4c09-9a51-20ad745fe8dc@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <873e8ad2-50cd-4c09-9a51-20ad745fe8dc@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=INwPywvG c=1 sm=1 tr=0 ts=69cb9692 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=P-IC7800AAAA:8 a=EUspDBNiAAAA:8 a=11eJxmzFO3uqpiRjfBAA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMxMDA5MiBTYWx0ZWRfXyuqhWqowY1ib
 XspWdqZYi43NjZDjwk7VDB18jPgp1LbmgvAvQml41QXnOQjB5roQIlHXxqEZhBYp/mmCVQ0920x
 YkCVLRIhi/mH3h2t/ic4PbEVH09FvkyicwV46A2fU68WjOX4LK6xWVhy0nqNiZ8SmUduN5eooBu
 Mj5ThF/xnsxYdsIt8RM89Zw/zvqqWiJInEKmhxGwoAyejcUd10O+YMUntH1NGTBSlW62BzuR0M9
 qQYhMiGCN5CVk/eBISGYTwQ/NQkGscWcZPwbVVTOvC96BSq4BNmptM797L7t1ql9s9uwmYX2qCL
 lGgfHvY1Qu1KxarOZW1oqNO5BK2qPFEveUWt9WKS0ESMTfWdhKa7b6Zn9tJkeiYvvXZcVIun59b
 FpuEDKqxqP4H1Ib36TsJJK1W/7PewyXvLEclLAe3li04NzVpotse/oI/1ADejqr12XPQGLh/UVZ
 NCSBj3stng3cnvvLUsA==
X-Proofpoint-GUID: N-runFwL4tIMGR6Y5PEMG4fSZe5z0uIt
X-Proofpoint-ORIG-GUID: N-runFwL4tIMGR6Y5PEMG4fSZe5z0uIt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-31_02,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603310092

Hi Kuldeep,

On 3/24/2026 4:16 PM, Kuldeep Singh wrote:
> 
> On 3/23/2026 2:47 PM, Harshal Dev wrote:
>> The DT bindings for inline-crypto engine do not specify the UFS_PHY_GDSC
>> power-domain and iface clock. Without enabling the iface clock and the
>> associated power-domain the ICE hardware cannot function correctly and
>> leads to unclocked hardware accesses being observed during probe.
>>
>> Fix the DT bindings for inline-crypto engine to require the UFS_PHY_GDSC
>> power-domain and iface clock for new devices (Eliza and Milos) introduced
>> in the current release (7.0) with yet-to-stabilize ABI, while preserving
>> backward compatibility for older devices.
>>
>> Fixes: 618195a7ac3df ("dt-bindings: crypto: qcom,inline-crypto-engine: Document the Eliza ICE")
>> Fixes: 85faec1e85555 ("dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE")
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
>>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 35 +++++++++++++++++++++-
>>  1 file changed, 34 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> index 876bf90ed96e..ccb6b8dd8e11 100644
>> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> @@ -30,6 +30,16 @@ properties:
>>      maxItems: 1
>>  
>>    clocks:
>> +    minItems: 1
>> +    maxItems: 2
>> +
>> +  clock-names:
>> +    minItems: 1
>> +    items:
>> +      - const: core
>> +      - const: iface
>> +
>> +  power-domains:
>>      maxItems: 1
>>  
>>    operating-points-v2: true
>> @@ -44,6 +54,25 @@ required:
>>  
>>  additionalProperties: false
>>  
>> +allOf:
>> +  - if:
>> +      properties:
>> +        compatible:
>> +          contains:
>> +            enum:
>> +              - qcom,eliza-inline-crypto-engine
>> +              - qcom,milos-inline-crypto-engine
>> +
>> +    then:
>> +      required:
>> +        - power-domains
>> +        - clock-names
>> +      properties:
>> +        clocks:
>> +          minItems: 2
>> +        clock-names:
>> +          minItems: 2
>> +
> 
> Hi Krzysztof,
> 
> As motive here is to enforce 2 clocks for upcoming targets and keep
> minItems as 1 for already merged ones for ensuring backward
> compatibility. Can we do like below?
> 
> allOf:
>   - if:
>       not:
>         properties:
>           compatible:
>             contains:
>               enum:
>                 - qcom,kaanapali-inline-crypto-engine
>                 - qcom,qcs8300-inline-crypto-engine
>                 - qcom,sa8775p-inline-crypto-engine
>                 - qcom,sc7180-inline-crypto-engine
>                 - qcom,sc7280-inline-crypto-engine
>                 - qcom,sm8450-inline-crypto-engine
>                 - qcom,sm8550-inline-crypto-engine
>                 - qcom,sm8650-inline-crypto-engine
>                 - qcom,sm8750-inline-crypto-engine
> 
>     then:
>       required:
>         - power-domains
>         - clock-names
>       properties:
>         clocks:
>           minItems: 2
>         clock-names:
>           minItems: 2
> 
> This will ensure for every new target addition, default clock count is
> enforced as 2 default.
> Please share your thoughts as well.
> 

I don't really have any particular objections to this proposal, but I can
see that other bindings where the need for an additional clock was realized
later on use a similar pattern as this patchset does:
https://elixir.bootlin.com/linux/v7.0-rc2/source/Documentation/devicetree/bindings/timer/fsl,imxgpt.yaml

I'll wait for Krzysztof to take a final call on this.

Regards,
Harshal

