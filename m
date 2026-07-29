Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9D443A7F4
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 08:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785315373; cv=none; b=OELS5am4dic5MRQBq5GcqGwQWVE7PEAUq7FY/K/9I3BUNCZ35Z5abl9pLt1K+v7UzfFhAyyAOQLvLO9XbkTwjjiWLPxgIq0j9LSSn0mjH0pZIx+zfdggg2c7Va6nv/07WT9d7fXxiAivDdbG80+670cTz9gM/Lb+DinIYPCNeNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785315373; c=relaxed/simple;
	bh=FLgawzuiib38/bmMwP47vHuIgdaIxTcjNnI6O8d7RIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RS4bbqNFZVVr071PI2Xf0w/iwxBUu6s9vQwWENYlXJYjctKyp46gEA/r0zJIaMkBaN9wH12A76G8j7cUSxagjBPdn9zoy2lPACDk0Fo0bFEeUwhjV+DxU/357BOSIFTMbBL7s31hfCOeyisMVbYuNbixo6Q8gIS2VGoz3ZCB6Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FoOoQbfZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KW3omwDY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FoOoQbfZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KW3omwDY"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T7etVr2326509
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 08:56:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pxZfcIc/FcVFHb6JANdHjj0w/Cgi98STqjq6SMmiLi8=; b=FoOoQbfZvQA8W+1v
	KbBOY6zXdaiy4hF85WJh754oG3TGReXqFo0V3MKNtM+5AEcziBCvXXJlRCl4JEE6
	Gy7TYTYXNVZzmDNTfjxumhDP7TF6ipuJ5NO8aK6ZR9I/Udhwb6mDWov6zvS5DtC1
	kgl0Pdo77dy4wwJWru9LM6hpoF+uzErdpLZv9EYBfiouzeAeI6LtywwkEIup76M1
	ZJWXYdUGHYW9Rk2SYuizll/EuQWEq9YD0sUPVe4D/aaDiSAG4OZyn5npM4KUSWAA
	KjWDQ0F7N/5TZlCI4lkTfFtMqhPjCuda+g7DpiyiFp9RZg1Vp4NXR5tJpHGYjUbq
	qPj5Ig==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqbm1grax-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 08:56:11 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d001671a54so16622585ad.2
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 01:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785315370; x=1785920170; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pxZfcIc/FcVFHb6JANdHjj0w/Cgi98STqjq6SMmiLi8=;
        b=KW3omwDYxI3D3CGlAqz0+3/1iNs24rusX89FhxqjQQxLiR4YfYxKxnGa1JBRv6TJe5
         j4hv5ou/aMPDi7Quob2BJeS+ihFR5BWjHjf+v7yCcMTT6xnFsvf8tNs30VbmJLr+r8yR
         ZVQ8tDacIuK6/rWqj0KNrbOi2x9pghz/YFzOqJ/VeZygjn5WP2EYpTLIxRf6upFpRQ1B
         R0mUwB5hcoRS/CEB1WXcegCcT6isa5JiyesFTHtjfMr68epDhjAoxLfZQszaAXCsuQho
         NwYgv0VOY0V4cEQ8if1Arb2qkSORXrOtpu9FD9coxlJchD/DCONrNGtUv7RP5myxODBb
         FmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785315370; x=1785920170;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pxZfcIc/FcVFHb6JANdHjj0w/Cgi98STqjq6SMmiLi8=;
        b=SpduFry8e5H4GHSqD39MVcEitj5D8M4hJe8x8YwNs0y0eHD2XRSeFnOGSFUz3JGmiw
         WyqwMuEca3ZLGVj9tpk8MhBny0qYFQCn5HKWVyRq7NzLS0wMXY8kie+UnshrZkYEap0Y
         n8PG753MIjhUHcCS5SNNDxTOQ21pr1Cd/DDIOG8hS3ZYxOMFcVTxEXMR8KHCZHnTHqpA
         67WnBPJSmfuuT924MgQZqdaDVOwn4dWJPJ+maK9EjwG1IFkKGDdLHGNaxxz/PfYH19rG
         T5DzSoHEgzaFgzu9P32nW2J+mbtqK2xtLtE/G6wNH8Px8VeBBQ25AeICN2x5DmCF8g4O
         OXzg==
X-Gm-Message-State: AOJu0YyRtSpeOByW1ONiSrwUTmWyUtbC3qtsIIiUaLHV4jypmDMX6nbz
	Rb0jtHWogXFinh7qiTocKfqK3clTXvH1Xc79IWNMJwN5Z8269CasFFmE4ZqgTPLl/cCLsVAGU0w
	s5TyWRVbfxBPDSOQyRhJ7c6gW0exdVPqt8QVu6/hztJOtsJwLYbt2DssSypO8Nq0kGO8=
X-Gm-Gg: AR+sD12VnSSWFuD5PRr2W4yTYyDz6swvxTSc7NM6AascFRXDomYe6tlgwrW1PTwGjXE
	1uVZ2L02inuA4vbiIlDQPcLMJAadRjmntWZh/Vj8LPq7S1q9jCoi1DNEptVvZQjo7uoNg59UBoP
	pG/TS4edamKqCHk9ivUFuxZzjC0DkzAyc5HtiF4SZ43xlALNhcH3J1XS22KXj+SjELjb5yQbQEN
	DPJhOyz2H3A2By4sX7CTbl/C2QE+1a863clVW3hY9EDTAikYwqHQXyIV+pXZHfDufni+FvoBZaQ
	GGsre6Lr/skZoUG/1MDZac4plQXNPpLaAl6xbikbmX98qMqfyVhHkGJYYYKl9AucWrRnAzGJHF/
	X4Q7o9bL8Jivg7ZDlvBT/NvQpFoAQJiA=
X-Received: by 2002:a17:903:166e:b0:2cf:7d44:e14f with SMTP id d9443c01a7336-2d015d44a72mr67845205ad.26.1785315370381;
        Wed, 29 Jul 2026 01:56:10 -0700 (PDT)
X-Received: by 2002:a17:903:166e:b0:2cf:7d44:e14f with SMTP id d9443c01a7336-2d015d44a72mr67844945ad.26.1785315369947;
        Wed, 29 Jul 2026 01:56:09 -0700 (PDT)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bf39b5sm7969865ad.57.2026.07.29.01.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 01:56:09 -0700 (PDT)
Message-ID: <1455590d-ac61-4f8c-ae0b-7cbb2c38ab76@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 14:26:05 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Udit Tiwari <udit.tiwari@oss.qualcomm.com>,
        herbert@gondor.apana.org.au, thara.gopinath@gmail.com,
        davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com
References: <20260517105233.807935-1-udit.tiwari@oss.qualcomm.com>
 <d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com>
 <f19fa79b-82c6-4cb7-87fe-43c9b92907de@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <f19fa79b-82c6-4cb7-87fe-43c9b92907de@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA3MiBTYWx0ZWRfX5HrB74IVu7wN
 oeWCXO9NBY5Zwno4TkfSqIpXmsJYAMd1V0AmUM+TvYH+SW8i6TcIRum9MXvjjyW8ioh7cd77HTU
 YBCfy37cD5BpyhnaK88oGuDNzVZEpuRxvAyslj6GCvSXrraHmmf9I3SPkM1oP60DQ1h1W5tfoct
 gQKdku2aMgV/5gWjaUFS84j8Vhhpic8Dh7AXVRPE0UQlAwU4FvCbYULZev6vughO0lp+UVFvSUF
 kxhEF4CLNT+hPaFw4bxY0dWbF/pSUZcOFXVfc1BqLa/FLg4DnyTI+wAfNw6NNQoFbBK6bh7FPvY
 8SYgyFq1EXPFmBgoo12F6/fw05mP4q3g+OKk7imK4laXfhruUBrOiE1pmNaA0A4hcCWJGQBAjS8
 IpxmQ3h+Ry2NqavkzOwsiLn58c8rqXX9/fkVMYkSM51/Es6AZI3kkM2XhbJ3aSzPiN5y+xC4tfD
 SFYLZE7Bi84LHy3zoqw==
X-Proofpoint-GUID: C5IHuEWBakxhOobint_dmfvxutoDPbnq
X-Authority-Analysis: v=2.4 cv=R7Az39RX c=1 sm=1 tr=0 ts=6a69c02b cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=hkcS3Ldj-Qh5X0bBtzIA:9 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: C5IHuEWBakxhOobint_dmfvxutoDPbnq
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA3MiBTYWx0ZWRfX9t/uGGFj2pEk
 Y6tiFMmbqk27Ng+Dvg9ufQzzySUcsv9vfXvOsGZuqX6zFDPRcFAVHJnE8uDXbu8ACYaOgMVjWm9
 wgdZOcqgxz5m/FT/2l9zTtJ3dnsB25Y=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290072

> This needs to be rebased on linux-next/master

This patch is floating for a long time with no reviews/feedbacks.
I can rebase and send v9 hoping this will be picked up soon for merge
window if everything seems good.

-- 
Regards
Kuldeep

