Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3407B292B27
	for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 09:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751015268; cv=none; b=SNq3naRJWCLvdYxR2/SwO4oLQdQSoypggq1rrVh4nT15obAI6ZSOtk00QX1B+YvbAL/tHM4a33PnOPDfnrMaeasLuiHjC7A7W8Do6sUkrYdJTuhL+qTUSUqzO/wTyI0w/cbc9sD/TITbvC+mk8XNFSzLfAG1HzFoRiix3e+OcnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751015268; c=relaxed/simple;
	bh=c2yoZC6/l6e1TokJLuOg/gxsdGFe4q39zE6LhEBb6wQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W380G6QEMa8OCEOhgJlJ7+IunSY05Xg8B7pJtLaq+Kdh8xeGFzFaD+hrbhnlwUB2FKl+H56leBLs3A4gS45zmJQUqdKwJMu66IHOgmEeIFuaNHtnczExPicCYQOjaXVWLK4/WVgtpNOB56gLMe3NNO7UcScZMCeG6NBg+4BFApY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=TjXX5JES; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="TjXX5JES"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-553d52cb80dso2191318e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 02:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1751015264; x=1751620064; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mwTaehLi++D3BP/Qfp0PX6Y8cfOYLLnC6EYX5G+DxBw=;
        b=TjXX5JES7cM7k7uQ2o76IWb0lgmt3v/4flqJ58nUaY+D6YIbReX8AAjj+bdkpZqplB
         ZQTJ+YrZoWaJDApFtPxdImP1rDMnQq3DnyOhqyahv5LfHQyXwTQMHGEjgwWMMhNXQ01+
         bSfHaojhaiePsqCkobOWNIJNIDRqE9LGSxeF/ZbVPKzPjPWykkyfc+HbRzjECkCHnxMO
         KacjTpWbWqq16oidaLmLXhHm4P0KireqNuKVS/xDdhjKwEFJe/bx0Aa6yfRErbVtyi/g
         /wAjLU3g5e5l+V1qIvtFDsqjgkln9NXBYfWkCNzMmCpnYhpuybNWv9/KIph0XXSBeozR
         j75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751015264; x=1751620064;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mwTaehLi++D3BP/Qfp0PX6Y8cfOYLLnC6EYX5G+DxBw=;
        b=p2p+5jhsoC2sZ9sZ/l9unxaWpoGEL3rjeyp1g8USYpG6ktljoCzOHUmEbF9cdh1wFs
         FntHFunchMaSHg0icOe6pIb9Q4mpW65MXL8LMtdHv/N25Mr7NWUY3EtWh978GkCVrS1K
         Saw1JD4IHH/PALSQdojXiJkthXdWmVa5V+Rup1DX9Y0Dr+QFZpQ4dgXqYzL09qlmP6Aa
         uwaEJ9CcgnEOjNLS3p9/wdxGEPxKsFDqicOj8tHXGlv+Ql6O6jeZBTHkVwvLnPNp39Gj
         K6vr/GApm1HE9xyCrhidoI6zWL7DeckqVe2GQktsVFyP/pq2WeLLeYFwx5QsW1Cpagfk
         zwXw==
X-Forwarded-Encrypted: i=1; AJvYcCUc4Ys+gLQszkDjX3ncYhjM4ZeSS/HleVzswrAhjcq8BtoX0wagXDK2xl2Epx4ag8Nn905rRPRP9qyAwHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YycgQVex8Sz1bqqQfTsQmwczAI+BaHCy3rlzPvjhI7BgYbNmvKl
	9dhzTXOP+vM0AhuibuECiuykqx4S1JVEJh0g3L66xJrLbvRCgiR+TZXIi0qtYLdaLvo=
X-Gm-Gg: ASbGnctNZQCxY/z+NFxkohnuT4CYT/pICKre3QRE+RpeQJFbQvHlbraodEGb1feVVfO
	+3pdSl+qXhBxU61Z6oQ3MibSwwKK0WvLxjhTLHO7qIpVd7ka13mqauaB7Hk8r0zOg31pOYvxyWF
	CHlhqvIXywpbR+Yhxv8RgUic2vLi1zFt9SIAQXNHvt6OgAEmd5ePayKgZXfwYOPzxh2ABXCVxXc
	2IeCsxMbUyBU3++tKJtYGK73pHxu4YlSw3vOWU/IRy4CNFIsCWCZsckXdWdGI+waFUqBn6Fhavm
	NJOqfbbkXwqTNSGNeGvWVWe4Yrt+FfGOflq8sYwgnNOAJlqjO3aWyvdQW2oiNuak62xDHnMwaKr
	jJn1zZOVQIwhDDQ8Na0PlGejAcTPNdA==
X-Google-Smtp-Source: AGHT+IEN/vImgHyT08WNJquuCoqBqWoXcpPN6YcsofZ82MFo/mUqptPZeTPp1FYUrQXumaxV8Lg7Fw==
X-Received: by 2002:a05:6512:2395:b0:554:f82f:181a with SMTP id 2adb3069b0e04-5550c2bfa3amr615791e87.2.1751015263987;
        Fri, 27 Jun 2025 02:07:43 -0700 (PDT)
Received: from [10.0.1.129] (c-92-32-242-43.bbcust.telenor.se. [92.32.242.43])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5550b2b8fadsm364392e87.103.2025.06.27.02.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jun 2025 02:07:43 -0700 (PDT)
Message-ID: <fa13aa9c-fd72-4aa3-98bc-becaf68a5469@cryptogams.org>
Date: Fri, 27 Jun 2025 11:07:42 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
To: Sami Tolvanen <samitolvanen@google.com>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Zhihang Shao <zhihang.shao.iscas@gmail.com>,
 linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
 herbert@gondor.apana.org.au, paul.walmsley@sifive.com, alex@ghiti.fr,
 zhang.lyra@gmail.com
References: <20250611033150.396172-2-zhihang.shao.iscas@gmail.com>
 <20250624035057.GD7127@sol>
 <48de9a74-58e8-49c2-8d8a-fa9c71bf0092@cryptogams.org>
 <20250625035446.GC8962@sol>
 <CABCJKudbdWThfL71L-ccCpCeVZBW7Yhf3JXo9FvaPboRVaXOyg@mail.gmail.com>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <CABCJKudbdWThfL71L-ccCpCeVZBW7Yhf3JXo9FvaPboRVaXOyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>>>> +.globl   poly1305_init
>>>>> +.type    poly1305_init,\@function
>>>>> +poly1305_init:
>>>>> +#ifdef   __riscv_zicfilp
>>>>> + lpad    0
>>>>> +#endif
>>>>
>>>> But they appear to be unnecessary.
>>>
>>> They are better be there if Control Flow Integrity is on. It's the same deal
>>> as with endbranch instruction on Intel and hint #34 on ARM. It's possible
>>> that the kernel never engages CFI for itself, in which case all the
>>> mentioned instructions are executed as nop-s. But note that here they are
>>> compiled conditionally, so that if you don't compile the kernel with
>>> -march=..._zicfilp_..., then they won't be there.
>>
>> There appears to be no kernel-mode support for Zicfilp yet.  This would be the
>> very first occurrence of the lpad instruction in the kernel source.
> 
> Of course, if the kernel actually ends up calling these functions
> indirectly at some point, lpad alone isn't sufficient,

The exception condition is specified as "tag != x7 *and* tag != 0." In 
other words lpad 0 provides a coarse-grained, but a protection 
nevertheless. As effective as the endbranch on Intel. Since a 
"fit-multiple-use-cases" assembly module, such as cryptogams' ones, 
can't make specific assumptions about the caller, lpad 0 is a working 
fall-back.

> we would need
> to use SYM_TYPED_FUNC_START to emit CFI type information for them.

I'm confused. My understanding is that SYM_TYPED_FUNC_START is about 
clang -fsanitize=kcfi, which is a different mechanism. Well, you might 
be referring to future developments...

> Also, if the kernel decides to use type-based landing pad labels for
> finer-grained CFI, "lpad 0" isn't going to work anyway.

It would, it simply won't be fine-graned.

> Perhaps it
> would make sense to just drop the lpad instruction in kernel builds
> for now to avoid confusion?

Let's say I go for

#ifdef __KERNEL__
SYM_TYPED_FUNC_START(poly1305_init, ...)
#else
.globl	poly1305_init
.type	poly1305_init,\@function
poly1305_init:
# ifdef	__riscv_zicfilp
	lpad	0
# endif
#endif

Would it be sufficient to #include <linux/cfi_types.h>?

Cheers.

