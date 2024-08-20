Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6152E13FF6
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 02:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724119430; cv=none; b=R2wLUW3KnRAHDxQHMUBODhF09bsyS3xiyBfkHgceuYCHQ51D4ahn9uRi5mW5FPzn+wYPpDGDc0Wl9oAYMC/YP2pVsxCoXGaSmHfy2+eBW9Q3R4aWaedIAKXtVu2XWxyelnQiHFEwkRg4pLbzYDnrB09yt8uQhuzPU/ISNN86SWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724119430; c=relaxed/simple;
	bh=R4JmO1tXijq837S6eKNd1LWJUT/T5vCXtqilkLu+H/Q=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=SuiIgwwEhYecyK+S5jkaW5/9E9XGtLMuKd865XcubnAhQ5mbGnuUietQm1HTsHc6ZYLtg4BCO5OGx6Qd8W2/6eAQ7mjQugpPKtsqEas9pStyLaawQmUQDlZcErY/tuAQPZIC4JaHerUCAByzkEQEPiYuys6EbYzKUDunD2LMIvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [111.9.175.10])
	by gateway (Coremail) with SMTP id _____8BxXZuB+cNmGcQZAA--.30575S3;
	Tue, 20 Aug 2024 10:03:45 +0800 (CST)
Received: from [10.136.12.26] (unknown [111.9.175.10])
	by front1 (Coremail) with SMTP id qMiowMBxZOB++cNmLRYbAA--.54310S3;
	Tue, 20 Aug 2024 10:03:43 +0800 (CST)
Subject: Re: [PATCH v3 1/3] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
To: Xi Ruoyao <xry111@xry111.site>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org,
 loongarch@lists.linux.dev, Tiezhu Yang <yangtiezhu@loongson.cn>,
 Arnd Bergmann <arnd@arndb.de>
References: <20240816110717.10249-1-xry111@xry111.site>
 <20240816110717.10249-2-xry111@xry111.site>
 <CAAhV-H7TKg98QXtrv9UmzZd9O=pxERvzCsz83Y+m+kf0zbeCkA@mail.gmail.com>
 <ZsNClVFzfi3djXDz@zx2c4.com>
 <9d6850dd52989ad72238903187377cbaa59f7e62.camel@xry111.site>
 <a29807b5-d0ce-f04e-a7d1-024d29f398be@loongson.cn>
 <391b12b694855412985081df86c9dd48e2b020e0.camel@xry111.site>
From: Jinyang He <hejinyang@loongson.cn>
Message-ID: <bf8632f0-48c6-ffe2-1636-7f6ead3b82a5@loongson.cn>
Date: Tue, 20 Aug 2024 10:03:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <391b12b694855412985081df86c9dd48e2b020e0.camel@xry111.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowMBxZOB++cNmLRYbAA--.54310S3
X-CM-SenderInfo: pkhmx0p1dqwqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoW7WFWkJry5GFyDGFWxWr15GFX_yoW8XrWUpF
	WUKFWUKanrt3WxZr1Sywn8Wr90y34rGFyUXF15ta4UArn8tFnYgF4Syay5WrWkG348Grya
	vF4Iq343WFW5A3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Fb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AK
	xVWUtVW8ZwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2
	KfnxnUUI43ZEXa7IU8vApUUUUUU==

On 2024-08-20 09:09, Xi Ruoyao wrote:

> On Tue, 2024-08-20 at 08:50 +0800, Jinyang He wrote:
>> On 2024-08-19 23:36, Xi Ruoyao wrote:
>>
>>> On Mon, 2024-08-19 at 13:03 +0000, Jason A. Donenfeld wrote:
>>>>>> The compiler (GCC 14.2) calls memset() for initializing a "large" struct
>>>>>> in a cold path of the generic vDSO getrandom() code.  There seems no way
>>>>>> to prevent it from calling memset(), and it's a cold path so the
>>>>>> performance does not matter, so just provide a naive memset()
>>>>>> implementation for vDSO.
>>>>> Why x86 doesn't need to provide a naive memset()?
>>> I'm not sure.  Maybe it's because x86_64 has SSE2 enabled so by default
>>> the maximum buffer length to inline memset is larger.
>>>
>> I suspect the loongarch gcc has issue with -fno-builtin(-memset).
> No, -fno-builtin-memset just means don't convert memset to
> __builtin_memset, it does not mean "don't emit memset call," nor
> anything more than that.
>
> Even -ffreestanding is not guaranteed to turn off memset call generation
> because per the standard memset should be available even in a
> freestanding implementation.
>
> x86 has a -mmemset-strategy= option but it's really x86 specific.  As
> Jason pointed out, PowerPC and ARM64 have also hit the same issue.
>
I see. Thanks! The gcc produced __builtin_memset in expand pass.
X86 increase the maximum buffer length to inline memset by
`-mmemset-strategy=`, while other archs like LoongArch cannot do this.

