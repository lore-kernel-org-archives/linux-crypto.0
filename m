Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E933932E9
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 08:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786351412; cv=none; b=UO0z2gV4b89xWLY1CR9JVEv2/0f6JGTYeFDBetviN3HkfAZTym+mBdGbV5cEI9XYa5RU6hIyon1Xmzf+dXqHzSEwAyXyT11TCjLbDbuBnby85Epmi+x026qqNiPbbSb5+YOxcRyMnEZduDyz5yH5TAtXhl09U5l7Bz627+jDcBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786351412; c=relaxed/simple;
	bh=pPL5khEgHmu2fsyrmKe0EB1NFQZmkhZQHz7mF2iI9mE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mp4w8aE99NIxkwL6DbkkoJwIZYu+IYX9xwPwTasVA/HI+T0p2242ulKA6pcwUkmN1z7thDXValWp8x1ne1drGTaby/NOod3/+YjqdGl2lD1OrWt3DgFb8tjqVnCtr4h3uAZ5qglSCnfuSzQhz47aJCVB1b+ZmjRZwsmfaA8JSZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ak4qPRgX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=E0yf8ZPD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ak4qPRgX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="E0yf8ZPD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786351409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6cSi1LXgQkO/X458Y/C3HK1LiSzfooYccuPa4x2B3Oo=;
	b=Ak4qPRgX2TP9kzp/HBlzn6XETKNi/OsYbAsCERAMCe773CD0pfuOLNEIo179BaVGje0XSX
	5i28MDL1AV4Lw1bLqczYMM/THAqnzX+Pee9V4nquIOrVM60Gvy3updfOg55Q6aIn5/ZtHS
	JEVMyHvA0spiXRu7BVl+veu1f01dWAk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-yW4HqOn9P8SkPk39TO47kQ-1; Mon, 10 Aug 2026 04:43:27 -0400
X-MC-Unique: yW4HqOn9P8SkPk39TO47kQ-1
X-Mimecast-MFC-AGG-ID: yW4HqOn9P8SkPk39TO47kQ_1786351407
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-475e540a0ffso934629f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 01:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786351407; x=1786956207; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6cSi1LXgQkO/X458Y/C3HK1LiSzfooYccuPa4x2B3Oo=;
        b=E0yf8ZPDRrvk6YnO5pwvN21OZRU0mfSfNMLkMNaligWCYeF07SZfOop0YzHGHT+vye
         48gNpZliC8MxSz5UQXsdTAgmQLgjND2W0EWl4Kbn9WJgcGpzKkL8CEQwnwgfQPngGoEs
         ibmmt/B9DM+QGugPW7hvVzrCdTKAy74ddvUN53NtD30SIGtbtsNBsw765c2O6cpuH+2f
         3zyMsss9d7oqshcXfFNZyDH7baJgz6+4Q7ITCFtzm+JAIImrQRIuVDmTAaWiEbAZ3i36
         vH+dc5VSGkcV/+1Xs7DwBGZm9yRqEh9l9He3NyxH/qVC8wzZ3rsAqBVp4fLYIBH6C3sr
         niDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786351407; x=1786956207;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6cSi1LXgQkO/X458Y/C3HK1LiSzfooYccuPa4x2B3Oo=;
        b=AiXcgmu4BX8wBGqPI/ky9GaU6XMvJ0k0/3m43Dyrb9kFsvd5NXF7w00llTxumaX2AC
         o4QgEJ1BKdp5DEawJeJGaE5WTRT14SB+s0s3jvI8czFxD8Nglj6P7RMUpKDlc5u3b1Gm
         Qk/P2YnFzALDyXIkur295pM9SmYz2rp9iJAMP9ZiYGxwto3mii1eTIIaadJPC6u7TMFm
         ++pfDQBsj8Nlyx4XwUPHDtiQiDpJJfk2KzPrg7LNikYCd3madxKEYTadqEs1JDBOU4Wo
         OYi1uvZlG78/qbb7325HxxB8xkXTtwINIQyExLvmNd2L4zT+oN/A23XjPjwLLFi5Qw+w
         +fcw==
X-Forwarded-Encrypted: i=1; AHgh+RogEcG8JRyp1ueLFV2oTD5Z8ylU6ncVEBGev8Co09qYfOJLxIMiL0E/BLrcciwO/qhzeVMUHncrKqktfGw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7VuUdyytVWnGWdFyrx5cJL3xxEnj4OwcyYh/MU46lW1xv8zuM
	s2Z5a+h3YTkM02b/UVNe2Rp/wZ2lVvYR1JCqYkM5a4p8qMdndBg0Jjqg3Bfl5l1FNOljcY7I8s3
	z0Dz3uIjhexBH7tC6SePBe9Ze5iwjC+BIOYJ6KneiMh4NhWz3cUZH7TE4e4NAo3ehrg==
X-Gm-Gg: AR+sD13q+RP5y+zp2camfrwHbOyWjz0MHjqZfJ1ErEiACtgFpt6QKX/UqeW+bWibMRC
	ok89sOfgHwkyjsdo7auHl+D8jqh+GkrBQa1y2HJfvIYOkzapTQISzC7DuR7qkyKtFafz0G/VyFn
	YyUV3bZnD0i2+BU/+rFzd8wAo4VcDuG0Su/eXHiZ9orfIuzBPdFI+sTzRdidiRRYwgKcCgpMN/e
	kt2L1lst4O9iV9bcMnIZSoIPkkiYtBBieUQPTGNgzG30KBOCsXqIvizWsZerMYz0Bd+dE4uZbyc
	AoAPT5uXaJtLa4vXxb5RG/R0Z2l7Sr4VBuaEyomlKiBHC/xdHyICJ+6hl32ivUgU+qdoszJo
X-Received: by 2002:a05:6000:2f89:b0:47f:9171:bca2 with SMTP id ffacd0b85a97d-4814564fec0mr169131f8f.27.1786351406719;
        Mon, 10 Aug 2026 01:43:26 -0700 (PDT)
X-Received: by 2002:a05:6000:2f89:b0:47f:9171:bca2 with SMTP id ffacd0b85a97d-4814564fec0mr169098f8f.27.1786351406383;
        Mon, 10 Aug 2026 01:43:26 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800214557esm30699757f8f.2.2026.08.10.01.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 01:43:25 -0700 (PDT)
Message-ID: <b2034bb2-6085-4fb8-9704-ecbac10c8fe8@redhat.com>
Date: Mon, 10 Aug 2026 10:43:24 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/10] crypto: safexcel - Rework cleanup of sensitive
 structs in safexcel_aead_setkey
To: Antoine Tenart <atenart@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
References: <20260807070651.228713-1-thuth@redhat.com>
 <20260807070651.228713-10-thuth@redhat.com> <anWL9TltGiN0QAFg@kwain>
 <anWPtWKdJFUoe2Pq@kwain>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <anWPtWKdJFUoe2Pq@kwain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/08/2026 10.02, Antoine Tenart wrote:
> On Fri, Aug 07, 2026 at 09:40:58AM +0200, Antoine Tenart wrote:
>> On Fri, Aug 07, 2026 at 09:06:36AM +0200, Thomas Huth wrote:
>>> From: Thomas Huth <thuth@redhat.com>
>>>
>>> The crypto_authenc_keys structure only contains pointers to keys, but not
>>> the key data itself. So explicitly clearing the structure at the end of
>>> safexcel_aead_setkey() is not really necessary, see Eric's recommendation
>>> here:
>>>
>>>   https://lore.kernel.org/linux-crypto/20260804185402.GD2904385@google.com/
>>>
>>> On the other hand, the crypto_aes_ctx might contain sensitive information,
>>> so this structure should be cleaned up at the end instead. Do this
>>> now via the new __cleanup(aes_zeroize_ctx) marker.
>>>
>>> Since __cleanup() and gotos should not be mixed in the same function,
>>> replace the gotos with early return statements, which is fine now that
>>> we dropped the memzero_explicit(&keys, sizeof(keys)) at the end.
>>>
>>> Suggested-by: Eric Biggers <ebiggers@kernel.org>
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>
>> Reviewed-by: Antoine Tenart <atenart@kernel.org>
> 
> Actually I think we could do better here:
> 
> The AES key is expanded in safexcel_aead_setkey using aes_expandkey but
> the result (the aes variable) is discarded and never used. This seems a
> waste of CPU cycles for doing a validity check on the input key, which
> can be replaced by a simple aes_check_keylen.
> 
> The same applies to the EIP93 patch for both chunks.
You're right, using aes_check_keylen sounds like the better idea here. 
Thanks for the hint! I'll update it in v5...

  Thomas

