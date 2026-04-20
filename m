Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450A839EF1C
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 12:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776689854; cv=none; b=djT5P5XgTL6acw9F9iOdMgNm8Kmvhev5XS5V95lniv0a+nvEpaXHNaqvLfWM7m6j+Jynjzm7wERcXQApcg1BaTZEi5Z7S0Bh7a9MG6OXJtXuEjl/tkwBrLi4pUisvofPOwHXFqbwauIuSqu8BPs5Kz9UZKoCvGz8/UCETmtQuTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776689854; c=relaxed/simple;
	bh=2yuzhsqIoFkC93c8bQUG7uE36plzmoFPEtctfPNZbxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNmjvfpSqQFQpnz+HvhKp9pXOhy/PtXAbPBA8aMnPdeVIDszUAlVGs+hqci4ZhBj7teAQgHPotza6VNmC8G/91zZx4IyBkHpIU8zUIFb1AjO1XAKlKmHVPWXBKA1bW2N4mq8ym1DlxKNyKJr/zDy3Hd0ba//7xuW3uBmGhfjE0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DOpVZm/x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ymy336hn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DOpVZm/x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ymy336hn"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K97rHF1600315
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 12:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=41og4mU1cLDXbt7IUpYZOpMl
	mqtt4dfz8VnoGJQGa8U=; b=DOpVZm/xN/P2BBvah3VvNjMlOn5xsAXk5r9cx/RR
	jn/gCp6WiV2dtQpJ/Yf7wGvknOeNQMsM5o+hYsZqh/YbkJWoXgEhy8M8f8OEfW4D
	AwSpAWaSyrY3Y16RU41RgFqmPLNmWonnyaR833AZsykPu/xrFIjjU9UG4YKl84GX
	POSpm3vnRPrT6m6MUCPeWKBwfay/VXtkr6So7Z9LCs0LWFXZ2jIIdpgujkoNvu+M
	HAdBS0emtefdUg7WWDcqyqU8Z4w8JDEtar1FE2my+TpbeWakq/MxNtxQOZ/zlVOi
	YvPUwUu0PgnumtjcBiYV+ms3B4jGH4jh55GV/ToxoddiIw==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnh898rbr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 12:57:32 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-12734af2ca4so1577258c88.0
        for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 05:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776689851; x=1777294651; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=41og4mU1cLDXbt7IUpYZOpMlmqtt4dfz8VnoGJQGa8U=;
        b=Ymy336hneZq8kQqKCHEOgaaL+gDp5WbC0Y82vPyUE+ydgIUDpoX1BY19CDVjy+O3Q4
         Ws7jhbTeOwxEuFJdSYmUgPc5pu1R2UY0POb4bT3LUfVbGYtsCMkxpJjpV8HKf6um/WHL
         mEN+iBcYcIEuX02OudJIbtaYe3hsY/Oa5VzoI6wBWk/s4bxMNhdzsyByMmzM1hGYF5RV
         tHxLwHYLat0m1P3CSm5oVZUYiQ/uuWw9NBclB7wzfwBC1ztAoNPxKtzIFjhTn1Ln+5Rd
         1fipFQUeoDjRNOLwDEmhBXPGdfBs4+dk6UMkpr3kXj1eWi660zJgs0GLz/qP80ZNQYFt
         BITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689851; x=1777294651;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=41og4mU1cLDXbt7IUpYZOpMlmqtt4dfz8VnoGJQGa8U=;
        b=H0yQ/Zr/S0PJSG5ZIanOY1s3aqBcJ2yUqMC7hfpUJrIF24BhE0B+CjKL8Y8A1MX/fz
         FLlJ0IquPau3NOsrLbrGlXWyaYuX6WaQYTDp/fatcKXsZhEODxQNnIXjxUmVIL/L+W3T
         o7PizSTKEWL8gZsEe9m5VNyQsCywItPM/WiW2yCZQX+eJE8PBKzIEI+ku/1lBzkOkfUp
         kuFnMS5RqTLnREvKoq6KW2hqkVtIyG4s+3uOZBQdfkv4ibB7i8vSHjs5y7kSc0KZge/g
         hiVBBCe5lWiK7PcjtmTmjo7OIb1fFMtS0Zho2oqweuLRIEieGkiCl985IX5wUDjEXpPF
         kEPw==
X-Forwarded-Encrypted: i=1; AFNElJ8KB2oTNXFLSW1wSUQ54yg9GzCi8oYnjsMEsXNqmmKpTRFMtB2BcSPiq/JGVMbfndUoXmyvu36V7Pctoxg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy26kJXWK8o0MjBind3DXEh2YX++yhjBbXDwVEYsRYn3j42dhkl
	c8rx5kJ5tXCIVeNtnYYLAbMzXabQ7g9TKhu6zNYQmJoyhMg7ubKPY2Nx7S5y6oxyxdZKAgMeItM
	/bFOfs7KjHlAdTyovVzVIU1JNRd7UxkTQ0G7zByyYrmxenFwpx/J8MCIQzwYvhiy/Y/4=
X-Gm-Gg: AeBDiesJs3Mwkdhx4E1GKrNBuqSTmfPnoPCzDpkE7njGKMA0ffZCMqukPziNhfmBAoW
	xDuNDj6zZ+A6i/OcTDDOD0psr8qIgRmQBMniPgwo2ZwEsO3cnL3wtJLPJesdbTI5A6tzRXE62PL
	y2OL4jswobjBgyWsMZ9Ac+TKdC9tvUWYGXZIoBJqHAUBgzeH1ira5ow++Lmj45QngNEV8UeEnuF
	E41f2Dmj5WyPfJhNYylhyDPCOofQeEigAhS5B1xdqkpwnkLM1t4MjmJVFA2SMxnnNpFzg26coun
	tXMuSLGSJA2jY4E+jO9gG07wsLzm/AFaXmIr0abv9N+Za5SfgKmxy12pQevenseILQ7zYpd6+Id
	WeBPEKqyicbsUQdwPoz18E11SKHYBmhRhm3DGVKIdFF6n6aaI7jdqoGIDkxck9/i4lQdAN8zJYn
	g=
X-Received: by 2002:a05:7022:1281:b0:11c:883d:1ef0 with SMTP id a92af1059eb24-12c73b2c248mr5226093c88.15.1776689851132;
        Mon, 20 Apr 2026 05:57:31 -0700 (PDT)
X-Received: by 2002:a05:7022:1281:b0:11c:883d:1ef0 with SMTP id a92af1059eb24-12c73b2c248mr5226067c88.15.1776689850578;
        Mon, 20 Apr 2026 05:57:30 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c7b62fe87sm10608117c88.2.2026.04.20.05.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:57:30 -0700 (PDT)
Date: Mon, 20 Apr 2026 20:57:23 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: qcom,inline-crypto-engine: Document
 Nord ICE
Message-ID: <aeYis8uC0BcGXB3Z@QCOM-aGQu4IUr3Y>
References: <20260420073301.1250197-1-shengchao.guo@oss.qualcomm.com>
 <dd5ee12e-1aac-494f-a8f8-74e236ecb47c@kernel.org>
 <aeXmOSfAFoxhIAcD@QCOM-aGQu4IUr3Y>
 <4b074757-ac44-4077-8ab4-5a983d1be50b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b074757-ac44-4077-8ab4-5a983d1be50b@kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDEyNiBTYWx0ZWRfXwHg2ZTP59T7K
 hfy2cbEiA+T6nnvPxbaUuexyJxz+pM2ybFPCofRDEySCD1lLiHRxItcL9MnVacPwkH8nzvUGsrx
 Od2wMtxZYqNIkw8mKmUbmLF3LRposIA0fZCj+JAd4EjlRKAS6ed0tC47jmGNmQyUFCIoiG4VM3Q
 tQ7p/me/uebPjcPcmgLHIlEWYTEi3+QaOa4afbMDmIHFwzfa2UkJEMqrQokZesSJ7NoQjoVrfnf
 wme80pFQOjgp8sDs36yg56ZbwwDT9rPZGT62ESnuZrXr8fI8Jp2cOLkpfXZErmRCepSB9snX+2E
 whdZtHQa5xR0emOEcUsaY/hePaUuq93JhRwTIc+fYUOfTm1rZxkqiTR4MJvcsdVoGJuI6aybJIx
 ySXh6JTvTcG11dbjjTPChMVTqWlWlvn3e0kgNyTd7itVls8zV7xs4THhC0gOoB1sGJcce7yYf6g
 1b1ZYvIaIy9ZzBMuFvQ==
X-Authority-Analysis: v=2.4 cv=D6B37PRj c=1 sm=1 tr=0 ts=69e622bc cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=NEAV23lmAAAA:8 a=lIS4hxcDbv2UqGGAmQAA:9 a=CjuIK1q_8ugA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-ORIG-GUID: -TMQmq_gKoyHa-4kIfHVZrEi6Eo-_k3X
X-Proofpoint-GUID: -TMQmq_gKoyHa-4kIfHVZrEi6Eo-_k3X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200126

On Mon, Apr 20, 2026 at 01:56:46PM +0200, Krzysztof Kozlowski wrote:
> On 20/04/2026 10:39, Shawn Guo wrote:
> > On Mon, Apr 20, 2026 at 10:27:56AM +0200, Krzysztof Kozlowski wrote:
> >> On 20/04/2026 09:33, Shawn Guo wrote:
> >>> Add compatible for Inline Crypto Engine (ICE) on Qualcomm Nord SoC
> >>> witha fallback on qcom,inline-crypto-engine.
> >>
> >> Don't explain what the diff is doing. Explain why. Why do you use fallback?
> >>
> >> What is Nord? It's nowhere explained. First posting was 1.5 months ago
> >> and it did not provide any explanation. I don't see any information
> >> being posted in the series sent now.
> > 
> > I'm still checking internally to see how we can get the best socinfo
> > patch describing Nord which is a SoC family covering both SA8997P and
> > IQ10 variant.  Hopefully I will get it soon.
> 
> I found the DTS on:
> https://github.com/qualcomm-linux/kernel-topics/commits/early/hwe/nord/
> so it should be mentioned somewhere, which I kind of asked when we
> discussed about adding compatibles used by that DTS. You would solve
> yourself all my questions from three threads.

Ah, I see.  I thought only patches posted to list count.

Thanks!

Shawn
