Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804F93BFAD0
	for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2026 15:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787152595; cv=none; b=ORk9p3gt/a3tYYZJbQiczISPL1HtDjhsqK/ClneDC40d0XippLBgNAB0eHX0FGkz8yFNJ/ER08HjuzWf96RWYQ49Af+J0UUmp+2988WbBffCB8+OPWBnhaOLSUcgkgQYZpR4r1sZFD/cQePMQQyVRPhNL145EdRXm7LIh+giq5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787152595; c=relaxed/simple;
	bh=c7SNQbihKrV1BvcLCqZktQ6R4fuRJM0LWhSnFjZtQq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KltM18fzJJZeNzY2E/DjZgZ8mus6+4MwczZh5qAvJDwzBeADeZ0f8f+zZ4xNwzAN/Zk0b1Qk+AOBk/da3rj8vY2OShBQzUmcVkW916i/t1Q2MqI/a2Cw3btsuahQbeawPJhpGTBMJ9U66eRv8kRH+HQlWOAVZPuSrZvzadwWato=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cVjL+Lju; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=p7eMd5EP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cVjL+Lju";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="p7eMd5EP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787152592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/pCp01H5q14BGWDagpRfB3mWzEt3z0AEMKWpYdOxzSo=;
	b=cVjL+LjuMeNFx+fSvXsdM3rUNj9DriKX4omsWxTYjKMaQwVShM7A66QbhgZXxxc8vzkDP4
	odQAOSldRbZKx71zlwrmdTSj1pD7qYFuDtJvcM7OT3eMtL1Y87KDFb5yv4W0QUUgiDSZ3z
	ZdR4adEndq+d5kshtVw3LaYTwgLsshs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-kzK1OshmPiCgJJNsgf7KwQ-1; Wed, 19 Aug 2026 11:16:21 -0400
X-MC-Unique: kzK1OshmPiCgJJNsgf7KwQ-1
X-Mimecast-MFC-AGG-ID: kzK1OshmPiCgJJNsgf7KwQ_1787152580
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47485fde05aso655213f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2026 08:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787152580; x=1787757380; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/pCp01H5q14BGWDagpRfB3mWzEt3z0AEMKWpYdOxzSo=;
        b=p7eMd5EPSyqj9hrwSvmFonpXtcSBzuxpBOaQ8llHPut6Uf++iwQLB6ziJz0fyByCl+
         i7COPR7SfgCsifGbTlZzEqvs/ypDcLJN4HLoCR07A2zTHaJT2mGBQLyVik7jNTK5l5kC
         HdjeMEreaqSxg3ead+t0M8KjqHz3W1w2E+MyyGi6WE+jteTz3V5CtR4XGPRzveZol8Rk
         W65h5xvsIeEBHIIrC5Va9i3l3ILGgtAShV7Q/lJkCcb7pDLrjEx5Iekk87LShm174r3d
         UredxkxsVy3tGlHwBMhTygtwzXvHTjvfrChVYeVAWCVz2AYbEhEvqul2G0R914957hkv
         k5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787152580; x=1787757380;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/pCp01H5q14BGWDagpRfB3mWzEt3z0AEMKWpYdOxzSo=;
        b=MKFAmWMUhatNV1v0dXmSrbXGJPXyZ3rc4fUX1jFr/LlAFvhbGX6ldIxigUGjttutYn
         fwgagx67vd39yZHob4pUhNcSbigX/KvShSJZA1v6U0L1G2ZgVzUvZPNNx9uqCjsNMkW0
         c+00w0fwKFw5X2QHNiWR8enWz1k3fK7m0HsAwoVn1odHp5xc+shlQ4oSFHpK5k5eUhWc
         /ngQAZ6ozZchtP9UsNqIn4d1PDtdSZ45/2rBfFF84uLBKMpqukhFL88JQsc8ZWKKyA5Q
         LA+XTrZm74Jx6AjETAeUJ+dWN5ML/gIzJdVG9+lc8G1N1f4NDmZJrpzyupXZ98u8pBTP
         W2sw==
X-Forwarded-Encrypted: i=1; AHgh+RpcedQibbEVqcg0an1iDpvWD/jixSJg3/7t0YCKgxrnkQFGvXVY3bMbJ5NyuwGcwW5L67Jgeu3JCJ8qWV8=@vger.kernel.org
X-Gm-Message-State: AFuF++mDikBh0xL/+/pwVSdqNYWbtnhQIgBPru1Ahn9FWqlOJza3k6tx
	QkD3MDD67YahCgujJrXkca8FzBP+ttjTrtkU6g7q0tDz1g2+dpuXG3gDLYNauu5fh1OkEeKjmr3
	dKZRjEm8aMxeBFk2eOXKprim7xiNvyZ7TFgeNXsP3C+vIwGEX6LB4O1dbEHHvHngbQQ==
X-Gm-Gg: AR+sD11gBNqwYrd8XNL5EJoCmF3ZpJojLfhhX/ya9V2qGXRIQjkAa9t41IoseWram0B
	cSCRN3oC4vEbZbUJilpEn0qwEtVmUZYir5xDykarBHyjP3/fLjxUxAe4+KmNxogssjOyYJpGNv/
	tf/1uCwXFFQrn9hkMPpxCm/e+nvJ5Pt6udSjwjSavne4JpDZpGfTaPMwax5Mc2gF3ErEDyPrOU0
	REZ+p5RXqvy7AJMFCU6m5Zs7LkKqMyQCn6IihphpusKg36EW+h8qjzQRvZ3Afe1y9M0KJnAFRuV
	VhqXunKPyP2KqN3czLUqhQytv4+3KsbSuuX4kOq4PIGY6h8oOKF8wX/um6vueWcUCips0vUb
X-Received: by 2002:a05:6000:98d:b0:47f:95e8:2ebf with SMTP id ffacd0b85a97d-482b1fd7137mr10553414f8f.12.1787152579795;
        Wed, 19 Aug 2026 08:16:19 -0700 (PDT)
X-Received: by 2002:a05:6000:98d:b0:47f:95e8:2ebf with SMTP id ffacd0b85a97d-482b1fd7137mr10553301f8f.12.1787152579445;
        Wed, 19 Aug 2026 08:16:19 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.113.47])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b14514d5sm6455707f8f.10.2026.08.19.08.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 08:16:18 -0700 (PDT)
Message-ID: <0ab5030d-7740-4c3c-af7d-e488d124bf16@redhat.com>
Date: Wed, 19 Aug 2026 17:16:16 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: inside-secure - Zeroize temporary arrays on
 stack with sensitive data
To: Antoine Tenart <atenart@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Pascal van Leeuwen <pascalvanl@gmail.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260819105836.156251-1-thuth@redhat.com>
 <aoWWgixBpVypLoWx@kwain>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <aoWWgixBpVypLoWx@kwain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/08/2026 13.43, Antoine Tenart wrote:
> On Wed, Aug 19, 2026 at 12:58:36PM +0200, Thomas Huth wrote:
>> key_tmp[] in safexcel_xcbcmac_setkey() and consts[] / _const[] in
>> safexcel_cmac_setkey() contain crypto key material that should not
>> get exposed to the outside once the function is done. Scrub the
>> arrays with memzero_explicit() to avoid that the data could leak
>> via the stack.
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Link: https://sashiko.dev/#/patchset/20260813134953.979481-1-thuth%40redhat.com
>> Fixes: 38f21b4bab11f ("crypto: inside-secure - Added support for the AES XCBC ahash")
>> Fixes: 7a627db9cafdb ("crypto: inside-secure - Added support for the AES-CMAC ahash")
>> Acked-by: Antoine Tenart <atenart@kernel.org>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   v2: Added "Fixes:" and "Reported-by:" tags
>>   
>>   drivers/crypto/inside-secure/safexcel_hash.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
>> index 3402e570d045c..1ae6fbec31298 100644
>> --- a/drivers/crypto/inside-secure/safexcel_hash.c
>> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
>> @@ -1993,6 +1993,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>>   	ret = aes_prepareenckey(ctx->aes,
>>   				(u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
>>   				AES_MIN_KEY_SIZE);
>> +	memzero_explicit(key_tmp, sizeof(key_tmp));
>>   	if (ret)
>>   		return ret;
>>   
>> @@ -2104,6 +2105,9 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>>   	}
>>   	ctx->cbcmac = false;
>>   
>> +
> 
> Sorry, I just noticed there's an extra empty line here.
Oops, that's embarrassing, not sure how I missed that looking at the patch 
multiple times already... Thanks for spotting it, I'll send a v3.

  Thomas

