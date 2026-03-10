Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49107391E63
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773151991; cv=none; b=N9+FtQmiG+j7HnjkUGENCvHUbwQKtzMwjul8AR0dyuFZ7QUa6u4MAoiJQw0ynbhQYP1A6YgIP4KpGpTGs4Irh/YHNzr4wP8+F6i/FN0D80Ol8YRxW9zPNNIw5nBcjcscnDM0hJ/XUL6Dxx2sRhA7gxdx6Xht8QOwezDLQ7i8JXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773151991; c=relaxed/simple;
	bh=fuHMn095nXnFWpT3nvSDB5emiYVKz1ZSOBPXG+Z7VVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VDYvqanE/rrUUIIGPGpxAa13ndIHm+uF5F8a49H+Cw8s7pO6aWiQ8DkvBjqC06blnMyr/dAgcYN6qwmgOYlXAsxvrDxPAOtgZDXm/QiSzJ9YhFEXXcWkAlUH6Vt/lfl+ywL5ARWI2caUOe7gkcYmM4bCHGe+9hb9aqdd9X7TEeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fSGkSXoL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V3bBtZar; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fSGkSXoL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V3bBtZar"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACaS3o3759039
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uj7lRluEZ+PijDD6FAfpyVAEjjvz57dxZpftGNLTZuE=; b=fSGkSXoL6BwpNJAL
	TNBy0v+QW7JImjzR/ehgL8s+PmUs+bwuYfBP8QFCybN3Q76IO7lSoiirWQedfmED
	3oMQwAIbZZ3MDHwah9qIkxFxqofbqJGPGs63w1rXCeju5+kGMGxH+cGTbNlgBB+1
	BRx2Uxb+OEZnDFph6YpVwSg4ddkeiw9CPb6EBef4XT4hgyYhVVKRZWMpdY+edSBw
	pFe7NIGogQFF3MDx818ubnXeL5BrqE/6gdZjv8fScVLUNr7gpEZvpdoreGO63ijU
	VsqL63m/JGO7BCwUMGZpcDt+oTw4rWkGJn11uY5blIoQqwS7ZvFmNo5/KBOlvAT7
	M5uITg==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctk8ugcsr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:09 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-899fcb63705so46301046d6.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773151989; x=1773756789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uj7lRluEZ+PijDD6FAfpyVAEjjvz57dxZpftGNLTZuE=;
        b=V3bBtZarZbRqEX9hnXKcoRrBppHMui3bTI3HHXdgKi965KjSS+Ef60b7vr7ZpkkdRS
         Oi90XkcFixZHK258vsRVPqHisXXHbxihhTswhQEkNvEtZPq3X2OTaOj+niO7O6mGb/zC
         HYkdcSamkiX4xMNSxNavyjkJvgDtaeFEMz5Mh9e/T579g+rP/N5uJiapjiSY/4Jp2hbv
         Bo+K1ngeI21iC8MRXcQQ5XbdxTYudcK94jpt2aB1xbQYAUmTXTjEWXhfkgnxtFvn/Q8G
         onQPGaTt/ZHe3eLHz3wp4KX0/5PCw96N/P3RLZe6NtjV17h5xDOpmEOG12z2fKR/r6Kt
         0t0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151989; x=1773756789;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uj7lRluEZ+PijDD6FAfpyVAEjjvz57dxZpftGNLTZuE=;
        b=Drndv/eb9WSLQiQUqJiaROcq/b3Y6n72NKHm9ilL9aqR+2wit0eSDIGquVlQuVXXjb
         SBY3ueGHXEqGWpZttyXg5ADddZQUwMdGX/7o30wP98kg+uB3M1nJQ5rxIILI9/8DHSzY
         fn1epoeuSm9oVo+XiXhaQNO00705a0VhA10/t9Bref7cFzR8SkGBprHfJC5z9bVrMl6d
         AZQvUAOGoZy5wjS8nv5869rtnzmxmpDU32oWX9lZA2rVgrlGpxQU0oD71s8Z/tctFTqC
         YnPcoRxwlwiVpflnYtiEPKp8+PLZxQ2j0Nu1cXQfRua/sU8HUydyU14wb/qA6tceneNz
         Sqqg==
X-Forwarded-Encrypted: i=1; AJvYcCUT0YQQq4I2Lgrz/R2b0K5ePczT0yO5dhY5FDCDuUTW81XzWOzw4s5V9NCXq7p8MnIvAVuArgNBakmF5lU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzwfsPt8CI03ly7a/UQ7BJIZgeMnrofuEMdkk83TPAQ0j7zb3g
	QW8nzP7UPjmsDU06l9OXiHqcu42Cao0Gzm7gOhicu+vXE+H79xfgDvRjEvSvzVGeyrmXijZpRAF
	jn9nDbZjXkxeoQ/qGcfZQ0wF5s3OXUzmv0t4+t8iRK+X6Xjq+D8l62bXzEGbWH3fVlUE=
X-Gm-Gg: ATEYQzxZSj+PnxHqVScQfqrtlAA0axw7niLTdECilu7tcGhn6r5tUoit1MymJXB1J26
	IACRDHkMlGj48iSQLkC9BEvu1xn/xtFUJFMzH2bdgc/h97V3QodO9ZuYeBT4f7VcAfYyzXW0fTM
	W87b8KK1P5qd9ceSIA/XAfTy5cyjAnsGkLUmHlPRyl2O1oxGwvFvndeay6IFBwRBJQiOzNGvVaJ
	3g0PGh8PUTMQxsXOaqtQ1DWRSgU759lOa3ILeDfWHpnv1LUIww0Uoc4DO+4OP75VRJAKjK6sgPO
	e2grs/8REQ1E0tKfvGCE9b/SePWB1H3LsLwzPPV+NmLPObtDoeQSoeNSTcJY5/r0cUrUQI0QEIA
	bdfNRJ9JQSCUbUlcVkncepc4UKq/82vJyZJnLgeZYHaHFgv/t4SlpfmKkkZHRwlXCIkJXQLGfam
	NJAfA=
X-Received: by 2002:a05:6214:6003:b0:89a:595c:b805 with SMTP id 6a1803df08f44-89a595cbf5emr30835516d6.6.1773151988457;
        Tue, 10 Mar 2026 07:13:08 -0700 (PDT)
X-Received: by 2002:a05:6214:6003:b0:89a:595c:b805 with SMTP id 6a1803df08f44-89a595cbf5emr30834966d6.6.1773151987983;
        Tue, 10 Mar 2026 07:13:07 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942f15d51fsm493523966b.53.2026.03.10.07.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:13:07 -0700 (PDT)
Message-ID: <91452d3f-fbbb-4960-b5e4-85efdc2c84e4@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:13:03 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/11] arm64: dts: qcom: sm8550: Add power-domain and
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
 <20260310-qcom_ice_power_and_clk_vote-v2-8-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-8-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: TNWiFJGeNND_9QeGsDmtHrmLPiyySj_X
X-Proofpoint-GUID: TNWiFJGeNND_9QeGsDmtHrmLPiyySj_X
X-Authority-Analysis: v=2.4 cv=YcmwJgRf c=1 sm=1 tr=0 ts=69b026f5 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=z_dnvKGLtVwtNw_c-ccA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyNCBTYWx0ZWRfX9lXPCUshhg/w
 mV+LxrGaTfIL92BtRryt5S4hhVeE3s7Ynm7aaE13REEFEh64TX9in++m1G4EeZAAyqvnNDKOlEW
 QKtCjQJ+z00srWs587U/wyNl6GLvEqM6WcpYShhL2pwpmmOyygD26X+Eo6zcR+hRg46zobUGEOh
 pW45Ltj+NeuRmLkE+Wl/UKrqfL0V/0hK+uidF+f/UrGfTS7JOE0hdIYzJ5+VVqVVmruKEkJXFxR
 cn3ZhJkJ/x/2k2qxOX4LBpSXYKTL0nhZEPvgYuRYJOYJ8Xcw1/Pv/TYhjwGy033MuBE6I31mwXB
 IV8OnwaaytoUVjhirqAIAsl+1oeG2kQYzjlemwXN790y6caww5gu2gJUYwLcPqJAAaakesg/BpK
 /dJEsvpyd8DOjUG9w8WFzm8eal9gTb+SggtBIyMxWC9i3sxmewRAQkYsUKjiPiam+W35XGk8A6q
 a6fxhgTYzIXFREgx3lg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100124

On 3/10/26 9:06 AM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8550.
> 
> Fixes: b8630c48b43fc ("arm64: dts: qcom: sm8550: Add the Inline Crypto Engine node")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
