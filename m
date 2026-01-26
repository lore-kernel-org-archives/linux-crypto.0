Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10036330B12
	for <linux-crypto@vger.kernel.org>; Mon, 26 Jan 2026 10:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769423374; cv=none; b=goDa/p1dyDCzze8u49CNEWlT59XSopWIfEqpPinWNS15t0K3JDX5gG7qbnflb065K3xwLNPbmgEakj5qV/FAZ3IVkmeI9o2/0lEglUiL/4mCDiMzVqJDeHpei96mg3Pdng8lSGy7qsGOLgdaiAw4t6C6g5M1AHC/fMI1RzjPsSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769423374; c=relaxed/simple;
	bh=4FhbNxBE+2dR/8Ipn1dfar4orfhP1st9tPee/VuPyJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BTbpM5s6u4l06AZsdfsVJ+IaLKPi8jgoFzKyqG0l/Pesg/dthXUCe6YmEsR/1kSLLRFtAPV/OIBO0XhHwZ6NNd1+OJND91THgyAKShe1lcXkOb6XjwJMhiXQ0MObErQJyNFI21Mg1z1V6W096JzMvKzc78rTM05Yug6R5uQxFmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NDgPQV+q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EWSENu5t; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NDgPQV+q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EWSENu5t"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q8OrOp1200312
	for <linux-crypto@vger.kernel.org>; Mon, 26 Jan 2026 10:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cgVTddFUCs+RlMNWUCuNviaUI6E4wDbSvZqfGD79Q+M=; b=NDgPQV+ql4RJ4zoi
	PHde4W5EGExhTXdhMdZICB0OcyIi7mNuN2KluyafXLngJgC6t07+23FYovEfHs2V
	Dt5hkoQzNVsZBXM3F5v/W+6pFNdWLh+IcyKCI58L1tIQ1WrlV+2lths9IeF6hVz/
	CLGUY35p/gMcCLpOeiTIp0CFLFtULAMYSppIgEObRIRSEJIqkrzpE8/zUPAKa6kW
	XRNU7aU7BIFf3gPMOVwAJmoLySw3YAHLgoLIRcDyQURQrBAL+aSx9ggdAhhyH4kN
	zYqa70DlaP+uluEh/C5LQQ0tkvKz84rLcmMVyuNcd51aLatcGfwe8warvrKq7Dcb
	PkGI1g==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bvq3hc715-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 26 Jan 2026 10:29:30 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-502aca58e75so10218701cf.2
        for <linux-crypto@vger.kernel.org>; Mon, 26 Jan 2026 02:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769423370; x=1770028170; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cgVTddFUCs+RlMNWUCuNviaUI6E4wDbSvZqfGD79Q+M=;
        b=EWSENu5tqcQM1s62AmwP0mgBkDzsixAQ3rIX9mzcksubquB4MqI/FuTWHJKhORiqCe
         a0TnsyiY9VO/aTtbK5X+NN81arAkfeCfXgoMLaKpfAtukaJHN/Ly/Xh46ZcJ2zUonb4B
         pA2C6JKdAMSNQT3CP3XrnMcNWoAY/giiG4e1rezr8T5wuIzwUf7jPFdSXJcy3H6QQ5ID
         4cudz5+HKf+frfzFBV84wOlD5aa3q2B6NpoYxffasbkP/gnY9uEsrGAQRgqS4jiRm2JL
         m6OkSOGpDuz9QC7oUmuBYjsYp2aMpxfaj1B6mdXWOERRUq+jsm21ktmgrf+2vSHX2fRC
         gJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769423370; x=1770028170;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cgVTddFUCs+RlMNWUCuNviaUI6E4wDbSvZqfGD79Q+M=;
        b=nMvd8QUSNrC14oFr1U/070nK4uu0Smtmedv2T+qZdFSmCjAUKkYMu42Gx3Xcke0Zng
         0OydQsdTTBf37Gsb6npUacTGInQ08ghbQ3cv3JuZNpbMrV/VQanDFHXQD7ylb89xtHTo
         j7mscS0HKHCMVc386r8ybBqUma7WN9AaItglhkIcK/ajoDfpkKzbntjFvHeB/Z4N2rer
         USPs7alKiqoFLS9UdmM6nwPHvFyL+jnXd+lfeyAvcI6j90msKjSMxJlMSYBCysBovmEG
         3AhjxGuz6XR1QDdwqegKrQFRjFpQSMekLicO+gZQpXPrLFwB7aKLheabadY4fYRk0pcC
         oQ+w==
X-Forwarded-Encrypted: i=1; AJvYcCWDLkxxSabzaHtx5ct5fHCzHn4Pwe6bkwFodhShuH2ZeqEUDyN3bfFK8lg24wkejiVIGQWnuYa8cNiduEk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxjuuiwm5aLJEq53dX+0aLnQ8xNSkF5H7h39Kr6KCgOj2ZU+Do
	AhM//6LYaVh6iyImGt3Q0P7UP+Q+N+fDCyhAhcZPw3z23/Vpbl/dztWMfYpVABl9WYi58jGoKsP
	8POB1NtE9uK9qjvaIMULSgZNF9UbJXHTqOJwEbLU4TqVbNuWdcAeJ5OSxeHpEbylInus=
X-Gm-Gg: AZuq6aKaPjiOoZml31p4zYtwNQlQcKwNs/ysBfSj/mZKClMn7zXUt+s1tAeyOXJnKHl
	UN7wJ5EWPcTIPY4DpNCrRrnKbOM9Is+xWdR8b5OEV2Fq1K9knISInQev1FuSUw+FyqPUHtejp77
	03FM0vi4AeFKdALgkOhe9ow/SwBF35lT6XiekfO01ig+VDYsnNeXqeaUP92ail2L5dZj5jKQms8
	ZlUSDSn9sZuCikqI45goU/c/cJZWz98XfdG5yK+8gkh8vVoMJ2rfYAwS85dqkN2r6howckd28e2
	bERXqxj0aOYNgdVvzk1pQTI/pbgfQiRp3weraffiL1Z8hpnfzmGOBCs0jCHrhQlXzRnChkZe1sp
	pJqqzJkpMGArZtyJN1oKlT2pelYVqnuJ2FBTOe+bakCL1NErbEm8s/V3AmWfSjugXOoU=
X-Received: by 2002:ac8:5aca:0:b0:501:46db:6b2b with SMTP id d75a77b69052e-50314c89aa7mr36422001cf.9.1769423370196;
        Mon, 26 Jan 2026 02:29:30 -0800 (PST)
X-Received: by 2002:ac8:5aca:0:b0:501:46db:6b2b with SMTP id d75a77b69052e-50314c89aa7mr36420901cf.9.1769423365000;
        Mon, 26 Jan 2026 02:29:25 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6584b96cae0sm4770473a12.33.2026.01.26.02.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jan 2026 02:29:24 -0800 (PST)
Message-ID: <7216c86d-2b87-496c-9548-ccdcb3c98b6b@oss.qualcomm.com>
Date: Mon, 26 Jan 2026 11:29:21 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] dt-bindings: crypto: qcom,ice: Require power-domain
 and iface clk
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
 <20260123-qcom_ice_power_and_clk_vote-v1-1-e9059776f85c@qti.qualcomm.com>
 <14a71b33-4c10-41b0-a6cb-585a38e05f56@kernel.org>
 <06160c6c-a945-467a-be82-7b33c5285d0f@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <06160c6c-a945-467a-be82-7b33c5285d0f@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDA4OSBTYWx0ZWRfXxPPnWlbSKF0/
 dGCendipfRGGAFIYIPLDG0zgtIpbEd/JbesAt5vDRq2BFACb/uqFKHMkNT+2j8zF4TxJAlznT3V
 JbolJ24GqTIiCGUMI1kEfpibEIqiG/3Kp5dKYkR4oK7XEzQR2EGHupAj6wCTdPbmOnctksYxcwu
 3Bc8GfT9JeI4UqnwvRCQIO1/5kCKIYcm+lPSXwR/4nP6//r6a0w1e13a4HzDQA23aNmuowp23//
 IpaAYASu5ByvdlYuzSd7folzLLn1M0f0AvqBTJxLmEabu5ulNLy2hw/D4QJJvVTd4gupGogxjX9
 AK3CdQ5k/TddxpOESSo8LKssHXIr3fKFBkK+JbCjL3Hk2M7UbohPOYcG4ET7Ql5TLuHF4l6LLTv
 pMK74r7BNHJD2y6QJ0B0BwdcmUXWIY1Xc0ZdvxhsPLSlFKZituezNOhNP8HjH6614TrClrIqFAo
 6iceSzFYGEbkb+7bj3w==
X-Proofpoint-ORIG-GUID: MlKrKDAeerB1S7QbEWfhI6vDCLIIitXu
X-Proofpoint-GUID: MlKrKDAeerB1S7QbEWfhI6vDCLIIitXu
X-Authority-Analysis: v=2.4 cv=c/imgB9l c=1 sm=1 tr=0 ts=6977420a cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=8ImHDfJAwSrsxWKzuGcA:9
 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601260089

On 1/23/26 12:04 PM, Harshal Dev wrote:
> Hi Krzysztof,
> 
> On 1/23/2026 2:27 PM, Krzysztof Kozlowski wrote:
>> On 23/01/2026 08:11, Harshal Dev wrote:
>>> Update the inline-crypto engine DT binding to reflect that power-domain and
>>> clock-names are now mandatory. Also update the maximum number of clocks
>>> that can be specified to two. These new fields are mandatory because ICE
>>> needs to vote on the power domain before it attempts to vote on the core
>>> and iface clocks to avoid clock 'stuck' issues.
>>>
>>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>> ---
>>>  .../bindings/crypto/qcom,inline-crypto-engine.yaml         | 14 +++++++++++++-
>>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>>> index c3408dcf5d20..1c2416117d4c 100644
>>> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>>> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>>> @@ -28,12 +28,20 @@ properties:
>>>      maxItems: 1
>>>  
>>>    clocks:
>>> +    maxItems: 2
>>
>> This is ABI break and your commit msg suggests things were not perfect,
>> but it is not explicit - was this working or not? How is it that ICE was
>> never tested?
>>
> 
> I took some time to educate myself on the point of DT bindings stability being a
> strict requirement now, so I understand how these changes are breaking ABI, I'll
> send a better version of this again.
> 
> As for your question of how it was working till now, it seems that
> things were tested with the 'clk_ignore_unused' flag, or with CONFIG_SCSI_UFS_QCOM
> flag being override set to 'y'. When this is done, QCOM-ICE (on which QCOM-UFS
> depends) initiates probe _before_ the unused clocks and power-domains are
> disabled by the kernel. And so, the un-clocked register access or clock 'stuck'
> isn't observed (since the clocks and power domains are already enabled).
> Perhaps I should write this scenario explicitly in the commit message?
> 
> To maintain backward compatibility, let me introduce minItems and maxItems for clocks.
> When the Linux distro uses CONFIG_SCSI_UFS_QCOM=y, we can do with just 1 clock as
> before.

You must not assume any particular kernel configuration

clk_ignore_unused is a hack which leads to situations like this, since
the bootloader doesn't clean up clocks it turned on, which leads to
situations like this where someone who previously wrote this binding
didn't care enough to **actually** test whether this device can operate
with only the set of clocks it requires

I believe in this case it absolutely makes sense to break things, but
you must put the backstory in writing, in the commit message

Konrad
