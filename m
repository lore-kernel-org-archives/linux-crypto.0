Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168732773FF
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 05:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774328710; cv=none; b=aIiWxX5O3qc1SAZv+excRlP4AWx5VJprmrk8K7raAFAPj2PpRn30nBLNsOSr+14Ubcno9a+kFNnTgnOzra34UaGiphlmGUaSnxWgx/pSZBHuj/8dlabL5JUmLDPXD/zCUnS6FreD/u2mBV9JN4gq7+64w2NBTwWrvs3Cd83nmyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774328710; c=relaxed/simple;
	bh=zUwFFRo6geXN8Ov4xaFctP4dDiEmRc+oABVzzvyL9iM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J27tdADMk0qQff+EIcx9F2jbHHnvtCT8UHHWhTVLx40HNBd+vkiZ8QvL8j80xsyvGsvWJt5mYlLn6kQThMHiUZy0daUfRbQS342AA4g1CMIO124YgKFMY5+rzMiX6+k3pxs7GcCKnJ3xAg1tzKJWVYE0j1lRde1MKqpm53q2LuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fruGyfzZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HNFJBc9j; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fruGyfzZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HNFJBc9j"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O3IliR3171033
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 05:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BTeMF/ACpsQkCMro0pibigi1s38+6dwcwFlwar3P+Es=; b=fruGyfzZf29dairQ
	2M0XVtjYu8JPt/kw/74vDB+PDI3MSQO4pouZgxlVf+Zqg9gAJfqtMAdDEELQeMh0
	hkaw08yiOPW+5y041u8dnBzaHdtjt7zkLom8hrFC4Y/6YJsfRVJPjahd2Mi/Mhen
	eYjfIvqgeIEtAtCNB+o8dhmzNOB3EVasOdZM9CaZf/wfCRJYFkIwdm39Smch3J0f
	7nWJI/IUeF5BYNV0m53SBmTX9FgqDcI6mJ4yJelWOqn3Y3j8yJ7qH2ehdj3AoUZw
	ORkPiDqbE9zLLolfwyDCK3KUBstQL3S0ixz9lL5Yp/7ucH4tdvrUK7H/tqNEYvHE
	brOemw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d35r23309-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 05:05:07 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c741a9ef5f0so3488419a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 22:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774328707; x=1774933507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BTeMF/ACpsQkCMro0pibigi1s38+6dwcwFlwar3P+Es=;
        b=HNFJBc9jZHxUHTkZhYruZJMe8uv7uG9FpkK7hN1I4KXVPrX5ZgnHdIl8+TuVtzdnej
         /DxEnnEEw4zNvarrI5Hdo0Abw8lw4vs9iuTI5/YPjD7jPnABQl1Vrr+0/e85k7zz74IG
         pHMQub3teOFeOmJkfaJ8iJN+/n2KYP77+u53Y5BP25Ytm3L/8CPTjI9xB+FXjDK7K1w2
         KEDDiH+vmgfeVc1jUyjx4/ugMvYst9gei351tEemWL465K9ebutCkCXbpEZsQ/RJ44T7
         rHQroqfS0xjejzcmujMhWlPxJ9QBQdGOTpPgcPF3/NL1WC2bB/vOrcoxC2os3qtun0pV
         3DuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774328707; x=1774933507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BTeMF/ACpsQkCMro0pibigi1s38+6dwcwFlwar3P+Es=;
        b=J33Vpm24lRVEGtkwwlajh8RUQYcF/DSlmenW9sk8v42hQlcW1D45PJUVyZIacKa3Rw
         4x9X0joYc9A7hymtX8lAaB4cVNXp/l6fiSteJx4YJ6g+ICAa8MW5Z6Lo5BrC6e/XTAHD
         SYl5vCTlhfWys5/az++RTq52emn2MWSXWZaFfpx+NEyP/Xg+0X2WTXil+H0In0hAbjfr
         8YcgNun5YsAynB/qqDwIha5OCpXMwr4L1ikvofObpc7+6k3vrX2G6NLRdiv4EAKkM5N/
         Tq0bCPV35U5sKBZsppdTaVrkhiUNjx4Ky0e6E+MCJuvO/hQhG47sI3O5YKNpIMWVOPnm
         Useg==
X-Forwarded-Encrypted: i=1; AJvYcCVMrLmclDpX5ViutBMyLcXzqWekO9obB1ziIIYikdSkfxLFFT6BHUyvFoAmuIyyvAbM4+zFkab+2+mvQcM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOO2EeOVDVSMRO93gkjm4fIHJhqxwV/8IQ7QbJ6+LcGvpW9Uy/
	tVdyxmcmI+Y5cGAvLn/H0XKjI1m4GVmlu1Uy4iGwtwf4mj2Jeb3EGJHwGGBGAbjWdipQ7Wlw+g2
	NKSeC95270ZNcTkV6qGYZOA2kLFEYTNvATK2x+n8syeLr2WJSGcX45aCa9NkCSTpd57Y=
X-Gm-Gg: ATEYQzyy5QX9yDvITsETebvhIy2L/7mCk+2jkJckLMABlv1y1Se6dTuz2/Woy5Gp3+g
	ywRRWI4dJShfZACA0tEGnLMV+uTuBp60V1ah1nAnskUHdhthDTN8HnfklP3Zcf9CgmP/0OvMEf0
	Tf6UmrB3qTdpCMKo9Pp/N0SoiszlaB+r54Hdbl6cu8lmxAAC+1n2Y4Zt01jfytd16uOLH8mGbQe
	wMvHqPjT8MTt4mTISszAecDqlDDFNtyMDBTGnLWjDznnRettI5fh/xHSiGspJtC0aVNFl1zxbjw
	Zn1fzSCUnd+3sC50dtnXLAdahhMfITOeqHbCy+7bg8ys8EkDIB1zTInTCCySUAJ4qr9a5updz5f
	eier/J5UPSQc/LYVAexnfjWpInTG2O5kN8cUpU1S7Se6zpJO/ErQ4
X-Received: by 2002:a05:6a00:94db:b0:81c:717b:9d31 with SMTP id d2e1a72fcca58-82c5bd50708mr1805164b3a.2.1774328706911;
        Mon, 23 Mar 2026 22:05:06 -0700 (PDT)
X-Received: by 2002:a05:6a00:94db:b0:81c:717b:9d31 with SMTP id d2e1a72fcca58-82c5bd50708mr1805139b3a.2.1774328706372;
        Mon, 23 Mar 2026 22:05:06 -0700 (PDT)
Received: from [10.217.223.92] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03aa9fc6sm11517543b3a.7.2026.03.23.22.04.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 22:05:05 -0700 (PDT)
Message-ID: <328e25c9-0bee-48c0-bfdd-3161ff9ecc4f@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 10:34:56 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/11] arm64: dts: qcom: kaanapali: Add power-domain
 and iface clk for ice node
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
 <20260323-qcom_ice_power_and_clk_vote-v4-3-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-3-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=VvUuwu2n c=1 sm=1 tr=0 ts=69c21b83 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=WCIbC2r976qWEa8sWNEA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: 5Mo7uNFCKTI3vJKHj4_0Z76lNy_zyhJJ
X-Proofpoint-ORIG-GUID: 5Mo7uNFCKTI3vJKHj4_0Z76lNy_zyhJJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDAzOSBTYWx0ZWRfXzvkzTvlbHjJX
 Jvd3anqiTiArZi7dDgtzhLoNjjb1pRbpES6MXP33k+NoPh8FmuIPYfCS7Ti0eb3oBFP/PLhFPYS
 rblhbKyRUPzmhV82Koh4FaTNKi3jeBYxh/3+A3YfHZIkxNcGjXdl8VYAayl0XFC3a1+/4ih/wCI
 AENSPrkDw4BqgsVop1sSSHZKuxFkpaFJa+lA4AJg51w3TFPcRFD63u8wnPWxYhOfSrPltM2O7y/
 QBi2xkhhmQ8s1RL0HyNYae8yVQX6IDiSWM3uTblCPO5sUjMFXAnr1Io88rltXvJsBaUFhuV+zfM
 OFiPH50WRj3VcKYfdQO8AL6QCTXtzFsTQkuaR85orywIu3J8inSqP2dtGYL/DR2zqpgo12X8Yi0
 b8t7uqTwnkfN6elXi8GcWQ0tLK38vJPoBq6F1yQR12bVASLX2+tDnpR6oFCGxl29dSbeEjfbDMT
 y2DX4y56zyzzHeoR60w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_01,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240039



On 3/23/2026 2:47 PM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
> GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
> kaanapali.
> 
> Fixes: 2eeb5767d53f4 ("arm64: dts: qcom: Introduce Kaanapali SoC")
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

> ---
>  arch/arm64/boot/dts/qcom/kaanapali.dtsi | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/kaanapali.dtsi b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
> index 9ef57ad0ca71..52af56e09168 100644
> --- a/arch/arm64/boot/dts/qcom/kaanapali.dtsi
> +++ b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
> @@ -868,7 +868,11 @@ ice: crypto@1d88000 {
>  				     "qcom,inline-crypto-engine";
>  			reg = <0x0 0x01d88000 0x0 0x18000>;
>  
> -			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
> +			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
> +				 <&gcc GCC_UFS_PHY_AHB_CLK>;
> +			clock-names = "core",
> +				      "iface";
> +			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
>  		};
>  
>  		tcsr_mutex: hwlock@1f40000 {
> 

-- 
Regards
Kuldeep

