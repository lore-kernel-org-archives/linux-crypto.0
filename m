Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAD4399357
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773151969; cv=none; b=VzOflMDM3005D21GH20LS8+Tos2WNyFXm1i+o5IX2Z0IX/yG8pCOJ2wdnxNGlraPyTGLpodmvFjcyDlDBLdympZednrTeyFlmyiuJbbCrdTdjfLxIRQYoJ2sMVVnHS6sN/rzsYqSCbdHfpQ5PMX8tdrcbOlV6Mpdj+O58ivQEJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773151969; c=relaxed/simple;
	bh=+KTIjkL1fMUsF5C+Uy7fi7NsEQceepC8CV8GyeY1hM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g7FM+c8CXiZpE/WpF88UCxYpC6AQRp5ZJIK/cLwFViXYNajaBfoxmCFX3pjFp02i5ZFXEQYbXDvIctDSJ/z5ziH32ra2DnwAw7nmKumkhcwrpxZL4M+6ERiz9DMixFP7CDPrYCLnzSturV7SYdHLNWGNwd2r5662HDvAnYnez38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OqgTRfR/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y+hnHqHM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OqgTRfR/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y+hnHqHM"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACapW3790202
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1zGTVzhjGLlYOLvxeBLSV0gDnAHmqo3DY4rcCyXMpks=; b=OqgTRfR/0T6/z5C9
	VlpDxWx7rtN0WpQsOHfrJzUMws9TFQu/xeKLrKACd/HJWMmI9otyRNyANCroT16G
	ZXNxHu1/9WFVdfCE/Q/Nq2tSu6XIqOzjybFxwGxRSY1W+dgIZNafFFQehgmvERd4
	iccHdSR1jfCclo8b0+BKbF+WWE0bcmA/DqK3ySZI7WSCo3LaU1egqv1RRlrW5TVg
	b5b/rKcDlpr6hMhkLXJRkqmBMVzH2VDJHwEq8Js3fmMnMahYdUVt1z5YIqI9q6QS
	Z8JvJ9qWX7bA4bpA6E9Loh/lDHPxAZ8cZmcFoB3ynQU8TnbQZkL1bbSOUWDW81z9
	Afamzg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct1ekv75w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:47 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cb38346fdbso53446285a.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773151967; x=1773756767; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1zGTVzhjGLlYOLvxeBLSV0gDnAHmqo3DY4rcCyXMpks=;
        b=Y+hnHqHM7REPn2R5Q+2PcgDaRSB+jFW2fcyJedK7z2545mACcvgB/GTay9XcuHnMlk
         02KgTiszbWlAZ4krenedVVJ0aYbEXJIJLlFiYT2NSmURVtd0A/IizAD5G9NpLKNts02r
         W7md5ygp2k8KUW/uOF0kzy4/8e4THznAlnC0RRgFI0CfKpnKIap3zZSTyvcag5ol/Yp3
         33ooOMcXCl03dE7Sq5jUaME0ZgaWJ8o4s3uRRBogUg7A/cSTNO6J4mYxdiqbzoeG7DMq
         DV7790gRGK/yyjzLcU7kvpjN4s+Fd3VajrQ21lovvCN3kBPncJ8o33I4TwnMLvfHisuP
         s+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151967; x=1773756767;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1zGTVzhjGLlYOLvxeBLSV0gDnAHmqo3DY4rcCyXMpks=;
        b=mnqtq5J0iBnFY61HJ93LAMIvgSJB7t6iiSt0FwymqnPE9g3X397C3xbcDn4kUBFY2N
         DTL79WmGs+W6D82JvZg2Wv/nJt6wYuq1karl4kQ2WeYjPw6a4xg/gFXYPjrf/VdQlRz9
         5tvN01lNtqljKmHZbdvQIapW5TjyGAwJkSZUzYJbm+sNv6DolmxjEY0Q7T3PhXFhU6il
         RBLKHg++XqWt3rtxUcwDA4PIqck4ch8oZCg1fZydEaorvGj1YwNlItsTOAxEkQHFrW7X
         0uSOjdwE1Fb/MQhtdR9gA0BQ68NZj80m3kpeCAwOyO79I0oGXO/mx4WlputepCiu64oD
         XMsg==
X-Forwarded-Encrypted: i=1; AJvYcCWs6BS6kN0gBma2toNRc0vCMJUqmdVzeXjqJSR5BCv+8bVQoEaSha+RGE9BKwS95JLWb3D3TRdLBcftdn8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSNeoP6LIL/PSjcIsF1q+5OALlt1DoM6JtTgl+3aBvsGA8UkfS
	Wgw6gC297RIg9FFYkTGERgIWesNfkoDkHgmudTAjgpR6iXyjxegwIzjpcdjVoFULC37QUooiYZJ
	SDnFVH7mtjM+O+pQ7l0+M63M3UPADvU9qNDtvW3SETFqb6DhsQVNRaj3HOIzTecSThVM=
X-Gm-Gg: ATEYQzwDn0PV/YpITGOvjQoRc1z1rffPUawg743yrnDr1Pc27lhEYY5/lgLd2WOsdGY
	LImfFrF6rGMUJO4Q2qsLsbaU5B8QXwYOVeg7cpNeYErDeKsSUuBxBJvMwZKe643tB9RjopQk2np
	p7o67FXqCSzn6Aa0MaV9WnjiYY0UqOku/hKJyuKyp0Upvc4rjpjNUMGnS0DR53BFqhVqbTHmyNc
	rYg0ExWTnYTb0PVQwtFwLQr4wdlWtieODDhsgw9aPUfod8BFxGYYHh0VZ9zTsHi6+Of3DWVZyK2
	rh9cPLbk8z2WnBJ3RTR0MmxUSF8CG472yFYu5dzJ+FeboExCDwuT3igdQDKSVNbIitRdTcDjaWK
	UgopWpVD4wXqvVvfEbgcpUMDacxVlXdRpyFL6Uy7cP2tJrpIrnNsXBMzLoYQB9LL0GPEDgvj6HN
	swMRE=
X-Received: by 2002:a05:620a:45a0:b0:8cd:8d50:16a0 with SMTP id af79cd13be357-8cd8d501f65mr623701085a.3.1773151966600;
        Tue, 10 Mar 2026 07:12:46 -0700 (PDT)
X-Received: by 2002:a05:620a:45a0:b0:8cd:8d50:16a0 with SMTP id af79cd13be357-8cd8d501f65mr623696185a.3.1773151966085;
        Tue, 10 Mar 2026 07:12:46 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-661a3c66d3fsm4317323a12.2.2026.03.10.07.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:12:45 -0700 (PDT)
Message-ID: <b27a3e14-60fd-45e0-b33a-16b53c4d8593@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:12:42 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/11] arm64: dts: qcom: sc7180: Add power-domain and
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
 <20260310-qcom_ice_power_and_clk_vote-v2-5-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-5-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: c2BLy-hBPnfIrdylzkEbmgBFSqWrsH7w
X-Proofpoint-ORIG-GUID: c2BLy-hBPnfIrdylzkEbmgBFSqWrsH7w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyNCBTYWx0ZWRfXynVqpINVKwjo
 d40nlipBTFncHAtoKjYuUkw9hXmp6uieih1I9RlX6BVJL+yToGfHiYSpfGkzAOQ83nGcvpbA1MK
 CGE+4tepOnpwfXpvSoCJS9GKxUWhdjtIhHQ24YgiD4+AVMdrrzCMRXjXQGW0xehQ5pzE9xSfBtd
 e0YlMDsVdPey9qy8Sogfbdfr9bStNrvtlVEQkj4atU3ZFl5+yxOL8bUWdHKtHe2EzC6xzzsHeLb
 NVPNtOCWJac6DulPawsMkv2auxhGzTvD4G8SwiYr6CqJwguQqbkxgax6o2iiX17jX30xslYEl03
 ZVPlrLaDWUndXaDBW6WiNuYdkT7w4UzbpVOK0R6oZvOsc+292fyOCSvQR/5qRH6MhGrERSW8Nbv
 pxfOihAfvInPR+r/AqVPFJDeGjGQTEt0+h7JFlF6xVIModPKcI8P9K6nuResg5Z2+0WfW5V1AGr
 xcHJ/yS/RRutcFR7Ahw==
X-Authority-Analysis: v=2.4 cv=eIEeTXp1 c=1 sm=1 tr=0 ts=69b026df cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=z_dnvKGLtVwtNw_c-ccA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100124

On 3/10/26 9:06 AM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sc7180.
> 
> Fixes: 858536d9dc946 ("arm64: dts: qcom: sc7180: Add UFS nodes")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
