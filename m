Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDFC3A3E86
	for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 17:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778692885; cv=none; b=OHFEFf8+uMOS6011dQt9Ahh4J2FeSTZw7eO4jBl6O11XcAdWWU2q+GVuFQ8C8XITVLI4j0GuTl8TJ+gEIMlWTNJDkaxyad1duIJmGUIWd/bAPt4gO/pc5XQPs5wxPxPXferPMnxh8hQVLpg3nB8EPjTn//sxgPiI7czwMVkNlCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778692885; c=relaxed/simple;
	bh=v0IV5J3gGx2xBoYRV1R+Z4M7mKLMB7/0g67CTqMH8I8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ikbm5FqiHjpte+QA6siJBILNaWkJUm4M5J2sydVDaYqI98VF5IDifWaX5fR7G5/NROQx5kUYbRkWhW9qJuZFlCII7KkV6W6uOpL/hiVPHD7yGniu5iU2kflS1KCr4dhgKytZATy9R5U8qgGv8B9BcozqAX0GbWwsk4TYxja+7tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=geUkzH8u; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YS20f0yU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="geUkzH8u";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YS20f0yU"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DG4t8q3007654
	for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 17:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	64CGNQDAMolvqQS+n3X5oH42IZWBrRm8X32aGPTCYYQ=; b=geUkzH8ugbIpy1OO
	62i4XuoCUdGn96ZBmA1yo51A95Momi59EYOGcFV5azv0uDMFXc2rmYbqJYfnnv+J
	M62iehyevwymqhPa7j71hG3u6PZIvcF1FSAqNZ4OQKjaafGN7Qnt3QTbpR5P51XR
	fyAIeaFfZ6Y3r2uUc/dK3GDBPAw/dLJp9MgmNStewb031BeqS+x/yCj0JuetEtix
	GctQFROAkvXEOYTNQxSzTk7Lsiigt+aJtIG+SFE1Ul+1VXuzD31kJX8Jnd5mGYI2
	DOK7nnzuXE5UYm+JgYHJKjHKo0cCIKveS8Zza3DRK8cILZ1iLvh3WfjhxVcHNq5x
	hS+kLw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e4py0hs2g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 17:21:21 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ba268cb5e6so62930325ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 10:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778692880; x=1779297680; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=64CGNQDAMolvqQS+n3X5oH42IZWBrRm8X32aGPTCYYQ=;
        b=YS20f0yUAx83JXpLoAoc7QCB55czqiyO3ljkSLSOEXsSQpMFOmSRGV9ED0CKM15QgM
         dfTO0N3oFI9+iS/AwHCVjLS8uHPzPJjupMRaF/hihktjiMi6Ds2KoInEf/aivEVd2DSR
         +y1URt8F5g6O+2jCtohyvFTx94IHxwCwmKmYYTz+CQpiLWJ5B5CGLT7MWkM3FMRX+M24
         j/FT+y/hWMMdD8zil+Ce7Oz5Vk3fUBe57ZmD/ZbO9MSpxr7NRmlP4QGMZFjWtQ6TZkUl
         umtVTLAahpXhtkpS3IgW8KyOZgTVWDVDGVABcvck/+gSDSQNCujdgcM52MlkkIAVWqzB
         iJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778692880; x=1779297680;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=64CGNQDAMolvqQS+n3X5oH42IZWBrRm8X32aGPTCYYQ=;
        b=d5epZ6jWqWhjM4LYBJ4AQEjKoM0HSsFe0rcVvTfnyVcIhWNoOvNxHSEtGf2ef5I5Ip
         eIjfWGE2MKKQ0KaMguxOlD9Wrmt7W7qZ1syD3iO01iN+C51MVg0o/v9SMdA3nzApf0Z3
         1rBaJQW2kkCeZTbRiMMIHVQYEULdqS/soY9mpVDi4Cd3B1svaAxwmJnwKTWlhMEC2vcH
         9MS1Znat44LVuUZN3RFP+9p8F7sL2dcB6XDEzYSooTX6VkLqk92xfc2fjlCuhH8T6Tqr
         b+uyg434UbUrDqS7iaocc8uw5G6K1fc2YiDnXLJTVVglZ9hC16FHQuo7+/iUjrhR5cbo
         NQLw==
X-Forwarded-Encrypted: i=1; AFNElJ/aGkA2Bnc1nSxOuLlFtToy2+3NXPgzJ9x4TLHDQiOtEon9I1hvWOI/0KN/yEfyC9H8zua+q8sZnsoVqhI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6wObKxeCxpFV9SelJ6Xz4L0d6Vr4upusOkbWmBLR1KJUKPpS0
	+LloP6HI+tB8fsjlLkmGY7CRSMQSduAc8flqgSkBcZO+t+5TpSop9cdXdz2a1hyQrUbS7hqb8iq
	7Z7yGvH7KQra3TDzISFvGhKaGM3O3loFdGtyEiBzIItex9pzb7Irr6Q1noUEVorvdHDk=
X-Gm-Gg: Acq92OESy3XALmMaTJhJByR9JdQICG1ATb5BRFiDtaRvImfSyoGTN/q1s16ua2gz7E3
	3UzQUTtFB9jr/xKRZMuotQqBDL3wjKP/r9MfmZ/RgIzT7B+eGC0V4Ti/OcpCLufFGHJPZXrRaRm
	UYJ0Mk+9211uvKYRX0a6uJnsQrpxFiv3T9lvuFgXxIvH5DM4oeHK0AUySD97mJbPIPz/AYJAxF4
	yK3ng4ZA9Iwee2uMV5ayDNcVqOXKF3Z0tJpUYNbtanJBDG6yXe2IpqfK3uGEKiXjd07J0Jh5JRb
	O4Etmlst/QbKn1CfhGWEs9DZqTOrcofuH/3vWVMsGwJg/xCMoT/5OyJMJYrasnoSYUuRcAZAEEt
	zN0WkCLzaJFEQWN4pqHUO2vw2cpeAA+2OBOjjN3SZeZCvFOpPirY=
X-Received: by 2002:a17:903:f8c:b0:2bd:147d:c712 with SMTP id d9443c01a7336-2bd27133c75mr48061065ad.1.1778692880456;
        Wed, 13 May 2026 10:21:20 -0700 (PDT)
X-Received: by 2002:a17:903:f8c:b0:2bd:147d:c712 with SMTP id d9443c01a7336-2bd27133c75mr48060635ad.1.1778692879972;
        Wed, 13 May 2026 10:21:19 -0700 (PDT)
Received: from [192.168.29.116] ([49.37.147.94])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d271d1sm174203325ad.11.2026.05.13.10.21.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 10:21:19 -0700 (PDT)
Message-ID: <3ba11863-e7cb-4697-af67-44a26b19ca8e@oss.qualcomm.com>
Date: Wed, 13 May 2026 22:51:09 +0530
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
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
 <20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com>
 <afmuncmBrrvddHTU@gondor.apana.org.au>
 <b8805117-d54f-4e42-a7d4-6fa18af63e69@oss.qualcomm.com>
 <CC0E438D-5544-4BB8-8512-7F93A7FA4DC1@oss.qualcomm.com>
 <af6MsD1wDs9EZl5q@gondor.apana.org.au> <agHkmKq-q7_6m4nl@baldur>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <agHkmKq-q7_6m4nl@baldur>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE3NCBTYWx0ZWRfX8DmtGyMf1H/E
 1ls9zqpVomiGrfCx2XED09M4oOD0zm4swU60LwiFeIOG0uOOaZ34UehrLXwRWrhQH6V82GC6q8m
 m1B7M7DlUNd+eFHyOYw5mqoj0Qr0ikWy1aSSd6tLHIa4Ti0e2ahWlge0al5NB1qZ2k5axolacIq
 iVGnJCZY7pYPHYkMgO2Osz14S5t2OYEDutNqChDTItpElFFWbOEsp7O/pgcxr2NtTteIGK30CSg
 80eiOBAFNsJTzKVHYt1Xqr5QUA9Gz4ySdfFvt8OW/ywWZsUaul6efm93z8KkcPwW6b7nf5afAxV
 nygK9fPM//eTpNwf8qXlx8b/n/5Cr7Oni5q4VZEjbmYeN3B3NYz94Km4CMHule3NheVo9jeGGlJ
 91X8nrPb+ADw2+WB2fLenLwjlz0jW2shHS/wwQzaKcRXYMLVSmLoWH6E17aSf2gQusTsNzZMBqi
 TmX9bxZg+lI2XZn/WdQ==
X-Authority-Analysis: v=2.4 cv=XqXK/1F9 c=1 sm=1 tr=0 ts=6a04b311 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ck3DHw2mBQFJDQxCZQbCAw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=FNyBlpCuAAAA:8 a=EUspDBNiAAAA:8
 a=ntcFNnzPSak53SQFYkoA:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-ORIG-GUID: P0sdr_bWXjIK_kzO08dF6OI3Qh0jF8ne
X-Proofpoint-GUID: P0sdr_bWXjIK_kzO08dF6OI3Qh0jF8ne
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605130174

Hi Bjorn,

On 5/11/2026 7:47 PM, Bjorn Andersson wrote:
> On Sat, May 09, 2026 at 09:24:00AM +0800, Herbert Xu wrote:
>> On Fri, May 08, 2026 at 08:11:45PM +0530, Harshal Dev wrote:
>>>
>>> Can you please confirm for Bjorn once
>>> that you're not picking this up and he
>>> can pick it from his tree? 
>>
>> Bjorn, please feel free to pick this patch up.
>>
> 
> Thanks Herbert, I've picked the binding up.
> If you need it, you can find it at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git 20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com
> 

I hope you are planning to pick up the rest of the fixes in this series. I can
see Kernel CI Robot reported some dtcheck warnings since your tree doesn't yet
have patch 12 and 13 from this series which have the corresponding DTS changes
to comply to this DT binding.

https://lore.kernel.org/all/202605130731.Gi7H8zjD-lkp@intel.com/#R

If we can pick the rest of the fixes in this series, the warnings would be resolved.

Many thanks for your support,
Harshal

> Regards,
> Bjorn
> 
>> Thanks,
>> -- 
>> Email: Herbert Xu <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

