Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3444404BC7
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 18:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658030; cv=none; b=AiHNu3SLLW9kjiN/qybvUDplHGTncOrQDxgs2yvucIwgNiqW7ulGNmX6WjidssfuLYWMYj1AYnSysh99hhc27G39E+qz2q/xzW9ZMynrw+RElflqzkTbP+r+hVeilbAqwiZbYN+uSUTAM7sQMC95rttoiXBMR1zOxR9Mu23Yjq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658030; c=relaxed/simple;
	bh=9I8SuSEzPUmQkXgAoO8qB39k16yQ61FTlzIkj3Jiy8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=It6L2158sxQzhDTIjriemkHJiyDg5mu3qIxhfBLNlGzrmwzZffhDhWR1VDkeq06UzA67jrgKlnaifxXJfhihyPhwVRVEpk74T7En12ufv19HC+ImH6picNf7wzPudy41eaolD3xQL5VtRhf/NP5B2v7LCpbGxI6M+9fuJjMavcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FJj05R2s; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IeRmYYGt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FJj05R2s";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IeRmYYGt"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LH2U7w3439779
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 18:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fc5hVouaXSdYpjHELQxCbl6GfmZ4wxwxC4HC57BPPkk=; b=FJj05R2svGpfrQnX
	c4tc7mBvFM9B4aQNDUteAR7It2s6TbFcwp6eeV+GQ+dxnRwu7id/oQFmugx1iFfs
	M96r+iZL1B8zDG38y5RvigS6wes1uF5nrMDq9xvpt9tClke6yOW2xFyw2WQEGowt
	2VBHXx74dRPKyUeIHBYPKWuhnxXVmob39F36XTu+qx8nS925V1A97i0O2jkILy9u
	Gikiv0FdE4LRx3Oj/+qL3AdcN4Zz+q7VdyxB+vXn/A0auBxFvkqYS3CIg15tk47q
	z4c23L3sCtCMvuDTX/KJOah7FDg4OHwR7jPQDJbTdhxPtoNYVPJYr0SgYzF5UXqQ
	OExG+w==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj6nstdp0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 18:20:28 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca860baea9fso19957982a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 11:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784658028; x=1785262828; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fc5hVouaXSdYpjHELQxCbl6GfmZ4wxwxC4HC57BPPkk=;
        b=IeRmYYGtxW6HjkSbKsjC/0OHYZnVjN7zFd3Ntp3NWP3MN84/Vt1JAHf20foS+eXpPZ
         QuEg0mznMb6YbOzdXI5YyU7amROZA62U2VsHsk1cjo2dWxB2YjkeV89HVIKmmT4CUQ+f
         Ov9/hG1ndQ0PUXN9V9YPIS8SuAPf7lDq3JcRZFOMrRVVfFagqCQgbEltkDLJQ+Zwq0AA
         ztc2TvTrYQOGY6QHJBaZcKk/3XNKujoQGRpxfHpxxmKc6Zd+5da0t+cGUNApRPK9b+Qq
         SQqE19+G8WjB/eAtl3qU+IUQoY7WPBmuJCjZ6K7lCCrDlugfTIQKkNXXduOZtEdf06Ks
         ORwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784658028; x=1785262828;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fc5hVouaXSdYpjHELQxCbl6GfmZ4wxwxC4HC57BPPkk=;
        b=nJrT+JxRhnwsYVTdAp9MjciLvmXNhBQ194cWdC3e+hY4d9XQ2ZGYIZodYtCw478oyh
         Iw5UW0tBCE+FTBa0XzZPQXHXGDa3uvX1KpKcnWRF+0aCMb2/qZLdiXxd6zTrNcgUSlqJ
         AHnTavLcQmaK92xtfKegoyYPlRLyGC2vV1HDcYDkPhvfPUawzV8OkjxsJQ0oO0whRwxm
         Aiiekj/oYLTn8OPxNyNKAD1d2C+rkfjuCH5jUkmjCPUiR0g5WMCCg4muUT3phKQ8y14U
         KuuJBDJrB0y1DzTycEF+iEt7+HFJ+WeUZVVGyL8svpqxDJytwmWK6j5rtjZzUu+4vADF
         4J+Q==
X-Forwarded-Encrypted: i=1; AHgh+RrWfp1v4+QFS19v/VtBiaukmJFx1knVZhrgRlYOTzNGDOy8vCBwTGQzvrwzsJq+UYq5i7FKgSC5NhjgGvQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy82nXv1h80ep279RuoZgoIZ8PCGZy9uoFPPACDYbyOGn0PTz6F
	X1+OzUTLi/O9B6b6e7gnQFM6vN6QO5//OUU4f575anH+gaIguHt1mf8RiPR21Y0r+y5b7dRbluG
	vrbXTQ/yxxLGJC+JSlxs7bRWDgQ8yzZPwBcr/G9ZK+H8rTvg8jIQOQJpqX1Ik70qYaqA=
X-Gm-Gg: AR+sD13XVU8V2OZS/gX28auZ3tfFiM6tQoQ1lVn6bg+262suhD9AN0dDZ//pOhlP8f6
	JqYAk+fApQhlQf+Lq00xlgwQ6HzgIzpVcArbKPDLoFdEyIB9/C93jNbe6gtnqu8OlBYOAeUOXY0
	bX2m+wv7vJC/qNu/grK7mQZR3exFetVKcbb8nFAV18gvEO29t2ZXN49R/tr93ovnuNs7uxG28XI
	pmzkAW1GzNG4+vPieQtvQQE9gXb2QabOz7e2xSHn4qP/ZZTl1E0ipSCWQBKjBiSQ3C+nc5d29gj
	rll7TNf0ELUYTxZD68iTpj6hRFUPOoZ6nPwG5nyKihv8K+G5Ap6Sa9IjaYOkj0y6fETmV3pulED
	2v0DPdBIQ7xDDAYHBUeR4FfaC8npPV5Yon5A=
X-Received: by 2002:a05:6a21:7008:b0:3c0:9c1b:d0b5 with SMTP id adf61e73a8af0-3c3ad9a4de9mr22508061637.64.1784658027487;
        Tue, 21 Jul 2026 11:20:27 -0700 (PDT)
X-Received: by 2002:a05:6a21:7008:b0:3c0:9c1b:d0b5 with SMTP id adf61e73a8af0-3c3ad9a4de9mr22508005637.64.1784658026958;
        Tue, 21 Jul 2026 11:20:26 -0700 (PDT)
Received: from [192.168.1.8] ([106.222.235.145])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e07000fsm2341770eec.21.2026.07.21.11.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 11:20:26 -0700 (PDT)
Message-ID: <773715fd-823f-4564-ba42-c60bc8284b45@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 23:50:05 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 12/14] crypto: qce - Map crypto memory for DMA
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov
 <lumag@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Stephan Gerhold <stephan.gerhold@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
 <20260721-qcom-qce-cmd-descr-v23-12-1be02deffda9@oss.qualcomm.com>
Content-Language: en-US
From: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
In-Reply-To: <20260721-qcom-qce-cmd-descr-v23-12-1be02deffda9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: MIy9EdpyP71MDmffwg28Or9_kbG3r9Np
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE5MiBTYWx0ZWRfX37uzlNyH3nlv
 igQtDTXGlHIZYXWX0l436SjWMDwxj1DoLRNXKDhsV4Pi3+dlPSWCQRdRLOoAkOFwHN53DdPzTwn
 uHCNsHPcqQ4SnQRrEhApFfXWZrvR47g=
X-Authority-Analysis: v=2.4 cv=ZJjnX37b c=1 sm=1 tr=0 ts=6a5fb86c cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nYgDJefOb7ZtON2RxEtQrg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=KKAkSRfTAAAA:8 a=DV7x2YVLp9Y0dp68W6cA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: MIy9EdpyP71MDmffwg28Or9_kbG3r9Np
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE5MiBTYWx0ZWRfX2dVUWTONhZ7Q
 HsIBSqpa9pn8YyBJaawOBv3Y6wxk8PfC6Aes9k0CSBEafWMWuPBJsMNrMTkCTwN0D6Vc64fx+Br
 cRjwBii8mt6wnXShSdOtFBzVz0nKFeApqZxEtjaDVPUeITFj11sDEyQiAD9wQ8FC40n+5uWzcKC
 m2NbNKQ000I6IAyC2nlgp87o/D1FjqBbIcC6k4F0zsWKwX2GffzgXHHK6Ppq1Wrud6AS54mMD6n
 xTCXf323WZJL+KqFxTnFVHnwGZgxw7Kqcz7jLNYaJrYF98QCrvGArT7Co3vWwd1fbjwWXaIAg6o
 iS6I/ELPQ21tqQJZ7Zft1EVe6cUUADCpeFDd02eVh7esl2WpOxGGsgGu2iX03MLdEY5QN/fOT0w
 uSvx3VHFF/CVuLUNk71E4lwvK68fhiTSu1z8dd8LwvXNihTeXGx2leyE5427iu1HY2ZDOH9p/v4
 6jfI+g7tbAmcHD63ewQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210192



On 7/21/2026 7:03 PM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[...]

>   static int qce_crypto_probe(struct platform_device *pdev)
>   {
>   	struct device *dev = &pdev->dev;
>   	struct qce_device *qce;
> +	struct resource *res;
>   	int ret;
>   
>   	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
> @@ -204,7 +213,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   	qce->dev = dev;
>   	platform_set_drvdata(pdev, qce);
>   
> -	qce->base = devm_platform_ioremap_resource(pdev, 0);
> +	qce->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
>   	if (IS_ERR(qce->base))
Would you like to add any debug/error log ?
>   		return PTR_ERR(qce->base);
>   
> @@ -254,6 +263,18 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   	qce->async_req_enqueue = qce_async_request_enqueue;
>   	qce->async_req_done = qce_async_request_done;
>   
> +	qce->dma_size = resource_size(res);
> +	qce->base_dma = dma_map_resource(dev, res->start, qce->dma_size,
> +					 DMA_BIDIRECTIONAL, 0);
> +	qce->base_phys = res->start;
> +	ret = dma_mapping_error(dev, qce->base_dma);
> +	if (ret)
Would you like to add any debug/error log ?
> +		return ret;
> +
> +	ret = devm_add_action_or_reset(qce->dev, qce_crypto_unmap_dma, qce);
> +	if (ret)
same here
> +		return ret;
> +
>   	return devm_qce_register_algs(qce);
>   }
>   

[...]

