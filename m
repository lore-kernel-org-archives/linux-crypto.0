Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D0A384CF6
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 06:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779346313; cv=none; b=mmUQS2ri1aJ+BJ0udoLlo4HE0eBLHx/IYeoFPB+eVX8jrdbNuAlrQXQJ5DUwXJ8+Rs9nXZR1OAjVcuo/i77OYbjlEvpfl/vVDm2NvPve9Kul31mKt4OiE53YjODQhWW2ZglOcoZBEzejSuVTHBaigUCd7ZbNXT9UHnk6AXV5h3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779346313; c=relaxed/simple;
	bh=OzXvlTwqyg/LORhSSsvxHKnz+VzK+OsN50SGeyyrFmo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AHvJUwOKIgEfjbKbwVyC8J1nioDnGTSRPPR3vPS6ip+XbPfty6OSlVIK4ssZdXS2YKszWRi63U595ZkLYvDhut/muBpM+ywYXk2ttfW9KKM1Xg9kpxyAdD+RYZUL1nZVhDdqxq6X8HFiBoO3HaeTboFikx1oN3BIEl5iZlK/2Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B1vg3W/e; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fpy8BxmF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B1vg3W/e";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fpy8BxmF"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L1IfJ32072102
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 06:51:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ipaFgG3ogON0geuVOtzTG/KiPSvXW3QMvF4djvkApMQ=; b=B1vg3W/euwWpmXT0
	mzK/ivX/06i+rfYeWpY4Q3W0jG7eYYXGdcOb/6CtlDz2zAtjyAC76ywiKXwQ2qGP
	G/FwwUPBgqXK4PMmDABwSM/Sa3l85HjCfxz7GMhau5d9oubwkrLSh+meSJV4yk+V
	btNs5mLaK9MwW/pJiKawRCMYxytvUy2+gDVCXG7Q8j+Jv0FrHqpBjNrUgZLlYp02
	ex7sRnqXkCmwpHaMe13QVtppYiW2fASuriagul9HYgHOCXH351shb3fu0Vr4fC8x
	ggnd0nZp3NRv8z88HNpz4Sn3CRz73zpPTek9G9BfX1t7/0USEF4b8/SnK/k4BjNa
	cYEfgw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e9r96124y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 06:51:50 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c829366cf25so8682724a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 23:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779346309; x=1779951109; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ipaFgG3ogON0geuVOtzTG/KiPSvXW3QMvF4djvkApMQ=;
        b=fpy8BxmF9If6zIOEIy9ghZXjRphg/WBy4FITj5ivZgX0Rsx7dybL3GH2xf5811tnBZ
         RNIbK7u9q4LSpEllAWoNO4iNqKoN4Sum8l86pYwECo521+jsHMXUkZdQqyOWP5Ohkyws
         ZFcRgJFyOJ0+k4p1na7qSo/iCnWTIlh1xAL8EXUu8Znfy2Ivg5ArwiJM220X/lElH9/y
         568xquEDqj39P9dJ1kNCPh9+34OrnJEXxbfQMAwn663kIR6tGhs0SKt8Z2wTy9R0ofrg
         aBC68X/tkCR9ZmeLoA4cZjtl1kYZoMh4GcANXEJsU+LRlD9ZU6KlI7lEcSZMoiwQdygx
         F6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779346309; x=1779951109;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipaFgG3ogON0geuVOtzTG/KiPSvXW3QMvF4djvkApMQ=;
        b=cKkmG+yaoZk/itdJTH7R2v22XGMtkXoLtemnNt9oWSc+7Xie9ygK0wv+X2E0U7kKYM
         XzOrbhEhtfe8SZvUUbPcRMcGNONePRNz+0n+udIn/gZ82qByG0mpPqRvDIsfo48rPZbi
         +t/sNa+NCqEhCt9Km6nuIwnF6+sUM4OcYl+4b2K3BsNpR0Az/ZEc6Ki1mLGC3ZkJaICK
         hUTvfhCTH2LAzGWe0yTEqnxPqvvTdT20vfpv2ehx4r3fQK2j3Uv2+AHXlLVb2+Ize8yO
         LeGbe6lyWoOtLFygnvRtulmKP11jONk/gNP7YrHrAlDtJsgHaRhqlNuO3E0dJwECScOB
         Z90g==
X-Forwarded-Encrypted: i=1; AFNElJ8cA26aIqm9JLDD24B7MrGFqx3mJs5usXHaHO0KVm5vBGnRofW/O5ZCan8UCEPVkfq0d0xmS79Ie1bWP+4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgINHwPFLVUu+j7WTlWBAvvI8PT6b1QQ1ErX7zRbVYg31veF59
	KmTax+P48mrYpdrGna31sv6/1Ium3E3bIzh/Jt12ZQeBKt2Hi56sL+t5PU2WbCE/Ok8wsqejDuq
	yFhSl0PLnt2e7zmdajbE09xlHUMmarfxS8ZLmRWpDqCmgeuDpTAa6JvISv4GBNbfyvm0=
X-Gm-Gg: Acq92OEYxOUIq6qgINuIlcYfMQM/yUXOqwfbyTyJ2Y4lftyJ2y3omLXKeZcg5p/nOfj
	Y2EhkEqnUcB4GP9CrPOAxj/1iWUbl0FQdqT1BjRoqi6rKIBsGP5Og4PLYlO0MvKfBenptWf1Lz5
	kBNfwxXv2ctveJFrmZHxHVEvLwkEWWBQuOq0tahAKOIucYmiOAhVsquaR/Y1sO9+wpATliwK5rs
	GaApWbnZyzbM+VJJ8MaZnxcgzazr1aJimiKgzlaRlu6IgLI6pgyh40Qar08cnmLxpR/06j7ynqy
	qMTX/QyRD1rXeFNiUls71ViGkRfqfp7/KFcqpqQn/ksT+yXJ2uHYPj0/wwlDvrS2+Yln7noQL8T
	sKkfhIgHMtmIZ4VTVF3UNpp6uU7cRWvPOeF2J7PZ3ly1W+nE0OHHQCO9ViFaZkw==
X-Received: by 2002:a05:6a00:845:b0:835:6d99:3f94 with SMTP id d2e1a72fcca58-8414adf542bmr1746470b3a.25.1779346309540;
        Wed, 20 May 2026 23:51:49 -0700 (PDT)
X-Received: by 2002:a05:6a00:845:b0:835:6d99:3f94 with SMTP id d2e1a72fcca58-8414adf542bmr1746442b3a.25.1779346309052;
        Wed, 20 May 2026 23:51:49 -0700 (PDT)
Received: from [10.92.163.96] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84154e59ea9sm232016b3a.61.2026.05.20.23.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 23:51:48 -0700 (PDT)
Message-ID: <d4d35e17-84fa-4c95-9bfb-abfd25ea7f4a@oss.qualcomm.com>
Date: Thu, 21 May 2026 12:21:41 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: Re: [PATCH 0/3] Add support for qcrypto on shikra
To: Eric Biggers <ebiggers@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
 <20260514194735.GA1939213@google.com>
Content-Language: en-US
In-Reply-To: <20260514194735.GA1939213@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: IY3ztUkUpXKPQ44mWQHAaKueP1ZNNvEd
X-Proofpoint-GUID: IY3ztUkUpXKPQ44mWQHAaKueP1ZNNvEd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA2NSBTYWx0ZWRfX3ReEJrV0HUtE
 MvlrULB3mX70vgbBuktuSztvkrFlbAWmYGXKvmuGK/EwBoNy3Y4ZMMAhDUUJxwFgNZ5eTPOhBb0
 FsG9p0TZNQ2Q8FPAnD4Q6d1pA/1cjhYywFlC9OEXVWOQ6ZHQ/eDODQkDyWnJoZbVvAViVU1WhH7
 2sPQBaxD9fKU7vWxvjk7gQJ8beFg0EMWRePkEv8s+tYT4/AtQQnZvaZNZKuUAZCu9WDgihTT7KM
 Mr6RySIfkEW6o/RUeVFQSdrNZsATjDSWvKI3ILeWrX+k2YpLq8l2DAa8Non/9Unw+IGJFKgxoeA
 h17P+yA14Ikyh62Q+JjjkV/z3PwsjOlswhpE4BQ7nOmlTmO4ghgJJygLaVkRTzgwSp3M46PL+m7
 GkWEcyO4dibNgmuLcxc+MH9Lag6SFbTx6JFrRA8kwJpLxdO9JAB1OK1wNXETKIRc89dg9Ee2bsz
 UDigo/xHe4Ff+Olgn+Q==
X-Authority-Analysis: v=2.4 cv=GqFyPE1C c=1 sm=1 tr=0 ts=6a0eab86 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=1cRb9DtoxWFOFH21OVAA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210065

On 15-05-2026 01:17, Eric Biggers wrote:
> On Fri, May 15, 2026 at 12:53:35AM +0530, Kuldeep Singh wrote:
>> Add qcrypto and cryptobam DT nodes for enabling qcrypto on kaanapali.
>> Shikra bam dma supports 7 iommus so update dt-bindings accordingly.
>>
>> The patchset depends on below. There's recursive dependency so referred
>> to base DT patch here.
>> - https://lore.kernel.org/all/20260512-shikra-dt-v1-0-716438330dd0@oss.qualcomm.com/
>>
>> Validations:
>> - make ARCH=arm64 DT_CHECKER_FLAGS=-m DT_SCHEMA_FILES=Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml dt_binding_check
>> - make ARCH=arm64 qcom/shikra-cqs-evk.dtb CHECK_DTBS=1 DT_SCHEMA_FILES=Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
>> - cryptobam and crypto driver probe
>> - kcapi test
>>
>> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> 
> What specific kernel features would this be useful for, and what
> specific performance improvements are you seeing with those features?

I hope you mean 7 iommu entries.

Please note, shikra is an old platform and differs with latest platforms
like kaanapali in terms of iommus#.
Kaanapali is optimised(in terms of iommus#) as same pipe index/sid i.e
4/5 can be used for general purpose or for any other usecase like
DRM/HDCP etc.
Whereas for shikra, there's dedicated iommu entry for each usecase and
same pipe index/sid cannot be used for other usecases.

The performance will be be effectively similar.

-- 
Regards
Kuldeep
