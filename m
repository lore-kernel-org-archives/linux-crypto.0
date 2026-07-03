Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF95A349CCE
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 08:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783067149; cv=none; b=Ncf9bvv4hLj1HSX77uESckjByhyltfrhFIluwWW7zX/GqN7z24Itd9xBUu/36dFXMXhpGMaEwmciLtAQ7hTMbmTsEj2YNDvXHDcF5+PnyaDT+7NgZj+mLxnNiMu8jwbb9Ih5MCWtZMXmngHC0vik21mri1o9nEKPxMb+8FAXwd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783067149; c=relaxed/simple;
	bh=Z3lhZcvTy3ChvwrsZwjryfnqt63yUqro+E8ba0wENaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j3bUl2Ejx1yuZjVWd4MKwxP85CqnxoCdgNMyfUDrGkeFjinKuNRBdaTyTbJwpRj5GNfUAomqbyjqjRFKC4QASu4g3v6yxXaXGgeEnOf78lfCnAWNSWbxKDr2c8R0YYYWmIfo5vhzpKGNWYiRtmeZNA+T1Mcm/oFgQxfkBx0KP8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aOmQVJto; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Zce1hbjX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aOmQVJto";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Zce1hbjX"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6635rp963088123
	for <linux-crypto@vger.kernel.org>; Fri, 3 Jul 2026 08:25:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	muNeEPc2vpjuOsLjLd4zSCfTUU2sqAB/F6JbZI/i5BY=; b=aOmQVJto31isSbl/
	qfWSCSG3v4pXIhUSvwVqonp8Bmz1j9cuRdqmxS4psUVlFW0PRqBPDaM3gKX2xnh1
	Wy3Yk3C7HIjgzWSiY6YXXWFtvnbEesF0tpihjutQH59EGOpmK7j0ogvneiwDaRAK
	APiOWv5eTiehuu4PnsctkDnksfjoqs7m8HKb6blH9VtjtI+hGZBziym1ZU2drAI2
	UFD1VJAtNkR0M4IRQtfJc0mJs9w/OpELHDBXv/6uMssVVNryTpuiW0FTR5Gff0gY
	GBNWRDn6daL/UbZFWP6w05ryR2JNjRCcxmoO58LgXn62glh2mI5TaFoE+RE5P8VD
	lSvMwg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f5s2542kg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 08:25:46 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3810e5c5871so602566a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 01:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783067146; x=1783671946; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=muNeEPc2vpjuOsLjLd4zSCfTUU2sqAB/F6JbZI/i5BY=;
        b=Zce1hbjXCA8VTFqoCjM8EHBL7oSKg5qkOkevTipnjilzL0Ak3b7EUOX7pD+mGC3TVc
         uXHrKWT1QettroPB2CyPTpuOaNfteTdOvgRgZ5gLWZZ7x0tNoHzvh+dwNlPn0KpgEE48
         a0zW7WsKQ8GwXpkqaMQc5VQakt6aLz/2M5+U2qkpYWH9ZqtSVR8f63NqrqtU2K6DRhTB
         sBgzVWUKYSIkf+BJjNPDAQwB4ke/R2RMRL37lDF2gDL4H1u6Totrrh10tasU+EVtcUQ+
         6YxOkQAyL8xist1nP/fEZe3KP9RDjrZX5SdLZH2QdqfGh3QKyC6rqJzJSYWPJu6ztjHp
         LA9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783067146; x=1783671946;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=muNeEPc2vpjuOsLjLd4zSCfTUU2sqAB/F6JbZI/i5BY=;
        b=rgOTCrDeqApl46F/LZKjWM4ce0NC+ObqtQ/oK4JiqnG79f78aIisJ4kjsAVBVWkmej
         zfsLxo6HQeaam1GQbLXocvfNlUpVMeZRCDSNzzrzsbuwJmIu4ju+r2ClGKpiK+7eqLSD
         cc9I2T/gpRTll2OzxgbEbUyoVMXm9PqWTwbezlD4jwn5Cd+Dhpp/GGaypBSoi9byIRbs
         f1SPZVcvg2XqdQdxEVHwkrUytsQ6yVnZKxHWy5UiZLTuwZnyczaABl0oRLlbMP0keMEF
         ss1bNTgKaCTUrs4SMRKVxZRN+vEhC9xpI6wih+grY8Xk3PzjC8j+ryFMdJybECT6X0T1
         qBKw==
X-Forwarded-Encrypted: i=1; AHgh+RpmBLXk820SrdO1UtGxCepUsSUf5use0UYMDCzTveie3eU+rQzz9hfDnB5b/NRuGNQpt7dYj8dsssMc7q0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZoE24RYeD0IXFpQT+2eSLCffZjU4kP2ypn+l59tJqhJ3WIPcS
	BrtssVWvSFTuqKYYR3jnWVBZiKyG/aqXdCv5eM2ctSzXnSUgSzundoKmUQ5y95xcA/Hn31LZ/t+
	fy2beWu4ep+e1mFs/S2pQLCFxXbqY75e+rxuF1bLjU42wgK2l+uuTVFuGoM0h8iqThPM=
X-Gm-Gg: AfdE7claZlRDAqIOQQdb2+2hP+ZzmCq3xzwdLVdgs57OMI1hV0wC2TWITArwaYQOQ0f
	h1M4Tx+orElGYBPaQ/BBikYrp609lmrIzMllthWAXxHDtZloKWBZ2uL9Djh78MSavI+qDT7MI27
	YfKq3PKtwkHoFNlYNkN2I2phAvO82hn52dPSIP0ze/F7PYCkJEZRJV/X4qBYuHlsGcIoKHy556I
	w3j4wPWEA1b7sBMwYxh3KuaZgrdcIHZb2XHRg3C5lNv3TjEdFwT2hCLHPB/mSdD+n9YYhjGQy3Q
	zjlzABks0nQk1+IYqUVvm292Udjv/efEw/tKTxe5nNSL7SNV5xeST+db6GXFYbFORJKiNgbWm07
	6mHGgRbH7778WzLSLMiTRRVlOVegdCSQc5LkjsMsdMJ0=
X-Received: by 2002:a17:90b:528b:b0:381:3b5d:30f4 with SMTP id 98e67ed59e1d1-3813b5d35f1mr1237819a91.1.1783067145695;
        Fri, 03 Jul 2026 01:25:45 -0700 (PDT)
X-Received: by 2002:a17:90b:528b:b0:381:3b5d:30f4 with SMTP id 98e67ed59e1d1-3813b5d35f1mr1237775a91.1.1783067144955;
        Fri, 03 Jul 2026 01:25:44 -0700 (PDT)
Received: from [10.217.222.146] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0b816a42sm30312280eec.9.2026.07.03.01.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 01:25:44 -0700 (PDT)
Message-ID: <1db1de13-385e-4b9e-b18f-f7035f1b58f5@oss.qualcomm.com>
Date: Fri, 3 Jul 2026 13:55:36 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 Fix legacy/new SoC strictness split
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Konrad Dybcio
 <konradybcio@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
 <20260702-b4-shikra_crypto_changse-v2-1-66173f2f28b3@qti.qualcomm.com>
 <20260703-nice-beetle-of-efficiency-eafad3@quoll>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260703-nice-beetle-of-efficiency-eafad3@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=U7uiy+ru c=1 sm=1 tr=0 ts=6a47720a cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=QthcfW-pFkhp4WIqV0YA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: qHNnby8phW7dMFhXemsYQiv_cqIA2r50
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDA3OSBTYWx0ZWRfX6/TzMtpke3PQ
 XkG041umlgf52uDgx0BZPNNHhCm4l63M1mBwpHCewESceN7F8Yg1wf0hlpAX/vfvONSsd0eT/B8
 WmsOzAXbM2UxPDOU8QahV9YhgPVcUU5Aa9CyAKgjrqRtZJ2yyb9o+0PkJQgtQafbqo7cZnTKZfY
 8NrP5TVkVpsMvoJYwZ+xIIXNUC2o7PKZDVkHcghaus+UTEM7k2foeia67ju9onrVFwYtwOF+gbL
 gcz0878mDGC20eynJQtA0O+JpAbVAzfse1zEYJ1hLDM2Z9BIucfnVAr9Cajk/UWS65ykoG6vWjH
 idSyMXmaumjWfX1ghKhOTKHKFJRBsif7CNtayJUb8B7rVxeo8lSKxRVKf0wJREul0mqmmzWPfGG
 ZIE1g9UmOqpLUsuvn2nH/kJI7kTAZJxOawUjXXsLaBmqymRjS2XOxb9A5iPPuzkiDkS5u1oNRzZ
 8afXFRfDn2aWfDne03Q==
X-Proofpoint-GUID: qHNnby8phW7dMFhXemsYQiv_cqIA2r50
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDA3OSBTYWx0ZWRfX+iKlZlo48x7p
 4vD3LDDcihwKeP9VxO3TtTI302XEoHZqOkz4qNgxHv3qMl5fbVUYpYjFsviR8FhDk66bD9VX0Yd
 SmyBjKqJiv3xxbER+cRfepp7PG7ZFoc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607030079

On 03-07-2026 12:21, Krzysztof Kozlowski wrote:
> On Thu, Jul 02, 2026 at 01:47:11AM +0530, Kuldeep Singh wrote:
>> Couple of already merged SoCs describe ICE as single clock historically
>> which are recently updated with mandatory 2 clocks.
>>
>> Keep only the known legacy compatibles flexible, and make strict
>> validation default(of power-domains and 2 clocks) for all other Soc
>> compatibles.
>>
>> This ensures old DTs are valid while ensuring any new SoC (not in the
>> legacy allowlist) must follow latest requirements by default.
>>
>> Fixes: e27264daac7d ("dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk")
> 
> Please drop, original codeo was correct, no bug to fix.

Ok.

> 
>> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>> ---
>>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 23 ++++++++++++++++------
>>  1 file changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> index db895c50e2d2..4f3689a24410 100644
>> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> @@ -55,14 +55,25 @@ required:
>>  
>>  additionalProperties: false
>>  
>> +# Do not extend the list.
>> +# Legacy SoCs are allowed for single clock.
>> +# New SoCs must provide both clocks and power domains.
>>  allOf:
>>    - if:
>> -      properties:
>> -        compatible:
>> -          contains:
>> -            enum:
>> -              - qcom,eliza-inline-crypto-engine
>> -              - qcom,milos-inline-crypto-engine
>> +      not:
>> +        properties:
>> +          compatible:
>> +            contains:
>> +              enum:
>> +                - qcom,kaanapali-inline-crypto-engine
> 
> Your change is not equivalent in relation to hawi. Please make it
> explicit in commit msg - all devices which are fixed by this.

Sure, eliza/milos/hawi are non-legacy and will adapt 2 clocks model by
default so will update them in commit message.

-- 
Regards
Kuldeep

