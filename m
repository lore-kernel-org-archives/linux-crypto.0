Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E1E3D8131
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 13:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777899796; cv=none; b=naPlzR6wTNjPol+44BUhKpBhCX6sh+aWWzaXb1QhbzA1NngO/32T/VKLfYvFsYEVye5VFnNN0I/sHJkUH0Mg8uMw2wfWMzs/ZZTchGwcJxxcHA1/QTMBI3bJWzbUVeeBad8DXq1gX+TaJEuK0VCaESFquL5+n7nNGXDvyZVAuRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777899796; c=relaxed/simple;
	bh=wLV3QMhBysu5BU6gl2h7dYWY9fYB7rlEsLU9wG+Tm6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NHZVBngB4/E13v56wTpiEs715dikhc05NV5ZOGA2MCgitDSrrGL5ajvVT7X7hgsDPZ27Zx/G4v22sKrx50LIDKKuYvN1KoDleeHxGUrNH2iw3qRuWSXkkXQXTWEanGJIo0axcKdxnpb1cC1imScwsxN3C3f9wTBsQtppCSLLWN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UHl7vNZq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iU5uAcBL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UHl7vNZq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iU5uAcBL"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 644B42UZ2850117
	for <linux-crypto@vger.kernel.org>; Mon, 4 May 2026 13:03:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JEtCjXtga1JNt5qAIhY+RK9mEt1ejX7uidveVx9G9oI=; b=UHl7vNZqNP4lWzHT
	KGN47JRjFHhBNY4Yv4YRZAQNRgVVfujinGXupfaJzbiCkg5YG9iv9kSJ6qmaR7/8
	1HkmeZR9tGTRMNpzZTV3aG2nZtlrLLjmFfvfhdpPTBaXFazBbj0k7PE3ToeaFio4
	7fnf1VllbhqXWF+958Z3VaMDG6ad318rq66Zmn8fvkF55kMGkb1zEzvWNZHUvgGo
	wMF5/6qNLI/vvqtzPYMTSjQfvF/RLflh6+ROf8xT2pcSpZgKo/fO+wyXJjhl+qjK
	ReG4oJKI4GizmBN6eoGV/4q4V8rKv9/HmqqN4Bt+oortOBn4qaGkuYkYhx9pezw/
	9EQsQA==
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dwxk1bj0g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 13:03:13 +0000 (GMT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-479f0ff8f6bso549155b6e.0
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 06:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777899793; x=1778504593; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JEtCjXtga1JNt5qAIhY+RK9mEt1ejX7uidveVx9G9oI=;
        b=iU5uAcBLqjENyO1XyKkSZ/1tghwhs60hI+M7xdNhAwuNTaSocG0514uitdxcf6w8+W
         IPcJ/ilmXWt4AxuSWBT9uUg/1Uf1CaiQAfpr7L1vwZkD6c4uieO4cTWhAwXY8LXLadDL
         C2HOtSvaqQDTa6WVkwLNCgfzn4FLaV4G/+T87s6Zpgd6M4E2Fi9GvQ0N3uE9QHpA3z+T
         WDCECNhV1U/iEyS1y/6DQs4Z5U8wSf1VMp9+A4FD4X3ibBjWxth4H5iEW3tgOat+hxq3
         cDiVqfm8PBK9l/XRXa4vjQudW7Oc0sQDa0hiBggbRHg42s/2jx41WHO4yE1ayJLEImJ4
         zbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777899793; x=1778504593;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JEtCjXtga1JNt5qAIhY+RK9mEt1ejX7uidveVx9G9oI=;
        b=dU2XZq6Lyg8X3/ogwOBwCsa38UCj54ZiMB/K03ALHQXKZ7jwbktVYX/xtTAvQjUT4W
         PrQcndThDmv+S93Dozyf5WFIoILFzF94y7tpevamwpFH4CxBrZ+/oMCEc8uhh6bw+LTd
         Y4nyoqi8sAzE+dIRjsZ90gki/CH0LVo+YhpVERBUFf9qMyWVvIlgl2LJGCx0CKK6GUkd
         +gvaxGaaYwojO7Iw9EVgrySL9zrTtgulC5etmo2TEqf1em4D3+aJR4Rs6Z4C/EOiK9vn
         LOez94KQ6kDQW9l/Ef2RghXzQ4vYgpuF6YYV+85l9ZPL9BaOFkmPn0PnTvZFY6DOWmh2
         mLMw==
X-Forwarded-Encrypted: i=1; AFNElJ9bTrAvqjIXeuEugrshCFcD2dHwqCsegU5VaJ3VzF+m/7+KpR/rBRThlk6Ao78IVtGOHp09CT2PkbLQizo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmW8PJ1lH5JsLy0tfAzGYcZxKl3Q1/u8yOUWD6zlaQ+5Vm8RXT
	sLnwt3fBAOektUe4ZgR4LSLm+MVNlbUbMopWuAvrXTp7FQYrcyaeeqlXuAdpPRsZiRfNgE20llh
	xS5cNls2nxVqbM90HlG3ougr8utGiJFWzFEFik1p+vLAi2vzvFg+6x39NtEk9J7GhQAc=
X-Gm-Gg: AeBDieu3Na4T7SyaGppDvSEDZxkaqAlVvP7ABZ7yIqZGBzk7gn7V3V/W7yiohqxTZqA
	lQs0Vldvk9y7xjQBXFhO0exDP3mNvQ6JYX84+04GMqFof+4i6G0LOeugEpsNb0b56cKG9EadLkr
	4KmphsD1h25+QVdxPkgZ2fYNyEv30FfS0kT5A8JmAYgPwIRfc4ed9pxfNrnBDitWBnzoTi59O5M
	hBerJ8FiEgzDxzf9IDYAGz81HdrhreruF1QvKsNFtUhrudi8fD8BnLrkASzS905HEkF3xBinSFP
	IDjs6Fn38/fdZv2CMwCSLkNvQs1dzU1D+1A+Gkv/Gvv051UEG4Vgca+hFHPxi7AJBEGieTlAtmy
	5yxijYMbJiyoSIDgUoS4Oytaa40UeBxSE2m6Xh99RvJkIAbjQBH7xIdHAp8nkN9wOf3sJOHePuN
	+7oJ8JWPOUXpj3VA==
X-Received: by 2002:a05:6808:1454:b0:47b:c013:1519 with SMTP id 5614622812f47-47c892ab898mr3025064b6e.6.1777899792916;
        Mon, 04 May 2026 06:03:12 -0700 (PDT)
X-Received: by 2002:a05:6808:1454:b0:47b:c013:1519 with SMTP id 5614622812f47-47c892ab898mr3025007b6e.6.1777899792329;
        Mon, 04 May 2026 06:03:12 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67b85e28ef8sm3353612a12.2.2026.05.04.06.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 06:03:10 -0700 (PDT)
Message-ID: <7ca11333-3c56-43a6-b62f-9e93b0f5df13@oss.qualcomm.com>
Date: Mon, 4 May 2026 15:03:06 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/13] arm64: dts: qcom: eliza: Add power-domain and
 iface clk for ice node
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
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
        Alexander Koskovich <akoskovich@pm.me>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
 <20260416-qcom_ice_power_and_clk_vote-v5-13-5ccf5d7e2846@oss.qualcomm.com>
 <e9068e98-1d6e-4cb8-8885-aa5831407b3a@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <e9068e98-1d6e-4cb8-8885-aa5831407b3a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDEzOCBTYWx0ZWRfXx7L5cA1JzjCs
 lCBL/F7QMIM2J5aOd4l3U9IQJ7ecLzV6yzndHYNtgjvzfTnO2E91BAaH3Ufg3B6d5MDmLdUIrCm
 KRpAYQlnJweMTZDSYfP2iFuYx57C2GNG2mflkm8caxiSx9rm/Ax9/+vgaYjagGZTvLOpSwMfgHM
 ZVe0QHGe+m7wI6CeUDZxnzwQ5Vs8PkK/dnv7Ltqlru8remIUmWBVoX13+9tEl6g4sGLZ7pfDARX
 NXsA8yxu55sbqor6b5ehUC8z1MTGZ9rGNMfNV6p2ObOgM0cGVwYKg09PwqTC3gBPqsWEjKpZPG2
 POhzng5QFmuTA5OTS99Mn9HfFXKucXYWVXvbFZPPmsNqAlP8NuyQg+EjqSu4BrNmeC5RwHSNf1L
 i1D+lI6UAi5rfKak1fDCz5UqLsEGYyYCPfsPOBjSp/hCFkJBjdXMHFwWO0wVCjlyjUDuEklndE3
 OzF1iCAJi9unT/Hn3FA==
X-Proofpoint-GUID: M1odY600ZavUqEtd7kErh-nZ-ntTqoLl
X-Authority-Analysis: v=2.4 cv=bb5bluPB c=1 sm=1 tr=0 ts=69f89911 cx=c_pps
 a=4ztaESFFfuz8Af0l9swBwA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=YGhfrQ-tf-JdS713w1cA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=TPnrazJqx2CeVZ-ItzZ-:22
X-Proofpoint-ORIG-GUID: M1odY600ZavUqEtd7kErh-nZ-ntTqoLl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040138

On 4/21/26 11:38 AM, Kuldeep Singh wrote:
> On 16-04-2026 17:29, Harshal Dev wrote:
>> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
>> for its own resources. Before accessing ICE hardware during probe, to
>> avoid potential unclocked register access issues (when clk_ignore_unused
>> is not passed on the kernel command line), in addition to the 'core' clock
>> the 'iface' clock should also be turned on by the driver. This can only be
>> done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
>> GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
>> eliza.
>>
>> Fixes: af20af39fc09b ("arm64: dts: qcom: Introduce Eliza Soc base dtsi")
> 
> On thing I noticed in entire patchseries,
> https://docs.kernel.org/process/submitting-patches.html
> """
> If your patch fixes a bug in a specific commit, e.g. you found an issue using git bisect, please use the ‘Fixes:’ tag with at least the first 12 characters of the SHA-1 ID, and the one line summary. Do not split the tag across multiple lines, tags are exempt from the “wrap at 75 columns” rule in order to simplify parsing scripts. For example:
> 
> Fixes: 54a4f0239f2e ("KVM: MMU: make kvm_mmu_zap_page() return the number of pages it actually freed")
> """
> 
> Fixes tag need atleast 12 chars and I see other submissions specifying 12 chars whereas this series specify 13 chars.
> Not sure if there's some hard rule on this.

I think the general idea is "the more the merrier", although 12 has
been the standard for the longest time

see:

https://lore.kernel.org/lkml/cover.1733421037.git.geert+renesas@glider.be/
https://people.kernel.org/kees/colliding-with-the-sha-prefix-of-linuxs-initial-git-commit

Konrad
