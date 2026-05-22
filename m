Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792E032E151;
	Fri, 22 May 2026 03:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779421586; cv=none; b=ujYUOCfzgaTkjeZz/4I1jW11/Gkzii/+xRXqoP9rxF4iILelrETrq5p9tlcZY8y8EIvz54MaUru2vjc3+LU9QXcR9ujjTIiOWAeyZT50pq+i/jMj7MdoBOKmCY3493jHxEFBmdMXZZ/6Xg1vTrkSHHFHLuQUq0EA50wJC0ZquX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779421586; c=relaxed/simple;
	bh=M0XmnJv53KNUcwwsi7tWGFt+AcUS34x3Doz/+8739w0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RE6P4ZZra5oT/Xa3VlBQrt0Sll3Bh04yymgSd9lKJA/TdBPOnXRZIT1BG/OSWKwnqlZaDF9mcTybDh9TOvAv6xzlM+TN00nVVQdN/BOv/AOC/XEj8C07a1IvxjwkzgFCHQsYcqLyUuRw4oIWY7+3ezdcz3ouXqvqCZlJSVFWnGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.164])
	by gateway (Coremail) with SMTP id _____8AxX+uI0Q9qNUMMAA--.35516S3;
	Fri, 22 May 2026 11:46:16 +0800 (CST)
Received: from [10.20.42.164] (unknown [10.20.42.164])
	by front1 (Coremail) with SMTP id qMiowJBxrsKB0Q9qvjyMAA--.62394S2;
	Fri, 22 May 2026 11:46:11 +0800 (CST)
Subject: Re: [PATCH] crypto: loongson - Select CRYPTO_RNG
To: Eric Biggers <ebiggers@kernel.org>, Huacai Chen <chenhuacai@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 Yinggang Gu <guyinggang@loongson.cn>, Lee Jones <lee@kernel.org>,
 kernel test robot <lkp@intel.com>, stable@vger.kernel.org
References: <20260522022525.12976-1-ebiggers@kernel.org>
 <CAAhV-H5cDnWKxBobwRErRyvG8671e6VXsBe6w1RkX9rfn7CVFA@mail.gmail.com>
 <20260522025722.GD5937@quark>
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
Message-ID: <d71adfa1-8895-e741-b72f-c5e99d5fb9e6@loongson.cn>
Date: Fri, 22 May 2026 11:41:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260522025722.GD5937@quark>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJBxrsKB0Q9qvjyMAA--.62394S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWrKF13CrW8AF4ktryxJw1rKrX_yoW8Jry3pa
	y3G3WUCFs8GrWfCanFg3Wxuas0kws3ZrW3KFWUC34Yvrs0vr1UXr1IgFZxWa4qyryFkrW7
	Kr98t3yY9a4UCacCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_
	JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
	xVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU2MKZDUUUU


在 2026/5/22 上午10:57, Eric Biggers 写道:
> On Fri, May 22, 2026 at 10:52:42AM +0800, Huacai Chen wrote:
>> On Fri, May 22, 2026 at 10:26 AM Eric Biggers <ebiggers@kernel.org> wrote:
>>> This driver registers a rng_alg, so it requires CRYPTO_RNG.
>>>
>>> Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support")
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Closes: https://lore.kernel.org/oe-kbuild-all/202605201622.qWOiiZTV-lkp@intel.com/
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>> Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
>>> ---
>>>   drivers/crypto/loongson/Kconfig | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
> By the way, do any of the loongson people have any comment on what they
> think the point of this driver is?  It's not registered with the actual

To provide an AF_ALG-based random number generation interface for other 
modules and user-space programs.

Thanks,

Qunqin

> hwrng subsystem, but rather the pointless crypto_rng system which no one
> uses.  So if it was intended to provide entropy for /dev/urandom etc.,
> that isn't what it's doing.

>
> Can we just delete this driver?
>
> - Eric

