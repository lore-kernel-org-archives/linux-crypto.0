Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0761F30C359
	for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2026 12:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771244345; cv=none; b=S73gEWMeyD6NpHyTqTNS6LfrVXTC4d7GQhIeA2YcgtcXGzqR7r+4GO1uuxeMWhLmnP1IFpmWBM+TJq3TXamVPqw44LZzJdtn0NIDumU1q0z+iGOUhftpFoLQmxQthnCsQrh3myfO/BoPmylR3kFdvliK7vSg/L+/sm9h2//eOro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771244345; c=relaxed/simple;
	bh=qF6sWr30Kr12NDVrl+Ez+nQNFEANHqIDNqXDpkPuGcg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A3wd2rVhd2QjmCjRrHbZYmekHnC5Z3yjMYxJxC2MEOxkHU4NhajfbdKq4SbAjsDKT781Sq3w+4pCK0peygigEbDl8iJ6M+8vHZAlPk4ojNVnEz12c2wFitqu0XlYc5eVe9+akzQieQJ5hjFT7hOGM1x1b2BenLfUUSL5lSuNmRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Uh59LdEx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fYxYa3rs; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Uh59LdEx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fYxYa3rs"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GBdhoG2895319
	for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2026 12:19:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AEKTw5C+zxMfo68DsKgl5OTHrBuzxHktqkQD1FRSneg=; b=Uh59LdExsjjW+4ph
	elmCKKMRYPWMCLO/wUH14+zwM8FyvqJxThXwAbJvO6tp+Sv8eyeH1wx6zw7E7ZX7
	9ztG0jHIyM8S7R2otOr+oTZzn1qzC5dYaZlZobHt9Ab8ltBclU+MlbkMJP4rv3JC
	6i30wLUPRceW2cXTr7kIxu3J6n6zw3jYXcwy460/ERu/GW2DjIO8Dx11mANi/aSA
	RGXYd1HC3Bv/H0W76tDWOxg+2kRIiLleN9EAqOn//tMceV3lHnp1XnNi0hZASjd9
	Dv3aRS2NTB39HJyU/42qBNDku4Z4H47IuhcTroSwCv9+PhK+qndv7GF/JAEN8Rsu
	65DyhA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cahtcmbyy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2026 12:19:03 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cb39de5c54so230987985a.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2026 04:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771244342; x=1771849142; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AEKTw5C+zxMfo68DsKgl5OTHrBuzxHktqkQD1FRSneg=;
        b=fYxYa3rsCr1OW7v2r5hDPfoXvLHVn9lJeqm1RUuiYYUUxEfRybmLYKtuYjNqtSD2Er
         xI5CM7YPxXPdkIDNS55xXOICqpYTtfReJB6J5opmtilZE3vd3/ifGr/KfFu6Bs/bxMgP
         2TJtpaBN928hSUrYMzmaOCNGXBtpBbciqBKP/DTQIbL0Qeh7/q4RxfCb3Mr6fVxSJDZs
         iP7kGqZxXHaZ36Gobg9Yn88ViFhxJqO/O9AxZK2lp7KaL43gr3/HNoTh4wz+ihEXE3oN
         6bqxgZBJzepPGUX/dGr8qKyuP3GFfGN/FTICj/FTWBm0LC+snqoMbFGFUrbDrUP8w8dS
         hABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771244342; x=1771849142;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AEKTw5C+zxMfo68DsKgl5OTHrBuzxHktqkQD1FRSneg=;
        b=iHxnMO5vgVkMrwsBXyd0LQQjUyQebpXTc1wiSfQCyYIM13e/mBMIBhLUfzwSJ5MOIx
         H6NihBq+f7dR1nj45+P7sOoUBxvGmd8P13OJQh47whmhk47Wab1MSYEEmJZ9w9tUY68r
         zXx9XSJxGcWdKU2NDRwtPNMjj0MqFa7LEJPi4lyrR8SZdkgNW7J7/B4FlBa5Ieznn6UA
         zfCKRA5xwxUUYxNXO/RTch+nEBaFy60fWVHKaouh0UKcuzNomowPvwzIeYOioVFfkd7g
         1NpX3WEjct6c26jalUi00/8Iuk3a5zrsXj/Z2HIdKTfKGScu8wsKJGqD4933CsySFFrL
         FZ1g==
X-Forwarded-Encrypted: i=1; AJvYcCWBfpYU5fPMx3Ba/fqHpv4mFCWiRg9np84XsqsRBGW7J8Isdpx4ylGbZfGhDM7pGGLZArqtqvWoCzoFUjE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHEOz/gxDHcygUcPnTJsBCBPGevbOtBwRypbZwqxavyCTJiBjl
	ULQIFNdU/c+CNrB9kr8sI7LNH7rev92Sa6bgEbg6NT7UpUTesuUZJEYZTIgs4tvyRhjRmyCZ2nO
	0VXWC39PlQYQ5mPQHr/r81uOwkHDhiqK83JYtykOf4aSkFwkiKI3TD+/Bb1OI6GY7TlY=
X-Gm-Gg: AZuq6aJz1HRQhvtff4AILpB8z47GrcKW/GByGRI82f3OZHtLddj29grEcZpvcPKucHq
	CM38ywPQ48b0ZCUCwTaPo+hskfCHMMWzNiD7qVhnymC2MSgWiC+/uY9OCRxIDgts/5A6Wk2NodY
	QRU/ZYoDYOzlznTJSR8YMyh52rSqxGBG1JQSrlNivW7N7RncOgfv6zIXo2QDMAjQhctdAe9V87b
	26pBFVyelxcop0D9E5dSuxDNnqBKB4y+TcRJvKhCIE8uR1G1oz4N/gXBbFyy5ZLIg3t5FNlwI/o
	ArcHvxNKyoJoUs23RlAY5NehqOdQeW93EfSPfOZ6+wj9BUoLgmnEKPIeOCujq9JrBGRjuLKYGUy
	/XvF5WxRq1vhvw8sU/qQ/+4zro2o+QEiVtl7oXC4hhi+xOPEHXk3ZUjfvLPRAOZiIvVYmpbCRVB
	p46T0=
X-Received: by 2002:a05:620a:2941:b0:8ca:2e37:ad06 with SMTP id af79cd13be357-8cb4090d491mr897415385a.10.1771244342207;
        Mon, 16 Feb 2026 04:19:02 -0800 (PST)
X-Received: by 2002:a05:620a:2941:b0:8ca:2e37:ad06 with SMTP id af79cd13be357-8cb4090d491mr897412085a.10.1771244341538;
        Mon, 16 Feb 2026 04:19:01 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fc766519fsm241141666b.48.2026.02.16.04.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 04:19:01 -0800 (PST)
Message-ID: <3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com>
Date: Mon, 16 Feb 2026 13:18:57 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
 <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
 <aY7MidG/Kcrs83O9@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aY7MidG/Kcrs83O9@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDEwNCBTYWx0ZWRfX5o/g4EL2zkfX
 +qUolDdZU7B5MUdAYM3dD66UBWKYawhm84BVbqAXq7pMddYzZ5s7yOqJGg9AXqoZ9D1+/7JgVs7
 Gu8hue9w+2VQtsfHcmUFEpH4wfh9uNT0nQT4U+CkoIJuA+t3qKyTLwS+DVOtTN7//a5/bcqPw+r
 MpvvypA3M7XwC4dNK55oGArk2Fcw//joDM0fllhGmkxT1OdcTDvxgBrZwsziOYmxhu9soZQmi6I
 4w2Y9dQFIQpdRK7cM3itqMV2c4eCR++x6Hs7qhGcGjZxQL1JC3FFMAHTeRVdVZIz8/i6ZVKXrxj
 pTeNpITp36E/j1Yk50szIzqeW2Jthftvoe7TYtsrBcevapWbTda92ze5QSiXPiMEAhAXLDtX3ER
 jDudl79vNHJEKbOxvw3bZnRoLLE9HQtAGtE+WIhhCsJoHlYDJmQUbie+7igc2GokftTehckCOCH
 EWqe6goWLGvDgzAeBpQ==
X-Proofpoint-ORIG-GUID: wiBySw4yoXRrrAhTkwamwlZdmufs1cq4
X-Authority-Analysis: v=2.4 cv=DJOCIiNb c=1 sm=1 tr=0 ts=69930b37 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=ZkWj3vqgG5hmBBxJETsA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: wiBySw4yoXRrrAhTkwamwlZdmufs1cq4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_04,2026-02-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602160104

On 2/13/26 8:02 AM, Abhinaba Rakshit wrote:
> On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
>> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
>>> Register optional operation-points-v2 table for ICE device
>>> and aquire its minimum and maximum frequency during ICE
>>> device probe.

[...]

>>> +	if (!ice->has_opp)
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	/* Clamp the freq to max if target_freq is beyond supported frequencies */
>>> +	if (ice->max_freq && target_freq >= ice->max_freq) {
>>> +		ice_freq = ice->max_freq;
>>> +		goto scale_clock;
>>> +	}
>>> +
>>> +	/* Clamp the freq to min if target_freq is below supported frequencies */
>>> +	if (ice->min_freq && target_freq <= ice->min_freq) {
>>> +		ice_freq = ice->min_freq;
>>> +		goto scale_clock;
>>> +	}
>>
>> The OPP framework won't let you overclock the ICE if this is what these checks
>> are about. Plus the clk framework will perform rounding for you too
> 
> Right, maybe I can just add a check for 0 freq just to ensure the export API is
> not miss used.
> Something shown below:
> 
> if (!target_freq)
>     return -EINVAL;
> 
> However, my main concern was for the corner cases, where:
> (target_freq > max && ROUND_CEIL)
> and
> (target_freq < min && ROUND_FLOOR)
> In both the cases, the OPP APIs will fail and the clock remains unchanged.

I would argue that's expected behavior, if the requested rate can not
be achieved, the "set_rate"-like function should fail

> Hence, I added the checks to make the API as generic/robust as possible.

AFAICT we generally set storage_ctrl_rate == ice_clk_rate with some slight
play, but the latter never goes above the FMAX of the former

For the second case, I'm not sure it's valid. For "find lowest rate" I would
expect find_freq_*ceil*(rate=0). For other cases of scale-down I would expect
that we want to keep the clock at >= (or ideally == )storage_ctrl_clk anyway
so I'm not sure _floor() is useful

> 
> Please let me know, your thoughts.
> 
>>> +
>>> +	switch (flags) {
>>
>> Are you going to use these flags? Currently they're dead code
> 
> I agree, currently they are not used.
> However, since its an export API, I want to keep the rounding FLAGS
> support as it a common to have rounding flags in clock scaling APIs,
> and to support any future use-cases as well.

I think you have a bit of a misconception - yes, this is an export API and
should be designed with the consumers in mind, but then it's consumed by
in-tree modules only ("what's not on the list doesn't exist"), so it's actually
generally *discouraged* (with varying levels of emphasis) to add any code that
is not immediately useful, as these functions can be updated at any point in
time down the line

Konrad
