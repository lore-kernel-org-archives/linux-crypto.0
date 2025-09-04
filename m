Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C4227F18F
	for <linux-crypto@vger.kernel.org>; Thu,  4 Sep 2025 20:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757017376; cv=none; b=poioyV4LrainDwDpH0kV9KGwSm4c2klDg0fPuk9WVyxbgLutWqVEAHCOWQlL6P0BR67ZZkqbioYLTbyuDTHTVr7zLH9vlFXwVHvkSMgM1Zp+f9Y9b+fMl6HwOtbvQXILEeSbE35YMmeEnhA0biF8JjSdQZwCVEFNhyrXui7ltT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757017376; c=relaxed/simple;
	bh=pOSe9LCUGXl4HpI1pu1/gQtGF+5rfV27KrUR5t1T8RE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c3R9ZJm6q8CCVDIB18Ymd4jTZF9jD73qXeCyyZzD/xObNeahXqiCRiHQsrL1ExJZKAkiWYMriv0ZIfoTf2XspZwOLx6Sqcq6azitS9TrwEcssKipWPxqbjN4DrNLdkrIqkB68oNrGPiWcE2S+YUfmWi/gCkbPKIeewn6d5x2YvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D1sIot58; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D1sIot58"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61a8c134533so2573346a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Sep 2025 13:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757017372; x=1757622172; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EFjbiB4m/eIhgkbRs/v135oy1P6+1az87mWyaXYnAmg=;
        b=D1sIot58XQ031mTgRCPm+Ic98putP0IabQZcY+oQW0XsiKTMYl3cq+TeRKnPD9TsQP
         y8DCUSFqpByFRmXJQfxH5+tBGhwfcnAvm286zIrran6O0VUGHa1l1PIluvvA2r+Ca2uZ
         sN/oei58AIGjwpO5nbccmAjs4RzoUIR8euyts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757017372; x=1757622172;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EFjbiB4m/eIhgkbRs/v135oy1P6+1az87mWyaXYnAmg=;
        b=HEy2lDBXQtOu/F8eTclqKDWufym6JtFk4mAhvhVqpqABBiyb93lpoxKjxFGntMyNI7
         wNj1SqhgTpHeZcM6t6Rv4iZxBtI043ZishP0GSNZpgWI/VacuKNXrzdaUiF8L2bDCaPD
         7J6mOAXEq3GMQPyXM/FWxrlULqDJ/DizuriDRGlxrN+YEsyc5bsnsJOT7P/0gTpppZ6T
         HO1K0CGtZrI/Wrd2bPEpKQQNFt+YCIUYx+onKL2g1vtazaYYTM3aZxoL49CQdIQYfmcx
         cSi3W9/OeiGsDOaUSAxoYeOmOSBaHxumimEXi/pgM/LdPWk/eLvH3gJyelQDTvBFmGNk
         99lA==
X-Forwarded-Encrypted: i=1; AJvYcCWIe+wwGs9PDwYnL60w8Pu72ftTADx020JmbUP/ZHYyM+FC/PiQe3i8pah4LK166HaE/pS+OdW9H60tk3c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeT35Ysg5S19hSKLfJ6fGIk+H9SfIbTujbrfqn+yrGw/XIbNc2
	Bd4+aN/yhPYPTK1J5mPhbdbiSkCW5ZfMDJC7TmAeD6EDlKw+tzSNz79o+4baoLYKJGcLMO3gz1b
	1XaBVWeA=
X-Gm-Gg: ASbGncvH699vWibmMZNRgyWtlCkRno3xhxTP0bAtWnT88SnGa+Zgko4zMei11xC3RCG
	WIuU08i5KyIYmElNRkWIM8RhlEmB/rKuz7z5vDkTP80V0gjm2P1tGQxk5mBx57DiCLi4Bni7uS1
	uD511w6GmWQNo6U7Spa5ViT0PuksPfB5IuyQOFjdqhpvzqnSRy5M+eAljwYxEzS+4aPwtDq2kMX
	CHWuARNJLnNAA1CgmBwkGMKF+Jp101qMUIVElWsTs5JwgzQ26NvVbGtRf8XjUjVE5RLP6jwhK87
	HSKup5v0c8BqAS8V948H5QxQ8750vyfocAilJSCXY5tP6wpmLVMR1s0eDdPboqXcbAA5loj2gE6
	HVHmQ3LoblZcdzbQxO0DbJiAoH+DCIeEn/jdI1hVrG7rqSteDD6cY2VV2/FYgtHQhjSb/YWJ1
X-Google-Smtp-Source: AGHT+IEb+eHK7XijzEynU8835ML/0mYxWxGxt+EH0Bx6MLzivYZohDtglnDyAyojGy6ADwhapUlkgA==
X-Received: by 2002:a05:6402:50d4:b0:61d:1d36:a7d5 with SMTP id 4fb4d7f45d1cf-61d26fd0b47mr18846242a12.19.1757017371936;
        Thu, 04 Sep 2025 13:22:51 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc1c7848sm15623881a12.2.2025.09.04.13.22.49
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 13:22:49 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b047f28a83dso201732966b.2
        for <linux-crypto@vger.kernel.org>; Thu, 04 Sep 2025 13:22:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWdw0GhKfCq1XaFrxYGwH6fYueUzbFeud6/nnd/EoBabjQyafODN0DJgJQZB8HqvXaSmBvFbPV2dqnKBjQ=@vger.kernel.org
X-Received: by 2002:a17:907:2da8:b0:b04:23e0:5c0a with SMTP id
 a640c23a62f3a-b0423e07281mr1768814666b.20.1757017369118; Thu, 04 Sep 2025
 13:22:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904155216.460962-1-vegard.nossum@oracle.com> <20250904155216.460962-7-vegard.nossum@oracle.com>
In-Reply-To: <20250904155216.460962-7-vegard.nossum@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Sep 2025 13:22:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wizcBV_yos1SZW9Zty7960TCeEE1t2qE_Wmm8CMoim60Q@mail.gmail.com>
X-Gm-Features: Ac12FXxMTxemNqEb5J5AwGTntJrW-uSyt3_5duZoquFOFuM4JPaOvQtYu2LKoHk
Message-ID: <CAHk-=wizcBV_yos1SZW9Zty7960TCeEE1t2qE_Wmm8CMoim60Q@mail.gmail.com>
Subject: Re: [PATCH RFC 006/104] KEYS: trusted: eat -ENOENT from the crypto API
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>, Vladis Dronov <vdronov@redhat.com>, 
	Stephan Mueller <smueller@chronox.de>, Sami Tolvanen <samitolvanen@google.com>, 
	linux-modules@vger.kernel.org, Vijaykumar Hegde <vijaykumar.hegde@oracle.com>, 
	Sriharsha Yadagudde <sriharsha.devdas@oracle.com>, Sumit Garg <sumit.garg@linaro.org>, 
	Jarkko Sakkinen <jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Sept 2025 at 13:05, Vegard Nossum <vegard.nossum@oracle.com> wrote:
>
> However, since commit 9d50a25eeb05c ("crypto: testmgr - desupport SHA-1
> for FIPS 140") when booting with fips=1, the SHA-1 algorithm (or anything
> that uses it, like HMAC-SHA-1) will be unavailable.
>
> security/keys/trusted-keys/trusted_tpm1.c is hard-coded to use SHA-1 and
> will fail with -ENOENT when attempting to initialize the hash instance
> using the crypto API _if_ the hardware is available. This in turn causes
> the entire trusted.ko to fail to load.

Oh Christ.

Can we please just make that trusted_tpm1.c code use the sha1 library
code directly instead of going through the crypto layer to get it?
That would presumably neatly avoid the whole issue.

Eric - I haven't looked at how painful it is to just do conversions
like that - I assume it's a boilerplate thing and trivial to do if
you've one one. Please?

             Linus
