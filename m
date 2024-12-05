Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F253619ABC6
	for <linux-crypto@vger.kernel.org>; Thu,  5 Dec 2024 19:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733428283; cv=none; b=CyGJG5QQ59q46ouVMHGY+ioT/u0jgP01oBsa4gfkRTsaWFMFP/fKAUwo5kTN5TaI3dh9L/+mvLz6Rl+P9jU81MBeQQWi4PKqIQLY7ip/XM+2hHZaEbf3LR2BQalLlC1l5YYYizFOA6QTcoq90SIOROSbfFcQ8IpXSqsqiiTasYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733428283; c=relaxed/simple;
	bh=bd/rcxhI8GJ+7LgB3usB5IRB7XaD8/+ZWzOUld/X5OI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eJ1QT+QzG4qxa73mmasLpagfNO4oqyB0WWMyA+KglSb1bNZ3yq2uTVA5OoUmrvW+iZLyRpNl5sLOIFEuI/WPrHJ/pAg6F/59HxDfxfWll/q/3iLxi9U974WPBLz97FH8b2giAFAPyYfkPzUgH7aiZ0YvueH5S98Ifbbh0GWnlBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f1fpSzAP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f1fpSzAP"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5HaNa5003813
	for <linux-crypto@vger.kernel.org>; Thu, 5 Dec 2024 19:51:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	k9cm5lSjldF/HZCvqlWFShBMiLrsI/ByFg9XQ1zht7w=; b=f1fpSzAPgsGrn+65
	Fqck3DGaTXKHhR0DbhhMX6VagqXNFSTxVwS0RFuN3i5Cyoc9oE+f+9zZ1iwS6trr
	N3bbuVhVIxLcj9IskKLtOHaEBfzAWeRb2vq2f8RJGZ7PS4R/zX+Vwp3uJFg33evJ
	7eJplLoaG/BGT3WDnkAx6nZcCdbyrYSdIPQJkoWggaGGuMlyL7cCKnrZIjrLoVJs
	VkgVNx3trR6/0S2KRIsMGss+yiTh9eTHA7iQEeaGNhtK6IJKsO7SJn+jzupxkkUh
	SkgyoadvVfxRG6Etus1iEDP4KlYZn105RUjlkN2eFyQKHewfnIS5hiMa11bljXPS
	7AHLCA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 43bbqm18t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 05 Dec 2024 19:51:21 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4668cee0202so2262281cf.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Dec 2024 11:51:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733428264; x=1734033064;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k9cm5lSjldF/HZCvqlWFShBMiLrsI/ByFg9XQ1zht7w=;
        b=s4BHFca05o7CMJa0gKlI/QwxlTq/yFlfcGGmmgFsNqJhoStRPDq0ok31o4u02710s4
         ugKtTWFIkNdCkJuhOjvbXhQy9mgqLm7V0++WT1ozmogoyy7ZtgehBH4QxiuTn72wC7ol
         iRkrWa/t5aqS45WB77Wzc17ekfd6SdJBq2vWNSONpLUYUQEJGGtKT3h3CbfMbMIZ21WZ
         dKqZpW+IpO+p3Xcm9l7etFrNwfpqnGpN/OuQQHRn0K3MNJpwq4vUqoJBQslLbMjD3FNd
         UWQ9OWg7JNSdywPH/+Ero3XyGfISc5m6KvatVjXZPRS8AGsTgGCUu8u5G7vFGxo9oZpH
         UePw==
X-Gm-Message-State: AOJu0YxkvbaLTvMCmqonniq9iH/KAye6URDMWz3JeXFZutzVhV1pqJKG
	AzuXqOgnImEDzXCi1WgB6XdelB/fQ2bi1TtsUgm3h9npgO3Xx+5VSe8KMXT0AgLPUqw6omQq0cA
	cIahBX9Ih89vIHH6vhhhMXfv8L1vVRCXhVAAdSi+o1gtP5PzsxSqh2x7WjGMlE9A=
X-Gm-Gg: ASbGncu6mFSOM0Z4rva882m/v+kHu7rKeC5fBckJU7kpFnXA5ohJOGUffryHbw/5gFt
	WjG8vr2QxPwfXWlY3EeIrIMkUpXSO5GVKmjHTUe+SMfZmg+OdzVtS4z3StesIA/GMelzcpzEDfq
	fo4Sk8mbNgIvzb3S3TlvJiPpXwVqEuh+MGc6a2qIfvFrjUztTSZVgU+gVq03XNbIJ3aqA+xZj4e
	Ya9eKGl2FeDtYegNMGfZh7O+4A5x9p7ytaRRg+1+Qw9MHgRec/GPTBB0tGnohITpMkBIJt5bRfa
	WyADvLlwZ2jUDecJM8LU//boD/sF3h0=
X-Received: by 2002:ac8:5e46:0:b0:461:2137:ba4d with SMTP id d75a77b69052e-46734e0d25dmr3117631cf.15.1733428264015;
        Thu, 05 Dec 2024 11:51:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEusIBLnVRK9pVERR8e39tkzndxRKaWZWLYk0nIvVVQfvn8maq9fL9bdBqs21dRJYgjAMhZBg==
X-Received: by 2002:ac8:5e46:0:b0:461:2137:ba4d with SMTP id d75a77b69052e-46734e0d25dmr3117311cf.15.1733428263567;
        Thu, 05 Dec 2024 11:51:03 -0800 (PST)
Received: from [192.168.212.120] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa62601b5ddsm133485666b.118.2024.12.05.11.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2024 11:51:03 -0800 (PST)
Message-ID: <de2ea78e-7887-43f7-a478-52e050079992@oss.qualcomm.com>
Date: Thu, 5 Dec 2024 20:51:01 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] arm64: dts: qcom: qcs8300: add QCrypto nodes
To: Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241125111923.2218374-1-quic_yrangana@quicinc.com>
 <20241125111923.2218374-3-quic_yrangana@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20241125111923.2218374-3-quic_yrangana@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: BcPaN-VcILCnkrG7ei-zBJZ9VLdteaXk
X-Proofpoint-ORIG-GUID: BcPaN-VcILCnkrG7ei-zBJZ9VLdteaXk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=924 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412050148

On 25.11.2024 12:19 PM, Yuvaraj Ranganathan wrote:
> Add the QCE and Crypto BAM DMA nodes.
> 
> Signed-off-by: Yuvaraj Ranganathan <quic_yrangana@quicinc.com>
> ---
>  arch/arm64/boot/dts/qcom/qcs8300.dtsi | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/qcs8300.dtsi b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
> index 2c35f96c3f28..d699706638f0 100644
> --- a/arch/arm64/boot/dts/qcom/qcs8300.dtsi
> +++ b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
> @@ -710,6 +710,30 @@ ufs_mem_phy: phy@1d87000 {
>  			status = "disabled";
>  		};
>  
> +		cryptobam: dma-controller@1dc4000 {
> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
> +			reg = <0x0 0x01dc4000 0x0 0x28000>;
> +			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
> +			#dma-cells = <1>;
> +			qcom,ee = <0>;
> +			qcom,controlled-remotely;
> +			num-channels = <20>;
> +			qcom,num-ees = <4>;
> +			iommus = <&apps_smmu 0x480 0x00>,
> +				 <&apps_smmu 0x481 0x00>;
> +		};
> +
> +		crypto: crypto@1dfa000 {
> +			compatible = "qcom,qcs8300-qce", "qcom,qce";
> +			reg = <0x0 0x01dfa000 0x0 0x6000>;
> +			dmas = <&cryptobam 4>, <&cryptobam 5>;
> +			dma-names = "rx", "tx";
> +			iommus = <&apps_smmu 0x480 0x00>,
> +				 <&apps_smmu 0x481 0x00>;
> +			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE0 QCOM_ICC_TAG_ALWAYS &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;

Please wrap this line, see other files for an example

Konrad
