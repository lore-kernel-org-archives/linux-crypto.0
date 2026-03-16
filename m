Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB833932F9
	for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 12:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773664709; cv=none; b=A+LNj8fref+CgMZDbyFUBuOVRxnNKgN74q1yptuoDsB+dwLfjydLlaXMeoL9SbiqRXrONDczbEgIJ3XqhDtAJvky7kx8IaAc6Jo1A7lk2Tr1DCLkAkrx2iBtBmpCSxjkvJONGEpeTAsUaPC1kWbwsiaagB63M3DKOookbMoa4/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773664709; c=relaxed/simple;
	bh=nsErYwbtChCQiapJkcrzg98OOqd8zCCGMK2ntR4jOqA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hGQjRzCACpDSb9dw3NdpuhHSp3P2jS5qYjp0MWXaSHQQH6NnA2cW64uIlgt7rmxPAyRqU8L8fVCIxS0GalojGw7PicQtrFjVm+Tvf6+1QNqelM8tSWOQxN3n7kdGriPB47JsaR/1QJXlq4/Km1BFJf8YrVeYo6t+rxe2bbn+UY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N7N5ZXRC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VwN5RBkO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N7N5ZXRC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VwN5RBkO"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GC0d761724882
	for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 12:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9J2Sbga2XlEXPDOHcokMKf1ZSnJnsrAxProE5RVBy1s=; b=N7N5ZXRCutQ6RBDz
	/S1ioW2HCgNopQ1FCnJtUN+Lp4kyIn5A9p6FMDVhoip9bNRqUYyJcLPd0I+OySh0
	LIoM0aS3QK//H/GP7XDU9iyX4+Hg+KrIWjDBDUGQzQ07potR6yEcfhVu3aXBHuHP
	CaY4O4GU88ALZrVYZFJisjp294zZ3vc2u6tXkvpkSXHbfdHObH8FCh97ixhBlmR3
	Sz8aPG6KrC4A8BmLYmMq74pDk+J5p/LrrLCgoLlxhq+fNuNRgjGXnhUW1KmlRamF
	aqnocV+LebWZqS90IWBWzFQQ//uFb9S3dyjVf9Yk+QBKcap9jAB+dKtbLaSBgD4x
	gJkgCw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cw0udnkry-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 12:38:27 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3568090851aso39769552a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 05:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773664707; x=1774269507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9J2Sbga2XlEXPDOHcokMKf1ZSnJnsrAxProE5RVBy1s=;
        b=VwN5RBkOregDSQPPb4NXjyetAm1AerysCscHEEHLuT3vJUIvypK1thvPPrmS6zj0eg
         MIB5ayHN7zlK12wR5g5NrYPevehx1uR9OIA2aTNZj06q/+E5AOLVwiWMxOl0b8QCGk/O
         D6PMPfrSZ21X++A4YCDMdU04IL+UjPDccZVoiS4d4xjHfuatoPJ9BrlcZBV0jyNc89y5
         9gP/hVFLP3x01H7tQWLODDSSSV5Ptb/EAqK9NpvB9vBnt9LFBgZLAX+KvuJsRBSi9Ucz
         tQR7HazJndlXIkMa0yjmuEi1G2jHtUuF+S24Mlk89kb3BOEQK7BZDzASAUznYwB45QPN
         CHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773664707; x=1774269507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9J2Sbga2XlEXPDOHcokMKf1ZSnJnsrAxProE5RVBy1s=;
        b=ZvbQk8w5kE/6nX6kqc32G7sJZ9EtmyUO7dCwuHi3YGLrIHPzqngVxpBXJJiDkLTCPq
         Kj9LHUL56bN+LhSqkm7mB7MDpAbFrbCxsdJUNdHRs28lznSN5xZJjcKuMvrkvLB/qBqO
         zeJqRhgo3nSyL3lplcDW8Dl6bAtk7C9cNhTLQtEGQIa4g+OHj0+umvSfnBJetRKSJswV
         gFSC8IoDGcy6KtT05vnHSQ67wKUNtowPuzUQ++BYCZnpEDFhhOpXXli9vBwq5ZqM+43U
         us/3qzAil1ro4FprqYxguW1CWarsxRD7a4lFKbmDxXUIAn53m6riPf0AsF6bs/pP7uJO
         WXHw==
X-Forwarded-Encrypted: i=1; AJvYcCUwRyvTv7HQdufGKYiaXvbivxrpRlG7s9Dpm0vW06ze49JOvs0uBASUTIatAiAhB/4SmZRdr1d2AcX5lLE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+NVxf6wt0UBnHXfQgkn9rYun1ZDlNK3dC3uwii8BJcstJ/pzk
	e3Rt6sC/XGo3lTgzuj563zxRp56uwv4C+N/QBo89UljviVnWEVb8vMLn+QYsGb/+SwiFgnd3tLD
	by9sN+1CZYlvxJUteg3Sf6XYEZI5Jh+/pMd6N8cCwdyJ6zHRVCj3j8nCFeznVKsa5BtQ=
X-Gm-Gg: ATEYQzwpM0WG8HE80O9QAmkz2yEWZyNzbTzmsPj672ut7Wa7YrpqPGl0zAzLrRNQKtO
	eTguBYULJoSGjvnwRmGW3RJFFrCkFP5QCs+ws68SpicpmI67obRSsdAFaNL0S9IdzNQ/itQ/PJZ
	YCajOs617zAXVGYaGTScO+lmOxIWzSUhqvlibQcdSRmtyWrzuM/MbgjGd3eh/eQou5N8ZwhWAHE
	H91yXl3GDrTvjeG61+sM9NDgkGHtrobiHh/QbFOxPtTSXWqWiOMqC9ItX9E34JDCY61qbscx3y8
	rW0XqNWUm/eNc10UduSp9wGwO/2zRP6hQxiFd+IwTqOfrnfe7oCHrTqNR+j3030sfTCh+Fi6Eqs
	pBxqYBc7VpR9X4FfU4kcNUmtN8DcQOuJ7FvakzWQNwmBebFxFUYo=
X-Received: by 2002:a17:90b:240e:b0:35b:9242:61ac with SMTP id 98e67ed59e1d1-35b924264fbmr3530194a91.10.1773664706851;
        Mon, 16 Mar 2026 05:38:26 -0700 (PDT)
X-Received: by 2002:a17:90b:240e:b0:35b:9242:61ac with SMTP id 98e67ed59e1d1-35b924264fbmr3530174a91.10.1773664706318;
        Mon, 16 Mar 2026 05:38:26 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74028eecd4sm3718488a12.26.2026.03.16.05.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 05:38:25 -0700 (PDT)
Message-ID: <938a2d30-200e-449e-8ccb-0d2576fd28d2@oss.qualcomm.com>
Date: Mon, 16 Mar 2026 18:08:16 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] dt-bindings: crypto: qcom,ice: Allow
 power-domain and iface clk
To: Krzysztof Kozlowski <krzk@kernel.org>,
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
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
 <20260310-qcom_ice_power_and_clk_vote-v2-1-b9c2a5471d9e@oss.qualcomm.com>
 <2ac2efad-3533-490e-bb42-f21c4e950277@kernel.org>
 <a2d6c630-e4df-4cdf-8b10-64d87d24bf8f@oss.qualcomm.com>
 <b2d852c4-9f52-4ad4-a916-ced19c599938@kernel.org>
 <972bd9c8-4671-4151-a3a9-d7eccdf83913@kernel.org>
 <fc3d1ef4-1a0f-41d5-a742-81305ee7f521@oss.qualcomm.com>
 <87fe32f1-b2f2-4b9c-9e54-03be35c921f2@kernel.org>
 <48daa237-aff9-45ef-919e-665e5ed27f66@oss.qualcomm.com>
 <f8cf0bea-aa1c-470e-9d1f-807546a93b9a@kernel.org>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <f8cf0bea-aa1c-470e-9d1f-807546a93b9a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=BJ2+bVQG c=1 sm=1 tr=0 ts=69b7f9c3 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=SZXt-WhlXTLr8WwM2e8A:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: tk4IVJXV1JSO90ykFLje89NV0DZzK998
X-Proofpoint-ORIG-GUID: tk4IVJXV1JSO90ykFLje89NV0DZzK998
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDA5NSBTYWx0ZWRfX9ODM4zPB0ign
 MrK4UcGOSTjvioCGBY1wDIBfbZQ486Qdd1SudZFU4t4JNYzg40VdBzXZO1wvYceWai8GbgoxECH
 1sE+phTU4No9+V6JHmXyx/9fsTRktpuTWMNtyRetFNoJfRnWoJ9bpmr5UudCbWCdSrlM3ipayyd
 43W1rGbN6FYOy5pt2A9s72qYzJpcknWUfkKycHnRnD/zUq8UcVN8Ud4ngSqP5poer5e6EtonuKw
 Mwz1znMC8PpZ2BhVKSIK3BlujwmbQc/1q+cg1q2hi2INrZME1ezv4pbcBM8bX21kvpa+EndzDHe
 zuyGeMFDMbUxj2g6biWSZgtUCNCudGz45VuM06u855jGvHcpjAQ43J9FMv7unDG5pmoS2duI9dd
 rpEbQdhIHL+89Uqhso3cmWBrXTz+rw/shcS77u+hC8bwNEZTpq5tJWvr4l/dhIK61YrcBQFVuDW
 h6lyIJWYVfEWCoeR0xw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603160095

Hi Krzysztof,

On 3/16/2026 4:39 PM, Krzysztof Kozlowski wrote:
> On 16/03/2026 11:56, Harshal Dev wrote:
>> Hello Krzysztof,
>>
>> On 3/13/2026 9:28 PM, Krzysztof Kozlowski wrote:
>>> On 13/03/2026 12:45, Harshal Dev wrote:
>>>>> Except new devices, like Eliza and Milos. And then this should go to
>>>>> current fixes.
>>>>
>>>> I'm not sure if I understand correctly, do you mean to say that except for Eliza
>>>> and Milos, new devices need to change their DT binding to 'required' with
>>>> corresponding DTS changes. And then, the patch updating the DT binding also needs
>>>> to be back-ported?
>>>
>>> No. All new devices must require this. You only preserve released ABI,
>>> so fix unreleased ABI (Eliza and Milos) now, before it gets released.
>>>
>>
>> I'm already being annoying, but I will disturb you one more time for clarification. :)
>>
>> By saying 'fix unreleased ABI now' do you mean to say that I should add another
>> trailing commit at the end of this patch series which marks these resources as
>> 'required' in the DT-binding without carrying the 'Fixes' tag? Specifically so that
>> Eliza and Milos carry this constrain.
> 
> Please post a v3 of this patch for crypto subsystem, doing what you did
> here plus requiring these clocks for Eliza and Milos, with explanation
> why this is a fix thus why this should go to current cycle.
>

Got it now, I will add additional bindings which make the clock and power-domain mandatory
for Eliza (unreleased ABI) while keeping them optional for others (released ABI).

But I feel I should add this as a separate commit which carries a Fixes tag for this:
https://lore.kernel.org/all/20260223-eliza-bindings-crypto-ice-v1-1-fc76c1a5adce@oss.qualcomm.com/

This commit with it's current Fixes tag is required to be back-ported on LTS branches because
they fail to boot for LeMans and Kodiak.

Let me know if that's not good, and I should add the additional binding in the same
commit.
 
> 
>>
>> From what I understood from Bjorn's comment, the DTS and ICE driver sources will reach
>> from different trees and either could be merged first. To maintain bisectability we
> 
> 
> They are applied to different trees. Period. This defines everything,
> you cannot fix it post factum, you cannot fix bisectability afterwards.

Ack.

> 
>> should first merge this patch series followed by a subsequent patch which marks these
>> resources as 'required' in the DT-binding along with accompanying ICE driver source
> 
> Then you have a released ABI and you cannot change it, so what does this
> achieve?

Ack.

> 
> Just look what is merged where and you will see the differences. I don't
> see Milos crypto engine in current cycle, do you?

I don't either. I believe only Eliza has been added till now, I'll re-base and add only
for Eliza right now. Subsequent patches for Milos will know where the entry needs to be
added.

> 
> And bisectability has nothing to do here. You need to fix ABI before it
> gets released.

Got it. Thanks!

Regards,
Harshal

> 
>> changes which fail probe when 'iface' clk isn't available. Of course, the subsequent
>> patch will not be back-ported as a fix.
> 
> 
> 
> 
> Best regards,
> Krzysztof

