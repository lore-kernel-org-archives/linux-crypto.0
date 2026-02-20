Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCD732E121
	for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 09:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771581131; cv=none; b=GTPaabBCt6aZwncdsMXOkeyZ1oYShtksJYHPKoE73hnVVb+8d8LFPN136yNhcPjYNa/zqBeROdQXHXeet9DbzxPGvsYlsWC+c1F8VzEmBJSwFp8s9lXMcg14zBGx5MV6JrYz5YJiOaxGNVSbwIo3Zq7SXyzDvPPcKlQQgyY4Xgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771581131; c=relaxed/simple;
	bh=FowdKhKXbyjVfW9AkAYjblRRaJ2Zozif1PAqo+RUePM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pzBcPj0uq9VE18o+mz4QdyP21mG0+cXOGuf1u/vLrt54JSZvXXwCZ3a9m9m+l00HhK2RSAKEby9/m51D2TvOHsDKXZL1yMUjUKMRBYPw6JIE+ytITwtlxSRpReeC1UQYPMiPgn8i1nD2bmksoswo2N2GOulzPvxdnFmL6vlGRx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IFhAzCvg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ae1VPCc0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IFhAzCvg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ae1VPCc0"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61K5S8QY3337643
	for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 09:52:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	G8NbSIkdAuG83lqu5TIDUnU4FuLiZ05N8tMIJQiF8/I=; b=IFhAzCvgdOlLliUH
	H/zprfA17VAM+fV9geWgjAGRtSRRFv0QgeusOKKLHkDY6h9Fs74tWqOrgb+YwS8W
	m2sXQX5iRxCPgYfCK3ar+/1TcFKrL9J9BHJmfH4N8wfpdKNVfVaXfCESj98erSdE
	6MbZcyktjT5poRPUqSR4e6tKqWo5l6p1mOSBqDIhoQpVIDsp9gyrpU9VbkF1uIXx
	yMqlp7sIGo7N95IhH16Ytd9/o7BS4fymmyGYY2d/e54Po6mn68uZTitU4A/oUeeA
	KpvWwG/JP8r/rhhrT3AQRiqXIIt/CTAnCVCaf5giFnM2VW79eFjUc54zjOiZ2NOe
	/X/myg==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cedp6h6jq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 09:52:08 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-89545f12461so17990946d6.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 01:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771581128; x=1772185928; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G8NbSIkdAuG83lqu5TIDUnU4FuLiZ05N8tMIJQiF8/I=;
        b=ae1VPCc0LjuKi0TQETXCmRRyZWfTgG26SHF+zMYnIvJnlcVXSOCdCqsM74RDC0y98k
         013Q0C03dXoON9g/cdBRhCCh3rZDBOuZ+KfhKQ89VW+m0BW4k+/6TGkx3W+wk8/jAfbX
         Uz2Y/IzE8FUNw1NpdTBEyNPQfJZdIvKSdH8mnvHt0v+pqwORcVQBoOBulWeRUzD4pN/l
         78W1zj8gQws9XyWT9dYtaogEfLBTYGepCfeZDdQUx13aymPzg5quwOeYD6TgrA3lZz4S
         2g4o45jKW7kAZr1Pv2N3khc8Ag+H4j5uSIFmd6+ZjUJ1ZVE4hBNmW9cgvxQMm0MHDYnB
         km+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771581128; x=1772185928;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G8NbSIkdAuG83lqu5TIDUnU4FuLiZ05N8tMIJQiF8/I=;
        b=jB3fZCoeSsEGjMGjYsJraZSQ7MLap+1mnoqQRFOd4U0MCk7j65EfWGGWe7DYy1qVg7
         zCDoPkupktl0awQY3l8UuLHPTJetwY/Km+FHp0r91lTxEnr4RXRtwWPNVj6Cidg0dRtW
         K/dGYhQcJ+VT1UZQG24cHeUqqipajuBdsAuLVNVtTWIsib8o5a06Sx+PFTA/Ukqiy/Tc
         Jv3U9rDEXz+bylP8RaKxnCWRitopq14KHHfVjIxkfxmEUIiuEQJFlPH+ot8sNEx4rghB
         4il3OomP/sOpOUY2sVNXVCK715qYUGTLCCnhz8iPmnl9MiKCC2/Pydw4aiM12dFhvwYJ
         jvDQ==
X-Gm-Message-State: AOJu0YxnOBB2pTYQnq5Sbem8j4IXvVTPRec4o/Sj7qvGeYrV6oREHzVv
	7KAIccoTh++usdzmvKMhrWnOSoklq3PIcFHZCWAeTQMmXFOHZH2z6o26nS2YdkGkncc9VHGPVI3
	Hz1SPZeCFaZVz9yZ3UFHz8abNrGCJpTALxL1LDv2qxFMAHb1pAh5GXGQO5f4jawfaVUo=
X-Gm-Gg: AZuq6aI1RSCpqtjkyM6sla5EE0wVcCZsQTsyOGXhedhAgDt+bU70qt6LACTeW9JFHzx
	7PZhDxRkoKPtquX69oKwxgHkqAPrYUlWRyWcISEE+dL3s1DHswBltEs076bUzDpiIaU6Hc7jC+t
	+JclThfnCmK24GWjjIVYWN5hMLWevfhqPbYR/YuzZhR+lP6dhIqfN6c96iYMWoqKHFQgr5hJNt+
	pLJiyRf+n7YKFt58Z7Nex7GgKOPUdtcXAZWTPEhj9h8299HaDf9ZxDmEMN4ot5I6Eqn5q6zMyZK
	TzCdazLGKsa0CLFERobW/GKzk+Ey0stEmrE4yQgVSWr9xARGn8teNXciwXHPS50Wa1tuO+dZjlP
	5rM8SnNzif7RZEIkwbNlY643e9N1z8gj1TAfVXsLg6+iOTETLUl36LF1QwfPW0gRhBoNv0pQv+y
	uYsVw=
X-Received: by 2002:a05:6214:6014:b0:894:9d67:7329 with SMTP id 6a1803df08f44-897346fe806mr239456716d6.2.1771581127801;
        Fri, 20 Feb 2026 01:52:07 -0800 (PST)
X-Received: by 2002:a05:6214:6014:b0:894:9d67:7329 with SMTP id 6a1803df08f44-897346fe806mr239456636d6.2.1771581127452;
        Fri, 20 Feb 2026 01:52:07 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fc73f7b8asm658082366b.27.2026.02.20.01.52.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 01:52:06 -0800 (PST)
Message-ID: <ab5725df-8454-4e3d-8806-a711ef0e6a42@oss.qualcomm.com>
Date: Fri, 20 Feb 2026 10:52:04 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: quic_utiwari@quicinc.com, herbert@gondor.apana.org.au,
        thara.gopinath@gmail.com, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com
References: <20260220072818.2921517-1-quic_utiwari@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260220072818.2921517-1-quic_utiwari@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA4NiBTYWx0ZWRfX4jSrXYm8jkzz
 Bb8Gde3KDO6DlYHB9uY6kQ6WtsU0sgRsavkGBW4BDaXKY9mkKr/X+IT002dLNqMnFwlhhDwZ/jp
 BgXCy9LGP8pAQNG9O+zhz1YJgPhYg0h/GckUWzh5RgbbaqvPzLOxilmbl/e8Vwvayl0fGPwMDBL
 ivIm+QoGg+NQ+iQHRatWBFWXswq13ewi+CiVgB5C1bTRpqo1TxiD9artF6HukQPJjKgLcHhD4AI
 yHTYfoyq/6LDjoGqupXNCrETua/FBpiep8fCD8hnbJj+xTuQqICoRXqbZwGFJePzTiDmX+N6sBj
 Lc7ZCjiZOZTrsTuwWueuapFushjeyOnFM3LdfBhcdV9PXE6PBMXMRdwxJMRZ758fqBFsPMrx/gx
 YHFfehH5GESG4myNAwJN/3a/70NmHQhxmvELIHzO+qElzCDbnDy6u5/INHULFLb4YCyLjjQx7gX
 nTYgk3p42+TlmdDSVuw==
X-Proofpoint-ORIG-GUID: qRcPHUwWRE4uxPmw9deIP7I0H9rqSzSC
X-Authority-Analysis: v=2.4 cv=Vuouwu2n c=1 sm=1 tr=0 ts=69982ec8 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=COk6AnOGAAAA:8 a=KIb8oVNHrCvuKONrHFUA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: qRcPHUwWRE4uxPmw9deIP7I0H9rqSzSC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_01,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602200086

On 2/20/26 8:28 AM, quic_utiwari@quicinc.com wrote:
> From: Udit Tiwari <quic_utiwari@quicinc.com>
> 
> The Qualcomm Crypto Engine (QCE) driver currently lacks support for
> runtime power management (PM) and interconnect bandwidth control.
> As a result, the hardware remains fully powered and clocks stay
> enabled even when the device is idle. Additionally, static
> interconnect bandwidth votes are held indefinitely, preventing the
> system from reclaiming unused bandwidth.
> 
> Address this by enabling runtime PM and dynamic interconnect
> bandwidth scaling to allow the system to suspend the device when idle
> and scale interconnect usage based on actual demand. Improve overall
> system efficiency by reducing power usage and optimizing interconnect
> resource allocation.

[...]


> +static int __maybe_unused qce_runtime_suspend(struct device *dev)

I think you should be able to drop __maybe_unused if you drop the
SET_ prefix in pm_ops and add a pm_ptr() around &qce_crypto_pm_ops in
the assignment at the end

> +{
> +	struct qce_device *qce = dev_get_drvdata(dev);
> +
> +	icc_disable(qce->mem_path);

icc_disable() can also fail, since under the hood it's an icc_set(path, 0, 0),
please check its retval

> +
> +	return pm_clk_suspend(dev);
> +}
> +
> +static int __maybe_unused qce_runtime_resume(struct device *dev)
> +{
> +	struct qce_device *qce = dev_get_drvdata(dev);
> +	int ret = 0;

No need to initialize it here, as you overwrite this zero immediately
a line below anyway

> +
> +	ret = pm_clk_resume(dev);
> +	if (ret)
> +		return ret;
> +
> +	ret = icc_set_bw(qce->mem_path, QCE_DEFAULT_MEM_BANDWIDTH, QCE_DEFAULT_MEM_BANDWIDTH);
> +	if (ret)
> +		goto err_icc;

Normally I think bus votes are cast before clock re-enables to make sure
the hw doesn't try to access a disabled bus path

Konrad

> +
> +	return 0;
> +
> +err_icc:
> +	pm_clk_suspend(dev);
> +	return ret;
> +}
> +
> +static const struct dev_pm_ops qce_crypto_pm_ops = {
> +	SET_RUNTIME_PM_OPS(qce_runtime_suspend, qce_runtime_resume, NULL)
> +	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
> +};
> +
>  static const struct of_device_id qce_crypto_of_match[] = {
>  	{ .compatible = "qcom,crypto-v5.1", },
>  	{ .compatible = "qcom,crypto-v5.4", },
> @@ -261,6 +323,7 @@ static struct platform_driver qce_crypto_driver = {
>  	.driver = {
>  		.name = KBUILD_MODNAME,
>  		.of_match_table = qce_crypto_of_match,
> +		.pm = &qce_crypto_pm_ops,
>  	},
>  };
>  module_platform_driver(qce_crypto_driver);
