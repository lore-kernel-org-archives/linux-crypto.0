Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2C02C0299
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774348762; cv=none; b=VAd+B/a24ExttXGETOu92WI8QNRzqhyfi7TkRHooUXm5A7xEH/4S9SHWQmPI9Uly1+z3Gx2LuDLoZTFDEMiI5xGfTD4ciajoi8TwAQAtlKxcgrZV67kGdEzXHKGQVJY/fpzu4z/Ujlg7Bet6WJUZUwUqON5KnhtEUe/xjGia+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774348762; c=relaxed/simple;
	bh=aixy/4nOGtVTADyTkPYzo4GgfdqV1G72q2wVa/sm6ZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oyU8pcCzCHtGrnZXbEgdKloFFRMCeMtiFxxXxnOc3FX+XJndYoPdVM5ZI148cP5XbpIlTO804XF0wkTUmrdOrd+ulh6+wSj7xAYv3KoY1OOpWYlFOSMjKswwo8HJtPQ+coYkmWdcp8U/FXtnWKs+5OygA62e7T+K0+E5HNwY3EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ncx6ADOr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XLpkGrBL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ncx6ADOr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XLpkGrBL"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O9wRaK3039639
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:39:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Uj5qYX8FhfQc2+1CHGK1yl39nh7ddqgU8t5AUa3/6Rc=; b=ncx6ADOr+KwUM7yI
	769Cw/e6gqp0AtD4FjBfrfcy+ogQg3dmuA+2FfDTeL2P1L5F5W5jzU2WP+nxHeTS
	GxzENAL/7mtjsP7lUfry9BGJ7qERXd9o2+1EsB4yPDTwoMjwE+CxHMcHbdbwv09S
	2LpHS91tNZiXYVY/ZtG3vipFit7aH+aOXb4eAUxeRPlORcoHS5nhTsKCtY2nTnae
	Ask54iUCBYGs3Z5Mkcnrj8j7oNlcrWmtqb5iwjDFy2AQlHgcoCYcdPiGlcYwcW/+
	4s3R+Wf9jQFeIWOP0PlijQtSz/MZUdUokCIsE0W2EptAZIzcjkuIUdZFY53e3uUf
	njloWA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d3rf0g50j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:39:17 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aebfa0af7dso103030685ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 03:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774348757; x=1774953557; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uj5qYX8FhfQc2+1CHGK1yl39nh7ddqgU8t5AUa3/6Rc=;
        b=XLpkGrBLfN52GP0hjTk/mMOAZEF+996DGKKu9ormubxK/fClLPoRvhguymZVvJfItc
         zFmSwRQyoAioglPjvImS69ERvwx7ei/4VeP7hcgxoxv6U5IaDDKSm48/8CphrsrPjSdP
         UUKwIDRmfEOrbE9ijfEv7mMAdogWw7lpu6cuMZ8zs+d2pLWi9yYLHohu6I1PvlEDJr9/
         1MSR0R5WXRO3YtKkcwwTrdFGES+sdgjG7IwG8SXaUXBetKbW6Czoqr5hkpJEL1lvYekb
         oOypvYwqQmAf5BnUZEUS0OBEJanrvhOfGMCiPTaRG6WPi2cPRH1GBwZBRs2+EJlHvKJz
         jNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774348757; x=1774953557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uj5qYX8FhfQc2+1CHGK1yl39nh7ddqgU8t5AUa3/6Rc=;
        b=UC5FikGd4Pyzw+29E1PLLIHeYF0e7V7M2tKMHLjiSI9WWCVSluoU2dWm6oE58rZzI0
         yaJENEIG/dhAm1A8sYjX+KY3MaBuJ/1bkOiplNn38YO6wZWz4zn2BQj06vslUOg+w8m8
         6wWBIodp00F4jxaYzj1OfzSFK34PC8gP35kGy8/xU7M7kU+q66sPoejLLGyeYzWMzvPM
         j5wNNTvpv6rgiKlSIB2xM9C6bWxMRhljy/aBDs8m4YrTySAq9pCpRI05Q8jolSKBjNqG
         NK2Ai0ElnXkDKaKoKBYk0f2YIG/jlgY21eNvbGjF5sa7B4fhFUa7FnNreLNSUvIA73zX
         vJpw==
X-Forwarded-Encrypted: i=1; AJvYcCW9QEnoDYkSko7Trjge3u2zOQd+sqrPDlLHkUZ1eq/5ajhrY/ouSextKRGHF0rOyRY6H/tHjGSpjXhqpLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YznjftN4mc1EuYfvZhkwrUHkLBH4pkCbECdHFsFxLK2NZlxEWc1
	+XnBj49PARvlecLtClmj/S3aHE8JQv9ePb9CORHkx9a8CaBvOFkAkAfEeaiiWtgbD+NEamM641E
	mY6cTxoitSzwH4cM6RUz0zY1V9e6z4Ri3lHf4iQv0ROipJeERSySiVtblH/aLVcaSrZU=
X-Gm-Gg: ATEYQzx567Rrvd3sHIISbxH0WSJt6zMeD/G6SGdRyr5N9I2Ol2L7Wj5+7nmQ5kECvEc
	BTkYdQ4lLby2G87jmCX+Dc9Sl+/7W2JaB/175KDOCBiizjMOY4dXTlrYtwlRgUKYMqayEHaL/XZ
	PQDfVj5lfGbPjpWhvyBF68j6RaIlsXHLW50bY33l3VQv6rtNY0HAH4J87kyrPLw2fqbQ9sD20YZ
	Xpy5rvcJmsLxpiBmEC5GvCioUFXgsS43inXENKwSR1/WOx7aQUZXSs/vZO09bmBFlXtGAHlUm//
	hbm37VVIuiaNUksDxmFeoCfJHlMjRABL0ky+W/1CT8VDfIX1Zk1KyaA2VUcOEGLnUvbZoX1ap88
	fDUcFOX9Em/coiu66IQyyE1g3aCU0x8hkx7uFUhOa70ZevWgfOYR+
X-Received: by 2002:a17:903:41ce:b0:2ae:508e:5019 with SMTP id d9443c01a7336-2b08271fb32mr146163415ad.20.1774348756689;
        Tue, 24 Mar 2026 03:39:16 -0700 (PDT)
X-Received: by 2002:a17:903:41ce:b0:2ae:508e:5019 with SMTP id d9443c01a7336-2b08271fb32mr146163185ad.20.1774348756210;
        Tue, 24 Mar 2026 03:39:16 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083527f90sm137972405ad.19.2026.03.24.03.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 03:39:15 -0700 (PDT)
Message-ID: <00a59d9b-cda7-406d-a53f-33ccf1ee4817@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 16:09:06 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/11] arm64: dts: qcom: sm8550: Add power-domain and
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
 <20260323-qcom_ice_power_and_clk_vote-v4-9-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-9-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NCBTYWx0ZWRfX3UQE1ExtGvvs
 sMYS52hzN/Ng9VYFVqOcn2pwDjCCKMRTbKTl7ascmdUVjvmecWlxR4eL/cyNL7YbocSdelLW2sp
 0r+RyRI/JLJ7JygBt6KedWcejRfuPDLbG6vfzo/i2bAGROdafw/vfsxYaeQymvJ5EhpaUnS92/l
 Vs5IA+0Ddxz88qdFYGNU47iZaNp15AbXyi5MxdCa8S8EcNUy+RggZrGpJr4I6gJfY98hyo+5s0S
 8uZKeHRlThj/RZ2aKFwwoNtv3oVYJsWmUr6V7Te2vQcUulGBMglQI2xDnU7rv8ph9mStmd+bVZD
 xeqXlVhh0ateMNT/GTTucfYdiIkKyPgf1k+kxk2ZcbuGnOE+6lIx0u9p4I16DFozAsawg19MvHX
 ZwpnNHbMfJMB/fKmQ9EKYWrenO/NMOewYalDSos2BUO5ZrUYmJkpXZW2XuLA6YtarZWZYqq53s4
 cocakfloj+DaQ0zAXCA==
X-Authority-Analysis: v=2.4 cv=Ua9ciaSN c=1 sm=1 tr=0 ts=69c269d5 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=RcdfdvLsBkETvr5PKcUA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: i2g94CFdIoDgDBRc1WuHD6BUiZ_N5AeD
X-Proofpoint-GUID: i2g94CFdIoDgDBRc1WuHD6BUiZ_N5AeD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240084



On 3/23/2026 2:48 PM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8550.
> 
> Fixes: b8630c48b43fc ("arm64: dts: qcom: sm8550: Add the Inline Crypto Engine node")
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

