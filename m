Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BACF3603F7
	for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2026 07:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785829377; cv=none; b=H2Skj41OadxPBnjESwV92TMblcJmPs2Sw5zjPTmFPMJPIc8YCNJQ50iVY0yZbhazOkJ2hyMz15hMhhrGoA8pb8ZiS418u0yj6ibB8FTH4NKETiRM8wEqEJ8mt9M49aPP0+Jw2tseYg2QH/LbIKxYHwt1jLmL1G7OGDE2TYzog44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785829377; c=relaxed/simple;
	bh=hc/KLoiXxVRkYrNqWwUeXVLvDfvQcw8+h6tPjXvUgjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ge9FxmXTMy2Ad8xUG96efDzDPBTcqGPHIel/CpGS1h7MsFt0dhFxR58aMc8CR2AI31IL753di/gV8I61L969j1rdUfe99KVAdUN5dcc+XjCJZML0VcTbFquCbRFDZffbRzYahPlHGPdVi3yuRrH7NF/vFTukwhtKsfM7lVjyajQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=crqC5bHH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=M8v3nqi2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crqC5bHH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="M8v3nqi2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785829374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hL218+tFFRsvRbeZEwZ8U/3P+ghElNSwaHgpWQSt+ig=;
	b=crqC5bHHcy6+mDY2X0Bl6WN99YP8PUkxExvD7aE4AXYjoe5DRRddprWguYPGGxx6/9GDhd
	61+H+/UR2STYaPi2+stFcKB+9oSKgCF1uZkLl5vXpqEnfRIVvpPbYsjBpopEDm8LR04yly
	NCP7wh319yLnJ5Zlts/lJ19+pB21Ngo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-_Q_PYCekOyuGsHHZHsLYtw-1; Tue, 04 Aug 2026 03:42:38 -0400
X-MC-Unique: _Q_PYCekOyuGsHHZHsLYtw-1
X-Mimecast-MFC-AGG-ID: _Q_PYCekOyuGsHHZHsLYtw_1785829357
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-492488f8583so28007225e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Aug 2026 00:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785829357; x=1786434157; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hL218+tFFRsvRbeZEwZ8U/3P+ghElNSwaHgpWQSt+ig=;
        b=M8v3nqi2UDa4bXXJumqwszt6EIrT+axnoFrjv1VUodvfx+2l9dtEOQaF+lW+9oIZyd
         X9vQ5sqCl7ptvabJyENBc6Rb4ql5p8Eurceo7O+PZ97yBDL1HIUTnnjGZFfSfORB4CtH
         XmdsoZGcmIly/AfIs4ZJc0epq4yFe1hIPQPsQqOk8zmlpiSzJFShp8gsz76ZbH4jYQ0A
         rj3Z+fsS3zhMADO0ESvcZT0aXQjgkQU+4F9q9AQTC2XyfNXegPYrl8CCE21f5Cu6sa9n
         0zq1vhNIJIUfmLL31yVHNjWTSg27XD7vAGA1++WBQuToEn5o+Xu2W+I3/YbFGZd2Geg7
         MBnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785829357; x=1786434157;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hL218+tFFRsvRbeZEwZ8U/3P+ghElNSwaHgpWQSt+ig=;
        b=leZ2kofuKPBYQXM5qUcrIc3ndIC1Oe3zZ5ksAYzV0lQPW+OQ82JgWKbR/UQY8nHNGG
         7sDOvLGDhHKOtJKL3g4+zGAICzF8uWx94WgXPmxHiZ++MilTlLiQoQC1eFPFmRQsLVJJ
         oS9KHl6/3HlKVpiU03VZySk3m1WmBKukppyN/zRNvRuOSWKPyl8Cy0GgD+GCHGlZ//ob
         3lqGwllgZB7lGaDDe3KhM+CcX0yNaFHmstKep0Rhg5gzK5Nc8GGhvMy71Uti8W/r1Q+r
         OC0k4L2rlkBL/QjnqpBpd99vCsOudnj/A3ZpIfc5F3jxwHxlI7lsQrJWF3oUaYkm1nlB
         UiQA==
X-Forwarded-Encrypted: i=1; AHgh+RqVNp6Y5NcP+baxA4rk3zOlF850WqGLKVs9Za6g/tzOU9/ZPQNumNBKxO7yFTS/nS8nLuVpofrOECjLwYg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrzn27EIfQMqx3G17kND/54ufMtvldt4wS45RRmBt0Qh+kt0FY
	Aam/hoUfFdLBc6hjGZCmtzOq6Yj9km3Y1+jt/8b+0d8grHoBZQifYYTFwVJzy3ujLvnvrZf1881
	u2eZxKqZiyS/Kltfi+S1UVc/EbOLHyo1zNX7lZVHUY7pnzlkABk42MQ5lH25udzbBFQ==
X-Gm-Gg: AR+sD13YgZO0ouPzhLyCFDDlKPiE9N5HJrKIZmDZt3dT8Gdxe5XoAwIkFEGiv9d8ZRD
	rCjYLCvCl8/HZEYSyRG9hiamPHipUaiYGgptvuVA9Ln0jXsLRwRy4BkuU4jaB/IJv9jm0Sxw6+V
	Ll0R17fjH/iQWh4FUlLdJlq96CF0VzFo0Z+ZI+lIKfXJFKMIzy6mc8Rp9fRZirtgS6E1ACb2Fuo
	rzuUQ0IUBimuft4GyqMsC36krpkM4LUC9aLWedml/R+8OM8b6r3+e7xF7BrOgtSQwZfFAQKTPOP
	czAESqU98rYPEP2CuE+UsFV5RWJpZ0LIcSEPsixcFTiK6fSNK23NCARjrHemj7BYQMleu2hC
X-Received: by 2002:a05:600c:5914:b0:495:5cda:52ec with SMTP id 5b1f17b1804b1-4980c662d03mr260931425e9.16.1785829357222;
        Tue, 04 Aug 2026 00:42:37 -0700 (PDT)
X-Received: by 2002:a05:600c:5914:b0:495:5cda:52ec with SMTP id 5b1f17b1804b1-4980c662d03mr260930955e9.16.1785829356843;
        Tue, 04 Aug 2026 00:42:36 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49949fcb46esm75080935e9.5.2026.08.04.00.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 00:42:35 -0700 (PDT)
Message-ID: <46104b3b-ae4b-4255-b7ab-c994a59c9882@redhat.com>
Date: Tue, 4 Aug 2026 09:42:34 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] crypto: Provide a wrapper for zeroizing
 crypto_aes_ctx
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Simo Sorce <simo@redhat.com>
References: <20260803094432.70505-1-thuth@redhat.com>
 <20260803094432.70505-2-thuth@redhat.com> <20260803190540.GD2062@quark>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260803190540.GD2062@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/08/2026 21.05, Eric Biggers wrote:
> On Mon, Aug 03, 2026 at 11:44:20AM +0200, Thomas Huth wrote:
>> From: Thomas Huth <thuth@redhat.com>
>>
>> Several crypto drivers need to zeroize their local crypto_aes_ctx
>> structures after use to avoid leaking key material on the stack.
>> Currently some call sites do this with their own memzero_explicit()
>> call, which is error-prone since it is easy to miss a return path
>> (what already happened in some drivers). Some other call sites miss
>> to clear crypto_aes_ctx completely.
>>
>> Provide an aes_clear_ctx() helper that can be used with __cleanup()
>> to automatically zeroize the context when it goes out of scope.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   include/crypto/aes.h | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/include/crypto/aes.h b/include/crypto/aes.h
>> index 3279cfa546085..5ca7b1ab50e8c 100644
>> --- a/include/crypto/aes.h
>> +++ b/include/crypto/aes.h
>> @@ -159,6 +159,19 @@ static inline int aes_check_keylen(size_t keylen)
>>   int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
>>   		  unsigned int key_len);
>>   
>> +/**
>> + * aes_clear_ctx - Zeroize a crypto_aes_ctx structure
>> + * @ctx:	The location of the context that should be zeroized
>> + *
>> + * Explicitly fills the crypto_aes_ctx with zeroes. This should be done
>> + * once the context is not required anymore to avoid that its contents
>> + * are leaked on the stack or heap.
>> + */
>> +static inline void aes_clear_ctx(struct crypto_aes_ctx *ctx)
>> +{
>> +	memzero_explicit(ctx, sizeof(*ctx));
>> +}
> 
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> 
> I guess we should start using __cleanup with type-specific zeroization
> functions like this more often.

Yes, and I already got some more patches for other structure in the works 
already, just wanted to get review feedback on this series here first before 
sending them out / continuing that work.

> One gotcha is that __cleanup and 'goto'
> should not be mixed in the same function; see the comment at
> include/linux/cleanup.h line 148.  Patch 8 of this series doesn't follow
> that in safexcel_aead_setkey().
Ah, thanks for the hint, I wasn't aware of that recommendation yet!

As for safexcel_aead_setkey(), I think the change should be fine since the 
__cleanup() is declared at the very top of the function and not somewhere in 
an inner scope, so there is no way that the "gotos" could skip the cleanup here.

To get rid of the "gotos" here, I'd need to introduce another cleanup 
function for crypto_authenc_keys first, so if you insist of not mixing the 
__cleanup(aes_clear_ctx) with the gotos here, I think I'd rather drop that 
hunk from the patch for now, and provide another patch series with a cleanup 
for crypto_authenc_keys later that then adds the __cleanup() to both, struct 
crypto_authenc_keys keys and struct crypto_aes_ctx aes here and removes the 
gotos at the same time.

So WDYT, drop the hunk here for now and send a v3 with that, or keep the 
current v2 of this patch with its (hopefully unproblematic) ugliness?

  Thomas

