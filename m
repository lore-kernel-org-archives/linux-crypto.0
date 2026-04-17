Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3883ACA5D
	for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 11:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776423979; cv=none; b=JdvvThEOhxf+ONaEf1RGyV+ct/En+HXkVJhllRr9Dhq61+B1i+o6gJ3qbeXQSbpxE+ofxo7eoD8wgRhPecx7LhjDxoC9UZfXQ375yTD4dXD9FakuSIijfyhv9BYKi1m8s1HY85LebG+Sc/KPwYz6CsXdIgB5G/cC4w4XHJMVKRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776423979; c=relaxed/simple;
	bh=gjp214fa0vDqtp2MIeTwFh6cFLkjHcWFV2eE2F+rGpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QZX/gSRRdiZAMSPy95g2moeop1ELLhEA+xxIFvQvqVeodSdZXR+F/h8AZ2fNBX9g+bNMrug1t9SJTUbg29acDp3Shmukrx5+azgi8ybL/NLDpWm8qVfSuuyBx/7xiApu4hD2iFQdqSEcsjl2yVydCR2HWASw/DtlxdUaSCM6iFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fbLJq39r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MUkDHP1x; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fbLJq39r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MUkDHP1x"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63H7hsQw1981958
	for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 11:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	q4ixaJYpWyXs0N5c5hlaCDJ1tgjucLUVDje4oD//Jiw=; b=fbLJq39rXjZu1k9E
	fmL5++/HztL1OrhflZnUN00HemA56HmJ5k0Cfvv2E9BwdkpaPbmAoEhTLJO1puaf
	wYRHu2H2U0Qna1ctpxRUDff3RbruQ6nQA8CRQjdAb0fMHzL9edojLELrzugarRsw
	S7nRf0WImd/ceysRcx4o1toOEgnaPOUj9j3KzG2FKTExZnTWiR0XQwJGINT/cFq2
	kvNKaEq44G+E1xJwW399UJC1+cFJv73iX3IF1Mv2Yx9DVMwbNi6i2a2DVueVfLty
	CLQiwvG1K0YVLYS8H6MHovpUdoWnYvMhR59HDrhZ5cghL9KF5CynFlkMxNJ5e/0e
	5hKSBQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dk52jk22q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 11:06:17 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50d5d076d88so1151481cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 04:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776423976; x=1777028776; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q4ixaJYpWyXs0N5c5hlaCDJ1tgjucLUVDje4oD//Jiw=;
        b=MUkDHP1xb8WkGwJxQHy5LHnfU0mPoYsVxZPCoLkS3YQCvWc6vheMeizqCHHGb2RtZz
         riOUecVVbLntybC68RFbYljhI8qUV1ce9A24cvn3n0teBkzK3536WHgkCOBsCBww29ek
         syc7SHnZs7NxnH5mBQRQh+I5ioH79vUV2RFgDlCFoZBNf620d3c+wDP2aUlKdF9upmJL
         EMd3BmrugtizfmZ1lcZUw/SSS58b9DGboSg9MSXgNqQXmzcOXJdudCVFWZVyY+pyNWNF
         fuy0TcVlKQup073BJx1E4xSX4R0PKnzT5XnPOfocTpRUijVAvBRgLOLPKhN960XQffom
         7l8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776423976; x=1777028776;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q4ixaJYpWyXs0N5c5hlaCDJ1tgjucLUVDje4oD//Jiw=;
        b=PT+ne2+8VxyYVq7Njz73bqziwPGI8yP6LMli5x8PG68wxv327R2nUUulMVAFACMsLq
         Q1Hd/Y+OKv1GphpxdIR8oqTuUwP1+YhQL77178sWW+3t4xxCxY+4b4XCYP2R/YolQqkj
         i36I4mn6+YczdHqYjsGiobCEYXEij3257bi7wWCQ2QLdEaJmUJEweU7MkHTQlRnsgD7u
         TD94fQApCp9tcl3S09KAVicbIeov2VxhvAUFoDReAF6mGKhjjqMWNWLyxuSSz0q4+rBy
         fS7KSHBucu+B29BM6Wn62mEF8fH3YxhHstyuua7L5ldZDoHgDyqYr7l6gJI4+ILkMs+T
         3awQ==
X-Forwarded-Encrypted: i=1; AFNElJ8sIKkGxJKpNh05dJ9az2+2va9ciBuYNoVy+zB320qKnOyDx4XxXH0krmxoKigBW2iHZJzSgCgIqgVQGzA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl4WZaMBdcSvQ2ei7Xc/8MU31C1DGGJXEWDtv5yxB/u718rulr
	+P9Gq+hYdh3tfKx9GS9VhFAsUHj1qPmoRILRYxTTqh+dZMnym9zhi7qZvJLHUINPNfJ3o21oPhm
	gRP7I/1mtfZ18rPOjQSv5VBay3U+UNvcNq5oZ6rIQQwvMuSdLDFEatuRGfHw7wc79IoA=
X-Gm-Gg: AeBDies6YpqTzTvjH3UivTAIBT2PmA3ZEE+HmMahT/3s6r0JGGLDHRbxN8oyo0jFDmQ
	lOP/fxcREcbnIQ7DPy9YAmBX866F7CsyRwbMjkVLXFMDJpYKNCnuMFuN/TVinLXK9JOMmVIUx/i
	GrCOh2n0mnUxl6lgtWFeeRUSaHMsWJf7vukL4SfR7Ca8gZz59X0rbYf2P19Xb4AbX0khAxFQDVJ
	gNYXWQ4UY8fE5C1RYqelt/pkSmQ7TW4prvrk4CUHgsJNImv2aE4ivAgO0da27P9OYpsoMGP6xGm
	ly7R9Wg44+NAqegZFaRn9IkBPmrbnI8kxx/vyMWYSZ+ho3lz6hCSC6JK2xkhXoP3grnqvOeJ6eQ
	hpRN9xk/9B8wvPVUHMRArHg8v8+E/fGvzGJLZFslZPcqlTfuaKLKo30+aH+N11+jyjOJfjwaETj
	9LTkoC/4vIvS/+Gw==
X-Received: by 2002:a05:622a:15ca:b0:50b:5286:f756 with SMTP id d75a77b69052e-50e36c51b96mr19278431cf.6.1776423976088;
        Fri, 17 Apr 2026 04:06:16 -0700 (PDT)
X-Received: by 2002:a05:622a:15ca:b0:50b:5286:f756 with SMTP id d75a77b69052e-50e36c51b96mr19277961cf.6.1776423975524;
        Fri, 17 Apr 2026 04:06:15 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba455043cdbsm43146566b.46.2026.04.17.04.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2026 04:06:14 -0700 (PDT)
Message-ID: <82e0d347-9ac9-497c-bc67-0db9206c5dd2@oss.qualcomm.com>
Date: Fri, 17 Apr 2026 13:06:11 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: glymur: Add crypto engine
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        johannes.goede@oss.qualcomm.com
Cc: Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
 <20260416-glymur_crypto_enablement-v1-2-75e768c1417c@oss.qualcomm.com>
 <653fc8bb-295f-4f1d-b9ac-a33e0d8a933b@oss.qualcomm.com>
 <b8f781b0-f7ba-407e-8603-ca504535a894@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <b8f781b0-f7ba-407e-8603-ca504535a894@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=buR8wkai c=1 sm=1 tr=0 ts=69e21429 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=PHqvf1VCJBkSuYI76_kA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: BamPrMjS2Noj7KSdFNSogpdyVDX438GU
X-Proofpoint-ORIG-GUID: BamPrMjS2Noj7KSdFNSogpdyVDX438GU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDExMCBTYWx0ZWRfXz1XD7Bap2mfm
 1nCWmRaEAelIFO3JcudXKhv/6r7YlXbF7RDDLNs5YoNBxnvmDEj9HcUowixy8ehlTw+ts4gYQT6
 jjBJoYNU1TUy1z0QD1Wq2wBYVzVXhwJWLckwc2+ZKM+695OpPhWK6SNde4U8t9q52F70wm/b0fo
 4FZm18iM7gV0RiJQyxo6/rwgIfuzE7DvETxEnDvQI4OpZ+8Ohixt5pdCaNfKqDjzMqyOc4M7FUi
 gK2zKuUbRpNDUiaigKbIeZQwIdgsXrIulpYPM8+2bSlEo6vVdXKyFUX8wQXiHTPi/CkwaHUXeZL
 KsiAIHuiQvRI2AWqjjm2H2hv1jWlWacOQWgAfe9S0AwEkfh4boMWKp8uj7W/HVyMO1Q++5GIujN
 IK1RGwPIAdWh7W4Xl7ka3kaVhBQlNfYgf+DXRIbSR6VVTzgEbvOEnV0ZkwZZcNR/xpHTi/Ul7jt
 My/o54e9OrRr2rvyKuw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_04,2026-04-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604170110

On 4/17/26 11:22 AM, Harshal Dev wrote:
> Hi,
> 
> On 4/16/2026 7:10 PM, Konrad Dybcio wrote:
>> On 4/16/26 3:07 PM, Harshal Dev wrote:
>>> On Glymur, there is a crypto engine IP block similar to the ones found on
>>> SM8x50 platforms.
>>>
>>> Describe the crypto engine and its BAM.
>>>
>>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>> ---
>>>  arch/arm64/boot/dts/qcom/glymur.dtsi | 26 ++++++++++++++++++++++++++
>>>  1 file changed, 26 insertions(+)
>>>
>>> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
>>> index f23cf81ddb77..e8c796f2c572 100644
>>> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
>>> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
>>> @@ -3675,6 +3675,32 @@ pcie3b_phy: phy@f10000 {
>>>  			status = "disabled";
>>>  		};
>>>  
>>> +		cryptobam: dma-controller@1dc4000 {
>>> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
>>> +			reg = <0x0 0x01dc4000 0x0 0x28000>;
>>> +			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
>>> +			#dma-cells = <1>;
>>> +			iommus = <&apps_smmu 0x480 0x0>,
>>> +				 <&apps_smmu 0x481 0x0>;
>>
>> It seems like these aren't the right SIDs on this platform.. Have you
>> tested this patch on hw?
> 
> Thanks a lot for catching this Konrad. The correct SID pairs are <0x80 0x0> and <0x81 0x0>.
> (I hope I don't need to pad them?)

No, you don't

> 
> Unfortunately, I could only validate driver probe on my limited ramdisk environment:
> 
> [    4.583802] qcrypto 1dfa000.crypto: Crypto device found, version 5.9.1
> 
> I was waiting for Wenjia to run the full crypto user-space test suite once. I'll update the
> SIDs and wait for a Tested-by from him.

Thanks

I think you should be able to get some life out of the crypto engine
via CONFIG_EXPERT=y && CONFIG_CRYPTO_SELFTESTS=y (which btw +Hans
mentioned reports a failure on Hamoa)

Konrad
