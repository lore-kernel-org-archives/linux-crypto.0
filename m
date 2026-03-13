Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61449217F33
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 11:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773402368; cv=none; b=jrMQV7V9hGG1gh5eCnhE9v6/EYcdUT6yEoEnmc6i2W9QGj6+ExJ3lKRHNobA6E5tXFTKImchjuaEQ02YLK0kHRK6XZropsVwa11rUD4ydAB5o6btpyNry/5IfkS9lLg26dFg7nLnybt3/80QyEwSQyOIj7eKaYy0DjOkpDRgKxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773402368; c=relaxed/simple;
	bh=p9gRUw/1sa+IWFsrR/fQYGevFbp+SQEbBTw0TZ645PA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uRz93nku8vzTqCtfTwyWsfdxasGMsD5FrmRetPw8XyABIi7ipngWOKgj5P5Mp/ZX8nnq7DKMZSLgV22GdVKWsRw/pTeCA0XHBd/MnliAaUD9YbRYmUdj2DNpk42DVM6R4aTsW8LVjCOls1zf0HxevGRiqXwDDCbSRVPUwkQnFTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ottyQ+4t; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ORC3YwAP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ottyQ+4t";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ORC3YwAP"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D7JUF0240711
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 11:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EQ6rmuUSOwm1bx/rwcwQuU4u+z1BgbLoQv3BSEX4INM=; b=ottyQ+4tYu5wB680
	A79unT/3TpojUdSQQx0TmsybiGOQF0u+hXII1YgqqR4W4gYA648qRsjgK8QTbyAD
	YWi4UgXmcwudls01G7GZ1Gk3yvI6SPd21vOF+obIfujNXK4AfpXug8M98uDzS75T
	AgNfdRCnDrTRCVu2nGj1y5UL+ZDIwc7ipsAMLucDnHgLE4IqZEX1RAxmfUBRYeq3
	aFmHT8G7T48s102xoNZn6QAkGwjysnky1PannEqIuDYBuxswdXhLzb6PNP9iSu8C
	bjABis1E1XA6xqIlfFPH2d9cZMtGo7TBVgQ8GsTVxpMO3D0KPyYytSwB+zXQoqed
	xNepFQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cve3d8wgr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 11:46:06 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35a019abd6aso2160490a91.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 04:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773402366; x=1774007166; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EQ6rmuUSOwm1bx/rwcwQuU4u+z1BgbLoQv3BSEX4INM=;
        b=ORC3YwAPGkmUp3oAt8KixazmJqFOEmCmPgkafFdRCNeONChCq/UQoafYZEhJ8lp4uR
         a49/hjeBW0weThTL898IunPKmXw/X5GVnuy/ABmhj4E9bEnErfTIQuOVHdxZzXMADtzq
         DOnPINhFqLugBdmD/kvQUnfShp13qLgmc8QqnDVIJUxUobWGzkqwURjWS0oTibVN1MLR
         8y7VjTyv3qAEdV5pGU9/0AcFM3DyXIfnTjp0Ymvb0dp2aElD+KlUb1TuW4GJpc3g50i+
         snlLIZmADIW9CCDAcn7jOmOnjRc0OHqC6j5ripaDtA79H+pEoL24ox7B9MexYroGUVQa
         09yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773402366; x=1774007166;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EQ6rmuUSOwm1bx/rwcwQuU4u+z1BgbLoQv3BSEX4INM=;
        b=aeK2eHe0WQrtrkV8RN063/IJ/jC+l8Ifz5mp5UsDJhqqqbkG9MbMWsPwJoWa9q7kYJ
         XcRvpLb25ej+zleb1RV3eZxdxfjPoSjMnh+kXSv7Z48xAZ9cHXW146Zc8QJdRm6iC1X3
         f/2eulCkZ+4WtuTvCldwRiqdpbSQKl1AitnlAWd625td13EyXflv+74DhWLm8G06TdZM
         VHv+4eqlg6U71f4CUcLD/ClSuOL8sfd5ooMdY0DBzbH2FI1jsfATsc6qxcWtSxtQvBNE
         QdhmdbLv/yF9dehJo/uWWdHY4LCRq/aBzGBgsMTgcxTyBAmq5MbG0QA47JIylb06PFQE
         dATw==
X-Forwarded-Encrypted: i=1; AJvYcCXlDO9U4+mlMfJzX3nfuBPc4SIc/SxoRYx07U0EB4lP/PNd72pJ9QR6Xkb1G0P+sqS/cgAb562PMq4ntmo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyd3zZ66Pzjj92Ua4DO2yoBq1aVT39RLuQX2P50HOGhDaSlHrX
	F+VbGFDziGIOGi64N6fjeucgh+JegTtlt7+HSACcWT6Z9WNW5Rxi35MLUeF+ZVgPhc60+pufYlN
	AA3KIOynPYtnbXcWfRiyblzuL708zccWUPbY9S61k4UCIrw1Oz1fX61dyILawpbi7kcU=
X-Gm-Gg: ATEYQzy1RkxCd/snbkgLK3bN2Hi0b6Zc+HOvYYUsDQMv9amY6YGtvNRUlw4957GSVt5
	YJvSxwhjBht9ko/k3jNcJEYf3yWcHacMw1BuA7FLUknQof1B4h3stocY2lLxuJqxvGOt6QY3VkU
	d0kXZCpWpGf/CmRDyA8FaouWLW19GqvSMaZGagtpO3B6c2DLvkJZT2ra/lZMuDC9M9GVM/pyzak
	cymSX4A7FXTVsmvlaClIyaPOBe4Y9J3Ap0SDSwYqY9LE+1Ss3k5HlyK+oP+2Lcuby53BPBiiupW
	tbeQ0VXOH1kXQTHyHG8gqN1rO6eqGsGX2no6F0Gn6tWcSVTo2+jP0gOPLz/b2rTuw3HbaeivUnw
	hg029Y2cXJmz3ttFb8LPNjhwpsQ0V5RrNM7EcTNJxv3ooaCZNm2U=
X-Received: by 2002:a17:902:f552:b0:2ae:54e3:9299 with SMTP id d9443c01a7336-2aeba51229cmr56438925ad.21.1773402365558;
        Fri, 13 Mar 2026 04:46:05 -0700 (PDT)
X-Received: by 2002:a17:902:f552:b0:2ae:54e3:9299 with SMTP id d9443c01a7336-2aeba51229cmr56438565ad.21.1773402364893;
        Fri, 13 Mar 2026 04:46:04 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece83b35fsm23082215ad.80.2026.03.13.04.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 04:46:04 -0700 (PDT)
Message-ID: <fc3d1ef4-1a0f-41d5-a742-81305ee7f521@oss.qualcomm.com>
Date: Fri, 13 Mar 2026 17:15:55 +0530
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
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <972bd9c8-4671-4151-a3a9-d7eccdf83913@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: rTpdAn72LI7uVsv7l0pNdUod_hsXgRD6
X-Authority-Analysis: v=2.4 cv=FLwWBuos c=1 sm=1 tr=0 ts=69b3f8fe cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=P-IC7800AAAA:8 a=EUspDBNiAAAA:8 a=dbIX2S3wHq3ruR6a9lMA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA5MiBTYWx0ZWRfX5tG7w1zWzVri
 tj//CG7j6QD2L/4E1UFaYtXuBb7Zby+8w66NmSuuBlkNulfN6g/8Ydwep7I7QxstlxJxqPOA4ob
 FZSRI+ISih+15YU4NGqCiR2d7cyTxfDsHERCrxC1yci1R4tTFtutz0OTbXdZokDB8EJ2TxVdzsN
 tqZntwpjWT92QQkSgTrHWtr8XPIV4IKOtsUrHzd65FYWO5+bB6j4CUwh5zyUbxGEhJhgX4DxcQA
 BZ/T6KjRAxzV8oyKUtzDaL6ULp6sVSDrAHPOGe6Knxz3GVeznqLHLAdoOcpKWghkrN2IQ7ahHv0
 v+ulByVP73ZSolMwetnbgWV+lpnn8HSq0Ubl5jBiZKCDaOD1puKDa7Hq0y1K3Ncn6wm7OD2I0MQ
 6aVMqhnUoLF8nKUeukvXgOFMrmQhZT1RSwzaCYZGUBs59/9nMaikloyUcgWvzLTMZ2duFd61oHm
 TCIwIxjp0TQmfJV1qEQ==
X-Proofpoint-GUID: rTpdAn72LI7uVsv7l0pNdUod_hsXgRD6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 malwarescore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603130092

Hi Krzysztof,

On 3/11/2026 11:58 PM, Krzysztof Kozlowski wrote:
> On 11/03/2026 19:25, Krzysztof Kozlowski wrote:
>> On 11/03/2026 10:37, Harshal Dev wrote:
>>>
>>>
>>> On 3/11/2026 1:55 AM, Krzysztof Kozlowski wrote:
>>>> On 10/03/2026 09:06, Harshal Dev wrote:
>>>>> Update the inline-crypto engine DT binding to allow specifying up to two
>>>>> clocks along with their names and associated power-domain. When the
>>>>> 'clk_ignore_unused' flag is not passed on the kernel command line
>>>>> occasional unclocked ICE hardware register access are observed during ICE
>>>>> driver probe based on the relative timing between the probe and the kernel
>>>>> disabling the unused clocks. On the other hand, when the 'pd_ignore_unused'
>>>>> flag is not passed on the command line, clock 'stuck' issues are
>>>>> observed if the power-domain required by ICE hardware is unused and thus
>>>>> disabled before ICE probe. To avoid these scenarios, the 'iface' clock and
>>>>> the associated power-domain should be specified in the ICE device tree node
>>>>> and the 'iface' clock should be voted on by the ICE driver during probe.
>>>>>
>>>>> Fixes: f6ff91a47ac57 ("dt-bindings: crypto: Add Qualcomm Inline Crypto Engine")
>>>>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>>>> ---
>>>>>  .../bindings/crypto/qcom,inline-crypto-engine.yaml       | 16 +++++++++++++++-
>>>>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>>>>> index c3408dcf5d20..d9a0a8adf645 100644
>>>>> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>>>>> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>>>>> @@ -28,6 +28,16 @@ properties:
>>>>>      maxItems: 1
>>>>>  
>>>>>    clocks:
>>>>> +    minItems: 1
>>>>> +    maxItems: 2
>>>>> +
>>>>> +  clock-names:
>>>>> +    minItems: 1
>>>>> +    items:
>>>>> +      - const: ice_core_clk
>>>>
>>>> core
>>>
>>> Ack. I'll introduce a check for this specific name here as well:
>>> https://elixir.bootlin.com/linux/v7.0-rc3/source/drivers/soc/qcom/ice.c#L582
>>>
>>>>
>>>>> +      - const: iface_clk
>>>>
>>>> iface or bus
>>>
>>> Ack, will call it 'iface'.
>>>
>>>>
>>>> I don't understand why this is flexible and commit msg does not explain
>>>> that. Devices do not have one and two clocks at the same time. You miss
>>>> proper constraints.
>>>>
>>>
>>> I agree, it might confuse someone reading the commit message the first time.
>>> I'll re-write the commit message to make it explicit that even though these
>>> two properties are 'required', for the time being we are introducing 'iface'
>>> clk and 'power-domain' as an optional property to maintain bisectability,
>>> and that the properties would be made 'required' in a subsequent commit once
>>> the DTS changes which are part of this patch series have reached the top tree.
>>>
>>> Let me know if any concerns with this kind of commit message.
>>
>> So you are adding it for backwards compatibility? It's fine then,
>> although I had impression you are fixing something which is not working
>> correctly. New devices will need to constrain this.
> 

Yes, this is for backward compatibility.

> Except new devices, like Eliza and Milos. And then this should go to
> current fixes.

I'm not sure if I understand correctly, do you mean to say that except for Eliza
and Milos, new devices need to change their DT binding to 'required' with
corresponding DTS changes. And then, the patch updating the DT binding also needs
to be back-ported?

I'm assuming you're leaving out Eliza and Milos because they aren't supported
on the stable branches yet?

Apologies in advance if you meant something else and I have completely misunderstood
your comment.

Regards,
Harshal

> 
> Best regards,
> Krzysztof

