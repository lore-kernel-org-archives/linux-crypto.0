Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728A839C010
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 12:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774268870; cv=none; b=mbJaYDMu+wdPHHYZHGzd3QOmI7NsaHB+pRmVhjHvrMXPOBLuj2YX2Po6pO/RNZ8DxuCZZDr9hOc2o5tMAsygF9lmdH2RbiHpT9LG2Jl31TwNm5IPfDXo9kj28CBvz1OxN3okJ5d09waF0OJRWnBHFHedfYBgLkETHA16QxX77BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774268870; c=relaxed/simple;
	bh=WugqA9yyDrviBAh0oWni+13P4SXt1aezRSrY3nIa230=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k45zMQXepJCxNF6HnUE4FcCsySIGWN17EPFdrqlCEG8L3dEWLGQCnXjSNT9ffkK0unD4MWgCPvFhz5ekrA6x5vBDcR1gpUXHnY92oPOPUug7drKCI9KuXqit+B9Ks/G2IxQWyFB0MicyCWy5vWmKM9hVJxf/oGATsHGhJ1lS/x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oqyXUA+e; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gv4iBN1M; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oqyXUA+e";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gv4iBN1M"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N7tdwH1627218
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 12:27:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	n5X6SCCrZlhH0x7gW7E0uH0Hbsvi0PHB4OLS3xzpkYs=; b=oqyXUA+eQddQwFEZ
	F06Q3nB093RH9ixHXHtfqBcpobMOMhWInd0ug2SJgr2WdTffxYbLKocnlvPt+qqL
	mNu2Mm4Fkzk22fqpgQxZklSdL1KIJ5yk99mRutwwC0zHxilhEMM7jO+XQ6PRIO/W
	4zZWydokO2GgcM2AjTGfI9hOVlYzxIk/NPWO2RQGA4jUVzaKut61KI6MQmrJ4pdi
	pAC2bk9rTQpCczMvoFAYXnqEUljesYw0jROycVtyX8kV4cihuSs0ts0IdJFylRTz
	eVJaqDMkapL6y9mDf13idd+rK127kAPZ47i9IIFnjnQEqjbQr0heyMxYVKbc62sp
	/yRX1w==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d31jc0x8m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 12:27:48 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50b317c4041so27437371cf.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 05:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774268868; x=1774873668; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n5X6SCCrZlhH0x7gW7E0uH0Hbsvi0PHB4OLS3xzpkYs=;
        b=gv4iBN1MkLTbWsF2zkwndOfI3gUimIU2fcANH1tCWfk1hcrOUjMMSoceExlyfcdlAx
         myuDaW7W8jMdsqPwkTatvhQvE98njKjziUVlLRZ1G4utQTmLHfxv8M+rb9QhGB3SNy4f
         Cgex3CF2XX3rZsTM+1MIg1Ol9cwSZYp7ZJrkAlh1QLWndiTXJt28hGI0qfCl+BwP8/XI
         dky3zP/hjHTLiTaYBOvl6A6YXNNnTEPJbUVOWKJWzPcotPOrX58U2edQGQzBGw/QwlOq
         IWejv+ihZtzzeGxJaC3GMPeJwW4DC+v5LTG3LZiScJeS66sYQQz/dbJtlvHlX2+akVso
         xTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774268868; x=1774873668;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n5X6SCCrZlhH0x7gW7E0uH0Hbsvi0PHB4OLS3xzpkYs=;
        b=GJ9Ql/zLLlto9ONCziDvNB2ptHvtbZjXCHBgSzAmZaLCsySqN+g1+z6pLUUlvN4Izw
         epfZQvsBf2Cp2ht1c82lBPYTU0+LMNeuDcdn9b1vaW6db9/5ahCKB7rulDMrHDqveQVE
         Wg2hzofTsGrYC+K79/x9TRyXHXeUnPKmw8tfXoxmhB3lPucrMA9lPcZ+UyvJSdkJuF6u
         m6IOBcesNDJvI++7KMhNbhBl/U4skavbEUr7P/LlH0OWcXf2WWHnbiViD5DGUU/5MU3s
         0FvY9HtCUa+yvJdg0Z76ENudVFPu6ONb2HKRBirlJjKlnmXCJoSqv0NuIg9EEgFNmT7Y
         w6lw==
X-Forwarded-Encrypted: i=1; AJvYcCUT6dswtNv1cgO+mzqWF5lYECGGm2tUhUEcPmZC9Hf4aftOHkv3etE11mYsKjGTvt+TovySkBkU8VeJua8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHlDXB5m6Uc+MWdzp6H9nTciOxwJtMCFOeXIx7+LSalxvS4Nr+
	wUoFTV/oAhpnMbczd94Z6LPiSZ52pCOdahI2scSjFGqq4/+CYyVFNCS50Qj/+YW85kaTRFeE+Ll
	V7VB3bgkBAe/um6tt/HXCyQWFz46c0DfnfviRsO7SIV5Mz6TGuprl+EsQZl1aRB+8tms=
X-Gm-Gg: ATEYQzyE3xVWl/8eI81CGfQ8xnvMJ24TtuyWdsYGMPVpmQ9uzilOccFrkGA/mtY+bZ3
	IXxIRDGPoQ6h4PPi7fHDN6II0Setf4z0l6S+8qPMT0N+UuIQJukIJ6fV1Fw5TTyUy7wxsKBCMam
	qZ11A9VGXjojw1AN4YJrAfSwlbU+sd2P476BfBaIYFnqCOWJPHQ3jlBupH05lnIqHnKR3GQoGGY
	vFZP3enpO7otToNjCbuhh1fLdgRmTx2G4wJjqEeVWtd8gEHF60Lv/yNe4arB9+d5ZQOsn2BPXw8
	gREakJSwcUY+U9aOHZrKybiSM+BTA8DNSZXi4LxHvDlix1TBj9wTZK00TAM5b5oFAxo1ud+HfLp
	HbFp89o28+SA9o+kDb27i03AugXB20CPnWKdd84Yac4YMBLXWX9FOJyYhy/DsMKSVXJ2g4ESIfW
	Bg1/4=
X-Received: by 2002:a05:622a:1992:b0:509:d76:fe73 with SMTP id d75a77b69052e-50b373d748amr144814951cf.3.1774268867888;
        Mon, 23 Mar 2026 05:27:47 -0700 (PDT)
X-Received: by 2002:a05:622a:1992:b0:509:d76:fe73 with SMTP id d75a77b69052e-50b373d748amr144814541cf.3.1774268867450;
        Mon, 23 Mar 2026 05:27:47 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b983398c16esm487370966b.61.2026.03.23.05.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 05:27:46 -0700 (PDT)
Message-ID: <632d2e2d-82c1-4e4f-b477-96c5e75767bd@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 13:27:41 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/11] soc: qcom: ice: Allow explicit votes on 'iface'
 clock for ICE
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
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
 <20260323-qcom_ice_power_and_clk_vote-v4-2-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-2-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=fKc0HJae c=1 sm=1 tr=0 ts=69c131c4 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=SBCaeXWvHhY2KLIX7PwA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: 0JGdWPWtagJhcveLe83P7lOjJMDDeWBz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA5NiBTYWx0ZWRfX+za7hq2O/W1X
 wd11VusW39x6RVRbDaLc7pkRNCjGZFQFRSdswb6IZ8dG56RjN1+Un+D1eq3xaFW5Y/lot9EJZ7N
 6FbWoa22hyzm0ypk/u2v31rJCMBGBMt/mpM6EJ7623+tu2/PYMhT0FpHVgwASwTxn0cZaMWw/NN
 b9NNSdAZq7/8izC21qv/yvctD42LKsxGxkrlNn5Z0Rmg8EOq02B9of8+uT0LFou2fLEO1alnR/h
 5gG6ZEEmcngv/XB2MfJ3uFIhGMFy8/qbkXPYjl3MS0ZbmhEqI4ygev7pPBLk1/5dlH2FruYxNcS
 aIroY/y5dVGKDV1V+S+ix+SA4QACTxqw0uCGKEhtGVpQniwu7wwAnrD5rJRzYUSUnGpcsZ0WDaq
 gXT4hCxZT9XEcN2vpOVHccwZgnkwThYeiZ2KEe/adHVwvSngBnzwCcW1631vuCmQGcmbAvM5q4N
 QlYvH7IiuK0WgbDleNQ==
X-Proofpoint-ORIG-GUID: 0JGdWPWtagJhcveLe83P7lOjJMDDeWBz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_03,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603230096

On 3/23/26 10:17 AM, Harshal Dev wrote:
> Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
> de-coupled from the QCOM UFS driver, it explicitly votes for its required
> clocks during probe. For scenarios where the 'clk_ignore_unused' flag is
> not passed on the kernel command line, to avoid potential unclocked ICE
> hardware register access during probe the ICE driver should additionally
> vote on the 'iface' clock.
> Also update the suspend and resume callbacks to handle un-voting and voting
> on the 'iface' clock.
> 
> Fixes: 2afbf43a4aec6 ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

[...]


> +	if (!engine->core_clk)
> +		engine->core_clk = devm_clk_get_optional_enabled(dev, "core");

This change is a little sneaky given the commit message but I don't mind

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
