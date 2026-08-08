Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632F83CB577
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 10:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786185545; cv=none; b=DL3d7Pbiml8XkXo/OP8wEp2tUde6QNNsJmdqYGDtfOQnT8m1rUAYPn5gHQtGeICWG6FIQe29giEfTLPppl5lVeigs0ZUXram/fRJemoZLaCaoeF88H5wts8Fy38Z4HqCTQU/vDWAU8tuHxFMUvPSlgitezPBNfVPa5pjJIaToWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786185545; c=relaxed/simple;
	bh=ngVD+iZWR7jCh0MY5EC6oquQpUmXxcSQpH22Nvcg+LQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CKIrgOzs88m3QeJ3ydBF6Fx1GOuqQzDO3AoZjs9FCpNbClTXPi6k7S0fT+mt7h9QnFzluTByzMwP1kuPJ9Yuy+M1RGL5dT1HFD5N8yJQCFU7E/QkfvyqOaN1F6ccWUMGCRYzN9HpeLP6VE0ujYMoVQVQgzwZPUzRgmk+T3BvjE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QhGee+Qn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKpWtcDZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QhGee+Qn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKpWtcDZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786185543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=avs/8vY6YPXcNnZBbOhG7aKpSljPvSAucckGDKnJ5sU=;
	b=QhGee+QnxOdaNzxUAKm6VIGuyDW/oYm9K22hhi9VWvGvea8JKdS1szqZxTIZW2n+AZ8qiq
	/72S6/2I8lG+Lb8/uaIKIIIgJe5eBldUu+AEj/ky6rIrwhN10XRFBxeSaSunN0ymn9T2+J
	HZb/iUbeEc7HrgbnKrrgDbyiGcz6l+Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-VQfmH15MPMW5LJlgZ3xlRw-1; Sat, 08 Aug 2026 06:39:01 -0400
X-MC-Unique: VQfmH15MPMW5LJlgZ3xlRw-1
X-Mimecast-MFC-AGG-ID: VQfmH15MPMW5LJlgZ3xlRw_1786185541
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-473ac08a6a4so234797f8f.0
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2026 03:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786185540; x=1786790340; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=avs/8vY6YPXcNnZBbOhG7aKpSljPvSAucckGDKnJ5sU=;
        b=VKpWtcDZbut4hezhXMPoayPpOcoLbQzX3d+IUxeyY0soPiWR2tUkT2b27ZLIHLrAFz
         rVNIDc9om2wDNTCS8YQVN9pVwvy6SkzjTpGhKQwutIG3z1FVlKmwfrvyy042Kp9ZJh/h
         C8LozlU8LQ5j13r3BvT9BtOkxSzdPOnR2HCRAOxsq4ut6cj1ornS0Vob/KZb1QQVPN8f
         c54TxNxtuJ/j/ypPQKdWuih97NfaJHUvsdiDfRgUQ1hYq8BHJhLB3G94ksGlb/AaDt/N
         rDHw4trT9LgG0iP7FvDfSmwWvLOZkZnukgJDNER0jPt7YXstCC/jVOLvqw24B7qg79Td
         HL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786185540; x=1786790340;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=avs/8vY6YPXcNnZBbOhG7aKpSljPvSAucckGDKnJ5sU=;
        b=iPF/2Iv7mu7LoZe0AHyHBj4PzJp9kgPpVpGf7156LuaB3mu3hduheeYKMUIasoBzE7
         6nxqJEMJeyEf0AcEHxYNofkvoSRhZcAHpbLN5pDYhCvxGONTA+JNYXtXZURNqZRARQFa
         gynTQxrBuJNX7PX83kwQL5Rj8dNyDRm+cvtoDw7h2X3n7L3kGyAXHOvJYZkfLnRpsJs5
         E9fS4qz1rLFwi1TUrJlzQdkOWMOyK6Huy3pU7rqPV3G/iISFJGrE7Xf+YSy1fsXXAn/a
         /MwTMRpy9Xesmg2XrcuOJH+MX2VPSxIEsLdTFAJNJ27WjSqDBbgYyuGMr6em0bnmsyrW
         pdcg==
X-Forwarded-Encrypted: i=1; AHgh+Ro7XzpJwVLHclA3zCkXkKlUaeMXufAQ+dXky86Kyqg1J0IBo0v9arMmxJtvGdUpxDMCf8IP9Gtn/16OmZE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7jpJIFPkc5aMUJQ74LIdpgTk4iciLPLdvlU1FBRZQiLkaPcmX
	hIzhYbh8dlSHmAHhK+xrKHbtDBEg+gwHOwawLpyCHGes9yTEgQfaE8yThq4Z+6CLWEkHwmlskma
	/aTyF1QQKNAzzYBEC0UwkLQCVlz9xQee4JKjTQDg3XjTxZmSzS0kTZrfod+khhoEomQ==
X-Gm-Gg: AR+sD11CI9zcNedKPfoP+mgx+oqivgArh+pOPdODbsnaIh3nPbfPCXwGJqhprDMDJPe
	3rTLCoOYI3dOjzwAbLYNIeM0vvV8siAkaHpYgwK7j0v2hQDnzD12Lidgsfo5fZdbuXFmofd6B7r
	5/Ok+gjDNvgvYNOrBzhSrjxKa77u819keQ5qDHdl3Onw6MbiM5vKWO86fxpimfeZqHOXelKLooO
	C8IDbfv9NcX1k8/YNoGrByBnb9pHRb4dqnErlZco4kBWtpZcZXa5Dt9fn2xh5a8lcMAmm/azrT1
	PXOSyiKu9cUSaR3WVByB8VRMssGlxkL5HhvpneGfX7RB2sLyD1Vg3HpJyPa2fy7PTxVV/64J
X-Received: by 2002:adf:e38f:0:b0:47f:83ee:e56f with SMTP id ffacd0b85a97d-48130ed8729mr6725821f8f.18.1786185540762;
        Sat, 08 Aug 2026 03:39:00 -0700 (PDT)
X-Received: by 2002:adf:e38f:0:b0:47f:83ee:e56f with SMTP id ffacd0b85a97d-48130ed8729mr6725785f8f.18.1786185540446;
        Sat, 08 Aug 2026 03:39:00 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021f9182sm14217694f8f.28.2026.08.08.03.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 03:38:59 -0700 (PDT)
Message-ID: <995329a7-8980-4b5c-85c1-9c415b200804@redhat.com>
Date: Sat, 8 Aug 2026 12:38:57 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] net/tcp-ao: clear the aes_cmac_key when done
To: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Neal Cardwell <ncardwell@google.com>, "David S. Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>,
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org
References: <20260807125845.1477067-1-thuth@redhat.com>
 <20260807125845.1477067-4-thuth@redhat.com>
 <20260807152231.15b33daf@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260807152231.15b33daf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/08/2026 00.22, Jakub Kicinski wrote:
> On Fri,  7 Aug 2026 14:58:40 +0200 Thomas Huth wrote:
>> -		struct aes_cmac_key k;
>> +		struct aes_cmac_key k __cleanup(aes_cmac_zeroize_key);
> 
> Nak, we don't like the auto-cleanup stuff in networking.

Ok, if you don't like it, then let's drop this patch.

> If y'all need a garbage collector there're jobs programming in Java.
No need for derogatory statements, Jakub. That's really inappropriate.

  Thomas

