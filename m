Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CFD1E2834;
	Fri, 22 May 2026 06:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779432341; cv=none; b=HYA62pOghHjiYh7JgCky66s/8mESJqrAg2hlQ2Acaj+sYa1zCgSN1FVf7uFl4HoSGdF0degKUgRq7Zhw6XpWj72BIcoNCJqndjlnfNif59Y80htwTfiFZU8S+zS5mgTJ60iCOf9RtvynmIJPDDPmBym/7vWunnTmCj3zLdv0rSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779432341; c=relaxed/simple;
	bh=NEAJcMATb6PnnmILQbJ6cbR5u4L0C5MRxeUZ1TwkXWE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=l3FZ+fDX9wUrl+d8oIy2aBr/6HsZ6friq0iYzDEXoJUKDCPLKxtnTmSuOZSGxzrLd2ullU/xKn7YPUp+ZBDDOUImVrOK4c4lcmztvFpm9/E2HfapRKSpJuWcsg+x/TlEMAwTa+aoMQv2EEZSsN5WXOGT8CSvsQAeayj5Qhod3JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.164])
	by gateway (Coremail) with SMTP id _____8DxsOqP+w9qJ0sMAA--.35757S3;
	Fri, 22 May 2026 14:45:35 +0800 (CST)
Received: from [10.20.42.164] (unknown [10.20.42.164])
	by front1 (Coremail) with SMTP id qMiowJDxhcCL+w9qrE2MAA--.50900S2;
	Fri, 22 May 2026 14:45:32 +0800 (CST)
Subject: Re: [PATCH] crypto: loongson - Select CRYPTO_RNG
To: Eric Biggers <ebiggers@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, Yinggang Gu <guyinggang@loongson.cn>,
 Lee Jones <lee@kernel.org>, kernel test robot <lkp@intel.com>,
 stable@vger.kernel.org
References: <20260522022525.12976-1-ebiggers@kernel.org>
 <CAAhV-H5cDnWKxBobwRErRyvG8671e6VXsBe6w1RkX9rfn7CVFA@mail.gmail.com>
 <20260522025722.GD5937@quark>
 <d71adfa1-8895-e741-b72f-c5e99d5fb9e6@loongson.cn>
 <20260522040310.GF5937@quark>
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
Message-ID: <bc3acf15-808d-4141-7f1f-4a7a7f856c6c@loongson.cn>
Date: Fri, 22 May 2026 14:40:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260522040310.GF5937@quark>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJDxhcCL+w9qrE2MAA--.50900S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7ur4xCw4rWryDuFW3Kry5ZFc_yoW8uF13pa
	y7G3WDCF4UtrWS9w1vgw1xWFyY9w4fXrW5uF45J34rZr909F18Xr4IqF4qga4qyrn5Gr17
	trWjqr1aga4UCagCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
	6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jOa93UUU
	UU=


在 2026/5/22 下午12:03, Eric Biggers 写道:
> On Fri, May 22, 2026 at 11:41:15AM +0800, Qunqin Zhao wrote:
>> 在 2026/5/22 上午10:57, Eric Biggers 写道:
>>> On Fri, May 22, 2026 at 10:52:42AM +0800, Huacai Chen wrote:
>>>> On Fri, May 22, 2026 at 10:26 AM Eric Biggers <ebiggers@kernel.org> wrote:
>>>>> This driver registers a rng_alg, so it requires CRYPTO_RNG.
>>>>>
>>>>> Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support")
>>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>>> Closes: https://lore.kernel.org/oe-kbuild-all/202605201622.qWOiiZTV-lkp@intel.com/
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>>>> Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
>>>>> ---
>>>>>    drivers/crypto/loongson/Kconfig | 1 +
>>>>>    1 file changed, 1 insertion(+)
>>>>>
>>> By the way, do any of the loongson people have any comment on what they
>>> think the point of this driver is?  It's not registered with the actual
>> To provide an AF_ALG-based random number generation interface for other
>> modules and user-space programs.
>>
>> Thanks,
>>
>> Qunqin
> AF_ALG is a userspace interface; it's not available for in-kernel use.
> If you mean using crypto_rng directly, note that no kernel code actually
> uses it other than the tests, the implementation of AF_ALG, and the
> FIPS-specific code which uses drbg.c specifically.
>
> So, the first half of your justification doesn't make any sense.
>
> As far as the second half: why would a userspace program do that instead
> of just using the regular Linux RNG (/dev/urandom)?
>
> AFAIK, the only reason to use a HW RNG directly is for certification
> reasons.
>
> However, there's also already an interface for that: /dev/hw_random.
>
> So AF_ALG seems completely redundant for this case.

To be honest, I previously assumed that the `hw_random` was designed 
strictly and exclusively for the TRNG mode.

Is it architecturally acceptable or common practice for a PRNG mode to 
utilize `hw_random` as well?

Thanks,

Qunqin

>
> - Eric

