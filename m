Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B26117ADE0
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771510839; cv=none; b=YzgoHd/kBINkaGLaqe3VSDQUvsp2K0Hu+c/B7YBxBVBlolXRe+uwZISTGQ9K5kvhIUkXJEOz52cGC1948R1vDtqlhCsANsEBskbkURXgdAkHnxWCGz7nai79tQHF/M2OhySDN598gTGw4xbKmGXwg6Furpdjs5/fQm//3e1RTUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771510839; c=relaxed/simple;
	bh=EoTRB37SeccKHBtVBHrYRty94wgbxpHZAwwtK3YUt1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ohCyVhor9hlY6WRZXZzVX3XU3+qkxTpaM0qUW7FYFcbq6REVzv0qG+S4ggrg1yA8S3ETxJ8xSE1z/6iWYbsX21KvLRcx1QpiQ62CSGBaisQebbWViSTDk/hAX0Pumdfpt8iNjEFUUVOGmWCEb8rwQTtSRt47nPo1wR6m7GYDN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=myhzW81f; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Xhk4d97K; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="myhzW81f";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Xhk4d97K"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JDkLOA3232829
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 14:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AY6SzcgnN1ygLs6NoU90S60oq4F1AC43RaLiXbNMb7k=; b=myhzW81fJU9IimI0
	N0kmSTdqXiTLyaj9ehFU8/Y+CBje0zMUUVH0Dn9tAHEIxiOdn1aLBAyask+DHIbG
	YQKcwl79BFSGG4Pu/YbVs74vwQfwIoU++NROHLJUoVdXQpUWpI7q2rjAnanrl2r7
	aJ0WJzuhTKpkBfrG+Y1Dl1Sd7orJgArMjzn0ptVktb6ILOC0oNJAVZnK0cyFXEGk
	vNuBx//ZWqApdEN2u8L1GtNcC7imubi8NdRBBY/SwMjAVahSMaloej5O+uS5I5Es
	5aLlud4ZBAF4v0/zTf4bll3Np5hcx8bzHXvoB4Mir0aN93WvPNolfv4ZjeXXbESa
	cWyKbg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cdqfg9v82-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 14:20:37 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c710279d57so82500785a.3
        for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 06:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771510836; x=1772115636; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AY6SzcgnN1ygLs6NoU90S60oq4F1AC43RaLiXbNMb7k=;
        b=Xhk4d97KwIKacBkg59oIgXq/2aN2OEU/ilVvoxI3cH5TzXPs1kPXNO3MVZcuoPGw21
         w/3rc6Bew98g24oXB1JxQolrGnnn0XDrLOWuvEwR04JnFD+BhVimypdAv1fVREoGrQDt
         oyUtciOQKa+zYPfRECg1NhuJTQFnsg8G3/Rpz+NswVsnZrh5DKyVtJA54q31ogy3jtMg
         OLc4DCG/kkgxgP7rsyDWyzejXeQJvnvFbKjprzfnz2xRTiKOsmFd3cvwrOVq5uqawypP
         mt5RotWbvuZb/5u7n69cvunNrqiXza0ef5OgY32AncoAk0xGyxhly0T1nwvazw0oW3d0
         izzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771510836; x=1772115636;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AY6SzcgnN1ygLs6NoU90S60oq4F1AC43RaLiXbNMb7k=;
        b=o63RwgvpPdmy70R31HYoKzniSWvmS3FumcJnGyQAPsdx88VQZNHalDqphUb2A2pBn9
         P3NaEv8b/ZKn7mIyxa5ycEjsCoviUmNQHB7R22LvEPYzO+qmhvR8uDEJPdnTKcH56kVK
         DEW78j2fX7r/f3TsUCbZINIwACDe2CmyV2f6pJQXB1FMKXgA7jzIe4YQIhSQsLtR2bSb
         yscMPecjay4IaaF5BgNwzVE0hz/dTYAXwJ8ed8Aa0gxHmcHVqFqtbw3kDilenfNvdvZl
         5zLSy48vG5187M4vBZzC5qIPTPm32eAptFVzCYXfQJ5vOC1KKW8FHt0+7l9SkIEtzF7N
         CxXg==
X-Forwarded-Encrypted: i=1; AJvYcCWUFDltgRvccD8HPWxgFF1zS7qLSYFEpmTmOSyCExJ682tTU7Tf72GD32Cck6Ay14Dv8jLCdHhu8RDgUxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEI1J7MyV/SSlAlHsVvmTCdaSOr9kyXqdwDro8CWUP02tMdRN3
	MjPA9u1zgmTVEqN8JblVEsh3lxZivZu/OLqsvOCSxTwWwFt4wdedQ3C8acoqf9lOUM2b8UIG3qE
	67FEDOrtoOlzSv8R3xrKHPLrh2IVVh4QdE83Hi8eolkK9bVCAguWm9bXCEFYKjJ4niUU=
X-Gm-Gg: AZuq6aLmE7V0RGGxfXs0SJq3OR5eUSRVwSINflJPhJc6S9s8p1msoCIOEkLCXKfEDfK
	sgkm5CTFiLciciSw0hmW9NyEzrrJlBvwH/MRZe6oMqTL8njEmR3Bpy5YYRVV4alXt0EGYV+f560
	lLsnhQ32V+DvHJNYhp1jXsb99FPHhTAkrqOPK3lwpR/Z7ijC/kRV67pxiA/BdbhZVh/pGm72pmz
	xeoht6a206RX2QfChLfz/P2UBoWanYUOp99CJxcF0WarSfjnoUbgWKEFesMfrhFWTi+BQe4ykLP
	w+1J/6LTYO9qQ9HVwx0AiCiG+RaEvON79WjY2LO4oAZyedcvgl8f0KLC4AEi+YN6hY7NqxRZOHU
	Wie/efd2mGYtzoSeYgM2iFZjBTSKRXUHCw/9oXhw6Vlj6tHv0iaU2NMYzBaVbqd7j23oL0iqmZN
	E2Wfg=
X-Received: by 2002:a05:620a:318b:b0:8c6:e2a7:ad1c with SMTP id af79cd13be357-8cb40850a4bmr2122380585a.5.1771510836607;
        Thu, 19 Feb 2026 06:20:36 -0800 (PST)
X-Received: by 2002:a05:620a:318b:b0:8c6:e2a7:ad1c with SMTP id af79cd13be357-8cb40850a4bmr2122375785a.5.1771510835889;
        Thu, 19 Feb 2026 06:20:35 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9048d96bb0sm116689366b.18.2026.02.19.06.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 06:20:35 -0800 (PST)
Message-ID: <6d2c99c4-3fe0-4e79-94e8-98b752158bd6@oss.qualcomm.com>
Date: Thu, 19 Feb 2026 15:20:31 +0100
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
 <3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com>
 <aZYMwyEQD9RPQnjs@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aZYMwyEQD9RPQnjs@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: SlM82MU7uVYMt3KTTwVmZpfoGuZAAIGO
X-Proofpoint-ORIG-GUID: SlM82MU7uVYMt3KTTwVmZpfoGuZAAIGO
X-Authority-Analysis: v=2.4 cv=A6hh/qWG c=1 sm=1 tr=0 ts=69971c35 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=VczSQE6j7Ae0sFSu3OgA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDEzMCBTYWx0ZWRfXzBE6TUoK2Cdi
 VmRH7xwmi381HVeoOAv+xoXeDGeMd2pjjied322AOQmfqwO7q4JQG794aCokdXOXYUlw2x6HD8I
 B3f6e7ClxmSwTsoWWRSALu2YRYMbMmKe68x5V+0D7Vt1gPo5My5H7jmOhbG823fujMU2UFKfbvs
 WfiGO/LgzG4Efmxa96X4kOlZ6cuYtB6mLV+nhNPuOpTO2OV1BtqqRww7rrdBkqj/qQGxcjHfGmt
 QKMun3qfALbm9FNDjU46TUgCK19b0CsgVl5SM7oFg7rVQsnvh5SOsC2q05DUcCCRcysK5GOSi6I
 Hp+hxlIWaCCSpw/ovBWskgaJE3w0FkgAkg9xoOxIhuB4IhBjkcpBNWiak/75+HO/yXoCf3Z659w
 Xpx7uBFTt6JS2KpvpjNJB54zeYNK1igdHuVg1+L++mcxckl6utjRaXSzacCZofIPEd7bhAuyjBz
 ZcTxTNMFBP6mVMzFXHA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 adultscore=0 impostorscore=0 suspectscore=0
 spamscore=0 malwarescore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190130

On 2/18/26 8:02 PM, Abhinaba Rakshit wrote:
> On Mon, Feb 16, 2026 at 01:18:57PM +0100, Konrad Dybcio wrote:
>> On 2/13/26 8:02 AM, Abhinaba Rakshit wrote:
>>> On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
>>>> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
>>>>> Register optional operation-points-v2 table for ICE device
>>>>> and aquire its minimum and maximum frequency during ICE
>>>>> device probe.

[...]

>>> However, my main concern was for the corner cases, where:
>>> (target_freq > max && ROUND_CEIL)
>>> and
>>> (target_freq < min && ROUND_FLOOR)
>>> In both the cases, the OPP APIs will fail and the clock remains unchanged.
>>
>> I would argue that's expected behavior, if the requested rate can not
>> be achieved, the "set_rate"-like function should fail
>>
>>> Hence, I added the checks to make the API as generic/robust as possible.
>>
>> AFAICT we generally set storage_ctrl_rate == ice_clk_rate with some slight
>> play, but the latter never goes above the FMAX of the former
>>
>> For the second case, I'm not sure it's valid. For "find lowest rate" I would
>> expect find_freq_*ceil*(rate=0). For other cases of scale-down I would expect
>> that we want to keep the clock at >= (or ideally == )storage_ctrl_clk anyway
>> so I'm not sure _floor() is useful
> 
> Clear, I guess, the idea is to ensure ice-clk <= storage-clk in case of scale_up
> and ice-clk >= storage-clk in case of scale_down.

I don't quite understand the first case (ice <= storage for scale_up), could you
please elaborate?

Konrad
