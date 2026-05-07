Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438013CAE92
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 10:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778149235; cv=none; b=TLP1WyWtVlWYN6FifloBa7iFdOyQLBV4O/xbTnwq7Gw3IpzGlL03uksu4d5qFhCwx2yDRBmsRJLvDdNUQ5OE8dwoQCC70swgT72Fr8KO1CbP7OodfSi7HbKNC2wv5llBGTc8vmBVtE3zw5nVQqNxcnJ4+uZLz9durReVfnekdnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778149235; c=relaxed/simple;
	bh=2avxSsvk1as1FMY6RZX9B99PtZTW8XOT31jV6eVZ6xg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1l5ecTWfSoUycQugZZoRx/zxUfFdXnWd6UeqnAuYpTK7APdUDHiy6T3sI1YACAPLHXidC9aTDNwyzm/XjnLDeSmhAcSNJATmQoB2t7HJR1gdjopJh8JkwBmVYaD8iFCVw4osNchfD7tXBN5pqKzcE0cwDWRyJZic7bvV0xteHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SIuYQE42; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a3klX9YQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SIuYQE42";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a3klX9YQ"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6475MPC03157830
	for <linux-crypto@vger.kernel.org>; Thu, 7 May 2026 10:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/5khHSPAj9LWxns39r4VokImHha4yMAwLlWdMzY6C+E=; b=SIuYQE42z6i9X7IE
	qd1RPC+RB7OGD1KAd9WbNTvlFgF6j+gF1bnLfGmPzCWi1DlC97FXwcL/3aebILz9
	fBurTT4pMlR0tiji3AsPG3GyTM1PstZWk/uAhvNUtnnE1XJeVE06eTKift4tN5iP
	LOrU7PWK/oWztzxL3Gql+YNg9f78klXntPo7aTvv5rlExtIbs2ze8Ij6ZP64pow7
	PW+6russqldCZ+wQX8++Ej1gV79ILQegULNwUt9DyGDTIkRXZ5QxSUyUFoQinFH+
	TlfWLs16veUtpHQTE0jaQQFVQTkI2YSC3X193c+pFi4aYSTJqh3kRPkxe4MVrUiO
	8AYzDA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e0mhf14m0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 07 May 2026 10:20:33 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ba603a7d2cso8083945ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 07 May 2026 03:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778149232; x=1778754032; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/5khHSPAj9LWxns39r4VokImHha4yMAwLlWdMzY6C+E=;
        b=a3klX9YQwsQxBrxiS7TYWH6VUWhMNXfZve67ATRHutpSElJlwnN9uWhvX9zpc5vK2Z
         hADkAvg9hO7ntG5V2t0TC09WYsF+TuqVPdT2Wyj4LSd6uzmNn0J3xpbN83z1YMHvUOnH
         F4VHeTOUgy/CjCPpwexe/WF3TXiJChdzyI5EBN3qx/vN7UKdMS1p5cx7gwY9ZrH0lJl8
         5x4BL5uiSGff6KsryeGkfDoI3NdH440ODnHsqxMzA/INlvxYe57YMPj0SnOxR35qw5WH
         ja3+dC7SJsvi+8olBHpqbmbgX5wq44U1lTqlJhTLtVsDI4aZPc2Q5fTwAoSBri5Mmg1s
         Nxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778149232; x=1778754032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/5khHSPAj9LWxns39r4VokImHha4yMAwLlWdMzY6C+E=;
        b=pKvdGwmQVembEBKq7p0hVEmh9CUW5q1rWqq2CvEJDfLXMH4hAPQI5mHTL25KY6oJCe
         9AIu6T26nZ/44whhVDEJIzK7D6F11mTOlyumbh/KRP+dwcEFVRaJG9wXGOPxGqmr/lUS
         zMu2GC+4UeZT/Ae956cJR47hbfp8UM2YshASuuQXCoFI7v82Lk+9CjLxl2mwQYeAXgh0
         BwHWvwZhCpQ48AQIWlJBm5ikAST72+CHfnDwK+Q5d8YV78p36yZJgv98XYYmhwT/K2WQ
         bZUvCnqdACSG3eGndDMdSTIBp7QDhC2fNyQZhZhMHF7BJBecEh13lzooh3ndvxegX9A5
         Vs8A==
X-Forwarded-Encrypted: i=1; AFNElJ+RGgjv7wZZ2pOgZ3NUq2gWW3vmUET5UR7GvM8CrB00Zqx+KuIgC21/HrfpPNy4tXP1TiJtd87ide1AutE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNTjCZwTXkU+hU3kAhyqiU4w/kpnJe7JWlrkf38pzC0BDC4XiJ
	pTBIFdOJpc6TYU5voRwMJyGCXDdpPdWidokGWtlFzI/3Q5myHw8/RgB8JsN7jj/yhIt8oDy+xGH
	HK1sMVw/tBGBVDflrCAwAM54gGZW3YL1Fbo2qjauh85DKLhJBboEgHgkVzKVa82xsLXk=
X-Gm-Gg: AeBDiesaG8NFIGGBVeqQH/gEJV6UsiVn6FLzllzHHFyQtvSxCgvp528Pg0IdGe3B6bK
	CzZeqMQBP3HnpYMFC2IkWCl5x8xqfJQvjMHS6y9pzxxRuiUQP3Xuu+pK80SLIZfgq4yeC8yhcK/
	6wHrBNunmGKNfPNMCndl5pAEi2+zR7kD0EFXEqCC4PX8kuPK0Hmm8W/u+CdcLh55cAecd+ZJfgP
	elBtG97mD+S1tY8UMz0qN2Ir1A15ccU5Hla3lPfScinMc/cQ2814bTV1ljyjmqzv/5ifvFoZsuH
	k6g9fpBSp12O5ruuRMANMtomWMXxTZ5wWCMNJDi90tv5VPYf+Iq7q1EGGOnHo55RnHeDDc3GPqB
	0hX5UmL2GvxoZZVtHDaAlogSqsY6unwmfvbQHSuumU0u7KiCEt+/GciB1Nm0kXA==
X-Received: by 2002:a17:903:4b03:b0:2ba:21c2:d6cb with SMTP id d9443c01a7336-2babd4bdb6dmr19838095ad.16.1778149232135;
        Thu, 07 May 2026 03:20:32 -0700 (PDT)
X-Received: by 2002:a17:903:4b03:b0:2ba:21c2:d6cb with SMTP id d9443c01a7336-2babd4bdb6dmr19837785ad.16.1778149231620;
        Thu, 07 May 2026 03:20:31 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2babadef254sm20528445ad.61.2026.05.07.03.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2026 03:20:30 -0700 (PDT)
Message-ID: <b8805117-d54f-4e42-a7d4-6fa18af63e69@oss.qualcomm.com>
Date: Thu, 7 May 2026 15:50:21 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/13] dt-bindings: crypto: qcom,ice: Fix missing
 power-domain and iface clk
To: Bjorn Andersson <andersson@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
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
        Abel Vesa <abelvesa@kernel.org>, Brian Masney <bmasney@redhat.com>,
        Neeraj Soni
 <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
 <20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com>
 <afmuncmBrrvddHTU@gondor.apana.org.au>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <afmuncmBrrvddHTU@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDEwMyBTYWx0ZWRfXx3EOPuIjbRuc
 UvwE0tmwnlNPkO4DZamDRfA9GK30Szw2EzFzCauAPuwi0WO7LlMnjoIv8o8OKCEbVQdaST2VoLE
 gW2C8jXOkxASjvqKKjpJOyup219kJdOEy+mEeaupodyMCGONMd9km8wSAfaqXHFErpqsXwMbKYw
 xFtFczqwjwr+ol90hx9VayGgkhuJQnDaG7tfFI75g/hiOV+McXwu0t8/XNiWksbDKZ5lWPS4nTw
 N33TxE9DklEyIvRT3066kTEPJPahXxNRwiddDOu4UI3+XoyrXcdBCLG/D+ZkAUz00cTFf31Ub8V
 QAVXeuVJqqMcUVEPzChUH8WtV9aGXdgrEvEb3GilV78CPAFMiioz6vnfxHGVPXXWDkMLYoXhMac
 +dw/KSOcltUvElek1W8Wc3bcpWwr29j5SxH50qJw01JS8UESFkf7GFvXM+XltkuuiFIdK88GR8E
 MKEDT4+bsTOiyaoQljg==
X-Proofpoint-ORIG-GUID: cNwHvh9n9h1gN9-tRgwoiR_JrTeWY8Z1
X-Authority-Analysis: v=2.4 cv=SuagLvO0 c=1 sm=1 tr=0 ts=69fc6771 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=CMx50Ybjb1gtcuyIV48A:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: cNwHvh9n9h1gN9-tRgwoiR_JrTeWY8Z1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 adultscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605070103

Hi Bjorn,

On 5/5/2026 2:17 PM, Herbert Xu wrote:
> On Thu, Apr 16, 2026 at 05:29:18PM +0530, Harshal Dev wrote:
>> The DT bindings for inline-crypto engine do not specify the UFS_PHY_GDSC
>> power-domain and iface clock. Without enabling the iface clock and the
>> associated power-domain the ICE hardware cannot function correctly and
>> leads to unclocked hardware accesses being observed during probe.
>>
>> Fix the DT bindings for inline-crypto engine to require the UFS_PHY_GDSC
>> power-domain and iface clock for new devices (Eliza and Milos) introduced
>> in the current release (7.1) with yet-to-stabilize ABI, while preserving
>> backward compatibility for older devices.
>>
>> Fixes: 618195a7ac3df ("dt-bindings: crypto: qcom,inline-crypto-engine: Document the Eliza ICE")
>> Fixes: 85faec1e85555 ("dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE")
>> Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
>>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 35 +++++++++++++++++++++-
>>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> Patch applied.  Thanks.

Herbert has pulled out of picking this patch from his tree.
As discussed, since this DT binding update relies on DTS changes in commits 12 and 13
of these series, they should all go through the same tree.

Can we aim to pick this series via the qcom-soc tree to ensure the binding and DTS changes
are applied together? Since the 7.1 fixes window is open, I am hoping for this to be
picked up this week or the next.

Regards,
Harshal

