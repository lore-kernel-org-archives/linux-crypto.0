Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0753A1689
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773152002; cv=none; b=sEGzsXme4Hw6umOVrhoWoz7kiTqQaEEnPeDvKYr+88qvDlvBHMan84MtiC51jTVXsatZpjsCVtAbBbKxeYzQ+70YemPjJreyLdnc/NQmEV4GRUAwcOs+oDuEsNWpYULOWh4k9/7DWwc4QBqOnmnRj77m4ug+bz6U5Y5C72UG2d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773152002; c=relaxed/simple;
	bh=T7pF14Q+SzOq0+K82CozwYuf0rO0iM9ZwPpSHzJlXLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLNehDDtziT2olzN5R6Hc8I2TvxjEQVlFwAjA3SC4Uo+ZNQHfuQovgXuZTihWrcDpO1OwM3RdZErtY0oj1qkvcPAXjAoqMWr08HMUWh8uUEd6nLWsCRi57r8xsOQxbI2OlJ9smEJ6AQPw+MqUN76FyHeFMFUgFLUayg+fwWz2bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oN7K8wnp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZxqittHs; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oN7K8wnp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZxqittHs"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACaU2K963315
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	opFks4pIgNp6vlYaF0QptMTfPZJU6vOsbC8WTDtmcOg=; b=oN7K8wnpWZmrxR6X
	kOz1EBqEOhkRRiEANii5ODpPRYrpeOhibMLeM/bS/LDd7uHUjMaeqGmG1B9jITFU
	QBeev9ABrLfLjU8zMFW3kTPjJ73MxNnLciInkIjxrUuzzjjbdYucmaJMFTX5MW1K
	5OsN/zdNhGN0PUJIj52wSHoA/pkkHxWxd3+5hEM0yH4REFJF9MD646jZm+oczYt5
	FgJWb2sa9Cp4YgZBR3Amcr0OunBG8BRs750H4mbkQ98+IDRRWHhS7/tEPmVFFiZo
	JM4LcoKYUpPYD2qkFRhnox4AASfJvrfD62Op3KCMxKIi7p/olfay4zDItMDT4e7r
	kwaGGQ==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct477khnk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:18 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-94abae6fee7so1734057241.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773151997; x=1773756797; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=opFks4pIgNp6vlYaF0QptMTfPZJU6vOsbC8WTDtmcOg=;
        b=ZxqittHs5Eh+FmJBk0m7ECnrP4yEsZOYnF97l/Lrliy7Qw0O58uE1FSLAFZkv6B2Fq
         T7/jIhI4xnAoBNvPzbDA0I+IKXeHzOGFPl+bWONS4/XqGCD7nDSYucj3Yfx0/2MJoX3c
         MfJ7rv1CPFVNI5K6iRefSzWLwhlQPyzA3g6NwyV5dlVTgt6E4Ld9A4CEmYmBVTQo+GXb
         QT2fSBy+tHPPJmV8MdYL82DSlKkAypXgu+95hbtE2FMMeTC08tn6tyGhmEi1eih3gd7l
         V/BCiuv8IKzER4zT47mh8rKluHSLs3c5dBW5Zg7/dB+EUSVgZleroKm0q106wNYjZkLe
         HJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151997; x=1773756797;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=opFks4pIgNp6vlYaF0QptMTfPZJU6vOsbC8WTDtmcOg=;
        b=vkIT94G/WfIQWPiPL5m0PVaPHKuBsQeMNztKPavDV5LG0/2fW4IKVoZ1bx/NuoQ/4P
         xx77RFtdzADtIyA/FMB2c4Rf9T+WrzrsRMH7ztS91a8Gux8mJHnOwkt2My46QcF0Bppr
         tZcIGJwuXy5F0amNwqwkhnNl8BYijmCFffZDvt0DsjcONvWbV+TTO77qtKyONO+UGcFf
         1XKwbwu5qG7iTeZjvNf9LzkPTxWvvPYAmbhdwvltFjlJD8tW1Z1Ujp1YAJqXlLop1Trz
         O3Ksm6upkeqLYYUByzTUf+21V1OIEY+RPTOc3YnPWvbt46Ae1shThhq2lHgJ6BbZV/xu
         v0qg==
X-Forwarded-Encrypted: i=1; AJvYcCXGkee+viz6hF3v2CDohNQLICKssiW4LlXN7t+lEWU4B/TLMA9r0OSfu8plRkpCkDTYZMZ/8Jnoz/cWaGU=@vger.kernel.org
X-Gm-Message-State: AOJu0YySZKWE3G9Y128IruxvrF3LMMe//JoTbc6Rbr5KbKQT6sV8C9B8
	Rc49QnW0iCHPePy/fs92XiQ6gJfQj1sfqtlRoR4VZ/y4Ixy5FFtL6wQADxuNuDtYLXdCe9SNoTZ
	6BvO5LEoIN2h/A4Uo87H3/t1RkeQp4OqtvB55HqNBfQHCetfrAlT0mK9Lh+NpdJVvNLE=
X-Gm-Gg: ATEYQzx/7M4C2cnFTVILYM2R7slLdX5XGWfiY5RizyC1qa2QQ5I9rSXkbfQXHgQqY1Y
	8LGVYLL0B/ibt4haXvHLBF3ZINPnnrYROnoF7mMzZ0s0kWdPlakQd7OXSkjKXCbs6Hn6rd8S3oz
	4DqhPj+ahz9vdPs7TCguyw9PgqLO2DLICb5eMtPZW9qqwg2Nd8DmOR5yfb/DhmOuvCc2H89FO7v
	Wirxc5c5UKY7SDZEcV36HvY2cmU7Lat+f3z+CawD6BNnToNIkk4zTg1SWW8DmszzW3sz28Gc/U5
	FrzeS+IUJJ4pu6LEBQ3KEOns/8X01clLebQXPVD8SH9udW1ibwWROr4KR8DGgEiHVEX3NDOhFfM
	ZvlVUzFgiU8M6z9mXHEMBdBL7sd5omdtTrUwbFd9vJ5YbVybWd+VfpWTWonNfJRRV2IwHdByFct
	OXugU=
X-Received: by 2002:a05:6102:3e86:b0:5ff:cc25:d60f with SMTP id ada2fe7eead31-5ffe5ef6299mr2724113137.2.1773151997450;
        Tue, 10 Mar 2026 07:13:17 -0700 (PDT)
X-Received: by 2002:a05:6102:3e86:b0:5ff:cc25:d60f with SMTP id ada2fe7eead31-5ffe5ef6299mr2724098137.2.1773151996789;
        Tue, 10 Mar 2026 07:13:16 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942f15d51fsm493523966b.53.2026.03.10.07.13.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:13:16 -0700 (PDT)
Message-ID: <b8eca89d-e02f-4c16-b31e-6b5a86671bd8@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:13:13 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/11] arm64: dts: qcom: sm8650: Add power-domain and
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
 <20260310-qcom_ice_power_and_clk_vote-v2-9-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-9-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyNCBTYWx0ZWRfX20MLgKwy0RZ1
 cFA2RZ/6NZpO4ajAfNZAd/THCmv5FinUVWdapfZaJESNzh3Pvo7mQ32khRgBN6Li/6M0Sj/6T9v
 JS7BdlBmE6MU8aSxgnAhkphwZQ0agJii/FGcAiHOufTm+J5csxLJAIVDYjRlTU9YCwNMT6C/qHu
 0J4W/R07O2F8T20Vxw4+wRaEJ+K9tCTBY64mkjaE9SG7Z3C6ZhuumWGYEMKdGOG08OJhH9TQUz5
 fDrZ785RglA85FgYInkgVN6mK7/ijGS4TDC4OErYR6+RhEn99UmQ9pzxKmo5s1qJw+NWwemMFMo
 s9iuuovNi3XLmmjnD/RjFM6O7Gq175mUMu4WVjqJNZRjHrvlQpQWcDpq4KQ7A7Lll/lELEiEmbE
 e40Uv4ZYhte7HYv3eKLPnUSker99JMEkenmK5HAbe2+jZ2vBRJGcy4jahqt2MHdqcuz3lyAwifw
 WB6TRlRIWqwMTRvme1Q==
X-Proofpoint-GUID: hqrfSNUR9grKlTWb11e2UtACzbQSzU1v
X-Authority-Analysis: v=2.4 cv=KLxXzVFo c=1 sm=1 tr=0 ts=69b026fe cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=z_dnvKGLtVwtNw_c-ccA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-ORIG-GUID: hqrfSNUR9grKlTWb11e2UtACzbQSzU1v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100124

On 3/10/26 9:06 AM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8650.
> 
> Fixes: 10e0246712951 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
