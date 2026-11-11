Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406896;
	b=It6V0WV/q9x9upfmD2XsikySkfPwTt88GyVmd+Zjzteqkpi3THtPiVt9WsZTUFPSPXDE
	 dws/yyu82+hkffWrI0vnvSTH69oQ0xiIIhVOoShW0lbDvI84a6+peS26KjTQTTHmtufgb
	 o7yMTL4tviwzPOw28LyUL+6rwK+aY1lXKZl7PIZVpQ6R3jl6GolVRcNy4WO499TK2EH2i
	 0FAhRRyPOKO4apc6qdWV+XF2nd0pbCAFKMODgd0u0e7YEpq5YytUx8r/3Umnia7KZGXUU
	 8s3ckLgN8i8VVvFBTvngIP/ztAGDLyxQBEzHmMJVLxK03jxNLUsQ6EPlr9k4jO8sRSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406896;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=GxGFMPSMc+iqvGRdJCvh10NMXRvdL+St7g3NmqPw0tU=;
	b=ZhcVazgUWAApjiUGR2XRFJ4VhWUW9VZfQocR7HY6tBwSRivEqLmnKd8VXaH23yqTHz3k
	 yrGoSR94wJmfCPV991FfYxRz6grlB72DHhFRiR6j0V/bUISgowuSXbdpHSXsm3NrehuNG
	 5FZ8chOWM9993hlaPa7pqwSgr/1d/FVSJr89QwpMAKk49Nih8t0tHKB9DTdE63+kCUiT/
	 cHl2dqaiC2I4XDah2v8kRaVL/3qNeNE+WH6ua76evAb0X7d1J8mpTHZDJ00I3H9r/XUEk
	 /EeMSiulRIZUVi3VTL1Ey4zKDQJrHdbb4GDIfyWSGWozgPxPpP7uxNNNJFB68mzdwJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bDnvUKAi;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Qf09NGf0;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECD7606A324
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8ECD7606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bDnvUKAi;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Qf09NGf0
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABEJ5Kr3198542
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GxGFMPSMc+iqvGRdJCvh10NMXRvdL+St7g3NmqPw0tU=; b=bDnvUKAi0u0WIELi
	draB9OUqEYVnUuQVfou+DFxxeu0h04896EDTGc2+QSKfACr7BF5yIp5dF9F1hjO5
	2F0CPXhVsE3Y9TjSNMvsPFbQb8ePkPxKg94sgEBS1meZxX0MHq0MDvTjJBZMaJex
	BDOxdmQiwAfEXWZ0kq7ucrJlZUeS4bOsHZcvVUtsF7SSraXrBNKkkXS4/ytn3F1O
	Gu7076wSgbpXQ746r8ZhHdYxl2ZX7RBQyrvMr5fZ7aNdaAWO43ScYfV6GSocZUWM
	GF0Cp9+4oSGU5EfWv5O/t1A9Y6jOX/RJ7zxNP3E2UkI92QnDtjqvrp8xrvzwm9ji
	CuzzFQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvt1500df-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:21:34 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3763bd79663so1381612eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 06:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794406893; x=1795011693; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GxGFMPSMc+iqvGRdJCvh10NMXRvdL+St7g3NmqPw0tU=;
        b=Qf09NGf0+B07jOT1UpHBaxb1g3CqYPNFwNMRKef5X4V0lDtPtDnEVSlsBozT4anq0/
         IdD250tL2dpI8wuDyADK6ZPpM7PxmXOpzjFmRqfGQfkhpZiBxQruo/xtmCODYV51//0E
         ATAKtgKGRh8jECnssDbgnDvOwPCHIcpprTCVeNEKReaXG5qwDq0+Yl/Dyn+fpLLBNqbo
         a9+Pur9uC3DYTUYfr48iTbr4lwev8gG2P1L6WJYTUktGOKYwCs4Rev2JANihl04+Icqm
         L5V0wciNNnb/lTmD3YoL6u0zX0Lx2Uz0sWMYM9lEp8wHxyscAzDj5vgifXcwrh4ObmAb
         g+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406893; x=1795011693;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GxGFMPSMc+iqvGRdJCvh10NMXRvdL+St7g3NmqPw0tU=;
        b=pYoqX9EFg+SDnUbNQQQuAep7VsIx9aA1LzfPdA4Dbrf512PQOOTc0m4rJU0Bd7rAXz
         o4jBUcw/0UKkGYymgc8rptkbAGT1SjEuDCX3J45Lvq9abxRV7Y/HQq7GToNqBXt7DaUw
         i9rYjMvXZkbjd8okbc41/Lb1PCPUkObwb78j+H48y57CZGQqSRvWSsfPIQqQBq9JdBmx
         do2eUdXQfAlH/k9D6/CP0+auC6bMfVtEa7RlzP6phnnthBwgZ2ng6y4dBSkGytxeDg+V
         hbnaRc9n7xxCuAkBxFUNpTyNPCxYYH9h8OHmILP81C/mCmPUyXCx+e0nAQO00R3GlPFt
         im7g==
X-Forwarded-Encrypted: i=1; AL+hErFndO0FTI2tIVqkzEbrNljSdS8j8f61I0LFkTed0yRDPrwdv5StURIkcU28s5jpGOmACc5NvsKtMvL5N1s=@vger.kernel.org
X-Gm-Message-State: APuU4Z9OQg0g76zZjN29pq6Y10D+uCoT/+Gj8hW/JpPJv8uk+ITN3fMs
	46dLucZVQ7MXSZ91AQagosYms28LvTZtTibf5gDCMEWkySgnADNDtFH9jbCzC9Prw1TRtCXarW5
	zrCJWVcUUktSd8zL75lh1LKTFlFUIEof1M+W6GwR+sZoYX4bwP4G1tPZHNdtp8h7CI3s=
X-Gm-Gg: AYBFou050CtVa3jKvczj1a7Ki1SjqT4YtVlGwFqku8y8PblNyJWih41MrOVoP6fZevr
	pr1cwi8JLuwAhBaetH2OzxjM0XoLuAQMae5Oi4aJBCJCan/9GspwcistcFKaEq/l0UzNEgv96Xj
	PUXEjDxKaCxI9FfT0tl/zbuHkKjp7rjD1+iK+ZJarN3rtTNutI0auqzZirPC7UKayOrIVTfKvUZ
	Dhimh188GOaoB2tRlHj8Dix+fhiUXmOA40fd2Sr4tcI6ykqmBJFRPV2O4dq74LylTO2zAHr4tKO
	NlHA8dF+QH/+/y4V4LtdsZfHYBLj1FxK+TZV1nXfceQIygPFePlEi9e5Gt1+n4xTOLDxfpQJh51
	1qlYMPEWReDjiPzbNdpVqFnwleRogHCBVtyD8j9R2RCMrWE0X5W23NZHd1BKuG1/J9Fmac3P6HJ
	w=
X-Received: by 2002:a05:7301:796:b0:36e:a321:5353 with SMTP id 5a478bee46e88-3768385f3ecmr3014200eec.2.1794406892696;
        Wed, 11 Nov 2026 06:21:32 -0800 (PST)
X-Received: by 2002:a05:7301:796:b0:36e:a321:5353 with SMTP id 5a478bee46e88-3768385f3ecmr3014167eec.2.1794406891704;
        Wed, 11 Nov 2026 06:21:31 -0800 (PST)
Received: from [10.218.26.96] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520bf3e18sm32989258eec.16.2026.11.11.06.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 06:21:31 -0800 (PST)
Message-ID: <224eb5ee-e250-4cc0-8695-5b573757e802@oss.qualcomm.com>
Date: Wed, 11 Nov 2026 19:51:23 +0530
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
Subject: Re: [PATCH v2 0/6] Add support for a TEE agnostic Inline Crypto
 Engine service
To: Eric Biggers <ebiggers@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>,
        Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        op-tee@lists.trustedfirmware.org
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfX5b41sXOCz5BR
 rlSoH/LlXSbHrJMau1N6P3C8XOf17OGxylggOwtDFz8Ce+Zrw++Aa/7T8dx8lnj4B986LbGOmY4
 T9nUSyQaP8pJ2r9KnM7SADX5vKOyMM8=
X-Authority-Analysis: v=2.4 cv=Yrya1IYX c=1 sm=1 tr=0 ts=6af479ee cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=_EMmJvYMAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=b45o4kL6AAAA:8 a=FUZdniSIsCVK2WyB57YA:9 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19
 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22 a=emCv1hD2LFd8cNRmW21v:22
 a=dhdsR-PFWuPJUldTnwXm:22
X-Proofpoint-GUID: 4QMjUG-dnsZ_FQQdA7TC7pBbL35c1yUe
X-Proofpoint-ORIG-GUID: 4QMjUG-dnsZ_FQQdA7TC7pBbL35c1yUe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfX99F3Hem1X/Qz
 wB/Wo7rzL3t2tImI9n4+gkLXjmSg1Iwsq50mG76Y0IALCOGGJHZfSb+y7Btj2rvZNYpwoBpqv7x
 nbMeZ3qLgVWFNu+zVsgM9W62YU7GhtB525L3AHh+lLkvVSEgiGPAg8HaZjQjAylRHAGmaoI+bn3
 P0EEARDGpwpPKgCC3w3E+Cx/Kdvsgf+Xt1ywUvhg9E30+gz7hcgt6KfKBJy7MzfGjLQJ8qwxCsa
 KZ28ZG52A1xS3IJQXL+zQu6ppKwPV5QDS4975PLL6K7igalivI87dCpd0aDEkMje6K04x87plfR
 HlVnyvznLT0EVaT9r5osug8eWw4Lp8RrdFTBtsIehhenEoUkkYtJPGfO9LSH4GrKM1Hu64+S8nN
 z6cuJbvBXmubuLlnbhhP4W5RdI4UeCp385Z52KodIrx45O3axG5D9oqZzQwRZJBrExDCtw9rMc0
 5wOJQQdmlSAQDEHpylA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_03,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 suspectscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110056

+ op-tee@lists.trustedfirmware.org, Jens Wiklander <jens.wiklander@oss.qualcomm.com>

On 11-11-2026 07:47 pm, Harshal Dev wrote:
> Qualcomm platforms such as the IQ-9075 EVK now boot with both Qualcomm
> Trusted Execution Environment (QTEE) and OP-TEE [1]. However, the Qualcomm
> Inline Crypto Engine (ICE) driver currently only makes SCM calls into QTEE.
> With the arrival of ICE support on OPTEE [2,3] for Qualcomm platforms,
> there is a need for TrustZone (TZ) agnostic APIs which re-direct the call
> to the correct TZ at runtime to request programming of the secure interfaces
> on the ICE hardware block.
>     
> This patch series adds such TZ agnostic APIs to the ICE driver for
> requesting secure services from either QTEE or OP-TEE depending on whether
> an SCM driver back-end or a TEE client driver back-end is registered with
> it at runtime. This series is logically similar to the one introduced for
> Peripheral Authentication Service (PAS) [3] which was recently merged to
> provide a generic PAS service for both QTEE and OP-TEE.
> 
> Apart from introducing a TEE bus based client driver for ICE, this series
> also adds support for optionally registering a TEE device which represents
> a particular TEE (QTEE or OPTEE) on the platform bus to enable drivers such
> as ICE which poll on the availability of a TEE interface to be notified.
> 
> The ICE driver is an independent platform driver which polls on the
> availability of a TEE interface (SCM driver) before checking if the ICE
> secure service is supported by QTEE by querying qcom_scm_is_available().
> The TEE subsystem currently does not provide any mechanism to notify the
> availability of a TEE interface, i.e. whether QCOMTEE or OPTEE have probed.
> Without the introduction of such a notification mechanism the ICE driver
> would indefinitely defer probe until the OPTEE ICE Pseudo TA becomes available
> on the TEE bus implying that for OPTEE builds without the ICE PTA enabled,
> the dependent UFS/SDHC storage driver will fail to come online.
> 
> The TEE bus based client driver introduced in this series which registers
> with the ICE driver has an ABI with OP-TEE that is 1-1 identical with the
> SCM driver's ICE ABI with QTEE. This is because both TEEs implement logically
> similar drivers with the exception that OP-TEE currently does not have
> Hardware Key Manager v2 support and so the inline encryption functionality
> with OP-TEE is currently limited to Qualcomm platforms with only Hardware
> Key Manager v1.
> 
> Validation:
> This series has been validated on a LeMans IQ-9075 EVK device by attempting
> file system encryption via the fscrypt tool.
> 
> Merge Strategy:
> All patches in this series except one touch Qualcomm firmware and soc drivers.
> Hence, it should go via the QCOM-SoC tree. Request the TEE subsystem maintainers
> to provide an Acknowledgement for this.
> 
> [1] https://ldts.github.io/qcom-buildroot/index.html
> [2] https://github.com/OP-TEE/optee_os/pull/7906 (In review)
> [3] https://github.com/OP-TEE/optee_os/pull/8137 (Draft, depends on PR#7906)
> [4] https://lore.kernel.org/all/20260702115835.167602-1-sumit.garg@kernel.org/
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
> Changes in v2:
> - Merged the furnctionality of the middleware ICE service into the ICE
>   driver as requested by Eric.
> - Introduced tee_platform_device_register() to fix the issue of indefinite
>   probe defer in the ICE driver when ICE PTA is not enabled in OPTEE as
>   pointed out by Eric.
> - Fixed type "Psuedo" in ICE TEE back-end commit.
> - Fixed space based indentation with tab in ICE back-end Kconfig.
> - Ensure tee_shm_get_va() failure is checked and ERR_PTR() returned.
> - Validate out_shm size everywhere in qcom_ice_tee.c
> - Zero the memory holding the key when TEE invoke call fails.
> - Check failure from qcom_ice_tz_ops_register() during probe.
> - Cross-check out_size and lt_key_size in qcom_ice_tee_generate_key().
> - Always return 0 when qcom_ice_tee_probe() is success.
> - Did not collect tags from Abel since significant rework undertaken.
> - Link to v1: https://lore.kernel.org/r/20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com
> 
> ---
> Harshal Dev (6):
>       soc: qcom: ice: Add TZ agnostic re-direction functions
>       firmware: qcom_scm: Transition to ICE TZ agnostic operations
>       firmware: qcom: Add a TEE bus based ICE back-end
>       tee: optee: Register TEE devices on the platform bus
>       soc: qcom: ice: Migrate to the TZ agnostic ICE APIs
>       firmware: qcom: scm: Drop exported ICE wrapper functions
> 
>  MAINTAINERS                                |   8 +
>  drivers/firmware/qcom/Kconfig              |   9 +
>  drivers/firmware/qcom/Makefile             |   1 +
>  drivers/firmware/qcom/qcom_ice_tee.c       | 443 +++++++++++++++++++++++++++++
>  drivers/firmware/qcom/qcom_scm.c           |  90 +++---
>  drivers/soc/qcom/Kconfig                   |   1 +
>  drivers/soc/qcom/ice.c                     | 173 +++++++++--
>  drivers/tee/optee/ffa_abi.c                |   8 +
>  drivers/tee/optee/smc_abi.c                |   8 +
>  drivers/tee/tee_core.c                     |  21 ++
>  include/linux/firmware/qcom/qcom_ice_tee.h |  10 +
>  include/linux/firmware/qcom/qcom_scm.h     |  20 --
>  include/linux/tee_core.h                   |   9 +
>  include/soc/qcom/ice.h                     |  56 ++++
>  14 files changed, 784 insertions(+), 73 deletions(-)
> ---
> base-commit: 8f7df005a7564bd7ffa75da9c3085d5b996f1e16
> change-id: 20261021-ice-migrate-tee-svc-a5cd6959ae36
> 
> Best regards,

