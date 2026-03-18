Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B710369988
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 07:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773818491; cv=none; b=OL65AnfwlgDjgRqotUPiMFnL5ExfPx1CSfTrG7IS5fszP7qddNG/dQ1h30aQB/A8raixY8gkNukl38EMc/8ld0yAIXkhHsIODTvh7JRcWX5L0M1jq+bo0r2WaZtwRTcojCQSUdA9dmFRuMXTGqI61vLIf4DWn3axcIXKPfUv/fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773818491; c=relaxed/simple;
	bh=Zg5AMgU+Rfbc6lXhdJRs/m90+7lDT7VWHZ0ukmlenNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h9+AB3Izx+xjO0yGY3Ma1fy5prWhA93OcFRKeaZmaMSsVKCLMZenqhamumXIHhUbkIw0ATeRgMNd7BrsyeNwMQaNTT0GJfhmG0kTgXCWaMwuZJ3LETq4hnR3E79jJ6iXS2TpQ+eQX/K3V/Qpkv1NrSGxCuvmj/pK2RaTuT01oRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B5MKpL9w; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kqkX/5SM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B5MKpL9w";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kqkX/5SM"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I3cliN402852
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 07:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YylNgRIFLdDGow16+9WuHWE7gEEdV3w331tMJHgwFVE=; b=B5MKpL9wxZO1hv95
	3H3e8e8jZSxzeg/GlIrj42LJg5/klTvj6tNtab5vdccOwxbvyCM2N5IvkFD6UNU9
	ukoE4VbvTPk7Ss8bfwi+YiB6P9s1oWWRMmsr/nrtFvR73Kuu4Oouk+P0ba60MRi6
	WW+ToHCyVje0wTWb3+NehMYWM+RmiRWqgHiDHDT1MoAcgo16qHsWy6Xwg5O+LE7O
	rqxTUaBb/mxCfM+otbuZRyVALxArUg/EPzKKDzcWfPrbr0AA8YpfUWyKXlofkrU8
	5sLX8O5ngK5AQ9brOk25h1UORVRj0HssfOsVfs0nWKTv1YMzg+Kgo49c+ptj8hPX
	s1T33Q==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cyc4dtg81-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 07:21:29 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b069bfa817so16820085ad.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 00:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773818488; x=1774423288; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YylNgRIFLdDGow16+9WuHWE7gEEdV3w331tMJHgwFVE=;
        b=kqkX/5SMbd3+jdqaBfIuE5Z/q3C1Vz3F3w8QyRm28b3ZSwTQVt3hEug0PqiIWK11l4
         6HiahNAUMXc/JYRfJT+T2CJUAHJUAMLmG0hQ84GZU8R8RZ8O4EpDan7rv70JVvoNdE61
         a0MrCdx8r388C7cDRIHv18qjbaDToxyw43BOY48dW1jI2R8uduKJxVvxO2ftENexSdF8
         QKzznw4gUSI0LUASqb7gm/9iwcKBv45kIUzLyTwf/47zX5TVnConQYTch9/SIQZV/DbA
         PeNL7dGwjeJ51KvYAQYLg6Yw3wiFKKPBOU6Lgxh8wOS4WeEOVRKBsBgv7xJdEkW3pmSP
         /HDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773818488; x=1774423288;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YylNgRIFLdDGow16+9WuHWE7gEEdV3w331tMJHgwFVE=;
        b=Owe667iQgUkJOW5aMQE6NHQ/auWV2HCa0rl8Umpwd2ieD2I9wB/eWp/BcOTZPPFIAw
         zSK8idyYFWDfWbHYCsmf/wKWvVUATLujWcQhP61mvFiBhsHrDO7cjwKaBo+Oj0O2LZMy
         pZ3J8IozOUWJbTpRcVq1PvSYfQa5OikPEHepYZjX1K+3UaqzfUK8mKUc7JtEA2RcCvy2
         AFniBPGQepmSJIGXoLK4P96Y0j7Msbh5cplkDgNDSIUV1x4DtOQV7mcXNrvs2frD8FqL
         oMGElH4/LKF73agBzcvbfUvJXFPk1+zmSqSbNAMYizFJfWuZ8w43yeYDzgVausPUUuVg
         uc6g==
X-Forwarded-Encrypted: i=1; AJvYcCWiO0oW8BQh23tP3sgQBINpy1GCzVXuaMWyhEtrbUqVpk5xi4IsaVwxpV/cbfClrxjOybYCFoa4NRB8qFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdosXzFcU2HgqHOf1Q5SagVfpUj26De3n57IElDdAjiuQUrp8t
	rgsGxHbIxoBVXqRenQ9fT7d11ba2RSAQnWHtAjb7dVrfU1uiq5E1FLUN9hWsltO/05kUF5Q+bef
	1zTHe0R2Qcy6yhST5J7mti3pQC9LDp8BFUq0gygkVUS2vIU+T2N3acZEHvKD+1i52FaM=
X-Gm-Gg: ATEYQzyMPGzI8RuFjEXX5G+ttoFLdTJBheNLxCITsN5DJ6JQcZnqw6Zvh+zmCyRl8gC
	8DKASRo7kHuuds81GWnPrsOTx/zFr+Oy1nK35JgUtI4HBjRe5StoIkbFM8+RWuVFHtvbJdR4Re2
	/f6fzA/15KNX0xBzuEtvGkElfQE3xNKQDCalkpNJcH8QHQbcyMd58Ib3j9Otew30ClYWPsN2q5M
	Zsl5m6Ud04tETgtg6uwgpAXtr4ddDCbRdJ9nvEKU4w/VzQIzH0INwmuTK6szWGEPNs7bqvuoC9b
	xvebaz8ie/d5M7OClAoZe4huziCTVUXEB4LjDNYKigM7Sgr9hipgkDsxwLTVA7j00mAcaE1euHD
	m7GS6KjMvjePV/cLJVH5PF36OsICrBI7uBNmIi3Ld28viTWEI/mM=
X-Received: by 2002:a17:902:e94d:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2b06e3230femr23641205ad.1.1773818488369;
        Wed, 18 Mar 2026 00:21:28 -0700 (PDT)
X-Received: by 2002:a17:902:e94d:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2b06e3230femr23641015ad.1.1773818487824;
        Wed, 18 Mar 2026 00:21:27 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e619ec3sm17610455ad.69.2026.03.18.00.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 00:21:27 -0700 (PDT)
Message-ID: <1b1028b3-22c9-4b00-952f-804f192d8870@oss.qualcomm.com>
Date: Wed, 18 Mar 2026 12:51:18 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/12] dt-bindings: crypto: qcom,ice: Allow
 power-domain and iface clk
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>,
        Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
References: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
 <20260317-qcom_ice_power_and_clk_vote-v3-1-53371dbabd6a@oss.qualcomm.com>
 <do62iaopjcahvn576gfcdbyo4yxudf4uit2sbifvjw3pwrlb7j@higm25fdesk3>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <do62iaopjcahvn576gfcdbyo4yxudf4uit2sbifvjw3pwrlb7j@higm25fdesk3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDA2MSBTYWx0ZWRfX4VYNvSC+Az1K
 Ae9YrZzH1F/0W2TkBmV1bmZVB4Gkmgtykedgp0gsxKtEniG4U+6jkzgg0VTUoEoL0cbQnSy8Alw
 bhnRXn+hMTBGhoKQHloIj5wDcwdnT+MvtdMwrnUcIjOn2mmaYA3TEW0tDvv0IcRdkhk5BHju7Fx
 zSDYlMMhqDIKgSQLFSFO90/w2o83QMaPVV+8EqLR+q67By6gr3UPsJOlvenHs86W5X16wW1Bz+N
 gA9RmB6q4tT8Yp2EstX862suC7b+lfSXwwtJr65QLJafEAO1ZJqMu2/eqCgUWUHs+fQ3stGRXje
 FP1Vu9Xt+FTjgftUx7oNM+Ccdf0BB8Nk2r2syi3yRzlm/TQg0I0nIdk7gCtKf6787JvIYp6Mkoc
 FdHNw3X0tI3yj4mXU+12e5x5v+TlaOpH8tCuBJZQqr0ZdqkQIZN5a+3kxiR4OKkOB7JFhSd8umy
 Mh8qBazal7L/SZ8EHug==
X-Proofpoint-GUID: e2m9m5T2WAFcCNvkAekRBw18eKqjfgtb
X-Authority-Analysis: v=2.4 cv=DfQaa/tW c=1 sm=1 tr=0 ts=69ba5279 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=vZp64IP-UYAUPCcu32UA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: e2m9m5T2WAFcCNvkAekRBw18eKqjfgtb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_05,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603180061

Hi Dmitry ,

On 3/17/2026 8:42 PM, Dmitry Baryshkov wrote:
> On Tue, Mar 17, 2026 at 02:50:40PM +0530, Harshal Dev wrote:
>> Update the inline-crypto engine DT binding in a backward compatible manner
>> to allow specifying up to two clocks along with their names and associated
>> power-domain.
> 
> This should come after the "why" part.

Ack.

> 
>>
>> When the 'clk_ignore_unused' flag is not passed on the kernel command line
>> occasional unclocked ICE hardware register access are observed when the
>> kernel disables the unused 'iface' clock before ICE can probe. On the other
>> hand, when the 'pd_ignore_unused' flag is not passed on the command line,
>> clock 'stuck' issues are observed if the power-domain required by ICE
>> hardware is unused and thus disabled before ICE probe could happen.
> 
> You can simply say that ICE requires these clocks and these power
> domains to function. Accessing the hardware can fail if they are
> disabled by the kernel for whater reasons.
>

Ack.

>>
>> To avoid these scenarios, the 'iface' clock and the associated power-domain
>> should be specified in the ICE device tree node and enabled by ICE.
>>
>> Fixes: f6ff91a47ac57 ("dt-bindings: crypto: Add Qualcomm Inline Crypto Engine")
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
>>  .../bindings/crypto/qcom,inline-crypto-engine.yaml       | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> index 876bf90ed96e..99c541e7fa8c 100644
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
>> @@ -52,7 +62,11 @@ examples:
>>        compatible = "qcom,sm8550-inline-crypto-engine",
>>                     "qcom,inline-crypto-engine";
>>        reg = <0x01d88000 0x8000>;
>> -      clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
>> +      clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
>> +               <&gcc GCC_UFS_PHY_AHB_CLK>;
>> +      clock-names = "core",
>> +                    "iface";
> 
> We don't actually need names here. You can use indices instead, making
> the change completely backwards-compatible.
>

I do not have very concrete objections to this. But introducing the clock
names isn't breaking backward compatibility either. I wanted to continue
using the names since the ICE driver has been following the tradition of
referring these clocks via names since it was part of the UFS/EMMC driver.

This also helps me avoid touching the ICE driver source code for specifying
the index of the clocks.

Let me know if continuing to use the names is a no-go from you for some
other reason.

Thanks,
Harshal

 
>> +      power-domains = <&gcc UFS_PHY_GDSC>;
>>  
>>        operating-points-v2 = <&ice_opp_table>;
>>  
>>
>> -- 
>> 2.34.1
>>
> 

