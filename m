Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CBF38D68F
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jun 2026 10:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780914992; cv=none; b=S8wZbC3fh+PG3cCTeWHThJaYVNUeBkqzw3ZkBZ6D7BgwGyboiqb/orB5fefhAL6YHOUvEXv2P4T6Qobb39bP3TRXFN3ZzmllXhTHD0YhBquOKQRmt52ug5dAqt1oZZVwm2KuMEljNJVZXEPlYgKN2whR10whb7Gk8jatRX68og0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780914992; c=relaxed/simple;
	bh=xueKkhHn5SxTa0rE8+SCQcYUGJGPna24rZlLrLKUJ/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GoJ5LneJUwEQ2JJY1YZD2aYi+R2EcbhXbRhuEUsUBdfvqKazkPG+dH+8un2oX38oLAQOsie8+iX7AwbnA68gsUpXucM7AsGWv9EuqrgHbWec6ZNs1ZuhLnH2eH97VMj1K2k2Tqt7/n23Wd3PAo7LVyVzYyRM1fezZdvJ9bQ4Qq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AlDuD69l; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MFC1tTg3; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AlDuD69l";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MFC1tTg3"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6586OrxD2274527
	for <linux-crypto@vger.kernel.org>; Mon, 8 Jun 2026 10:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ImZ0Aq+n4EK2FB5Lr3zyUFNgl2SmAfecI9pM4VllFJk=; b=AlDuD69lf2KHVjI5
	fjhdMBSy85Vk5gTp6mX/KvR8CQR3Y6Jm53vmQN06K2H0+wqDFERpVrLkOyp9cFlj
	Sh23TPISnh/Dz/0JEjD4Yvq0zNCIMyUf39r0Zut75kCs7B8zLbmlTtJB8wKDJVZ6
	E3m+58mc39+olAmgl2BG7JEL8X11bX6MuHr8RzhFwdgZFvwigbqk9iKgoT14aW7z
	v0kj4Ai1wTWE/PCAJdgZhZ1sMmcaaJu0tqNz5BkTu+IO0KNDm4rg3TXljlcNwV8J
	w37hP/l4RXppynfYqM0en1rPp14zI1BcghkhHpBAXRBdoduKkAQb6wgF2bydidX9
	g8xkdQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4emcqgy3vq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 10:36:30 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bf004bf8beso51192795ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 03:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780914990; x=1781519790; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ImZ0Aq+n4EK2FB5Lr3zyUFNgl2SmAfecI9pM4VllFJk=;
        b=MFC1tTg3C4GdGGJrMgrQBGc5fl47pf8Ax+Ih0WX7CAcF8f/5a14Qr3q8YvChtzaNTB
         spWg1Y3zA/foThbID8hgXN3ljjcYANbWxqnHFCL2WZyUrZkGiOAvqqZGIeNfmMEswTmR
         5RM5nQfYj+I9YGk/JKKJSnZKPE1iptQMbLeLIHstNB5orS4eMA3hMWh4rcdB4IhQwVJq
         MxoruomG/1f0GIGVz06TbdBEFsGsEihbsglVQjj2Q745NfsWaB5gCMFreNHkz5bPee6N
         Q0CJGfMsbLhTi/v3KmgoFBjWYq8t7pQl687AGTU7CSt+fTONkDQ3D0oR1VW4Vb/FYmkB
         fF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780914990; x=1781519790;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ImZ0Aq+n4EK2FB5Lr3zyUFNgl2SmAfecI9pM4VllFJk=;
        b=YlQE6iIvmSARJ3JjJBMdKh9qM2H2o+d7qU39cvDtNcer1CKvB5v/++eWD/R19wq//B
         RoHWO8j8LRRb+sa7T/8CNZrVU1/sG53uIYGJTyPV1kwOgYbx5jQVRd3euDJt8IvXnh2y
         BVuxJ3T5aAaR2ZePVuya0vQwdJYwQaKebv6g2t8mBVxRqGC+lUdBx/lMogLn9w7WiQal
         7UluGeFcovD/vjmXH5CifQLYH7rA05FRuF0cnYfOTSJF7W73zOQBZ9QmgvFp0lPhp00e
         xL0pyGpbcvz+lSzSmKCujWhdutTPuX9Sgu97pXfmTc8aE/h/BUQp5TnQkg7lBwN1R1xN
         BHhw==
X-Forwarded-Encrypted: i=1; AFNElJ/VwUE7MaaSO+PqSuqGRnvkJpTbzjxiVJVAsDFU1szCHkTpiie5ld0gmOVKzTRb6SUnRy5fgTQRy70KzoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfAToSfeRGNcFSgsxPPp4IFY8YIDB6GBztbhQHmbNRPm4yOqcY
	IgGKiZLXoK/C9zLMSSd+y3rGqlrXhbBIti+9DU7P5mNYD9XydOS3uvnsANJ9iqdHdMPC2KQ/Nvc
	f1SReoLrHHX/WH9iJVuvhe629P1BV8oNNKy05EYVhSE9yXfWcvaOgmnq32tpwJJ8dZbw=
X-Gm-Gg: Acq92OED9I3Rok5NpIBK50dIJGKYESNU8n20RA/w3lVpiRegv+8BJHzMrqpq6m0AI6P
	FAqCkkLI/LEsCSkoS5EntqDPzDpH7F1J5Znn9UU7w2c289m15e7TbgfeEHnrkUyxhSv4OD+9R0k
	pnh2h33Lh7D9Dp9EKXuqkDVJAyX4gWvYi4y7O5kt6Anrabv+TQxEgW61ryCGW0TTI5BOrey1QE0
	vOIpiiPNvYdROePfjSTbgH5LSMelduGuGtbSg0VeYVGP+VKsdkG2nWgHFTHr8TalsriKnDKyxJK
	EJZ/GlVj82FeasBQs/dyuVUzy9G/dRQqXYqdjIHHxnnGuEUqSyLDUrYs4y0Q4wvCRY5sv8txBoc
	9he9ShUKsm9gFQ3QMPFKNpa7NxG8kvJUpnjhksuCHwkwvbVUpzVtXsOZzHrVOxn8=
X-Received: by 2002:a17:903:2389:b0:2bf:305a:312a with SMTP id d9443c01a7336-2c1e820985amr174110615ad.22.1780914989929;
        Mon, 08 Jun 2026 03:36:29 -0700 (PDT)
X-Received: by 2002:a17:903:2389:b0:2bf:305a:312a with SMTP id d9443c01a7336-2c1e820985amr174110265ad.22.1780914989510;
        Mon, 08 Jun 2026 03:36:29 -0700 (PDT)
Received: from [10.217.222.59] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f6d1e5sm167065495ad.12.2026.06.08.03.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 03:36:28 -0700 (PDT)
Message-ID: <84d8eac2-e031-4781-8f3a-d301b5ac5a0d@oss.qualcomm.com>
Date: Mon, 8 Jun 2026 16:06:24 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Add support for rng on shikra
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=dJGWXuZb c=1 sm=1 tr=0 ts=6a269b2e cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=ygU-B8C60GXm5nKEi1AA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: yeqO3milhfvpDVrOt3eczkCkCvoKGoxr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDA5OSBTYWx0ZWRfX8DL+S7WxQM+i
 vTKwBKa57JI1AzwyiLMN3McLdyp14bJAZERAqAGQE8LyUWvUglS5X0hfwVBfB/k8cawR/nOIQsG
 /CzAQ7nOHwwp5DMh06wEhD6pOtNpN/ZZ3umhODZtlq8Mvd7MCJK2dvOwBRD2WATIkLjbuiL9G6h
 OGafm0Q1IDgXzHLATEayRLjEZXE8bpk86sd5Q1D+1KvN5rEqOS2NEX2tQ4Y6A4BnEkCACSZptlK
 HmVBGWE6UF33CMHEvqx5V1MkrRmLE/fNnasMReenlmCFTNRJA/GZoaUg2QGpETQzbHQ79NQu3/s
 4McAXM4MkIIS3RuSPCQXuRV1wi9v4L490gOa0D35iQUEeDi/CF4y1yNLA+/+n+4ouVqWx9odDpd
 NBaf69nVZwq6iI+Vd/IT002P72y4m/ENP13o4M7KF9nTPIyn1QCmphexO1rufu4pRW/8twnq+Uh
 pMPcR8eqtZIZyWCfhbg==
X-Proofpoint-ORIG-GUID: yeqO3milhfvpDVrOt3eczkCkCvoKGoxr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_02,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080099

On 14-05-2026 18:46, Kuldeep Singh wrote:
> The patchseries contain dt-binding and DT changes for enabling rng on
> shikra.
> 
> This series depends on the following prerequisite patchset:
> - https://lore.kernel.org/all/20260512-shikra-dt-v1-0-716438330dd0@oss.qualcomm.com/
> 
> Tested-on: shikra-iqs-evk
> 
> Testing:
> - Boot the board and verify qcom_rng driver probe success.
> - Validated rngtest utils
> - validated against dt_binding and dtbs_check.
> 
> Steps followed:
> - cat /sys/class/misc/hw_random/rng_available
> - echo qcom_hwrng > /sys/class/misc/hw_random/rng_current
> - cat /sys/class/misc/hw_random/rng_current
> - cat /dev/random | rngtest -c 1000
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

Kind reminder, rng/ice/qcrypto patchsets are sent together sometime back
in single series and please follow here[1] for discussions.

Please consider this series as inactive from merger point of view.

[1]
https://lore.kernel.org/all/20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com/

-- 
Regards
Kuldeep

