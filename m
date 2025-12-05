Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA533218B3
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764934173; cv=none; b=rDTldd908CL0/wM+t6ly54S2gf9zR2EJ0fIj/rx5lUafRmWDniV/bedxPn9x3L2SBPYUOhkD42KmUL69+dCvJOEOmxV0OCLuNQuioRAtbMhhpA+7e/Hf7ClSd84Jr1NRda/GG/bnOhLzNRhaQFRX4eyBL8Tn1rISiOewc+3Af0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764934173; c=relaxed/simple;
	bh=2QbpmW46B2AGPfg22M8RWdwNWnwwgqRBCb3JhSiPqEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KZgOT9+T4PP7CDoBLlcreHD4HuKqN4A/47WHFC6mDjfksCvDkOVDy7omLjh/r9mQaMI7glT5UJ2WNKFhNIOcCpbWx86HS6NRT+W78HCcWh6v8MXC6Arj6loxSaj0yRQU1Iw4Ls4VwjKi/LaMAGuWty8D8zQSr0+LdIVkfN7c2C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eAXGOvPi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RtDREsc+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eAXGOvPi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RtDREsc+"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B5AiLpL3135729
	for <linux-crypto@vger.kernel.org>; Fri, 5 Dec 2025 11:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LWL0ydM3L04AohTCdbZotp5wDtMDsHUfvxSpYEhTDwc=; b=eAXGOvPib2vDWGMr
	oXVzROqEKnOQy6BOu6O9PlL/6wDazam85enpte7V+1dF30wSfFW44URGoenppFeH
	VJ8g4loGrYXtC0T49kU+Vkxja7FdQdZiOyOjZGDXb+RmHx6414c3tK26S8NPMAoK
	1kDnijXJXLA2rZgD9DwXDtYpApVv1CX1yYyki/iDUd/NdjHEFVfkY2jsaxtvfZOZ
	R7EecJS2E55acTzV7rTOVqj+kuSYGvYjugfzXjgwLj2fZVGxiuk7hyHbvLrYgC5s
	v9YBIJeXljEgV6kFkTBX4TfWwbKh58Gg0/PpjMdOJmwIMKF6fo9t/Y5mPwPrYf/k
	HJn+ww==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4aupa8setq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 05 Dec 2025 11:29:29 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ede0bd2154so4999371cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Dec 2025 03:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764934168; x=1765538968; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LWL0ydM3L04AohTCdbZotp5wDtMDsHUfvxSpYEhTDwc=;
        b=RtDREsc+cNLaWa1i7+Rx6GZQffsxwgVnalm4BW0garqY5dhoWwLfnUcASrSXebhR3z
         Zil5sP4xR8jLAInnrWfcQhw2IRv3UYf0cgmi4dKCcVUj4YFkqZXEy9wcdJiopfiNA69+
         Dh0v44dLj/WJxWzqTOiJvmsAMSGBCQosFFowv5oYcxK6DjrgVfyvzY10phGMV7rXQWQw
         ktQdd27FBm+48GfWeDfFe4jhJ1vllj4TrZnUoCR5GTLdkLGlKgZ3x9LtFWDgVcO3oYlv
         BcSKwYgPawBRTlQ87U3zjBazFIcEE2YNTcPqDi5ixhmyVhZ1hCA/X1VGkGS5FgtmW9uZ
         +bnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764934168; x=1765538968;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LWL0ydM3L04AohTCdbZotp5wDtMDsHUfvxSpYEhTDwc=;
        b=wufDlw3VfGmMTm7sMpNJ/xhD/CInyyqQ3ENSkMTX4gitJtbpeuAlpxOrqguFsi7jg1
         HAmMMPVJ7BFoSEN+xGzIjK7ws31Cvwpx1SH3C1rhFtjLSlMM7IhC0A88wwGoPJ1HC97X
         OOv8fHOcCm0Ac+wK8uXl2XEYUKlXrEEzjiNoHwhgwLRO8o8r2ebVY76Qrm+qp+1wDB6r
         KRbmSoytKrfe/HXj2qPUFc2hJ3yL6Y9uGRC7gau3w/HsiZjpty4SawLXmFtIixmMoOXZ
         s+g6ohvb1uCMumA2X9aOe4AxP5604wH94DEewFiZOAle4KfQ44J6iJJEegpIXcGv5AxZ
         QDSA==
X-Gm-Message-State: AOJu0YxI9voZ7wfWJrxvUJDK6mV4MCWOV5IkyzZocs6m/R5nhO93VGXc
	Fz5TyFC14xZe8bN+WuCC2BFzfNoYxVMpR1GN5BNrKQhD/w1x4nc3+kUeIBcyiCsigN+3Vzj1NS1
	ReYBv2RIyGlmgXFDMwcj7G5CTBxniOnx2AwuRuEEwKNz//kIEWQVHW+Pvm5wrLgUokHDlRGOWi4
	g=
X-Gm-Gg: ASbGncv4HbScEaMT3fhk2RLd94P2F9eKmQ1ddmKcyajnB7+JysBzviaQmE9+4OjjxLV
	SvIDiuwWViN9CEuqU4qFPWBEFTR8QKvE8mEsRLxvJLpMHvutH2ZFJP+GSZgwdHzAwUXp2As8eOg
	hwPpPrUuYpnJiWuzuDt11VAHd9Ws/wz3PGScU0f4uxhC7COh6fRX8NFdkbwjJ9ZXKjxb/He6AYP
	iq+zQ8h1iM9ecasvalIVT2aJNEELL/4hyBWMQ67RWnNhWE6AiExKHqqKaT9VoDL1zbfqFBPWqX0
	n2mJVD6S9dM+yuO+YAiOD/jx0JlZLeOcoR2gtIRPuCWl5D4Mg8lx6xSHdICXPQ5JLX0L5TskHFo
	lJTI5FU90fDYANaD0iEv5dmUbWp66tH+TXzZlfyP/U4uaXZCNZ5J2gICaHhbHWQKpxg==
X-Received: by 2002:ac8:5ad3:0:b0:4ed:67c4:b7b9 with SMTP id d75a77b69052e-4f01b092f51mr87709341cf.1.1764934168486;
        Fri, 05 Dec 2025 03:29:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEa1ijzoTxkvUrge3Gxt0hrZV7i9L38lwB3FXCXbmtB3yye8Rnw9ekPcTmVNaAdPycz01M15w==
X-Received: by 2002:ac8:5ad3:0:b0:4ed:67c4:b7b9 with SMTP id d75a77b69052e-4f01b092f51mr87709091cf.1.1764934168031;
        Fri, 05 Dec 2025 03:29:28 -0800 (PST)
Received: from [192.168.119.72] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b41219c1sm4054011a12.27.2025.12.05.03.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 03:29:27 -0800 (PST)
Message-ID: <a2c6cbdb-a114-423f-a315-6e5e9ab84e5a@oss.qualcomm.com>
Date: Fri, 5 Dec 2025 12:29:25 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: quic_utiwari@quicinc.com, herbert@gondor.apana.org.au,
        thara.gopinath@gmail.com, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com
References: <20251120062443.2016084-1-quic_utiwari@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251120062443.2016084-1-quic_utiwari@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=ZqDg6t7G c=1 sm=1 tr=0 ts=6932c219 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=COk6AnOGAAAA:8 a=HDohle4KqOvtihE_74YA:9
 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA1MDA4NCBTYWx0ZWRfX9i4AKVY4ODyh
 TNFd18ge+BEERFy8oBoWy1Chq5ERPX1A2lUILfTCGYuhvKhExOF96SPfiWiZh9lCY8G6WPg0EtW
 OXAlZbhng7rG5XsGvb2WoW84Tyq6oFLnYJRqVYNhvt1YQ6ziT4CSXWQG2SQAuvx0C6y01GmOBxe
 374ZBWxRrXvSC/VqXogN6lyjE6QmjqKdMogSBbgpwSyDKd1ncRTEjnyaGXqhGApWV+S+uhDoDH9
 kpJG0yFOFtNWIDwWKBET0H/3u5Jue8WZEyF+U7CvjuZCnrA7RWT+njz/uLEB4fVRqOmdH8Fm22Z
 JtXbyyorGbArSetvpJ+/N+T3NrVRYUxmzkBPA8dMhaBtGkpHSDdKiVg2JWdIrN7btJT+o34qJOV
 AsKkUJ7zG4TNoMenRDQr9jt+P/veJQ==
X-Proofpoint-ORIG-GUID: mhfuDTSpxQfws8SdaM_kpY5oX6eAHSnk
X-Proofpoint-GUID: mhfuDTSpxQfws8SdaM_kpY5oX6eAHSnk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-05_04,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512050084

On 11/20/25 7:24 AM, quic_utiwari@quicinc.com wrote:
> From: Udit Tiwari <quic_utiwari@quicinc.com>
> 
> The Qualcomm Crypto Engine (QCE) driver currently lacks support for
> runtime power management (PM) and interconnect bandwidth control.
> As a result, the hardware remains fully powered and clocks stay
> enabled even when the device is idle. Additionally, static
> interconnect bandwidth votes are held indefinitely, preventing the
> system from reclaiming unused bandwidth.

[...]

> @@ -90,13 +93,17 @@ static int qce_handle_queue(struct qce_device *qce,
>  	struct crypto_async_request *async_req, *backlog;
>  	int ret = 0, err;
>  
> +	ret = pm_runtime_resume_and_get(qce->dev);
> +	if (ret < 0)
> +		return ret;
> +

This is quite new, but maybe we could use

ACQUIRE(pm_runtime_active_try, pm)(qce->dev);
ret = ACQUIRE_ERR(pm_runtime_active_auto_try, &pm)
if (ret)
	return ret;

and drop the goto-s

Konrad
