Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC5C1C3BEE;
	Tue,  1 Apr 2025 07:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743492041; cv=none; b=IbJ6kcm8Y09OqIrxy5rDbTXPm8r/2aCX46MHyaMIbICpjTS8RYhcf3sjpvEF/1l/5rWRUJrFcPdWiFC4zBK77jfwELijDjMQjJqPPk4AsiBMsZ0C34TsODxFYi1pWuhKXRUgqXrX3f0XIpAk9D0+hYykDnXJ2XK8dIbqgpT5mYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743492041; c=relaxed/simple;
	bh=3rFFXI6daLv2cyQoQFQJIyc2mgHJZ3oTpLktXKXpV/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HzNK0EQ7SK8BCU+U9erEO6DEmB2XL3zG0biu5hTuFOyLXxMIBeC5BSf/qU4jUCoqgsMvDFoHmamQGc/CIqd/PEK1aSvVEM3DSSnU+ddaCVeWtyitOcj0dIGo3R9wnEtWPQ+l4gsYVzgPRgyDbwTGLsJmbEq9ucoiSZ0ZhBBcdrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SUhUOuv9; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUhUOuv9"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e61d91a087so8416428a12.0;
        Tue, 01 Apr 2025 00:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743492038; x=1744096838; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2kRakNwCaqbpjj9VHFcPrOhRQB3Q05EiOGrDv1ZgKWQ=;
        b=SUhUOuv9p6h9K1s6CBh6L7G1YZG5TcYZYwiTj1K/dcFyPf8yNMtsQE7GMZ+ho4+Ciy
         hZ9S9LEh4PQ2QCpoa7YCcjb7zSeMccemk7eYUQexkdTtcB0LvdVUMQZKZS064zyhLaLG
         oc+U0K6jsaz+g+83qxe9tUMG2gqGaMEHrGypasAbB8AMVVQTdgmI6aeTD8QYiQ3zdukO
         a3bSpdErbbry5hreMJMmHPccT5YwHRSSEalRZhQXBvGVlN7QV6JkI1p9CufbjASE568y
         6pq41bhJFp95cT+pjyXawEvMayiaQvML32A9cGlW0qOdIcSj++slKXxaf2vDrQb/f2F2
         rpwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743492038; x=1744096838;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kRakNwCaqbpjj9VHFcPrOhRQB3Q05EiOGrDv1ZgKWQ=;
        b=e8yo4ANHU/RqQCFVQIFj6kgwA42PiBE4tRQv9UG+XmVjjSXbUGS1Yhhi4Q8i9L2QgN
         1yYLnlU19g7JjGa8WY8r8NKEoy76PLfmtir5UiFae1x9PmR1TqHH5Htz3ffHgBvyC0y9
         0hexn35l3xelFGea9oAWPdtf2ww9sZmmJIMYMTntb5MynvhKuKwaZV0mcmLYc0WsFNRs
         eqZuqLIQoDyM+9yJBn0AfQ/xZDut8TFjc7v7r3dqHxaUT21BWHs4owu6tgbYEvaUdqSm
         ziedNMwDeuWD6B3yb9K9ZnfOu5Tak9SmzZoxvjsTFBHj7TSyEWxnfa/LKUsWfCPQQizP
         SWvA==
X-Forwarded-Encrypted: i=1; AJvYcCUYSYV6BcaZiBtpKIfAaJPhKU6NfLJhn00Kw3yIPMpCcjT5FLW4wr8XyF1XBBo8OuyzeCTvr8wdMNNl9RU=@vger.kernel.org, AJvYcCVCinZ9JZl3eMv8V04Ilb5zDC9H4YeDh9aq3mXvDKjygec7DjgPpnRQBPU6munuq2iRtqSX4P0OkppWJ8mh@vger.kernel.org
X-Gm-Message-State: AOJu0YwX7FQypVDlTrX2oP2iLTWrDoODHyjiHpWxEhizULTIhWAYOI5K
	K8paoS/t6tTElLlCW6N8Hhn+9uxPjXFL9Y5ISs5Ww9dNGH+OjHcTFjEp4w==
X-Gm-Gg: ASbGncuF6uMSamYaHqiYCbpqfSmKtdkaK/ppNwJWSEkOD3ebq3krNRgK0LaAQ4+xGBd
	N3gDf3Bn0xWYcZ/cJUcRgwQny0sPrSK/3gYapBBAnK6mPhkcpIbX7Kc5sBfXNWBeJkAcUMIqNlA
	BZCANnQtcR8i0rOp3Uzyuwbat5ZUjl4tkC1gLFjxbsx4Nj3Goz7l30heObFZ4kYlz4yxlC1Dvjm
	y49J0Ip4+vtOjF1KS6AnTTfq6oIoFwhJcdSKv0mfMy45WDDozD7ikAd1JE6ZmZC/+qx7PchVigH
	ez1AixOzgccxdv/ZLuh4IitqxDmr7exluC0blHYpW8xXuJ1MIt89hR1Z3A9xNuEQE5XB
X-Google-Smtp-Source: AGHT+IEu6OtgUmGoQ8lS03XRsx3xm3PWe/YrAJQfmRDcOWbFBE28PmGoRlf24QmXdJ364O6ZCbLdYw==
X-Received: by 2002:a05:6402:5212:b0:5ec:cda0:ff1f with SMTP id 4fb4d7f45d1cf-5edfdaf916amr8706102a12.21.1743492037626;
        Tue, 01 Apr 2025 00:20:37 -0700 (PDT)
Received: from [147.251.42.106] (fosforos.fi.muni.cz. [147.251.42.106])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc16d38e3sm6710813a12.24.2025.04.01.00.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 00:20:37 -0700 (PDT)
Message-ID: <50b9b436-90c3-4801-ac1b-94b4e195e03a@gmail.com>
Date: Tue, 1 Apr 2025 09:20:36 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Chaining is dead
To: Eric Biggers <ebiggers@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au> <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au> <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
 <20250331165630.GA3893920@google.com> <Z-tTEjCzpgDr9a-3@gondor.apana.org.au>
 <20250401033303.GA56851@sol.localdomain>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20250401033303.GA56851@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/25 5:33 AM, Eric Biggers wrote:
> On Tue, Apr 01, 2025 at 10:44:34AM +0800, Herbert Xu wrote:
>> Thanks for the pointer, I wasn't aware of its existence.  Yes
>> there should definitely be only one code path for this.  So
>> what's stopping you from removing fscrypt right now? IOW what's
>> missing from blk-crypto?
> 
> Well, fscrypt (ext4/f2fs/ubifs/ceph encryption) wouldn't be removed; its
> implementation would just change on ext4 and f2fs.  Instead of providing a
> choice of whether to use blk-crypto or fs-layer crypto for file contents
> en/decryption, ext4 and f2fs would always use blk-crypto.  Supporting code such
> as fscrypt_decrypt_bio() that would become unused by that would be removed.
> 
> A few reasons I've waited so long:
> 
> - The fs-layer file contents en/decryption code was there first, and there
>    hasn't been a strong need to remove it yet
> - Much of the file contents en/decryption code in fs/crypto/ would still be
>    needed, since ubifs and ceph still use it as they are not block-based
> - It would make CONFIG_BLK_INLINE_ENCRYPTION, which adds a field to struct bio,
>    required on more systems
> - It would add the overhead of keyslot management to software crypto
> - blk-crypto currently always uses inline encryption hardware when it's
>    available; but, I'd like to preserve ext4's and f2fs's existing behavior where
>    the use of inline encryption hardware is opt-in via a mount option.
> 
> But I'm thinking it's finally time, especially with the conversions of
> filesystems to operate on folios that's going on.
> 
> dm-crypt could of course use blk-crypto too, but the dm people haven't been
> super comfortable so far with delegating en/decryption to the block layer.

Hi,

I cannot speak for device-mapper maintainers, but as it was me who complained about
block layer inline crypto introduction in dm-crypt, perhaps some clarification here:

I have no problem if there is a different block-layer/crypto API that guarantees
that the content of the bio is encrypted/decrypted, it could simplify dm-crypt a lot.
But it must not send plaintext to a random hardware device underneath by default
as it changes the dm-crypt threat model (and I see you mention the opt-in hw option
for fs mount as well).

However, dm-crypt also needs AEAD (authenticated encryption) support.
This is becoming important for devices that natively support additional per-sector metadata.
If we can access all these features through ublk in userspace one day, even better :)

Milan

