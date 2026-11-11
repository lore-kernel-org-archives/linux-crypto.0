Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409054;
	b=3xWn/ipcPIR2eEIoixOt9ecyroth0X6X+pgfB0gBNA0YwXOC4byDwORrDiriJeeu0W2H
	 qOIwxFclWUm5wSY9Dau8MQQfgSVRFWjtFPRF+6/B2yqtTP1b4Imu7MH33z6LBVhiGiRgy
	 SyxpqnIccMCZqOW9Y+/ZdTtxJD8r0B25nOG/D86m3lOvhG2HMXkudzT12AfXsMbawrI+S
	 Sn1j3t3nElqfK5GL5pX+dCuKImYRoAl6xkPxnS+OGrMtoo72dYT6sYHzP5sd5R9hyG1Pz
	 X1k5FWamXllCP3fMKlSZr8BHWKTm3uiERp6PStgxy2PGJ3XmzOJWGyhaDlfpNIefYsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409054;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/40jYrLAj6axvoSSA2in7aHxwy4Fp9/+iv1azORyUxc=;
	b=UdEK/sxELMykFLSvUbeQ69DXnqXlQDj0avbRNf1evv9NYj5sZJanSlnd6qm48XD+c5Ym
	 OHdm2FAT1XeOVyzKpcfbRHcnq+k6W0UHA3A8lcpyoz01faLu5AlY4HypjojJhMQoMYcny
	 vLu5vlGGMkS6fQJlqiLyr3cNUkQ7r6x6MlUMzVfA0g4F/fGYWKgFkS7fzoGSXvmmdyUh4
	 WqW0Zg0yUuionTF7f95Em/5Y+5fGlrszhJaazGoaBml8gmPLlKNYfV/RJQniYfj0gGLV3
	 cxezWoZL7xKOl1xp5jKiuugHFdxyeS+1eqVaxtDxvg/HqJJ3/zYFgjM+KUOFRUQ7jIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Yxjct9mH;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Jb4iPAS+;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB74606A327
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BB74606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Yxjct9mH;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Jb4iPAS+
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABEJIrb2577017
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:57:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/40jYrLAj6axvoSSA2in7aHxwy4Fp9/+iv1azORyUxc=; b=Yxjct9mH/uBDFpsW
	5lVZNAVbaSVTAAKCPuor/FOsWPX7t9k/A5CXTYka2RCr1DRvNcUyvRief2MFfdeq
	23Yju/jkNnZiHiQ1yn8gKAX1TRvmvHAJyW5I4sOkgftY4FcQkqMWkNmRG8vMyTlQ
	sUlMm0VeMNJKnGUdZTMFTOiy88G6xvlMx6tcYLN+D/wXmm8kF42ltsmzwGfAKqjQ
	WbgxmiyzV2LCJYJqrpl82j1CRBBd4XfpunQUrPI61aGQxdhRmf652r6o2hO5tCtt
	W/RepYf7o09qxLsa/Aj/quS6nX+6VFXcW+SUflhEDZIAeq4EdQc3ix+bKnLGyOE4
	5Rvy8w==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvgjdjaxh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:57:32 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-375f0fd31f4so2070545eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 06:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794409052; x=1795013852; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/40jYrLAj6axvoSSA2in7aHxwy4Fp9/+iv1azORyUxc=;
        b=Jb4iPAS+WEIdulqY/gyjy4lfkQx09m/8ZEOsV5yL9Yw5NGmGotCznxfZyHcA44F9lG
         Zu9qI9IRKWjNGXkuHMxHN9v6mGeLr8OKX46I0jJTydjIxnOlHR+qk3Osvyvq/0zf7erg
         ftsg6Vd4lvRrA+VQ9Tz4wKPasuDfH8nlHisL4yiZ1a546Hn1D+H5q0XzbC3BWeprBQjI
         MYfHZnWlwkhYchV9xmwcUEldLwkA4vKOGcZE9as8qT+2wRTQU4aVcPxuWnPAfZAd9Jlo
         sQ4O7ehp2tx2NeaeuHJhm7umf6KtAAswSHryCStuTvl7V1nV+yOfn5XwJrQNzP+VmW5L
         xPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794409052; x=1795013852;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/40jYrLAj6axvoSSA2in7aHxwy4Fp9/+iv1azORyUxc=;
        b=rPVXsuKNzNk90eo+6iNq0gr9qsbA/Zmq0LbuYDwhO+Q/pFrZEd2PNClWatXqDUzuRm
         Fow32GQI0iuQfFAQ8Z/ZdBfULHsC4dAXBRviWvp4xhXSsA9VLRhcoZWynWjGuQAYEzK9
         IUrvPcTZ0MFdtpHlfizE5TOopf1lINaxYZMwvwmm3tAxMOtAENRSNNCfck6b1ugnHeg6
         sFjHFp8KjRn9gwoiq8EKx3fTw52Bjlqi4cSIA7iaVq9blv8LTWHn5C7+r3Gf7GI1zZHA
         VxNn/IueeZFmvVatrYfAoTQrwvr/BysiomZYYTy3aLEymuBue0EgbKd6NBBzDfsWTObJ
         QOkA==
X-Forwarded-Encrypted: i=1; AL+hErEuefO0D78BObYZ203YsXiyOJ6EuNMA4p5mKzNhK0JVJmPPhcMjz1OPTBkBcoTfQVY1F4rBrlXtOUuRiS4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/FmG2C80E8kl9CHJXmUoh4vtQbej6pBd7UT+sZjb5A4uzAIjH/
	n+sJfzbuAeAEnnpzxm8kp7S0mbThL+f3s1dzuNcZIBaU1MZvgyxQgtPHR9pQz9kY5iqD/E8jSr9
	339ZY6p43iMiYogt/ohpqXgm42IuyTsQcCYI2FjhLdenyUzCRd98YNwf/Il7EL+8JLcs=
X-Gm-Gg: AYBFou2zDqZaiDqPtny7pyYmct1V7jX7wmQZbZGBuSh0W8OD0cRdHA1HcOyjep+nGqH
	POQVF43WqmofEyVY1GGDhXuyvqEZ2kRyYfhYX8AnTSKlgY28ccPGM3Gh/Cah4s5Rx2pPNk+e4CO
	0rrlXh4uzni7GsM5lWSUzZwkKGNt4uir0PffB/deAV5tvrX5OaAwzMM9tpDigkBAZLQ2IwvqKLS
	D6NU3VDMxHnsTztskQHJH0eHxVBmx1hCUGUI8ZDWiUAK1IakmUJk695GRuiCzjPzWR/wCEYpvhu
	X0hwWJSHkdOC1HOGzyvmNxr4If0fj9HIGxAQrweIoOO11cf9Ajj9DkxvS9cXdOqGKOtUvjpOzyI
	Pat0FYeXubS88+bXDSaU5Uu/eE+bvSRyc4WxiSTwuGPW0v9/jYC2ccCiWY36XCu2+Rj3oatMjx7
	EeLdY=
X-Received: by 2002:a05:693c:87c1:20b0:36c:c483:7077 with SMTP id 5a478bee46e88-377abbd9353mr220900eec.14.1794409051657;
        Wed, 11 Nov 2026 06:57:31 -0800 (PST)
X-Received: by 2002:a05:693c:87c1:20b0:36c:c483:7077 with SMTP id 5a478bee46e88-377abbd9353mr220869eec.14.1794409050978;
        Wed, 11 Nov 2026 06:57:30 -0800 (PST)
Received: from [192.168.29.10] ([49.37.154.218])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3752060c4b6sm17298659eec.15.2026.11.11.06.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 06:57:29 -0800 (PST)
Message-ID: <197d7d58-9791-483f-9a7f-40747f44d1ee@oss.qualcomm.com>
Date: Wed, 11 Nov 2026 20:27:22 +0530
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
Subject: Re: [PATCH v2 4/6] tee: optee: Register TEE devices on the platform
 bus
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
 <20261111-ice-migrate-tee-svc-v2-4-29d19f6c92ab@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-4-29d19f6c92ab@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=E7tYNqdl c=1 sm=1 tr=0 ts=6af4825c cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=KJEteu+P7FD/DYblE0u4eA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=b45o4kL6AAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=cVz09F1fK_0Ztju5R3sA:9
 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22 a=dhdsR-PFWuPJUldTnwXm:22
X-Proofpoint-ORIG-GUID: sF8A7JJiFNtuvZCIRJ9FJqZ-UR7mjpJH
X-Proofpoint-GUID: sF8A7JJiFNtuvZCIRJ9FJqZ-UR7mjpJH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA1OSBTYWx0ZWRfX5qeGVFQokciY
 aPc/bNVT5FbIUhq9aDiAkSXQUDyrAf3jcrB+V46mMSy3TbvziQgh0TNtFEitUkRr2AOvG5gVh3H
 DML5jdayjG/4XwLUmJ1E1n/F/wybBGOn6LI18ydiBArTpflxMkn3/KJ9wTIOnc7VJ5BmtAaXRqM
 a0vrmAKDOpb7hzEcyYxAduFx6sY1IGexdQ5hscB1EnrFEUHkcTbZ6j87HZWtFMaitE68JuybO52
 O44cjyis+ygFrQRhxvwWlRdqhFsMGA5LaanDarHBs06A8N608iggRUpmboOM6axwBQibMYxvcjK
 G/04INyM+6kgMTKlI7f+dVhSzdD3/ltO/eeei4nRIl3YZHdq14MZO1oRP4/uk92BxZtxWsdvmQe
 u5wgNfCT70M39K5vsStwP8jG86BhS8x9KalZTn/+zgn9SA5gMWhtsyiV0ZnbZVREIgIJIIFMyUK
 UEp0CdfyjYV4XJo/qnQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA1OSBTYWx0ZWRfXydt7m6cx46ht
 r+m8Mi3qjk3Pltz4Q/TVSqfTVhw9FO+9pZ8LuED941sIwKFvuNrIfZpCewrfzmjI+Geneck0FrG
 WoHFPm7xsg107KGXeIr/JkELJzlRCQ4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_03,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110059

+ op-tee@lists.trustedfirmware.org, Jens Wiklander <jens.wiklander@oss.qualcomm.com>

On 11-11-2026 07:47 pm, Harshal Dev wrote:
> The Qualcomm Inline Crypto Engine (ICE) driver is an independent platform
> driver which polls on availability of a TEE interface (SCM driver) before
> checking if the ICE secure service is supported by QTEE by querying the
> qcom_scm_ice_available() API.
> 
> The TEE subsystem currently does not provide any way to notify regarding
> the availability of a TEE interface, i.e. whether QCOMTEE or OPTEE have
> probed. And so when migrating to the TEE subsystem via an ICE TEE client
> driver, ICE needs to defer probe until the OPTEE ICE Pseudo TA becomes
> available on the TEE bus. This means that for OPTEE builds without the
> ICE PTA, the ICE driver would indefintely defer probe and the dependent
> UFS/SDHC storage driver will fail to come online.
> 
> Add support for optionally registering the back-end TEE devices which
> represent a particular TEE (say OPTEE) on the platform bus via the
> tee_platform_device_register() API. This allows drivers which poll on
> TEE secure interface availability to be notified even if the TEE service
> itself is not supported.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  MAINTAINERS                                |  1 +
>  drivers/firmware/qcom/qcom_ice_tee.c       | 41 ++++++++++++++++++++++++++++++
>  drivers/soc/qcom/Kconfig                   |  1 +
>  drivers/soc/qcom/ice.c                     |  9 ++++++-
>  drivers/tee/optee/ffa_abi.c                |  8 ++++++
>  drivers/tee/optee/smc_abi.c                |  8 ++++++
>  drivers/tee/tee_core.c                     | 21 +++++++++++++++
>  include/linux/firmware/qcom/qcom_ice_tee.h | 10 ++++++++
>  include/linux/tee_core.h                   |  9 +++++++
>  9 files changed, 107 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1132e456488b..06dba76996b8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23013,6 +23013,7 @@ L:	linux-arm-msm@vger.kernel.org
>  L:	linux-crypto@vger.kernel.org
>  S:	Maintained
>  F:	drivers/firmware/qcom/qcom_ice_tee.c
> +F:	include/linux/firmware/qcom/qcom_ice_tee.h
>  
>  QUALCOMM INTERCONNECT BWMON DRIVER
>  M:	Krzysztof Kozlowski <krzk@kernel.org>
> diff --git a/drivers/firmware/qcom/qcom_ice_tee.c b/drivers/firmware/qcom/qcom_ice_tee.c
> index 694aa05847f0..39f7094439d9 100644
> --- a/drivers/firmware/qcom/qcom_ice_tee.c
> +++ b/drivers/firmware/qcom/qcom_ice_tee.c
> @@ -5,6 +5,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/tee_drv.h>
>  #include <linux/uuid.h>
> @@ -22,6 +23,9 @@
>  
>  #define TEE_NUM_PARAMS				4
>  
> +/* This represents the back-end OPTEE device */
> +static struct device *__teedev;
> +
>  struct qcom_ice_tee_private {
>  	struct device *dev;
>  	struct tee_context *ctx;
> @@ -281,6 +285,18 @@ static int qcom_ice_tee_import_key(struct device *dev,
>  					     lt_key, lt_key_size);
>  }
>  
> +bool qcom_ice_tee_is_available(void)
> +{
> +	/*
> +	 * Paired with smp_load_acquire() in qcom_ice_plat_probe().
> +	 *
> +	 * This marks the availability of the OPTEE interface informing the
> +	 * polling ICE driver that the platform supports a TEE.
> +	 */
> +	return !!smp_load_acquire(&__teedev);
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_tee_is_available);
> +
>  static bool qcom_ice_tee_has_wrapped_key_support(struct device *dev)
>  {
>  	struct qcom_ice_tee_private *data = dev_get_drvdata(dev);
> @@ -398,5 +414,30 @@ static struct tee_client_driver qcom_ice_tee_driver = {
>  
>  module_tee_client_driver(qcom_ice_tee_driver);
>  
> +static int qcom_ice_plat_probe(struct platform_device *pdev)
> +{
> +	/* Paired with smp_load_acquire() in qcom_ice_tee_is_available() */
> +	smp_store_release(&__teedev, &pdev->dev);
> +	return 0;
> +}
> +
> +static const struct platform_device_id qcom_ice_plat_id_table[] = {
> +	{
> +		.name = "optee",
> +	},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(platform, qcom_ice_plat_id_table);
> +
> +static struct platform_driver qcom_ice_plat_driver = {
> +	.probe = qcom_ice_plat_probe,
> +	.id_table = qcom_ice_plat_id_table,
> +	.driver = {
> +		.name = "qcom-ice-plat",
> +	},
> +};
> +
> +module_platform_driver(qcom_ice_plat_driver);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("Qualcomm ICE TEE driver");
> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> index 535c8619197b..8dc75c252f52 100644
> --- a/drivers/soc/qcom/Kconfig
> +++ b/drivers/soc/qcom/Kconfig
> @@ -296,6 +296,7 @@ endif
>  config QCOM_INLINE_CRYPTO_ENGINE
>  	tristate
>  	select QCOM_SCM
> +	select QCOM_ICE_TEE
>  
>  config QCOM_KRYO_L2_ACCESSORS
>  	bool
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 452896b1858f..4844621b7497 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -18,6 +18,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/xarray.h>
>  
> +#include <linux/firmware/qcom/qcom_ice_tee.h>
>  #include <linux/firmware/qcom/qcom_scm.h>
>  
>  #include <soc/qcom/ice.h>
> @@ -132,7 +133,13 @@ static bool qcom_ice_tz_ops_registered(void)
>  
>  static bool qcom_ice_tz_is_available(void)
>  {
> -	return qcom_scm_is_available();
> +	/*
> +	 * Both back-ends should be available before we check for
> +	 * qcom_ice_tz_ops_registered(), otherwise we could pre-maturely
> +	 * assume that TZ does not provide any ICE secure interface.
> +	 */
> +	return (qcom_scm_is_available() & qcom_ice_tee_is_available());
> +
>  }
>  
>  static int qcom_ice_tz_invalidate_key(u32 index)
> diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
> index 702da7d98fbc..2c0065f3d9e4 100644
> --- a/drivers/tee/optee/ffa_abi.c
> +++ b/drivers/tee/optee/ffa_abi.c
> @@ -1177,6 +1177,14 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
>  	if (rc)
>  		goto err_unregister_devices;
>  
> +	/*
> +	 * Device should only be visible on the platform bus once the
> +	 * child devices have already been enumerated on the TEE bus.
> +	 */
> +	rc = tee_platform_device_register(optee->teedev, "optee");
> +	if (rc)
> +		goto err_unregister_devices;
> +
>  	INIT_WORK(&optee->rpmb_scan_bus_work, optee_bus_scan_rpmb);
>  	optee->rpmb_intf.notifier_call = optee_rpmb_intf_rdev;
>  	blocking_notifier_chain_register(&optee_rpmb_intf_added,
> diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
> index 51624443359b..85ee76173982 100644
> --- a/drivers/tee/optee/smc_abi.c
> +++ b/drivers/tee/optee/smc_abi.c
> @@ -1920,6 +1920,14 @@ static int optee_probe(struct platform_device *pdev)
>  	if (rc)
>  		goto err_disable_shm_cache;
>  
> +	/*
> +	 * Device should only be visible on the platform bus once the
> +	 * child devices have already been enumerated on the TEE bus.
> +	 */
> +	rc = tee_platform_device_register(optee->teedev, "optee");
> +	if (rc)
> +		goto err_disable_shm_cache;
> +
>  	INIT_WORK(&optee->rpmb_scan_bus_work, optee_bus_scan_rpmb);
>  	optee->rpmb_intf.notifier_call = optee_rpmb_intf_rdev;
>  	blocking_notifier_chain_register(&optee_rpmb_intf_added,
> diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> index 1aac50c7c1de..0d3c266b29c7 100644
> --- a/drivers/tee/tee_core.c
> +++ b/drivers/tee/tee_core.c
> @@ -10,6 +10,7 @@
>  #include <linux/fs.h>
>  #include <linux/idr.h>
>  #include <linux/module.h>
> +#include <linux/platform_device.h>
>  #include <linux/overflow.h>
>  #include <linux/slab.h>
>  #include <linux/tee_core.h>
> @@ -1225,6 +1226,26 @@ int tee_device_register(struct tee_device *teedev)
>  }
>  EXPORT_SYMBOL_GPL(tee_device_register);
>  
> +static void plat_tee_free(void *data)
> +{
> +	struct platform_device *plat_dev = data;
> +
> +	platform_device_unregister(plat_dev);
> +}
> +
> +int tee_platform_device_register(struct tee_device *teedev, const char *teename)
> +{
> +	struct platform_device *plat_dev;
> +
> +	plat_dev = platform_device_register_data(&teedev->dev, teename,
> +						 PLATFORM_DEVID_NONE, NULL, 0);
> +	if (IS_ERR(plat_dev))
> +		return PTR_ERR(plat_dev);
> +
> +	devm_add_action_or_reset(&teedev->dev, plat_tee_free, plat_dev);
> +	return 0;
> +}
> +
>  void tee_device_put(struct tee_device *teedev)
>  {
>  	mutex_lock(&teedev->mutex);
> diff --git a/include/linux/firmware/qcom/qcom_ice_tee.h b/include/linux/firmware/qcom/qcom_ice_tee.h
> new file mode 100644
> index 000000000000..a5906c5d4e39
> --- /dev/null
> +++ b/include/linux/firmware/qcom/qcom_ice_tee.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
> + */
> +#ifndef __QCOM_ICE_TEE
> +#define __QCOM_ICE_TEE
> +
> +bool qcom_ice_tee_is_available(void);
> +
> +#endif /* __QCOM_ICE_TEE */
> diff --git a/include/linux/tee_core.h b/include/linux/tee_core.h
> index f993d5118edd..d5310b404c1e 100644
> --- a/include/linux/tee_core.h
> +++ b/include/linux/tee_core.h
> @@ -205,6 +205,15 @@ struct tee_device *tee_device_alloc(const struct tee_desc *teedesc,
>   */
>  int tee_device_register(struct tee_device *teedev);
>  
> +/**
> + * tee_platform_device_register() - Registers a TEE platform device
> + * @teedev:	Device to register
> + * @teename:	Name of the TEE the device represents
> + *
> + * @returns: < 0 on failure
> + */
> +int tee_platform_device_register(struct tee_device *teedev, const char *teename);
> +
>  /**
>   * tee_device_unregister() - Removes a TEE device
>   * @teedev:	Device to unregister
> 

