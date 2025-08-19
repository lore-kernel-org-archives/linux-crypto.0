Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3908B1E5207;
	Tue, 19 Aug 2025 09:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755597415; cv=none; b=p1H0lgNUL1obwWHdrHHYqz1KktIlQovPzn7frIKjTnoG63bo91qsdW6Bl6h4v7v9pr7ggbpZyKQxwSLfsM60w+n7uVBGiRNX4pCVZOfY7oZOp2cHS52SRyLaaxeLTQlIGXASMC/1ka2+e5GXjfURCyZRmswZCr1e4k0zwQhtesU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755597415; c=relaxed/simple;
	bh=0zy3VasTvDkGYKh2MdkeeuI2WFPOfWq4rFwh0kf6R20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Exy1n4XF0I45wNPpl2Y91uYZFysFBp+bnaopvv34V/tH2+AocKH/W1fRzOfXHrXiCxFdikA6uF0Aekxcc40hlXqgVLGonLa/vLzEeCh6APj7tundDhxYhaizVa1WTLZ+L6sPAiMSOsR7L21zP8IMy1srAYdGQsR/94QvrbA3Njk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmlCtNop; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmlCtNop"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb78da8a7so829274666b.1;
        Tue, 19 Aug 2025 02:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755597412; x=1756202212; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g0bVAF8WDQqarUcJ5Cxhh/tMUtZzqgjbTmQW+l2gxzk=;
        b=jmlCtNop8rM18KIAQqLxFBu/Oh1zJR1TSfJNeLabLdcv6PyPJvgEi2mfpq7aRuf/ql
         NFDwujxtukOO8bXjtECb8BRMTBIqtUI0GJes5eQFJsp+S/9WDGIC87sWdn2yaG2wdH9g
         E42hamsabVBIvYyCSGVqrMkRtIgV7+2eWFg6xbJWUAwS/JYBIDdbULSmz8SJWwxJgX/1
         nGhh/qFb8ew3pikC21AcrKoJU9zw1Imq0qmr0yulFPtGqhCZMJYRFqKvce8MBnV5oe00
         GEOR1mPSYhJQLARBQ+Kxye7CdnLt8oEciewW5HzUMRW3tpvUodswcZuYcA1a8feCoF4k
         aeZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755597412; x=1756202212;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g0bVAF8WDQqarUcJ5Cxhh/tMUtZzqgjbTmQW+l2gxzk=;
        b=udk0yrzvjt0banuwD/cIoyugD6E2gItvJGvYUeqgFeabYoFAVo92FH/IridpMe3XgQ
         k2FxMFWMfqVqJQGpk6igkdM6+i6TZsg00cHvb1iK7Anbqzg6yUMxCXwqdhA4Oa67vtPO
         CfGyWybAeo2dagKWGPN2lu15UCHkPG6mmoIOaUjNC0YkWDrOT2s1rgKJllg3+cXbLt1a
         ZB4kbGZfGvjWJ2GLHu8E5KTLtAO4ArGcMbOrdQOgVH48nAuyWXqZi0NczOTq01zqj3oh
         WWdhrA+dMkUlsApR/GAEAGlUCPbP2t0pt9dUPGwfWinYeVaobS8FxT2P4kyf3xe+EivL
         yL+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXXhoqTpY+jlz30JXR0bzAEnI4n8/MBHSvWKajEHjYVFqJynh+gcMYglDLRyw19TfWusQhqD3ea0I/a6fc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSxnY8Klrd4sGuTG08H5esEcpSoRVqYon7NhAfHpvZgbdX7G0C
	BVfvol3EOPLlbY3Wi6hcDxXChQ254JncAzYL0CsxsVACbhursZN3QBXyCeKjiw==
X-Gm-Gg: ASbGncvdHnAgCTdqwv7EQs45X4skYhiP7BAB6OWi6tuUANoAXb142/lwNiQimT/EQIW
	1bj3ap1fWse8HeP3zoyW2vd1ixNMzhKMNfQikjOC+9yivwFR/2D7nRg+cK+JgeDexbuhaFG6Pco
	vX9XUW2hyz5fTRn2Io7G8k41t4JSHuEfqlqyW/miruuDbTa0Rg7/y5ehSGs5I+Js3NTSzNg5UsB
	KgVF3x8wX2ycepgKPL05WWLO7ahEz9DrlpsP0HbVM9Ozb9bL4Sfhz4pDQ3Z3NkSClAonUAvBrmO
	bXZQq77V1Iu/0+CHGTKwHcmH/YXIzyMmr8ftgV9z7Ny0oY1SmaMpNMGuP3X0Bajk8gmJZH+Fh2I
	QwCyHXnbs6+M1+x5yFYvCMt+9pSSA+/ee/5OD5Q2M+kpI5J0n06h7C/jFBURD1lVecMKKnLg/Vq
	zEaiw7
X-Google-Smtp-Source: AGHT+IEcppJNVG91ZVqZDy4Z08DCNt+xy4s8G+9ZqhzqBRbSTCDZF6ZxqhVeNiqJS850WRXpPuZhVQ==
X-Received: by 2002:a17:906:c103:b0:ae0:e065:ddfb with SMTP id a640c23a62f3a-afddcb8a329mr192086366b.18.1755597412348;
        Tue, 19 Aug 2025 02:56:52 -0700 (PDT)
Received: from ?IPV6:2a02:2f0e:c207:b600:978:f6fa:583e:b091? ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdd04e0c5sm973562966b.117.2025.08.19.02.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 02:56:51 -0700 (PDT)
Message-ID: <e40d056b-731d-4e33-9347-20c0a7665ede@gmail.com>
Date: Tue, 19 Aug 2025 12:56:50 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] crypto: ti: Add driver for DTHE V2 AES Engine
 (ECB, CBC)
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Kamlesh Gurudasani <kamlesh@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>,
 Vignesh Raghavendra <vigneshr@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
 Vishal Mahaveer <vishalm@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>
References: <20250819065844.3337101-1-t-pratham@ti.com>
 <20250819065844.3337101-3-t-pratham@ti.com>
Content-Language: en-US
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
In-Reply-To: <20250819065844.3337101-3-t-pratham@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 8/19/25 9:12 AM, T Pratham wrote:
> Add support for ECB and CBC modes in the AES Engine of the DTHE V2
> hardware cryptography engine.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  MAINTAINERS                       |   1 +
>  drivers/crypto/Kconfig            |   1 +
>  drivers/crypto/Makefile           |   1 +
>  drivers/crypto/ti/Kconfig         |  14 +
>  drivers/crypto/ti/Makefile        |   3 +
>  drivers/crypto/ti/dthev2-aes.c    | 411 ++++++++++++++++++++++++++++++
>  drivers/crypto/ti/dthev2-common.c | 220 ++++++++++++++++
>  drivers/crypto/ti/dthev2-common.h | 101 ++++++++
>  8 files changed, 752 insertions(+)
>  create mode 100644 drivers/crypto/ti/Kconfig
>  create mode 100644 drivers/crypto/ti/Makefile
>  create mode 100644 drivers/crypto/ti/dthev2-aes.c
>  create mode 100644 drivers/crypto/ti/dthev2-common.c
>  create mode 100644 drivers/crypto/ti/dthev2-common.h
>

[...]

> +static int dthe_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct dthe_data *dev_data;
> +	int ret;
> +
> +	dev_data = devm_kzalloc(dev, sizeof(*dev_data), GFP_KERNEL);
> +	if (!dev_data)
> +		return -ENOMEM;
> +
> +	dev_data->dev = dev;
> +	dev_data->regs = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(dev_data->regs))
> +		return PTR_ERR(dev_data->regs);
> +
> +	platform_set_drvdata(pdev, dev_data);
> +
> +	spin_lock(&dthe_dev_list.lock);
> +	list_add(&dev_data->list, &dthe_dev_list.dev_list);
> +	spin_unlock(&dthe_dev_list.lock);
> +
> +	ret = dthe_dma_init(dev_data);
> +	if (ret)
> +		goto probe_dma_err;
> +
> +	dev_data->engine = crypto_engine_alloc_init(dev, 1);
> +	if (!dev_data->engine) {
> +		ret = -ENOMEM;
> +		goto probe_engine_err;
> +	}
> +
> +	ret = crypto_engine_start(dev_data->engine);
> +	if (ret) {
> +		dev_err(dev, "Failed to start crypto engine\n");
> +		goto probe_engine_start_err;
> +	}
> +
> +	ret = dthe_register_algs();
> +	if (ret) {
> +		dev_err(dev, "Failed to register algs\n");
> +		goto probe_reg_err;
> +	}
> +
> +	return 0;
> +
> +probe_reg_err:
> +	crypto_engine_stop(dev_data->engine);
> +probe_engine_start_err:
> +	crypto_engine_exit(dev_data->engine);

crypto_engine_exit() calls crypto_engine_stop() internally, so there is
no need to call both functions here. Just use crypto_engine_exit().

/**
 * crypto_engine_exit - free the resources of hardware engine when exit
 * @engine: the hardware engine need to be freed
 */
void crypto_engine_exit(struct crypto_engine *engine)
{
	int ret;

	ret = crypto_engine_stop(engine);
	if (ret)
		return;

	kthread_destroy_worker(engine->kworker);
}

> +probe_engine_err:
> +	dma_release_channel(dev_data->dma_aes_rx);
> +	dma_release_channel(dev_data->dma_aes_tx);
> +	dma_release_channel(dev_data->dma_sha_tx);
> +probe_dma_err:
> +	spin_lock(&dthe_dev_list.lock);
> +	list_del(&dev_data->list);
> +	spin_unlock(&dthe_dev_list.lock);
> +
> +	return ret;
> +}
> +
> +static void dthe_remove(struct platform_device *pdev)
> +{
> +	struct dthe_data *dev_data = platform_get_drvdata(pdev);
> +
> +	spin_lock(&dthe_dev_list.lock);
> +	list_del(&dev_data->list);
> +	spin_unlock(&dthe_dev_list.lock);
> +
> +	dthe_unregister_algs();
> +
> +	crypto_engine_stop(dev_data->engine);
> +	crypto_engine_exit(dev_data->engine);
> +

Same here.

> +	dma_release_channel(dev_data->dma_aes_rx);
> +	dma_release_channel(dev_data->dma_aes_tx);
> +	dma_release_channel(dev_data->dma_sha_tx);
> +}

Ovidiu
