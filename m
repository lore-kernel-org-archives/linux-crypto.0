Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E26DC3E123E;
	Mon, 25 May 2026 08:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779697347; cv=none; b=dxkJnxNS5l3esGNTKgHZX/4b1K2j2WEjGyhycgRuRMoyBgTN4LFeMRPN6XkP+kSxXJhGcnnwtcMWGeIJk4kqJpFaNJIdRs0DsmDXnlp7NFq0xS8uiMjuUuKL+EDZNUpFlFDFlwZE70CccpQIWzmFt5VGW/aU3XNqBoDrOR43oqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779697347; c=relaxed/simple;
	bh=G4NFmvwqppuwFg3fj04E9ibqzOf/hoxaF9CBbWAed98=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=l/cQdMTxauqfhvtXfldEaIaR+eEQNTCArP8RNB2nab6G0wdQQvI8AcJvThGVTvuAytuxFM1vdmydJ9HTqTCMuF7DTRjebgoYdUorLfXpjjXUu6qMEZRJz9hM28jDc6Kqf0XzqfyATwRKHwmH9tZmE/lvmtcHN/vrZaxmaOVVEFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.164])
	by gateway (Coremail) with SMTP id _____8Bx+Hi+BhRqvgANAA--.12720S3;
	Mon, 25 May 2026 16:22:22 +0800 (CST)
Received: from [10.20.42.164] (unknown [10.20.42.164])
	by front1 (Coremail) with SMTP id qMiowJBx58C7BhRq1i6QAA--.57128S2;
	Mon, 25 May 2026 16:22:22 +0800 (CST)
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
 <bc3acf15-808d-4141-7f1f-4a7a7f856c6c@loongson.cn>
 <20260522174835.GA1894319@google.com>
 <4501444d-9c17-8d4b-8bfd-bd1d69d77a76@loongson.cn>
 <20260525032006.GA243157@quark>
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
Message-ID: <05c794a7-f82d-5454-8df9-0ac543f8f8f7@loongson.cn>
Date: Mon, 25 May 2026 16:17:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260525032006.GA243157@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJBx58C7BhRq1i6QAA--.57128S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Cr17tw4kAw4DKr45tFyruFX_yoW8tF13pF
	Wj9a4qkr4DJr409w18Kw48AFySyrWftrWa9r4rG3sxu3s8ua4fZryxKFZ0ka4xCFy8Gry2
	yrW8WryUWFs8AFXCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2MKZDUUUU


在 2026/5/25 上午11:20, Eric Biggers 写道:
> On Mon, May 25, 2026 at 10:45:14AM +0800, Qunqin Zhao wrote:
>>>> To be honest, I previously assumed that the `hw_random` was designed
>>>> strictly and exclusively for the TRNG mode.
>>>>
>>>> Is it architecturally acceptable or common practice for a PRNG mode to
>>>> utilize `hw_random` as well?
>>>>
>>>> Thanks,
>>> So the Loongson RNG is a PRNG?  Where does it get its entropy from, and
>>> what is its security strength?
>> Loongson's hardware supports both TRNG and PRNG simultaneously.
>>
>> We can locate a reseed function within loongson-rng.c, which clearly
>> indicates that it is a PRNG driver.
> That reseed function gets called with entropy from the Linux RNG.  So,
> it seems it's really just a PRNG seeded from the Linux RNG.  What value
> does that provide over just using the Linux RNG directly?

Alternatively,the reseed function can serve  as a stirring mechanism, 
where the primary entropy comes from the internal hardware TRNG.

Or simply ignore the  entropy from the Linux RNG entirely, trigger a 
reseeding internal.


The driver merely forwards the seed to the firmware; how it is utilized 
and what kind of random numbers are returned are entirely determined by 
the firmware implementation.

>
>> So the core issue here is whether a PRNG driver can utilize the crypto
>> interface.
> If you're asking about crypto_rng, it can.  But the crypto_rng interface
> is also kind of useless.  If you're asking about hwrng, it does look
> like it's designed for TRNGs.  Would it be possible for this driver to
> use the TRNG mode?

I mean crypto_rng.

We might use the hwrng interface to add support for the TRNG in this driver.

>
>> If it cannot, does that imply the drivers listed below serve no practical
>> purpose? (7.1-rc1)
>>
>> loongson@loongson:~/upstream/linux/drivers/crypto$ grep crypto_register_rng
> Most of the drivers in drivers/crypto/ are added by the hardware
> manufacturer without any regard for whether they're useful or not.

If we are dropping crypto-rng drivers entirely,

I am fine with removing the Loongson driver along with the others.

However, targeting the Loongson driver alone is unacceptable.


Thanks,

Qunqin.

>
> - Eric

