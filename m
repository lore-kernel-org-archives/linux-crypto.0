Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B842466B5C
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jun 2026 11:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780486570; cv=none; b=mnWNDaH2FohfYf+YZrltfriM4W4t91+2+X3jAdRQIRAYrUpWoJN+V3fmjjQfUObr2ScWXuFLAFhoPJZ9satqiiiYeS+Upg2Z5RSjaGPLgr8sRZqLFajKZolkLRIUdkDZQnIYj2NH8CjAkoH4piML2u5hDrK0ZILAGP45KurdZXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780486570; c=relaxed/simple;
	bh=6mxxhBWz3iwuNGJ2Se4rUanT9QxciF28jRe07jVdIvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rm4XM2Xw/RSjAFQYN2L84vq/DHzMtBj8tnHMZX67ZzDsirgxl6UPslOMNTru9IZCggo/nFiWjaDW1UQvNKCRzWxWTpwWYoeuzIzmXQQn6ItKaMnik4iAE9z9UIkiDWOSMr60C/dfpgHmqsj0FRegA2qSKAmSSx0Ln/l7OWg2teU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nIId+GBt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bBH5E0hv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nIId+GBt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bBH5E0hv"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6536vXGr1756374
	for <linux-crypto@vger.kernel.org>; Wed, 3 Jun 2026 11:36:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RxpSdp0rXQ9Y5LjILO1iCs7gA/5k0Z9eqsnGN8nrHRw=; b=nIId+GBtPZ7zzuRd
	WWryXiWFjqA17uKvcoU1ruqY1qjI+HReuKNZsF8STJNsywr+Z7NmkDErmiQQ3wsv
	iUW2bjayRF2r+sjQtPUx2NViS3ju3vev+YDjO4/fGRsGxch+vAf7/+Wz3AW5/ea5
	SyRzc/H9cbhsfRVVuOE640Q7k5eWWe9LLV+WivS8/VPfG0Vvyqaz2o12BWBNzPlH
	4Hy/4e5VMVVRgLcNNqABstJHsEdTnB1UE+32XGtCpO7+sRgqcr5EMy8nseBU+JCx
	59xZLY2WCirhVvj8vWpNuGh4NDXd1XKeexu4iyKT3ewMMyNq4T7APSnE3reBJ+jO
	qi8O7g==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ejff015eq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 03 Jun 2026 11:36:06 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5175bf22b2bso6091121cf.2
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jun 2026 04:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780486566; x=1781091366; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RxpSdp0rXQ9Y5LjILO1iCs7gA/5k0Z9eqsnGN8nrHRw=;
        b=bBH5E0hvuS156q9rnmqtX1JdgCCEEUCyRbY9ABHPG6bq0rloHkdBLgnlOlRo4fR18Y
         bINb1RFGgz3Doh5hPZmtAMCZp8MwbxujcmQSqcoqk29E6KOlnG7Rn0RfA4Fu/ImJeJCO
         0ktJAG8sA6rDy4si3fwAT1B2mlO1kLmBYDLYe724lK18SniyAUFMLVj4OqBEIVHI0ywM
         8g2nGGHdwBSjAGFBy1lj3uYCfBF1Mmc0/toztwnGFLgaOHWDMzoKxfsX17ZqpWX61pjy
         Pj6TL2DFHAvjqyXulKWvAZsdk+RM9J6kPzcVZjcRgoKveR2eTjawNmHAFkzdUDl42y52
         CpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780486566; x=1781091366;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RxpSdp0rXQ9Y5LjILO1iCs7gA/5k0Z9eqsnGN8nrHRw=;
        b=XQAS1EC7b7j1KTtr2q/n9Un64/KSveUzpDlUFROwNA1P7fDz86a7RENfcbSleXRWmu
         XmbrVowKwY2NeXLfUbVtc5WDMiSA018VyGQU10EyZOJ2P0iifYowBOZhOO3SHeh9clUX
         6NPyS9Ruu3dF93AhfE85qEc+CKmn/P9a4+SMgpeCOOUJoTsFP4vS/ZIFFaI50RXSs3qS
         5B6BxsBVmNBjTOHR2YHknXFKMVVXeXFkoNI3s5JJAA1yVfz4+6WLE1Rrgt8cyHD3PyKk
         lLW5Mnc9piYoRy8LoL4I+fC8AvanYuyO6M2QYZdqfdvyqqW5f/4iRsdv9O3sjcvHZjkS
         4OHw==
X-Gm-Message-State: AOJu0YxZn/GYIpi8oVEe02rR18obEfdKtcDxqhWytIqltEC9ySPwFV56
	wMfmCCimA7Kcwk9QBj9MftnO39K7OwGpagQzhuahbXLsKp8NIFAnTSzhM3uiUMj5kq7W/G4z/BY
	terxpOM0gM0r5Mp3HssdSJbCYZs5tVbQZoa+6KpbrICVZ4timLWNEd0xz0gMjouxMGKI=
X-Gm-Gg: Acq92OGh27Am/BRnRXs4yuZjuM23IIq7D2favRYjvo4ElrIhCPO5jiXmOxdhGguRYjm
	buF8iI7v7tv71S4OxVn65q/XPcleHyDT4iH7d+lWRiTSp9DWAnGO19MrN0Euv9NI6joc2QISqwz
	5ARDpvSXVr8zrTA/e4XOrPltjdBY5AqmRhFZwK26K/TjpZDQEirJ5Hs+CkUR/I0URciDBBzdvmk
	vGJTGfe8HAEiwvUh/fBGa6dYMkr/t1ySj1cE3QSER2QV91s2AGKCyJv4wl7Mg1g8DTW4L2kz5Ya
	6AvTGNT4rhsdbVwDMDhV0r/VlDms6NjjmXk8uQiA2YXJTBmhkrREwg+uwxSJ9GWdxMxDGajhJ4u
	j+p0JjPTaHhZqhGrKPVmVRfIGfgZGEEpoVTG496dR3OSGVPCmhq/gTLsCUgjSLMH3J2JiGU2o2w
	HqbvGNucYs4G0=
X-Received: by 2002:ac8:7f89:0:b0:50d:a92e:fead with SMTP id d75a77b69052e-51778171e34mr31522461cf.3.1780486566449;
        Wed, 03 Jun 2026 04:36:06 -0700 (PDT)
X-Received: by 2002:ac8:7f89:0:b0:50d:a92e:fead with SMTP id d75a77b69052e-51778171e34mr31521651cf.3.1780486565343;
        Wed, 03 Jun 2026 04:36:05 -0700 (PDT)
Received: from [10.100.11.76] (public.toolboxoffice.it. [213.215.163.27])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf054e086fesm140822166b.32.2026.06.03.04.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 04:36:04 -0700 (PDT)
Message-ID: <876710a4-7315-4541-b998-c0e603b1d422@oss.qualcomm.com>
Date: Wed, 3 Jun 2026 13:35:59 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: make myself the maintainer of the Qualcomm
 QCE driver
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Demi Marie Obenour <devnull+demiobenour.gmail.com@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King
 <linux@armlinux.org.uk>,
        Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org
References: <20260602-qcom-qce-broken-v1-1-a4ef756089e0@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260602-qcom-qce-broken-v1-1-a4ef756089e0@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: u5jsxWZyu6RkZySLzmIzxoyOfg0iv9Fn
X-Proofpoint-ORIG-GUID: u5jsxWZyu6RkZySLzmIzxoyOfg0iv9Fn
X-Authority-Analysis: v=2.4 cv=LYwMLDfi c=1 sm=1 tr=0 ts=6a2011a7 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=aBIYUfOEhgoR9egqXYNcqA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=NFhk1LTU4Akv3bPm0kMA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDExMCBTYWx0ZWRfX4vvO1Hkwuk6C
 h3Dx9faYrTpEJmJVZ/HqEIm+ZSqYURnU4CUwq8bRrqMtzQN6IO4f/dXUYFiy3Oi92nu90mxNAu3
 0WNXx4m/2TrLNH+H9F0soHGimGbOFOYP+yntjaEdV9nBLbkXfqVGNeTe4U1+e7Q1OhYfzJ8p1Tt
 bSOX70oK+t3OxeRlebaKiak5IH9JKPvydEE5wXlXa3vY4m496GVaWw/YevyeW7g2phVcZPOXO/z
 KgcthlHZQWpepFWVHhIZZ7YVeXN75G7hXIZqs7XQS6KXpN7SwJOAArpHzmGZMvzru0/otj+MYsD
 ZE96rIlWEBZYlEcMX80kTTexXBtljJJSR+uEZRQ4fWXR9C1SaMZa5lr0/bqu0rHNAGKmXZmb6lC
 5aAYIk+2lWQcNKfyv8p2sLL1SOPmr+1O9rCNG1dXxFY3P7B1WnZi8WgEZJrVFFD1jr5N4WNqG7a
 TOjie2Vyf649Xqc079Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606030110



On 02-Jun-26 14:46, Bartosz Golaszewski wrote:
> Qualcomm wants to keep supporting and extending the crypto engine driver.
> Thara has not been active for many months, so change the maintainer to
> myself and upgrade the driver to Supported.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
