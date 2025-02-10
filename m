Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C886A17BB6
	for <linux-crypto@vger.kernel.org>; Mon, 10 Feb 2025 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739191215; cv=none; b=brl8ZRcUFz4Q4GzBzdfGR04Fqx7MCCm6LlvV/xBls9OOoijRwQmsYV+HcaR4teNliwEZ9m3x82r12Rodrw3XEKyvvL+Nim4SnLGB0j0VPDwFvT3ZdzIeEBkLZK0ELFPoKCF9VSeZEU6HAFWDa519111S1FFqx1Jias+3V+Okl6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739191215; c=relaxed/simple;
	bh=vC/2p3vue+xQRI8AHSDC2HfA+L1Yp//ojjEwI0nkQRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AREppmxTrwW+WYRp5UmHEsG9uPz59y1l41ATkp2k+UNGJUwAkXYkFHiw33O8o12DOzztvwaxBjngJzW5X2igBZPEsyG5yto0LUbNXkmhaNbb16aWSzUW8AjrTf5k+bgHAtVxFpPd8NjdxiWeCSLDRSalvh37NOCgkbK1XuNljyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CL1DgAU8; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CL1DgAU8"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ab7c81b8681so113193466b.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Feb 2025 04:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739191212; x=1739796012; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RJK+xXuuNshrOOmsp2OjLGqkJM8XBht+rlbmPUYy3P0=;
        b=CL1DgAU8ScbQZ03QUbDFIav/gb+pHOile5HfCQXCUmEVQUvT0GKd/XccVFII7ta8fq
         VOWPApbhz0qSfw31xYJqENGjvZg9zQTFcVIlynIAwFFuU4g/I7VqWB2LIUrlqjccR4Iv
         AaRT+wiF53frCwSr9Lb35SGgF5mk5j3r+CreXf6e3ioM4P5Q4ute0TceNeZTk9bKdTsQ
         6ZRjpJtGpeezuoTTBIeErI7DVRshmI1T9N27x5CRjdbJGrVATkwA9St6+Oslu3L0XimJ
         ToWKwlXOQ4Vagt0pvsdXgCJY3pgU1p2vokw4WDcIt0KQ3izR/13W9nE87MI58oy2/+eR
         ChnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739191212; x=1739796012;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RJK+xXuuNshrOOmsp2OjLGqkJM8XBht+rlbmPUYy3P0=;
        b=QEA9VwSTTZZXmmvvk2m5JL4vVV2145f2Ej80YJbQbdZnaXY9JKTrZRa6FKfpr2I/0S
         G4ZuW43hDG39+N1sbrQ38Gnu54BjTXsWx4MojzoHLfvLB2SqpGBK6muxo0DIk/9y1hJk
         o6y+/VaZEFjZhV4ecm2s3vv6OZNVsE4Y6dp75+qKWgjefKOGPA12XmTfStfCiK6zeFt+
         Pxfnt6sits22drmB/jDw0+P7H7gLH9m3xtW83V+TBP/gm2Oh5y3GDFCMVBF0tnOomr2c
         i7uwhgFU73BvC/vShhZtyDlJFpJVxWGu2sEOvtIWFKM3BT4/njyfO48KJbUWpUGsq2nR
         X8gQ==
X-Gm-Message-State: AOJu0YzGWQg5ogXDO/9zoLGlZNuOvuVFNLb6GxB0iT59zQ9jCVl4p9Bs
	ylxfN6s6Za5sBI+cXzo59VH6x4Az+WXU/sJRjEnByKXsarh5SuefbLaPV0TWa7YfkA==
X-Gm-Gg: ASbGncsE/P88wtXq+ABJoZHmerWlqEsfJsUUFwg7VWgw9/y0c7DQysgGFtqo4xMuVSK
	LWr1/Irv8lmwXTCxnltxRjgMHNo+BJXIIvvGrAa/5Ql+DtEBwQSTSpKZGWccZOc/gofcDBfsDT0
	wb5mUF6CMJIPHwffqma4Zgler4NTm8LgaERE6ay9H9mDNFTbR9k375axMq1apGJI79T+r2RWfXQ
	izo8nrrDHakU150TblfGFeZT2ZdzuD+klx7+c4QZT4sgdqwfYtWzQe3paFFc+WMQ0ALMbn8IeEg
	Zv3P9BGDwrTQ6M/QP1TRzJDu957FuLFrT49+dDbkPh6m3ZgqGGQHz2H99rs7wL3WFM4jg7JT5eR
	/GVIyd6FjthE1o+Y5fV/6/wmOq2GRReuXPiSKTiQke/MAE8c5qMU=
X-Google-Smtp-Source: AGHT+IHBmTV/q8kkdD9VoXT0z82FGAVcIGVICf5E+QzF192xxTnzFAraIFL/vjVbGpVUTPh4qm5XHQ==
X-Received: by 2002:a17:907:9628:b0:ab2:bd0b:acdf with SMTP id a640c23a62f3a-ab789c1d683mr1521631766b.36.1739191211777;
        Mon, 10 Feb 2025 04:40:11 -0800 (PST)
Received: from ?IPV6:2003:d0:af0c:d200:8ab2:e79e:9971:853b? (p200300d0af0cd2008ab2e79e9971853b.dip0.t-ipconnect.de. [2003:d0:af0c:d200:8ab2:e79e:9971:853b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79fea9e06sm543811566b.60.2025.02.10.04.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 04:40:11 -0800 (PST)
Message-ID: <1157db48-ba02-4977-9604-fdca26da575b@gmail.com>
Date: Mon, 10 Feb 2025 13:40:10 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: jitter - add cmdline oversampling overrides
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, smueller@chronox.de
References: <20250127160236.7821-1-theil.markus@gmail.com>
 <Z6hy7LFoHPffWuWi@gondor.apana.org.au>
Content-Language: en-US
From: Markus Theil <theil.markus@gmail.com>
In-Reply-To: <Z6hy7LFoHPffWuWi@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi (& sorry for replying in HTML the last time :(),

On 09.02.25 10:18, Herbert Xu wrote:
> On Mon, Jan 27, 2025 at 05:02:36PM +0100, Markus Theil wrote:
>> As already mentioned in the comments, using a cryptographic
>> hash function, like SHA3-256, decreases the expected entropy
>> due to properties of random mappings (collisions and unused values).
>>
>> When mapping 256 bit of entropy to 256 output bits, this results
>> in roughly 6 bit entropy loss (depending on the estimate formula
>> for mapping 256 bit to 256 bit via a random mapping):
>>
>> NIST approximation (count all input bits as input): 255.0
>> NIST approximation (count only entropy bits as input): 251.69 Bit
>> BSI approximation (count only entropy bits as input): 250.11 Bit
>>
>> Therefore add a cmdline override for the 64 bit oversampling safety margin,
>> This results in an expected entropy of nearly 256 bit also after hashing,
>> when desired.
>>
>> Only enable this, when you are aware of the increased runtime per
>> iteration.
>>
>> This override is only possible, when not in FIPS mode (as FIPS mandates
>> this to be true for a full entropy claim).
>>
>> Signed-off-by: Markus Theil <theil.markus@gmail.com>
>> ---
>>   crypto/jitterentropy.c | 33 +++++++++++++++++++++++++++------
>>   1 file changed, 27 insertions(+), 6 deletions(-)
> 
> Why does this need to be a toggle?

It slightly increases the runtime of the code per 256 Bit random number 
generated, which possibly doesn't suit embedded guys using this RNG but 
demanding short system bootup.
So users who can live with this penalty can enable it, others probably 
won't tolerate it. With this being a toggle, it will also be easier to 
enable this in default distribution kernels running e.g. in cloud instances.

> 
> Why can't you just make this conditional on fips_enabled?

This was also my first thought, just enable fips mode. Our workloads 
don't have to run in FIPS mode and I don't know which software may 
reacts to the kernel announcing to be fips enabled in an unexpected way.

So basically, this seems to be useful, even when not in FIPS mode.

BR
Markus

