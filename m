Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A79B376BEA
	for <linux-crypto@vger.kernel.org>; Thu,  6 Aug 2026 08:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004302; cv=none; b=Wad085LhQFr3zhtLEDxfBAQ/STmGwxYvzRWWuh1N6ZKKGvEwotSh/gq4zD+MhVLRPQyHX+7jeMohXZaGKAjoBMI0FmbD463wVTwMG/JueMzNCP4OqE9BgjHiE16EzIHS801O9MLinj2e0K5rH311JZ6X/ekNx10PWcEbLDEKF78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004302; c=relaxed/simple;
	bh=ix4w6E9OhlpAAnlkuDAejW6q71jAQztfmU4WVHH/v48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UTM92JLndLi62+JUM+8FIR7/quIzl525qUOCmO1wYqJ9Up7+Fe/hiGQDnM8t+W5OEIeYrn67Y/UgIOqF6LWI4805AW2RwGM57wA9VRb2KQP8VQwjT6QryjykrdezHJ+8TGXaJs44QdaHWD5yoK9S3wUMiChMmm9MRQeu+AhiCck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rpf9UFWU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XnQpFfvP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rpf9UFWU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnQpFfvP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786004300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uLmr4nKuDA7V4EE88WXZWru75WuN3VpuVD/Fka0D5Fo=;
	b=Rpf9UFWUN5kpJrCMb8JUeojHrvPFuHoufo9yM9iGQkcB/N/ObrqLP0EXOAlWshsHvIC7sv
	FA9i+HtrZurYoZdB1RNO7l53YZULJXMARKHTZdTHCo5YTtL69TGVSnaFIo+sFzLidy8gy6
	OpfAqSmfqeth8favUZ4tvl22fzCrUHg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-Z1ez5DtRNMCQf-WjrTsZGg-1; Thu, 06 Aug 2026 04:18:16 -0400
X-MC-Unique: Z1ez5DtRNMCQf-WjrTsZGg-1
X-Mimecast-MFC-AGG-ID: Z1ez5DtRNMCQf-WjrTsZGg_1786004295
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49808ea1b64so8171685e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Aug 2026 01:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786004295; x=1786609095; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uLmr4nKuDA7V4EE88WXZWru75WuN3VpuVD/Fka0D5Fo=;
        b=XnQpFfvPBTWZReHBdPIoJ7/p5MqhQduaXYHyHim0BIMKIvsL+Efk0bXvrssgSfPRuk
         o59kYK6VHkf61ywlxdS2uPhxeUIQXizrmXvvQc/r3cWfvcPlf440ZQX4Ejgjf7V7V+lH
         OQuRnnYs9w3RnG+LVEvi/wZsuWA/XnJSBOUFL4pt4NDJ5b3pbXhNwt/2gz4sbBzlLE7H
         T4JxE2n0WA7GdCwT0I0g36eriTRzK1eRAhYDCbETg76WLaTqTAmz3VhQT8XvWk+Mf8xj
         1n+Dr6J3Iu2A3JFmu4JCWLYx4g4TcETRQTyq19wyQpApLq6N/jgYvsY1FCBi4+7umOmE
         S7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786004295; x=1786609095;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uLmr4nKuDA7V4EE88WXZWru75WuN3VpuVD/Fka0D5Fo=;
        b=du9pr1tRXmfgyLZ6CAqNE9NI7I9BHphOugBsS2oEGnXDtRseuPozGkxjrF4SOIcwGD
         nVw3ICcFAehh5w8cxjRXfYkdxvB2Hl1jm0X0R+aPyWPpB5sN3Bb5+mHMWpQ8OGzY4lOH
         Ae98zpFsjhstqcgUXXQ3X9+qZdlF2GZv3BhCVikQVuwKuQI9CsrtkE8EiIuxJpCTFJto
         xZ9brBkKAsH03hOIH5CR25KLii0UFav+5tYB+uI3ZjXhv7JBuXK10fGTu8Sc6mDbKb8d
         iNUdKm8+uLl1sN7QUiWAlB9eECVCKuQ6sBPg8kBavBNcsTJbMKYcZFsXayR58m4lQ9w+
         HBjQ==
X-Forwarded-Encrypted: i=1; AHgh+RqVqHt5t4s0Quq7uSFuSHXGai7gF2hOYA9+TfeLztHuBeEud2gKlMD7H4MpwcprLeLld2XK7yuL0psMPsc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWlYG9+Z7iMK6n1quujp+7etTLBqBwDqFB7sH2oEZoFbhdxKWq
	PmQj/MFE5cjCYymW0qO4CLnCpO54jzwctLPqBZEz8wlSNND+RJinsCAcNN3tX8jUvSrdDOAA1Nt
	xztMXoeKRifpa4i9tOP+pQXn3TFg89eliGKz1QUFAw0vJrvMZz0ALVtukq+Hb54ePHT4qwDbbPA
	==
X-Gm-Gg: AR+sD13BDZtCf+TS1U/31UaDDIxxChNrWj6EjuRwmoZ4YZrRZIrdeCJdDVsskkGwrOv
	XSgXt5pZLcy1xv7qNBahSWPr3UaJUKXrWytznYQi4QL3iSb4hR1EXlhvlDUv5a0gFFqoQnMcToN
	I+myDuscKit9AlY6lVtucNLhXSykI6OsFdeqZ+yTJ2EEzYpFzUUSi1F3k8auvk8fIVxqpy9koNd
	PIUA3hZybYjLvUO8qwLvYm8PZdhYhis+ngpXhNk+W+l2qfIvz24JRN7WLb1HsH//dulcsGIc+Ze
	na28NGX2jKhVWZrCEvoKNfZ95H1XiYJBfXZT4wDUyWn6Ds1lVFtzol1uNfJ+OmAG1/uDbb+o
X-Received: by 2002:a05:600c:4454:b0:495:3a52:71b1 with SMTP id 5b1f17b1804b1-499553d5ab1mr29805465e9.5.1786004295573;
        Thu, 06 Aug 2026 01:18:15 -0700 (PDT)
X-Received: by 2002:a05:600c:4454:b0:495:3a52:71b1 with SMTP id 5b1f17b1804b1-499553d5ab1mr29804995e9.5.1786004295142;
        Thu, 06 Aug 2026 01:18:15 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49954246f9dsm51116545e9.15.2026.08.06.01.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 01:18:14 -0700 (PDT)
Message-ID: <7c456e18-0fff-4d06-a94d-66807b9777ad@redhat.com>
Date: Thu, 6 Aug 2026 10:18:12 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] crypto: safexcel - Rework cleanup of sensitive
 structs in safexcel_aead_setkey
To: Antoine Tenart <atenart@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
References: <20260805115749.392672-1-thuth@redhat.com>
 <20260805115749.392672-10-thuth@redhat.com> <anQ9UdZqmj39hfgD@kwain>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <anQ9UdZqmj39hfgD@kwain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/08/2026 10.10, Antoine Tenart wrote:
> On Wed, Aug 05, 2026 at 01:57:47PM +0200, Thomas Huth wrote:
>> From: Thomas Huth <thuth@redhat.com>
>>
>> The crypto_authenc_keys structure only contains pointers to keys,
>> but not the key data itself. So explicitly clearing the structure
>> at the end of safexcel_aead_setkey() is not really necessary.
>>
>> On the other hand, the crypto_aes_ctx might contain sensitive information,
>> so this structure should be cleaned up at the end instead. Do this
>> now via the new __cleanup(aes_zeroize_ctx) marker.
> 
> Looking at other crypto drivers it seems zeroing the key pointers was
> explicitly added (sometimes later) and my impression is a good chunk of
> the users are zeroing it. I don't know whether removing that is fine or
> not, my limited understanding is that provides in-depth defense against
> leaking were the key reside in memory. Would love to see an explicit
> statement from someone with that knowledge.

It has been suggested by Eric here (unless I got him wrong):

  https://lore.kernel.org/linux-crypto/20260804185402.GD2904385@google.com/

... I should have maybe added that link to this patch description ...

> (On the other hand mixing gotos and __cleanup is not advised but is that
> an issue here? Or if zeroing crypto_authenc_keys is actually important
> can we use __cleanup too?).
> 
>> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
>> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
>> @@ -407,17 +407,17 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>>   	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
>>   	struct safexcel_crypto_priv *priv = ctx->base.priv;
>>   	struct crypto_authenc_keys keys;
>> -	struct crypto_aes_ctx aes;
>> -	int err = -EINVAL, i;
>> +	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
>> +	int err, i;
>>   	const char *alg;
> 
>> @@ -430,25 +430,25 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>>   	case SAFEXCEL_DES:
>>   		err = verify_aead_des_key(ctfm, keys.enckey, keys.enckeylen);
>>   		if (unlikely(err))
>> -			goto badkey;
>> +			return err;
>>   		break;
>>   	case SAFEXCEL_3DES:
>>   		err = verify_aead_des3_key(ctfm, keys.enckey, keys.enckeylen);
>>   		if (unlikely(err))
>> -			goto badkey;
>> +			return err;
>>   		break;
>>   	case SAFEXCEL_AES:
>>   		err = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
>>   		if (unlikely(err))
>> -			goto badkey;
>> +			return err;
>>   		break;
>>   	case SAFEXCEL_SM4:
>>   		if (unlikely(keys.enckeylen != SM4_KEY_SIZE))
>> -			goto badkey;
>> +			return err;
> 
> 'err' is uninitialized here. You can use '-EINVAL' instead.
Oops, good catch, thanks! I will fix it in the next version (assuming that 
removing the memzero_explicit is ok and we'll keep this patch...)

  Thomas

