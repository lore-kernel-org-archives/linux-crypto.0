Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7531DF756
	for <linux-crypto@vger.kernel.org>; Wed, 23 Jul 2025 09:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753264080; cv=none; b=GqU8i1eM/6uDCxTqIwb/zQ8LfZwteNVdRaLRkUvF0FQ2S0+nDTN3BNfeP5c/xNEyfkYukRnkp4e26wRtQq9/KmCAwUnUIr1o2b5SlvHwxf8wB/3jYAl9M3mCK6j2GD7Ofr1AylxcCO4a1L7+lzDypy2IE/fn2JvVY6WrUVgn63c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753264080; c=relaxed/simple;
	bh=j4AS4XakoVI92B2kUF0qBpsNqIEG5VlYleby3CzZWWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTjcMYL4ay8ys+6F2oLW7LUE5Q3AapDJAEh02OYsA3heRWSwy5SdBhbRgMV95MxRcal5b4Rv58oT7VZAPn1DofnojkB9xh52bocCfLiPrInEnkku9wdNNPIoz239cDvgKvNsvRs298zIDx83sWvJWiZxKA7JGfoXXxNRl6ZkHRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=Ni80x8MR; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="Ni80x8MR"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-553e5df44f8so5871196e87.3
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jul 2025 02:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1753264077; x=1753868877; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/iHsnb+QFDGFQGoh/DAKzy9Zy3rl6+YGRpc9K7e/1bo=;
        b=Ni80x8MRdFGBdMp4HoKGt40WQITd35RoAhlifG3L8fRvOxq2njdtrB3y7DsLVhuSeL
         T/mQruWhzLTyno7s536rlzssGJLWj8tbs7ns+efm4qYxOKdJ39BePS1+ecSdynZCShGO
         mGFz1LuItai4c9NPZiwjwTUf9LRKxCefW5JNt/ulfxaH7g4FOE9D2OmucCC1yJgBwXRG
         NZiEa6sZ4m0zguhQdNINxdV/Gm2wC2h0wz3GaLgw3VmRP1pqg88NLqYlg/cvGVXg8L8i
         FKh6VuEpNUTlJhYhPK509SSrpEeTmp4zJW6hEllYnlsj1IaSmzR7fwZK6fhvdwyZmH4a
         hb2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753264077; x=1753868877;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/iHsnb+QFDGFQGoh/DAKzy9Zy3rl6+YGRpc9K7e/1bo=;
        b=MqI+G/roO/DD13REaTxmR35BJfdFr4ac5h3YhiZWZCNI+MjiKEjbrNBZetS7DtqOjH
         2Bq2gUMSTNRksPwxSqOQDKNGBLrgugDnEQH63oQxiJtYwSu2UlGIDL7Wq14YvAVWcV+G
         v7R75PPk+pTerOm2mQTdCEm4Lnxn3unCOrHyKEVqDUGR54uoxYYZ3BoFZHev6FwmkvR7
         d1w6k7rz0Rd8e2euNUEcGfopPrhwXt1MyxoQUa0hcQcKWWK/pTBBd1Csddn+iGG5DhwH
         DG6yg9cGJ9e8jkupLP9XVZCVCMaLPAuSw2diFJ0hXOc1OQCUQ6USL/9vdZtmGitt1/R2
         Xqfg==
X-Forwarded-Encrypted: i=1; AJvYcCUGI3MdBRAL7RU2f18q1ZUs6y7ECNzTOgI90zQ9fzv6JqXNWRTVpAILUmt/LzUDVBEetPLffyPVNyxMh70=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5yKGcCvCRA92/wg9fI/m3HSbuQrhnJYZthOFszBjfUWpLpcmO
	jinVpbhgaRyigahRSbPbPX356ApJqgfsH8ogI95gahk7ivfujDMB0p2kJwy531BinOZhNySUIl2
	7zOJE
X-Gm-Gg: ASbGnctPGzmu4q1Q27yoAUULpQNwAO8TH8SUUX9jFsG935rI+e9Mx5RtX16y0NyCGan
	zl2MY+UFmwyb3Xgz0zo7IH7QjxXtCnVsV4Z/TEtnEn/Jj0yc3HEODpCf6b0LXK9G6tWAaeyeC74
	kAT0vpRut7ZAjv+vmYx3o9aUiqyUgBnMHBuQ2L4ppCva8WN1itllkMR0DJDlbJitWPkDQZKRTHv
	3Ue5HgD4PP1waliEHY1RyJ1jobuB0uhPAiAlyIPucrEX6ANKS4bFCos87oMcj28RKGwI1vVndIz
	twcirIh+bVd490efK3DBfA0XVJuLUBk3dxkDB8s8FH77DjLljOK8QW6B71yF3BuijV5DIKt/LgO
	EUDNeu8ZUD9MGd3tmX4ibS177DOV7u9HIr0VEjy8utshsFeVGtEC0+9U/uFToz4JUow==
X-Google-Smtp-Source: AGHT+IFq48/8ENzanpaDeHxcIDxOJRvTnxQr9W0HfRdR24SiPdB2l8+HzzLMqoVluoTBHOfXgRfW2g==
X-Received: by 2002:ac2:4c54:0:b0:55a:4c3a:b11e with SMTP id 2adb3069b0e04-55a513ff603mr711109e87.30.1753264076401;
        Wed, 23 Jul 2025 02:47:56 -0700 (PDT)
Received: from [10.0.1.129] (c-92-32-247-84.bbcust.telenor.se. [92.32.247.84])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55a31d915c5sm2261332e87.157.2025.07.23.02.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 02:47:56 -0700 (PDT)
Message-ID: <bfb6c88c-4dce-4e52-81dd-a8b696e07aea@cryptogams.org>
Date: Wed, 23 Jul 2025 11:47:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>,
 Eric Biggers <ebiggers@kernel.org>
Cc: alex@ghiti.fr, herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
 linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
 zhang.lyra@gmail.com
References: <CACGDn=Rn079JhB7dwqbC-3GNiydJs=dGEXtcw+cC8z2Yjp2Qbg@mail.gmail.com>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <CACGDn=Rn079JhB7dwqbC-3GNiydJs=dGEXtcw+cC8z2Yjp2Qbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

> Next, I plan to validate this performance gain on actual RISC-V
> hardware.

I've rerun my benchmarks, the cycles-per-byte results quoted in the 
poly1305-riscv.pl commentary section, and it appears that my U74 results 
were off. I must have made wrong assumptions about clock frequency or I 
failed to note that the [shared] system was busy. Either way, U74 
delivers 1.8 cpb, be it the initial processor version or one with 
additional ISA capabilities such as Zbb, JH7100 vs. JH7110. For 
reference, the cpb is calculated by dividing the clock frequency by the 
measured MBps rate.

I also have vector implementation cooking. It's not ready to be 
released, because it doesn't yet scale with vlenb and works only on a 
256-bit vector unit. It achieves 1.3 cpb on Spacemit X60, 2.5x 
improvement over scalar code. Just in case, one can't expect the 
coefficient to be the same on other processors.

Cheers.

