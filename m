Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D40E545
	for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 09:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750756434; cv=none; b=FCGc2uVYJz9l/qrCBxxGX6RygVK+697ToSueKT+nLxWkc1Q4piOdTy2Dx5vzIAN27SUgLdEVU8fWLdCC4Iscuvd+hJCxZB34XX2aPgzNN6fT3SVldcuI9EjHX2FZ7do3SZCgMjXAGspSGFta7IYiqPO+FkBd8H3Usywf+FquRYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750756434; c=relaxed/simple;
	bh=Fj9kA2DvjkJlCS5AZd024qRG+gPqQ4L5VFl1xQm8Wm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jHgI/Q2cZ8D2VBAaUk3MC1Suz5giJp6q4sOe4CyNJuA4CuMYTqWMItKtxuCrmplz3dy0QO5y4av4XQCxWjG+TIyAubExiB7Ow0RETNbjTN70YLYHdoOfXIec+Slj4vU0hSXbafJKxXD5BBF7JEmx/DBCmv60hocyRxID4Rvz4No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=mApsRHqh; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="mApsRHqh"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-553cf020383so175902e87.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 02:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1750756431; x=1751361231; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VeAtLCIzELtEqAtC7OfqanDtQsJ0MWYyoX2KXzWO0Js=;
        b=mApsRHqhiwoGxgn8mBEj1cFlQZg8Bll7tufs4vpnCFUezZY43hXn2GHTnn35F6rFUu
         q/KHttL70MTm6OKmdfuf5wmruCfYl5pHVFXs7RU57FAoC7u7JUTHRX74Q58zOsW1+PXI
         54Z9MVDNbF4moC9MELudY7aqJm/48sMq0wnZx6kDwQs4XX2GIRTUsdGEaO87O/J0511W
         BF3SJz4X0xB7Y6fTuHWXj8FkMK5WHk6lnFJLlbD5mcU6hhyzEgWmNOcOuMOwxBdFjuZ3
         PP4ulFPlobuNyDLK2C6Lfsr7S1Nodj/HhwZzF6Qd2YjrkLm1h1EVBGbwRJkqoRdY9Q82
         HEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750756431; x=1751361231;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VeAtLCIzELtEqAtC7OfqanDtQsJ0MWYyoX2KXzWO0Js=;
        b=RO6JkcqSw5zhErnBJF7FKTJ0mM/upFkGQICqVFVS9lBh2YDraEXHgOHFmbmFd64fFq
         RJyQeE66RrHQpADyFQ0UIF0ISjuqx4ysnKO3ttd3vP1nhPeOS6k9XhVPPdnj27LxzpSO
         aAV34X6/vk0CrPqMHY7ERvx0GscSvY6Jci7hJl2IQKHJbTzRqKHMzdS/Ob10y1gNZpWo
         35TUcNydrJH2HAYuH7b5qd2+GXn6zsEEWEeJ3vIsvtADi0h/UR13L2XQqPRu6gathT1O
         WSxLlJowuZ6OBfIbeYiHoxKH/hpSpVxofgcdsGTwqrKg3dtZ44M/jBA9lNYDJKA/qLL3
         T0OA==
X-Gm-Message-State: AOJu0Yy6aemQrvYvPKOABHn7P1LPMehUpRL15Ahfdncs43frVeSg+awJ
	JrzKfoRQyvjCVJOXZdSDFWZRfLrDwZRCoe095yTxUdI3e0eXXN2mOccBuUMaOk7+t6g=
X-Gm-Gg: ASbGncu1oa7MUS/vRuA3lEJL148QAyi2SxRgSy60eaVEYJU1HmGSSsD/+TeRIR3tePf
	s0ChgJ1uW+qwusiVlRsN2LbMBo4ywVn+WxFJxWh5uG2Xn+a4GsFkmR02IMWlm3ouk9i9iVHsTbi
	nL68lnGRwmlNqZlYUUruY/I5i8jwhsb4b9UpsyjYbIIMwv48BRbrU5lN1pCO4uoKIwvPg5s5WYv
	RqXyWukbivioB9uNy2lRg7qd8U7sjdsY8lprMZZHaUm2S0EHejeILYOV471sVJ9TzmJDUcjr62M
	jHoQS1qLZ+47i99aIsVJ8AQDtGNZBSK78D/cWDbR97NxwL+ML+VuyjBg9Ch3JB1kw2WaFOjwJYH
	lhSyOfH21v3H+bQdpuqyDdOxxf640hw==
X-Google-Smtp-Source: AGHT+IFaH46vGc8vI6X612n64uA9UbCTRBi9D9MK4NxdIERHjnEHGYL4HBCVvwI2kOhbR50is8W1kA==
X-Received: by 2002:a05:6512:4056:10b0:554:f9c5:6b3e with SMTP id 2adb3069b0e04-554f9c56d46mr208217e87.41.1750756430826;
        Tue, 24 Jun 2025 02:13:50 -0700 (PDT)
Received: from [10.0.1.129] (c-92-32-242-43.bbcust.telenor.se. [92.32.242.43])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-553e41bd232sm1729392e87.95.2025.06.24.02.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 02:13:50 -0700 (PDT)
Message-ID: <48de9a74-58e8-49c2-8d8a-fa9c71bf0092@cryptogams.org>
Date: Tue, 24 Jun 2025 11:13:49 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
To: Eric Biggers <ebiggers@kernel.org>,
 Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
 herbert@gondor.apana.org.au, paul.walmsley@sifive.com, alex@ghiti.fr,
 zhang.lyra@gmail.com
References: <20250611033150.396172-2-zhihang.shao.iscas@gmail.com>
 <20250624035057.GD7127@sol>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <20250624035057.GD7127@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> +.globl	poly1305_init
>> +.type	poly1305_init,\@function
>> +poly1305_init:
>> +#ifdef	__riscv_zicfilp
>> +	lpad	0
>> +#endif
> 
> The 'lpad' instructions aren't present in the upstream CRYPTOGAMS source.

They are.

> If they are necessary, this addition needs to be documented.
> 
> But they appear to be unnecessary.

They are better be there if Control Flow Integrity is on. It's the same 
deal as with endbranch instruction on Intel and hint #34 on ARM. It's 
possible that the kernel never engages CFI for itself, in which case all 
the mentioned instructions are executed as nop-s. But note that here 
they are compiled conditionally, so that if you don't compile the kernel 
with -march=..._zicfilp_..., then they won't be there.

>> +#ifndef	__CHERI_PURE_CAPABILITY__
>> +	andi	$tmp0,$inp,7		# $inp % 8
>> +	andi	$inp,$inp,-8		# align $inp
>> +	slli	$tmp0,$tmp0,3		# byte to bit offset
>> +#endif
>> +	ld	$in0,0($inp)
>> +	ld	$in1,8($inp)
>> +#ifndef	__CHERI_PURE_CAPABILITY__
>> +	beqz	$tmp0,.Laligned_key
>> +
>> +	ld	$tmp2,16($inp)
>> +	neg	$tmp1,$tmp0		# implicit &63 in sll
>> +	srl	$in0,$in0,$tmp0
>> +	sll	$tmp3,$in1,$tmp1
>> +	srl	$in1,$in1,$tmp0
>> +	sll	$tmp2,$tmp2,$tmp1
>> +	or	$in0,$in0,$tmp3
>> +	or	$in1,$in1,$tmp2
>> +
>> +.Laligned_key:
> 
> This code is going through a lot of trouble to work on RISC-V CPUs that don't
> support efficient misaligned memory accesses.  That includes issuing loads of
> memory outside the bounds of the given buffer, which is questionable (even if
> it's guaranteed to not cross a page boundary).

It's indeed guaranteed to not cross a page *nor* even cache-line 
boundaries. Hence they can't trigger any externally observed side 
effects the corresponding unaligned loads won't. What is the concern 
otherwise? [Do note that the boundaries are not crossed on a 
boundary-enforcable CHERI platform ;-)]

> The rest of the kernel's RISC-V crypto code, which is based on the vector
> extension, just assumes that efficient misaligned memory accesses are supported.

Was it tested on real hardware though? I wonder what hardware is out 
there that supports the vector crypto extensions?

> On a related topic, if this patch is accepted, the result will be inconsistent
> optimization of ChaCha vs. Poly1305, which are usually paired:

https://github.com/dot-asm/cryptogams/blob/master/riscv/chacha-riscv.pl

>      (1) ChaCha optimized with the RISC-V vector extension
>      (2) Poly1305 optimized with RISC-V scalar instructions
> 
> Surely a RISC-V vector extension optimized Poly1305 is going to be needed too?

I'm a "test-on-hardware" guy. I've got Spacemit X60, which has a working 
256-bit base vector implementation. I have a "teaser" Chacha vector 
implementation that currently performs *worse* than scalar one, more 
than twice worse. Working on improving it. For reference. One has to 
recognize that cryptographic algorithms customarily have short 
dependencies, which means that performance is dominated by instruction 
latencies. There might or might not be ways to match the scalar 
performance. Or course, even if it turns out to be impossible on this 
processor, it doesn't mean that it won't make sense to keep the vector 
implementation, because other processors might do better. In other 
words, it's coming...

> But with that being the case, will a RISC-V scalar optimized Poly1305 actually
> be worthwhile to add too?  Especially without optimized ChaCha alongside it?

Yes. Because vector implementations are inefficient on short inputs and 
having a compatible scalar fall-back for short inputs is more than 
appropriate. In other words starting with scalar implementations is a 
sensible and perfectly meaningful step.

Cheers.

