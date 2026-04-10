Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33911AE877
	for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2026 05:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775798494; cv=none; b=WRdXKJ1iEnTqyDwcDaVQdT2n1ks89+9mSpSkIBndkcA/ji1F43zyplI2u79MU6FNqPDPjY119RLoKhZllFlqc+RDtr2htPF0ipIVBr+Jq0p7a2CCXaqN66F+DUTWJD+A3zQs1RLFvafPYbwJYf8aHBA5yZdMGoqMcL4GgeHIMYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775798494; c=relaxed/simple;
	bh=yHvOI2JZgbxhhrS18x0i0G5yfw4r80zSgSr0hfssywE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=L7Bx6SZcEtG4dRVLOfC3+P/gYPN6dHNa9yS1Vr3IX0jmW/OulR4DwpFobjhOOir/WvkAwiVOgpmcbdHW+ncTNcemOOZigMyOd0rgrpmW2Oc5UqQG3RAiJ8OVlWs7NRti6gieH26zR57w3W2KYg7Dpksy7RZ3buuIREGqGr4m6zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EFm/x4IP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e9tKiS7n; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EFm/x4IP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e9tKiS7n"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639MreT32812087
	for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2026 05:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IizYWfGnPeXguJY8VoN9IpzJy4a0fnMYo5oTTGL49d0=; b=EFm/x4IP1CiaFMsX
	dcZCV1zlJ7zw4ZmY4hK8WZwxwuVCDNGucrVuc0mIcwtyT5kxR4I3qSMHsB/e8/9k
	ZOIGrf7sxwAUcseroqYEIhRzMmFkHWMn0j4nO6/ZTaPap3lZlSAH6FmJL46xoz22
	p7K37GA3u90WJTAA0rYyobPwwh06Y25VCkSXYrC+6Pm+EvUisQRCT84NpwgoQXV8
	+yWdUNIR9EhmLk1JLFRsCz67Z/Sb+l6WvFTc/oljFmMsYNjuOk2ioI0rbe019zw0
	VHi0/r65bVSxH06T2bzgSUzolxBW9OZJDfyw5kh3ZdB/+yq1hwRiNPTthUuxWQwB
	7znu2g==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ded6hamf4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2026 05:21:31 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b24a00d12cso16640045ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2026 22:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775798491; x=1776403291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IizYWfGnPeXguJY8VoN9IpzJy4a0fnMYo5oTTGL49d0=;
        b=e9tKiS7n182sg3jyL8ZOmcJcQMbIQ51sAGYY+bGqnoKIQLpYtyJhQxBvrHymvlVU/G
         N5w0dp5tnquXJjGWJCH5QFLHRD/EnGghUCAOIVnqOGynd2qscQcWzlmHl6lJLsE2mSvH
         AS6iOFdQ2/5TNxtO6Azxc8AMxZwM9I5uWXenme7SGzG0gVP3I/tBdO6ZlfcXmZzSzLtQ
         QZhFFVYI/NIdoA/k2djnyfIZ89cU3ojb/LXV/r3xPwVECWgvcoOxo1WUgpZkc/lwE/l8
         46+Zctl03qacUbV82XBP5auX5ZD95divRcLf8npeVzdkxIuih5V99KmXnJeiOtMc9kl0
         j+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775798491; x=1776403291;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IizYWfGnPeXguJY8VoN9IpzJy4a0fnMYo5oTTGL49d0=;
        b=Hn51J7ZcVDUVDVSHb5DUGPm/EnJ6gKG/X5c0FmIYv/s1zbubbwgu0KDl3Z7NX84AmT
         FSqEvi+iMHa9OVGU4gBwyNgFJNAbroaMyRA05cApouRZGL7Q3BKrBmR9kKSN3AHVxzO3
         TgNgPS1WNbI9mMFSP/7HKu/IyJba7OpkWyyRcASH/kJmOxnoEVjJh1cxw6QqnhwYtkO0
         Bz6NDzQUqmHyHEMJtrDbhQiVg+Tcl9d0tG+7CYnrijW/jFCMbXmpEjfuCApp6Or111u/
         MBeHpr1EuMtfu/ha51DbKDQTG4Nq822zeEBva0/EJfV9Y8Ql21kxJd2OKoZj6L+MdOR1
         2rxw==
X-Forwarded-Encrypted: i=1; AJvYcCUuaT61iVWMBBFCMAod3F/MI94hGb+qxdl/QshTdfTX8L7YqKHaltUsiZ0hx4aufy8jDb5pbGWxK2+rra4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl+8tneleJLZz00Whj3Cy++08qZJEny0awOoXhQ/mFiulWQwcg
	M9GukNVD+9s964VvcVst7ARTVnPAupbVH7/4MqJtIuCKeAAplRhRh7SuySzRh4FX4ztEOJvIhFE
	REE/cPadF7kt3TqU7U94blGb3JOGlf6mqe24UrydqUl0S3BE36okijR1NsczduF7Uszw=
X-Gm-Gg: AeBDiesCml37kj22SE2yAJCiyZub18jCSTywozpSTZI/8DmNK+Dx0TtNtlJ47KEfnut
	Wv/v22mj1j4TkSUSSkuRDuUYFcYzW+WpGc9EC3iVG6AAWIZ4WGUSE+HyMfwQsezW3b1SMlyV7KE
	aYXRm1Ves0mo2HsvSdT2G6GjDVaqKk+SwtA3yVewtfagZ96Y9mUnHIBG4qZGgLqce5uH3xClApI
	kE5CNjLL7B6jvtD171zSXJwCFSVcEQhaU+bAqGcPpLDijoUJu4uJtIJH4DwEeQ8rFO8B/66CZWL
	voE+T6xi5TGkpjaczjPlWkDLHxjitunY1iJcuxtyPd5GA5QAp0P4uocSQESBceAV2lpRPEgA6Up
	fWRxCAslKU/8P9G6mhGGtaRvL/ErPRfNBkGz/kJ/GEdiKPC/kltxr
X-Received: by 2002:a17:902:a70e:b0:2b2:65db:8c5f with SMTP id d9443c01a7336-2b2d5a1cbfemr13291105ad.27.1775798491268;
        Thu, 09 Apr 2026 22:21:31 -0700 (PDT)
X-Received: by 2002:a17:902:a70e:b0:2b2:65db:8c5f with SMTP id d9443c01a7336-2b2d5a1cbfemr13290865ad.27.1775798490717;
        Thu, 09 Apr 2026 22:21:30 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4f469casm13692445ad.81.2026.04.09.22.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 22:21:30 -0700 (PDT)
Message-ID: <a6b18da5-4132-4a76-9a24-80e2978af86f@oss.qualcomm.com>
Date: Fri, 10 Apr 2026 10:51:19 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/11] dt-bindings: crypto: qcom,ice: Fix missing
 power-domain and iface clk
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
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
        Alexander Koskovich <akoskovich@pm.me>, Rob Herring <robh@kernel.org>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
 <20260323-qcom_ice_power_and_clk_vote-v4-1-e36044bbdfe9@oss.qualcomm.com>
 <873e8ad2-50cd-4c09-9a51-20ad745fe8dc@oss.qualcomm.com>
 <2b71dd68-ff35-411e-905d-3ffa2ea3efe4@oss.qualcomm.com>
 <36b4fead-81fe-4b98-9de5-4d524f199569@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <36b4fead-81fe-4b98-9de5-4d524f199569@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=RfCgzVtv c=1 sm=1 tr=0 ts=69d888db cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=Z7d3RZfmASx9lX5pdYsA:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: 1KDoQqONW9Wt-JQ4gZSvSRz7xN6qXc3J
X-Proofpoint-ORIG-GUID: 1KDoQqONW9Wt-JQ4gZSvSRz7xN6qXc3J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDA0NyBTYWx0ZWRfX7+Jzfqytl0Q+
 /cN1Kmnqr25RQOpTLM+aBjF3exPk4U7zzmcSmUktjS4qLSYriVu8N7rRoMPrqelXUkwAvgWGrhI
 /DABpkCAzreDEZS2xByQo3SaJbsX4opEouQztgJEVvABve2rwrDE9pI5L7I2u+T1Mje54PzMVYu
 Yq2atUOsbPMgCQmaLXsj07P17//hOK0Ej3rd3XBbDscdT7hhnEnEd8BXDvxF7uHhiyhcOAclB/c
 N2Ff5x8FZL7HpXzx7SQwQEkwhFWRqmWWYMlg4XLRk747TiSLtJBAYhqpzNI98fCUvgSomtuYkTC
 KHfNQWsNSfDPacKFz+yjxesTEw4GfL0Ce9sYJfViLCGboiUuMD0GzE5ZIn3bPLzawEzAOV/hRaj
 VjeA8TefoM6Qdrw42M0BJfEM/HtA33kSLTdEGUe6De3rvsw68R2Swm3vUbvHcG7wuDs5ychsm7C
 uRx1kjJGaoHJBd75v0A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_01,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100047

On 4/7/2026 10:28 AM, Kuldeep Singh wrote:
>>> Hi Krzysztof,
>>>
>>> As motive here is to enforce 2 clocks for upcoming targets and keep
>>> minItems as 1 for already merged ones for ensuring backward
>>> compatibility. Can we do like below?
>>>
>>> allOf:
>>>   - if:
>>>       not:
>>>         properties:
>>>           compatible:
>>>             contains:
>>>               enum:
>>>                 - qcom,kaanapali-inline-crypto-engine
>>>                 - qcom,qcs8300-inline-crypto-engine
>>>                 - qcom,sa8775p-inline-crypto-engine
>>>                 - qcom,sc7180-inline-crypto-engine
>>>                 - qcom,sc7280-inline-crypto-engine
>>>                 - qcom,sm8450-inline-crypto-engine
>>>                 - qcom,sm8550-inline-crypto-engine
>>>                 - qcom,sm8650-inline-crypto-engine
>>>                 - qcom,sm8750-inline-crypto-engine
>>>
>>>     then:
>>>       required:
>>>         - power-domains
>>>         - clock-names
>>>       properties:
>>>         clocks:
>>>           minItems: 2
>>>         clock-names:
>>>           minItems: 2
>>>
>>> This will ensure for every new target addition, default clock count is
>>> enforced as 2 default.
>>> Please share your thoughts as well.
> 
> Hi Rob/Krzysztof,
> 
> Were you able to review this suggestion?
> Please let me know if need to update patch on top of this one to
> initiate discussion.
> 
> One advantage i see with suggested approach:
> For new target addition, just need to document new compatible string and
> no need to update another list everytime.
> It's easy to miss adding entry alongside eliza/milos and might make
> wrong assumption to authors/dt-checker that 1 clock is still allowed.
> 

Hi Krzysztof/Rob,
Kind reminder!
Could you please share your thoughts.

-- 
Regards
Kuldeep

