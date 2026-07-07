Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F375376A02
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 05:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402484; cv=none; b=BLqqv2aPQ3YAjgHaicoFJl8LmXx0b88LOmMX7DAPvoJ9cuQXkywzuYr5pW/FkeLz+H6FhaE6GYOsReZs/SygIJqkmFPBlVuI2OIrgQi/hzOi9ycAleldlDU9Bw9FrV76vHMjF4m1NX7mMcJ9pQRXJwT42vSiA7kOY3c9bNOu6Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402484; c=relaxed/simple;
	bh=6gUJmEQ7gh2OVod4PlGCDo2UYQU2TxUMTLZmwW4INZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gw1tDQgTFNg+an6m/atyG1apN7xwSQeon+EQT0TQdDMuCNchLlEDFV95SSgbUA+o2rEyWmJ2bwJAzeLCrRSdeo613Xz5HohalRW5J2yHXnV40roUAsVhvhoyVmkJNSIAf4gWDknLjPxZu7BNjnuzgFG28Xqy7nLtdkvk8xBvAnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=goKEBfAs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BIHnlfEq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="goKEBfAs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BIHnlfEq"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66749GZd2658259
	for <linux-crypto@vger.kernel.org>; Tue, 7 Jul 2026 05:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	J5y61QSWVlQeeop/0EzUtwGiLotqpcy/KmZCwpdQ1Jw=; b=goKEBfAsewj0Z2Cy
	UGR1y5P3xcYq7gCpS0Owxr6dGO+uI1+0NmVs2aQ4qQ1azCJn79x28aNGe9xUAtVS
	ot+dTVw55poQ0RfvHkvhyV5Xoa2pxqcbZF6+gBKN/nB+WMqDfG9HLLzFmPMbsiyH
	OfJ2EBdrE7HVwD8ttZzsw2VcYR7UhBmcTNVSDV4tnTkBsa0/I6pKqCEKKxJmpnIs
	b5KLFUHwqI6Wv8dVn7+y5L4eTJN76rUlkd2HOqmjVu3HS+Kfy5dM+MgQHb/bzMCD
	JfHIeirUnsTXwPE0tzD5EKp516daVqJiz2BGvz/xc+2XKMCRneSXIMQk5aFSKYYV
	wlNdtg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f8a3r47sf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 05:34:42 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c88fc985a65so6500145a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 22:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783402481; x=1784007281; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J5y61QSWVlQeeop/0EzUtwGiLotqpcy/KmZCwpdQ1Jw=;
        b=BIHnlfEqDSAfhCTzHDFfekQXEkoHNzZm0pGt+DCZae3xC65P+3zrdFiNSjJwDrzeaY
         qjqlFKRkPKHGCdfylhoQJ7R5nIFdz/6xQ2huhpNKzUD/apN0tmOKE9BBAKBMQ0fhdl8C
         TM325qzAbFRPgbAgOYdo1Z51oBZpIEuR4BbmF5SaCROTh4qxbqjaugKvp3EMXjqcQdAa
         BIwwLO4BRHggpLPFapOReFUsY/BgP9ZSRF2QaxwR553I0NJyTw7f6EU/cb/yCV3fInbk
         cQG1DXaRxjcf1Bukmau9GWjm5psGAblB4Td/sqcKC8Rlz1N3QIwEXIoKxhKuzkxzBGpv
         p03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783402481; x=1784007281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J5y61QSWVlQeeop/0EzUtwGiLotqpcy/KmZCwpdQ1Jw=;
        b=jHCrc06G2deQm3UYzveGEahSOLsiC7/uJAAzRPUzoL6sTo1UQRQyyBvlZt0onKGSro
         M7RgLu17sCiBxt4ZA4BglwabrOs+1s1jNPT25adkwpLSwV4bP1RFp/MhkOqHFNYy8ncl
         GFuDhbGHIEfRT2+Qvrz24hJur74yLeRUxQy8q6hl9XKCdg+zGerB4uVnVrFrFgnO3VpF
         GrZw9+xgeperoFx5ACJBZbJZQchw3hMcBQwuxgmufYNyqgPdUx8uE1CaJww4L27vRbOA
         QUEt2RSKmoisf868x5vrPEFsITyzuokHeeeferMy70i1SPs+gCixSieS6VGYUV88DS86
         0ZFw==
X-Forwarded-Encrypted: i=1; AHgh+RoLUqCWHwSV030HmyG9n4T0ctJVRCxSc/G3Wd43G8GpCSmIadVb0YfL8OWoL19WoDyCyG4URCT8jKjkYVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLqYAlHdvdv1VVfjZm4nh0x628243sVR8bIGXwO68X/lzk+rX1
	JIhb4DYgZ41VktAryzLekFgoPzHOMye/NMHJ6ec2v7WPXG2LIagfq49HjY2VLQNgoSygNRF6fqE
	CQVrvaw3OzcGOKfoQb3WrKXM9CCcJoZLCs6mwqtvofkxsGyA5vd2L36Px33rlc5bACU4=
X-Gm-Gg: AfdE7clait8w2RodJ1shFlZEg0F+EODzSeYr5FbkFbEA7iufuaYMJt1AKMEICIqVcX7
	FElLx/yJVR5fNrglKqRRLMfzUZKMZitM6iCLMnuNl27fZdvztKe7ncReZ8MdACMweI4P85JiRhz
	axA/DPkDVSTRsnci2i3jQewivdAWX6xTSCfzZQ4xLh7faHRvQ9vh8HsBUq7ZHoYUDeI/AVupoWw
	oW7ZebRPrb37WkGvEm2UBHSAJRORVYcNTaGpxA8WqpNpTc2ovMjNKLMI0BvhGyn8fGJt1pN1mWp
	JTZzOQReccd1JdXSQAaEVgmnlduHKQ9Sany08f+vNNsctkNZKh+45RsYES2FSBf1hrWaQa1HYVo
	lbyhKAUxAuhr3wmzgKlLzyJpnuQ8y3s/cS2spLvxa
X-Received: by 2002:a05:6a21:648a:b0:3bf:a9cb:b799 with SMTP id adf61e73a8af0-3c08ef902e9mr4691637637.54.1783402481075;
        Mon, 06 Jul 2026 22:34:41 -0700 (PDT)
X-Received: by 2002:a05:6a21:648a:b0:3bf:a9cb:b799 with SMTP id adf61e73a8af0-3c08ef902e9mr4691604637.54.1783402480647;
        Mon, 06 Jul 2026 22:34:40 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5afeb060bsm398917a12.14.2026.07.06.22.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 22:34:40 -0700 (PDT)
Message-ID: <cb8f0ebf-8afa-45dd-b2fe-724af7e0b73f@oss.qualcomm.com>
Date: Tue, 7 Jul 2026 11:04:34 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: glymur: add TRNG node
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
 <20260424-glymur_trng_enablement-v2-2-0603cbe68440@oss.qualcomm.com>
 <814cff7c-fc03-42a0-93e6-852598943ac4@oss.qualcomm.com>
 <0debc1fb-f6ae-44c6-aa87-d5ef3e39b47d@oss.qualcomm.com>
 <b4794e93-0fd3-4559-9ecd-02d679bd06b5@oss.qualcomm.com>
 <b5287c07-24b1-4011-9805-529f6f51c22f@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <b5287c07-24b1-4011-9805-529f6f51c22f@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MCBTYWx0ZWRfXwouhmg570zu4
 +xhDhLsxp5BkNQHwILfpcZN+/f1qIoDXfMjfpOaMwN0ou+LIz/ouwXVwO+3JDSulm30Mm0UlCe4
 WhkEcSL7JhVXas8Cmx0k0FBIzSudnJTt52JbxPnH+uiy+nfRsw2gnMAq/4NBD3kA+1Sun7hExK3
 oYNPcWWhW1jIn4VoifL40ChlNuyu1PhejLrDqgK38wYDuDTTDTqdccyfAxfUBJGUoJuaGydKYT7
 Vwxk2CwV0NlSB9+Km39M1JAsCscmXrEk6+lAcP4gL4lxLMBP1q6lZ7Z1uuCqUeIwSt2JF4CL20+
 fDGTF9bSanp85b3zwwEoa0zxc9RDtBHeYB50Digq4I8peoqrztwb16YEZ6fla1ip/mDzJVsGRv8
 MnoFo958WiT9fc+fg+m9MvU0Be6ljJBCDq4TiWmjqFqcW3n4VY4dRpqubhdPXD1K+uaEwk1vj+J
 WX0CrBnrOH5j823u4CA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MCBTYWx0ZWRfX2/upv4fcX7S1
 wW72izHZHiZ/Hs00Kc+eiWPDT8uYHHFPSV8tzKHbMLhkQXZ1DdG0Ea1H0/jnFZFgA4P6IZ/m05a
 5Ur0JzohnFNNU3C7XetztWXDmidjjg0=
X-Proofpoint-GUID: gT0uzrt25QXaF2V6Lj8S7R3WG9hxQdyK
X-Proofpoint-ORIG-GUID: gT0uzrt25QXaF2V6Lj8S7R3WG9hxQdyK
X-Authority-Analysis: v=2.4 cv=OKcXGyaB c=1 sm=1 tr=0 ts=6a4c8ff2 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=FNHKQYERf4qwuPYjk0kA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 clxscore=1011 suspectscore=0
 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607070050

Hi Konrad, Bjorn

On 6/18/2026 5:50 PM, Konrad Dybcio wrote:
> On 6/18/26 1:58 PM, Harshal Dev wrote:
>> Hi Bjorn,
>>
>> On 6/9/2026 12:06 PM, Harshal Dev wrote:
>>> Hello Bjorn,
>>>
>>> On 5/18/2026 2:06 PM, Harshal Dev wrote:
>>>> Hi Bjorn,
>>>>
>>>> On 4/24/2026 2:05 PM, Harshal Dev wrote:
>>>>> Glymur has a True Random Number Generator, add the node with the correct
>>>>> compatible set.
>>>>>
>>>>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>>>>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>>>> ---
>>>>>  arch/arm64/boot/dts/qcom/glymur.dtsi | 5 +++++
>>>>>  1 file changed, 5 insertions(+)
>>>>>
>>>>> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
>>>>> index f23cf81ddb77..64bbd5691229 100644
>>>>> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
>>>>> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
>>>>> @@ -3675,6 +3675,11 @@ pcie3b_phy: phy@f10000 {
>>>>>  			status = "disabled";
>>>>>  		};
>>>>>  
>>>>> +		rng: rng@10c3000 {
>>>>> +			compatible = "qcom,glymur-trng", "qcom,trng";
>>>>> +			reg = <0x0 0x010c3000 0x0 0x1000>;
>>>>> +		};
>>>>> +
>>>>>  		tcsr_mutex: hwlock@1f40000 {
>>>>>  			compatible = "qcom,tcsr-mutex";
>>>>>  			reg = <0x0 0x01f40000 0x0 0x20000>;
>>>>>
>>>>
>>>> A gentle reminder to pick this patch for the 7.2 merge window.
>>>>
>>>
>>> Another reminder to pick this patch up in-case you've missed it.
>>>
>>
>> Gentle reminder.
> 
> Bjorn and I were both out at the time, after we returned it was too
> late to accept new patches.
> 
> Currently we're halfway through the merge window (where Torvalds
> receives pull requests to create 7.2-rc1 out of), during which
> contributions are not accepted. They will resume in ~1.5wk after
> 7.2-rc1 is tagged, targetting 7.3
>

I believe we can pick this up for 7.3 merge window now.
A gentle reminder to pick this up.

Thanks a lot!
Harshal 
> Konrad

