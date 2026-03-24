Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B44823B62C
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 04:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774327712; cv=none; b=hPsEVS0UEHvj2mn0LJxLOheKJiG4G8W3KQke/Ax5iOvQzRDmzIGofJ7qH9QYLtCHO+Qo7+XUONPxydoOQ2lbBp8FUuqQtFMFUeaLhod56a2SgUbSRp/A5WR8ajHgC5jzGBKuIC4KZe2Jml4x88rp+J+gHT1n3KsWj1n4ZzPa9sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774327712; c=relaxed/simple;
	bh=MqY0rvVxZ8EWepxH1jMTKMbCOC3ejPwoTXI2X/mtWe0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EWchz18/hb9LsOqH+vabT+mkO0SptrY8I8tuSeblhKMcTP+rDat8bnyvoKlV8NxgyI5xAPlTrfzpDsksNaEekMM/Oj+JWTGNdhibXE4rhdwVmeIvw+6MBy9SiRrclpQcA/BeoOpM8W00Eq33SElnVL/iOXRMR1zMZDMmt51gU70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DfwQtmA2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gP9BbTMA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DfwQtmA2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gP9BbTMA"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O3WKBE3903725
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 04:48:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zeigFvaue2fOm1v1THIQ2tyCHptET7HZIXbAdvlVh1g=; b=DfwQtmA2Tol8kT0p
	AyfPrBdbO7Pg7VbmAULGksQZ6QurwM65gWFE7oNJkgDyzwKoiVeXJLGLiNMwYDw7
	P+eI/Aqs3BZsdC5v97cUxj0NqiYgBqoERnwM4UpjDhd36IIpBD6BAQwO1OLCq3DH
	NoHgCh2U125+kq8tAXfcqg9F7YZe4/j5TGinmJ2UwkcLCD+T/7qLd7PRlgEx0bLq
	wxQ1C0I25n2+pZSHBg80E34lf0IE+gDgHsQ+8YgC306yGx/3rsqRVP6Twt2cR8oJ
	ETh71+liKIfWTefm08atbUCwZZbb+bKwPe0lxI/zFjCGsd9xTxTdPKZEJbDrpD03
	6BAcQA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d3jt0g728-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 04:48:30 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35b9246248dso5112131a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 21:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774327710; x=1774932510; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zeigFvaue2fOm1v1THIQ2tyCHptET7HZIXbAdvlVh1g=;
        b=gP9BbTMAD7dLckdvq0sONZnQj+ztBgMGvVXDEf7ErmPyYFUMjMTxmI1AR3eb+Emk3w
         OBLvaFC8qpMh4DjKagzPDJaha9t+PrhUPv3hB1biya7Yfx8QHYnfAlv9Y2KAbDXldVbj
         DU1HO+kp6/M9IXl8wdD5DwIEs2rZkoazY0+1QfcdMg8cjMn3UmsJoBhA030SwQqpojQo
         a3C3Bora9w2SHI8g5nwMvkQ/B/cV7Z9XW3hodDR1nPvJphKRPA/T1JahMUEAItC8CiCf
         RExsCfprWyZOvP1QnOQ+wDN3vMqYtOEFWH5LlYb8+W54w8HosNR8oJVZmuKPkRgyHR12
         evpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774327710; x=1774932510;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zeigFvaue2fOm1v1THIQ2tyCHptET7HZIXbAdvlVh1g=;
        b=HkrqVNXCNP/QGp1IpZtVqNtoaXPsqhXxPRpjy7thZCIqqZxz8NeaXMLMVC4g9HV21e
         xhwSSKss01fdage8T6fMy9vYRDw1OtkAi863Rj3mp4fOpmPIDOpW7pYcQ+GmVhO5ZgGt
         xWWqsfeWiRdF6t3pnnx35VKZK/kynKKr96bRQ6akXyQLsTlgCM6CbX19+QI0pQUxz+Ig
         7lerb94NKbHAKDNHJ0+iMd9eReZ86nWOWCDJ5fnc64aHcTGtbIrW0PFekKla5wq3Kc2n
         y0bXwc+H/ZORtak4i6cbHJFnW8mhqhq4I1cK+GHQ0JiEttQ1q27APF2ZcJEoJigTt5N+
         YcyA==
X-Forwarded-Encrypted: i=1; AJvYcCWgGRSZvkuGJ3eI0zrq8Ym8T93I3dsVo1Zx3AuFrnujNVmotylAE82YpNT1Q2XjbgR7wb+KHLgCfbnaeSk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWq4IM5fFzNXBx0rS0WYWCQ3CZO308UFo8A8wEdoO4GRvu8Rlp
	KiH4J5jj9sTxWUgDFMhf7sFTPN0K4CbD9fsOV9IBlIJN6M0TOVwpLnE8dM90fHkWw1QN59kS7LL
	PemqnfNSMZ0oiTSyH1gY6tAsNZCr1ZKvF+oLOgQtTZDINJAx2ofUUU6WVJFOuyzhzJRU=
X-Gm-Gg: ATEYQzyVunkdkAXdmNV1a9EXZDeDh4bkjDYSx12Tm+5UwixlNXwuuovB8u80RRNtyX0
	nXgjMg5JdrpqWB3+2yUvWcyKsgC3308T2xmJML8PmUjsONDtHOtL178BQ+rBvgJT5/OoRCVK1Ly
	grlKhCpdGPRmbR9Lwbr3c7/+YrJzBQDiqZbLFEw7FNxhz6vrPQSQSohogjrYBkO9of7oOH+7m9h
	EfJ7Vq1sZZcnxFZgwisaXMp/vFZ3fIM/94aKtZIMTXX0T/TdfeeokX08+lxgPoaBMOMU3yVRvNM
	ZKiVwWuKz2ESvsMZGxvsFj51SS6R34LMSxyI23id82JKV1IGJ9QGwK0WON3RjPnqVOkGikvD50c
	GL58sj+L+mtwozSHTn43eoqoBtsIK1i5xVtCuvL+RU8JSuhb47B4R
X-Received: by 2002:a17:90b:5108:b0:35b:9cd5:232e with SMTP id 98e67ed59e1d1-35bd2ce4493mr13430868a91.29.1774327709480;
        Mon, 23 Mar 2026 21:48:29 -0700 (PDT)
X-Received: by 2002:a17:90b:5108:b0:35b:9cd5:232e with SMTP id 98e67ed59e1d1-35bd2ce4493mr13430834a91.29.1774327708987;
        Mon, 23 Mar 2026 21:48:28 -0700 (PDT)
Received: from [10.217.223.92] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c017477eesm386657a91.1.2026.03.23.21.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 21:48:28 -0700 (PDT)
Message-ID: <7d797c67-25b6-48c9-b98a-4545de86e45b@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 10:18:18 +0530
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
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
 <20260323-qcom_ice_power_and_clk_vote-v4-2-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-2-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: VOzl754QVp74fQV7sM1jeReSM08Jz950
X-Authority-Analysis: v=2.4 cv=Nc3rFmD4 c=1 sm=1 tr=0 ts=69c2179e cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=SBCaeXWvHhY2KLIX7PwA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: VOzl754QVp74fQV7sM1jeReSM08Jz950
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDAzNyBTYWx0ZWRfX7MdmS2aS6afg
 a4xd2S/9a7KThKfLrvMEcBi7r5PQZ7drPmaBY+zW6oKRgbp9bgDqieqmJk+HrUZNxAC9eGIPsdM
 vUS1SAXD3OITpeMeROyuq2BYVyr3KhcJeRpoTFfi7k2HCvRTHCsbltjD4Lq0FZxLDz0SAkpXRhm
 1ukqMQrMp7vwNNnJ/1pm+LH86wyqo/kvo2ziMZge7nRMnI/6u0TmceQviPmP5G90fUKah+lUogD
 x4H966qaPLJG9hChajDgnZW+E0TUThxfZOhqoACqfLPRBf5YA6fBf6bqNr0QS/zqFq8SvzxuwoK
 A2cCBh0lebysIE9Rm69qef8DYRNdTf3986hAZqAjFG4uT+39tz4WWnhZO2IXDHqnDuzcnG8+o3j
 q9ubw8AjaUcQHNoXP+t8y3zbbs1fcCdFT90gaPauKin79N98QqofwXDfQIK424SbbRyHayHPrzu
 rVirUlm6XRVTRrVpp8Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_01,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240037



On 3/23/2026 2:47 PM, Harshal Dev wrote:
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

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

