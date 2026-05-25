Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA49D29B20A;
	Mon, 25 May 2026 02:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779677436; cv=none; b=KyNGGOAtGDBmzMrfVBQi0GNyGyXDc3jnKBhVeF0lxV3B2Nw4XiecvSGVU1BN2DdTDwe6ULww7l7PLXmlusWtraQWMoQsvEkFQlzmeT5aUgopBgqFwrrxCbj1x7SJQsek5LV1GzP+pvUrD+x7+Kr0VSEKOGEXztjs9ks7k8Yu16g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779677436; c=relaxed/simple;
	bh=JpEh2ZN0k8eUxzXlir3g3RGyyjHAHoSuyF3ZoZrFcRg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qEl922kn/QjfLvte5zOw4454xwChYS1KleLbZSvajN/XEmBz2UZsV50sViip6hXhv9wdjh3NmA7TzsADa3Eg8AAOdxidjrAK6YuZfvJdE6AObru8EMnXd5XXuTTE2wFsraoFwDe19iMQaVK8haH1CKZPBZLdyyw3nor+yEGjiTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.164])
	by gateway (Coremail) with SMTP id _____8CxQ_DwuBNqmO0MAA--.37131S3;
	Mon, 25 May 2026 10:50:24 +0800 (CST)
Received: from [10.20.42.164] (unknown [10.20.42.164])
	by front1 (Coremail) with SMTP id qMiowJCxmuDguBNqm9ePAA--.62503S2;
	Mon, 25 May 2026 10:50:09 +0800 (CST)
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
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
Message-ID: <4501444d-9c17-8d4b-8bfd-bd1d69d77a76@loongson.cn>
Date: Mon, 25 May 2026 10:45:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260522174835.GA1894319@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJCxmuDguBNqm9ePAA--.62503S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxCw48Ar18Ar4rJF4UXryxZwc_yoWrWw15pF
	WrCa4UKFWUJr1F9ayktw1ruFyY9343Xw43Wrs3Ca4fAwn8tr10qr4IqFyq9FyDAr48ur1j
	vrW8trya93WDAagCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jOiSdUUUUU=


在 2026/5/23 上午1:48, Eric Biggers 写道:
> On Fri, May 22, 2026 at 02:40:38PM +0800, Qunqin Zhao wrote:
>> 在 2026/5/22 下午12:03, Eric Biggers 写道:
>>> On Fri, May 22, 2026 at 11:41:15AM +0800, Qunqin Zhao wrote:
>>>> 在 2026/5/22 上午10:57, Eric Biggers 写道:
>>>>> On Fri, May 22, 2026 at 10:52:42AM +0800, Huacai Chen wrote:
>>>>>> On Fri, May 22, 2026 at 10:26 AM Eric Biggers <ebiggers@kernel.org> wrote:
>>>>>>> This driver registers a rng_alg, so it requires CRYPTO_RNG.
>>>>>>>
>>>>>>> Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support")
>>>>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>>>>> Closes: https://lore.kernel.org/oe-kbuild-all/202605201622.qWOiiZTV-lkp@intel.com/
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>>>>>> Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
>>>>>>> ---
>>>>>>>     drivers/crypto/loongson/Kconfig | 1 +
>>>>>>>     1 file changed, 1 insertion(+)
>>>>>>>
>>>>> By the way, do any of the loongson people have any comment on what they
>>>>> think the point of this driver is?  It's not registered with the actual
>>>> To provide an AF_ALG-based random number generation interface for other
>>>> modules and user-space programs.
>>>>
>>>> Thanks,
>>>>
>>>> Qunqin
>>> AF_ALG is a userspace interface; it's not available for in-kernel use.
>>> If you mean using crypto_rng directly, note that no kernel code actually
>>> uses it other than the tests, the implementation of AF_ALG, and the
>>> FIPS-specific code which uses drbg.c specifically.
>>>
>>> So, the first half of your justification doesn't make any sense.
>>>
>>> As far as the second half: why would a userspace program do that instead
>>> of just using the regular Linux RNG (/dev/urandom)?
> Could you answer this question?  If there's no answer to this question,
> then there's no use case for this driver as-is.

While I'm not an expert on the specific application scenarios for these,

I believe any PRNG driver should utilize the crypto_rng subsystem.

>>> AFAIK, the only reason to use a HW RNG directly is for certification
>>> reasons.
>>>
>>> However, there's also already an interface for that: /dev/hw_random.
>>>
>>> So AF_ALG seems completely redundant for this case.
>> To be honest, I previously assumed that the `hw_random` was designed
>> strictly and exclusively for the TRNG mode.
>>
>> Is it architecturally acceptable or common practice for a PRNG mode to
>> utilize `hw_random` as well?
>>
>> Thanks,
> So the Loongson RNG is a PRNG?  Where does it get its entropy from, and
> what is its security strength?

Loongson's hardware supports both TRNG and PRNG simultaneously.

We can locate a reseed function within loongson-rng.c, which clearly 
indicates that it is a PRNG driver.


So the core issue here is whether a PRNG driver can utilize the crypto 
interface.

If it cannot, does that imply the drivers listed below serve no 
practical purpose? (7.1-rc1)

loongson@loongson:~/upstream/linux/drivers/crypto$ grep 
crypto_register_rng -r *
allwinner/sun8i-ss/sun8i-ss-core.c:            err = 
crypto_register_rng(&ss_algs[i].alg.rng);
allwinner/sun8i-ce/sun8i-ce-core.c:            err = 
crypto_register_rng(&ce_algs[i].alg.rng);
allwinner/sun4i-ss/sun4i-ss-core.c:            err = 
crypto_register_rng(&ss_algs[i].alg.rng);
amcc/crypto4xx_core.c:            rc = crypto_register_rng(&alg->alg.u.rng);
caam/caamprng.c:    ret = crypto_register_rng(&caam_prng_alg.rng);
exynos-rng.c:    ret = crypto_register_rng(&exynos_rng_alg);
hisilicon/trng/trng.c:        ret = crypto_register_rng(&hisi_trng_alg);
loongson/loongson-rng.c:        ret = 
crypto_register_rng(&loongson_rng_alg);
qcom-rng.c:    ret = crypto_register_rng(&qcom_rng_alg);
xilinx/xilinx-trng.c:    ret = crypto_register_rng(&xtrng_trng_alg);


Thanks,

Qunqin

>
> - Eric

