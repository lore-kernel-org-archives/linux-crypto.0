Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A51D46EF93
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792152618; cv=none; b=HgJ6rBHbEAGZ1u4thvIiXI3uwiDpJcRYYoC768ivOlvPsuWRpWGC9WrRGZt0xaH3hWI3k1FZVAJqg5wTPK0EJNr0yxJL604C99x1xV8jX8GKB+B9pTVTWD9JTYKppq3Q2kZWdHHW/q6k+fKsApm47JqnqYZRIiQ4kA87VlZUhsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792152618; c=relaxed/simple;
	bh=jQ/FSLrIkJtB17z8bh109FKYvGJkqaPWH/ZwQG3vnNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G1sH2bs44ZpUkjCXc6V3HZQPfKlZHBrvfoW11pcrsW/NKG126sV2QH9YBAZKtvvkBX4NXaULuokz26lg9UaWNDpK4qPUhocyeIag42fdPlQHBkK/ymILj82Xy1w5eIuliH3SgvErl+qVBFVaVrcH3Eq7JbHZa+sBXjd5IKHjI+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L3n3T5Bv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IAN//r90; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L3n3T5Bv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IAN//r90"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GAA1D21945547
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gd1U7p+R5ZYI8dKfgvksJKbmgdW/OkpWP6JFK8vbi64=; b=L3n3T5BvyxHfcau6
	4a9x7SZJTotMFQGR0dy1xGiqjPL0hRis1NWitHrn4y7qtpwCdp75bgDBrOdIJrMx
	e2EyJEVUVUqGjKjU4+nJ7v3rsfiiBlDfS+NoiaepY4tUbFeMyLZUSOJc2pduh3SH
	0+DsMllgEm9wzDVL056OKMKDP2NGGTVGFZcempYNpJhhvUlvXF2l3ZOPNkO5T/1p
	NR5PMcY0MLwsfr9Ox0tLUBgDSU4sXcxbmD/BvEDpeO/mi/ZXOiZUY+77+KqYRrIu
	b7UPQg8oRO8aPJIxnWBVnajo96+//hC/sGwl2sWWQHcUfZEw5Wh4QoISUfW/RN+H
	U7ukFA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbg5yrv5y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:10:15 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e85f74c21aso9531085ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 05:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792152615; x=1792757415; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gd1U7p+R5ZYI8dKfgvksJKbmgdW/OkpWP6JFK8vbi64=;
        b=IAN//r90woLi3ZUrgSzM6lZxP3xvr1MkhfLade5F/JdeCcw8dcBVWteaSoW5kxDduA
         aU0cLaZWHaWMI9WS72feNjfB8/UdHydWA7ARD15sPSBhlXyHHNRhJ4LkQzxjnl2kSaLC
         +oklPzvfwQ7XCx3lG8aWg7BUun7oJXCKyzRagxEp+M02VZzyDG0EHuKEIoZMgHUit5e8
         lm0OQZr0hkoN5ZPbcOt0QVr+CKsO78tZveOUXEsBl3KvulCQ/nr9Nj8jYV359B9/wuj8
         a+HkztixVOWVwQN3ZxvOj9aJnfSQRO2UXsIA/YXbRnIQ1cjKS/EMZzzLpDKb2SXk6Ord
         fA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792152615; x=1792757415;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gd1U7p+R5ZYI8dKfgvksJKbmgdW/OkpWP6JFK8vbi64=;
        b=SQjF/YxzhOTn8mgfLbYZvHoeP/mrw4MPn0gyeK5QMjadLzgWgEA3z8R+uPzXO9A8bJ
         F4YJoRM7YmIVJtZ2lS0F29gBkDbQ1Hy8IbWsiaHj/eLwoxFQNupkDGrS5MBZcrf3b+WB
         J6qRYbprcepdUwAE0pBTCv/qZldnVNW98J3Zg7Lr+fJXzeP8PnaPCe6D+mDsoHu91so9
         7sSELW75DROfKY875xLrS2wwLJSayNlpJq1OIs4586aLBUf+v3Yg9klHbc7gRXyF7OA7
         IPm0hxm6xDCaP8J3mOt6qRSFoSarrS/WRtx1mfck919bPK9VtWrfSq03MGQCUAOVWH6N
         +FYw==
X-Forwarded-Encrypted: i=1; AKwUvBzrpKtl3UD/M1/aI4EXAQs+lqrUAQwfjFy8ML5Qz897W87YfbWILno2RMKOh5p4HUTN7/yEL33CHF/UgSc=@vger.kernel.org
X-Gm-Message-State: AFq9FYKURHQY511awD+XbBglqkZoe8f6HTblla1MRWreoW8jCZ536TzG
	KAUx6CL/SP64wHet+2us/FI/Euhgvtnv63NL0W782L1wdIJrx9ikQzJS1BF7xADMQy/FeoyXYTd
	OHaMKYYgR2AGezmPb7bkKThM6X6F0MvGHHR2AxVLtOiqBF7VgDeYrLgZe2hEMJtxRYII=
X-Gm-Gg: AYBFou09y1oHXjGg+HzT6vFD8SEgp7wBz2Zv/OAPxGcloqfi/Mf1Yf2aTDDSNQRwxPE
	OziKDf0hgTXtCA7V8YCghlqUQyuLDzjFMe7YMI8Fn7gv7oYeE5U6OFeqLmUCMidOLPOhOY83wCh
	1TRHkrcUAevOk9Fh5VBMBPkcxZ2TlK8SoDt+bHRH64nlTrwdC2NtbycSWVkRuhiCYSV2w3VeluK
	XxKCtvbRMhpWUb9bJkTcQ0IkdSjRXTuhFIQtN7m4ZXBk7dIJpKV5/0HDn8sNEybAtkI28ku/O2X
	2izw5fzJ+j1CsXNIXcoz1zWH0HowMn9zmskS8S5IkLSlrfwZe2Zok8ShDJit9cTzOnwmfCTojbi
	zF/JFEx6eTdLaA4/3GRV0GQhfFagUz3M=
X-Received: by 2002:a17:903:1a08:b0:2e9:57bb:72df with SMTP id d9443c01a7336-2e977568618mr21987035ad.28.1792152614764;
        Fri, 16 Oct 2026 05:10:14 -0700 (PDT)
X-Received: by 2002:a17:903:1a08:b0:2e9:57bb:72df with SMTP id d9443c01a7336-2e977568618mr21986735ad.28.1792152614236;
        Fri, 16 Oct 2026 05:10:14 -0700 (PDT)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e804ea9sm8953685ad.13.2026.10.16.05.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 05:10:13 -0700 (PDT)
Message-ID: <c6aea30e-337a-4747-93be-cbaeeaa933dc@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 17:40:07 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dt-bindings: crypto: Adjust Shikra compatible
 hierarchy
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20261006-shikra_qce_fix-v1-0-8ac54d81edb4@oss.qualcomm.com>
 <20261006-shikra_qce_fix-v1-1-8ac54d81edb4@oss.qualcomm.com>
 <20261013-pastoral-magic-perch-1a2e5a@quoll>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20261013-pastoral-magic-perch-1a2e5a@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: bS_C0a9Wbm4J87jDg2kFfSxF-oWgy-MH
X-Authority-Analysis: v=2.4 cv=M+HYuCws c=1 sm=1 tr=0 ts=6ad21427 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=9AdMxfjQAAAA:20 a=xNk55bQaariEeO8a7gcA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0OCBTYWx0ZWRfX6Nulitwn3f9r
 cL85T6NwYYAphsaRPt3+9em9QxcpLToDg+g49IuidW/sG3J/bcGD2Cf9k2c1Mz06/fn3crzxcQX
 2QX+M6Z8yLBe5ExV3udAL3Px/QdH/qI=
X-Proofpoint-GUID: bS_C0a9Wbm4J87jDg2kFfSxF-oWgy-MH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0OCBTYWx0ZWRfX9sLLzPsBsxsj
 Ff7Lft6o+NgEObhvLw94fWVgkPH0BTVL+swotFD62LyO9pHhmLvRkfwoeRTg3bhVGINpooAoX9m
 nqiCkVoRzFAYU1fO4IIfruAZj38V6YroqTJc5PexTUeu1rMV6C3CdPceCf5+oHzH3pQhOGfJjcs
 Lq2Uh0sXJv2vGARxnmKjF64rTeMLi8eWqxnXu72laRigdO2+vdQhwYPaTTmoiXMgOvzw4v9tfS1
 I1heKIx48ANrl0WSqyS7PJqOsDhZENP19pibIwRHdBp/p+iAzxWM6IQWsFHc1IZYaw6nGBCOST2
 zWdHv1lSiI6q0DtI5pbrIXEOzbrjo86V0drIMjcU5XiiZ3oUrTse1Y9eFNnJbuIl9/P8t93xAkU
 W0YCPNQfvtaP4HQspHrZiy7jtIY/kBXuQpqJCC+tr1fbqu6JxBmM+j+TQq5vRcfX3F2nowZlqa1
 77fTa0LIukyTI1ETBUQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160048

On 13-10-2026 12:14, Krzysztof Kozlowski wrote:
> On Tue, Oct 06, 2026 at 04:44:03PM +0530, Kuldeep Singh wrote:
>> Shikra reuses the same QCE integration as Agatti and should follow the
> 
> `git grep Agatti` gives zero.

Agatti is chipset name and compatible name is "qcom,qcm2290-qce".
Maybe I'll mention both next time.

> 
>> corresponding binding requirements too.
>>
>> Move the Shikra compatible to the appropriate binding hierarchy
>> (matching qcom,qcm2290-qce) to reflect the underlying hardware
>> description.
> 
> You do not change any binding hierarchy. You are changing fallback
> compatible which is ABI break without any reason.

Agatti and shikra both consume RPMCC managed clocks and clk-smd-rpm.c
does proxy clocks voting as of now even when no consumer is voting for
it. The required consumer i.e QCE need to vote for it explicitly as
proxy voting being dropped now in patch [1].

As agatti(qcom,qcm2290-qce) specifies explicit clock entry as per the
spec[2] and shikra is derivative of agatti hence, follow the same
convention.

Coming to updating fallback compatible introducing ABI break,
"qcom,shikra-qce" compatible in bindings got accepted in v7.3[3] but not
the corresponding DTS change[4](which consume this compatible), the DTS
change is queued for v7.4[5].

So we can straightaway update the hierarchy then?
> 
>>
>> Fixes: 45834ff95a6f ("dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine")
>> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> 
> Drop, that's v1, so this likely did not happen. Anyway, your SoB is
> supposed to be last.

Kindly check cover letter for more details, it's respin after receiving
feedback on previous series.
Quoting here again:
"
The previous patch-series[1] was sent to an older thread and with feedback
received, submitting a new series.

[1]
https://lore.kernel.org/lkml/20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com/
"

Seems using b4 shazam automatically add tags below SoB.
Let me fix it next time.

-- 
Regards
Kuldeep

[1]
https://lore.kernel.org/linux-arm-msm/20260910-clk-smd-rpm-skip-proxy-v1-1-1cb5694a99d9@oss.qualcomm.com/
[2]
https://github.com/torvalds/linux/blob/master/Documentation/devicetree/bindings/crypto/qcom-qce.yaml#L130
[3]
https://github.com/torvalds/linux/blob/v7.3-rc7/Documentation/devicetree/bindings/crypto/qcom-qce.yaml#L57
[4]
https://github.com/torvalds/linux/blob/v7.3-rc7/arch/arm64/boot/dts/qcom/shikra.dtsi
[5]
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/arch/arm64/boot/dts/qcom/shikra.dtsi?id=099cd05d200ba241bcc7497c4384b8d657a5632e
