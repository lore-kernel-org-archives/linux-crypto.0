Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005603EBF17
	for <linux-crypto@vger.kernel.org>; Sat, 21 Feb 2026 11:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771674329; cv=none; b=RHNl4B7cfI1SeRnFeQbIQWp8zt6wO/6lTxFhCp3RsVidwS8i/jKL0WCORDTOFrnDhHZSWycMYHkBjKdiBO3DtQvJtpsl94W+jQ5goTYua83LMzsz5CmAfpoFerwwHBX/ycQRw4wcwEHDnJ3dRqutoql4QI/5W0ZZcd1ZQO9pW2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771674329; c=relaxed/simple;
	bh=hkR+aDWnEbijQXJmIbBhHdhpGenvUEZEBRga5xZQ8Js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTABzBi/nW1/w+hjTgyal9JhrcIg0W3V2TKZST+6fyLb827qpkjCtURnQHIvvPbOZ6w7tmDexTNiE3Z21CrQwzIs6NxDH4Yr0+EL0hSsRR1umVinyDb2yWtf0QRecuIVCJFV5AJQgmI6jKSgzNqAREc/yjmLP8eo+XrkoGswxW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OnN5FkzU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Lq9KGpGg; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OnN5FkzU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Lq9KGpGg"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61L8P2A82712414
	for <linux-crypto@vger.kernel.org>; Sat, 21 Feb 2026 11:45:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=hkR+aDWnEbijQXJmIbBhHdhp
	GenvUEZEBRga5xZQ8Js=; b=OnN5FkzUm9Li/y1eJO3JYfDS9QgA/QDILBDkSqTr
	440rwUJz2COhXgvower0/6s2NdDF3ix0tIxOo+NzkQF4fircDjMfwQ55jkJbH2yG
	I14qoyof95RToiOVzXkwHdeyWioznSHBuyLzMAlAqJIb4l6E9TTjvoVhv2VW3IEb
	DbrrpArkW/E7SdbPtFDnYUYEgU5Y3XqbtMPJOu3WpbWjrCnLXce5hp+CxrVbj0+T
	FbLg8MtRxRdbRyPQqaucBxnNeI9u4heAgUNj7VdxnYA9Cc4T3P48JrOOdfupizYV
	2cBYmkpJaBXsKcU9Tc2yTn/Rx+w59qla3qCb71C7n5i2hw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cf5vj0mq3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 21 Feb 2026 11:45:26 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cb4e37a796so2183824285a.2
        for <linux-crypto@vger.kernel.org>; Sat, 21 Feb 2026 03:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771674326; x=1772279126; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hkR+aDWnEbijQXJmIbBhHdhpGenvUEZEBRga5xZQ8Js=;
        b=Lq9KGpGgl/7wm2x29VCwYLYAq3e2lstg0tNvS6/BHrP2gF/98WcpnnXnGl6FKr4DPs
         Tmiu6N2QwzVjt+gzgy+JkfovdWP5MvLpq4XhcyfLMvnoDePzY8rcfo8//5Cf1a3ltX3T
         hoKy02al84HUf7NYBDhnHBk1RtvaYyCPONmzxJyDSr1bw8zgRgX9eCUUpq9p0RaxkgCM
         1LpK7eoK9DEiWVjLuI3iZ05q27kX6HqgZgUSrHH2O7DarR6SELBZgUEeUYyiKVAyQEsw
         NU8FacqjjEiGGWWEp+8ijci8dggG1IGhc89091J/yDe269RKfVyFqoUK9ISNxjxQ9wHb
         t3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771674326; x=1772279126;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hkR+aDWnEbijQXJmIbBhHdhpGenvUEZEBRga5xZQ8Js=;
        b=YzN2g1UIWG6VjoHxcuBOtojWAF2uzsK7QtwkJNOOTHj/H/ldfjpuvBONEbP7Radp87
         gu2khb/zjwv4pP6BnmBN/P55OcsAg9q5mJUMt1BrLHZtb7Fgdt5xlvXpZcy7DMYkpuE7
         CytdVREj2aUWUgsTuCkdjDs5fItssu8r30qFMTw86brmk/l4yuqb4Zl0aLQHSsButRq7
         qShbE1U5tk985WGOIeJ859yWVWwEzz1Wz9PkB+9ziSJM/48Vo+X0uL4AqkZGFTxgdQf2
         5V+SQa45vSVDxlLrTJV49kEyuKcB26uLLnBVMJ847CL0a3pxfx+TdPIFQ/4AJklgDKAj
         +JLw==
X-Forwarded-Encrypted: i=1; AJvYcCWSayitkL5sNn0MyRg7+i+WB17/+Gzph6FzIPN6GWBPgDZagfR15c6tpFTNDyg4ai4ulYxX42xj4JzY58c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoSVXH4glM2cBOLNXcOAR2tC2P9PH2sdqWCgOhzBIkQT/YeeLL
	9IVSpmw15mYqEhlshtkJAUUIDFdWHtLcdD5CwwordSqMLA7tP6lCmighuba8EEMuLhyCccLbfZw
	90WhGEwjDdnRr+VY50tmliFFrRd1145SNLaA+51kpXGbDmqCqH/sX1/LxjD7H41NQNsU=
X-Gm-Gg: AZuq6aLJ0543HcJBPe55RelnVboMvhuuZTPdNcgNvK/wX+Wp3QOzk4Y/r0yYXMpZJ9h
	Pqqe4z6vo1gcbovKYfnB0Lc6TPxuy7FEf/OzOtZLTwWNEVfy6u08s3pvCrZ7rmjj1RyISJOVWoK
	fgoX6bjNxFCpW5DJUpxr7pV7mrSDVq4vtrO+rV9L0wi35KhHWaD+ktTtmPbfBDVw2PJBGC6TgmJ
	RH2Qcu72y4zlyx6/jf/DK5+/6IJo+0Up72Hd82Yk8QkH+243qjaZIzyG9xmVNqGEfInbmG70TPk
	yslw44EoDN5ig5ISnTgpBudoLHR9k541hyw7uAfz/RQixqQ6ZOGJTfZml91jUrhoCO1mf15P4RZ
	ZfdN2DwQ7cuvkb+fpqJpfNJPNDcWSu/6YdXVo
X-Received: by 2002:a05:620a:1a9e:b0:8c6:ed6b:5865 with SMTP id af79cd13be357-8cb8c9474f6mr339770485a.0.1771674326089;
        Sat, 21 Feb 2026 03:45:26 -0800 (PST)
X-Received: by 2002:a05:620a:1a9e:b0:8c6:ed6b:5865 with SMTP id af79cd13be357-8cb8c9474f6mr339767285a.0.1771674325482;
        Sat, 21 Feb 2026 03:45:25 -0800 (PST)
Received: from oss.qualcomm.com ([86.121.162.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d3ff27sm5370545f8f.22.2026.02.21.03.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 03:45:24 -0800 (PST)
Date: Sat, 21 Feb 2026 13:45:23 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        cros-qcom-dts-watchers@chromium.org, Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] soc: qcom: ice: Add explicit power-domain and
 clock voting calls for ICE
Message-ID: <ayk53t4tjes6gq2m32e73tll5umb3fvot4keqxnfi275xeglvq@cis7h2n6j5jy>
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
 <20260123-qcom_ice_power_and_clk_vote-v1-11-e9059776f85c@qti.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-qcom_ice_power_and_clk_vote-v1-11-e9059776f85c@qti.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIxMDEwMyBTYWx0ZWRfX6F65XlHj821p
 QFH33RRGTKCeuHMRsuWAul7GEvX6d+uFdbLMEmJoAQrHr5aM1Pl+hQTS9ES/7SIUcNU0Mnt1L+2
 cSMpKtmpwuylKEOh1AeovnQPrAqYLgCt8OCDCr9MECQHe5cGEcv6+gY6kDN22YcwXqc0g6JXC8K
 kRyrbsvmNXu8GtXKZXNluGHoo+UMvr88IZiuX11nPvXP8F3ec5vvyMQFGU2cUFr4qhap+VDTg+f
 7T6HxSSdj7WCbY4PSl9bm560T5hDiYq8EvSQ8Fzo2syvG+Iz70sH7N5TBZyq1ViJ99yZuVlWFwx
 JzvkYX7OEGuBMC+YArZUveElZTxrkTmEqetbMId5sPtynPW7XlmUConqcm1mk6iqATBUoUdIzfk
 JzhagZwArtEldYW5Yc5TyISuqIx5Xt1vyFtRzEzw8bt9nRD6p2WTrhCMWFp3XtzP/BWib6RrbvT
 EtgJsY/Z2zwsQTqKelQ==
X-Authority-Analysis: v=2.4 cv=T5KBjvKQ c=1 sm=1 tr=0 ts=69999ad6 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=oauzzCmhM186DRC0Y2yWPg==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=SBCaeXWvHhY2KLIX7PwA:9 a=CjuIK1q_8ugA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: QSk-P2xiREtIPi8x3AoLjAsTm9wS2Iar
X-Proofpoint-ORIG-GUID: QSk-P2xiREtIPi8x3AoLjAsTm9wS2Iar
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-21_03,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 phishscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602210103

On 26-01-23 12:41:35, Harshal Dev wrote:
> Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
> de-coupled from the QCOM UFS driver, it should explicitly vote for it's
> needed resources during probe, specifically the UFS_PHY_GDSC power-domain
> and the 'core' and 'iface' clocks.
> Also updated the suspend and resume callbacks to handle votes on these
> resources.

Your intention here is to fix the patch that introduced the ICE driver,
so I suggest you add Fixes tag. Same for all other patches.
They will have to be backported all the way.
