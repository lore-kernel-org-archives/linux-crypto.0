Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3802B39FCB6
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739529; cv=none; b=V4fLBZT9ukLQQISffoFSrihc8CcJFyEnI6+4Jy3VfL0kO+a1jRXn489rK3JdCR6YwTDq4VNkGmEVVgGNpD7UTX0zoLaaOfsQ5GUus9hc5ZjcubuUaTLGYiaeo/zMfygJrtBSgFf9NXdNwl8mN5vhh7n+2STzHkKWuHgXLC9ZspE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739529; c=relaxed/simple;
	bh=cYAUf7tYdCbIp0kTz7vRfdzxvjmcwGrNweRRCyA8n0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hhDDzvbLtoAuoqC4yTgJw/3lEOqcNVabE9koAZUg+Ek17BZnduiRzxNnZmZ6yBT0M5S9Z9lh5uJLZw6JPzEh9NpVyLtmVg2wkiSWXoJbXnkmHTKeYXdjuHA3HFLcZbwIA1nVwIbYa3Pwy/5GDjJbdRdE1T0jz9vYmHRM9Hp9kpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=equERnHi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QRD5fIDb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="equERnHi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QRD5fIDb"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H7RDKK2905945
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:25:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NEQX+EDkomw9M3dwmMKBzxuBhFDxwqMzLHFUnr0OFuU=; b=equERnHiKsZkOnIR
	Xlt8Dh6zE6GT6R1LSU75jKjmzG/GoU/IA18gebinn08Nfwy91zv1K2tpbpNcLH6e
	jGnE+3EDldZzU2iRgjfd7HjNK41Y67wYUHB7nKv1ICc9Hp6m7j0EBiSqrA/FJzdO
	7Vwx690zU89gychHcpkSHAgaKivtV0KZgvEuOu6thhkqCPX1HpyHxFTdNMX5dt/s
	5JkgPAiTBRXdGoBXwScwW7KHwYt9MsQU6Z7FXDw/KdkLQwZu5hZFx69YV73ICXZC
	gCi1dj0PWzK25Bq6wXZVC88AX8kVeWVnCz4R3SsY+UCai2nCGnz/pv5iEZG4mYJq
	wWhSnw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cy2jxgesh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:25:27 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ae4b96c259so9834245ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 02:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773739527; x=1774344327; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NEQX+EDkomw9M3dwmMKBzxuBhFDxwqMzLHFUnr0OFuU=;
        b=QRD5fIDbYcZ4cQuZJtCLbr+Jg06uGRJSW4+xzT0yHOQ/FMMYxz4RISqqDsxKKwCtbi
         ZuoZSNwRI27XrL9vAqF6pFqJMXMSX4N6ErdvEi+3eoT5PoxNQtioSbeU8iWH6d0HsxK7
         Xx3sAWnN/px13J7qMVaPJm9jgzezBqmUg8lIccFy5kDAaUoSdV0uha0/aWdDErstc7Cl
         8pG4hw3hTPaOMrBs5nBBfzhRfyM35HJq1nY5LUILlfsa8Et/LgLrLOC2zw3Vix+q/Vd9
         WpEEaRLg5AdfgIrFxdmsSyThxqY6d86co0Xk137CO3JOmgyKL5q6RgSPoqLyXVqa+Am1
         agKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739527; x=1774344327;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NEQX+EDkomw9M3dwmMKBzxuBhFDxwqMzLHFUnr0OFuU=;
        b=KfWBWwCdWbk0aq5xILM4yY1bP0+r8RdLj/GILaYmM8VBiXdaCHY5L0AaeQaxPgB4hG
         iSbVKVy+1e3MGdWHEJHD5GNmQlhbf9JoybZVbpehaUheRXA2z8mvGvP7E8R3U8DtSp4D
         4kn9E6xoJ0NRjFbqsZEiq9/Kq0pCe4JNO0bLjbJBMGHH15kid3NO39uKtdYh6jLJCpBX
         PRusAV+OTtb5jqhYuhY066343+ze45mDhyUmMxMS/188P51MRJLb+ezxQ5EF0sJQ099T
         FXt8GyAJwcbqEBsilZ/uksp/rjlXly1VsYJWulCQY/SxjNLWX5S5U45ebtaiP9VM+oT5
         OiYw==
X-Forwarded-Encrypted: i=1; AJvYcCVJWvNy02MMhoynIz/NS7p7TtlYEuBoGBDV5VyDwq2EgotGu8or+w8TdurZatH/P6PR0Xb0P+70FlXlLeU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGHTxIAREqAA2YhNbIjAhJTDNFaHj4Po9/7cYxaCGkzTD0M3lJ
	NSGyuJo/8LyQ3QLIMLTznhOQV12qu+T42ss4veMjFvIOKzHn3vVczhB4ziqUhDuexNbGJc9GASW
	iC5S5BHzqXMkuy1PdEIePbpfPKA49PMTiX4S2+6mfA8ZuHhLGEm9tIPer/MziOfwSiFM=
X-Gm-Gg: ATEYQzzjGNNfmKWaW/hWzqLKfQ13uOtd1bYmooXP1hfhuyeZcrZZLLqyaUWXP6boUdW
	z5PE5IigQfxVLabZDfKW4+erTqYgdX3cF8Y/8coDuj1uziz7bAFerO/obQyiBRfXkwNuVvtrTmU
	dFXphnC9gIR3pWWYyOuxVcMD/H+2tKWfi5NxUlNzjq76t8Oout0V61czg0ZsTDV6MoIc0x5HMK8
	V5RC3bBwEjvYGrA8z8zW/JDfV7ExHIipo9uU0qoIDQ4+mEzjOJGtTkCNOC63qumSEbx5PipRxuM
	McIx9KwJktWTV2BqwtbsyvJqioyXImtNz2dBA5c08eZtzVpsIMVg+MTY/H92V0PeIpT44RqD6q9
	qRHQxczbKuazSsPf5bnzriBrPQjUeG8VxvT+JvO+cK2CLKfLONfQ=
X-Received: by 2002:a17:903:22cb:b0:2ae:5a70:477e with SMTP id d9443c01a7336-2b06365b4dbmr28028655ad.12.1773739526821;
        Tue, 17 Mar 2026 02:25:26 -0700 (PDT)
X-Received: by 2002:a17:903:22cb:b0:2ae:5a70:477e with SMTP id d9443c01a7336-2b06365b4dbmr28028325ad.12.1773739526299;
        Tue, 17 Mar 2026 02:25:26 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ee3ecsm176093325ad.42.2026.03.17.02.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 02:25:25 -0700 (PDT)
Message-ID: <90e2efd8-77e4-469e-bd36-61bcae290e21@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 14:55:20 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] dt-bindings: crypto: ice: Document sm8250 inline
 crypto engine
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Alexander Koskovich <akoskovich@pm.me>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260309-sm8250-ice-v3-0-418bf5c5c042@pm.me>
 <20260309-sm8250-ice-v3-1-418bf5c5c042@pm.me>
 <9e740dae-3197-4cdd-85fd-8a840d2317a3@kernel.org>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <9e740dae-3197-4cdd-85fd-8a840d2317a3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: YuXCxUU8vdK_6CtSxRTbuTWc3SPwnByz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MyBTYWx0ZWRfX82WVEE5GsRAI
 n/eeQORVccYSEKZAeIq+LP9SJ72j4/JfyM0zTiL0FCXmL6S/pwl22YSyETVNNNtfH/UEHCNPfHk
 6A7G1yqayPATvC0dd20c30ps4LwyBhlXX77skFwgwZe4kFkZJh8ETHRTkcmPmRBm73nG1XvEM9h
 lJZzIQaBZGn5Dw2PJotcwxirzKSGAHyvg+VC7smaPXATML5Ry9i2b4sirx8c7CSM5NEVz5qcmTO
 xjb3vZXz/oGWHJ/Ga1UCNteSyKF9dcRctcYz43uudbuQbTxfJ2yVdP090tNgVFI/qiNSe79CYHr
 4vr4/YE4YwM/fbz/CrzLfhn+nm2/oOX3oNoK8zhufcNPNykVK3ghNmsrQdyE8e3ZHW4aky1sLth
 7xYfF+MXdj0vRS3seoAZy29uglxLCLiat69szFQ20NOfBsvMGVlg44/2E6QD/shsQQQClVIIY/S
 jEwGNobtGrk5qekBEIg==
X-Authority-Analysis: v=2.4 cv=c4imgB9l c=1 sm=1 tr=0 ts=69b91e07 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=BNPdHxw50mfEycljYbQA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: YuXCxUU8vdK_6CtSxRTbuTWc3SPwnByz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170083



On 3/11/2026 11:56 PM, Krzysztof Kozlowski wrote:
> On 10/03/2026 04:12, Alexander Koskovich wrote:
>> Document the compatible used for the inline crypto engine found on
>> SM8250.
>>
>> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
>> ---
>>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> index 061ff718b23d..ccb74ea14ce8 100644
>> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> @@ -19,6 +19,7 @@ properties:
>>            - qcom,sa8775p-inline-crypto-engine
>>            - qcom,sc7180-inline-crypto-engine
>>            - qcom,sc7280-inline-crypto-engine
>> +          - qcom,sm8250-inline-crypto-engine
> 
> SM8250 does not need two clocks?
> 
> https://lore.kernel.org/r/20260310-qcom_ice_power_and_clk_vote-v2-1-b9c2a5471d9e@oss.qualcomm.com/

It does need the two clocks along with the power-domain. I can see they have been
added in the DTS but with the updated DT binding, I think they should also be made
'required' for sm8250 similar to Eliza and Milos.

https://lore.kernel.org/all/20260317-qcom_ice_power_and_clk_vote-v3-2-53371dbabd6a@oss.qualcomm.com/

Regards,
Harshal

> 
> Best regards,
> Krzysztof
> 

