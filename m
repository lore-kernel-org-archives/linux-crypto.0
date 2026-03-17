Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC1532AAA0
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739647; cv=none; b=mbMADxbsJElWmUK1jY94pGVKoXDDgp8lspg+MRquR6CAS8eKdNj8zwqf+apbKBPdkS+p4SI5wG+Xp3mBh26v4fdWoBJNDIWby9/EKtZpb9+BMVlJachQKFcvQ2MSbfULvkIZ6fgd04D3elh2XoX++NIF+uZoMNK8twY+QDaQA7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739647; c=relaxed/simple;
	bh=PqEXds4GrlgZ3n52VaQfUbW8LHZn+0T/t/toWPk5DGE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jy8DrFfdGNdZxXx6WTHIsjnIfVoVHOlAfKfxHuSVJaECT7QXK+pAnlO7by74UcDtS2b9TrPPUobqIId2O4vRJmZDFtLjVXCjv+r5JJXPieJwW2+4ZlwPdfcaLQ424uWCoERPCXdnBAHz2ATjJByDZwMyx2LGvibM/QB5wb9kEwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AuOBz6uW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Yeusu0S6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AuOBz6uW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Yeusu0S6"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H7PTA13295277
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VsUDLAst7GCYzE791DlmXpqcmyhgQ6vfLLVyLS8iSTk=; b=AuOBz6uWd9ill70Q
	46wqbr2fS/zJP2yLzkN7fDs3xLKvHI6NXUfPqWkwFxlfz4Hm7QI1iY3cgwnGurV6
	+frQ5nwVv6zK8l2VLyH8fxGcIOUqwaIffATyxrFJ0FiZ2P02wYWQufHNIfSk7UKT
	aEVBRriPJ6DCqzR94AKX29Y+cQ4AOMKLm1FQiVEFV3Aq7147B/ysgayU1tB7GXLl
	N2EoBe554fTqYORXjtDcPZo5l91m6wW0ccqO1nWKJzPOeczJj5EexYfzg3fvS1No
	XyJZUelDKhY0ypCkXiFzKoSXiAvp75FrRF8oGO+DLZ8jUffOz/YKv0F9QvU+24aj
	p+lu1A==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxkuy3cc7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:27:24 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b061868724so77362275ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 02:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773739644; x=1774344444; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VsUDLAst7GCYzE791DlmXpqcmyhgQ6vfLLVyLS8iSTk=;
        b=Yeusu0S606MaraiVAAGPK3UxoNCpCGzfOB4gaogeVoJxkBVRhTJIxFS15sbcS8VH5C
         wPMzYnIWMdxWxCE/+cNljVooGs3bpHiLuPqhkLy2SeqQJjdMcqyeb3sCI7MOXd+6qTAo
         AUfGwZgpovUQPLCnaVzmgFeagLCiDkP15aacV34HMA5EQKVuNDZY78GQ8CaTN4vTUJv1
         DmuALXAfnb1/GlRKR8Hh1WTgV+hEF6D5BfZaVuXvSnfOJt0CXaSTVjFbrfmwFrinFf9N
         pNiBwxfKWHxKFz+8iJjBML0DcEp5yAgB0vIrNc6TQqQzFUfNUwfp3HLFBTMs8d78KSGa
         SOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739644; x=1774344444;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VsUDLAst7GCYzE791DlmXpqcmyhgQ6vfLLVyLS8iSTk=;
        b=UhHklpjqPB8pLD2j4wTixaUNxtPEisbvAJonsXtCYSJhSQkvphXvfqpJ1d/AJRi+v/
         dO4y1Zspi1fVIBgTraR6FUh16BdoilVh2Ok94kBIfBopNQ3LgO8YaXI2A5Y644l/ditw
         oPFNC3GP2UE3sl/Pg4erfBY0+dpYD0tvsulWv39PjqpzAsbLpKUu1uTF4fyG7GdrXxjP
         7c7mX257dAnmdvWlFoFN3FgVkBBVeSSwRVT+gJGqVBLOVwBEtvXJGBWpcl/QGqKdb7SH
         YOdDs2cJK1h4flp0f6TceUd1PIYjnVph20XiLW1FtQSgGNtYv2Nnhxk2rmsP0wOT6lGI
         oIhA==
X-Forwarded-Encrypted: i=1; AJvYcCWOI9xIZ6Yuwwa9aYJ2kFB7aOSOrVNjzBZtGU09CBQ1jTjynK4ApVqm9dkqKLSGmMn1e/muy85ez7f0juo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3uSmQUA7MF7vVxJI7Y2kAxm0xlO0yxCWz9CM2xHXt2fEBsIpY
	a9pTi5xGImpFdjmhRCIqVO0i2QjX11fnMyELE7ZCQUdMfuU8XnpGCTkayTWPrbn3FdqhophQvch
	L7fNwKbPMH0hmpOVceG+FSwOs/EfGhM4oCE2qZErgFXEyMlNPUICVNNsSKY0/vv+0jb4=
X-Gm-Gg: ATEYQzyBjrEXQph2k8qTm9RGN/MGnZ2VCJ3Z4i5NLpuucwD5IfNpRF3/FBPRniqGR7o
	MkOvIwZGpYyS/0Eh4Ho16mVR6Ldvz4lli5Iiar6yaUL8bPo3ESLv4bDgYm+/HemTslM/Havl1RA
	Dq6/w4G6JD8bGIFq/Xmd6/HkOkiMLcMPtWr6ZSoVUBBVPOaAvALpYOLiwYfejHyN8I4iJ2+0aWo
	l+sqWnezfJ7CSpfFRJaq3Mma4oiB8CGOP4ctf73wLj274/3/jwbuclMNw8+rf5fCeqoEPhunCtV
	D5mIAmmHRSz51l+xpmmY8IKfk/TufGMfJ5twCEE+xSYiSgHVNtQ5bVmeOP7S1vd+mgCn/mHdwXx
	yzvF+iU6330Q6kzVkA7wAWqDwc6W7VjzaH8O95RsGwyaWOaYLPI8=
X-Received: by 2002:a17:902:d505:b0:2ae:ced7:4650 with SMTP id d9443c01a7336-2aeced7510fmr163910405ad.24.1773739643819;
        Tue, 17 Mar 2026 02:27:23 -0700 (PDT)
X-Received: by 2002:a17:902:d505:b0:2ae:ced7:4650 with SMTP id d9443c01a7336-2aeced7510fmr163910045ad.24.1773739643365;
        Tue, 17 Mar 2026 02:27:23 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0659a90fesm19021845ad.45.2026.03.17.02.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 02:27:23 -0700 (PDT)
Message-ID: <f4358798-c40b-4425-9f7a-230cdc6398ce@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 14:57:18 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] arm64: dts: qcom: sm8250: Add inline crypto engine
To: Alexander Koskovich <akoskovich@pm.me>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <20260309-sm8250-ice-v3-0-418bf5c5c042@pm.me>
 <20260309-sm8250-ice-v3-2-418bf5c5c042@pm.me>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260309-sm8250-ice-v3-2-418bf5c5c042@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=br1BxUai c=1 sm=1 tr=0 ts=69b91e7c cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=LnETC1lSbQsXWPk8PCwA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MyBTYWx0ZWRfXz4HECiXDA67k
 cI6i+Zo0F5sBcUVZ7eW0TlnLI2u9VRQfR9aBcgIpxW0Hej5hlbCB1EwTrfr1wZGibSL8sJPpOBm
 NAXwFUHLsptX8glcoRNK+2788grXgR6HPhmm/Me/0H4SS/8M4qf4XDRPAldnWj15PjJ3uaUGRGf
 PIY8IeMUkhUJ+tMHTp+J8iMz9y+S7IA74GrEFkTOkJO41IqAudRmv4WBR8+9Yd2O5EoADytEG6J
 hRPt2hEh2h3uRMk47BE6Hc1aBX0OhDTbUT0JZRiRBVpQjzcu8rJfrenNCJ6+FJJc1A00bWcwxx0
 5MVNPF8H+crXwPYoaW0UWkRsnqzzfwq5z4ZFoj95pNzQr5D0UqB2Ezbr+SCYIXOtw0hgN69GCJo
 bPvD9gzIDaB1/6+Dzg/LGTdzrAgw7+/5/tUuhXraFP326VmK6Zlen6EMGus35rIbKizkY/1AdCK
 9W0aw/ZY7Um+n7tXybw==
X-Proofpoint-ORIG-GUID: pQbWVY0J6gZ0U7GiWQ2jAFg9IIkiVR8S
X-Proofpoint-GUID: pQbWVY0J6gZ0U7GiWQ2jAFg9IIkiVR8S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170083

Hi Alexander,

On 3/10/2026 8:42 AM, Alexander Koskovich wrote:
> Add the ICE found on sm8250 and link it to the UFS node.
> 
> qcom-ice 1d90000.crypto: Found QC Inline Crypto Engine (ICE) v3.1.81
> 
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
> ---
>  arch/arm64/boot/dts/qcom/sm8250.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> index c7dffa440074..b49007934278 100644
> --- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> @@ -2513,6 +2513,8 @@ ufs_mem_hc: ufshc@1d84000 {
>  
>  			power-domains = <&gcc UFS_PHY_GDSC>;
>  
> +			qcom,ice = <&ice>;
> +
>  			iommus = <&apps_smmu 0x0e0 0>, <&apps_smmu 0x4e0 0>;
>  
>  			clock-names =
> @@ -2592,6 +2594,17 @@ ufs_mem_phy: phy@1d87000 {
>  			status = "disabled";
>  		};
>  
> +		ice: crypto@1d90000 {
> +			compatible = "qcom,sm8250-inline-crypto-engine",
> +				     "qcom,inline-crypto-engine";
> +			reg = <0 0x01d90000 0 0x8000>;
> +			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
> +				 <&gcc GCC_UFS_PHY_AHB_CLK>;
> +			clock-names = "ice_core_clk",
> +				      "iface_clk";

As per comments on v2 of this patch, the clock names have been updated to 'core' and 'iface'.
Please update the same here since your patch depends on this one:

https://lore.kernel.org/all/20260317-qcom_ice_power_and_clk_vote-v3-1-53371dbabd6a@oss.qualcomm.com/

Regards,
Harshal

> +			power-domains = <&gcc UFS_PHY_GDSC>;
> +		};
> +
>  		cryptobam: dma-controller@1dc4000 {
>  			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
>  			reg = <0 0x01dc4000 0 0x24000>;
> 

