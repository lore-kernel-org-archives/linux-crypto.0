Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806F3340A5D
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 12:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766147552; cv=none; b=OSqQUjUZXaMBCio5oFUHSjvdliTq+7bgVFWb28XLFJFvLmAgvL1Vgtp5SDp718PgiWPlHiXdklQKMSfxa9WAOEo8ydJjuR3gOpfBNsFZLsl32ngvJKUATTC8yxAgLAGGNnaWAhlz4lgFtb86xSZaGs79eRzaOpn5e7PKxV3UrRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766147552; c=relaxed/simple;
	bh=mZFZf18BY/ufK6zFxztQ9i1a1A/GLj96ahIOqJb5zVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JSjAhkipDEsuc78MkrqmDLrTrTjxQo1vB1uAnk9xgoOy401QWdmzWHIX3tr5AkyAXQrR3nNSm7ZUib5wEE/nsCta1EvO+T7sSiUORDJVFppdy0oWLTo0JC945pItlGTDp90CiLkrOzGgINxK6SS0oUT+TuCauxYdFXqSOIUdXEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bOJZeZx3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RCV6HPw/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bOJZeZx3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RCV6HPw/"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJAvH743559188
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 12:32:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8u9oyvu1hGtJNJiR4DhBrZamy4UAVZ53w+H+cr2gGAM=; b=bOJZeZx3YgGwsbKT
	BDuhqpcasnPHG5xnBxsKd5rFHbg6tOTv8t56t33asZkM3kvmbTf/MDBS2gsV3BnT
	+rAbQiUWkpKJX7LBx3owpk0GRxnuo8uQOw6jBleIeg50DlehYdJeP3AxRdbnraHz
	AOdIlSw4WAM8v/PByvKQwB1ATLjltLrN20KHW7vkgTyBIA4Zsho2/JAslg+Xh8Xs
	mDzxKXObH8eBImEvWmIhVobw7Vz/l7Cokhi3Ruaiqk3Of1WQD8n3JtGRSOq5z5ND
	2q8Ww3w+Dl0UOnuT+hNu1z2hxWMcGpO+qWL3LQbXKBXpo5otNzwDxEciltxG++e6
	oOvGuw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b4r2canhs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 12:32:30 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b2fdf3a190so31237885a.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 04:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766147550; x=1766752350; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8u9oyvu1hGtJNJiR4DhBrZamy4UAVZ53w+H+cr2gGAM=;
        b=RCV6HPw/CNbwAHzwQfZV4P5g3LOG3Q+e1DAeJFA1tc1I6hpIzhL2nHH6VFyQk6DPlf
         AC20J2/rMOKOGcNtVkDt2J/zi5np24xOCX9Z2NWoze1LJqjAAr/Lg9I9cqgVcj6JSuaj
         79fLghKt+cPgb2tcdU7z1hrzPApmyoaqghX6Cq6+kf7fzr22zYuh0YOxV3hu355EAJrY
         4TuWIvfmWLk6UrczhPYQiWSRYQbxbHXD0Dog9czzjvaLoH41HmY+ywiEuZsBlvXa2dMK
         SQXLFxRR8B6RtArszokvtoyg61TG9L6jgTSyG3D3eYuyX1ygEnvy6LURyoQh5pru5kKT
         1Giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766147550; x=1766752350;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8u9oyvu1hGtJNJiR4DhBrZamy4UAVZ53w+H+cr2gGAM=;
        b=Wy1OruB7u7DVoyR8b7+dVr8Olv3h6QC58naye+/XiqQA29yxVnzCYqVITJmvRRZqQr
         bgSBv1HJkmQPre+ijAguX2ScdNjHy2x4ZRdWMtjkgLvoEtwKcb8LHU+5YqB+6ZD2ly/7
         J71UW9QtYpoZACOdMaEbv7TZPhfN9osmEoE8PLRy0shgozO1d/6ejrwlh9cU1rGoI7YH
         QodXFDWegjORmfHhdLsVSW8MRGQpbuy/ZNrV2uCe4AgzeincSC1uFvQt3KfW4oZKIRM2
         hNDVdiMsX0ToZ72VaN+1/QoRBmdQmZMfmEagJpVpGEdE936iKdaCcalGvG88NUxlNfzv
         YYNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUR73aG6cN2lpedvMyj/1NtZUw2FU8PtS+eUUIqDdVPxjXdUSrXjo2MBp93pFZw1UotvLN6PBBzrIMkMyk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi63BDOFQTGpkQMMBR+LzSNdo7X7HC+Kmxnr10QpY4CG22391T
	xoKESESTl9+n5LHCzUaIq8YoYKpt+INchCmhU/oT16/bzg3b6rMlK/uJBqOQqKD1FV8z2wJyBm7
	RkjVzHaBKXqgScPBZ6S3OeqVk/cQglD4XOGK/TVpVNo1b5lMuzOiMV6jV0EWAfzemIes=
X-Gm-Gg: AY/fxX4mMhjUi8S4Go5zEi3Mpw6lNOdUgk6C98FACSA0VaoxMLiIGnUuJV7WYEyMpLs
	sDGlohYlTVwHXGZzBzkxMMzSlMF+WSWj9LbTcA1pqf7CZnCZzx8BVNYdfLNz32TU4wqm2CESRlB
	NszwjFeIRyUYzBw8gzbZgc3Wt6+fxzd6tk3qrZ4JNQox+/JA+V/Med/YJJrUEVmMkVJu2taUi86
	Mv5exBTG6tUDmfLxrwCQlFt0ysa7fL+MGCjlsUvKdGCYZ6Ak6jNT1SPJz5oNpNbVUmrKU4p0J7p
	zCD6Bj24VT2b6AVWnWMdsgsyK/OAIUA9aM5wVBWOIwr2DKLMys0iN9vv1w4b/z2pfgD04C3u6V4
	mFVSdqDLhXtjfkOgCCXIBcMviGcT1hwz9pjRPn0ZM6DLH8YSENe+/yrKhN2edTnURDA==
X-Received: by 2002:a05:622a:5c8:b0:4ed:a574:64cb with SMTP id d75a77b69052e-4f4abd173a9mr28999791cf.3.1766147549683;
        Fri, 19 Dec 2025 04:32:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCLarACSlXZpDNlKsP8TnF+SwJ7xKQm3Iz2dIDLFiWlhyQ6rlJ+J5TUvkOCo7O4V6PCoN0cQ==
X-Received: by 2002:a05:622a:5c8:b0:4ed:a574:64cb with SMTP id d75a77b69052e-4f4abd173a9mr28999371cf.3.1766147549199;
        Fri, 19 Dec 2025 04:32:29 -0800 (PST)
Received: from [192.168.119.72] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037ad2732sm223677366b.20.2025.12.19.04.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 04:32:28 -0800 (PST)
Message-ID: <b09d427d-0276-46ef-ac85-8f4bd4dbf42e@oss.qualcomm.com>
Date: Fri, 19 Dec 2025 13:32:25 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] arm64: dts: qcom: x1e80100: add TRNG node
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
References: <20251211-trng_dt_binding_x1e80100-v3-0-397fb3872ff1@oss.qualcomm.com>
 <20251211-trng_dt_binding_x1e80100-v3-2-397fb3872ff1@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251211-trng_dt_binding_x1e80100-v3-2-397fb3872ff1@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=cpSWUl4i c=1 sm=1 tr=0 ts=694545de cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=-fCe_xzhPpQA6hE3_okA:9
 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDEwNCBTYWx0ZWRfX24eJLFgkNf1+
 6lO+aZwrGQGNF+NDG0TfbNFMv3NM9XXs+Vtp18cE+82ap4Sl4U/m64/Lv4thQ8Xg0Sh4bBXAm4v
 6Kt1wnprtwO6ST9fAhZ895oqDLoqoleYdZUXIYY8jS8/BOX7iWMyVsONyl6hkJXhfdnqH7le3+Y
 urwG/eA5pgvHOVX82sliQTy3FGT1vhjLDFGG1yL+oaib9vAE2Uv215yrUENAW/eQtcSsjmz0xKq
 JSXkkjxFELUFZ2VA7EePiVMJOjIzmvVRuhu/oyxcMYrqjzsQLlimZGiio8OC7cCGgF2+EC33wxq
 sEjk+CekJj+h3MVZZjz39sowlHF/0qb6xa4WobnDCgMruW6WT8cEnKdpeo7JObdR3qbtymhOY0b
 r2KatqELe39RWdf+7TG7Usy0/2bE8kFEf6aO2HTbd22vDs1loJ2ftz5fs5MkFrqx7S9FPpOU1nx
 71EjCD2t0zLkxodXgyg==
X-Proofpoint-GUID: MFdo10rL_54mFLjQkevpX0GQqxiEl6bV
X-Proofpoint-ORIG-GUID: MFdo10rL_54mFLjQkevpX0GQqxiEl6bV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512190104

On 12/11/25 9:45 AM, Harshal Dev wrote:
> The x1e80100 SoC has a True Random Number Generator, add the node with
> the correct compatible set.
> 
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/x1e80100.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
> index 51576d9c935d..c17c02c347be 100644
> --- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
> +++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
> @@ -3033,6 +3033,11 @@ usb_1_ss2_qmpphy_dp_in: endpoint {
>  			};
>  		};
>  
> +		rng: rng@10c3000 {
> +			compatible = "qcom,x1e80100-trng", "qcom,trng";
> +			reg = <0x0 0x10c3000 0x0 0x1000>;

Please add a leading zero to the address, so that it's padded to 8
hex digits, like all other nodes in this file

with that:

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
