Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7B73DBD52
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774348808; cv=none; b=fhkQeNfJ7TNXYne0BsMBZFaD8Z9vd+/bExshdotaYubcUjGkLIeKgTWCxIW+39pHZvSOZVKJzVq6mn4CAJiWacwupWYi8/BkGW48yAqa/1tKwQlL+xdKI81YsDVLn9zegiq4wmkqcO0txF3viKyeKRbsRvZL+umfgWBtlmgsGVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774348808; c=relaxed/simple;
	bh=V/t8VE4RIxnv3KlXn6VFkpWMfjuQh3mARrMePng2vJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tr6xvrK+EE59dob/FuizwgowEzT/KrHq+DWQWO97qpc27UoCLkXG5dOa6V12TUpvb3kuTvYraxG/4zgJtrB8y/lX9pn4V5ZjXzS7DBCx3aAzbcfz3bRQNysRaXZgXxcZsHhI8sqS3hEVUedmr8YVlxilSCJ03eiA3bVQ+JIbjYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KXlmTcJi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NBxLC+Ki; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KXlmTcJi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NBxLC+Ki"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O9RUAv3934853
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xiLrR32Mkhp9iJsUryaa7C2F1tBnG5NgCMdH592hc+Q=; b=KXlmTcJiWso+drhi
	8Po7MCVRt+eNjoXF9ZRYUBmnzme4Q3Qx/Qmkiabldy/4qPJASm0QEHqlOVZw2Ztp
	zTZuesinNAI3sVHrc0U89UtsDuXwttKnxBGSroZiSRErZdhpU/4pRPgXs3+ElC0l
	shYwHNj9QYqzpVK6DTp/ji1dNzG88oLH2s9Kl7LAS2KAo1yK1O1eQkyDDj9iyzbB
	YCEqRXDxkwoarJ0ksavzkqBrVv+x+rPQqB1Nf0cKp/2b+YdzvFIJ9zKIqs6Jck+v
	pEnrNDf87ri/0qppL4ZbIwDnYkbUBeXw+bwiYmF1225s3Pcv1r8eFVh9MJEmzkEo
	9v12Sw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d37a0m065-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:40:05 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a90510a6d1so50970495ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 03:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774348805; x=1774953605; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xiLrR32Mkhp9iJsUryaa7C2F1tBnG5NgCMdH592hc+Q=;
        b=NBxLC+KiBgWvo62gpl3FAM50F0JegNDxerA9j9OOZ1uTV2M+Ww2sY0TGOR20y8UTEB
         ZsaTzi6azmA0PA7uXQQD9HeNXFApaRaI8b8RHk1O+HdFhxpFsLQRJpwktAAVcuQIrCBo
         dw+iC4xhv/w4vDs0CAN894C97/MVBHcpmMotS4RK+7W34aAmpO2ZxIxbHv3jYRH1soT+
         2Cp/+lZyg/VZX3ZuvdSJKn+WjCYFuZ69DT7buo9PA2ssSYEtVAE1zyr0czT/tDh/OZFa
         8h8OC7No2sJ/D1oUZv+q4LEd9kiTOnnULDjrkAU/+ziber4Uj+QCxNunPKelAstoU6TA
         A8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774348805; x=1774953605;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xiLrR32Mkhp9iJsUryaa7C2F1tBnG5NgCMdH592hc+Q=;
        b=YDQKaYLLyYVoEO/ADzRobUl0X2eP/jU4pYPOnCG2ZUECFFKqlvmrm0ixB94rLly8Tr
         IJdy8/1Cq7xjKH6YJnGUDCU5vXSP4Enp86IadV4CrEx8KsTjNFWW9jxxADvRrNdvZsOv
         4GM8N4dBK37jH63nS7b/SW7m4zPkO+aYYvE1XbahmZqqIivFWXKr9o8blp581gU9Cubm
         2EflQOce0aNL7RWokLVpXT4+EjaLpje/suLW7YQfWp2+E5CQRWmmf1ra9GmEYCUkKTwh
         RWBBIigJEsTnHAQwtsW5+SBWVoTKSCk70XHoTDn6HGzPTkvhVaUoFPrD+uFGWbP4NzB9
         CATA==
X-Forwarded-Encrypted: i=1; AJvYcCUDGtBqLhmG1GjxBhIaNB9PMKDvMu3dI1a+xM3gI3yPds4IiBDgFiNSUeyHaoJsT/YYso9FBFKVtlxTKYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsRQW1D/KUc3Rv+Fyng9Wf5mTnO4rNf0QrFQQ6T9Z5jrPpDoMM
	IsHUskdHbRpv6/jsoOas+rrGyzV5e/Y4VjAIwCEMP3izWMH9TBUsNUKMEHYjgJAwpZjthnpW9IT
	zfy6vHGNp3Vg3fS4NIEYPJXoWTPdwAktDubQtDZZeD8AD9yMVhugmAU8KKVP3pgroDYI=
X-Gm-Gg: ATEYQzxvnxJ3K3CRS79EtpKzsufz54cVstMm6NYI6O/0JIfxjfwn9DCZlLe2DgSWdBw
	fs4Sn+mX0yTfWG5MdUzvCOBEesZzTs9nej05pdevBVFiQh3v6yg6JMwisOca3C9ChMKxDOPAIzy
	S3tNIjoIyGKtDs2cf3HAdc51cRVaIy/HIuIH8s9zc4QYXyWmh2aIrqTjBpTjFkfXgIfBSlf0FeG
	FWUX+NkKiq1KioAwmbsTxXIbO6cskyxXHeYyhxAb24LlrfqPY4UV7o29GIJtgZjmqEvuuTdiZuv
	HGZzCPWehnnqd0RTYZNLD87NTkfDWn4XUNFc70p6RegIp1LkTacmOHLwGuQfGF5jvolt9D7sP1M
	P8y7C4DCJ7HWF78NhrJjifw8EpzXe8AHvUcDBn3jEQER+K3cIGMSO
X-Received: by 2002:a17:902:d209:b0:2b0:ac1e:9730 with SMTP id d9443c01a7336-2b0ac1e9a37mr4064735ad.14.1774348804450;
        Tue, 24 Mar 2026 03:40:04 -0700 (PDT)
X-Received: by 2002:a17:902:d209:b0:2b0:ac1e:9730 with SMTP id d9443c01a7336-2b0ac1e9a37mr4064185ad.14.1774348803929;
        Tue, 24 Mar 2026 03:40:03 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c766255606fsm1101544a12.21.2026.03.24.03.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 03:40:03 -0700 (PDT)
Message-ID: <d66c16cd-0460-4813-803a-dd298f3d7581@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 16:09:54 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/11] arm64: dts: qcom: sm8650: Add power-domain and
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
 <20260323-qcom_ice_power_and_clk_vote-v4-10-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-10-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=GIIF0+NK c=1 sm=1 tr=0 ts=69c26a05 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=RcdfdvLsBkETvr5PKcUA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NCBTYWx0ZWRfX5P4DivQUFzqD
 q/8l6PvBn3xQGOlo0D98Xi/odxW5vqO/cwrFFokhrkn/jzoDo6vmCdS9bs7+J+FWnxTWjSz+PUn
 vc1vB0UTh9wm0mK0tGpSaMwma+xuhhGj4F8wBUKcs6meOVQE2pU7c0yL8PS/CxLegPZX+XRGwwz
 PZ2VrdErRi1e9ROxVLV7FRpORmD3u4fK5tC/4xiB480x8gbVKwoM+PHnO+aF9uUzDzRJVduCvvu
 XHf8Gdb0i9L+3xZ6miViCiPIQ4VRaW8BpNKzvUdZmrSBwDpktT7+k4No0FQNEsHKdO+3+fjy9ro
 8oIs5taurW1ParJMcR8u6BfMN+a/PI4kbyxBhlNH41Wppzzi8GXYWQOT8F9Ft90Yh5xbGDl+KP2
 iqDD6NUnhmotL+7W1EfhsVW3PZJo7TdhuJS5rHSUzG1f0aP/MPAEEZZVYTDlPEGoj3fYllg1DI8
 iC3EmjnTrSWWSdo1wNQ==
X-Proofpoint-GUID: XkdbuKXdF-vE9EkVa9T_lpnVShRa4d2j
X-Proofpoint-ORIG-GUID: XkdbuKXdF-vE9EkVa9T_lpnVShRa4d2j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240084


On 3/23/2026 2:48 PM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8650.
> 
> Fixes: 10e0246712951 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

