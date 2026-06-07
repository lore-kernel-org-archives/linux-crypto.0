Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F3730F52B
	for <linux-crypto@vger.kernel.org>; Sun,  7 Jun 2026 10:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827236; cv=none; b=BtgOrLH14IWP+WmMk3M0P7SSGL8gkqsRDSXhbCgDHOJFD76A/GJGN3+jg7SBvCvvjFEO0Ak3dJF1S2CzdDufqoNqhF90wp2OIDEK8Fa5CqKIRCX+OUVSqqKC5hiZKmnL/B2lBnqtqpBBjTc0Mf/g5AucLSzhyYeXSUBeEYk6JTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827236; c=relaxed/simple;
	bh=8b8noawsfw61MgEwfkdxf4YgtoSVitAEIplliythSQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nzsKbNf9pXdkAJEvkO1h/tSXKtAJnlvURUygZZOvyWp3TUnVlyZhJqAHkW+JJ+3wu7rKKTC3Iz3PSOsm2YfLea9aCFj4Blz+hp21oaESiYo2TC+peXIEJT1u1OIf0iPd86Ts/VBcxIIT2PCXL0svHTCx1oVDw7aeoQ1IJu9yMMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kOtWLESm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RX7A1VDR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kOtWLESm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RX7A1VDR"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6577AwrO4122657
	for <linux-crypto@vger.kernel.org>; Sun, 7 Jun 2026 10:13:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=cC0O2A1C2rKd2LMRwWo0UDbf
	PSQQh6LFCm650/y8+MY=; b=kOtWLESmVDiMAJkiNBNjbvHb9DVqbW3eioOTZc/k
	pnCGFhbWK/Q8adEZVetXDMrSpEQfmez2FWvAkKzYQsavAAz82l3MQpKOJIWgNpOm
	6Q6YgDOteVL6k9qHMa3ACV3VunCxkOwfLJAMMYLdH/JpiYblVaWEdoC1g42NjXWE
	M6VUrvmYEkh/FqCKQuHj6Rltj3zY2gxEhMuyvxj7QRrGAbmjvURDdYq92FxfjMd+
	cSdARZtu0swZcZdol5EKEV9bnT1qGLOeY+uP/cH40L3a41d3nyqFQ4zfW2I8MGaL
	LSlFCMBK5RLnRXBpSXJLtm3QC9qjTleg5qtoqqBDBzedog==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4em9k3ky57-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 10:13:53 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5175bb9d47fso69087251cf.0
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 03:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780827233; x=1781432033; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cC0O2A1C2rKd2LMRwWo0UDbfPSQQh6LFCm650/y8+MY=;
        b=RX7A1VDREqViNJa8GL9UbzfivziUHqujiAo1OEQcScUZxrggu0RAeFQZahRSqHU046
         odPVkNiMwqSuNJeCzAnOGGXqobOVSaPpBtD5om7beC+0k+o4OAm/U0dkcOLKWZaysjIu
         D6DD6lPTWSyqRddUVANdCW6iWbP3zCF/aKZLiiKRbyqpGQ3pexSU4EgAL2dDOXkfGsqg
         szRHOx2fhAeJ5Cynhg3gLhJGQ1LiggiNvD4YkzztQ1v76tXmiR6N6CbfESQRRlLAS6HE
         MWcDR/VCSuhd1mktKgLOERVaSztzvcoYJjD9hWWtcwCial7cJWnomeCCkyx3UyodPUyL
         jkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780827233; x=1781432033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cC0O2A1C2rKd2LMRwWo0UDbfPSQQh6LFCm650/y8+MY=;
        b=aQcxahbXQ4BNjpQBkDxQYbwzCAHci9Va39QfrSLW/+gWDJqK5+CRTYCQ6YkHe1MCKa
         zhIXBBTbSfc4SSbvRXthJtoCGUUyh++Ys+uSF8BQ5MQINQNzfWH4jQb0uHsndZ4rt/kc
         BHIuUPLIta+aoUeIfjm9fBQKK37f5gDu9fbwqEr3cWNk40csU3h13aBtI7e8wa6EK910
         0//k927wa8UgyH9ZHy5/KOAKBgX4HjbrVBHKjJXNyKzQCF4RezgSQMGHwio3xq7K11f+
         YebJ+swGBRrglRmHY094kMIGoNMmf1hZUDW5f8/xkT/9DPrk75+1wfJwILYBrcdpw5s1
         t3zg==
X-Forwarded-Encrypted: i=1; AFNElJ/IQrvvItgk1Dp369K7Bwi6hrgS3XGVlCZvvoqploFpTnnjzaD+/zrXRKZG6P9CObeF3GzOdX58K5i2MWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjMbxVL/DlBFTcObngyq6kRiYDx+Lko4ig45mUmFHVEzt6+y3D
	WaLyXxxOzxWF3UkdOoXlCmokS00po0LZ5FH3OCbGCOh9XbX8c10/nlSWgD+dgE4SPjoNbuplFht
	IZoxW9jJPKm4/4zwNoce2LfOPAgHVyIm9Wzm3OpDbZvMu03/yTAXJUxwKiw5BGdIiIb0=
X-Gm-Gg: Acq92OH3NBeauYvuy3UxdM9/KGt9YWHzbKYH5iw9WhywxvanWf/9pOLvkKzkeb3dXQE
	lzOvFd0l/3LLiD9JAHUV/CkLp9NraN0SYXWaulYClquBTftQn5E81+LkNVUeNAkicxFQufSX4t4
	wzUNdQf2892wuZ4i3XNn2R5ke4XGlbg1p/2KDoIiUHBgQ46dYVwYSrfFhjPlbIdlxIwpOmw9ZYw
	EPbWyjq9svF+I/WYyDvrwoKNLfeT2SJeFNJz/rgb6KVJ+TGoBqEXxBu62VhbuR02vqvFYnYQphn
	vm1khoAIvOu2NOpeFT/+n02YbqqmvPGuUokSo3N1G93Ji4z14VH1EhAnjW38rBjyXftXmMDMBXp
	k0aRstMzc8Mf5X/WRrLswrfJrr4Vr937DoRseG34joKMHTu3YIUWjan/LTD5ta/jKucKrdt0Xbn
	SxRbuN04z7yRUh+Yp0tVAsMdvaQkcAU8NWebCGm8mov57Gaw==
X-Received: by 2002:ac8:4a0d:0:b0:517:b58e:a1e3 with SMTP id d75a77b69052e-517b58ea331mr2351281cf.50.1780827233230;
        Sun, 07 Jun 2026 03:13:53 -0700 (PDT)
X-Received: by 2002:ac8:4a0d:0:b0:517:b58e:a1e3 with SMTP id d75a77b69052e-517b58ea331mr2351011cf.50.1780827232751;
        Sun, 07 Jun 2026 03:13:52 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-396ac092dfcsm36963331fa.16.2026.06.07.03.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 03:13:51 -0700 (PDT)
Date: Sun, 7 Jun 2026 13:13:48 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 5/5] arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes
Message-ID: <enovafjkiuzr4bciu6bu6hh7h56wvnaq5fh7f46m4h7browyrd@7huwa5egaqaq>
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
 <20260521-shikra_crypto_changse-v1-5-0154cc9cc0de@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521-shikra_crypto_changse-v1-5-0154cc9cc0de@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA3MDEwMCBTYWx0ZWRfX0DNX5IpkaKSf
 lXwQa5GU9gedt7kJmHUuqHUBYJYeqyLis6frPAqZO9iFoQFoCVYh3YbLCs3FO0beamQqQ4T2Crm
 zw/WM4UL08WtSAeC0V9gJzSXoH7ajMrRg1dZ1UKe2ji6avkvpJo3R/xMpLhs7PJ8R2YAavNjYKR
 k27LhOxK5zHmmmPYhCbrqsqfxZPt908Ye2MIacPdjrh2E90Ow/SegvgzO9ClCKIlRARokd1z7Fs
 8dTe4ViAa7Io13ZtvSqhFZGtFIjpyyrUKche4k3LE9L/dmGqfDoG9rKkN98VykNCJf6aVIG+HQF
 hk8szicivc0DxSsJPzUWZjgqnTkP2ptiObcGMGVPzj1CumLlmwud1UHi1hZ/XQiac4V6LOT0IIa
 M/3sSeXzd642KtmLh96etZsbgpUfD2gwdlXi7dS5YdMy22rLXragnozmGwx4w5Z5r8Sm+F7SiT9
 5IdU7bn6NscilgJlgmA==
X-Proofpoint-ORIG-GUID: 8pi3Kz7k7Yta0PeFxZaShu20dCO1Eyom
X-Proofpoint-GUID: 8pi3Kz7k7Yta0PeFxZaShu20dCO1Eyom
X-Authority-Analysis: v=2.4 cv=TIB1jVla c=1 sm=1 tr=0 ts=6a254461 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=7nZNmzxVylfKdAgXsYAA:9 a=CjuIK1q_8ugA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-07_02,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606070100

On Thu, May 21, 2026 at 06:47:12PM +0530, Kuldeep Singh wrote:
> Add device tree nodes describing the crypto hardware blocks present
> on the Qualcomm Shikra platform:
> 
> - BAM DMA controller used by the Qualcomm crypto engine
> - QCE (crypto) engine with DMA support
> - TRNG hardware random number generator
> - Inline crypto engine (ICE)
> 
> Also connect the SDHC controller to ICE via "qcom,ice" property to
> support inline encryption.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/shikra.dtsi | 52 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
> index 31d0126e5b3e..b617735650ac 100644
> --- a/arch/arm64/boot/dts/qcom/shikra.dtsi
> +++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
> @@ -546,6 +546,41 @@ config_noc: interconnect@1900000 {
>  			#interconnect-cells = <2>;
>  		};
>  
> +		cryptobam: dma-controller@1b04000 {
> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
> +			reg = <0x0 0x01b04000 0x0 0x24000>;
> +			interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH 0>;
> +			#dma-cells = <1>;
> +			iommus = <&apps_smmu 0x84 0x0011>,
> +				 <&apps_smmu 0x86 0x0011>,
> +				 <&apps_smmu 0x92 0x0>,
> +				 <&apps_smmu 0x94 0x0011>,

0x84 / 0x0011 is exactly the same as 0x94 / 0x0011. Likewise 0x96
duplicates 0x86. Drop the duplicate IOMMU specifiers or explain in the
commit message why they are required.

> +				 <&apps_smmu 0x96 0x0011>,
> +				 <&apps_smmu 0x98 0x0001>,
> +				 <&apps_smmu 0x9f 0x0>;
> +			qcom,ee = <0>;
> +			qcom,controlled-remotely;
> +			num-channels = <16>;
> +			qcom,num-ees = <4>;
> +		};
> +

-- 
With best wishes
Dmitry
