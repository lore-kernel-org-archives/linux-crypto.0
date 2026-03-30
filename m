Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762542EACF2
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774881895; cv=none; b=Qp5laz7cKa+ltQ/NLE47sheEZ9heHCK0u+PVpaXZM6WW9a07G0D1snmGH57OF31Foe4PKvwM1pAYO917oRpnM2Sf+CURH6WuvA2CSo36TVUA1t0+oxnCGtvdDmx7GRKGmHVPoY9sgFVylRxUpUQh42e3Q+od+9F6tQtvJL10CI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774881895; c=relaxed/simple;
	bh=Ou2un0q+kwVxdytMbnTt7jxc25K1CsHTVOD4kpr9iKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dnwvr6fJJ+PZAEd8zPWnW/olsphzQP9UhOcj/I67Qna0n9ooU9b1kXuNg4KlJLFOSR6XVEcql7u995ZJTLAEvWotxM4SkMa4xTqay6xLIzHRB574ExIUnwlSZw9ZRNcZ2ojuM9Ls0Ilm6mcMRFqyejIQSSmEucJJ+2BZr2aNC0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LkfLKjgi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RlcZ5wLx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LkfLKjgi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RlcZ5wLx"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62UA92kA3031490
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wzMonzrP2PHDXqseDefwSdvKf++DvWGpSTXQTEc+mlI=; b=LkfLKjgibVq5muow
	9xQdN1AZ/I4a/RBs1+pS28soJB1/lHTItXmX1wvnklzhTIg+8hCuWKO0+hS/SUEv
	DhkGYDPP99ss9CmzhvY426VDIEuK1816Dd/MTVaDjbMh3LdvQp8xvA3coJN6zxph
	s1bjOXgLVq/oYiLVQoXc12bHnikuMzwRO2+HdE++5Jyj+9Zd/cHjxqUO2+FYbiq/
	vtiRIdwIcUTOGaTgAHc00Su7crWG3xYOYSkpttlO8qw9jr+DOidswWpCFL/JJU+u
	TgteKpcsUm6zL8+SysRe9by/7qMfu3O2azB8NbVIC20cQLf9IxW1ZLLn8EVnu0Rv
	RWIZIA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d6wqemkb3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:44:53 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5091782ab06so237102931cf.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 07:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774881892; x=1775486692; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wzMonzrP2PHDXqseDefwSdvKf++DvWGpSTXQTEc+mlI=;
        b=RlcZ5wLxWcY0aUHtlkP5OsOHedKMgi60Vjf+EKH0bHjHmgTUFunL1TtOIhsxGOtztU
         PBgBfWrWZlPcBF7Oo6MfwNHy0fdBfCqP5MjxIPGI9uKY/N9ZWx05uUMbzIdy8oWlxDh3
         Ng8DW59XQgXOYUVFJ8OabnXmbUb6y8rilCmCSqXzEpTM9opLLH2m6bl3mPToPxEG3N95
         pxZFFZh/dH+xMdTLobpfJwoHRsxgeI6uqiz1dyAn3eLps+eGGrHIEOYTtkiH7YwnuXnc
         qlSZw0SSBNqmWqfrf0XaMfMYSELyq4h7dCVDrJyVa2S5S5Lk1k0L7XVPcbKYoSDV1lEu
         sUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774881892; x=1775486692;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wzMonzrP2PHDXqseDefwSdvKf++DvWGpSTXQTEc+mlI=;
        b=G8vvLoBhMn9wvZGB6BEhxQfPbVfHHE+2CA+ikL+pBPINDP4NZ7tTzN0j+V+8Nipz/+
         BoSLclXAJmHH+kkfkfy4lmReKfHLEnnX8khUClkY9xLb7KscORc9OJDkVXb12UO5zE1X
         tm+Ywx9o146eKOBbejFyvGLX76wFisrUtfkZDaT4jOgx1g1WUXLalOCqhEnDN7qW6ay6
         Az+HC51ZGVrE16pyrxEdtVeiXzzz55CyfR5FRxIhj2pYuColLjFuVXU2Z8P/MPUsFRX7
         T8FIA8p4KBB7PIFk2vAcF7Zbwzuzag6qC7Mv0PaMe0z+yuSlT/O1LQfVHhP8YOkIs9zB
         d8vA==
X-Forwarded-Encrypted: i=1; AJvYcCUrdGMS/TPiUWCwyj3TOjL/r7Q9VTu2MyUfQc3YensvKnX6EyJ26tksKsCSxmQgQJ+rVoXVkH2ZD4bcn+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzE1d38kHhQ3gveQeELrHsaqTFBDFqGDEzv3vW1vULp8NoJgp6
	pkWEjYlHw/NuxiOuzlFm1r0EPhZqumKc+4v2yWXCq4E6/xFmd4nAHqUMrIebhyS0Heji81ddMMa
	XGW+WcckTVgqUFw2xtOSv50d8CycqIL725YlngcmdK0rnn28Usk6R47gQmyzkGF030x8M0/sxpq
	0=
X-Gm-Gg: ATEYQzxb/0BhXgzM0C0MXKFfLD4KAmzPtZUqV2H2RzdOYFoU2QxvsavADLYysSzTwfm
	bjCLEZ79ZLUMHEhI6KbW4bR5UQM5iS45mlwNAx2RvIjo3nD8jkdZvU/MTGy4KC+3wW/c+TwgxIg
	J38xaR/93WZrtjlAp+XHl+jnGegm+d+HW7o2Mh65VoAG3VGG3FQ60z0HYPKtGS0dUr8ETZacJSv
	UX4GnfpHvme+pwrdykIGgxizQUzLf18VryMs918ZCmB5mlIwsoMoPpe9MCns/RjIVJhA7WW7RTJ
	T0SW62Y2PgR2z56cyyUx1vQpMJSCXFOttk+aSvZQjDxTanQiZchcDpBDSLAfRZaQyll/zvi8Kfg
	W4vFbT8gZN4Gg/1cX4Vj2y7nF8l0zgRryXOJxRkX3p3Ou2/TziPc=
X-Received: by 2002:a05:622a:4246:b0:50b:40a6:29b9 with SMTP id d75a77b69052e-50ba390a23amr180921051cf.51.1774881892271;
        Mon, 30 Mar 2026 07:44:52 -0700 (PDT)
X-Received: by 2002:a17:90b:2ccb:b0:354:bfb7:db1a with SMTP id 98e67ed59e1d1-35c30145afdmr11403509a91.31.1774881582117;
        Mon, 30 Mar 2026 07:39:42 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76916d26dbsm7219239a12.13.2026.03.30.07.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 07:39:41 -0700 (PDT)
Message-ID: <a616c056-f9aa-420c-a543-7f1539e9e886@oss.qualcomm.com>
Date: Mon, 30 Mar 2026 20:09:35 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/3] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-1-669b96ecadd8@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260302-enable-ufs-ice-clock-scaling-v7-1-669b96ecadd8@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Jo78bc4C c=1 sm=1 tr=0 ts=69ca8c65 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=BG8uRRCXphxkixnqWPcA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: IZQU5VPfGY8fCCOXAZamsEomMzthcYQr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDExNSBTYWx0ZWRfXzrrVDHkzl0xK
 JXTFUe/NU1Uk7CgJjrr9crQyzi4Gu7s5Non3Ax/l2JhxCNRcMJvs5okHbdrQWQMgkSMHuSCxCyn
 X54e0xFOyJmEM801dPtwB8Fj01GQmyuFtjAJVhyTT0csr9W6RN8u7GI0AVLaGtpM25e4hDvbnPX
 UEcqJCQPa8WPkJWCGlLHsZQCUYJXgZSxV0oZZriEhROtf6obab4XERbuX640lf8+DF3hJp0qfff
 9opkb55HBLCO7HI9ISy0xciwglUR3PrqeEEyAHAt9kY16NWx2ohFRPJPSjWMyFe3shVmwjXlJam
 qiCMfu4nuMAFBky9kTM4elbAmFnguYoJ2PGOVknx5WTzYQzZInxGyjqbGKS04IfeTtnxLDji3MH
 kx6k1Y9H9+iu9hGy1/P8sXuRf7nFQGx4nmBjoQBIlAHYroMq8F9Md+LzMyqGtGOsgOFSuqpTseG
 i47Rm6nN8t7fhlzUUIw==
X-Proofpoint-ORIG-GUID: IZQU5VPfGY8fCCOXAZamsEomMzthcYQr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603300115

Hi Abhinaba,

On 3/2/2026 4:19 PM, Abhinaba Rakshit wrote:
> Register optional operation-points-v2 table for ICE device
> during device probe.
> 
> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> core clock based on the target frequency provided and if a valid
> OPP-table is registered. Use round_ceil passed to decide on the
> rounding of the clock freq against OPP-table. Disable clock scaling
> if OPP-table is not registered.
> 
> When an ICE-device specific OPP table is available, use the PM OPP
> framework to manage frequency scaling and maintain proper power-domain
> constraints.
> 
> Also, ensure to drop the votes in suspend to prevent power/thermal
> retention. Subsequently restore the frequency in resume from
> core_clk_freq which stores the last ICE core clock operating frequency.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  drivers/soc/qcom/ice.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  include/soc/qcom/ice.h |  2 ++
>  2 files changed, 81 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index b203bc685cadd21d6f96eb1799963a13db4b2b72..7976a18d9a4cda1ad6b62b66ce011e244d0f6856 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -16,6 +16,7 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_opp.h>
>  
>  #include <linux/firmware/qcom/qcom_scm.h>
>  
> @@ -111,6 +112,8 @@ struct qcom_ice {
>  	bool use_hwkm;
>  	bool hwkm_init_complete;
>  	u8 hwkm_version;
> +	unsigned long core_clk_freq;
> +	bool has_opp;
>  };
>  
>  static bool qcom_ice_check_supported(struct qcom_ice *ice)
> @@ -310,6 +313,10 @@ int qcom_ice_resume(struct qcom_ice *ice)
>  	struct device *dev = ice->dev;
>  	int err;
>  
> +	/* Restore the ICE core clk freq */
> +	if (ice->has_opp && ice->core_clk_freq)
> +		dev_pm_opp_set_rate(ice->dev, ice->core_clk_freq);
> +
>  	err = clk_prepare_enable(ice->core_clk);
>  	if (err) {
>  		dev_err(dev, "failed to enable core clock (%d)\n",
> @@ -324,6 +331,11 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
>  int qcom_ice_suspend(struct qcom_ice *ice)
>  {
>  	clk_disable_unprepare(ice->core_clk);
> +
> +	/* Drop the clock votes while suspend */
> +	if (ice->has_opp)
> +		dev_pm_opp_set_rate(ice->dev, 0);
> +
>  	ice->hwkm_init_complete = false;
>  
>  	return 0;
> @@ -549,10 +561,54 @@ int qcom_ice_import_key(struct qcom_ice *ice,
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_import_key);
>  
> +/**
> + * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
> + * @ice: ICE driver data
> + * @target_freq: requested frequency in Hz
> + * @round_ceil: when true, selects nearest freq >= @target_freq;
> + *              otherwise, selects nearest freq <= @target_freq
> + *
> + * Selects an OPP frequency based on @target_freq and the rounding direction
> + * specified by @round_ceil, then programs it using dev_pm_opp_set_rate(),
> + * including any voltage or power-domain transitions handled by the OPP
> + * framework. Updates ice->core_clk_freq on success.
> + *
> + * Return: 0 on success; -EOPNOTSUPP if no OPP table; -EINVAL in-case of
> + *         incorrect flags; or error from dev_pm_opp_set_rate()/OPP lookup.
> + */
> +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> +		       bool round_ceil)

Any particular reason for choosing round_ceil? Using round_floor would have
saved the need for caller to pass negation of scale_up.

> +{
> +	unsigned long ice_freq = target_freq;
> +	struct dev_pm_opp *opp;
> +	int ret;
> +
> +	if (!ice->has_opp)
> +		return -EOPNOTSUPP;
> +
> +	if (round_ceil)
> +		opp = dev_pm_opp_find_freq_ceil(ice->dev, &ice_freq);
> +	else
> +		opp = dev_pm_opp_find_freq_floor(ice->dev, &ice_freq);
> +
> +	if (IS_ERR(opp))
> +		return PTR_ERR(opp);
> +	dev_pm_opp_put(opp);
> +
> +	ret = dev_pm_opp_set_rate(ice->dev, ice_freq);
> +	if (!ret)
> +		ice->core_clk_freq = ice_freq;

Nit: Follow same error handling pattern everywhere in the driver.
	if (ret) {
		dev_err(dev, "error");
		return ret;
	}

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
> +
>  static struct qcom_ice *qcom_ice_create(struct device *dev,
> -					void __iomem *base)
> +					void __iomem *base,
> +					bool is_legacy_binding)

You don't need to introduce is_legacy_binding.

Since you only need to add the OPP table when this function gets called from ICE probe,
you should not touch this function. Instead, you should call devm_pm_opp_of_add_table()
in ICE probe before calling qcom_ice_create() then once qcom_ice_create() is success, you
can store the clk rate in the returned qcom_ice *engine ptr by calling clk_get_rate().

>  {
>  	struct qcom_ice *engine;
> +	int err;
>  
>  	if (!qcom_scm_is_available())
>  		return ERR_PTR(-EPROBE_DEFER);
> @@ -584,6 +640,26 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>  	if (IS_ERR(engine->core_clk))
>  		return ERR_CAST(engine->core_clk);
>  
> +	/*
> +	 * Register the OPP table only when ICE is described as a standalone
> +	 * device node. Older platforms place ICE inside the storage controller
> +	 * node, so they don't need an OPP table here, as they are handled in
> +	 * storage controller.
> +	 */
> +	if (!is_legacy_binding) {
> +		/* OPP table is optional */
> +		err = devm_pm_opp_of_add_table(dev);
> +		if (err && err != -ENODEV) {
> +			dev_err(dev, "Invalid OPP table in Device tree\n");
> +			return ERR_PTR(err);
> +		}
> +		engine->has_opp = (err == 0);

Let's keep it readable and simple. engine->has_opps = true; here and false in error handle above.

> +
> +		if (!engine->has_opp)
> +			dev_info(dev, "ICE OPP table is not registered, please update your DT\n");

Since OPP table is optional, I don't understand the reason for requesting the user to add one.

> +	}
> +
> +	engine->core_clk_freq = clk_get_rate(engine->core_clk);
>  	if (!qcom_ice_check_supported(engine))
>  		return ERR_PTR(-EOPNOTSUPP);
>  
> @@ -628,7 +704,7 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
>  			return ERR_CAST(base);
>  
>  		/* create ICE instance using consumer dev */
> -		return qcom_ice_create(&pdev->dev, base);
> +		return qcom_ice_create(&pdev->dev, base, true);
>  	}
>  
>  	/*
> @@ -725,7 +801,7 @@ static int qcom_ice_probe(struct platform_device *pdev)
>  		return PTR_ERR(base);
>  	}
>  
> -	engine = qcom_ice_create(&pdev->dev, base);
> +	engine = qcom_ice_create(&pdev->dev, base, false);

Change not needed as per above comment.

Regards,
Harshal

>  	if (IS_ERR(engine))
>  		return PTR_ERR(engine);
>  
> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index 4bee553f0a59d86ec6ce20f7c7b4bce28a706415..4eb58a264d416e71228ed4b13e7f53c549261fdc 100644
> --- a/include/soc/qcom/ice.h
> +++ b/include/soc/qcom/ice.h
> @@ -30,5 +30,7 @@ int qcom_ice_import_key(struct qcom_ice *ice,
>  			const u8 *raw_key, size_t raw_key_size,
>  			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
>  struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
> +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> +		       bool round_ceil);
>  
>  #endif /* __QCOM_ICE_H__ */
> 

