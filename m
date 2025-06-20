Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFD124678A
	for <linux-crypto@vger.kernel.org>; Fri, 20 Jun 2025 08:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750409575; cv=none; b=eLYGSDN1NNw+eGFCmHz0vCaFW2Rc3HwVmgD2MbXo++/ar9HKAVjS5Q09mPXGMznL3xi6UMBkti+4IJdA7RG8EDTVQqqWZb14DnYn2yfO2McxEfzC0VzY7tU8JcQ/26oynLjvaHGibTHwIzODdv1hEcn+tAZsTeDg0yKs89Ak5Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750409575; c=relaxed/simple;
	bh=EL8oBTncb2jPLKN95d0A3Gwfp2TRKNQGOjGrUHBGkPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XpGYGA9PckS2sVOx11POxW2UEW0CErQxNv1e0nF/OE/VtSGvg0/dhI/07fGdKzL3S9hHvizCENzXxkcoHOno9jkJQvyqvjGxJEWphzSAZtGV68LpPu7TLmfE8MH2ehydrzTuj3SQGkAqdHK1ZETQiLTukQ2PV7YTO41vJQkpAko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bOQuLVZN; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bOQuLVZN"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-604bff84741so2944534a12.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jun 2025 01:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750409572; x=1751014372; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ijIzJ3eavxhSX/7acbilpB+491DCDG2Gm+U0R3GFaaE=;
        b=bOQuLVZNKEI5lJQ3vrtM+sVUps3IXbpSznRf20vgX5xklyjH0QzMy/aiXNSatG6Rl8
         uCH2/Dyl6df2ZoEFF5Ri1dK0I9lR9VS2Z8DUb40/sHrU0xntwj4y0nI1YMVYLLzhqTiN
         NoSL72EsWDu77yZxlS/u198K0pGHRxy6o5vX82dLH44G8AvEx9BcaGj6rA0j2xOzkjEX
         D0cc5cBz1BLzreceK9ApqvdYmbpQs0Ev5x0ijrYyX1c2UuQKc9KIXy1xLkBb17D8+62m
         jSw2wRmz91GSMNSmhqpv5rH9A4hIEn9dCNfXfeuxzRm4tpiSDblHPt+/TFnKA1h2fvt6
         Lj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750409572; x=1751014372;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ijIzJ3eavxhSX/7acbilpB+491DCDG2Gm+U0R3GFaaE=;
        b=Vg6mEQzW4TWWMDL5LadjteNjrfUzWtQIyZ3Mn5fKyDAAx7+ghnfNC4ud+9a6u4dTKB
         DL8GANvHl8pm9meCEB/0FRRe0tdvFEzapXBlmnYagS/oAx85AAk3HIowAzY6sbfjo90n
         TDPrTPBqyCEDQVLeEBo8DWPVB2qq5RWZitBRPDBNs7dJWAeWZtiA1GQ6MssxV0Eliy3s
         rkmAmJQXGmFO5gHJBCd3a6DEhmox3Hv8van2WZooxGuVwQjYY62kfEq8J1IsP0QWis59
         Edlp2ZYDAf4Tvi92ruxWoK61XDLHcgfV56R347RiMmFsXQE+9DbNTRC3Wp2sqVTIq1LT
         NGuA==
X-Gm-Message-State: AOJu0YyoJb4UO5a/NGjkmHWfLr9wvIscCx8q/HvLCjjFn+cBYlppjX6r
	mbDUjFuTS1fYLYB0FznGngT292zFbs+DayGm64tsvo5vtIIk+mvP36dJuyprDQ==
X-Gm-Gg: ASbGncumADXYipkqo6ZftMS0GSxgkrRTUaHT/ptZzDCejaNBzDtDkw0qQ6AASWakORJ
	g0A32Bi+1NxybgGwV8m0sK34zh1gf3QLpQO7FN7lkBJ6q6DP1c2vx28okPfTDBuXAhvh1EFDRqK
	U4GFlXEtFYv+qs0w/jYnLiHFmCnBg9x3KFjIU+wuICfTRaNl4xAK7TR0asKbq+WzEDPGF76kry6
	BWzuQBltEOvrgbQDsZ9TCq+MRsti93+n2SgQ5+8qOZrpSe2/UOxDjgsWDs/RTQBbAUtwxLLeksq
	e9BKCMkWT5YVFvMBkHKitkqZOMgw+IjKBSat8nUUSaJIvRjOdudXiWt1LhshjtkZ2c8LVqikXHA
	DUvDLpnHIT89Dw5E64XOA8xFx6dfJdtQ=
X-Google-Smtp-Source: AGHT+IE61vdK8/CFtddcAAcdLUYS29QmjE8IbWsin3waPva7EluI3JPq048AhHefX/c/cNfvAgutww==
X-Received: by 2002:a17:907:3e95:b0:ad2:39f2:3aa8 with SMTP id a640c23a62f3a-ae057b39c29mr164405266b.38.1750409571965;
        Fri, 20 Jun 2025 01:52:51 -0700 (PDT)
Received: from [192.168.8.101] (78-80-16-228.customers.tmcz.cz. [78.80.16.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae053ee67d6sm129058066b.66.2025.06.20.01.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jun 2025 01:52:51 -0700 (PDT)
Message-ID: <953e81bc-edbc-456b-8276-536d313ab220@gmail.com>
Date: Fri, 20 Jun 2025 10:52:49 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 PATCH] crypto: wp512 - Use API partial block handling
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <8be28417-2733-4494-8a09-b4343a3bcf3d@gmail.com>
 <aFT2D0UeO0cQYV1C@gondor.apana.org.au>
 <fea81d0e-5b80-4247-8231-1e099be5bb1c@gmail.com>
 <aFUd1upBNhEM1KfG@gondor.apana.org.au>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <aFUd1upBNhEM1KfG@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/25 10:37 AM, Herbert Xu wrote:
> On Fri, Jun 20, 2025 at 10:10:53AM +0200, Milan Broz wrote:
>>
>> Now I get wrong data instead of fail (both on 32bit and 64bit).
>> Patch just applied over today's Linus' tree
>>
>> ...
>> PBKDF vector 20 pbkdf2-whirlpool [FAILED]
>>   got:  58 55 1e ef 29 40 d6 a2 f0 59 e0 d9 4a 50 c5 df 01 25 be ee 27 5b 35 47 6d 37 38 13 0f e0 da 29
>> want:  9c 1c 74 f5 88 26 e7 6a 53 58 f4 0c 39 e7 80 89 07 c0 31 19 9a 50 a2 48 f1 d9 fe 78 64 e5 84 50
>> PBKDF test failed.
>>
>> (Whirlpool is translated to wp512 in the crypto backend and despite it is a quite rare use, some people
>> used if for LUKS PBKDF2. Actually the whole vector test was reaction to wrong Whirlpool implementation
>> in gcrypt years ago. It apparently can find breakage even today :-)
> 
> Oops, I forgot to increment the hash length for the final partial
> update :)

It s still failing for me for that userspace crypt API.

Milan

