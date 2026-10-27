Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793071728;
	b=HBhu3hQTFtkNGR5wQwoSdMEWqZUHcoE9LiHvcUaAmV2lhk6ZAY4YXZoYvFtMm6jHECXb
	 PzFfCi03BYGjWQ0LZY+ZPD3R10uGLUDrUbqEnE2orG0YdpMuJw3QwDVKpYj0hnT+W3/lP
	 EF1gs6GwnRHdSD7MQi5KjRY7scAAoS774lpy+FG8Laz+1REFHtw44V4oFZmFhDsX2rBmD
	 LwDUUjdinUHECxUf9ziyK1lIURmjGwk1r6rymv9Ht3ZYUzZZCdfHjUeGLlnprnhyy35i1
	 AvXTMEtFQnba+VB9iyz+ArORdwCESsDwGgSJQKgmGZgappHt1PdsHzbKUvtWyHBGqQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793071728;
	h=DMARC-Filter:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=sb+RKkGHy3e/r4gLHkfytASA7lsn8w/DIKciO5unH5I=;
	b=C9C8R3+2jpxWAQGrsscbUUrjX5bZVIViG0JJAaQ/+Z+flTV1hXVFGhNSULjZKC+jjPcq
	 DzQ+2W4uoFnwDIf0FJ27Cyw/p+OwXtIiXLpcotUkkwX3AiCfR3R+STq3J2zFDb//nhPVa
	 06GIFJUfJB8CqG7H8K0mKjmpNhDwMiJFgDaznqWJAd8JFtY2ohyJ1dauz2XqBDc/Mn+Sf
	 Kq8s1gYhEALJMIer9ttMEslO59nt4UblKNRpz/Ul5VrxGnOla3QiJflD7xEpU7xOCzFwg
	 wP+278+FHVirZW+pQzYpOBAuDmqgzRtUzHDHA8AQxZzLbCZrB6vAcRXlUAzVGZ2A+Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91D5606A31A;
	Tue, 27 Oct 2026 03:28:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E91D5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.102])
	by gateway (Coremail) with SMTP id _____8Axj9FkGuBqGbAZAA--.9450S3;
	Tue, 27 Oct 2026 11:28:36 +0800 (CST)
Received: from [127.0.0.1] (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJCxPs9hGuBqhYowAA--.35389S2;
	Tue, 27 Oct 2026 11:28:35 +0800 (CST)
Message-ID: <7c3d56c7-5764-4c4a-9fbc-1e70c95df0b0@loongson.cn>
Date: Tue, 27 Oct 2026 11:25:48 +0800
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
Subject: Re: [PATCH 21/28] mfd: loongson-se: Validate engine ID, DMA buffer
 size, and IRQ registration
To: Lee Jones <lee@kernel.org>
Cc: stable@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
 Yinggang Gu <guyinggang@loongson.cn>, linux-crypto@vger.kernel.org,
 mfd@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261021121245.3111563-1-lee@kernel.org>
 <20261021121245.3111563-21-lee@kernel.org>
Content-Language: en-US
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
In-Reply-To: <20261021121245.3111563-21-lee@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxPs9hGuBqhYowAA--.35389S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxXFWDGF4rXw4kGFWfuFWfZwc_yoW5tFW5pF
	45Aa4Ykr4Yyr4xuwsxJrZ8AF1YyFyrJry7Ca9rta1IkFyDXw18Wry5WFyUWFZ3ArWUJF1f
	XFWkGFs5uF1rGFgCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2DUUUUUUU


在 2026/10/21 20:09, Lee Jones 写道:
> Harden input and error checking in loongson_se_init_engine() and
> loongson_se_probe():
>
> - Reject out-of-bounds engine IDs and engine 0 in
>   loongson_se_init_engine() before indexing se->engines.
> - Store dmam_size as u32 to match device_property_read_u32() and verify
>   that it is large enough to hold the command buffers of all engines
>   within engine 0's data region.
> - Propagate negative error codes from platform_irq_count(),
>   platform_get_irq(), and devm_request_irq() instead of ignoring IRQ
>   registration failures or masking -EPROBE_DEFER.
>
> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
> Closes: https://sashiko.dev/#/bug/linux-89bf25f5-ecd9-40e3-bb4c-bd26d07c53a1
> Cc: stable@vger.kernel.org
> Signed-off-by: Lee Jones <lee@kernel.org>

Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>

Thanks for fixing this!


Best Regards,

Qunqin.

> ---
>  drivers/mfd/loongson-se.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> index bdbab4b91729..23af05d388aa 100644
> --- a/drivers/mfd/loongson-se.c
> +++ b/drivers/mfd/loongson-se.c
> @@ -26,7 +26,7 @@ struct loongson_se {
>  	struct completion cmd_completion;
>  
>  	void *dmam_base;
> -	int dmam_size;
> +	u32 dmam_size;
>  
>  	struct mutex engine_init_lock;
>  	struct loongson_se_engine engines[SE_ENGINE_MAX];
> @@ -101,8 +101,13 @@ EXPORT_SYMBOL_GPL(loongson_se_send_engine_cmd);
>  struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
>  {
>  	struct loongson_se *se = dev_get_drvdata(dev);
> -	struct loongson_se_engine *engine = &se->engines[id];
>  	struct loongson_se_controller_cmd cmd = {};
> +	struct loongson_se_engine *engine;
> +
> +	if (id <= 0 || id >= SE_ENGINE_MAX)
> +		return NULL;
> +
> +	engine = &se->engines[id];
>  
>  	engine->se = se;
>  	engine->id = id;
> @@ -186,7 +191,7 @@ static void loongson_se_stop(void *data)
>  	mutex_unlock(&se->engine_init_lock);
>  }
>  
> -static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
> +static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, u32 size)
>  {
>  	struct loongson_se_controller_cmd cmd = {};
>  	int err;
> @@ -249,6 +254,9 @@ static int loongson_se_probe(struct platform_device *pdev)
>  	if (device_property_read_u32(dev, "dmam_size", &se->dmam_size))
>  		return -ENODEV;
>  
> +	if ((se->dmam_size / SE_ENGINE_MAX) < (SE_ENGINE_MAX * 2 * SE_ENGINE_CMD_SIZE))
> +		return -EINVAL;
> +
>  	se->dmam_base = dmam_alloc_coherent(dev, se->dmam_size, &paddr, GFP_KERNEL);
>  	if (!se->dmam_base)
>  		return -ENOMEM;
> @@ -258,16 +266,21 @@ static int loongson_se_probe(struct platform_device *pdev)
>  		return PTR_ERR(se->base);
>  
>  	nr_irq = platform_irq_count(pdev);
> -	if (nr_irq <= 0)
> +	if (!nr_irq)
>  		return -ENODEV;
> +	if (nr_irq < 0)
> +		return nr_irq;
>  
>  	writel(SE_INT_ALL, se->base + SE_S2LINT_CL);
>  
>  	for (i = 0; i < nr_irq; i++) {
>  		irq = platform_get_irq(pdev, i);
> +		if (irq < 0)
> +			return irq;
> +
>  		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
>  		if (err)
> -			dev_err(dev, "failed to request IRQ: %d\n", irq);
> +			return dev_err_probe(dev, err, "Failed to request IRQ: %d\n", irq);
>  	}
>  
>  	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);

