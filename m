Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BE338AC9D
	for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776433145; cv=none; b=VvclboDv17cDQlHfXCdLbP9m7oN69WwQls8ieZV8ji9vYlvj8ylJa70LXM9/InqDngCMHxZIuhHbQKIlI1+OIsYyquLSRnrGd0NxQ2zXhBmBG3FHs2K2Cn+MEHgqYM2P6HrJR3stDCJbmh92Ha9q9e8b1uoXWId55jTEwNklMRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776433145; c=relaxed/simple;
	bh=t7cDliQXykgBo+DCx8KGKV7xEmgslwFTXM5ZKUO+gQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ss+S+cUm6EA0vKr8O1pvZljGAPIGCZ9n5/DaauJzT7DI7GsY4ApwK0PslicayxdH/uwusjsjsbAVMUbHEe6S0hCSvRX2nhdIaKzRZL1xozO5JDeF1A+AjQxyGld5fDYdxYJmtd9EdpxtOnJF9bjHmSYJ4XnhxoI+B+gmhk0iWbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=feJRt25q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AMGu+fsS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="feJRt25q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AMGu+fsS"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63H9kaaY1042176
	for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 13:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LEV3M/S5NAu+rB8Y3D2M+b+TS/8kFcI0Azn+lMsweqQ=; b=feJRt25q4WzgUEAR
	4WVfVvlSKLpGj4hIBWgd77npJcAZOesM2C0bGxw6cH48+tCT7cdrXZYauu0PxP6R
	5ML1I8CQDTs0PfkXSkAvSaQC+8cHvPjbGNBA3tcQjG7kiEKJf2SXSwE+xAsokKM8
	IjltaVzAPTqAF9bgYHCKEwoxE9OCNEDGw8aMQblpiZZ1n3V1fvf4g1dOWApOMM8x
	U6RqtmEADlmseFdu8PBVfLpEhDlprzkyV7Nd1L60ubL52bCZVQ3hroE9PCBEUhAx
	BYVwDsmaQrpjQVtMme91Tx3ley6jpx3EzDo6+TRnYfJD/BCRggRVTNC+LSK7gBT1
	fufFDw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dkjhdrsv9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 13:39:04 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35fbc53b64bso861088a91.1
        for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 06:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776433143; x=1777037943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LEV3M/S5NAu+rB8Y3D2M+b+TS/8kFcI0Azn+lMsweqQ=;
        b=AMGu+fsSj4VLP6GK49K/1ye+/9bISx/wTY8/jmDsTQsN1AzojmSUiDj3RJwxklK7A9
         lgdO+hbKyEPe4VC5f97m3MwOjn6CfB4qEx8hfinmpuB5VuZlrtxgl2Bff7s+J0s0x6+W
         LowMngZc/6+/vV29Ov42NwibgX3vZEj4sZ4j9IrP+3DSi/xhBl5OW2Ni97Bp/aboP6QB
         8dueOdUbnuor7LJzOHaFIRdvYNSexN2p1itNxy55SJHbcb7eyP69tqjynVcww6eE9dik
         saz6qYpNMiJTGK5xRWwO1W+FeqWPn22EF2CfG2ImodyE7g2JhUject3v0ybZ6MXj5wIv
         d8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776433143; x=1777037943;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LEV3M/S5NAu+rB8Y3D2M+b+TS/8kFcI0Azn+lMsweqQ=;
        b=qcvfnoqu7SCiPDIEIb3MyMlYUiQOf0Vp/rOGt6RBjgu2CPIHofzKjQPwzpbPpzBXpf
         5tIsNxVmbob8f3xKMdjEsX4fs3LD9R9PU7pEZ2/2wds6vmnR6G28BYo1arThnqAP9MIf
         V9KO1NR6Aznloicjo2Qm4EktZlQK+dXJs6I+ALzEMzjQiRhoy9dluDTzmh5T7Y2hBnj+
         Gppg31vWsGuIoduH9Tf+aeAF4BsfsAacqcejdVv0jDahpzvL5SWqkgFCGMBmrPxS3iGu
         prR+zO0FBM5oJUI3Ft/9YpJu38gPU9F4kZXc/TYwNAS1SAG6LrsNy9LuMF4K2DtezqfT
         PP4Q==
X-Forwarded-Encrypted: i=1; AFNElJ+A1vqDGbj3hh5fOrKOdMB1ZBaeJROmZj6Wg1RfYOipXDoP6Pp6lA0L+S1OrCzUn882wAni3QDHpatNZcg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyLOYEq7VJqb7aLq+OgeJjEB3GsH+fsVdyVuRKkPj63HIbk8V4
	Kzd9rwDc+MoZj0IjcVz7aDl5ktCrAgoSM5TOj+j8A193WL+PAXwsA4GK+Hs6jlyFzwc+py+IaFe
	uOo6zgNNPelesAGyoFLCDECjHEcXoRCC5inKOA6yNXRfu7wRRsovj+0MywuzgqC4vKvY=
X-Gm-Gg: AeBDiesoSpZqSwTkzh14AWz8uDNSkf7hy+D2XlkkhMZb5ypwSIhkkkDYKnrAwKvdKt+
	pKXrDhgv3WJzLuO+NU8Ob4525oyPqQe11aOWDtsOSkEJqIDh2rKJYaPxjVCAbU7W8zxSrvL1lJo
	UPQs7ze0WZgkYrkBQxSszhNDBUuJAEVX+lRvlYm6LzKUzvqyEh68K2rwuIBnbrmkiSdI57KNd+l
	xGm5CPCMw1RYXLM8q5yYBL4QHuqyTR8kbEhSys7mVr29kPlcVu4S9S+6C81PDK/T94hGOdnscKc
	V9H7G1j2jbF1tBVYUBavmn4jO1Q46edvzNkompfsvzPj3kDMR7F17QG4uJrrB/QzYFdqfGQ2jA/
	Q917JNIekEMpTOzWoMWRewWgt5BOXY4Meq/iPE6y/CR1LkU5oeHCZyprM5jD2rA==
X-Received: by 2002:a17:90b:528c:b0:359:f2e1:5906 with SMTP id 98e67ed59e1d1-361403bdcb1mr2847257a91.4.1776433143226;
        Fri, 17 Apr 2026 06:39:03 -0700 (PDT)
X-Received: by 2002:a17:90b:528c:b0:359:f2e1:5906 with SMTP id 98e67ed59e1d1-361403bdcb1mr2847215a91.4.1776433142753;
        Fri, 17 Apr 2026 06:39:02 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36141990bb6sm2265184a91.17.2026.04.17.06.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2026 06:39:02 -0700 (PDT)
Message-ID: <0d5bf2bd-b90c-4814-bd2e-126a9bcb82ce@oss.qualcomm.com>
Date: Fri, 17 Apr 2026 19:08:55 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: glymur: Add crypto engine
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        johannes.goede@oss.qualcomm.com
Cc: Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
 <20260416-glymur_crypto_enablement-v1-2-75e768c1417c@oss.qualcomm.com>
 <653fc8bb-295f-4f1d-b9ac-a33e0d8a933b@oss.qualcomm.com>
 <b8f781b0-f7ba-407e-8603-ca504535a894@oss.qualcomm.com>
 <82e0d347-9ac9-497c-bc67-0db9206c5dd2@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <82e0d347-9ac9-497c-bc67-0db9206c5dd2@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Nq_abosuA-wQOgxc2A2NRl6dEpzp3k1V
X-Authority-Analysis: v=2.4 cv=YpQ/gYYX c=1 sm=1 tr=0 ts=69e237f8 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=-7XOZWLW2PA2tXdyhFAA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDEzNyBTYWx0ZWRfX/5/p8T+yQT6T
 IbQiAbSR8bmp0EOB31GT6SAwVE4XGmJXd0Y13MogFHCrCUeu8bpzn8t03LYM6JYFTVmgy7hEABj
 3KXiS39cZBQU1nOgK499f1uYFmxwHCok+ghDuQff1u2kYDAiVScOOGt6gfaDFOouOteRZLUz6uz
 GOsF2s9Zf4LJF8j36YpRmf4hlreMtYULQkFKMmy4X9ik1ytqNLfrwBzG4bDm9vxaT3lRaOUbPWK
 f9X8E8Cg8WykC0+6wgxf0BYSqXMORLEMwXaWkN0mPMDvFQo7/2AgVe5Xk+d+Pu2UvNH3vjFlnae
 /Yi/UyolUrgf0Cg80693oZq2sRxcuDOl7+bBf2wGsSeAVwHkIlC249WzbxlrRIdkJ2WfDegDKex
 vzUsORzIIhTT9IkFL6951YBH96tbKbE/Ee1AJPSuKiLDgJLcKzlh7HQJAdBuhDXqSj6wSIFS4Bs
 OKlkbVj8kPR0lsZ38tg==
X-Proofpoint-ORIG-GUID: Nq_abosuA-wQOgxc2A2NRl6dEpzp3k1V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604170137



On 4/17/2026 4:36 PM, Konrad Dybcio wrote:
> On 4/17/26 11:22 AM, Harshal Dev wrote:
>> Hi,
>>
>> On 4/16/2026 7:10 PM, Konrad Dybcio wrote:
>>> On 4/16/26 3:07 PM, Harshal Dev wrote:
>>>> On Glymur, there is a crypto engine IP block similar to the ones found on
>>>> SM8x50 platforms.
>>>>
>>>> Describe the crypto engine and its BAM.
>>>>
>>>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>>> ---
>>>>  arch/arm64/boot/dts/qcom/glymur.dtsi | 26 ++++++++++++++++++++++++++
>>>>  1 file changed, 26 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
>>>> index f23cf81ddb77..e8c796f2c572 100644
>>>> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
>>>> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
>>>> @@ -3675,6 +3675,32 @@ pcie3b_phy: phy@f10000 {
>>>>  			status = "disabled";
>>>>  		};
>>>>  
>>>> +		cryptobam: dma-controller@1dc4000 {
>>>> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
>>>> +			reg = <0x0 0x01dc4000 0x0 0x28000>;
>>>> +			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
>>>> +			#dma-cells = <1>;
>>>> +			iommus = <&apps_smmu 0x480 0x0>,
>>>> +				 <&apps_smmu 0x481 0x0>;
>>>
>>> It seems like these aren't the right SIDs on this platform.. Have you
>>> tested this patch on hw?
>>
>> Thanks a lot for catching this Konrad. The correct SID pairs are <0x80 0x0> and <0x81 0x0>.
>> (I hope I don't need to pad them?)
> 
> No, you don't

Ack.

> 
>>
>> Unfortunately, I could only validate driver probe on my limited ramdisk environment:
>>
>> [    4.583802] qcrypto 1dfa000.crypto: Crypto device found, version 5.9.1
>>
>> I was waiting for Wenjia to run the full crypto user-space test suite once. I'll update the
>> SIDs and wait for a Tested-by from him.
> 
> Thanks
> 
> I think you should be able to get some life out of the crypto engine
> via CONFIG_EXPERT=y && CONFIG_CRYPTO_SELFTESTS=y (which btw +Hans
> mentioned reports a failure on Hamoa)

Sure, I'll try this, could you also point me to the bug report?

Regards,
Harshal

> 
> Konrad

