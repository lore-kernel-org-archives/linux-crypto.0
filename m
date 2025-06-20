Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695F828A41B
	for <linux-crypto@vger.kernel.org>; Fri, 20 Jun 2025 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750425782; cv=none; b=SlP3Y110Ca3nixXWoXbIwWzn0BKnItV0NvZ9iIxBIp1zH6+yZwHYbuPYAl4n/08DY+UqS22+xYwuPVnaROnYdzcRDL5/OmSedxXY6nhiOWlWLb+jNHdztOYGtyhdcIFHlNXDx04Q0gb1fQso0ubThw0rDdn81D9pMwCfXOHqzHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750425782; c=relaxed/simple;
	bh=ySJ3U2Gv9CC3AUky/8+BPNTFRSSiBL4boE/D5UTGcdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EZvp9aMDAosHtyhb6JnbIUjU80Hj0qx6f94RwPXyfJjKU6knYxzMIOZfoOU4E35H1Sca1ENAmk9Qt7qagRJXsNPtiMrxUjVVU3+3jqeUe1+1YF5dd8esCg+N78HHUrLSv+wVjxi30oyz5TJeYAoRUKI0MwpfTouyW+jgo++La1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZN7ISJ2Y; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZN7ISJ2Y"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6071ac9dc3eso3112425a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jun 2025 06:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750425779; x=1751030579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aWmr00QtgOnqPpAcpjo3SklWE6cvcW8c55F9MQzRqE8=;
        b=ZN7ISJ2YWehQhApCETT1inwwx6j+UqX8tn0yRFJz1mDfgWhxyZbcYqhwVKQXYmYsXv
         /ORpqgo5oyAc+BAGrCgrgPAgCLFCWhpGXouMccPY77rYnilTTcyKHKIpE1xnWBLlrAWO
         nBnNS9dkFXZjdJ6NAKbtaKyCq0F5zzzEnvMKfFRgr0MvtVRzw5HMu/NadKVl91zs0iic
         B1df4jWmkZGX4fh2VMT8gwS19tdpr380YM0QeDW5cGZqAj+COMMspcL8MYVVjd1JCBcK
         vJFXXofvgVJHW9APMq6wDtoW5NqkQ3x83CDKt2EeV6feFPXuapEpCUGbeIZIw2+OS00X
         KXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750425779; x=1751030579;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aWmr00QtgOnqPpAcpjo3SklWE6cvcW8c55F9MQzRqE8=;
        b=GZOk37QjTPFJ/wVGtB6mxctB+WS687G1cqbJbarTpiAOiLFGKJsYjgKPEK/+PNZq0h
         Y/XI+r+44mgZR+cB/SzCGqDBwUcNg5BgC92vEgcjAbxvJndQU+N9DmWmwuDG3A5GpjxH
         DVUnGEE5Qbp/TnW4I91BMlcr9gg5LS55ZaNPNNcibmOG8QdtrjqqSQZzNcrthiApgisv
         PqwFt21ddjqZwDeIn3O1ymuEQr3ASHOWvEzqtBee7Yz3Nk/76WEglHuwO2jsLO+RWaTp
         LIEFV09o7G1AYdhWIQR7uo7TOGZ6VuucnvofWuOQZW5SpnatUaxzP5prfwwEJ5ngKWR3
         0QDg==
X-Gm-Message-State: AOJu0YxiqA989qNFHiuE4upTtN4pHpGYS+cNSp/76l9u98krE6AUigrl
	/7E5lP40IbYX3d6UHOUHF3Xw8dw0uR+UuxwWMW1yfHPBovQBqsRdqVQs+QSWFA==
X-Gm-Gg: ASbGncsdt+yMzngYpbmNOMfFuQI6nF5H4V9W2YwviBRT8ea8/YL1BcjyeEkfdZsGhkT
	qSAfKiZSZ/5TtZCcJRxe9qjQ4VnKbp4cm3YPnjZCmuINOK/oWcHgZpXicMO1smovT8PPdfg7NlA
	P5y9Ug+/VvMSnpCyzfWn9SoisyGEcZTzT1hjApP3iqRMGuO9dnUt+16TnpiNBQAezPGoHEqK88F
	74VuN95FRFdZ9klsGZq+RhKdz9zUT/QwzXaOe41APKCQztzsYzluTlzd2yL8UAE/cPaqaVATmKA
	w96F2eaZGylB8ZFnpBXCaEst5Hik/VeW0urGadteDzoS39GiPkbqx4ZQar5l5+9bFAHo3Wnmzut
	vsWLGqlebhCkLz7SQsgDn
X-Google-Smtp-Source: AGHT+IGqg2hBQCLEjXPhqoEAst5nm0w9rnleFJqkRK7FZru4muY0JXqzIU8XzbgY2cAdAkl8L5JnSQ==
X-Received: by 2002:a17:907:60c8:b0:ad5:27f5:7183 with SMTP id a640c23a62f3a-ae057b6c140mr245387766b.39.1750425778480;
        Fri, 20 Jun 2025 06:22:58 -0700 (PDT)
Received: from [192.168.8.101] (78-80-16-228.customers.tmcz.cz. [78.80.16.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae053e7f90esm162427166b.20.2025.06.20.06.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jun 2025 06:22:58 -0700 (PDT)
Message-ID: <6a5313ca-4b57-4688-81c1-692e49c689a7@gmail.com>
Date: Fri, 20 Jun 2025 15:22:57 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 PATCH] crypto: wp512 - Use API partial block handling
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <8be28417-2733-4494-8a09-b4343a3bcf3d@gmail.com>
 <aFT2D0UeO0cQYV1C@gondor.apana.org.au>
 <fea81d0e-5b80-4247-8231-1e099be5bb1c@gmail.com>
 <aFUd1upBNhEM1KfG@gondor.apana.org.au>
 <953e81bc-edbc-456b-8276-536d313ab220@gmail.com>
 <aFVQx1iDdBnaJ9sa@gondor.apana.org.au>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <aFVQx1iDdBnaJ9sa@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/25 2:15 PM, Herbert Xu wrote:
> On Fri, Jun 20, 2025 at 10:52:49AM +0200, Milan Broz wrote:
>>
>> It s still failing for me for that userspace crypt API.
> 
> OK I screwed up the final marker.  The old code always left a
> zero byte in the buffer so the finalisation could simply or it
> with 0x80.  With the new code, we need to set it to 0x80 explicitly
> instead of oring.
> 
> ---8<---
> Use the Crypto API partial block handling.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Yes, we have a winner ;-) It works now, thanks!

Tested-by: Milan Broz <gmazyland@gmail.com>

I guess this will go to the next crypto update pull request.

Thanks,
Milan

