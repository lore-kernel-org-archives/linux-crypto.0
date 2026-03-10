Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75B238AC7B
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773151964; cv=none; b=O/2U+uN3I2bOYnvhapXMdIBZg6It2kttDDzqbxyqxfjS6Yk0gkf8CGFzIkajsKN2l+OwXKF3pP6YRKaJgujKUGKC2cKpHVo3Sz47luLcPnTIWRoxK30lPh2vFfw/e2WrMtp2btDGQGyHnh5iIWZbvg/3+MTthqD1j9qQyq79WsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773151964; c=relaxed/simple;
	bh=+0QsUmKSdIAOx3H5r3Bwuurcl+aY3MLfHPpoPquchN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WYNNcK7oIy9h3L3+RUlOaDhUnD3Fr9AwQ87E1M0xTR/2+mg6IMzJ85TrEbOo3y1PQ3CUKKLItd2x7gwEFLeuxciUxw91FbMJFV5FkR8vE2DiDmqw0XcG6bb60qLsFBQYDD/U0xEi9F+a9lxZaDEvx0wlJuXQXl2PbTcCTO2z3a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YsQM/M47; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PosIlbpU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YsQM/M47";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PosIlbpU"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACavYS3296707
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wyF4wZYpsxMauFewTjHkjZxZN1aE7LqB8yEQANT66m4=; b=YsQM/M47A/tVFFWU
	TM3WoFHx2VfZxVGNJ2syTUVR+okXmuEny/juQEf8fwZ3pMnw2JikAFHjIaw8x+H/
	Q7QoYcN+IeUBHe359Gze6tYv6DatTqwFMM2NcZ9E4F5S7tWpo7ClYkMCjoYCG3bx
	w5LSrBMI6MDohr53VeXxQYckcDQHLV48mv8AwUEBdO/aRM9Ri3kpxMwI1usajMj/
	qMeNTr/GdW9JNVn4KVxgt6P7LZaWXCOTQWTImoSSbTa9z4jlw8sSNMlX+MgG4FAU
	qI2dmsuMWWOzmosed3GVpB2XN4VLp6txp5TzstSYu24qczggWf/rztznjEyjdtEu
	wIX7iw==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctg1ms7ax-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:41 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-94ac6242928so1510574241.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773151961; x=1773756761; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wyF4wZYpsxMauFewTjHkjZxZN1aE7LqB8yEQANT66m4=;
        b=PosIlbpUDbfhKzXBSfF3QnZOmghopL0UuJWY0vLV/jjp64SohguqNm5dJEYqnhU+Cq
         Xcj0G/hhU2gnCzaAfylNyMVaXDg2S6qSLlT1ZhOhHP9Hbmov2iBi/3koNr3yfY0mg2Tp
         gKepIoSF4Y9wcjERWZKSH3TrjIYuRLWfkGv3+BJTNlxPK+mk6Ou5MMLHMDAambuqm/7X
         76Fic9/kr0miIPUhh2JLHKoDoHv9SRQvBCqmIVb3bSelhx6hofmlwTMa0HUgTLdkS3sR
         HCVklECPAoLSPther5cYG2SQKZHSrmk3qciJ8Zc0/fw75RINVpTrCZGfm7j6q885K57b
         kCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151961; x=1773756761;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wyF4wZYpsxMauFewTjHkjZxZN1aE7LqB8yEQANT66m4=;
        b=CnTOL9qk1hJ5uzIvpvqYg8XrbR7r76meOgAxAhr7vqLqfOVilabsPAOS5VAFtpU/RR
         vK944NRLUwklr9LXCcwf7OHs+q4V3RXdX/DHoGBeFzazsjNc3d9SSFrucrCQKbozUuC0
         GOshvBTBAO3hYTb3LFqoblzq8X4zAJlezuqTckb1h8hAxOxexQDxG3Wj7RQRXg6xycnT
         jxZdK123bS/8INQrA+zXYK5xh/QSRouMM9C7/C/2qPSSy/bMzrSRbL0W55uePOzEtubQ
         x9CZL0qkK535YXSAhQ+yGW8U51Qn3c0OvjfoN/f3/cFExl7EX/tVUHMroLVzCe945ws2
         rbbg==
X-Forwarded-Encrypted: i=1; AJvYcCVX3jgUdafv4OFwms6OBykSUcuUC+NQmQTvncSCNR5xpYVebMNQeulGeMdnM4R1M79p89gyMbBp373CT58=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0bimc9XJrMMEU+D9ATdzWT4CBuhR/7YE+I5z76RV0RZRAIT+G
	EWYQSkbe4XU8loDNV+at5wmh/LXDV56TAtRJzzXDCbf9LHQp0mTR5Vy2NZ/dcwFvnTBDxhbPnGl
	OSxaDF6r5E+daquUOLKAxbnv7Qf3gyZQeA8uMDNHQA+Dq9oNLr2NEa/JHN713XkZ2iuQ=
X-Gm-Gg: ATEYQzy6eCLWIOPq0EJ1qgiPcdK6q6nfDok3uPIi3btQFcsqBKrZE1MZAYGrSIenbws
	xNt47+oc27eaGNWlm/j+vHdu8JKTcCGHdYOfbObGrWI6PR/qFY5rqC8oo+tguvmRzcWo5dDsbb2
	FNI3MsglPyR66Ifxsks5a4lO8qPyMhynMkBx8XngOtMWZFYz9HAop1PmIuepX/yz82Jp6QVEmWc
	zWeK8xEShLryTN9Fvn6Dbw2RIs/OfudP6efzxrrxYX0+Me5xXuAwzkdrVeqoEKJbWX2/APZEKK2
	Na7ra2FJdj8oO1Khzx54yZDDe8tiOWqPBP/iu4ZHjkRtjG0TcuCescfDy4e+Nt/5iqY3r5A7mVP
	rCEMJR6HjcVGTWAoQp3FkqNVf+irurOMPVKcaU5nBhrvOGZzIQ59dcET4VyV4JA9cmx4sJ5uQMv
	WKiXE=
X-Received: by 2002:a05:6102:32c1:b0:5ff:a16b:93e2 with SMTP id ada2fe7eead31-5ffe5e9712bmr2763506137.2.1773151961084;
        Tue, 10 Mar 2026 07:12:41 -0700 (PDT)
X-Received: by 2002:a05:6102:32c1:b0:5ff:a16b:93e2 with SMTP id ada2fe7eead31-5ffe5e9712bmr2763489137.2.1773151960520;
        Tue, 10 Mar 2026 07:12:40 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-661a3c66d3fsm4317323a12.2.2026.03.10.07.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:12:39 -0700 (PDT)
Message-ID: <39c6d1de-53d7-4aab-b054-067c182fe0c0@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:12:36 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] arm64: dts: qcom: monaco: Add power-domain and
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
 <20260310-qcom_ice_power_and_clk_vote-v2-4-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-4-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=YOeSCBGx c=1 sm=1 tr=0 ts=69b026d9 cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=z_dnvKGLtVwtNw_c-ccA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-ORIG-GUID: I3brY7wcAESIMTpq6LrL-nOjdq7FiJEB
X-Proofpoint-GUID: I3brY7wcAESIMTpq6LrL-nOjdq7FiJEB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyNCBTYWx0ZWRfX6fuZ5byK4ki7
 6CTuZFiOHsD0G1cIJu9ZPb9vjOX/FWWZSN+9xptw+rtkjw4QFt8bZJYlFSp7Plb1Y4Oe6d9v4iN
 8tT9lpvR2giRx24BE9zQdj8WQ/DxZDt+72RoV8FaXHTXFSOujolvA2cSviyDfg2Fz9VnbzNWUFL
 ajbWgsItHczBwajoI19X6sFGfWvCLoQtu2pNsKpks+oxw8Koho3L+8clkkIIXqOwpsHRELINPCe
 RNBYgN0akhj0MGkrArueszP6sGOFmqPMjvcpSzUctU1A+hCyx5iQ4V5xcTN1MjHyA9066N6E5wM
 xE0WLH6uWFW3RmYWc41B9HitEyl7Z4/TqhjmyuY5poVGBlqPNE6usngHl4h+fmGtlx2row/0qBW
 n6RJppS1FHXiYmNdz0K91G8NHM8TDSPcJhEJZ6e1vV13/GCrVfS51NQieff8tgFetaUybyQeSmg
 ItkU2DA0PoztEL8ezbw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100124

On 3/10/26 9:06 AM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
> GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
> monaco.
> 
> Fixes: cc9d29aad876d ("arm64: dts: qcom: qcs8300: enable the inline crypto engine")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
