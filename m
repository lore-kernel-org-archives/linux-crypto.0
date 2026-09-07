Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA534C9560
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 13:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788367; cv=none; b=I8qhYQ9ToUQuSt/iMfMjNIOHFcaPWvir2AV5yVMZU/o65iDMfC2weqzcSR/pgF9Vu3+pt2fuafsJ3Wb2/xrPfHnhyLgahqKpcn+geT4MBgkdKADOdrP9On0flZjPnGCa+UklMzwkXXv0NlJppeYPYtmupQhSpCBoIE6iIPPPowE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788367; c=relaxed/simple;
	bh=LuoUpMNshQ5t5idHuLjWLOPZmBgbq2ucZ5M7HsXdSsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BA3Lr+fI6NdvQFMzP9ZbJ7ArDW9GOL+jX3Em/4N5qmtOlwOafNiqdOnjkAeR2LAF5TQ/Ujof6k+PRWjMoWEEUeCvbgaVi88t1/kuy6pLkSy0KVsCRcZOyPphBZ6JBPVjWpLzxwZA8jfS/1XeDN7u6rhQM5uwXJUgdFq84NkIsuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DcMxJJhQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jUqHCYk7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DcMxJJhQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jUqHCYk7"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687DdN054148844
	for <linux-crypto@vger.kernel.org>; Mon, 7 Sep 2026 13:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Imd8sMtl7PDNNp8Q9khBRYLBDX+X8v274yOTSj2qwzc=; b=DcMxJJhQghvdxWJi
	Tk+FWZE67WMGXYylw5stS+Yt6WvgpXD1v9e/5yP0Q3GEDupUy3TjWkK86Y6gJR7u
	XYgkEkT63u/sqmHyp0ju/wzf0x1qx+DOv6La8QzlyOfRiSYc2N+j6kcgyOl1jgFT
	vHAkGJnSEviXjPWfSum+PBHah2REvWgKr5eSWrAR5YyOrLJjSycmjeaJdS6DLADY
	QgfdOskRmAIw4DSAcYJhN/WeEjZ41otAoUwVyWBVBUvonzITcziEjG+qVi9NntBx
	1htNsmCZGyHKClaEg3IAW0M4w53HrEDGeHtYxb3cTiIbN47636msAM/at6koH+Uk
	BWnl7Q==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghsfyha83-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 13:39:23 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2db3734d06dso37401635ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 06:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788788359; x=1789393159; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Imd8sMtl7PDNNp8Q9khBRYLBDX+X8v274yOTSj2qwzc=;
        b=jUqHCYk7LB58iIfT0ZBT1j8rofwQA9K+zgN21+2uJZ0UdqZ/kRsyVg8PL6/XNqL/hp
         XlrvB08FGrP6sptVfnKhYALTTljJe1QHAeaZWcokKOrQ+c9JJyyBY3vzq+uPboTAJwIJ
         kMnjUDqbal+fzp6dPfqPB3/tIrYgp9RlyqY9Wwn/5kWYU8c6F/zUvtzAKGIgmWEtIkF4
         lMZZT0LyjDGu+tu4RCBN1x+ufRGqnUjnOkjLQPtzHQWp3hZ3lfPfBykMXcXBeB/6i1mX
         Isho7+lgwM7F3yePOnRxHi0iE8DgiEEAXFea7oWTkDKQ5oEKmFgYq2yPOylEiZi4wiXF
         65jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788788359; x=1789393159;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Imd8sMtl7PDNNp8Q9khBRYLBDX+X8v274yOTSj2qwzc=;
        b=a2TVdzgQCx/mivpWUAEr53X32tinwRah5izvobpeuHX5SQmQIoPEQ3xEtZ2BY9EioK
         gqWFIAZsGxFFczsdvZnkqlWckfo53ZWVl2lpPIdGlNAO5HjpuXe0vrv+8OnjbdLTqRYf
         iTVf0x0m0/tkNKb2GaQIo2gdZerh/MPoBagFuno7d/AabsIGOwZ/qOw9P43kSik0KhzD
         8PUH2e2bXQ5M+8zGVxz8oQ4YFIPe2X7Hmg0YUJCV0P4WGdw932GagT1xuMLG0xwrwRXl
         W1cYTUgGRsb74Ns6cYsgdsuuXPW1F9L2uA1YXNUba7K7GP0E6R0bgRFlFU4LY+tvPaLG
         jx7Q==
X-Forwarded-Encrypted: i=1; AKwUvBzRlqbsxfhtMrz5EhtKb/+KcbJTHxR2e5ZEumvXyNCbaq7Pi5/SmyN0P6wuQAF1tNubNacMg320B4vyrY0=@vger.kernel.org
X-Gm-Message-State: AFuF++m+J2zJ18fPBZL3vdJv52en3zHNgUKifn/h9DiNyT239aN5QmOP
	wvwaeMzZgFfy0+oDIzzwNkFEwCQmBV3J9CD/UP4usNZPwwsHI7x5OdGJeFqK676JNDZfdex3RCp
	2qTl8RZC59wj2z0+ae/SXUrzMGw8ESYlFACcUNOEPuL6vPfip20OJkB01ZFakK+Xu8mc=
X-Gm-Gg: AYBFou2wrPiPfvWfgf4Cqg/hcUUP5CuAR1Q3Df1CHQRdm6L5SDmPlGzw3MMzdHX0bvu
	OY2WVUCr+wT7vlZySLa+K26qUcNkQzWmpQ2Ao64vQRoHLEVLMjZF59iIHprw1F5snQ/LbG0rUS/
	SXhZergkczd8yJaiSfYZ4IWzbkRGsrlINyrcMFcfDQStIxN4c0KoST4xoc/y30tdQzytaGFOUL8
	RLPGFlhalzqwuRWG41n1hMFfCnv2CFyqgt9/SdAOvzmMqzTQVWT0fITqpijqPivdMK7SveSA5Ug
	K5typCUh0QkW7c5MDNMQIVrxJJuKg3yANqLI214TsNKg3DS/UPBmrh/M52W4kABAccTjSxTkw0T
	Ykc7kj1M27YXeE1I/ttlz5D47WMAuKA0=
X-Received: by 2002:a17:90b:5790:b0:398:9bd5:4910 with SMTP id 98e67ed59e1d1-39b2624f0ffmr33905923a91.23.1788788359422;
        Mon, 07 Sep 2026 06:39:19 -0700 (PDT)
X-Received: by 2002:a17:90b:5790:b0:398:9bd5:4910 with SMTP id 98e67ed59e1d1-39b2624f0ffmr33905857a91.23.1788788358993;
        Mon, 07 Sep 2026 06:39:18 -0700 (PDT)
Received: from [192.168.1.12] ([223.230.61.94])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432435648esm32726196c88.5.2026.09.07.06.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 06:39:18 -0700 (PDT)
Message-ID: <841a008a-1ce6-40f9-95ad-09b4abc7456a@oss.qualcomm.com>
Date: Mon, 7 Sep 2026 19:09:10 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com>
 <20260907-b4-shikra_crypto_changse-v6-2-0676f61894b3@oss.qualcomm.com>
 <iow4xf2uflvjduax55tkbhaw2r4436uqvys22u6pbm3ry2gryw@g777gu46cgin>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <iow4xf2uflvjduax55tkbhaw2r4436uqvys22u6pbm3ry2gryw@g777gu46cgin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: dqVgIzw09AZHHSCy_uSeu6BkN57dO47P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDE1MSBTYWx0ZWRfX+003yN5xR9vo
 pFClWfOmCLhHSinGnvyiJAFdMWDArwLfRQ1G5hTgwKvr3E4Bhxn/athoK+Uk5Ax7GCSkakTjyhr
 dqL49EBWn0x0zxD2ZIv8A+Dg/Q5frnrtLsKKYUCeDMMyEfgEm3ORo3CwgQ96SntdWzyi1OECA4G
 aH7Ffv/l14yPWu26gYDo64umbVBoer1UOgZTWiyQAI1SU1gaavuHOurjq8r2Np2bULAGx6YWb+J
 7LhM0x07uwEO/CHUmNrcW9/JLyYCiqL2+VAMVlNUK4s0qJ5C7nrF+hlms4ZEt8YVYSSb68YmRdE
 mqVspkzMN79nNf7tI9wn9XFsiQyh3hy8PVHT3ZGZdSTkcy4+M59nlr7haUkYlycK8YLn0zM8F1w
 tzTXocftey/+WinJ/wrY2NcXHK7TimPboG0WcT2UgVrQZ/hVQCqPIKOOXhvhbA9nSBPAhTJiJMh
 lIDCwPfyWMtsd26MAfw==
X-Proofpoint-GUID: dqVgIzw09AZHHSCy_uSeu6BkN57dO47P
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDE1MSBTYWx0ZWRfXzL1f98LDHZ8h
 vjjTkw3mvR7gVn52fudO8YCcVqER66MkM/zRNR4ZCI2TSMyj5Xz2HrWheQ6sPNDhjeIWwPMthuN
 opKGsFJFEHeYTZxux65Te2nHGf+a6NQ=
X-Authority-Analysis: v=2.4 cv=AduB2XXG c=1 sm=1 tr=0 ts=6a9ebe8b cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=YDt4qybLIboWMMC/SFNjLA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=9GsNmjbEMOpVDnpVqTcA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_04,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070151

On 07-09-2026 19:01, Abel Vesa wrote:
> On 26-09-07 17:33:37, Kuldeep Singh wrote:
>> Shikra is derived from Agatti and uses the same QCE integration.
>> Update the QCE node to match the underlying hardware implementation by
>> adjusting the fallback compatible and related properties, including
>> clocks and clock-names.
>>
>> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> 
> No fixes tag ?

I was having confusion so didn't add it.

The parent change is in linux-next branch and not in torvalds tree
currently.
Shall i update Fixes tag based on linux-next commit only? or not needed
at all?

-- 
Regards
Kuldeep

