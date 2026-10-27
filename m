Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069446;
	b=ktx+jpUXbpzQKzgD+SYdb9BX1//i/EQCODrx25c8zZ5RIrFxTdKX0RnmXoTjHXrVxtfR
	 2NUIa23ZKT72PNntBweFAazjQJhA94En12wPDzhGnvum7syUVQzhisHOQL++ykEOG0FmV
	 xWfW+B+aNeynoAUwqU7RkpqlEeglYfNMJ6gfKj7QzRlotfYyYip7wASfeRZvhF+5tV0vJ
	 rq2RL9AqMALHRCgylsTXKKgiDPafJwuw+kLSVNOMweVv36T+13BOkgy1Mb0rBJ7dMgJNu
	 Lm11cZEybCGV93b66c9syC1dk8i3p41AWtkyUm+IUEJWUD1NmLnnCf8pCX9dlOVo7wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069446;
	h=DMARC-Filter:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=yp5lwm6B1KcrGTQodF+hkNMZvE12OPY0D+ZFleJb6Vo=;
	b=cVwfSbcZABCQCTkikKD1Sjw94eBbHoXleBosy+LKLSWPWPDaB2aVWeDb2tPR8K9oW1xG
	 SoVu+nQ9e+IyMNxWe6m+LYYMbm0xxKBocl6PehSgFXnV69oROlyt9FK0eF4t62qboYBDz
	 5WxwYSl25C0O96C79CGjGYjqmxO1IJgZU6+rjlAUzNvUeGVIi6XX2JC0eVhmDuEtpmxZD
	 eGhAUmoekVfUaYo0bp+RVcsS/eX91fbvHuPnUelXyaNY0DJiC8qbrwIlABB5cDwIsRswa
	 Z8iTyVZaCU1ziYcb78mIUpgvQ7+f2gkosz005kRfYRMLqMQi2jUIwTGg+2urF84oQlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760A2606A31E;
	Tue, 27 Oct 2026 02:50:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 760A2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.102])
	by gateway (Coremail) with SMTP id _____8Bx79KDEeBqJa4ZAA--.9661S3;
	Tue, 27 Oct 2026 10:50:43 +0800 (CST)
Received: from [127.0.0.1] (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJAxlMyAEeBqJogwAA--.8723S2;
	Tue, 27 Oct 2026 10:50:42 +0800 (CST)
Message-ID: <bf429747-eaea-47d5-a341-f74251321d09@loongson.cn>
Date: Tue, 27 Oct 2026 10:47:55 +0800
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
Subject: Re: [PATCH 19/28] mfd: loongson-se: Prevent out-of-bounds engine
 access in se_irq_handler()
To: Lee Jones <lee@kernel.org>
Cc: stable@vger.kernel.org, Yinggang Gu <guyinggang@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, linux-crypto@vger.kernel.org,
 mfd@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261021121245.3111563-1-lee@kernel.org>
 <20261021121245.3111563-19-lee@kernel.org>
Content-Language: en-US
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
In-Reply-To: <20261021121245.3111563-19-lee@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxlMyAEeBqJogwAA--.8723S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7uw1DCrWDGF48Cr45AFy8tFc_yoW5Jr1DpF
	WDCa4jyr4qkF47Cw1ayF98Kw13W3y7Jr9rCFZFgr4UZan7tw1xGr1jkFy3Grs8urWkJFWI
	vF98Wrs5uFW8XabCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU27PEDUUUU


在 2026/10/21 20:09, Lee Jones 写道:
> loongson_se_probe() enables all 32 interrupt bits via SE_INT_ALL
> (0xffffffff), and se_irq_handler() uses the set bit index from the
> 32-bit status register directly to index se->engines, which only holds
> SE_ENGINE_MAX (16) entries.  Any interrupt bit asserted at index 16 or
> above triggers an out-of-bounds access on se->engines.
>
> Restrict SE_INT_ALL to GENMASK(SE_ENGINE_MAX - 1, 0) and bounds-check
> the bit index against SE_ENGINE_MAX before completing the engine in
> se_irq_handler().
>
> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
> Closes: https://sashiko.dev/#/bug/linux-bc962408-5c42-40af-8111-a8463a05ccdf
> Cc: stable@vger.kernel.org
> Signed-off-by: Lee Jones <lee@kernel.org>

Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>

Thanks for fixing this!


Best Regards,

Qunqin.

> ---
>  drivers/mfd/loongson-se.c       | 3 ++-
>  include/linux/mfd/loongson-se.h | 7 ++++---
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> index 187ebbed0422..10af13c3b7cc 100644
> --- a/drivers/mfd/loongson-se.c
> +++ b/drivers/mfd/loongson-se.c
> @@ -158,7 +158,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>  	/* For engines */
>  	while (int_status) {
>  		id = __ffs(int_status);
> -		complete(&se->engines[id].completion);
> +		if (id < SE_ENGINE_MAX)
> +			complete(&se->engines[id].completion);
>  		int_status &= ~BIT(id);
>  		writel(BIT(id), se->base + SE_S2LINT_CL);
>  	}
> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
> index 07afa0c2524d..2d0a8b1e5c9e 100644
> --- a/include/linux/mfd/loongson-se.h
> +++ b/include/linux/mfd/loongson-se.h
> @@ -4,6 +4,8 @@
>  #ifndef __MFD_LOONGSON_SE_H__
>  #define __MFD_LOONGSON_SE_H__
>  
> +#include <linux/bits.h>
> +
>  #define LOONGSON_ENGINE_CMD_TIMEOUT_US	10000
>  #define SE_SEND_CMD_REG			0x0
>  #define SE_SEND_CMD_REG_LEN		0x8
> @@ -18,10 +20,9 @@
>  #define SE_L2SINT_STAT			0x98
>  #define SE_L2SINT_SET			0xa0
>  
> -#define SE_INT_ALL			0xffffffff
> -#define SE_INT_CONTROLLER		BIT(0)
> -
>  #define SE_ENGINE_MAX			16
> +#define SE_INT_ALL			GENMASK(SE_ENGINE_MAX - 1, 0)
> +#define SE_INT_CONTROLLER		BIT(0)
>  #define SE_ENGINE_RNG			1
>  #define SE_CMD_RNG			0x100
>  

