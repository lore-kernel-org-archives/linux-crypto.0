Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29903148D9
	for <linux-crypto@vger.kernel.org>; Mon,  6 Apr 2026 08:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775465974; cv=none; b=kqWQx2oPVDllCEH6aTzbBvW5qOcE75ndDvcf7OmfmoNHY+bvJ9Tf8HLy6SpX2+14TFC2T/oQfLfRphZWXdBv6Krm6CSiU5gra3zwkLPqjCLSIU9rz5Xvkqz8K6znbwkpks0E7ejP5AVS1YRNBOtzvOiR680AhzVDu4fdRrPobs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775465974; c=relaxed/simple;
	bh=BrcVfbLNxhMfWFJdUk7YBXP6HNG08kaECFRtSb+MLrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UU199x6nSEfYMhELm2aoledgT+vYd+wSRynG4nXDj1OzbBzomQ5y0imaeAmwZTTR0TPsrIeayqPX5a79nc3zPH0qxOMu8MjPOcZfuJZ7H6Kw4KKwJLOP8j975Ef9KYvVOnsFeOmmKcgjlj7LRLbsmjQj1C/j5+ouBxMahvWKCxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Uf7jhBWc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kJu60Flk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Uf7jhBWc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kJu60Flk"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6365n1IY2188084
	for <linux-crypto@vger.kernel.org>; Mon, 6 Apr 2026 08:59:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nUuQJyQWeCMv2lcP2Rhjh82ZK23+I0twqK0B0ISiMFU=; b=Uf7jhBWcS1m0c0fJ
	yFlq+FWFksjVKVFL+ZUXH7Wo6ttRrFZE7flKHGjfSaCLRKSODzOT+tHHQfgEMZu9
	/mT8eM3EBRff1AIqH4ghH7z5S0oAjNlRGem5XbOfl9LquafalQxmibYnjf+7v+C2
	Py5gEQn5UcIEAn3qEb1th+VbSggjaehJoyY4rpx+6edRO/FCgadw5G/bk3/hnpLM
	XqpZiZNihO/LJnwsyzz+OUFGbpOjp96Vwvsx15ZNe5xSWeXUB2xo79bjeGHw3l8k
	U+o+ec66ngajYen/HDQvx1ZjKj7ewXBm1cDHbwZb3tj8Z4HhP1BNNcPWaGqW/41p
	BZP1vg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dau14vh0x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Apr 2026 08:59:31 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35d90c7ec5aso9764907a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Apr 2026 01:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775465971; x=1776070771; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nUuQJyQWeCMv2lcP2Rhjh82ZK23+I0twqK0B0ISiMFU=;
        b=kJu60Flk5Fd/J14JHZ+OAQONfpwDCEkxH66xJObZPRscDQhVlthpO68OzXq09T79ST
         7F+bekbUUBb2b9pTCnSJ4mBSvupMB1CL1OnUHvGiu3Fmkd4bdh5U34B7+U3RgQPo5bBw
         FUMa5u4OkAa9xvRDBQ7T1/oSSjsgx0dI8VrV6rupeLTjTRS65odkeDZBoHv+T2hLaHNz
         raIf9f84ZVxjqzdQnyYQnWaL69GVYxe8odLEtpk2PEcwuUeBewDSv7fnSxrmwdaOnTzU
         9fGKqpYPpCxYRliOSiZW55K8U5yH/xRthAhmd5FAd/TF9oQLv+U3tWefs8lA8dS7B5Zz
         CZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775465971; x=1776070771;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nUuQJyQWeCMv2lcP2Rhjh82ZK23+I0twqK0B0ISiMFU=;
        b=hSPtOrYMpInIVpOO3mt07HQd8ftuHfDaskajzLM4ajjVZ3liivdvYxCGF0lplShRB7
         WdJGUViuzhxwXJ7duDy77nxKdwdWMaOI0XLeAsw0lnkIG2u2H8hJLuUX0i1WL+QxwoxQ
         UJUFdSZ0QgPpcUVGkw++SgjtMpF49h4RgZXenW/4Q58KZ9dlPhBxh+fQfVzw3zBveCEZ
         hBg0m4r+90jGAk24Np+yOxfIadSSkncM/pkQc3kx9Vfx1bG0gHhdujeHaqFK34ieCVGd
         0Tf8fwAxZEkLC6cX9ElqB7DA8ybbLDuw3x3sbpS+XykoNA9yXbxP4C20HZ0gsWcmPWCE
         Zq3g==
X-Gm-Message-State: AOJu0YzfLlbaZek+T3FAB6OstkyjIKlp8cgljDYWAs8P5VWEwBKFg9/M
	wFQy1Lk62ut3jBI8b0KX1/a2Jul2DNApzLyyJTMhBaycYhZBqfbEG7m7FGLwFiFMqkEyBIHzixZ
	mwfW/ppA2v+TRQBANixWuErcUFbuLyjqRPrXJvOcBlh5rEf5aWNrRHqis3CwCUPmJhDo=
X-Gm-Gg: AeBDiev9iLAflpsPhGJKKCc8+n6jCi6A5VzopFPwneWg9pFzm7HllnhJKF8iZPBDL/8
	LRi3RkThSug3A8I9oV4LZxlNrRz1hE935iLh6xYTQ9JKitei+0zv6IZIype8jq4PMR7Kt5sLuR3
	SAmjtOEQUwt6sUtHcwI1n/6WvXkkkItT6L0XJpfq8UTAYlx7TWBOnWokxZQ7EpskR+qR1Isgtb3
	lKyYPHgNzrg9w7u7jl5wY/3mmFss6Cg+LT7sx2miQkxbxoB0cA8c+ED2hpTw6IlBZGUWBRJfeGV
	ARNRKTn1X4TztpFUeKE+Z2lloRfg5xAGGXeR6YhZR8/gHHe/pcAFInOXZ7eEUvdVsH+tPAOivzh
	uwahNiswqL/lMTj4blnzm/Fksd2rcly414ua69VZks9gsBGuFPR7J
X-Received: by 2002:a17:90b:350e:b0:35b:9682:51e6 with SMTP id 98e67ed59e1d1-35de691ac13mr11912807a91.16.1775465971031;
        Mon, 06 Apr 2026 01:59:31 -0700 (PDT)
X-Received: by 2002:a17:90b:350e:b0:35b:9682:51e6 with SMTP id 98e67ed59e1d1-35de691ac13mr11912785a91.16.1775465970588;
        Mon, 06 Apr 2026 01:59:30 -0700 (PDT)
Received: from [10.217.223.92] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35ddb973ffasm11945602a91.2.2026.04.06.01.59.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 01:59:30 -0700 (PDT)
Message-ID: <8e42c7d9-d96a-4e73-abbc-443cf131c176@oss.qualcomm.com>
Date: Mon, 6 Apr 2026 14:29:24 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Document the Milos
 crypto engine
To: Alexander Koskovich <akoskovich@pm.me>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260405-milos-qce-v1-0-6996fb0b8a9c@pm.me>
 <20260405-milos-qce-v1-1-6996fb0b8a9c@pm.me>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260405-milos-qce-v1-1-6996fb0b8a9c@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA4NiBTYWx0ZWRfX50/xHfZQhULa
 UotNq1JWtfEFEM9zdrSjle7s6eReGAVfk6wX11CStF/mdbW05w92k7JsV43tXqKac5Tpm2XKoxM
 c10Xue8RuCSYSSy34SgWiEYjTd7zhVI3Hq9lhKCxEyjVau+EPWi6yFzQw71NCCsMN6vYtgLW5bx
 WxzgDM5p2sPUhbxRxWQMcizxbG21acouaGDYHM2V1dI4m+6qL9zEej80RZKVdKaK4WA8kV1YmX5
 M5B8Y61vtG1/abqL/wNTeTPFYBDG8seATO3ytKL//9VF043f91TnpNNEoF2rGJ5NKc7RHMCzmin
 ZqfJ9FKD6Ju/GJ9lZx0S2KaV31dxy7baSFPWtOUaqhRGuxbem3lacfVjM4FbKV1ok35KJSPVM+h
 jDraUKkcrvRNl4iLfhHMNbAn3cutYgi+AhXSMWOAz9/GKilDxpu0UXXKwRnAYljhGQmjc/tSiQW
 uBfhWwbRlQTMyIw4TAw==
X-Proofpoint-ORIG-GUID: n_SI-0Bvo3-KF91g6bW6d17k-uQ1E-PF
X-Proofpoint-GUID: n_SI-0Bvo3-KF91g6bW6d17k-uQ1E-PF
X-Authority-Analysis: v=2.4 cv=Q9HfIo2a c=1 sm=1 tr=0 ts=69d375f3 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=ocJNlaTN9KdHZx8uEnYA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060086

On 4/6/2026 7:40 AM, Alexander Koskovich wrote:
> Document the crypto engine on the Milos platform.
> 
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

