Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E882288EE
	for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 11:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750763320; cv=none; b=I/asIdi5YSUy/bxW+Xecvnc32T0cSN27Msfbb4Tb7eN74cQJv3t6CtEcND2F7hLHeDrCuOHmMtFGUaporvaxtBo0v248rBxqpRjU/aQOPR6Q+G28H8/0uWYOa3Vfr322QGZXUWWzUlAQ9oXGRiPhnJYutUOUrjwd3e+TEUCNbUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750763320; c=relaxed/simple;
	bh=lmyfNpv6vKhbMybNScDzLNfNZs3hNfzyiaK0ui+j1Jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s58CXny/U9b7kFGzLTYlQrfNEqkHPi/x1bXkNSsJ2ZFo7Li+6UH+BZCap1UOMo+JCn9OxwcW+9cX6+dEfJVR3kG4+oKTXBdvh4AtcvJw1rbMCJyTpWYaBThlfaB8lxo+25z0O5YzliEigeU3Dwd6mfy2wr7ylkpUmHpcglBYkvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=WiKanHPD; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="WiKanHPD"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-32b50f357ecso43422271fa.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 04:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1750763317; x=1751368117; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ivy1EjkVwPLS1G0ny1Hn6BgOuucNPs/UtRGt2ZEu/Us=;
        b=WiKanHPD+PVbREB5Tf9kpVlpGoiuU74pQlA0Z/4oWdw64OoDQ9D8F/QOmp8A+5cQH7
         E2/eQlEFf/RoiP7G1GgFTIINZk4IPyCrQM+xuPXCGDIdxD9UirHGqQ71H5AKWly/SDs4
         4pYqlpYc4Gm4qIlsAQNJWkrugVvv9s+0MFSnUHpJGhS1kIdJ0F1JtmiWeP69QIdQn+vq
         HNSkvzTaFyrF0VBlm8oAoYIOOelbYUCKQAV+6apxDM9cKOCmTE/khHoAFnfyXwGXQCid
         c/Oe4ln00N+9upVfH8u5D4vyx/Zx7mq60DNrip7TbBkX5WzaF07uBKmQFOBxFqmWrCg1
         StXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750763317; x=1751368117;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ivy1EjkVwPLS1G0ny1Hn6BgOuucNPs/UtRGt2ZEu/Us=;
        b=cYMSzlcBEgWgGWWboFqjkCd8Plhl7M4zppvlCv2ouR1GEBbHmOpxjcYksr9cf5ORtv
         3XrOUwAIfKh3lSlXJDIInhUDWgwKA3SiL3p4BEQuSQEWQ1o5FD6MdfbLGZ+iQ8c+UbLu
         0jNugiwj0b1eJ35P1I+MHO02U7if8DbG0z4Q5bL23yvd+lR0BAlzdZo3qgyjp6oR0cW8
         GJkejwsRRDdqcxZ1J9qtC/HHCiaVyLDDnLV2CMS8Is6VJHpZSoJhm7spqQSC7QFzmnhq
         LK+sRjT/EOXLhLE4e1j3Wd1kpGyGcQstKTGXN7s/Krp6VADl3ieil17M05MQWEUmaU3R
         DRtw==
X-Gm-Message-State: AOJu0Yx2H5HYwNWH7E9YS3TmONU04BUFuUQVBQOvscDGfQlCZssJ49mE
	B9IHw5yObkPf8gFC0P5zxEr+8gSLHfSX9IohP6g9JekahH8mA/3lYLjF7AGLPNwJojEfBADtAeA
	/K8w8
X-Gm-Gg: ASbGncuSjvXVDweWnihpIBh7CgEQPwOPVmiAgM47nXkEVYNH9YLvXWM/GlTUAw96NzT
	gOiAUBrccLdTsZIYyGBAcVvcSMrtV8H2I26TCNoUCW4KVoSfpSEu6a8lo1D+gd3BeHwH89gZba8
	PE3jsWFFWXHMFs+pvKDzNm5qJD0eifIgB/H3YwN+76nXdZ46LtK6RrQDl9opJHPDNdtwj2YHooV
	yONmc2gcPqXuyKFDZPkCfYJCT37J8qFQpeTL+q3GaHDSPn2WKGxede4PWPwjSLEp7NlWLIs+aPg
	oJ/1zpXNlRkyoZK7Sk7ZRr+HnoNHMYXqVN7YadPvg7EvMoN7GS9w54U1Nn9/6e9XQQkjVz5vFKD
	sfM0itEoWmSLnDhrwS/OOC7mXQsN+Jg==
X-Google-Smtp-Source: AGHT+IFkaVfe9A5q4PCpQMJnAeMmaLJMc+uasJr+tOkMohX7Kkj/gdRv7dSPCWDdO6DpJMYWCcZcOQ==
X-Received: by 2002:a2e:ae11:0:b0:32b:7356:94d4 with SMTP id 38308e7fff4ca-32b994d9700mr32922951fa.41.1750763316774;
        Tue, 24 Jun 2025 04:08:36 -0700 (PDT)
Received: from [10.0.1.129] (c-92-32-242-43.bbcust.telenor.se. [92.32.242.43])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-32b97fd6e58sm16229431fa.50.2025.06.24.04.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 04:08:36 -0700 (PDT)
Message-ID: <c61d1163-df80-4cbb-af13-3fcab8f6b9dc@cryptogams.org>
Date: Tue, 24 Jun 2025 13:08:35 +0200
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
> 
> Is there any chance we can just make the RISC-V Poly1305 code be conditional on
> CONFIG_RISCV_EFFICIENT_UNALIGNED_ACCESS=y?  Or do people not actually use that?

For reference. The penalties for handling unaligned data as above on a 
processor that can handle unaligned load efficiently are arguably 
tolerable. For example on Spacemit X60 it's meager ~7%. However, since 
poly1305 is always used with chacha20 and is faster than chacha20 the 
difference would be "masked" and rendered marginal. If anything, it 
makes more sense to utilize this option for chacha20 where the 
difference is way more significant, a tad less than 20%.

Cheers.

