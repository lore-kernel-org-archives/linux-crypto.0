Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AF81DB92C
	for <linux-crypto@vger.kernel.org>; Tue,  8 Sep 2026 02:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788835889; cv=none; b=XGcHok/VXD768O8iOLIZtrFk1vTP0JZmAFCrOy7lIjkCu4+neASXJERQWOiRhtSFFPhDuRyIwfVM0NTHzalGnrnxAh6vRoNv9Tn8/GBy21c4wiLpUcgpeD4HXdmVH35ek7f8u+jy14/+pQ4N81a4DOVtN16yiqcwlLLX/D4SRyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788835889; c=relaxed/simple;
	bh=VjVgSIEHErlpVkc7eq+UEEYEg/iQEcRtAbhlLZ5+dpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m4xCUkvu6Ye325ISO6v4MhBtR3rZkBOMqjbI/+MuU8YEnGXtJ2F1JB8i9ciNIZ9DtbjV2vZP3/ssaZ2RUuolT9e+tXXzTtd/Q8Zp9zauN9+4uWcQoacNJ4VTnIAys282nP+OYL6R7IBMEJNW+/mi2eCKQaTzAYX6FCfcPZBdPoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Bzdc7Ao7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WOLFY3nx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Bzdc7Ao7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WOLFY3nx"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687Nls9d1232083
	for <linux-crypto@vger.kernel.org>; Tue, 8 Sep 2026 02:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SXX73wHDy3wDhoXCZ7H3cw2yZLyFvFtSWJ5lStmdwDM=; b=Bzdc7Ao7GOAstmBH
	S7HFlU1yWBfnLbEY4k/ZaL+NvsGTCKgkzEZE37B8HrHk8jF7kjsFkOgUAt9Mxk64
	sI6Yh2mkHqYzuSomdl3Ha38vgSNUjtdB2wmjKYLuH9OKIfYPLB2LQUN+dDJZfKz8
	MDdJh7h3Q4gDy1d/VJsabaaqhQqd4YoLL9CKJlpH9qbUz64gisueNnVIxLU7pOlj
	ccWhCi608AC1BkgsIx+9CpkQYGTsvqB8o9JYkE4iFgUY4BISXQeLWDvwtfm5vc4P
	9cibFlMdPABs1Iv3w1YLhmbkY53GaE2+QaCJlk4hEMwEG2AWQ2Eikemov2pcsUm3
	HkF2Fw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghsfykdjx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 08 Sep 2026 02:51:25 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d6f80c76e6so78298255ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 19:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788835885; x=1789440685; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SXX73wHDy3wDhoXCZ7H3cw2yZLyFvFtSWJ5lStmdwDM=;
        b=WOLFY3nxeaz03Wiz+L6Jo6OH0fITHngZU6Vy+wxnOPGmBMddKAdybM49epSflyM2up
         YwEpMokkuKYqbrrDqtUaehbr0ZZZXlHodVvL52Aqr44fQxWGRFHaLp3hjFNPhtoUiWlz
         MHFsIBaZ7a1vMGgdG6ifgkeGi6wo5Z1prpO6hMtpaSbt8kKutl9YJrrYtD0L8dPtXbTf
         VrpcaohyZQWngTKPBpQzVYTtEtM+TXHJ0i7ehgTnYm/S73yV4xwcAXjQ/Ve7FQJNfJBp
         lHOclsQG2l3uBNtzHQUHXJvClS1gd2Y5qwcZMU8J5M+nc05elc4TMn0tdXKTnWY2M5uV
         t9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788835885; x=1789440685;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SXX73wHDy3wDhoXCZ7H3cw2yZLyFvFtSWJ5lStmdwDM=;
        b=oIbLIf+1x7nsSX2SBx/Tv/tqXMQG8Zs0Nd/+4kUrFbBSVdPb1utEfcSXzlkysQTavw
         PyafALmM8ctdiG06y5roShSALLaX3AuVoEcgmqDG2vG67pyU5E5sDrQuHGK5HYx6DfpV
         lH0LnBElOp83i8POFlHqOrBsjAQy6eCj3mOWy6MRc1yxVgkIDzzcHfhiAS/AaJSTxKav
         mdfaxBgcMI5SoM07y1JSM7UHbqAPrK0mFBMtWZTD74PJlOIeuBdMZq7VEVYcLuvLLIUy
         bJHSvIlgjCo08CsK2CBI1k+YwFOL1yvG2Vn9lt93pTTNrvt/+Zy9GohoZIqkQVDX8IC4
         EWTw==
X-Forwarded-Encrypted: i=1; AKwUvBzJz2/YTPB6cUvm7kP2GkA4TM+fj1uYpdsyXpSKlKL2Rr04iRfUkLMk/H2gJWksNli2gCGMW9YyFZgZlLM=@vger.kernel.org
X-Gm-Message-State: AFuF++kbJPe46zUREszqfgfFewl81M0VLVWMJntqoMYKOYeoMzlAOgv4
	+ztVtzQ/+z/KztgzwdLwPqt7dne84BPzGLYjmjGw4FkL1nBztmM6ntf5iwoiLkyJ27Nn6xejbLo
	QqSLEszDLFWahtjq00y7nsEjz3geZAzlbRp5fn51ksGyJT++Tlq7QSxMrq5oRFNmQCFs=
X-Gm-Gg: AYBFou3Lg4vxBF49cKxO6d2pChDW8ltRa7vdxR4qR8507chBBBbBaHhB0Nd/37JTLMJ
	MfY6eH0JAtHq+DJPp3HrAsvAMYYl1oCePMik+gZwPTriIMJFdg1kH/0c521COxM/cIHv2gyx9AV
	rizS2CIUdRRhPKkLbYqUF1DQXcii22cjEV1JSVMqUofkTNo703fI/aCB7MrBTYScPWRtJYcD9vv
	D8TX048E8I0UAs8iU1iAlPbGK+RRYEToqeBnqDnkUci2cBwp30N4waro+u4ItgPeDqlMjhcL/5/
	GE90DJVEwJcc3xc78IgpqsBlZojHQBRsVMZeXmSROKYbi2Sw73UEZOjAu6zPckNr12QQ8SQ/RAt
	39wAUUetuouksMwYqVoc8Gi0WmjwAvHs+OExjw0iFXHBkPLJooKG/5Uf86DxRP6JJdXDMfAU=
X-Received: by 2002:a17:90b:39ab:b0:398:9be8:ea68 with SMTP id 98e67ed59e1d1-39b261da75cmr40560626a91.21.1788835884806;
        Mon, 07 Sep 2026 19:51:24 -0700 (PDT)
X-Received: by 2002:a17:90b:39ab:b0:398:9be8:ea68 with SMTP id 98e67ed59e1d1-39b261da75cmr40560573a91.21.1788835884354;
        Mon, 07 Sep 2026 19:51:24 -0700 (PDT)
Received: from [10.133.33.68] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b25f88475sm23459473a91.1.2026.09.07.19.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 19:51:23 -0700 (PDT)
Message-ID: <062ea84e-07ee-41be-82a5-20600693a219@oss.qualcomm.com>
Date: Tue, 8 Sep 2026 10:51:18 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com>
 <20260907-b4-shikra_crypto_changse-v6-2-0676f61894b3@oss.qualcomm.com>
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
In-Reply-To: <20260907-b4-shikra_crypto_changse-v6-2-0676f61894b3@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: stWwj1E1a7baKHCXFaoxMfAs0HQ7WGvv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAyOSBTYWx0ZWRfX/9Xcwjj/ZlHF
 0cdVaAe8Zw8a+AxcyMNLb1T/pzuFaNsBK6rNRkNaF74IAkvLtGX+upi74ha9mYMbvkC9TfYqtWC
 dqhiNtiKrdmlQGNAF/lkT+9NHYVc3LjjVHRj1snSZSt3g+vqKPr0wuZVWGrBAW8l3vW26CVFzEl
 yiLgr1Ihh96DgWPquGi5m15fEYr/aAR9YpN78WdD6OJ38bvnxWyW7xm7MSSPLO+oNAYjkbn2CbG
 ryC3/ExROEqg6ABbL3Zvkx7zK7rcMS8tXQKMv7AIZ8T7n3DLRDLtXiFb8qgBjjLQEp6Y9eHZgyg
 1P5T9g1btxG6kpEj0w9urtu8vh3R04do8MVlE0foJHodfN0UQMCmPxrcNLY4dBiVyvWsBiFB+LT
 4TkBEkJle8SMwBw4gs7T1Vb5TYM4CD2jHIW/9kNDUWIT7FmIiOlQ3QIyXJ28s1lEO0ksDUoxW9a
 uTd+obO1p6VLJdnFNXg==
X-Proofpoint-GUID: stWwj1E1a7baKHCXFaoxMfAs0HQ7WGvv
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAyOSBTYWx0ZWRfX4uzH5MBQnJnO
 gbxI1QqVpliM/Gx8N5lf8yyxLQrfwKYzZo+86GrYAkRU2ylcx9EWZ3F7cQG3vmiP3UE7WoJqMNe
 q8GLWYx/bnHLABaRpKU4koEpakgjjaA=
X-Authority-Analysis: v=2.4 cv=AduB2XXG c=1 sm=1 tr=0 ts=6a9f782d cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=JBeEZWaBV44c9fYEBTwA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_07,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080029


On 9/7/2026 8:03 PM, Kuldeep Singh wrote:
> Shikra is derived from Agatti and uses the same QCE integration.
> Update the QCE node to match the underlying hardware implementation by
> adjusting the fallback compatible and related properties, including
> clocks and clock-names.
>
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>   arch/arm64/boot/dts/qcom/shikra.dtsi | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
> index c1f06f692f66..30c7cabc058a 100644
> --- a/arch/arm64/boot/dts/qcom/shikra.dtsi
> +++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
> @@ -1075,10 +1075,12 @@ cryptobam: dma-controller@1b04000 {
>   			qcom,controlled-remotely;
>   			num-channels = <16>;
>   			qcom,num-ees = <4>;
> +			clocks = <&rpmcc RPM_SMD_CE1_CLK>;
> +			clock-names = "bam_clk";
>   		};
>   
>   		crypto: crypto@1b3a000 {
> -			compatible = "qcom,shikra-qce", "qcom,sm8150-qce", "qcom,qce";
> +			compatible = "qcom,shikra-qce", "qcom,ipq4019-qce", "qcom,qce";
>   			reg = <0x0 0x01b3a000 0x0 0x6000>;
>   			dmas = <&cryptobam 4>, <&cryptobam 5>;
>   			dma-names = "rx", "tx";
> @@ -1089,9 +1091,8 @@ crypto: crypto@1b3a000 {
>   				 <&apps_smmu 0x96 0x0011>,
>   				 <&apps_smmu 0x98 0x0001>,
>   				 <&apps_smmu 0x9f 0x0>;
> -			interconnects = <&system_noc MASTER_CRYPTO_CORE0 0
> -					 &mc_virt SLAVE_EBI_CH0 0>;
> -			interconnect-names = "memory";
> +			clocks = <&rpmcc RPM_SMD_CE1_CLK>;
> +			clock-names = "core";
>   		};
>   
>   		qfprom: efuse@1b44000 {
Tested-by: Wanjia Zhang <wenjia.zhang@oss.qualcomm.com> #on shikra device
