Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB652594
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2024 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732282367; cv=none; b=cidmtJD216D8atnSt27pSqnoWeaerjMjjiJOFfCZAPq+dGg4gCUic20ucby0O2+8uaB+F7BsTTjjR0NaZX5eN5MQkZB94Aax3Y378xxQL0JoFxkZFVgsEJxwgx1XzitTu4YhhaavjPhPmpXkJtwaFQlR6ZPCToyKPUZjKbJTYSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732282367; c=relaxed/simple;
	bh=QunPnbf0xVtgUmtvlwYZ4OjpvqL68OeWHfONZQcmhRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OtXVarmeYXVLtN8+cRqAx99ELzYrGyby3PORFpvE5nEAGT99b+ik0d7CEm4mnl/q4ZcXqARW4l5B6hOy7d1boH//H+cadPGVYcon0Sn5/jhLfv6XpXKog+WP3UK5cNR4kXvk1tDyo5VSz7lTUcweUIloO4E5f/hZF4b8t1fKFWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aLrgyS1c; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aLrgyS1c"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AM7ZRYW015590
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2024 13:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1SlWBCRiGH4qgb/LdCPP7xOCkPJR6Xa67WYb1u2GOSI=; b=aLrgyS1cU01fZQd9
	cQARyLvm+bzDwhN+cvVmJj7MKNi9Hqxh7xOyShQLlRASesTQMWqcX2zLISHWiH/w
	9tUtF4FCPgaVCz6OCGE0tMZRCPGxOAwmNcrzN0HJLGCv0aKdsvuZVLG+cI/D8NgL
	lwHSuuXICh3/g5MgKV0qrK/jBytAEAb0UTWhGuJcFlo1ZReolqGQERP7/qTCvIgI
	tz7u4u3hG3f5DZhJ5TmsN+hk3dXcmkXU9SQwP1gK9Uh2VHk53S1ryA+khRgP1L7X
	NpfjZtyGq+D+NftpNnZnc3HHbssesqwih85zNJXu8Qx33Zj0h+o2JE0zBcDTAM2d
	pOdHkQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4320y9m9d7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2024 13:32:43 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-460e81465f8so4703091cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2024 05:32:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732282362; x=1732887162;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1SlWBCRiGH4qgb/LdCPP7xOCkPJR6Xa67WYb1u2GOSI=;
        b=dXoqT7E2cVvh+j3nkC3dESktm/3G2bgrM6PfTr40NhekvA3pd1QVLERClh5X2MuUin
         BClzmycxNJkvP3PX14TOIQukAvEwXpjhmOxaiCIx+VYKc/QHfngo/sas61dtzy3vmlE3
         qCNK8Lcht/fRtxRoBMS77f3l6mj4D+UrVlA7XO22QmOSPd+ePTHDtGngrU+sF38vkimz
         zH8rAHnYdgwfGhY//1CTVsUb5e593ih7cBmVXHInT7SwdQwITTvPcSPrWwiIob5E3Uhj
         3U5IOHNvcw1DRI5pExvyqzdrWEXkMX4I10PLbgFsOeQwhIIo4x+SN4BMopt7BFDDfBMW
         z+pg==
X-Forwarded-Encrypted: i=1; AJvYcCXv2+bImyHrgidHJcPwQ5mv/xAqSCn4PFsVSjsrg42Wj+sooEw3ioUe5n+YbghZPlECXHhxIC6qaq1/VX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOe8aLikLjjs+K1a42jg+MqmNIsD5X0w3PzZO6VwfduuHrjJJf
	WcOd2bGM0YMPxjzvpsD69Eke+psAkeLE/v+srkEQU7fKAD05N5Mp+nJPOVlYfOIGU14NWJU5Lcu
	FSK96dG5xKDe3NtdozomSC5OYKgUmTRFmJ7uF0bzlwPI8F0nna/Fbr7hX/E0Q+HU=
X-Gm-Gg: ASbGnctJvBaWK/FhT2kekYxEUGKgH3OrsRLtWidl68FmMPdhDjLrMOMa8gResQJ3bEV
	ewXju912W2JpUft3B/sNO3JzWOPsWR/2YTOJNTftbL80G91AYRE4/TBLoK6IGTgIKHrdetgPHZz
	rBOpJMCk+Q440oqbirFAv+RG0SpKoGuy3b87+EbCMtLpg0C2AmqwBxmlnJNo20o40MttIqkhYNB
	Y2SW15oiBgN8ivBwtFhrJc24DepJwdsgQGl3AFTcAfVtxa3tC6HzZ2h6VlxrGcQ55q0dRore8h5
	szqMtCiMFAAEtY8/iSio/Oca2kH/mJw=
X-Received: by 2002:a05:622a:3c8:b0:460:3a41:a9e5 with SMTP id d75a77b69052e-4653d62fa60mr16934681cf.13.1732282362286;
        Fri, 22 Nov 2024 05:32:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVf3O3jfV+1QWDBQ7DzPfL0PVS4kp8Bcv2BSTm+EqwdcoTXZJp32T0/6sMGFnYNedbZPT3iw==
X-Received: by 2002:a05:622a:3c8:b0:460:3a41:a9e5 with SMTP id d75a77b69052e-4653d62fa60mr16934391cf.13.1732282361868;
        Fri, 22 Nov 2024 05:32:41 -0800 (PST)
Received: from [192.168.212.120] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d01d3c00aesm916730a12.43.2024.11.22.05.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 05:32:41 -0800 (PST)
Message-ID: <211af8cb-6cc1-478e-b981-f88f70733872@oss.qualcomm.com>
Date: Fri, 22 Nov 2024 14:32:38 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] arm64: dts: qcom: qcs8300: enable the inline
 crypto engine
To: Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20241122132044.30024-1-quic_yrangana@quicinc.com>
 <20241122132044.30024-3-quic_yrangana@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20241122132044.30024-3-quic_yrangana@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: eGdpxr58i2eQ2hTdvFRlJN6b8ZVcbGle
X-Proofpoint-ORIG-GUID: eGdpxr58i2eQ2hTdvFRlJN6b8ZVcbGle
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411220114

On 22.11.2024 2:20 PM, Yuvaraj Ranganathan wrote:
> Add an ICE node to qcs8300 SoC description and enable it by adding a
> phandle to the UFS node.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Getting *a review* does *not* mean I gave you a Reviewed-by tag.

https://docs.kernel.org/process/submitting-patches.html#using-reported-by-tested-by-reviewed-by-suggested-by-and-fixes

> Signed-off-by: Yuvaraj Ranganathan <quic_yrangana@quicinc.com>
> ---
>  arch/arm64/boot/dts/qcom/qcs8300.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/qcs8300.dtsi b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
> index 2c35f96c3f28..ab91c3b7bba6 100644
> --- a/arch/arm64/boot/dts/qcom/qcs8300.dtsi
> +++ b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
> @@ -685,6 +685,7 @@ &mc_virt SLAVE_EBI1 0>,
>  					<0 0>,
>  					<0 0>,
>  					<0 0>;
> +			qcom,ice = <&ice>;
>  			status = "disabled";
>  		};
>  
> @@ -710,6 +711,13 @@ ufs_mem_phy: phy@1d87000 {
>  			status = "disabled";
>  		};
>  
> +		ice: crypto@1d88000 {
> +			compatible = "qcom,qcs8300-inline-crypto-engine",
> +				     "qcom,inline-crypto-engine";
> +			reg = <0x0 0x01d88000 0x0 0x18000>;
> +			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
> +		};

Although this looks good now, so I'll allow you to keep it.

I won't add it a second time here to avoid confusing the maintainer
tools.

Konrad
