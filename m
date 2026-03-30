Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1614A3A6B7C
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 13:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774878664; cv=none; b=oSwSzY4tV5jWMjP2TKrgDroNlJvJg1l13TT8Rrm0Ki/Q4/I9YJUSj6xnew/kucoBChAe9EqJMHeEI53bcLgPVYL/uEMaKenvVcBWYgW0rmFk5M2A9CZ7Xpv0KRsost+cPTRDX9RyhpTQYutOe5JCOD3PVS2penaagO97QihXsaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774878664; c=relaxed/simple;
	bh=1t+BYrtwY9uduvyPvPky5ZzhY8JpvKJ8YNmExprcBdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a0YXptLncQtaaBC9cKKDNxELyoPhj2Wmw3UtWev0ISL26emppTvp/c72AbgDUI8fSpYS2RVNfnJFu5hhDiXgbYC/tEAfTvQevx8z7MjHG+HSoDOsf6xTMdZVYMZXvfG3SHucFlhGZ8EzdILN0ZMtdVHuKuolqrvboamp8J4i/8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pfCA7fC6; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pfCA7fC6"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c769e72512dso833181a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 06:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774878661; x=1775483461; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FEjj5wcFmUqct5LV6/YMbiQFopUqN494E7iwiM/JsxY=;
        b=pfCA7fC6ZYo+iwqGWHonBacpEj2kkTlfbfCnv6Az7Ipwf9zOjIqrHGiyJiVR/H83vD
         fuYE1L3equQxM+v9e61F5kFtuTQX1mImDGMtLqewi4zA3KC3rYIw1qaKqvrDzLWCUMJ8
         uIwEVnIEkE+USDz3aTJ03YgsWE4Go5ldI+pgLaF0oov0nqGOWzEFo4dob5A9Q+Jz2GDb
         AVgN5mzPFBG8HUoWN1cnsERppoJH6ApArcAVfFzYLjlgawszhA7M8dxwOf3LFqoIamWu
         4ydRrm5w/o/9KpJlRUu+UJX/mc6e6rN8FpcAfLMEUGqbQPwp7aByeO7MjfhtWVlqaxZc
         q2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774878661; x=1775483461;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FEjj5wcFmUqct5LV6/YMbiQFopUqN494E7iwiM/JsxY=;
        b=Q8x9s3DiDXCjyoDod4elnhkhVlE2ygfHV5leYyV0O/xMFLxjQn8radLXvKPZ386zIO
         7v1gB9hLE7t4weelT307oxuigeO1w9muCwClzSaQo5PkhiwnaUN4vZA3CwqKcSYcpKrx
         kqCCc1aqp98cps1PrpYi2JDMiy/ntwARum5OvgGGvpi8WmFRnRYVzlBJZLEzIWI5TAmf
         JCy4AZnt0mgAMvKmHmNrALqwYYoFlcrN1bkoaMvba6EnLUfsnD1Ac6dqR415gerq1i6v
         +QBfIVMOC/OVnEZ8LNdVnCVSBMYD3rs2nMujqxzS6f2Upw3S/0ckhs+m+lGTr3nB/dYQ
         bF9w==
X-Gm-Message-State: AOJu0YzyDkjnFFn/5gqc+7eEK5trqNsxUJW/rR8iYCmyCP3MUhW6Aavq
	zCoA7XMWOL1dmSslyo1vWo/u5xiuXK+N2YEGGpw9cz0chNEpqUxw7gjx
X-Gm-Gg: ATEYQzyxRXgsLfL1Rf9KegyPFxr8JDIRQ9RXJm2uDJlhKnGubinUziDNGUk65iDtxYu
	WeN9qiaNAL6g/fjUXthSsuGqk0IGGbM/gqnhkXKo/rJIsI1DaFj9xw5ShBKk+tEzVik0WqygYnQ
	5fvbJ3vj5j/zjE6dKEqFgMFXUrXreWB4+idfy2651PBMt9fmMhyIiU1/G1sIe/NEIQERe7xrpQt
	ZrELoukqTkB+xtoFP4Ly+Pvz/R4A2XQJlbdDGOQg0LlsvujO2b2o83xMhXhyqBJZqV61eFDBXYM
	MIwXKrYi4aZZoCfYdOXmkZANe7KI5ryw0SOmTl6hntO6fDPsXtNN8Amx50h5CIwNonm28qp2w7r
	9wEFXPcIDhcxHF81klgt4kfTiqycm7a4k/8s2p3R19Z6q5reTG5lKIqmGpVlcslMPrgsRSZKZ8/
	tTzmPqrslpn6GmMaW9PF/9YkKf3514MNp8+Z8=
X-Received: by 2002:a17:903:b50:b0:2b2:4e5a:9471 with SMTP id d9443c01a7336-2b24e5a991dmr50885515ad.22.1774878661112;
        Mon, 30 Mar 2026 06:51:01 -0700 (PDT)
Received: from [192.168.10.1] ([116.6.234.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242765b93sm88906005ad.51.2026.03.30.06.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 06:51:00 -0700 (PDT)
Message-ID: <b2da7a03-ed78-4d2e-af5b-797bd4fa59b3@gmail.com>
Date: Mon, 30 Mar 2026 21:50:56 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] crypto: jitterentropy - replace long-held spinlock
 with mutex
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 davem@davemloft.net, smueller@chronox.de, yifanwucs@gmail.com,
 tomapufckgml@gmail.com, yuantan098@gmail.com, bird@lzu.edu.cn
References: <cover.1774854094.git.jerryxucs@gmail.com>
 <9a8ef1cbcc68b752a495acf0a23e7095eb0a7796.1774854094.git.jerryxucs@gmail.com>
 <aco5ijLVPL8EjS8g@gondor.apana.org.au>
Content-Language: en-US
From: Haixin Xu <jerryxucs@gmail.com>
In-Reply-To: <aco5ijLVPL8EjS8g@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Herbert,

On 3/30/26 16:51, Herbert Xu wrote:
> Are you sure that this function never gets called from softirq
> context?

Yes, for this implementation and its current call paths, I believe using
a mutex here is safe.

As `jitterentropy_rng` is not used as the generic `crypto_default_rng`
directly, i found only two users of it in tree:
1. AF_ALG RNG sockets via crypto/algif_rng.c
    `_rng_recvmsg()` calls `crypto_rng_generate()` from the calling
    task's syscall context.
2. DRBG seeding via crypto/drbg.c
    `drbg_seed()` calls `crypto_rng_get_bytes()`, `dbrg_seed()` requires
    holding `drbg->drbg_mutex`.

There are also other RNG implementations in tree that hold a mutex in
the generate function. For example:
- crypto/drbg.c uses `drbg->drbg_mutex` in `drbg_generate_long`
- drivers/crypto/qcom-rng.c uses `rng->lock` in `qcom_rng_generate`

So my reasoning is that using a mutex here should be safe.

Best regards
Haixin Xu
