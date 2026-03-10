Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED3838B123
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773151983; cv=none; b=UeFq4mwTfRbb3xYqonFX6taGS0eL+qtXjhhUGd4jPL2aqrALhEPwvMDR2FvFTi9Xz2hdJIoO7VbGqMZvTHd4kaezL7eCrEhXGJogwC+K7ZsCSNnk/XWIiHDu+LyN1HKoAja2up1iJyc7Z9c4yE0pegpphR0KlkEaRPB+L491hOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773151983; c=relaxed/simple;
	bh=5e1avswzIdmR90jxg3X+B+Ty4A5EkdVEGxOjLBbWb40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ftoak/q0nNlyh9KgdBe2lFWCWopA+NyXSBG+mlB0WzZIYzNn3Yco1/gyxf0J0KZfvhbvjQcnlrvx4bNVFuP2ssVEmrv2iK4PtvGMRd9JQiSa+s8A4GNTMbkAhdw4lqfPlslzKdWD3lxA8bgD/Yv4yJ7X5LeLCPan/+o6RIeAKYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pgmMYoQk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QzuzUdtv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pgmMYoQk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QzuzUdtv"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACacUo789617
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	viDjOwaw/yqQllLUim5qk+i23DOu8Ji1UjzfbpgTqK8=; b=pgmMYoQkeEk61lUi
	8/A6DcPji19sWHbMBixbgYn9jvuX5P5DEjbgVf0om2omBa4g4kjpQ9kMq+G1zC1v
	4EZyjHFDTO5Xnn68sEYljYOeDfB28gjxTIDuSOa46fhB5zZhe/oyZbGZnz0oHx9y
	QRK359kQHLf+rJwaw4Gic2/bXvCaTASNEH2WbTHkKtTByZuT3sH1F+Wb7nsWo2Mg
	YgBAxQ0ZwvoFYjxL+Hjsn/RjhFE9AzCTxLpQXT9HQvVuhS79X8Ux+d6RNgtAuLjW
	vwyxYXVUW9GHjC2A/1V519Nk+xD/2/eBYhieHmdEZL8sE5A397u0LWyU/uiWZl2n
	B14BaA==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct1ekv775-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:01 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8954b9b5da7so5458126d6.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773151981; x=1773756781; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=viDjOwaw/yqQllLUim5qk+i23DOu8Ji1UjzfbpgTqK8=;
        b=QzuzUdtv5sp5QcF9fGsTLespGvWfkCt0KbPV9+ZbmpX5CZ5Qq4k1xFD/B7i9XXI2d0
         F04z2LdzOWt5HGyLpyN2O+o2esKOsfrId5gA0K7qk7eS2LKhr60qgm93YTQesfJAJw/Y
         tOH5Bcbky/DCWgyQPKSDvKXh/IZpHh6CrTRTgjKcC2RH1WK2433N55BKQUwar+Ed7RFs
         06I7kwCLW08yi4lvjXEr+DBhYwPRAiegV2whj+YjHf3qGddh38t3qJ8o65TH7PiwIRiM
         3ty6D7IQIBmwD/2IQRgUAeYy+NHsJgwz5Hv3i22OegUryI/JXo3MhZva45P/qgljso6J
         WgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151981; x=1773756781;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=viDjOwaw/yqQllLUim5qk+i23DOu8Ji1UjzfbpgTqK8=;
        b=tPwj/6Iem5PqZJ+GY178MqIC6FE93teDqWAsrElQznayN6DZgzA82I8jofHBtAk+rg
         Iz60nXTOL2af5r9SeTr9CIlSqk+4lr19GSt530J5UUO6Zq5QOmGqtyb2wxBL/AdasdAo
         YHZR4jXZyv79XpBo41/jBfm8XHEW4pHRbKPdTmE9dMZdSYaJ1lTQkmI4GUZejP3VgSNS
         LpR3GsT+yTk7XRBEfbasv6S33dOZobnbo3gI3LOEDYNNBd1HCuHQLx1yTp3t0bz7mbKI
         nTTKD7VkSSYtU8NO7+1mINqDYV1Sksk9hL6AYztB05pCmszFDZTX8gfsmN4s9s3jFRxi
         p23g==
X-Forwarded-Encrypted: i=1; AJvYcCWhx8qhTdq0HznFbIkgs8n4+Uv6L/341BQftZw/01VD/DESwd5rP/RJ2o/Oz/QipLGNUESiMIf1wvV3qhs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3YhI6Kq3YnX5jyqaHtvars0Vmh/jXLH+x8SHdVZq7hxZRiuTv
	pNdWYhbeoOtnieHald+BGP6KBfHbqt3ihR9xcn4GcaoSI5MZpnvGZKk+PgBvnozkjTsRJjYKAAQ
	fpjJeZHO1dnbNrk4NgN9ZtFmfsC1VGd3JM2lWo/PRSh4Nf1+l9WBSxh0gFBwfzK22/A8=
X-Gm-Gg: ATEYQzyIUV6a9gIutpu6xxR+ijamAD/WNEIIy4FbpP3WA7UbqV5fmldyeHe6fcnWZSj
	8uwmtRnuztO2WMWvFxrEV5xs1mko/tERBUSv3w5zm2OKmVBJSOcUK4A0k072ohKPKZl9FGYgk4p
	rmcE+rksKDXNEfVSWSytMKaF29SgwjIcwPtw3PnjK5abtfasW2FSdYCu30ZSnAZno33PSLrWU6U
	LciE+zy+TqYK5mNcU4UNcmTTdLJpfGRM9loXDi9j6tRqxt0gjvqNSoVyd4QUCnpMItkr7psUtoQ
	C2sqxwpIUrJkF5e7FiLH0koknWfjIRgn+rUDcbkU9Iz7tdGoj0VjrQ9FX4CtxvYZGIey2uoiP35
	RaXHQp/lX5e34SBIGggzGbjP7+ZKMSjF4EeJW+Rcbm05c3EFRRM1wH0Ny1iyuBeoTgZRqjthVw8
	incA4=
X-Received: by 2002:a05:620a:4087:b0:8cd:7fc0:ee15 with SMTP id af79cd13be357-8cd7fc0f6dbmr1089000285a.5.1773151980747;
        Tue, 10 Mar 2026 07:13:00 -0700 (PDT)
X-Received: by 2002:a05:620a:4087:b0:8cd:7fc0:ee15 with SMTP id af79cd13be357-8cd7fc0f6dbmr1088995085a.5.1773151980118;
        Tue, 10 Mar 2026 07:13:00 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-661a3c66d3fsm4317323a12.2.2026.03.10.07.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:12:59 -0700 (PDT)
Message-ID: <33b27a0e-d369-4311-8372-82da4c331256@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:12:56 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/11] arm64: dts: qcom: sm8450: Add power-domain and
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
 <20260310-qcom_ice_power_and_clk_vote-v2-7-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-7-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: SU0xrm7gvEvBpua5pHRfwlr1Mfuoe-La
X-Proofpoint-ORIG-GUID: SU0xrm7gvEvBpua5pHRfwlr1Mfuoe-La
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyNCBTYWx0ZWRfX6xxiSd2khuLE
 UpT2upH/gWhYzpnhl9L5plTV0x6S9Rw3rc7aOJkscLKm3kp7Vqr7gUWusyl/6ORukwD/+zNyQoL
 32mRQdVsMe9K6kLHYKvOyX+bd4aMrUsB8UPfF2e/3ELsfj6xRKNjB/W7Q4NDQdW1t5eQ/UgvJY7
 XiQeIa0ql94/LTVgjNRNkYRfLmr8CiPQ50+O8aIl7bN7GMXY3wfV/Aw3VdagyBy/5g1j2iCDdVI
 XNVnhlEkxPvrRXbym4cqfuYq0Tu5VpH5G/JOgasj6wkPb0UFFdrexnBvmWiNZgU7qSRGg7LAXqC
 xL3yLfM442sF7epixdxkNgW11UPTIa+l2nYS9UcG5j9nWosAI2MJ/I1ZNj0DImkNhkl0kKicYJB
 0K1BUdiS7wHbHPmffs6938D9+AqKNG7PS9tbFvaL2Twmc77K2000TZvMxnK6yAndvcdQVHFg8HW
 paQZ57stjh7yzkEVapQ==
X-Authority-Analysis: v=2.4 cv=eIEeTXp1 c=1 sm=1 tr=0 ts=69b026ed cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=z_dnvKGLtVwtNw_c-ccA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=1HOtulTD9v-eNWfpl4qZ:22
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
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8450.
> 
> Fixes: 86b0aef435851 ("arm64: dts: qcom: sm8450: Use standalone ICE node for UFS")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
