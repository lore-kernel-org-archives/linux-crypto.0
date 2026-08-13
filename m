Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CD93C416A
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 06:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786601449; cv=none; b=MCZs9xOD3xVNkne/JuiNTd/xGBj1+NHumAgYjcJu+JGN8hRd5Ss9E9zg09+Vf1lARdVNaw0UqSkdz70pLU5oiwvogw7TaHeD1RGi5EaaYwPv3YUIoy+apjv5SafZQPsS9ebXi+nnrrzvyjIv0QfHnhWisvqkggRPmpPsg0MHirc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786601449; c=relaxed/simple;
	bh=7WEh5O5bExfXu8mXQ1B7pKZcn7Iuz4j6v61TvONpq3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RC3bEf4z+p/1joi8heoxAn4TlvznYwp1jZ0vPiEo7TZ4cUkjtTMC1ECk56PPh8gu819CppiUxAkztfWHbyYurAyBQqtBS994CybkblAHzbDKcWnP78rFHJ6ZM4v4xkRB0GFsW4Hq0C3y0hFXNwZbvep70xYZPSzmkv2UXRmX3Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VHC6eyct; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OAONuY7L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VHC6eyct";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OAONuY7L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786601446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=d9+13YGpGqP8LzpQBtciWgZWdxF7wOy5ADfzqZPo8FI=;
	b=VHC6eyctvUt0U+OvV8xaGwDtJp6v0PRjGDuhwlJ8Gopmvnqxdgw4+7+r18vo08JGxDOKHm
	FG8LG7DOpPMHYkR2bdjOQ/iYzpC21RyZqa8iMcPqm3FKKX+J+8bTLwyltV3sVYLXCFLHlw
	GIAMG1VjYjmy0oIcD9f5JLfc5WODowI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-bB81GkhKMzWSLEa8hDQRiQ-1; Thu, 13 Aug 2026 02:10:25 -0400
X-MC-Unique: bB81GkhKMzWSLEa8hDQRiQ-1
X-Mimecast-MFC-AGG-ID: bB81GkhKMzWSLEa8hDQRiQ_1786601424
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495689bfcc8so9828905e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 23:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786601424; x=1787206224; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d9+13YGpGqP8LzpQBtciWgZWdxF7wOy5ADfzqZPo8FI=;
        b=OAONuY7Lw/aD8JBfR5hvbYtJ1Qf6zgYqwzMv1ixvQOz/38VQqhoDt9CbkkE0w3g6cU
         XI4rkaJyNvWy4j1wGi6dH102jhn+ODNWZDv7mBPwQHpWAOTft0VZO1ihzoPnF6JIfHoR
         pxHkOLtjeIb5Pe0e3YtW7hlEzbrSQUBvkj3QzSCiH2YPlp/btBJ2RlWyEZEg6bcE57Em
         vHPvb8Azwarq9WCDoCP4TbVQHFLW8mMLn3mALxIwAr052kuNaCRuIU7+LQU3+nzA6/Sx
         kNy0QtwqSXBDlWNV7MhaRNZKFoh6pkfSUNW5HKpk9WLgCqtf4ILCG+Be4AuBXzu9VTS2
         cpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786601424; x=1787206224;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d9+13YGpGqP8LzpQBtciWgZWdxF7wOy5ADfzqZPo8FI=;
        b=cFmEt5iVWXZDDp099fioeszsF4U1v6x8Xfwr0OsnS7rE/GozoCwJejB8W/FPb4MEW7
         eBpjOwWTCNbKnmPVfcvvoxOk9CHOG6naSariYiEH7v9YWOsbY+u/msvc/xJH7f2p1Mwv
         fwMrEgkLvqrl5HMGSMfi8nctA+/miTIIKAdvMJH+wWC1NL11IPHF3CMwF6SK/JaE/NFu
         ApxncB9ftCOjwgg5cw44DasPwClJA58AMn/hW5yePGLstGsXyw1mtkmnWjufecGMbWtT
         vHl7HXXg+D/cVoI0M005VkMtr2pG/9HW8D8i0hXARp1967mZoPuV9ci1E2S+DENZM0m3
         u3iA==
X-Forwarded-Encrypted: i=1; AHgh+Rpwsvcmq0W74jrkmIGmsY/hUtjcpIUwnSMlSPx97/DRqwDVywyhSFqd0ISXD9B8vc7OnVoCNzv4eyzHkLw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6EvYmvhFba6+QlZKhtAvN2HbLW4j8Y8ZjLOyYseBF41m/kggQ
	K6iQgynphks5Un5xRRrw4Fwu9EhXdoRAuQQH0s+3XAGKCgK0EnJAnKYpG5UFbpw0hFyu2Rr+fc/
	7V/yTuMORsAmP3v0PPvIzfc3vnoigK9HsbgQs9/5R/inUSffFmp3Qu+fV/t4NuIfZTg==
X-Gm-Gg: AR+sD11MFKxHNaBed0KW1NXL0GqZAthLR5UnJV+SPxc2FyCMDWUA3bfULuS9zR1OwMX
	o8y62KvXnoP/G5SnVqWgV5S8tmpioxSCLZeXTNb1jSSyxmgLkATvLixPcqJRRvOJlRu6+RDYPDb
	on7V8hH88q5Mu4JtLx5lima1V6Qv0joaiY0AOcik3O+qbmDK9GIKL7vS1Flhf3quF3IEfSaPnQr
	6EH70GtIviXCjY7S7ndIqcEiOmpEegbeQjicjExMGBFuMh95LhNh4Sl/Vcg3al3Y5wMi6+RwbNb
	wb9j2C11eJ/trLenEpOiSlxcpM+PWsYQEaUzOQWDfRUNW8rx9gkyvLvJ9ZZdJ8WyfaB+wB/7
X-Received: by 2002:a05:600c:46cf:b0:499:4d4a:4990 with SMTP id 5b1f17b1804b1-4998219d44cmr27409055e9.3.1786601424490;
        Wed, 12 Aug 2026 23:10:24 -0700 (PDT)
X-Received: by 2002:a05:600c:46cf:b0:499:4d4a:4990 with SMTP id 5b1f17b1804b1-4998219d44cmr27408475e9.3.1786601424085;
        Wed, 12 Aug 2026 23:10:24 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981b0f6b1sm39407845e9.4.2026.08.12.23.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 23:10:22 -0700 (PDT)
Message-ID: <fdd88f0f-ec72-4640-919b-3e6d3a3c9434@redhat.com>
Date: Thu, 13 Aug 2026 08:10:21 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] lib/crypto: Provide a function for zeroizing
 hmac_sha1_ctx
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>,
 David Howells <dhowells@redhat.com>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
 linux-security-module@vger.kernel.org
References: <20260812163336.3103835-1-thuth@redhat.com>
 <20260813022757.GB28329@sol>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260813022757.GB28329@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/08/2026 04.27, Eric Biggers wrote:
> On Wed, Aug 12, 2026 at 06:33:33PM +0200, Thomas Huth wrote:
>> It's maybe not worth the effort for hmac_sha1_ctx right now (since there
>> is only one spot that forgot to zeroize the structure in case of errors),
>> but offering a function for zeroizing the data via __cleanup might help to
>> get future code into the proper shape right from the start. Thus let's
>> introduce a hmac_sha1_zeroize_ctx() function now and use it in the
>> appropriate spots.
>>
>> Thomas Huth (3):
>>    crypto: Provide a wrapper for zeroizing hmac_sha1_ctx
> 
> Subject prefix should be "lib/crypto: sha1:"
> 
>>    security: keys: trusted: always clear the hmac_sha1_ctx before
>>      returning
>>    lib/crypto: sha1: Use hmac_sha1_zeroize_ctx() instead of
>>      memzero_explicit()
>>
>>   include/crypto/sha1.h                     | 17 +++++++++++++++++
>>   lib/crypto/sha1.c                         |  2 +-
>>   security/keys/trusted-keys/trusted_tpm1.c |  2 +-
>>   3 files changed, 19 insertions(+), 2 deletions(-)
> 
> As you probably know, SHA-1 is a bit outdated.  Will these be coming for
> SHA-2 as well?  It would be nice to introduce all the APIs at the same
> time so that we can make sure they're consistent.  I would actually
> prioritize that over introducing callers of them right now, as that can
> be done later and often requires acks from other maintainers (and they
> can go through other trees as well).
Yes, makes sense. I've got a patch for HMAC-SHA2 ready, too, but the patch 
that is using it on the calling site has a conflict with the smb patch that 
I already sent out, so I wanted to wait a little bit til that is merged:

  https://lore.kernel.org/lkml/20260812130152.2861834-2-thuth@redhat.com/

... but if you're fine with a series that introduces the zeroization 
functions first, without immediately introducing callers, I'm happy to 
assemble such a patch series first!

  Thomas

