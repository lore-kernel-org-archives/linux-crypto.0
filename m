Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586824EC647
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 14:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788789689; cv=none; b=dzUG0j5u9z8sNa/RrRCaAPKhN5q5T0OAZkIppyQ6dNMRHMEoU/ourRBMqawdrdr4kFguMGPFhkqze9pyME7tXuqplFTlkSOB3UP5g6MhflZJ8YM3kB/GaErmlpUM7Te9Ga7OtgxID/Z5jPpRZ6q824dHzvY7Q14YcK96SVW3tWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788789689; c=relaxed/simple;
	bh=mtWx82lL+mkn6H7qvwjYU8EhK19cwUGjNz3GK+cHBfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QtBRedoyatjUK/8nAxavwfVo3w+LHQ/NcEQrPpC3YKH2s5Mcoh2FtNnGLDcwy1YuoHqhJTDQ1XVuVA/V4gJPAurctrGc+d47HGqv3V8YRESjMn6HM6x6S3SWqceUf2fv90lIqLtmzRVopkuczQ4/DqW+YhmuygSnOTqSwXhpiGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hlXwnM76; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVTk3uR0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hlXwnM76";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVTk3uR0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788789686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wmNJ8pkG4NaybST+4CQ0Bt5G1lP5T2gnC5sE7tY1xPA=;
	b=hlXwnM76eEKUm6vt273bUd7+B0ouGf2Iqoamx5fXYrIZ8YAcldkzRTfi4w6tBt69mUSmFo
	WqOBxQ8VLTWE6sY3xO0pOSBxYNjVfAyHoec8xZNQvmHZ1DlcDnUbYsOb5MqCH/WGtkh+yC
	PI1ygU2/BfI1PaDJNEsXKH2Nc4VZsAQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-kXxOHYh_OxS-acWwzXwQug-1; Mon, 07 Sep 2026 10:01:25 -0400
X-MC-Unique: kXxOHYh_OxS-acWwzXwQug-1
X-Mimecast-MFC-AGG-ID: kXxOHYh_OxS-acWwzXwQug_1788789684
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a801494eaaso2298625a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 07:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788789684; x=1789394484; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wmNJ8pkG4NaybST+4CQ0Bt5G1lP5T2gnC5sE7tY1xPA=;
        b=GVTk3uR03MB84xZ3tA+w07jUStHCRomLnYCMGpqXaX6GJyR3XHV4+F38RzrW18QWD7
         Cy11fO3BqdfCnCKtX3JNzPUesiA/vrAmrjXWBffl0R2+5GorJL2gHH/beUNMLfVDCXru
         ekUdq0PdrQEqy66aMZgP56etBrSvySwj4+tuUyUTt8KtmxFV4YXSMWNYY7AkSN+FcamE
         28MM4i6wRI4QwsO1Qk9z0p6WuKf99sR57ct5JGIIJdlnC2ctFVz08PVNBCAuJ4n0CqSz
         fBGM2CLxvgUmQV4qSXZ1sdlTgLYY6Gx0eUpshZDHyn0EhwsQMh9a4iX2vZcFxJF2a5iD
         0f1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788789684; x=1789394484;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wmNJ8pkG4NaybST+4CQ0Bt5G1lP5T2gnC5sE7tY1xPA=;
        b=ec+8/yxYAHZ4poexhxaYCPYC0tBuqW577lnUCTDrm3+kK9G5uCozs6VApXiPMb7edR
         gsAtYhAvO9PbHQEGSWk3QIkh42e4yWexIhCHgZos4EhDx5Koa8F0VMZBT/sOUu3883xh
         3ixlxEfcK2H3c5UBMA1xq6iSrAXK/KOImhovq+GbcmtfyBT/DxiqNqIJOU7O8bP+D0bp
         oUDjn6HEuKaZADbl5zQpz5eqKORElmP0vTxoMAt9dMhM/FXSA/Cp34oC5PQ6axs63NAu
         yx1bTl3y/kGrEWIk21dqzYYtWcBr/K9QpegT8xQoFap4lwugDXIUVzgWsPSRG8sPTVwf
         IXyw==
X-Forwarded-Encrypted: i=1; AKwUvByAtYZHpwV7D72UkObstEjPtfst+jquHru9ryb5+NutwCtmbe73t0i4T0uBo6dFsq0b7O9e03PuTAOzz+8=@vger.kernel.org
X-Gm-Message-State: AFuF++no4UXSLRpJ6crhGCDN9QzTcf5MHJtJCvTKPFA08IZ0fhgaM0Ui
	oIIWrhjLbHbyI7RpEUIkA2/9DGdUliMpYqWRAM4RqWT8aSecizaxm58wKeTlfvlGB6Z7cz/cMz6
	9kn8Nl9xokvAmdf5wHFJyU2sF8rKT6j/XLObCQjlOTuM8qiZaQlGK5LX4hQi1c3Dw+Q==
X-Gm-Gg: AYBFou3CjPFpZLKF2vQtvsBdD0eT0wXJ9Ay/5boO0rA71F3/Lp1fdzxSZvCp4QiDgD7
	Yn+TDmxQGNAd4MLfj8FnJ9QYoUsC59DpEDP0ji60+ZJTAvghhLR9KChljBY7yeNEtcQEteBSYip
	ElXxktPRYY63FEG0hFAOXnIqPxhyawI1FG+1ziZmUMbKdX2c7aDV97x0obVP1GPxLz3JxMyKI9w
	Ar1+UoiRGQTTzTXfaMQ549qgOyEYOTNcXWvoT1TYc7adHCmfdg5V8bUJZk5mU42lREToi2u99WE
	aoC3h8IKGRWtjb7HJ0fFD1kbhatfklkW8ejOlDVkVpL7iz8pb2zRaEqmNKDwHR7F0SfAD0Q7
X-Received: by 2002:a05:6402:a0d6:b0:6a7:ea54:38f with SMTP id 4fb4d7f45d1cf-6a7ea542648mr7202881a12.32.1788789683584;
        Mon, 07 Sep 2026 07:01:23 -0700 (PDT)
X-Received: by 2002:a05:6402:a0d6:b0:6a7:ea54:38f with SMTP id 4fb4d7f45d1cf-6a7ea542648mr7202845a12.32.1788789683010;
        Mon, 07 Sep 2026 07:01:23 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.113.70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6dfad6sm474269766b.60.2026.09.07.07.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 07:01:22 -0700 (PDT)
Message-ID: <165e590d-7c04-41e4-985b-af368e1e1507@redhat.com>
Date: Mon, 7 Sep 2026 16:01:21 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] libcrypto: Provide more __cleanup functions for
 zeroizing data
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813134953.979481-1-thuth@redhat.com>
 <20260901001245.GA220448@quark> <20260901165355.GA2775257@google.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260901165355.GA2775257@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/09/2026 18.53, Eric Biggers wrote:
> On Mon, Aug 31, 2026 at 05:12:45PM -0700, Eric Biggers wrote:
>> Hi Thomas,
>>
>> On Thu, Aug 13, 2026 at 03:49:38PM +0200, Thomas Huth wrote:
>>> Code that uses crypto-related structures (containing keys or context data)
>>> should zeroize their local structures on the stack after use to avoid
>>> leaking this sensitive material via the stack when the function returns.
>>> Using the __cleanup() marker is a very elegant way to assert that the
>>> data is zeroized without having to painfully verify that each early return
>>> in a function might miss it.
>>>
>>> Thus this series introduces zeroization functions for many crypto-related
>>> structures that can be used with __cleanup(). The series focuses on the
>>> introduction of the functions - most call sights will be adjusted to use
>>> these new functions in separate patch series later (since each subsystem
>>> needs separate review from the corresponding maintainer). However, I
>>> already included the two "safexcel" patches, since they already got ack'ed
>>> by the maintainer Antoine, so I think they should be fine to go via the
>>> libcrypto tree.
>>>
>>> Note there is one minor ugliness in patch 10: Since sha2.h is also used
>>> in the x86 purgatory code, and that code ships with its own implementation
>>> of string functions, we have to compile the purgatory.c file with
>>> -D__NO_FORTIFY now to be able to include <linux/string.h> in sha2.h.
>>> I hope that solution is OK (especially since the sha256.c file in the
>>> same folder gets that treatment already, too), if not - I'm certainly
>>> open for other suggestions here!
>>>
>>> Thomas Huth (11):
>>>    lib/crypto: aes: Provide a wrapper function for zeroizing
>>>      crypto_aes_ctx
>>>    crypto: safexcel - Simplify the check for a valid AES key
>>>    crypto: safexcel - zeroize crypto_aes_ctx with
>>>      __cleanup(aes_zeroize_ctx)
>>>    lib/crypto: aes: Provide functions for zeroizing aes_key and
>>>      aes_enckey
>>>    lib/crypto: aes: Use aes_zeroize_*key() instead of memzero_explicit()
>>>    lib/crypto: md5: Provide a function for zeroizing hmac_md5_ctx
>>>      structures
>>>    lib/crypto: md5: Use hmac_md5_zeroize_ctx() instead of
>>>      memzero_explicit()
>>>    lib/crypto: sha1: Provide a wrapper for zeroizing hmac_sha1_ctx
>>>    lib/crypto: sha1: Use hmac_sha1_zeroize_ctx() instead of
>>>      memzero_explicit()
>>>    x86/purgatory: Compile purgatory.c with -D__NO_FORTIFY
>>>    lib/crypto: sha2: Provide wrappers for zeroizing SHA2 hmac_sha*_ctx
>>>      structures
>>
>> I'm taking a look at these again for 7.3.  This is still missing quite a
>> few of the crypto library structs.  I would prefer to handle them all in
>> a consistent way.
>>
>> Also, given that we'll end up with a lot of these, we should be
>> thoughtful about the kerneldoc.  Using aes_enckey as an example:
>>
>> /**
>>   * aes_zeroize_enckey() - Zeroize an aes_enckey structure
>>   * @key: The location of the key structure that should be zeroized
>>   *
>>   * Explicitly fills the aes_enckey with zeroes. For example, use it with
>>   * __cleanup() for local aes_enckey structures on the stack, so that their
>>   * content is not leaked when the context is left.
>>   */
>>
>> It's not clear what is meant by "context".  And it doesn't explicitly
>> connect the zeroization requirement to the lifetime of the struct, so I
>> don't think it makes it clear when this should be called.  It also says
>> nothing about kfree_sensitive() which many users should use instead.
>>
>> Meanwhile, aes_prepareenckey() already has the following, which at least
>> connects the zeroization requirement to the lifetime of the key:
>>
>>     * The caller is responsible for zeroizing both the struct aes_enckey and the
>>     * raw key once they are no longer needed.
>>
>> How about we remove that and the free-form description of
>> aes_zeroize_enckey(), and instead expand the comment on the struct
>> itself:
>>
>> /**
>>   * struct aes_enckey - An AES key prepared for encryption
>>   * ...
>>   * Once prepared, users must zeroize this struct at the end of its lifetime.
>>   * For stack-allocated structs, use __cleanup(aes_zeroize_enckey) to zeroize
>>   * when the variable goes out of scope.  For slab-allocated structs, use
>>   * kfree_sensitive() or else call aes_zeroize_enckey() before freeing.
>>   */
>>
>> That would connect the zeroization requirement to the actual struct and
>> its lifetime, and make it clear how to handle each case.  It would also
>> make it clear that stack allocation is supported for this struct, which
>> might not have been obvious before.
>>
>> aes_zeroize_enckey() would then omit a free-form description, which
>> makes sense as it's a trivial wrapper around memzero_explicit():
>>
>> /**
>>   * aes_zeroize_enckey() - Zeroize an aes_enckey structure
>>   * @key: The aes_enckey to zeroize
>>   */
>> static inline void aes_zeroize_enckey(struct aes_enckey *key)
>> {
>> 	memzero_explicit(key, sizeof(*key));
>> }
>>
>> Similarly for all the other structs, of course.
>>
>> (For the hash contexts, the struct comment should mention that the
>> finalization function zeroizes as well.)
>>
>> Does that sound good?
> 
> There's also the subtlety that __cleanup shouldn't be used in functions
> that are already using goto-based cleanup.
> 
> And any kernel code preparing a key also has the raw key too and has to
> zeroize that too, otherwise doing so for the prepared key is pointless.
> 
> ... unless it's not actually a secret key, which sometimes it isn't.
> We've been getting a lot of zeroization patches that try to add
> zeroization for public keys, which is nonsense.  And also for pointers
> to keys, which people confuse with the keys themselves.
> 
> There are also Rust bindings being proposed, and they handle zeroization
> by calling memzero_explicit() directly.  So that's yet another case
> where these new functions are not applicable.
> 
> I'm increasingly thinking that we shouldn't try to explain all the
> zeroization stuff in the kerneldoc, and instead add a documentation file
> in Documentation/crypto/ that properly explains the conventions for
> crypto key zeroization in the kernel and defer to that.
> 
> The struct-specific zeroization functions are still worthwhile, but I
> think they should be seen as trivial wrappers around memzero_explicit().
> So maybe just add all of them with minimal comments like I suggested
> above (maybe even just add them for all the algorithms in a single
> patch), and add a file Documentation/crypto/zeroization.rst separately.
Ok, makes sense, I can have a try to come up with a patch series for this 
within the next days.

However, I'm still stuck on the question how to handle the #include 
<linux/string.h> for the purgatory:

  https://lore.kernel.org/lkml/7d373eca-c23c-4f79-9391-29d75bd5a53f@redhat.com/

Do you maybe have any good suggestions how to tackle this?

  Thomas

