Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9343E9299
	for <linux-crypto@vger.kernel.org>; Wed,  6 May 2026 09:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778059976; cv=none; b=MX0SRwfKz4aexHiGeIuBK+pcF1/Nqt9djzl1kksmw/wiIAGgM79YNThl7IUooQbi7HdkqzXOmjq6tbahRLlxrYZ/lE5kmV7BTh2tUIJ6W8V3+V+2PxX/m6LNg8K6bYg7LAnawyz5AsaJ41pPM3yaODyPRGWtVmEu/UWuW8PcFko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778059976; c=relaxed/simple;
	bh=aCWCeJiNrXPS1VKbBYDxcuGhg0ZqyJcxbC3dVJWs0q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aQRCzlMbvQNdNkl4JWOc+Xg1pwXVkNksovTk9SoQHfauTkZFGMB92THVERP0tCxHcoCzacnnQt1QCUrcBoeUBfgjn+1fRdK8UhM69CrzcX1SeCtGFx/E0/BAxi+y3oeuEPMyC9E0uLYueP+oDTG51nSyTP9GEOXSUm6u6EXtmyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NDDXqJCW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IxqLbY54; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NDDXqJCW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IxqLbY54"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 646813TD1434895
	for <linux-crypto@vger.kernel.org>; Wed, 6 May 2026 09:32:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1mTTk1pROV6By6vVpOchigpFI99l60HptIVVRd/8BWY=; b=NDDXqJCW4GmJC+xV
	ytI7UWkWgs+GHi0XRxzdQcbF6ooKOvhv6eJReSP4MVvKNX1pIEF8PnLHT4en6Gd3
	mZNN34yMncrH74RNnndTZPzVpoNnOjbS/YER28gswTS/mFrXNOjuhEVWdP0SNh0X
	Iv6wLXSIT0jSkUd6t7HTlxbTsJxV5SfiN1B5ueKTLQq+kpyy9Xq8uI1bgAy6DB9X
	BJpP42pxYA/uy2Ebv56VI3lN4TsOAKlSgc5hP50QAoSxjAoHJ197yY3uBAXxNaVs
	0OaT7u3sYoL3dT0hHI+gpGEe7PcyRe9arHTiL+4KgnU6565rz26K11yCevuc83y8
	ihcpHg==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dyuqdsqtk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 06 May 2026 09:32:53 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82f9429f49cso7559250b3a.3
        for <linux-crypto@vger.kernel.org>; Wed, 06 May 2026 02:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778059972; x=1778664772; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1mTTk1pROV6By6vVpOchigpFI99l60HptIVVRd/8BWY=;
        b=IxqLbY54l6IydfoaVJUwJxzYF29yHUEi0SlRGbne3ldV/TnTYGdC62yCs4MjfWkevS
         QqHl4k01SbwY56m4LQi1HMe+eU7EzRfKgQaerjtrEq2H6WsWw1NLMCgRdoVmVuRAL0Py
         Ytas9m9dCzwAKtUlcdT3EzaeBsIVvXoDVuZ3C9L4VIwgHKkqOu5/YJVnoRx7N4oFcEDw
         mradrUcLoT6DTzwbYfSK0wbisXaj1b4XNMnR3efKZtsyWDCSqy2dffR8QA3GZb8hTPNL
         pjlj7/uNZnDolvRlxyJ08X8IaupbqhGjfs/oPjujQoi2fcfEfRf30ycy6VSvQoOX53UC
         R9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778059972; x=1778664772;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1mTTk1pROV6By6vVpOchigpFI99l60HptIVVRd/8BWY=;
        b=Mx6LJF7h1vQo6Sgy2Ridc82A9MBoicZXkH3H7N3WolaK3ss/ZfzjEMmRe9tCfx+JyT
         1A4mOmzadqtPskQvNhpjCQ39ppz0GJP/UzGaZKXiYBKXurNXtymzEvg3Fk9uBVv1n3LW
         m2SLtaf1SJLa94l1IvD0dUJp3wqp92ny474b+dPHT25g+c5C3HEe0zPjW6klMh/srlBF
         G3EmWt3pYcCq0qLZM5Bp8u+mTg4BfZU+7PRwT2LbrEcNtQ1MrwRrVbmORRCE3jUe0CuK
         iHNQYCy7AQdg0qSjnNQpFvdX2+AcXj5Sk9bPdmBBgQTTN/tpuwj3G1wJfWhL+XZE8nyu
         7GkQ==
X-Forwarded-Encrypted: i=1; AFNElJ/4qQv6zvK7x8KD7sm2fEek9CNVtXUrCVW5ViiIBiaJm6KnKp2Wt3AIwbRqzOoOqO+q+PuuEqKoTcxaJJ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBHxdEhpbzr4IC022SnlmQ/3znFLrsKlLmBjDY1IzM0GwNZ2fn
	cZqUv02YE1V+shQiFtSyDYDnoXB3otrWczhTTJfqbv+4iD3Zln/w/A3cqGEGW4F0tTzQFfahejW
	NLBPjp9t8l9f5OCtP73lLbs8qiELx7r2bUwEDggFLlY/GyKnfkOo28MC6bHLL1KeZWdg=
X-Gm-Gg: AeBDieukHoTIM/bGaKj+/NIDm5zIXKRM8PQjlC2s+vdWdAy/9uTZhJNsqRSlqMmJhTG
	3VOneQNLfNrjVGzjkWjQ4XTT4ujXkzKZtqKKGiiq4S/z06zzeG6sRPxg+wYFzoiAEPYY9wMGPgV
	LX+vakD3CQKTuDddqfzt0IDBctbFpzhKxdGfKCEXIopCxRggic9T3cAkzLf7YqapGsCedb1OIOm
	rd+j+zf56QOZ/lsSiKXbTIMLeDL1Ny6K1nCZBdLJrVaXwXl6Fvh52zuFnsLmXc7OrvH2MlmzFOO
	cDpxEJWpZsizNvXcrd82mbWIFkGRLKF1d1/1h/MDfy6dZTv+5/2Lqu+EVrt3J9YzkCFW49rL9SP
	KE+luGqkd/Tip5WjiP3Mxuv0ewc54zLa0aJb7oEtSJlvDN7eGojwiDSXdZf2CAw==
X-Received: by 2002:a05:6a00:428c:b0:82d:162c:581f with SMTP id d2e1a72fcca58-83a5eb3943dmr2408176b3a.48.1778059972343;
        Wed, 06 May 2026 02:32:52 -0700 (PDT)
X-Received: by 2002:a05:6a00:428c:b0:82d:162c:581f with SMTP id d2e1a72fcca58-83a5eb3943dmr2408142b3a.48.1778059971853;
        Wed, 06 May 2026 02:32:51 -0700 (PDT)
Received: from [10.218.19.63] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965b333f2sm5895467b3a.20.2026.05.06.02.32.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 02:32:51 -0700 (PDT)
Message-ID: <5864c10c-5ad5-4896-a503-c184f4ee7717@oss.qualcomm.com>
Date: Wed, 6 May 2026 15:02:44 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: glymur: add TRNG node
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
 <20260424-glymur_trng_enablement-v2-2-0603cbe68440@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260424-glymur_trng_enablement-v2-2-0603cbe68440@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=W4sIkxWk c=1 sm=1 tr=0 ts=69fb0ac5 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=TjbBIv4-FJWQbs9x9KIA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA2MDA5MyBTYWx0ZWRfX/kLBTAT+n5Ht
 la4zbGf3ZHftwHsuq/bpAfAclNKnnkloT+S0MHXHvBl2P+TrBhgylYWZyijUXcTINF6zhmM7D8s
 pHb9gPd5gpfDEQAzk7ZRQFPKVpshUweSynBA0uu8J6vACp69nDZzZNg1RmrbT8XXX08bDA2kfXH
 o3gKVXSK7GiUXVYO37q+6jSzk7Z6+o8HM6uUgmLbuf5MHySOilEQQn/BUE/jm9TmsJro46z5lQ/
 2lbcIEh/DACuB97tcePS24kYxKCJcWJ+aWEPYbTO1xm0d3C7YurgElZhT3TiST7UOiuuz4Qfjqc
 I1dDnZs9MCmJbI4CFRLQSUp0TzdCEScGZStLbePMwJod14ceat4tkOjp0CWtiU14BxsnjGcWTtq
 lzQQE5sPMOF6Du58VWB4rWjS7ziyI+fNd9iyVfI7Jr/usP3LfvCzHDJcTCeCUYEsgmZ9BKGuy3r
 L5QV1DGfNJn/P3U8XkQ==
X-Proofpoint-ORIG-GUID: hgMNc5PG-zlPng13mcd7Mcab6-Bdn07M
X-Proofpoint-GUID: hgMNc5PG-zlPng13mcd7Mcab6-Bdn07M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605060093

On 24-04-2026 14:05, Harshal Dev wrote:
> Glymur has a True Random Number Generator, add the node with the correct
> compatible set.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

root@qcom-armv8a:~# cat /sys/class/misc/hw_random/rng_current
qcom_hwrng
root@qcom-armv8a:~# cat /dev/random | rngtest -c 1000
rngtest 6.16
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is
NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 1000
rngtest: FIPS 140-2 failures: 0
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=1666666666.667; avg=54945054945.055;
max=0.000)bits/s
rngtest: FIPS tests speed: (min=186.995; avg=280.435; max=334.623)Mibits/s
rngtest: Program run time: 68912 microseconds
root@qcom-armv8a:~#

-- 
Regards
Kuldeep
