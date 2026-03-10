Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A5397E89
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773151977; cv=none; b=UdsR/7c7wVPSQF57wK/6oQrR8c0FhbUd9IXo4Jbzq1A+lDZdmQAwx2rq85xoGE9t4DCnniQftgXFiZ5vl46MrV3W72+1PdZ7e+zLaxDoPN2FVh3IxLGhhbUsOEuWbK187C00iaT5r3lmlg8qpQ94AHaCsmcGnOmf3oCijKhcx0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773151977; c=relaxed/simple;
	bh=1FaIPFuWAfmVNzG9+OtQXpdcIagmdohXDgobkOvWmaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jJLajlcn4+r6V4NCGumVY5oukELWiQVpZ7tE2LtNMjhGH7O+gXifUzz2F+n0xtRy95bNwMzsradrBeMRVxadJKjOeRaUt2m6fEQt9r6KtvhnSjb+iJfBELz/Lw3Dh/1Z/IfYAG75AXAzeWE9l3q+qc6LEbfPL9JJF1jgFwSMr5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FahaEN7n; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PjXm/Q8/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FahaEN7n";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PjXm/Q8/"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACaTiU1502932
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OqvWktqC6//V6Esd6CgK+Uq4ljtYPh/ZuwNGITPaTMo=; b=FahaEN7ngFKMRFZl
	etdudgxLWcSyWAqy9SPb/9EueWGgIiP1tySGYqNLoG73WEYSNCX9qxDFE0uzf1OY
	neMDEFMDMw7UyQm+2eQlRek0cjCopGNhk0xLK62K8AslpiV49P4j9IMDXvSxnkLc
	1NfTt6KQS+dd0R9BmE7ehywg/1m4uHTlheTe3Q5uYA9ETXFBtQ/uzMs4VBmeS/+l
	k8o4jGPEZixb0LHO4dgaX+bTGLIjxELLZ5olZ8a4ZOTygFYtB5ffBYc1lDzD7QtX
	PNDifgNrfuogc4stYiwZwsxcgpZeFdmbF+dEPguY7HYIDNuxEB/Uk0r7NDmUVcgO
	Y/pubw==
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctdf8hupm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:55 +0000 (GMT)
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-94de9282f17so1989814241.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773151975; x=1773756775; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OqvWktqC6//V6Esd6CgK+Uq4ljtYPh/ZuwNGITPaTMo=;
        b=PjXm/Q8/gIL4eKo6no6UhhN9rO7atQOHqmfIRUqV7AQUYUF/xlCpnCVKGRO9SI9AdZ
         UbXceXkx2UrNTymGpL5fIs0AyS1a6kl/WkpM06cJ0w/FD5ue9++VYXJJry6hd3391xfe
         qitoy8z0zrDWn95+eURVJcSd6g8WmfRIgk5Q8KlDXEIxAwUQE6rz6VaAhszYGlCDJ49K
         AsPDcvIh2e5Zm121CnbCcdqUK8+/aoFBGlZuOBficeFyS3M0+47ei4E9aojW6OpxRHrL
         UsUPDQ+0npX3fucwmILk8cdYuv49k8+rqvk8hd1+3MTaTrZ4i6WyShzpl7GWuLMItl/H
         +J8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151975; x=1773756775;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OqvWktqC6//V6Esd6CgK+Uq4ljtYPh/ZuwNGITPaTMo=;
        b=sjRcgLJ3OcZ7siYE04Iuzt/ok//qWBQAqeW+ltNFkAhr+kgos5Sw5A9TqoW4sWh+ez
         1c0A1SoMCA4KpFnk0IypEeaBrM/GcODAdZaAq5xhF4jntyEp+n6xt/4KAUsyO+ixBtd8
         sBQf2WGAMgJpZ8RBF9V0/aKO1GQ4vONcSUR29hUjwEg3ZoiR4lke46rIOUElbr4DTMlv
         oN95SUt/hzFEl8TE3E9D/GAgb4vaIN+GK+PL2P60eLOar2CE6bq6k2p54IsVsMCV6HmP
         Yqfv8PYKERGPTy6BESP6vvWqoGLhpc/nqlq1MMS1mY70BDT1Z+X4yJX3Su67btbmULF1
         V8Kw==
X-Forwarded-Encrypted: i=1; AJvYcCXA6mLEs3kRZIZkJ1nY15QR6xvQO5M24gLcW5JLQqZVxuBtdf1ptTZ2UswTtu/jaFF0/vswOYE7HASdQ4g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQIK03OV3Nsw42jKqAgtp3JFmVk0tLYhfjow9EoHwQMZu0eLsH
	wh9UyW+90xllicD2OplnTtT9DCO2vPzDu/gBIjlSYUV/oAAXSbu70QGl7Nuomk7wmxfx2WHNHYD
	BBXPnM2sMOz42Mh7n/5quvd8P6YlgbsUwhcL2gmCpL+FU9PaDJPNfzxyJbEj4DJKOr5Q=
X-Gm-Gg: ATEYQzxHVZf0prODzMi2yT0bJD44wje0Wt7N403AGc++J6Pwk57EmMWyP0s2WUwHTgV
	DOiYVyPQ4cvW3tHkYwpYErsYiWmVx5wnLSEjzMVBRB/4MwEqQa0UtmBVtb/HYCIzMn7pvkM9e+f
	JZIpoFVUVBc0xkB/5IynK3PJe67eQddTo5tkjh4uso24iHoC+P9YG7IQrmDg9n6PRpMx/k+9gww
	IxZuz894FHU+s2Va5ISU1PNNZX4aVjvioK66rQFNSyR9BbiWjfMlIOgKC6ugua099Aypd9sluSl
	QVCr9VZDaNcNxK0ge7tusaWoqIS0ZWrlzj4kZVr4/hdl3glR4RYDA1ZS/IVwoeZMr5rxbMdfjCq
	/YwV7W6FM4svdWojbh8fyCovDB1Y/JE7u6m+mHcMclpYCmez7e5h82ap75wVbFbk91MeuH/eVGd
	7w148=
X-Received: by 2002:a05:6102:d92:b0:5ff:c0e8:d89a with SMTP id ada2fe7eead31-5ffe5ba4013mr2497919137.0.1773151974607;
        Tue, 10 Mar 2026 07:12:54 -0700 (PDT)
X-Received: by 2002:a05:6102:d92:b0:5ff:c0e8:d89a with SMTP id ada2fe7eead31-5ffe5ba4013mr2497898137.0.1773151973959;
        Tue, 10 Mar 2026 07:12:53 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-661a3c66d3fsm4317323a12.2.2026.03.10.07.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:12:52 -0700 (PDT)
Message-ID: <b5a9e78d-0458-417f-824b-a352e8b4c9e4@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:12:48 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] arm64: dts: qcom: kodiak: Add power-domain and
 iface clk for ice node
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
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
 <20260310-qcom_ice_power_and_clk_vote-v2-6-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-6-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyNCBTYWx0ZWRfX0t5VZTkbHe7J
 T3I9PCGYeRIzY1+BEXppSy9NS4lkdIvNkHnahaVTfMN+XF0rkK3LGMaL5L8DQHfvaJTpbuEfvYB
 LRlAaq64LoaXX1I7JD/1qM4RYjQkNJWCrVsGsNEIAZQfHHEDhk5q+yUjf0u9u4W0ehwbGXHrmQl
 fPxqnMoieQGoENZl2Y8zpER+HKS1itUCZUB79tErtNia6CF95M3wWJSmAHt4vQlFgJhJhlZiWcZ
 PPB32HrWEtspcm0uzhzMg7FMuSEoqaxZmijcqV5VfXKNIJg1+CFFzWB2v0ZNr2Tl64AE9unznnU
 zkig2ufDcVx1IHUCNgwFch7PEUWuiCe5gbyaTHlXRqkohccZ4tcDvdY1f9MC3ONYccOcFM2c2rg
 623mm17K8CF59S+iz1QRvIVFXyuq9mwrTE2detjAyPK4RUZre/ijRuVTXcG2QS3oPsDkgSeid4Z
 9OScJtGYx4xILA8M/6Q==
X-Proofpoint-ORIG-GUID: oF9h1nb5yet3Nuwn9qMv8GH0r9v3TGgU
X-Proofpoint-GUID: oF9h1nb5yet3Nuwn9qMv8GH0r9v3TGgU
X-Authority-Analysis: v=2.4 cv=b+W/I9Gx c=1 sm=1 tr=0 ts=69b026e7 cx=c_pps
 a=KB4UBwrhAZV1kjiGHFQexw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=z_dnvKGLtVwtNw_c-ccA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=o1xkdb1NAhiiM49bd1HK:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100124

On 3/10/26 9:06 AM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
> GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
> kodiak.
> 
> Fixes: dfd5ee7b34bb7 ("arm64: dts: qcom: sc7280: Add inline crypto engine")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
