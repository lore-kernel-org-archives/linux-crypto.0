Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF403E3146
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774348687; cv=none; b=KAWsEt+ZDUgb/rImYljkhvoVkiVN88UP7TxZYi/SY+goedxZrqanKma2UfgaLzvPZ0XFrxVmW553VWpgE5v9KeH8VyNkf7FXzpZ54cRzdYWtvlLzaMvWDUbQPc5iAp+/6MRCiDkzYEfL0ynTQoQaCII1eNN72LNl2FQYxxODR8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774348687; c=relaxed/simple;
	bh=4nTSkJ8Z5UP9+k9ovEKnp9OOrytj8jQs5RhK5L4WIcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YNI+1daHp4B8GEazZ3X/t0IWkqPl+p7iAE7k8LiJ4lxWKtPZi7boipo89VlvrS/ijLzjheebCcuBzu8fbgoFKJfJhzVoeN/35y3v+GZKM37Aj3GC4Ms2W2Gr7DIRBXTSIYJ6ajLIwVqYuPQlcDUuFevUEBk06dfJLgMHLzH7Qm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=O21yC/i4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K+ohYzmv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="O21yC/i4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K+ohYzmv"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O8xnKH2323354
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tJrGXDFrbMcwpgod7t4kbx8Wp/kOz6YdHGYxpUusIJo=; b=O21yC/i4zNbFbVtI
	xYRM2lP4HpI/UT+wyLt/2RV5Fa/rchBDfSWFTGNqg1AfP97Ef6y/RCZIw8CbCHHm
	cLXEVAaqFop3lnrR0h6IG+k7sTE0epUkp+c5BflAwlvn/rPDzJ5FkuL+vhK61GZc
	oGjJZZYCSDzcRrcuuof8TAqAbxo0gD5By3F4d7NkFvVyXJp9DA99JFNcLmP5hyzN
	8FxMj+I9h/NwjzXpQ9Fa5dc1pDUbxdD6v/TXXiyRBUeJMzhrk7RFVM7aRLdSrd4k
	WVMOseoFhyi3pSQ6YQRW2UeuKYCdXDSTjgOTuN6HK0ZlIt+8X4Ont8lRf+Eb15nZ
	F2tEag==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d3qkerd2w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:38:02 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35b93be1227so4525463a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 03:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774348682; x=1774953482; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tJrGXDFrbMcwpgod7t4kbx8Wp/kOz6YdHGYxpUusIJo=;
        b=K+ohYzmvSvpxt3m+ONgXLOMK5pTxrX7uHpERIMeO2PlQSxM22q8yToXVLwo3hxgpwz
         RaAcAlZ+sD1RjZCllVbzxfQKiPTU4fz6OrJBWJMSONUEalJyon/bQl0vmkb2VOH007Mz
         TY5GgOvKGPF+/JrSwgs7A43LTdqZ94KcLjnVaCTrORnb3RgVkvcgfYJ5YWAOFE5e28i7
         31hLNsUbsOecus2xAlWoXjTj4FKDMr6Q13pM6hQVhr0AZaCF3AY+zEz8HX+4cLEx1oes
         OqZFV/Cd+eX2BabfCnsS5maFFkZp0nHzlt82QRtLL/DnmY0f4YU+tIBKwSKt7mPDWAi8
         ohUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774348682; x=1774953482;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJrGXDFrbMcwpgod7t4kbx8Wp/kOz6YdHGYxpUusIJo=;
        b=o7L2SDbJ/sHS4jGYoJ/SP0To54Zcf3YTTYV2bqco2fBKUa8diyjPkYGgRFjV3QwLls
         ODIMjjChrImSgHpX+THJbohnlFWHVpSKm1Uspyu3NhAclBkEUo3PxH73PwL1RuS98sRy
         T8iImv9Oji37xvfsi62MXz1cosqS9XpqCjeYfTPFQW93vZ4qhjCalpRdWlYWZXhpOTdO
         0cgPYvTEV5YqtmiVx/b84Bh4+iITr/S3RXSwWzZvRNopPMJz+2ax0KJOYlOfS6HfukAK
         Z2GvSlS0F9ZMmj+0MOqSy+vWyba4VudWPPCrUtAOD8HI2xwOmI9crT9G39JrsMN6vKTd
         b2vw==
X-Forwarded-Encrypted: i=1; AJvYcCUuEi35nWU/g2PIPYUfms9rfsYYZUcyGGIcQ/s4ArbpUcaxAhYMiDwNXAGuWAqA5ddn4GPYivnaQRliMUY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy+Yu0URLiT48itty+Pju27lRDkY95r6ICRBc99Engfm3r/9gc
	PsxD66ETkg0YVdUrU5gMYRckInDPcIqD8D2u0RFten2yUf66tnmHAfoTXy2yVAl5/h4CpcfeSwe
	SQtTKHpiDe1Nj5ENB1vhI5RjVtw2eUatlhuohvuwBKwsaPZ4ONgLxoBOC23mchsAlSRI=
X-Gm-Gg: ATEYQzwI0DEJ4mhGmtAbU3G27FpBt5aUSxBBxCCiyLKKKLXlDlVftZvA83hO9EQWuYM
	EVIaKLb4kcG+BdchpHPwjCQbTKojYNaNaFjVt1z3g4jcJuAdHf6JGIqPETTpfyox/02m/NC1lBX
	nzq3uKSyOmdKBemwz+Qybcnv0KhRRIBz63QYWSVytp7pJv2bB0MauaBl6gh/bZlFyg5uFLPXc1s
	g2K6kgLdJZiFngfBiNSYQvL1kEwW1UvjRFgZQzjiOWgcmaFafh5qSjuIIt6hDtbe1f/m+7Wxcsv
	T+fGCn8zrasOeVpnGhEcMTnycJp4GfWaSpbVSuIRS3F7WzFjaRSrsIBgMePsvgHeCcDHk3hhkCJ
	bEnS6Yy3dj6++v1qUk624zjzP6lXiSRf8NFKEGb28AjAT6ugopdxL
X-Received: by 2002:a17:90b:3943:b0:35b:a760:1a54 with SMTP id 98e67ed59e1d1-35bd2cdae76mr12688960a91.18.1774348681439;
        Tue, 24 Mar 2026 03:38:01 -0700 (PDT)
X-Received: by 2002:a17:90b:3943:b0:35b:a760:1a54 with SMTP id 98e67ed59e1d1-35bd2cdae76mr12688928a91.18.1774348680916;
        Tue, 24 Mar 2026 03:38:00 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c03124a87sm2468107a91.3.2026.03.24.03.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 03:38:00 -0700 (PDT)
Message-ID: <546967f9-05f7-49ae-bfa9-204533715eb3@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 16:07:50 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/11] arm64: dts: qcom: kodiak: Add power-domain and
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
 <20260323-qcom_ice_power_and_clk_vote-v4-7-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-7-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: cf5gapMb-RN9l9WOviePgJDN5Y5dJuml
X-Proofpoint-ORIG-GUID: cf5gapMb-RN9l9WOviePgJDN5Y5dJuml
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NCBTYWx0ZWRfX0hIA7PK4aARD
 Vlay7gHz2Ecn9mfM50/jMzNEgNnncC8Vv+xA5BBF6G4MxUv46ysaCA+MB/NJAvhyRrzVOyo2RP+
 9+t1ZgNun4kyCf1xalp9681XZniYqytbpaNv4FvPOZpIjxPl5BwUA6JRUUZoxHtkFJL/G9ObBoy
 EygV2I4BWoh4MynvWYtaaqQ19+G8DuUNs/IRHASJ8Y/h4BwKSsEKmlSAaHvq7SJgdRkkHqLeqa9
 7pbZN+s66FmX6Im4Xl/zqguvVrv/SNbAQDiT04OJo4SxrxxDDmighCzdiBO6/yHuzMaeV6Y9fgI
 i78lRvXjcmpO+UDW7TipbinZtWRzWRIw1q4D2KnDCCMDS/l3r6wPBEMRitq+O+BVMfTIsk7NFOh
 fwzt+1vvl+gjD+3S15Xy2CrY7H3yhvixKEv+tuXRfBnpqQqkqXL9b82YzV6EJQrzHP2/pZxZmfk
 MXTIBj8jb1XHc5XQyXg==
X-Authority-Analysis: v=2.4 cv=Veb6/Vp9 c=1 sm=1 tr=0 ts=69c2698a cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=RcdfdvLsBkETvr5PKcUA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240084


On 3/23/2026 2:48 PM, Harshal Dev wrote:
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
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Tested on qcm6490-idp and ice ufs probe works fine.

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

