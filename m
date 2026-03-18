Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381A9368268
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773829845; cv=none; b=FRjCZgjsb8odCUadx4IzH7tvx256ZLib9WYVc4FA4d3IbKdFI6h3ab8yT+lqTpE6JlG8tY4yOCHm17fYBUVdV4geQq9TQCPE5NH6uYOsFlWJFUTvy73ydJiAzcsNIlEyh97leyxBZfpPclMOiyg+6Ruk4Md5Db3tqZiJXWi7Q08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773829845; c=relaxed/simple;
	bh=BXVKsVW5KX0qXXNdYZMGppyZopnLVN7FUFFMlRoCCxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gz66r7DK5B/5N11SNjnJ0iTYj9pPageHL7X8gU+miAxjYHl+npfrxLa4sOOU0aEmXH0xd0opkGh7Y8fTjGoT65WoIXm1cWvrca6YO48vsufBEvN65/t2r8CPz+ER/PRkr9oenMSEMIlJ/rD9SK2JsvsUONN1BmG+DtAfofZjaCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jisUF2Ry; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PcyM+Xf5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jisUF2Ry";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PcyM+Xf5"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I9BQQc2294016
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 10:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aOwk4wZNbzlxHVoMnSwlBHAbDQLpKXe/fZRAqQC3Ofg=; b=jisUF2Ry0nJJQTGm
	OCYR5+npAjgEi0uV7WP9RCX6yegltmQge7hA7XiwlTCFZR3iBLWRvAhAzBj4xX0m
	kr1KSGmOAqsYaeoX3oprrDcV4Yoeos2IVeW/Mznwu+9x4m4XVc1eKUz0cxkSz/u5
	jFYhp9Rjq5FXJYsHU3MPPuk9njWq8Y/lg8IVpebfjjjzV9bRRvMwCBTgDZEuzTbQ
	b7vneO2owUtpYK/LCob3ltFPcMMK+SDIU/ioHQdX8QXOiZx2Y2cVpP3MMaMUQ4GF
	QOKhu6LvNPGPAyUOnWmy2b/IQZ5YS+GvrSLP1C27sbTLnyKJ6MpqIG/v+AsF19s9
	mFJUeg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cya83ux11-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 10:30:43 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35b8da51b3eso4671241a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 03:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773829842; x=1774434642; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aOwk4wZNbzlxHVoMnSwlBHAbDQLpKXe/fZRAqQC3Ofg=;
        b=PcyM+Xf5yN1uAGaDgMJfgZ9BoLu6fX0pKK8EGVwEXK3q5fWrl27zqxDCrdq6ocJQvL
         WkMiPlNv3UueyJGSW0PM7tfskoQBgHbRu2KwhK001sA5Cz4TBhQE+UEtPJzr1ws/pdiZ
         DtgyDQJh2iUt8j6Ovnckl74gs9vexhhJCrF5qIVb34WVhQQYAB3pxzfPsmngEAAcw1us
         nkdpRHXuut8mhpcxV5TiK1XAdP4kB5bpJHTKGUiuCRDxbd4QnekJm+sNKcJagUB/FO9U
         9V8I0XpJWyMveWIIXmzpPZnrXId2SA1raEK1TR4ne2mw9TUFm62yP4VfmhKXKWWSnJWh
         PqJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773829842; x=1774434642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aOwk4wZNbzlxHVoMnSwlBHAbDQLpKXe/fZRAqQC3Ofg=;
        b=aFBKaieyaTLMcsPKtcREWD9Ntcp06+W1Q50ayK1pBDGyRbdJsghOCz9QK8xuuJ5VNL
         mBUgZGx0nXBMulLOIYOocIJ7e/+aA5k53lczlE7JiL4AgD7HUhx9ZSp/bOX1MF4SaeeV
         TdwxE92ShcZ7EnB+OySF7RpIAvEmq+PtDJ8bdrS1MXvAJg9m8yeGYk1MNxHSDh4untxu
         FJh2etSdWjD6lZC/1EEm9EODHSDLWxzv214/ZLvkX298Jji4j9qfJaj0OSiYIVc+yu0b
         tsFOwgN+oBKMATjVy3dHaJktM/x3SdXqO05zBbuwoxegBObpMjqUPZl7c1ITK+z8imbv
         satg==
X-Forwarded-Encrypted: i=1; AJvYcCV/mebE+KzfsdhK/FcZ5e3NlN3L3cN+oap69uJgaU7qyRL4s5IsS/A8KVuoiy8Uv2bwyCZh2WAEw3A6rjc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf/EnDqdoFabcP/nda0zKfDN1EL0bfmaSIjJElhBaVsPgoYHf2
	DFAGbHBfR39NDy0vhqvZdihHsYDz1ngSo+4e6qRM7GtU41bymh5i+7e+dqXpoUhTwKDbERpd/6x
	7AK5+PrlbgKMdE2oEBbzO/DtsTQeRWw00DEtVbcHqkaozchFykmiDlj1Y5xA/uRnap7M=
X-Gm-Gg: ATEYQzzefZ0T9TqxBMp2WnkOTTkKvRxo0QD1kE37V50g2C8WuRG/Eq9iHPqRjE+jidz
	B9AbdlnP4JB2EHpe/2NhCF4MvIBHHaRH9SuGYNYjq8CCIO9/LT9e+pUQPsFtDRUVX++fjLx9ad+
	gov3L/UGv3cb0U57hfYsY//cn0623KLURrubCNcOaB9Kvh3vaTjqKm6Me1RySItO5YBiQs+7H3t
	UJ4xVfAN3MRVUawA5SfWEzLJwjat7gkAvji2d9W61eDAOuRAr7mKxplUV+V6ogDPVpYCKsGeFgP
	L1t6wdLiYoif4GyI24RWQotPmgUdC/x6OZe23ePxV/cnOB8RVUVetQ+InnRWJh7biN3uK2I1JWJ
	g47joaFgK2jtetKX8vCBL9F71e1p5aonm0T2X3r3yZwFrnhNUQQc=
X-Received: by 2002:a05:6300:668a:b0:398:71b6:33aa with SMTP id adf61e73a8af0-39b9a08bf3fmr2812528637.64.1773829842387;
        Wed, 18 Mar 2026 03:30:42 -0700 (PDT)
X-Received: by 2002:a05:6300:668a:b0:398:71b6:33aa with SMTP id adf61e73a8af0-39b9a08bf3fmr2812500637.64.1773829841903;
        Wed, 18 Mar 2026 03:30:41 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c741dfd4090sm2146786a12.0.2026.03.18.03.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 03:30:40 -0700 (PDT)
Message-ID: <24d4926d-63d0-479d-b938-6438364e9998@oss.qualcomm.com>
Date: Wed, 18 Mar 2026 16:00:30 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/12] dt-bindings: crypto: qcom,ice: Allow
 power-domain and iface clk
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>,
        Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
References: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
 <20260317-qcom_ice_power_and_clk_vote-v3-1-53371dbabd6a@oss.qualcomm.com>
 <do62iaopjcahvn576gfcdbyo4yxudf4uit2sbifvjw3pwrlb7j@higm25fdesk3>
 <20260318-aboriginal-peach-bird-cacb8c@quoll>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260318-aboriginal-peach-bird-cacb8c@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: irKzHelbC92tVbEDPQF--V50mpJp_x-X
X-Proofpoint-GUID: irKzHelbC92tVbEDPQF--V50mpJp_x-X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDA4OSBTYWx0ZWRfXyWcYhowW/aG9
 aJ0+DrfMj2mtYDASTiblNizDqWEUzIsFJmErEXCnYFzwLMSr97yB9DpkQRhvdyyceocvfEH4cRL
 5o8UCyu60Z4WAp8R5sJT+UPfzYbqSkL8wyxOH61fR2vjdPzjtitqrZ0AoLI2k5kY6Z5xkZ/rr3G
 U/PF9D3eJk45B5CLylYgH5DcgR04HWOgrpm5KfVRDeMzPLd2fYfMf7URMxFoDWrDnqySqX5UvmY
 CtqagcznMmMWrEPZ3biAr5KZcmbhP0ytUz8PR0qqv3oNl1VONoCZmvNSAR7HNCO3bj3FJZT2crT
 cZBtDZ7fHutsLSTUU5SQZg74LD9w1xWAJpbqI1fYMuQl5gYlljSCCF66W8E7wUsrWzDI0QJF/tZ
 jlJVmMyKcK3giXRq1F4czeriDXOyQOBgiNB71ptmo5sOY/UwRbxIh5QYIFReuz5k73ksR/k5fmw
 WysNy7T0K8kySMyKEfA==
X-Authority-Analysis: v=2.4 cv=Y8n1cxeN c=1 sm=1 tr=0 ts=69ba7ed3 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=bjjNJb0cNGASWl-KbwMA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-18_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 bulkscore=0 impostorscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603180089



On 3/18/2026 12:52 PM, Krzysztof Kozlowski wrote:
> On Tue, Mar 17, 2026 at 05:12:36PM +0200, Dmitry Baryshkov wrote:
>> On Tue, Mar 17, 2026 at 02:50:40PM +0530, Harshal Dev wrote:
>>> Update the inline-crypto engine DT binding in a backward compatible manner
>>> to allow specifying up to two clocks along with their names and associated
>>> power-domain.
>>
>> This should come after the "why" part.
>>
>>>
>>> When the 'clk_ignore_unused' flag is not passed on the kernel command line
>>> occasional unclocked ICE hardware register access are observed when the
>>> kernel disables the unused 'iface' clock before ICE can probe. On the other
>>> hand, when the 'pd_ignore_unused' flag is not passed on the command line,
>>> clock 'stuck' issues are observed if the power-domain required by ICE
>>> hardware is unused and thus disabled before ICE probe could happen.
>>
>> You can simply say that ICE requires these clocks and these power
>> domains to function. Accessing the hardware can fail if they are
>> disabled by the kernel for whater reasons.
> 
> Yeah, mentioning clk_ignore_unused/pd is redundant here.

Ack.

> 
>>
>>>
>>> To avoid these scenarios, the 'iface' clock and the associated power-domain
>>> should be specified in the ICE device tree node and enabled by ICE.
> 
> And this repeats the first paragraph.

Ack.

> 
>>>
>>> Fixes: f6ff91a47ac57 ("dt-bindings: crypto: Add Qualcomm Inline Crypto Engine")
>>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>> ---
>>>  .../bindings/crypto/qcom,inline-crypto-engine.yaml       | 16 +++++++++++++++-
>>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>>> index 876bf90ed96e..99c541e7fa8c 100644
>>> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>>> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>>> @@ -30,6 +30,16 @@ properties:
>>>      maxItems: 1
>>>  
>>>    clocks:
>>> +    minItems: 1
>>> +    maxItems: 2
>>> +
>>> +  clock-names:
>>> +    minItems: 1
>>> +    items:
>>> +      - const: core
>>> +      - const: iface
>>> +
>>> +  power-domains:
>>>      maxItems: 1
> 
> 
> 1. What the DTS is doing here?

Okay. I will add a description of the expectation imposed by this binding on
the DTS in the commit message of this patch.

> 2. How did you address "with explanation why this is a fix thus why this
> should go to current cycle." - where is this part?

My mistake, I will explicitly write in the commit message that this change
is fixing the issues caused by missing power-domain and clocks in the DTS
by preserving backward-compatibility for old devices and constraining these
resources for new ones, i.e, Eliza and Milos.

> 3. Where is Eliza and Milos?

I will merge the unnecessary commit I introduced as Patch 2 into this commit
and explain that we are making the clock and power-domain 'required' for
Eliza and Milos since they constitute unreleased ABI and can carry this
new constraint.

Regards,
Harshal

> 
> Best regards,
> Krzysztof
> 

