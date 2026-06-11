Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8514C3C4175
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 09:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781171252; cv=none; b=mOvB0ef7Y+MtPBcVo/rwHWLi7V4nWjNeEIyGYQ9ZipE34+lojMbiaycNJdTREhcniVOZUT3fMJXd0Ck5uZR+tnpeuHtcKtBdPabiqTVvvQ4/+uvWSRn2jJosodPy3XHMTYrKcjpoK9ihsyXBr3l1BC5kiTWsPreLETTiqVhp+58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781171252; c=relaxed/simple;
	bh=cKk/InHI42xbqf0GMKfyHcHnULLRnpZJ47mFMpU9uPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0sUcH8YrYB4z8kXQBh9sIeqeKdmSKWWjzBYdc+BFrddM+vX88pNNO/7KtF74isJcZdGMeS2E5cBgH9ZlxIbeqgfU/rLSsFC5Clebv06ucYmj8kgzgOJn5VMsbbnZFDK4g+i8/wHMG9yzfUW2fJgTd7fSzE/4tNP68PpbRD51Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZbkGw5/S; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Yb9BZ+/9; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZbkGw5/S";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Yb9BZ+/9"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65B5Gdjq3761660
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 09:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EJXI28gRfgPyJfRn/DYafWDlX/OTe3kGnc0zofeBxnI=; b=ZbkGw5/S8jMFWWR5
	n35+bDH25EwyJvtzrWrWR76PHkJaHjpC/MkyjSSC9Np0qFdqKYDLaJ9viFxXq05a
	0H1EpOw4eon92vGj1jdifWCfqRO3TOQ3Mdc6yM9eaa2xwS/9NoDJCszRseTpNDdH
	pGsSfVKPpsIczuQ90mJqUCO6RU1MCC3FV9KKDhqq1srk3NL2GkQf7UsviTc7sqWu
	oXd3w1Dm1z71XjXqN19/8CoUYadgzLMpHuWGWl0ExJ8sIf1IQqKX1nn073iiA7X6
	7xVARmYWgyAdZPJ/vKl3DjjXUXy32S++oYwei80Wfl6q1XYr0g1IOLb19Dp8/vdX
	SXXaKg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eqe6sjuqd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 09:47:30 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-36bb6c41341so8626827a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 02:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781171249; x=1781776049; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EJXI28gRfgPyJfRn/DYafWDlX/OTe3kGnc0zofeBxnI=;
        b=Yb9BZ+/9ETojIEOHBBhHv8WzEQ3D+r6Y4gd5npg4GTZfTSIC2K+u6y03dEbUSPZ5eH
         NyAUIAwvWTrHLOErK53H9cEb+Qz19wkT06DQWUve68piwo6VBED4Eg3wxMtueGfqviTR
         4icbWrioB4dikLMJFsdVd20Eybe5A5UUcFqL8Hc1BkJesxu6r6fRj4NO1zFNWRF3haw1
         qacFVKiNajnvEOLAwlPBzXtEEQ7pvUklzqu/TdySrhE84xAlmN7LCBwRfWhSSUM0ZWyL
         LlYOoV5HQCG3QcsE1rTGYFBmCJ+O38SlDwDDz7LXrg7gudldCZo2ZPp0QV9+nAAh2nIm
         +LUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781171249; x=1781776049;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EJXI28gRfgPyJfRn/DYafWDlX/OTe3kGnc0zofeBxnI=;
        b=HA1BONB61+teFk646qJ16G7eG4KWcS6OkWbTbLVdeZULaDyDdwV2Mxns5A/8tDd7K1
         ntJwuvjn9FmKk/mEgpDjATrvpQkdtjVnxbi7XXvIJbyhxZdlb+O/+3QafU1rd1U+CJt+
         dREFRghHuvfGa3txV4mdmQROkFxDwSbju5E36V5vbvwR1f+9ZtG8zBhfTgOs6QYXMTAr
         qxql3sjrdhmwYqpJaUiR0fwZy90xkZWtDzSJ9FmgWZHX9tHTogkT8z+6PPK24xGXIIsh
         vccM2x5nllkVZNBoKjk/p2mdP9OtSwuCPZ7joe+Julutt/1Z913GTWf2655lIfianeDX
         y4bQ==
X-Forwarded-Encrypted: i=1; AFNElJ+GiExFivChhUK6MAurlJA8nneKb+9QrxTD6YreUvsFzMPMWamC4Fo1Y4yUtYPr7YgT35FS1T3DEmsGtpI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY4babFE2CPxwHH74ILbXvXGhD2Y3tKCpH8ORUKuuFGZKwAiii
	pDWjm1Elwlexjc6TSoO64U0pV04PAIdWM0OKWwZm6J1aFY6STuEeBqkCWjhrSzSmCr5r/hqaH+S
	nKv3R9OaZab3fu9DVDd1Pf5mgOFpFaR4C4I8x5FMYMJG49iCx2UeIG5QQPzMDkB5d95Q=
X-Gm-Gg: Acq92OFVDi2J/G1tyola/oK0AtH+97Hjc1qawMXydYBZMyqfoQ8YDtbkKRROSBdZ50e
	zU8kA9eyz0vCAFd1rHs+eE8pAN3N9NQQhGhaYrM5UMHqbqS9PCWdnoYpTZ+7fjYCC4ZAByoVFL2
	esCT2eaOWzZSpaurWG6XuJKwIT7zzN5U0tHbuEwfvfIK87jefwrQuY5O27x88o14wD6j9yLwn5h
	IzbLLi6xqWoPd7aWpM/fpJwZqM5uJ0VI/+RFyoa+Wlg1i+/Uf/dN7QClyC0q5vnMmVBCoNa7ziq
	0XmWvNIpvxcfSaO0S/pzV1QlFnYfUFbFY2xLP6/8NxNCrKw1mmllJd9bYpx/HK0ei+A8ZEg+YUK
	CTEERQnjxu/c2AMu2MGhHaeDkFS/GVe7qnh8hTax5ldQgfY9f3skeMdx/wgiOsqg=
X-Received: by 2002:a17:90b:1c8f:b0:377:4a58:fe0b with SMTP id 98e67ed59e1d1-377a03ba952mr2388344a91.7.1781171249414;
        Thu, 11 Jun 2026 02:47:29 -0700 (PDT)
X-Received: by 2002:a17:90b:1c8f:b0:377:4a58:fe0b with SMTP id 98e67ed59e1d1-377a03ba952mr2388326a91.7.1781171249050;
        Thu, 11 Jun 2026 02:47:29 -0700 (PDT)
Received: from [10.92.167.195] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3775558f317sm1982520a91.9.2026.06.11.02.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 02:47:28 -0700 (PDT)
Message-ID: <1abc518e-e24e-44ff-9b15-1766dcecd8a2@oss.qualcomm.com>
Date: Thu, 11 Jun 2026 15:17:24 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Fix Qualcomm Crypto engine self tests failures
To: Eric Biggers <ebiggers@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
 <20260610184205.GB1158828@google.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260610184205.GB1158828@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=GbMnWwXL c=1 sm=1 tr=0 ts=6a2a8432 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=eWo1p3akS8hEm68lJ2sA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: GvWBwu9fu6830VQGOehPQdcMplpXKNkE
X-Proofpoint-GUID: GvWBwu9fu6830VQGOehPQdcMplpXKNkE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDA5NyBTYWx0ZWRfXy+8AL1o9VS9r
 SB4wJpjcV/fHAjWg4dXHYZ9KJ7n7UerH9J3BOBV2g1GiwJfAkdeJYVuAj/rbnjFJ9/5vB45rFHL
 huVHl6nkuEW+9om6HeFH2wLG+k/bP5uzyGA3s4fRdOHT3UMJDWyncOTAuU7nfBd9vSr6hWsRDNd
 S1kSTDGIOu8U8cjybfH8R6E7GakCUNc27s3M1axketzHZ4Tm5Z62Vu89izdzvqkIotcZu1Q61NQ
 TgK4UsInj1IzjOJVSdSXPcJoF6+AYWGGZ43z4lilAXWPHAaMZboW04f7sk6LWzbzMWuMxNLavHD
 +mxPkJoPhI7T1jHtpALZ4jHAkAAlGH4aFsUv44z0iPSrvYHwHFSiXL96KNvjzcoP3rkjnHFr1U0
 9QusjHJgfssc3gdBQviwqzOYRsybYsUES62lHrDRU7qp/UEhvE/N/KCMp7B2zGgsAUnhJndtzpG
 9K50bXvZFI6zB+oVk1Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDA5NyBTYWx0ZWRfX/6MsH2l+2meA
 EynEbSugKP9SCi2LtPJ79n/I8PcO5QZwwDaek8uaBge5NSPKwRRi4sonNt7QbSihdmDF6CRzJSb
 8lmN27y4prtkK6HdlXvdHjDKlov6Wrk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606110097

On 11-06-2026 00:12, Eric Biggers wrote:
> On Wed, Jun 10, 2026 at 11:24:03AM +0530, Kuldeep Singh wrote:
>> Steps followed:
>>   - Enable EXPERT and CRYPTO_SEFLTESTS config.
> 
> So the full tests (CRYPTO_SELFTESTS_FULL) still haven't been run?

Crypto_selftests was only run as there's some discussion ongoing with
Bartosz on removal of deprecated/unsafe algos.

Seems Bartosz will be sending patches for algorithm removal changes.
The rest relevant selftests issues we'll fix accordingly.

-- 
Regards
Kuldeep

