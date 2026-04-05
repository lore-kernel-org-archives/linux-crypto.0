Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB142D8DDB
	for <linux-crypto@vger.kernel.org>; Sun,  5 Apr 2026 22:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775428921; cv=none; b=GgRuPTlY8teEzdKLsQNh0ROZJpZGy+7GVBNe5UAjX3AuYWjpJvx9xPGbWCGv6wl5oJ5vuOTQcqTmV2u2gAtWkbF6uXaqf2cYEJJD3dtA6MmIJYPxsflkUWecor5VQhkdobxCHjvbhyDjuyv0xNtdSQJMj4DviBaneIIMTYQTCsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775428921; c=relaxed/simple;
	bh=ZYwBfPbzxvAcO9wNEIv1uS7MZg/5/tJ7dM0qM9V2B68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FLzY1BmsMR91AQ0+a+jfWJlfBj1eOSp1gsB7jfpspAUR3z5IOQFwPzQYJfQvhxfw2Tut5IIwdpJdKy0aEV68c0G/2mPZmAMlXjpdSkaSZYcTp9V34+Iw1HVdm3IkOdlEaW/hn40+g1M2bnxCnlq0ni32itbf810krkfOpPK8t50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZYo+AyJT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QQg0THQw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZYo+AyJT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QQg0THQw"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635MVC9U1056963
	for <linux-crypto@vger.kernel.org>; Sun, 5 Apr 2026 22:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nV0P98lyDdzdwF7jAXLCXCBbvBHVzZd/AEsYBJrQ12c=; b=ZYo+AyJTFEyylReX
	K5VtAcGHMnD7MaIrxRHkzfeKzMf5Z2goztsBRcsjDnR+NvO8x376SytupI13qs+B
	f/ce1Q9Mfx1bhD0TUv0vf4HhkhDVP8Hh7gJnmXzNOO4YVrdqjG/WpnT2I3wveLrU
	xEaoH94xG0hN3gzlXHizm57B22NnyjbnViPjssJoXrqM3KWjiEpsfwRX0rjIAjKw
	VznmM0QjVHU8adYqUDmgRhCH+9EB6mGMBispXgklJ/ohclERJT9Sp9q+kJWcT3GD
	phO0o2lOlEA++6A0qBt2GlYnV3i/b5meVRkwLGLPdQ+7F6SODjTrpNx/G9Og/Dtu
	vO+u1w==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dasn5uc8w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 05 Apr 2026 22:41:58 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2d054421d19so85371eec.1
        for <linux-crypto@vger.kernel.org>; Sun, 05 Apr 2026 15:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775428918; x=1776033718; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nV0P98lyDdzdwF7jAXLCXCBbvBHVzZd/AEsYBJrQ12c=;
        b=QQg0THQwJJ9xnRbHwQT8UYCEyTyb3gXioaU7N9UMZ8/IyYcS+5/I32wcWnYZL6J8wz
         WNCzOCPEZasHnpExhlHwBeKHsSSThgi2cZk2mElVJuEDaXp930vkcWABTGbBPA9Hmb6Z
         6QsKQND+HWcDcjUE8IMnerCllnYoN0uCTDt2hw4F1CEQzVcQyKnyAEdYoAG49ficRpOM
         /u4ksB6i4wuHnuRGsLNsX+Okw2bcEyJugv10yn88WIKZkmtqHTyoKUragHDuxDw/wrMD
         cjzwrMCw1N9Qp1sdeQfPN4Z3SpQPIs3Lva5qRLJiUZNww29Z6F+euiUzfH2MXdE6vRzV
         2KSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775428918; x=1776033718;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nV0P98lyDdzdwF7jAXLCXCBbvBHVzZd/AEsYBJrQ12c=;
        b=KO9rCDM/s6piOkBPpKF4YXSMqcaS9Ycpw0DAcPhAqPSmb/V0iMstv15DqHt5jCrn+q
         mYb6RS4pT1kQr0TCeAzpYSwawQD3xrIkH6TPxDMVqrD0C0Knz+V8ESiYqgomtlxN7xWE
         XCzrQvRGOJb+RjeZ9jKE4o1XTcqfRsVRWgqQ3QEgFYPwzNJ6N0oG1HM9DhAZzjvep14u
         Uq7TRettZuKch39pWxyh9w0BVL6x0EziyXAmpG+gniMbuY/vQfXkVj2AGbMREs7kXpOE
         TZlFY045+ig7uXRoFVvj7FbeuyODr6mnVK7fUGn4TpS9ZZIicYLP69OKA/8ahFkn2Dkf
         pGgw==
X-Gm-Message-State: AOJu0Yx8IJ8HrngpQs5o8y9TYMgynFgAhTJbdw0nExygJmES1lUR1W5S
	zp/o1QByjYSDaIUrDCk/uxnp8jflX+HjKvNLLJOSBeVm90/doFpBjn4VfrUAG9s9CQz0wxVdGnc
	BPJD6R7ii56nk2K+AjcEMlDZp9Q43koE2cSBAAp0dtPn0u4d8jFtrJq3xume8O77ilYU=
X-Gm-Gg: AeBDieulo9AJ7ie4NcnF/HVoratfk/XPE7wjgntYL0XiZB7kLJFlQ7qG305z2fipriP
	sYzHfRavbe1kkhy73dsr3la5/PAygjAyVESR54rS+8jfpaH4Iro5Kw/KIKTkfyUy/RWjCeGR6ym
	EEMqT7ess6umudDYV6BGvkuBu5hstzMR2CBeBvYJ1S/Ufmz6iiscW4cYqeYD0iXqQInNzif2FYh
	htKYgqdTjrlvAY/875NELR4rqVpqQDf4EMm2K1kC3+qGMp3MRWRmCIpKwm6M5xn3K4JOAPP1ceA
	OWRJRDVqOzuljxv4Ncora/w9G0bGxrahl9Dby3sgnxmRi/nOQs4QKBy4kJ4QQMmQFtOTQEfwD1+
	XogNDQ86cF7JoYFPJbTovV3jRuwHQyJ/i8BvwYX7X0EOEf/FzwfsWopm7VuSmhlHFl+C3Nk6q1B
	Nx6fubyW4LHeNEhA==
X-Received: by 2002:a05:7022:ec17:b0:119:e569:fbb4 with SMTP id a92af1059eb24-12bfb770b25mr5167890c88.35.1775428917880;
        Sun, 05 Apr 2026 15:41:57 -0700 (PDT)
X-Received: by 2002:a05:7022:ec17:b0:119:e569:fbb4 with SMTP id a92af1059eb24-12bfb770b25mr5167878c88.35.1775428917420;
        Sun, 05 Apr 2026 15:41:57 -0700 (PDT)
Received: from [192.168.1.44] (c-24-130-122-79.hsd1.ca.comcast.net. [24.130.122.79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c07a8703esm4325942c88.8.2026.04.05.15.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2026 15:41:56 -0700 (PDT)
Message-ID: <9a3cbef9-5599-48cf-8307-3114ac2de704@oss.qualcomm.com>
Date: Sun, 5 Apr 2026 15:41:55 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next 4/6] wifi: ipw2x00: Depend on MAC80211
To: Eric Biggers <ebiggers@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20260405052734.130368-1-ebiggers@kernel.org>
 <20260405052734.130368-5-ebiggers@kernel.org>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260405052734.130368-5-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA1MDIzNiBTYWx0ZWRfX5oAb84oM1oQQ
 mhjJ5lkYWMRht58H0e/uyIfbfFijakBhJIaIWU3vdKN/gMI15REyn/kFbhycXu92XMAJJiZM9Pg
 csaAvnNeSIH86EV5MttajRs/Xc+LYvP8fRLej/0LPwku/740wy8UrHwbiPNCVwiSRV8YQZaRQcp
 EIUWato+VBUx8cE1j5EaaCnV7VCRvmV7kkOKT6ve0CYEmdPHiSYA5b7whBlSpcLnzHT40CAbH/w
 HpbNIkWSH4i/lJzxKaiRYIkeUPmj4BXmiDye4fLPp7iYToulZMzMXbkG4NbePb2lzQXsUo2giXf
 joL5wj4C3xJ2aLwF/rDlShX3+3kZyz71gZdBk1RLohJCsrc8hRQ9S7L6AzimMnCvOTLi4Ug3lNZ
 yLpRkR/cGMd+36VrqTCdLIKy/uM9ILdzOpUhjFdFPjQk52RselCSE0Lqr/kxvUJ+i1PLp5ODcuJ
 TOdomSHBJ+IVQNrY73Q==
X-Proofpoint-ORIG-GUID: WXTm6y-CrS7QZ6AgA-Tp-TEJSMnvrgUK
X-Authority-Analysis: v=2.4 cv=K9wv3iWI c=1 sm=1 tr=0 ts=69d2e536 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Tg7Z00WN3eLgNEO9NLUKUQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=NS484S8f6nxxdAqyviwA:9 a=QEXdDO2ut3YA:10 a=nGxtSMqkhFwA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: WXTm6y-CrS7QZ6AgA-Tp-TEJSMnvrgUK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-05_07,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1011
 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604050236

On 4/4/2026 10:27 PM, Eric Biggers wrote:
...
> @@ -149,11 +149,11 @@ config IPW2200_DEBUG
>  
>  	  If you are not sure, say N here.
>  
>  config LIBIPW
>  	tristate
> -	depends on PCI && CFG80211
> +	depends on PCI && MAC80211
>  	select WIRELESS_EXT
>  	select CRYPTO
>  	select CRYPTO_MICHAEL_MIC

remove??

>  	select CRYPTO_LIB_ARC4
>  	select CRC32

