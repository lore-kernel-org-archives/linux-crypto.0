Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BE83803F2
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 06:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780987000; cv=none; b=J+LVPkWCPcrwX1C2brM1l8fWpeOjI7+SuT7CGkgRcdeB69OI5xpyEfJbAeOW2q7z/4EpStBS7VWLqHs0f2QPdqK4OsHSwJuKMVWg0+mD4b8rgcsqA8ltk/aUVxTm5eku2GUhMPMUGUG+PnrfTMK0nn4Y4Z9SuFVv0culefHH0A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780987000; c=relaxed/simple;
	bh=oKeHTCClEnzlDhjKldDN8fmFaL+DbHLDQswkC6zCsg0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=cPEHojI9kQHgHugp5Qk6J3lf2nrecv+K7yVwiUO8J5IMIola0Im8QTYd1hSYFNhjHpoeLGDaXU95NgceNozDv/LLTSM/OJZz+S3YPf3TH3Gv+dCS7A0tb4bHRVZEm81VG11H1Vf/lSQfSZpuXmcuYPx4jpPnuhBMT8dL2Dak8jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hpnnm/sL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hvx4h2Cl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hpnnm/sL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hvx4h2Cl"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6593wZxX1060931
	for <linux-crypto@vger.kernel.org>; Tue, 9 Jun 2026 06:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6rwejrAXe9v/O/1lr/ak/rj4FZszxsHovCpkD4lij34=; b=hpnnm/sLyW9cKdl1
	nH7rTWeatKi9LJPam4wU+PejBOmnHwevAOC/iC9La6VA41TkV+40W0EwZGKVPeeg
	rAgAoj26gbaUtvDWfJ9FDe7AdBUOU+8dT7PNlVS4H4FcuWqgLg2qTiTTNkhtGp2r
	+0E3Jvn293VwaIy+5gG1k1D0Nm1cztz2HSr3dBYC0qxW356KARl8Q4yqkluVGeEC
	DjEG34JM2agdCM/clAO5+9homihYlBc1fIHCOSIHxjAAU0J/B7hhvanvDxQcXOdF
	JsHo2H9tE7XfKRTiV/aZDx8gK1V/7m5CIt0CNERGKRgMsSSOC+fMWoPBvbnwXk/H
	0s1gkg==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4enun44tn0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 06:36:37 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8424aac207eso4790718b3a.0
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 23:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780986995; x=1781591795; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6rwejrAXe9v/O/1lr/ak/rj4FZszxsHovCpkD4lij34=;
        b=hvx4h2ClQg3zWo4zXfa5zzyhsavCzOaW8L53VH7BPZqE1XGd9U7QY3vMTk0A2nn0EY
         uxFsdf5XyTfCCOuUucycHcCWqaD0LZHPyi1J6x0g1pf21qol1EfBK4T7zeSS/SBGOS03
         Cw+uKuNCbkxZ2nFBtQO59R3swO4XtLelt62+xvE/OMysM9+ihPf4A0bKrU1AowR64G1g
         1ZFzHgx7WPSWhSqyX3jObP8n9wgWc6grZtMEdwS/9dKYQ/+chR9bHwxwlq8+jJuddlYs
         EGlLVm/KSuLSBkVeis+UC+o6q6T8ZSJhbnXZNrJtOM5jejVzCrVCj/+9cJbnj6yrYefx
         5l5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780986995; x=1781591795;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6rwejrAXe9v/O/1lr/ak/rj4FZszxsHovCpkD4lij34=;
        b=LUY/bTwF+mQt9cLC3m6wtLdLp9MSOTnUmHcSdRdgTSDDbalgiBiqpP+l59hQfwbygF
         XCYMNxb9q5vExywZA2OMwxJERAfN6kGIWH9ZV3bvj+4yKy9jHAn9rqo9lIkmrIH1o9Y+
         /V0rmnQZjdpohNVrLUWhDN87LgqiPRXyLP8rxZeFEX8E+3oPNav4s/F+US3AFu740kw6
         NBWwP9J5Yv8IgzL2LNpRI1sXZvEsRyMkuUYEWK+g5Nuq73ughNI8kHOtONXkXF5lQvGP
         e7GhDGsE2QknRA+eytx4wc97q2RIPzo3rT4iDIr7HyLY8ScOqAHIJ+ip8BEzcPLOs7nQ
         3m8A==
X-Forwarded-Encrypted: i=1; AFNElJ9SG9AfDJ5XjeFkhq6B7hXVm68N0gB6gdmOjENaZOKUfUlSCFjT0OWOq3H0d3EATLAUbtsj696PyV9Fpdw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfT/DC9ymyJbX+W8NI4gxs/dWQ/kyLKkz0q5WSMioSD5ZGeLZM
	eKjWO7BTZ+YPnQt42KJFbDBTnNoQzWqvHgi96NIzvzDu0lqcRIrA5lZwg3v8nmgG6h4WJceYtKQ
	Tc+41HFXNZQ1p+Ea1SV33jz/uiOtMSa/uDudzULMlIpE9knK2xt81gjM7p8ByYTPN798=
X-Gm-Gg: Acq92OGANoBbtPglS8E4qOY/l++/i6oQMeDQxt058jSAxLcniLUmJz+G1HfNOnbkpZB
	hWTdB1u/NFOt3GeiLVXhJhRArqcMH9x7IA1zQpB6wgdoNkaTUjKeZSzjALBqe+X+dxWfrzet96K
	bXGEDO/3yO8PDzWsuYkIaLx0DAWMFOgWKsyDKESn37xfVXkpOi813n76ZGkcmXv2oRAJdbH5tRp
	4TenQwT7K+1A81Io1OX+2Cu6EFyUQeRlCZwwO8b3XeWKYN2uX7uN+C3iBTNGZdjbKQMVFdHxZCA
	ptOPFFksXmWbyHgjzvVUxHhFkamJ56m/kKKIpJ5+HpwObcY0R8XXce5hz0akwZRUiDUQSTUA3Jy
	MGFKg29vJbhBXZQ8MEFnSDu7NYdf/R/C/bQ2KHhk8RGgUiVjDclfzQuVBsaFU5A==
X-Received: by 2002:a05:6a00:4acd:b0:837:e9cc:d46d with SMTP id d2e1a72fcca58-842b0ffafe9mr18208598b3a.44.1780986994823;
        Mon, 08 Jun 2026 23:36:34 -0700 (PDT)
X-Received: by 2002:a05:6a00:4acd:b0:837:e9cc:d46d with SMTP id d2e1a72fcca58-842b0ffafe9mr18208554b3a.44.1780986994350;
        Mon, 08 Jun 2026 23:36:34 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282910d1asm20288133b3a.56.2026.06.08.23.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 23:36:33 -0700 (PDT)
Message-ID: <0debc1fb-f6ae-44c6-aa87-d5ef3e39b47d@oss.qualcomm.com>
Date: Tue, 9 Jun 2026 12:06:28 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: glymur: add TRNG node
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
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
Content-Language: en-US
In-Reply-To: <814cff7c-fc03-42a0-93e6-852598943ac4@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA1OSBTYWx0ZWRfX389r9nVxn6wN
 jxEmuJydduBD+YFxdxjC4W0S/9z/R/vvSBs28+wcOTA3yERs+ksABrBht0lvCr6+rwMUAQubGWj
 2kmNC6r1I6lpsFmhi9PDhY3RoNjJEgXO+B7bcIE5aG0f6Jxj6r4fQrADVYKBvkedKfRwfLTX5Q8
 ow9oVQ5ocVbHmtvYV6fHbFw1mmM8xjyclp7LR2lLDvYQEHapOlcTdMz5Ds6eWIzu7Rm80RhzR1H
 Ju2gjLpwyikyzLjN0z8/OdeCSXxDNa2g9d4yH1zixMXSagWR2vyF4LUynwGwcG/SmoHBo645i9n
 r2JTKfMWyNOxGqVY+107EVIzLARz0EGEppPToPPO76ky5PpL9Eas13hahTNdcy62Ke5GBidNAX/
 s5vOlIv3o02zorlUqhlOe5Bwg9TeaFkc5Gh71c5AGLUIjYlJpWErBiOC+6ZxnJSJt4rH4hXQLw8
 PqDZjUJhtpbt4hXVJQQ==
X-Proofpoint-ORIG-GUID: WikKbiFnvAbekLFBqfMbzqpbck6YB4sD
X-Authority-Analysis: v=2.4 cv=ZY4t8MVA c=1 sm=1 tr=0 ts=6a27b476 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=AuIPJNTv_tJEKgpUhqcA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: WikKbiFnvAbekLFBqfMbzqpbck6YB4sD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_01,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606090059

Hello Bjorn,

On 5/18/2026 2:06 PM, Harshal Dev wrote:
> Hi Bjorn,
> 
> On 4/24/2026 2:05 PM, Harshal Dev wrote:
>> Glymur has a True Random Number Generator, add the node with the correct
>> compatible set.
>>
>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
>>  arch/arm64/boot/dts/qcom/glymur.dtsi | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
>> index f23cf81ddb77..64bbd5691229 100644
>> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
>> @@ -3675,6 +3675,11 @@ pcie3b_phy: phy@f10000 {
>>  			status = "disabled";
>>  		};
>>  
>> +		rng: rng@10c3000 {
>> +			compatible = "qcom,glymur-trng", "qcom,trng";
>> +			reg = <0x0 0x010c3000 0x0 0x1000>;
>> +		};
>> +
>>  		tcsr_mutex: hwlock@1f40000 {
>>  			compatible = "qcom,tcsr-mutex";
>>  			reg = <0x0 0x01f40000 0x0 0x20000>;
>>
> 
> A gentle reminder to pick this patch for the 7.2 merge window.
> 

Another reminder to pick this patch up in-case you've missed it.

Thanks,
Harshal

> Regards,
> Harshal

