Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E452AE72
	for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 09:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750844306; cv=none; b=jKmDFfpbABjzQo7EQJGOsmLFErlIFerGS5Hb+n2nuErNgt9duWmvpK8vxTSrrCHlFsC0s0LgIv0PVg8evXs9/kEasX5Jbe+jvnBE6isqbt040QfiZPbJjOfwbHr0nFvRxR+YDwzuH1FIvsIkO4LXiAaiQFO8Yik9ftiHIDNXCpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750844306; c=relaxed/simple;
	bh=jdOb14OSPUYa68p0Um5LF0FSPFO5uqq9o+vRR3XEL30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tVDuEBLiSDFjThyfb8BR4jCXQb/YsRRY29/sMyHBJ0KWqMQbbehNG6I+7bQf3sKwDLZ3IKoAPGlDtiVyE7WZU2oYGT+ABAXZEINQgHW2SE5tbGNJTBhfsfEMut+Vt077/yEXbhZ7bdeXamh+HhhWg5mMglR0wLwrH3wj1bqUTLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=VzrLmpIY; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="VzrLmpIY"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-553e5df44f8so4832310e87.3
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 02:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1750844302; x=1751449102; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K2bjFrjj2eMqiTRqSA0mu7oTkOAFVTQZyOnAVudgErE=;
        b=VzrLmpIYOBjDeWdRDnw6PW5QzYzkP6D39EZ+48eWV28PmgiioDsxhx+zEjsU14AR9B
         NAGEncD2CuJXUcQVZYrIHnpNAy0TEtKaQHUaF429Y0JLXXC50CrtpFNj47p4NvKEho/9
         BinQDcj6019AbS11iAvrQ86jen4gjYAy5mII4kfbXHpSz//H2Z4TsEys6jXYkFS6BkEq
         Qz7pO+7lc3qm0cqrdMNT441sOYsXnZ37+AHJ1HgnTcoi3fY4/ojlXUL1aItj9G6arBS3
         Cb7f2WLCC1Gamp3NtxaXAHFDoPIZHrpxJGyIv/OWQAcJTiRS7rF21/RInaMIgeuKstFv
         zaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750844302; x=1751449102;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K2bjFrjj2eMqiTRqSA0mu7oTkOAFVTQZyOnAVudgErE=;
        b=VXlxoNgKl0NunK8r3oLMu5Z1MHcYccV/WqBHOewwDUYYh6DD9tstmz4eGS3E1dsTk3
         BTjmterLVxbDu4GwOit+OzFZFJx41Aabh74QUXHHRgrzWMotfOXCUbfzh8HmNQuZgEJo
         5ptCZAfSo6GqooW+2+9meskI+5D5P2HKIZkqJtjGWx/LbQo4NmPYi4uFzHA46exu5fUD
         ljW7HonULia3CD9L63DiRU4LZf8AIeNHUDdQQTiqjsFQoFVpHY0yha+/v7QRianM48mT
         SnK1S71nEvA3ipH8A9dMFwTemJOz3W+H7xKq5TKzW6R/O3eMLx4LBB/6ecFn8rCa2mLR
         324A==
X-Forwarded-Encrypted: i=1; AJvYcCWNjbGUpk/Zmlrz3HqAzxzkbK+zfSGe/JBwpu1kstpEM+KCrcIrozn2YJmeXP2J3I314H4fqJHSK6Rnm3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi8BtDte2FYgkfkgasP0HzK3RiOFONubeZJpkvXQC53hqKE/OA
	PSV0SUj7U2lUxfC+IZ+oI1ElG6JyP8dRLexRM+LZDAJglf7lOQW/gc/rtNSPiBAP0nh1JF+VyPm
	tiQfb
X-Gm-Gg: ASbGncuWrD5s5MOgX+P4b07YqytRB7QOYq8aSrI4z/3rFimkJeMNpZMVueUNAxv5pAU
	0wcs7b+f8JB7DpH8Uwbm0vtrfDU2I2bN7ZJax7zaW0Ca2Eh4Q6OD8bWubm/GopNrdGD7HTxAcYL
	L78o31hS/7wPAEmU2geEzm/s54XZ4pcsjaZ94QoAmiLLPLJY7Vbo6r398nHg9Dvqf7t6a5Y0WlP
	YiZuY9he8E+nqVAq2iM7h2BOmu89lW38sqj8MO8xmkjkheW4fUK8YI/JbGBlJSzdEv8jT3YPV6r
	VoSaU+a3RuUKcTrekcGUgRf2Pxo/TgNpIP62p3SSXxqx6cTOpINmMkdu86spa0YaAnRPNnjvCJb
	WkMtbMhajNdMbeZc2qVU0dDd+uTFvkg==
X-Google-Smtp-Source: AGHT+IHIIeyvn8QfCduWJd5t2Oh9R8b98qsYEyBICh+DHmIf1GXxPxIHXDfOMOOH72H4d74hXDCEBg==
X-Received: by 2002:a05:6512:3e02:b0:553:2a16:24fd with SMTP id 2adb3069b0e04-554fde59eb1mr653330e87.47.1750844301899;
        Wed, 25 Jun 2025 02:38:21 -0700 (PDT)
Received: from [10.0.1.129] (c-92-32-242-43.bbcust.telenor.se. [92.32.242.43])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-553ea6132easm1752798e87.28.2025.06.25.02.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 02:38:21 -0700 (PDT)
Message-ID: <3c191e21-ce26-4903-8515-3e110560aa66@cryptogams.org>
Date: Wed, 25 Jun 2025 11:38:20 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
To: Eric Biggers <ebiggers@kernel.org>
Cc: Zhihang Shao <zhihang.shao.iscas@gmail.com>,
 linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
 herbert@gondor.apana.org.au, paul.walmsley@sifive.com, alex@ghiti.fr,
 zhang.lyra@gmail.com
References: <20250611033150.396172-2-zhihang.shao.iscas@gmail.com>
 <20250624035057.GD7127@sol>
 <48de9a74-58e8-49c2-8d8a-fa9c71bf0092@cryptogams.org>
 <20250625035446.GC8962@sol>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <20250625035446.GC8962@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>>> +#ifndef	__CHERI_PURE_CAPABILITY__
>>>> +	andi	$tmp0,$inp,7		# $inp % 8
>>>> +	andi	$inp,$inp,-8		# align $inp
>>>> +	slli	$tmp0,$tmp0,3		# byte to bit offset
>>>> +#endif
>>>> +	ld	$in0,0($inp)
>>>> +	ld	$in1,8($inp)
>>>> +#ifndef	__CHERI_PURE_CAPABILITY__
>>>> +	beqz	$tmp0,.Laligned_key
>>>> +
>>>> +	ld	$tmp2,16($inp)
>>>> +	neg	$tmp1,$tmp0		# implicit &63 in sll
>>>> +	srl	$in0,$in0,$tmp0
>>>> +	sll	$tmp3,$in1,$tmp1
>>>> +	srl	$in1,$in1,$tmp0
>>>> +	sll	$tmp2,$tmp2,$tmp1
>>>> +	or	$in0,$in0,$tmp3
>>>> +	or	$in1,$in1,$tmp2
>>>> +
>>>> +.Laligned_key:
>>>
>>> This code is going through a lot of trouble to work on RISC-V CPUs that don't
>>> support efficient misaligned memory accesses.  That includes issuing loads of
>>> memory outside the bounds of the given buffer, which is questionable (even if
>>> it's guaranteed to not cross a page boundary).
>>
>> It's indeed guaranteed to not cross a page *nor* even cache-line boundaries.
>> Hence they can't trigger any externally observed side effects the
>> corresponding unaligned loads won't. What is the concern otherwise? [Do note
>> that the boundaries are not crossed on a boundary-enforcable CHERI platform
>> ;-)]
> 
> With this, we get:
> 
> - More complex code.

My rationale is as follows. It's beneficial to have this code to cover 
the whole spectrum of processor implementations. I for one would even 
say it's important, because penalties on processors that can't handle 
misaligned access efficiently are just too high to ignore. Now, it's 
possible to bypass it with #ifdef-s (as done for CHERI), but to make 
things less confusing, a.k.a. *less* complex, it's preferred to rely on 
the compiler predefines (as done for CHERI). Later compiler versions 
introduced apparently suitable predefines for this, 
__riscv_misaligned_slow/fast/avoid. However, as of the moment of this 
writing the macros in question don't seem to depend on the -mcpu 
parameter. But it's probably reasonable to assume that they will at a 
later point. So the suggestion would be to use these. Does it sound 
reasonable? Or would you insist on a custom macro that would need to be 
set depending on CONFIG_RISCV_EFFICIENT_UNALIGNED_ACCESS?

> - Slower on CPUs that do support efficient misaligned accesses.

With arguably marginal penalty, as discussed in the previous message. In 
the context one can also view it as a trade-off between a small penalty 
and increased #ifdef spaghetti :-)

> - The buffer underflows and overflows could cause problems with future CPU
>    behavior.  (Did you consider the palette memory extension, for example?)

Pallette memory extension colours fixed-size, hence accordingly aligned, 
blocks. Since the block size is larger than the word load size, any 
aligned load would be safe, because even a single "excess" or "short" 
byte would colour the whole block accordingly.

Just in case to be clear. The argument is about loads. Misaligned stores 
is naturally different matter and it would be inappropriate to handle 
them in the similar manner.

> That being said, if there will continue to be many RISC-V CPUs that don't
> support efficient misaligned accesses, then we effectively need to do this
> anyway.  I hoped that things might be developing along the lines of ARM, where
> eventually misaligned accesses started being supported uniformly.  But perhaps
> RISC-V is still in the process of learning that lesson.

One has to recognize that it can also be a matter of cost. I mean 
imagine you want to license the least expensive IP from SiFive, or have 
very limited space for MCU. Well, Linux, naturally having higher minimum 
requirements, doesn't have to care about these, but it doesn't mean that 
nobody would :-)

>>> The rest of the kernel's RISC-V crypto code, which is based on the vector
>>> extension, just assumes that efficient misaligned memory accesses are supported.
>>
>> Was it tested on real hardware though? I wonder what hardware is out there
>> that supports the vector crypto extensions?
> 
> If I remember correctly, SiFive tested it on their hardware.

Cool! The question was rather "how did it do performance-wise in the 
context of this discussion," but never mind. Thanks! In a way there is a 
contradiction. RISC-V as a concept is about openness to everybody, while 
SiFive is naturally about itself ;-)

Cheers.


