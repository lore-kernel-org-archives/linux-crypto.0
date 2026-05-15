Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777F031E82E
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 13:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778851405; cv=none; b=IOWnngEL02qGgkp8F7Q/he5cw8Kl/jOq/PrfJ4ba46BCAKtJRiJWDzUM9w6j6fsE3ThdVAOEQwkwDFSrLr8mCtBWVdclGyaRNgsc1R0Kb2E8P9N2qiJrIpbbJmcVZrmi//pSdx7nNEKT+ccPVCXoxmyqlNehJ0dQG/T3GwQ1Evk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778851405; c=relaxed/simple;
	bh=QEdw/eEh0/lG6qQJfmjuSVq1clRrTvUryIOMEkifb9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UzkUknCZAlcM2361z9LDt5dyXWtFuYPjQAk2pyyE0hF7SWRYpbxPVpV+NArtyoU8G1deODSpt0Zvq8qXMM1ZXl9hlQEwEvi5TQeBG4M+EeDMqgJbN06L/tc55L63/Z12uNy+bNX3qqm/Oiel+3ojI+lbY5MJm5fKEBLFPiDkeq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UhtFgxHn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kPS/MdfU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UhtFgxHn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kPS/MdfU"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64FBFvuh654865
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 13:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xNIOeyOfHfqkuA+98OANG6jWuYLg5dxeMgUwe8qYPMc=; b=UhtFgxHnhA2VFnFG
	n1Tbm8xoua8GonzOYork/+6I4fYgp2o1zjZDOisFyH6aUIsy1/KzOsd2LnHnCiFa
	dupicfvxRmUyBVxaiIEq2lxE1BH9SVU4aUoIWT16RSpfiFWQB6Y8hmKaJytT1m0B
	nVPEcnR/IpLJXWm/E6g3GpNzSaVeG0J+xl4FB4Bw3ZwdvTk9Rx0egWtNUXpRgN6R
	H4hHLEhPcecz4BxdhF7eGWLFE/Um6omDqH7WiFuN/saQVrKtv/kHP54jys/nlVCU
	RIm2TjtEufZs0Gu06m94wScXCulVcJJq4zAxPYA8ZPImf3TnL0zr94w8VWoSdBBS
	JuHYFw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1puejg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 13:23:22 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30230e64087so3002952eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 06:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778851402; x=1779456202; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xNIOeyOfHfqkuA+98OANG6jWuYLg5dxeMgUwe8qYPMc=;
        b=kPS/MdfUPonG08ze4b+2qmloZcK/KTX73v2t9FREMMOWu9JR8ZFBmg4/A7AwkgsudM
         9+Qg5j8ETapVA46/Q6h2cmIzl494KlzDtwNZd9VqZkwceXg8Y8c7GpyvYbipc8rHiBpq
         wh/UvfMCBc4pkoPNDPnAYZhaH1PWKm8WydlOA8Htbe/J210zlZkNJdWUzLFxbCy/fT1d
         D6IH3k4LkGO22KU1s2m2ehsA7mHcCf2EdoDc8+H554Ixd5mtMhdlym/3owLRYqdDuBc4
         M4cj2Fzis4rwhk7cDgpFbPJT9mBshT5/0lr+8yEryn+Cu2LPP6h4m4bVL9hs3m44kcaN
         jznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778851402; x=1779456202;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xNIOeyOfHfqkuA+98OANG6jWuYLg5dxeMgUwe8qYPMc=;
        b=ea97Zo78KoqS+BsQ2mzqr5zuFADyvHm/2fTlvAZSyN7Lf1e5p5wX8gRBKGXjQPH1uz
         volAhWjd8JsyoUJpNUGXQZJr9+hXqGJzEu6vaZCZGVxXp6aCv/gCCi1YqHZB4Qam6+B2
         Smkb0OzUuClW2gTb09zl1RjwRWi8j0hhQRiK42iCi7CkfOqN3QxU34oU187l/qE2cGp6
         LLaXtq8vSapgxFZxoiKYWaRlUofEqOP0em2cdQHOy1C6DoEVKAW4XTTXfgVbH6dtTNg8
         g3dySAPFK/pD4xfU7RfEqrQpeISVtxHxIP7IDubx6GTWuazJ74GIrNXOhfc6AytPjOdL
         gXFw==
X-Forwarded-Encrypted: i=1; AFNElJ9+F/w6zkSLzllkh7G+zM8gUtfzb0fobzJAEp/BSKKSDKvSoSjDsQE62WaFPVik44xD3ObdnSvUWvJqqyE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyriXLWQ9ket+MUDCxiz/33U64ZgLM6s6k2AKmiDkIUrGoY2g1w
	wLxSH2Zc04s+XKOFRHWs317U0qD3OnSe43Z/IqoImdMwWhW6iUAVU5LE1Bcz6w02sy5ydlSpNsf
	0Civa8Z5z0ujgUQ72msrF7lwLDRYinzHVPSvGS5fxCXaXqDW3+Hj/Oy8k+QacIhyOvTc=
X-Gm-Gg: Acq92OHXVnnEylUfgnaU1lK+yXdErwpWYjKjz+pzJ4m3rkAs77BO+wh5SY2ZWaKiUxM
	fsMJslqIYF4CXR9OisvH/7Spe4+QRNXU2N7w/XFhkXU+QmUrkX9q50vr0rtlZ9a/ON+GDn1hAzr
	GvyPQ+yus22bp19VNmCjUONfPMcbx0/7n+wUmxaImRKXfeJIaemhFPRwPxwllnbzloaBDlt3Zxe
	WrBImPGAmgJ6O2R8KJHUHRAmz3/p+aVw5r88VG/xUkk0hP7ZkdxMUN8gvg7hsgFiWh2wxMx22XA
	xl7RJjpie3cdTqGBa3Wz8VKqSolibjsPiqM5ssMRvYhvEGYxFfSMaFsr1bko7Pirh2kubqlg+Bk
	zdgeuA4LoObDQ2yWnEBSj+SnUYuAEUPg/XZpNNhuDQ8ggNMS3eKqWChwONGAa2O1zb2n+6hJ8Qr
	/yOowF
X-Received: by 2002:a05:7301:688:b0:2e6:ff79:e356 with SMTP id 5a478bee46e88-303982bf6a8mr2162198eec.11.1778851401985;
        Fri, 15 May 2026 06:23:21 -0700 (PDT)
X-Received: by 2002:a05:7301:688:b0:2e6:ff79:e356 with SMTP id 5a478bee46e88-303982bf6a8mr2162170eec.11.1778851401285;
        Fri, 15 May 2026 06:23:21 -0700 (PDT)
Received: from [10.110.108.188] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302973bc9d4sm6771472eec.23.2026.05.15.06.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 06:23:20 -0700 (PDT)
Message-ID: <56f5e73b-5f40-4bfb-9796-dadfcb4f9085@oss.qualcomm.com>
Date: Fri, 15 May 2026 21:23:16 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: qcom,ice: Add sa8255p support
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
 <20260512033750.3393050-2-linlin.zhang@oss.qualcomm.com>
 <20260514-clever-apricot-goose-acc827@quoll>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <20260514-clever-apricot-goose-acc827@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 368SRy1vZkbbiJ3Qi4P3qXqXT_hIaJ7Q
X-Proofpoint-ORIG-GUID: 368SRy1vZkbbiJ3Qi4P3qXqXT_hIaJ7Q
X-Authority-Analysis: v=2.4 cv=GrhyPE1C c=1 sm=1 tr=0 ts=6a071e4a cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=1_zi5yXmVb3nt7myx10A:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDEzNiBTYWx0ZWRfXwrq8wm2taHhN
 g+DHq+slb+6SNzzsgBmmRh4HaNX6vqBbAaUiy4I3jeW0INjfnxOgwlK7/dM3EFzS3uV5CvmrY3n
 +6zF+fNeJysvDsqwDQ8zhdD39SF5u9vukseNU1KXiBKULyTBhC4yfw+F9IOaKfDzAovQUqtIiDL
 7BPvV9EKz6dpNd08LijAAm/z7s7V8nz6UwrtK8GKVnuQ5FlbMui88nT++HdB5RBPj7sWznAdX7O
 NPUtYzmUDPDL+CBw0JyWvi3SPhpVWWc5gCc2mH3at7BpSeXlIzoA6HqscJrS9GR6yTsHHOev8ek
 ttUe+E9Nn7+76hsEdM0dtmqqqXoi0VqmsWrXssDBJ28COvRzXAzkedwrqy1j/F88L2EQhycKx7s
 z32EMVw1Qo+NtU6/+PPGp4D9dge4QC3evyk1Cyai102+NNBfdyPIcuyg0cNUbkDX/4dmIw+ddsL
 b+kHzN2UsqEwzBj/NTA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_03,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0
 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150136



On 5/14/2026 8:55 PM, Krzysztof Kozlowski wrote:
> On Mon, May 11, 2026 at 08:37:48PM -0700, Linlin Zhang wrote:
>> On sa8255p, resources such as PHY, clocks, regulators, and resets are
>> managed by remote firmware via the SCMI power protocol. As a result, the
>> ICE driver cannot directly access clocks and must instead use power-domains
>> to request resource configuration.
> 
> Then how can it be compatible with qcom,inline-crypto-engine?

Thanks for the review.

You are right that the SCMI-based implementation differs from the
traditional inline crypto engine in terms of resource control. On
sa8255p, clocks and other resources are managed by remote firmware
via SCMI, so the driver does not directly control these resources
and instead relies on power domains.

Given this difference, the SCMI variant does not match the same
programming model as the existing qcom,inline-crypto-engine
implementation. Using it as a generic fallback is therefore not
appropriate, as the generic compatible implies that the device can
be handled equivalently by the same driver assumptions, which is
not the case here.

I will rework the bindings to:
  - introduce a separate binding for the SCMI-based variant, and
  - drop the generic fallback compatible string.

This should align better with other SCMI-based bindings and avoid
overloading the meaning of the generic compatible.

Thanks for pointing this out.

> 
>>
>> Add the qcom,sa8255p-inline-crypto-engine compatible string and make clocks
>> optional for platforms that use power-domains instead.
>>
>> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
>> ---
>>  .../crypto/qcom,inline-crypto-engine.yaml     | 27 ++++++++++++++++++-
>>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> So this is v2? But previous was v6? Look:
> 
> b4 diff '20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com'
> Looking up https://lore.kernel.org/all/20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com/
> Grabbing thread from lore.kernel.org/all/20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com/t.mbox.gz
> Checking for older revisions
> Grabbing search results from lore.kernel.org
> ---
> Analyzing 8 messages in the thread
> Could not find lower series to compare against.

This patch was review internally, and the final version was v6 which is
approved for posting to upstream review. I'm sorry that I forgot update
the version to v1 when I posted this patch to https://lore.kernel.org/.
This is why you see the previous was v6.

I updated the patch to v2 (this is current patchset) with some changes.

Would you please help instruct me how to fix it? need I re-post the patch
serial from v1?

> 
> 
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> index 876bf90ed96e..4e7d9111d0eb 100644
>> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> 
> This should go to its own binding file just like in all other
> SCMI-variant cases. And if you looked how these other files are done,
> you would see my complains already that generic fallback is most likely
> wrong.
> 
> Otherwise explain me what the generic fallback means here and how is it
> supposed to work?

ACK. I'll separate the binding and remove the generic fallback.

> 
> Best regards,
> Krzysztof
> 

