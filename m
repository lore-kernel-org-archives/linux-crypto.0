Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56D93D9670
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 07:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791444181; cv=none; b=DCiZjCSRXx+B5FIdGzX2BpnjA5yKpvfhXLbyjajyU7/YEtpWWzTXfda7Sir4eQfwnA4QY6yHzWy1bKTyBb9HKCvxxYeCPSnKXqysVeTZte46K3P/YuYiGycyO0N6IGsQp0V71Gyyl3Yh34gD1kGPw+tvMjIY8E8wurBiE4kw4lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791444181; c=relaxed/simple;
	bh=i8uF9NLjlipi2g+SaY1Sbhj1L5kPCa+uJ+n1WEcSgbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CbV9CKsQFlW9OjuHfLjvyhGoOVbbCJO1q9oSwWbwj+xfa2V4ZJLNHPuBRHaETwY7Q/D8+fpCohmycZ7lXj1bBa6nu2UJR+0Tkqx5FU0isg2i06vE84LUeyX5FFeU9Qt45JE0yp9pyxIMHp0WqJIpbM9923UGrtZ9vSvBKDVokOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aEp9zmEk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y2YkhCZL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aEp9zmEk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y2YkhCZL"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987K2sh3190804
	for <linux-crypto@vger.kernel.org>; Thu, 8 Oct 2026 07:22:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ppMBDp/pJ4xxrQFK4q3LpnADbn6+L74//XQw3GBFLzM=; b=aEp9zmEkzBjy027b
	3NOlmj9O5D02wFd3a9dizNSmWW3uKE9tsrg6bJkbfQ2+nb9feFwHVCv+RYRVxz3U
	D/B3nkhBXr+hAg8uDnhWmRW7W5rxfnUVPWXwaKhwb/ufF3xSC+KESO6Mc4xIBdX6
	v+mLbHD0FhCExY/CaEbkftAQAYUcsJ2SyVv58i9uQq1UvMIam/nMjU0xwIikN8qR
	RENfY5j5VlewuE8gsIOgP7S/rB6zkBtP2JdDOjfAs1gcMYJ51FV8YdjY6KTXALB5
	7WTgrkI18bA73TTOOiN3YtC6n63vZbgqmr+qgcLrAtwNktTb36qvcnJP4i3M4x8w
	4I4ueQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe69prx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 07:22:56 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d55d8cd938so73674795ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 00:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791444176; x=1792048976; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ppMBDp/pJ4xxrQFK4q3LpnADbn6+L74//XQw3GBFLzM=;
        b=Y2YkhCZLDeQJPoobZCXFJXwL3TsFw89elbfe5rCoc+LFa2yw9s4Oss3p54qZTU1lQm
         wmwDx37B/M8WhPQzxCynFKnSvVoT9gVT6+baSVyGb2Igcar9rsCL5ELIU5USL1yDXNbU
         Kxf32VwT/s6HIbvWtJXYp4hbQL3IOV3Tswj3w2huj1614eDEXeQbqTeOn4t9DOyl7iTf
         t5p48YEOhzYsvtE196eY1Qgaj77wQCTZZKTpKUyDN+4t7B/OIsDNKx1MZX9WYKymSxZX
         4DyZxcqyiSFaVhtWpb+V2f0LxtsqPrCWtBdn3z2D6S7U4kQ2H6nPyFDto0buGg/8hEuC
         90tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791444176; x=1792048976;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ppMBDp/pJ4xxrQFK4q3LpnADbn6+L74//XQw3GBFLzM=;
        b=S6XX7jdhehYTUOOEDyCjlDPygU+L+2ncG4ceysk1pwcz0Pb8nE+LCGLbxsf6uEto7h
         H3l4hKPRhphh+Q1YCur72uvewqkEXwfevTkzcCyLXtKWkXCpUYLNQA7TyRBYE9FwPM6b
         RmjZtD6f4SymGjzAzqX0fSxNoUYoIpsgsLDA96e91iMzjoghUS2dbQY3m3U/coHmykMD
         xndYWgyIm+ZNQRbhHFuleUysaELTrQ0IHxWk68DlY2+aqU0/VBj3LYaJrkiEOqBASl6t
         OWAgIYFNR8xL8qgqv2dRZPS0TrfNyWlXOkvRJBSmOFQHWWwF8loDlm/12WzKlCgv3DRW
         F+6w==
X-Forwarded-Encrypted: i=1; AKwUvBwet0aH7KVWWjNBsqUMmFMjjn3zdQdzPKEqW54vXbFlandbTPsQKGIhsXhXvrU6e0iviqVT82t8/3Wwq0E=@vger.kernel.org
X-Gm-Message-State: AFq9FYJyWBvUd0wTURx/8g3+Aq2q97ki/sgw9RTEJFmsMTtoV3MmWPbc
	j/iehMZxe1vTS/sfnnTlcsbg71TLnOF49oKSUvPKyWRruHOytpVQfY+ALUOy4hfCo7CcNcKKbkN
	EaXKSvASuADt1qwUjSUMRBH7CC8hGvpWnSXL6KoBzB5qxoPcepZrAKooY1FtJMP3gqlk=
X-Gm-Gg: AYBFou1lyWuWkjRshmn9VtUrIjOO7L19QDMEf8pVp9zHJwQsCrcMLJddfO4oXqcpHJG
	NSyERJk7yB6MHlp/fuCi7IxSIec7An8OKCsfSpQH1LdtOgpuYcorZFH5WAokk/DK41LhSt21zB8
	4K4i15aiyNBzylyAOC59DjeyeMAtFUV+p87yGs4grDZXHhdPQclD6XPIPvQyijkT4MhjS327UKJ
	YVSlcFLIYs3bPJv9bTmoYY3ux9f9Q2xxm/WrdPI/bRJbPlXJhCClDkdJOh7lffi9ytlX0AvQg2N
	OfEyMpubqPi7BXKIk7KR2raUbUr8VVnv/Orhahc8sJTTMNVxb1Eyp3ebwqX+5G1cIJWN0R+4MqQ
	394irZKPlLnruo8kYvZBJNluG6sU=
X-Received: by 2002:a17:902:f786:b0:2e8:b4a:43a4 with SMTP id d9443c01a7336-2e80b4a45cfmr10534365ad.34.1791444176225;
        Thu, 08 Oct 2026 00:22:56 -0700 (PDT)
X-Received: by 2002:a17:902:f786:b0:2e8:b4a:43a4 with SMTP id d9443c01a7336-2e80b4a45cfmr10534125ad.34.1791444175481;
        Thu, 08 Oct 2026 00:22:55 -0700 (PDT)
Received: from [10.64.68.122] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e604b53294sm20934665ad.83.2026.10.08.00.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 00:22:55 -0700 (PDT)
Message-ID: <894b56d6-ab39-4920-ba37-94a5bd0cad5d@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 15:22:50 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] arm64: dts: qcom: hamoa: Add ICE node for UFS
 inline encryption
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>
References: <20260728-hamoa_ufs_ice_change-v3-0-293c7c6c2ae5@oss.qualcomm.com>
 <20260728-hamoa_ufs_ice_change-v3-2-293c7c6c2ae5@oss.qualcomm.com>
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
In-Reply-To: <20260728-hamoa_ufs_ice_change-v3-2-293c7c6c2ae5@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 8Un1lGtFndNJNLjLowISbUv-lRWhzvtX
X-Authority-Analysis: v=2.4 cv=HcWB3SE8 c=1 sm=1 tr=0 ts=6ac744d1 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=HdoDP85nwEVMDcDmVcQA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: 8Un1lGtFndNJNLjLowISbUv-lRWhzvtX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAyOSBTYWx0ZWRfXyf6NXbQ5Jn6o
 kvNOiIdq8TFq4itbvcHw8lCPAjZuw+/E6x1i3ohSGkunCobMYjBsyS8Mbqv3z63gaEuauMbBplV
 9EnBf0RYVQJAhWtFLafuzHw8DuG2pc0R375vGQ/UVHm83XBravmQv1yBm/NeIT/6tiXJUvkXkIO
 e6bMnmSnnlUnDvubdevb3ORXWb/mO1mh35DkJaAN5uypRqWXxfpdC0RwVAgXzJY/dQJFdcvsj6S
 OsRsZEJDtnxNSg523W6q1LZayNU6n44ZV8ClgWfWvUJ/MKBdSmd6JhC0IioF7GtiU3pGffxCqq8
 k/dY3MzBhDunl5C27URuE1ULl2Kwur3MRt8PhpuYou1kXtEGGUGPNbmeKtcbxN2K//SMpSfUelA
 QwaG9B0WRf0doLSjRJu+YsCrp/OldJQQcQumhFLBiEgPrcTUbiz5Yj9g/hnE/XP52g2HqpzYQkg
 rI3WDMk7MEG7/EarwSQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAyOSBTYWx0ZWRfX2VZxkOw7nC+n
 hCE2f0OiBxM2zo70mA7AwH/32Mb1VrB0RahnNvTffbPODvih+lMhm1LHBTgKGYitxczv2IhCuGt
 6dldQPYjcS36cju09KzVVhFAaSNh618=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610080029


On 7/28/2026 5:53 PM, Wenjia Zhang wrote:
> Add the Inline Crypto Engine (ICE) device node to describe the
> hardware-accelerated inline encryption for UFS storage on the
> Hamoa IoT EVK board (Qualcomm X1E80100 SoC).
>
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> ---
>   arch/arm64/boot/dts/qcom/hamoa.dtsi | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
> index 09527dcf957672b4b9658988359e79d8a432fd93..abec577c062d53952528f3bd0330638ea53b83b3 100644
> --- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
> +++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
> @@ -3894,6 +3894,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>   			phys = <&ufs_mem_phy>;
>   			phy-names = "ufsphy";
>   
> +			qcom,ice = <&ice>;
> +
>   			#reset-cells = <1>;
>   
>   			status = "disabled";
> @@ -3939,6 +3941,17 @@ opp-300000000 {
>   			};
>   		};
>   
> +		ice: crypto@1d88000 {
> +			compatible = "qcom,x1e80100-inline-crypto-engine",
> +				     "qcom,inline-crypto-engine";
> +			reg = <0x0 0x01d88000 0x0 0x18000>;
> +			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
> +				 <&gcc GCC_UFS_PHY_AHB_CLK>;
> +			clock-names = "core",
> +				      "iface";
> +			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
> +		};
> +
>   		cryptobam: dma-controller@1dc4000 {
>   			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
>   			reg = <0x0 0x01dc4000 0x0 0x28000>;

Hi Bjorn,

could you pls help to pick this DT change?

Thanks,

Wenjia Zhang

