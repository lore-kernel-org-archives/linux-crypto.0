Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792655236;
	b=aGVm+Mcthgar3rEl059quO9gqdqWV3dg89cTgRL8gpGrTMJLZ34ahMDzflsYn4XC5njK
	 xKFx55Ruq3Dx0RSlk6nFDzeMUjy+3G0RxefSvDihlNZMUHgD4LoiWY6Bl81q04HM/8H4/
	 ClX4+3VemjyhPgehH0GfCC5sQy82Z0Bc81w8NIxj06fulw/Zc/3oQiRP42stzyaCWnj0J
	 Qh6Y7m8iS4P3gGFeX1Zb9OXXlh4t+A8xsNdEBEkbpDJLaR3IAbg6IHFZtHnPnWNHC7YZJ
	 MG1aKCKMFCO/PG4tYthmvyMMsXx5Sm4Ke8UlyeBM/4zYxPYPEOIWynz6xafs2QeHBFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655236;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=C7UAW1KFyOtoF4BRFTDjluqDlRf6MeW5wwF+NAAgNHA=;
	b=x3FwVNCT8B1yOVaxr+IYtrcXhp8BdFjdLCxu+HcPzW/NAz2JlGqy7J5wCsviSbkzErqT
	 a3lAyS5RVOCf4vZk7ZLIoM+w4uK7Lx8YjyFiu8OiL6Fu6LmUov+iQRkbtBUEKJJueOrsl
	 wLnzYZRCGvS5ZCkWuNaOJu6ayVcoFfihchL/JmcJUJFKtMCUxy13cPbP0j5GGF2BFbzmE
	 8unawGrSYmgvSbUnEVzQmhADZsDu+SRrZUBbbGs6BJl6Osdx2TxGffScROfH52cmK6Hc2
	 uu+ik7emx2RynTWRV6n3xUUHgGLp8NnpPGjC4yFZ/iMjg92p/+nZZP9fJjo2mhauBYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SgKS0lJl;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=evfGega1;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E43606A32A
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:47:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3E43606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SgKS0lJl;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=evfGega1
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M704qL4110574
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	C7UAW1KFyOtoF4BRFTDjluqDlRf6MeW5wwF+NAAgNHA=; b=SgKS0lJlKQqiBAZj
	GY7B+4+vQ1XIAXlPskPDYp/gKq9YuaFSHb0Nn0Z1mGwpgl1mdy/HpeNumCzh9COE
	zuXugRZ6TIgXdepyH2vPSW03+ZwswgVkiAOmpovD0L6sWSKIgnpERp/mdFK2xmUA
	K2uw3ax7JbXoBbzpIR0QMUp16Rc+yJ1P5mTUxYV6245MLAunvUVZilvUCyPdtUJU
	iEB4f0+J7uXegrf+SdA4zldhsNlt44sB1O/zCjXeqfT4IHE/4CkU7qnvQS35KvJA
	jEloCQyu/wgXAz9KwcbpJ3Ry0+CcEIebKRxI9H/3stvHVfrMBbLRUbEDZBF/x/L9
	awqGCQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93ahaht-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:47:14 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-917a04d1cb2so3712446d6.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 00:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792655234; x=1793260034; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C7UAW1KFyOtoF4BRFTDjluqDlRf6MeW5wwF+NAAgNHA=;
        b=evfGega1zJRsuP6b/r9lPkhKvRF0SHzibAGGqVuAEWjvpWU6lUz/BfvZ9B4KJFnfWy
         e2cawJR7vybHg/LazvJJhZXVnXpDvRa96jE8TsXYowOXHMrVe6apcbWSN2feDeF41ePF
         ofPYMeCLkmurnu0HvdAyePEJ8TdKpAyhPKm6K/2E8fD8ouxg6OpoluA0qFHI/gWlFBTQ
         SWuzBUf/tVs3bAXuEVzRPVi/0UFzvrJ29VfdP+j+RlDhe262uJ7pmhDwZuYJYLEIFKhQ
         pWIoeuWQW7dpfUdog8UmCCQstswwuNtPawzmlNrRIDQetGuUVsDrfIoc+ZF3Tpd6Kkd4
         Ph7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792655234; x=1793260034;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C7UAW1KFyOtoF4BRFTDjluqDlRf6MeW5wwF+NAAgNHA=;
        b=oruKHuDP9nHkwFsmYqnxxUj88oWtFL17bLamveaDbcvl6haH5doNaDSRL4TVNibuw1
         CvZIE+Ajsw+4/dGr8LeSscr8aZni+P1606Ib/NElkMQQBWVG2kgKAV57VJ0lXc1xL9vQ
         UG04uLj3Sb9no6bfjNYToNxMP8j8j24dcu/KPJVVX/T9P3CgPMgtE/sn/7EjAYLMX42c
         GcQGOVbJ/kb76R4ICADXA+ENmQlYf7tCtPRtKUpMqmjn3fzQdLKz2SHLIpyD2tWAaAF9
         80pn1hB89ULgRtjbeqzsATJZprd51GNpwMkKaO7ZZI07y4qOkSAi0xioKj4aU+uubJ1N
         giUw==
X-Forwarded-Encrypted: i=1; AKwUvBxN4e5FDyi1h5ylBe/gPAAhSAcQCSB+Z8ayFy8XQdUGP+GJaqT5q+Y5fOh8K04DGIwyAC7NXm+mvoeKIk0=@vger.kernel.org
X-Gm-Message-State: AFq9FYLl+8u0Ku5ds0T8kTWp/JeuaA4oeNfCgOlZ9nIeEnMpsb0hBAuu
	BN4Km50eXi5M9AXWJ5dpUluKYOfrEYjl0dktB7w7uWBn8oLhTgwX242QY5ZO1Lyyl+iFZzTZpAg
	y9Q69vicD0nOAFYXdqSJI4kx+CvWnKmdPsKM/9uFtmjkY6BCT42wJA3fJ8SWu50UNQcsaQAcr8T
	Y=
X-Gm-Gg: AYBFou3OexPAEg7JFIsh9kpoalbaJpeQaz9Pa2RUZZB7PQ7kSZiFSQ8A2m0sqh5/Z9T
	wVd8SoalEKd+JZOwYZ48GR2Ad+Dr3NXVbJFqcTVZ9x7uhCDda0W4aEMIp7qBWRzDZQlbcM5b/jP
	VlsnBiUpR9pWhP87ZShc+9cAW+DUitVjH9PeVJDcPIthXNq7nkaqbFNdn2dXa5IAmFPZbOvqAcI
	QUQaTVcDhhQsWyw8lve9wJps3CpiSPsI6k6Em4iJl8ZTOHnKFABUBOS7OiB2Cf5K+sXXOmV3bnN
	bElDj7ynSi3YssrDIvQ3B5XcIKZiDBEuo/RWdoMY/zCl/kHwoLVetFYrr1BCC5K9r0mnBA/tBEx
	iioG6uSHAUdJ4zyY0iAS2Tg==
X-Received: by 2002:a05:622a:a884:b0:531:2663:2cd with SMTP id d75a77b69052e-536a75ce176mr61217521cf.1.1792655233887;
        Thu, 22 Oct 2026 00:47:13 -0700 (PDT)
X-Received: by 2002:a05:622a:a884:b0:531:2663:2cd with SMTP id d75a77b69052e-536a75ce176mr61217241cf.1.1792655233443;
        Thu, 22 Oct 2026 00:47:13 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a50bc9csm81543566b.15.2026.10.22.00.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 00:47:12 -0700 (PDT)
Message-ID: <601fa952-3639-4154-96de-aa09cf5f692e@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 09:47:10 +0200
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] firmware: qcom: Add an TEE bus based ICE back-end
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261021-ice-migrate-tee-svc-v1-3-b035be7aab0a@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261021-ice-migrate-tee-svc-v1-3-b035be7aab0a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzMCBTYWx0ZWRfX71k5BIBEcphw
 IONGvuRU5PnCtoe8LRu/ZVebbcaEdGrOK1exU6iDgHQwGfL/HYvdIVx2p/oEdcofId14Kf/lHQq
 y7c0YEzcQH4eN7muK1j2+QHSX/39myeZgxdEogAKz9uapPOT6R/S8EMmIYH9yItRv/5dRLEadIf
 yOeDBjpDUev5X3sB7Kx+vZgS2y5ZjsdLHM5PzCAgxXaKFH8EW5/WT53QzA+hPUz91tLVy7DWN6D
 s4TX0CrsCfw13czMw6a2ujeCC6JrySoDin9IS0LfQ2+7FBBuVieqN4WMBaQyg/gORRqINJ9AxkZ
 aSdq+MEF0QIMXyVRGX1LXD3rYNqn2bi9C17uVpS3LLsM4KsJOXjnMLc6a6FhJZSAh1TAVVzdDjH
 fhV2I9umvIqEMNBlcletMrtSbuQ9+owSvS5uEaSHBZdSGwhlZvvYwmOqXPoLXSxro2lwojR8QR8
 yMY5PQMvSw1+rEzd/Ig==
X-Authority-Analysis: v=2.4 cv=H7FOUOYi c=1 sm=1 tr=0 ts=6ad9bf82 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=7ix8c-dH36osfZYG5LQA:9 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-ORIG-GUID: Hb1g6Ut9QitQmNLzj-Qu_Hp69M-a9v5G
X-Proofpoint-GUID: Hb1g6Ut9QitQmNLzj-Qu_Hp69M-a9v5G
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzMCBTYWx0ZWRfX2HocKWeklXwD
 v4HGPBmUitM7NeAOgNDzkfhBfsrgnmfq2vUlF++KczG1tV1INmagdJRtmsAwyLWNWVMM8DI6NZr
 iCiDVhp9xf+DkwfxfH6tyDVfG5gWqf8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220030

On 10/21/26 5:43 PM, Harshal Dev wrote:
> Add support for a TEE client driver which forwards calls from the Inline
> Crypto Engine (ICE) service (invoked by the ICE driver) to the OPTEE ICE
> Psuedo-TA.

LLM says: typo: "Psuedo"; s/an TEE bus/a TEE bus

> The ICE PTA supports both ICE Legacy and Standard modes. In Standard mode
> Hardware Key Manager v1 is supported.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

[...]

> +config QCOM_ICE_TEE
> +       tristate
> +       select QCOM_ICE_SERVICE
> +       depends on TEE
> +       depends on !CPU_BIG_ENDIAN
> +       default m if ARCH_QCOM
> +       help
> +         Enable the generic Inline Crypto Engine (ICE) firmware service TEE
> +         implementation as a backend.

LLM says: please use tabs here

Konrad
