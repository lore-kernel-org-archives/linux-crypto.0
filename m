Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063252C325C
	for <linux-crypto@vger.kernel.org>; Fri, 19 Jun 2026 08:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781858619; cv=none; b=JBp/SslqPl0F4eVUYwTHu0c9WJU/ueq9co+jBRC+bPkvUsjop5yKEXK/7rXlimAY629dGkxRIr4gyuzeq2CK2rG7rdJnhxVb5RlJB/19k5gnXB24jdPCorgoTen7NhvCxBCeDgGMFUPS0QF0Mxx6LASbAg7SxZrr59a17seE6SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781858619; c=relaxed/simple;
	bh=bc31Yr5ghRJg0f90YIfKarYrpbtyGTI2c0LzMXhtT/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=llPpz9XFVoV7Tekgyq8Sp++6b7BesOYH0QCPsyfmFPKgUJGLZjJoHIswwQjshS+BlVgaSz5hOe1ew8w3nfGUa2hTzSjFA6hnKOqP+6R9U68hHCx4RF+0MSqE+kDSHmCWgkFhMDhh3cFB09k/deK2WVLb1iwhHT9W7239pqA3g10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g60Te3VQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q6HoYynS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g60Te3VQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q6HoYynS"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65J7Ohuj1104958
	for <linux-crypto@vger.kernel.org>; Fri, 19 Jun 2026 08:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Km4wby96Y6EXgbIfd/nWraW8VyrR6b3sietG3sRGZdw=; b=g60Te3VQVRD+d3SI
	eAg2m9qf8KMNl4XoscJ2nFhZ65TWJYcplYvixYInSKPiw7PMQV1pOiURi7/V9f0T
	beu6n7qHbl8oFqYO5PxG5WCHQpVbm+NctmRK1Weg0OUDGso5XJ8IeV+oefYi+X/4
	3GgYp1FlMzFr07r97Dh0Dlcf7vaVZavuPa98/FJ3U05JjFCri2Yt+KGOxniVo+Hb
	j1ifMUlmhob6KW/BzjxserpzFLUeOLEpKK393VOzDACYzva6wHosPtpitLz60Gep
	LrHPxyJIvAmtZ2/95j05LXJAbt1mcN0lXDx9l7UYvsAzExEBSUCYAhVMAxN2xAls
	ktzwxw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4evgtmm1th-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 19 Jun 2026 08:43:37 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c88fc985a65so1286974a12.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Jun 2026 01:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781858616; x=1782463416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Km4wby96Y6EXgbIfd/nWraW8VyrR6b3sietG3sRGZdw=;
        b=Q6HoYynSfFYAuuxdwGNdohuoMvFE73cLjrimW9I+CJ0elGmwjG2+9n3HXmIZaTs7Zj
         cEU+pUWBru6XDQn4MtnzH9uWUmFr/DcRBSEGWsvc3XVryA7MGpnwuO4NvwqwszyBrMau
         X3boyZFBISLP+Q2frplavbaweruRg1PeChQKI/bEGRbHT1pqoPhopkRNmMNcbACsiH9A
         rf+VWU1PK83pvyeD6ZaXEwMXfqldadsfY4JvAKlKqOzhaoihuN99GWtrDOrfHkHGaBdS
         zppVOigpPDG7Ea2TkzojT8ExGG4qSGSX3CL46HT7e1kf2c6+0sdNGlsds8JiIKwAzCEw
         sh3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781858616; x=1782463416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Km4wby96Y6EXgbIfd/nWraW8VyrR6b3sietG3sRGZdw=;
        b=BX7PxpCruEbagHiyY/Xa1gCQlpLYSwI6QYt9/dxhwLQY0X9enPJhC7PSTU0W0NEjaH
         UUIt8PPAYzBdiSwZK6wSq9NbjROT1h/CV27CPoPD9sFCMH8EV3+gF+/go+fYxd7cTIJw
         iK7LnYBB8GK1jyBTFcZ0Ee7PoKUE9bVGy40Go+0TGnZJqx4irHq9ZdraAxsl+vfDiTMm
         K6v9emgiJALcKh59Er8CmGF54ENmdvqEQXv/jRMwFS4s4z2GUFJfKdoE3+Ck99Wy6kXG
         WyD2Nfy2MKae9BHB5zGBQhEIKOaJQj3XIm5EvKUx3kxy6A+7G72w2yJeRXWMl0aQjzgW
         zCnQ==
X-Forwarded-Encrypted: i=1; AFNElJ/GMFq8HveZ4WjM66fzzG++wlZoxR6CE/9BWcwAmnPiGQsyjyZ0go/BiOdrxP6/4/MVV37Q7JMQs9DqKjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzueT9HHvvx8tctTFYCRW4Ncs+Ngw1XGvOAMU2gGljzd+yroghN
	1jQC7jPVOYHxGglb2n0h2q3SlBjiLBRIAV8KMJxmhdRoTz9CCMmT6pG27Wlfeq67bwuX89DD1bX
	drZRZtFSs1+EBv5su3FoNpeopwcrxE/4OZGrktKkO1AgGy5kWOOCNT3/L6bsGTt7kLm4=
X-Gm-Gg: AfdE7clsIHr+zsZDIfL00shLtQKFB4JK1wNmmJsa6p2pNMZqBOIu0jvvAPRDvuP40Ta
	SzG0Wn2pxENThEq3fL9Cu3ULlt0Xiam0lcxA+5n+wc+PAskP5wjtKuz5nfNqD02m9oTkp4NpYzY
	O7tX9Y5EXweCnr24qmNKIt0FSHtlciG2d356rcD8Nu8gSniBkbWdhnu2N29FfRTHLVfLJspZLBp
	9jc1CzI6iZM8JbgIxqNOn9sJlwQSXxaec2fSTLQJCHipSzDkYbIHTSraJywamd4Kw9T+o4+O+Us
	b+wXeueHd9v7ojO7scvcDdh5XunteIo1tgz7UhgSZ6LXapVIADcd+NyHEYNwffvuN6rNilx7b6S
	HbryP4A+QFLt9yJk9MTb91rJlU/p0A6K0zeQ7Ng8UPaw=
X-Received: by 2002:a17:902:e947:b0:2c0:e7bb:9081 with SMTP id d9443c01a7336-2c71904bfdfmr30535755ad.33.1781858616330;
        Fri, 19 Jun 2026 01:43:36 -0700 (PDT)
X-Received: by 2002:a17:902:e947:b0:2c0:e7bb:9081 with SMTP id d9443c01a7336-2c71904bfdfmr30535395ad.33.1781858615850;
        Fri, 19 Jun 2026 01:43:35 -0700 (PDT)
Received: from [10.217.222.146] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c72089c377sm15930615ad.15.2026.06.19.01.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2026 01:43:35 -0700 (PDT)
Message-ID: <53b1fa61-9692-42fd-a295-98bbeacbcd9a@oss.qualcomm.com>
Date: Fri, 19 Jun 2026 14:13:28 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Shikra: Add DT support for ice, rng and qce
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Cc: Harshal Dev <harshal.dev@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: odtFMr9VlNF4O9CGJEosJSakO8Jiwcwv
X-Proofpoint-ORIG-GUID: odtFMr9VlNF4O9CGJEosJSakO8Jiwcwv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDA3OSBTYWx0ZWRfX6ZSdOUYO73mj
 QHRwUde/8YLLnaMjuyG3Lttu/fdnd7wiOPk+dDj7YABcxINoB5zBi0Sc+M0OLR0e32TTogxL2u4
 bHWn1wA1Arm3FRhthOTZ0WPQuyUVllSm9yD+ll4+zpZAfstvfz9TuHbzHahsF0VH7KFzYzLAeje
 HWSFsOX7MqnWFqpEJFCrX8keAIjw4lhHvpBgIBJ2DGKHfD4LyUTs07Mas/F+9UsXKQrrTXlEQ87
 riJsGokeYQvHaPhinQfuHITDUUNl0bO79Y/vQ27TKdv1DpTLbzIJ9rYVwVFL87483u/8lzVnXqF
 hwV0/CKP5Du7zmR+0AZZfSA1AClG86xUsjuSRlMXEC4JyTI8viwUJdL2T98cJy6A2EoAQ4zgYQO
 GRz2ACq6z1w17rVITPXhc6zjuF6nWEuF1ME2/Yr1RN31HGrkLdYX4V5o8yA37bzfI0H6ELuNcSc
 qtLcAn6ivwIJFFaHSWw==
X-Authority-Analysis: v=2.4 cv=Qb9WeMbv c=1 sm=1 tr=0 ts=6a350139 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=DP-1hcgwhx0q92eQ_pIA:9 a=QEXdDO2ut3YA:10
 a=ZXulRonScM0A:10 a=zZCYzV9kfG8A:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDA3OSBTYWx0ZWRfX/xpoSb1c9c1J
 xvrVazlGYMpDLrAQrZwGU4qO/PGPeFs0O6lt7ov+BncDFcSFVHE6+XmWSNOMu/bYf1Q6shPkgvQ
 /6MqNWc8qHyKABj4CUeVoaP+r+zJwg8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_02,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 impostorscore=0 adultscore=0 phishscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606190079

On 21-05-2026 18:47, Kuldeep Singh wrote:
> This patchseries attempt to enable sdhc-ice, rng and qce on shikra
> platform similar to other platforms.
> 
> Previously, the 3 dt-bindigs/DT changes were sent as individual series
> and with feedback received, clubbed them together as all belong to same
> crypto subsystem.
> 
> Here's link to old patchsets.
> QCE: https://lore.kernel.org/lkml/20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com/

Hi Eric,

As selftests issues for QCE are now fixed[1], so shikra series should be
good to proceed? as your concerns[2] are now addressed.
I am waiting for merge window to end and will send next rev post that.

[1]
https://lore.kernel.org/linux-arm-msm/20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com/
[2] https://lore.kernel.org/lkml/20260522024912.GC5937@quark/

-- 
Regards
Kuldeep

