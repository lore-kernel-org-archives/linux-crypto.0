Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662DD42FCCC
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784711866; cv=none; b=Zxx7PiSI8n/LiU5WwLzRj8iJRaJtzA3HP9QHDBj1XYhoa1q10PzECc294FRUpa7Q071PXRNCUaedEzBBdlz/Vih5/ptKPIlEtEgjRbSJ/2PvR+aH9lN/QzQk9hWbn6Znu8aaozRFb8RCKqTVqk4V5Uynrt+HMkqcz123KMZat0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784711866; c=relaxed/simple;
	bh=+R8ZkA1YZmqfhPlMx4te0oUV2Sqm79D/qz8UL5d8UA8=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L6wQE2mjF4sD33yt71w1FFrY+g2UbulYOy8+ikIwncXA8eO72msLGRS0h0YdBgUXXdYgaVG+rDviCackLsnCHuu250bSmoaU7kTUfOTE33y3d/xzpTwD1oKgtK3jKg19yAw7I8UU52LVa2cXSCmLzGlh0suzP/ERQm+K9CuMgXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIYmS0hR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIYmS0hR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478791F00AC4
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784711864;
	bh=/6PVliGSFycddGsKkW91KxttLoqW/+RWeZZekuLgL8o=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=eIYmS0hRD1KL5/PnVlBYaE4b6NAiEwAvR80GpXOK033yOOQ0XxCaSF6JbV1s4B36q
	 sGzkyI/LlznYxtwVcYCcThIYOvstmSCgdDZpMKZ0oW/J6s82zkpwVPz1kptMYkBKZ2
	 l37pwiCsaixEgd1zytkGIKnBQF2f9fnmlRzKkq02m+9Kwj3S+S/1cmv1kdEZSW8SCh
	 S1OJFAfJyLIZX2TkG9CkPc1QRxY7exVk3315v/o48Bg8monAbIj5VjKbPx+XhgqqOQ
	 6XzKUfTQMy0PdrtouMwME+PcIHI0McXoOyWKbQ97M/162XGw9GUZoYOct8HlCA9v8I
	 6fLs6O3QvG6Cg==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39c95395230so72612201fa.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 02:17:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr80azrj+DHz5LZZhjVfbbgVwliLMpzWmt6KgBb8dEMjZkS1Vt3s5bSlYP6hdnFd7NoYbZ/NA764E+J/wI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhZv70IHw20Q+KGQPhjqJESyhjaIpm6+AE8khJC5zpTpiiCxyv
	XajBc7YPANy3ET5hV/8VrDu5YFR5/ihq/e0IQZNK9idWgfY9dDVcCHlNamAP9djANRLaACx5GiZ
	htIEUWLGc3Ed0mAiXzWFD6yG8pqR8UNIwSdHy6zhCTA==
X-Received: by 2002:a2e:a9ab:0:b0:399:9436:15c8 with SMTP id
 38308e7fff4ca-39eb270e082mr43628601fa.2.1784711862775; Wed, 22 Jul 2026
 02:17:42 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 22 Jul 2026 02:17:41 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 22 Jul 2026 02:17:41 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <773715fd-823f-4564-ba42-c60bc8284b45@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
 <20260721-qcom-qce-cmd-descr-v23-12-1be02deffda9@oss.qualcomm.com> <773715fd-823f-4564-ba42-c60bc8284b45@oss.qualcomm.com>
Date: Wed, 22 Jul 2026 02:17:41 -0700
X-Gmail-Original-Message-ID: <CAMRc=MdLMQgJsxAMXLBkZNWUiz9fYh0j=C5ErbFoDLV=VfPUzg@mail.gmail.com>
X-Gm-Features: AUfX_mwTbpG9pQdrDFtGkM8Tiwv_fdaEPF_gwsJQGZR809JD0LGXxyeWnhoxkdg
Message-ID: <CAMRc=MdLMQgJsxAMXLBkZNWUiz9fYh0j=C5ErbFoDLV=VfPUzg@mail.gmail.com>
Subject: Re: [PATCH v23 12/14] crypto: qce - Map crypto memory for DMA
To: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Udit Tiwari <quic_utiwari@quicinc.com>, Md Sadre Alam <mdalam@qti.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Stephan Gerhold <stephan.gerhold@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	Peter Ujfalusi <peter.ujfalusi@gmail.com>, Michal Simek <michal.simek@amd.com>, 
	Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@codeaurora.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Vignesh Raghavendra <vigneshr@ti.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 21 Jul 2026 20:20:05 +0200, Mukesh Savaliya
<mukesh.savaliya@oss.qualcomm.com> said:
>
>
> On 7/21/2026 7:03 PM, Bartosz Golaszewski wrote:
>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>
> [...]
>
>>   static int qce_crypto_probe(struct platform_device *pdev)
>>   {
>>   	struct device *dev = &pdev->dev;
>>   	struct qce_device *qce;
>> +	struct resource *res;
>>   	int ret;
>>
>>   	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
>> @@ -204,7 +213,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
>>   	qce->dev = dev;
>>   	platform_set_drvdata(pdev, qce);
>>
>> -	qce->base = devm_platform_ioremap_resource(pdev, 0);
>> +	qce->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
>>   	if (IS_ERR(qce->base))
> Would you like to add any debug/error log ?
>>   		return PTR_ERR(qce->base);
>>
>> @@ -254,6 +263,18 @@ static int qce_crypto_probe(struct platform_device *pdev)
>>   	qce->async_req_enqueue = qce_async_request_enqueue;
>>   	qce->async_req_done = qce_async_request_done;
>>
>> +	qce->dma_size = resource_size(res);
>> +	qce->base_dma = dma_map_resource(dev, res->start, qce->dma_size,
>> +					 DMA_BIDIRECTIONAL, 0);
>> +	qce->base_phys = res->start;
>> +	ret = dma_mapping_error(dev, qce->base_dma);
>> +	if (ret)
> Would you like to add any debug/error log ?

No, I don't think this is needed and at v23 this really is useless bikeshedding
and doesn't add anything to the discussion and only delays getting
this upstream.

Bartosz

>> +		return ret;
>> +
>> +	ret = devm_add_action_or_reset(qce->dev, qce_crypto_unmap_dma, qce);
>> +	if (ret)
> same here
>> +		return ret;
>> +
>>   	return devm_qce_register_algs(qce);
>>   }
>>
>
> [...]
>
>
