Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4882A28B7DA
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 04:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784004820; cv=none; b=OjqBUTE/jN5adt9n9aZVGQqocQ20lnmjbNc7sY1SBsct9zCBdiT393/BHxDIibwFY6EnDpTWZne/ESrb63WcdqZS5GIa2jeQuiB0S42PtfLalN08mCCzR6ALiVmhRIFTJuNId36gHSMYNlAd3JCN9z9/uDoJMtQ3neCfOwSj6gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784004820; c=relaxed/simple;
	bh=u6YLWUyyIdbLFxF+WFxSXJMexzKAp/sPfV5ZScdgyoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J4iHIYrkpd23Yk9sGMc8zycxZZtxnnr9/nzzXwfdYvHs3OOrmQrG8Q9IyYdVDHx+d5+KiqL+KUbhfRNpWwOHHydu+G/Gp4OhmQNbnY+akz0tOozhHxynazOtEAykRzmDkkQD696h6R1qFpic7TJbqbpb/teE6CNL9/YO+170Qs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jexu2kqS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MDIvEo2W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jexu2kqS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MDIvEo2W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784004817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xaFdyJwBLJkWqD0ZGlWFrq7M4WnI/aHFfQgpUPAtLAE=;
	b=Jexu2kqSqYULn11GqqMEXkRZaDVNHfGcmebS9ktfLpeZ34Kr7xxbyBJClrYe+UNR1G+yTR
	gySje+tQZoAiahcDMZT3DvGWfr5SjjMwYDFeC6d6w6zVeSBEWPSyKA7FZ5Y12EsVK95AFF
	VJ1sWZ37GeNSMx4sXUEpGrhaBh3Djrw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-fVmSxgBEP6OWghV3WOILgw-1; Tue, 14 Jul 2026 00:53:35 -0400
X-MC-Unique: fVmSxgBEP6OWghV3WOILgw-1
X-Mimecast-MFC-AGG-ID: fVmSxgBEP6OWghV3WOILgw_1784004814
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-493c20d0468so6433925e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 21:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784004814; x=1784609614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xaFdyJwBLJkWqD0ZGlWFrq7M4WnI/aHFfQgpUPAtLAE=;
        b=MDIvEo2WrQn8J+FuPE8Nf1ANc+4HDD+9iazkoGJcrit3BV7aw71SNSIx/41vClL5sa
         kVsRoyjt9FmP1PO1YKk3CzIEU+VesY6vVbqdhJxIML3vqXMyxKBoFm93T8HjsMQVfv8Z
         jvQH4VSuKLV4iedSlQnFN/bTgm8BRiVpisxZwn76vdNHRTHg73st0YpZBq5TIKSxrGns
         JFWvVfJZ2YSn1AsPiqNaQccmrgmqS3Ss4MU/uJuswFGRPXcj/DoVxAmUzR+9U5qOnecO
         Q23jYhq2q1dc0CHLW+T13dhRUMl3VQaDLM02a+6Qfya4v1TlBH7EPIRbqGV2F2rXyP4O
         tuNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784004814; x=1784609614;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xaFdyJwBLJkWqD0ZGlWFrq7M4WnI/aHFfQgpUPAtLAE=;
        b=NEnEQ7vHcaDP+CDt7Ee6KyVEikPOivCy2ZygvVMqt+K5/+uvsM/ftvjPq9No+ZjWFF
         uQUF2oaM+zhKF4To85LdmCjQUIWcBHSeoJQEvBmay9Gj30ElSweSjGd++0C1cRaLY/6x
         ttuNyQ3odZP6bsZ1x0Fn4kTJLrc7ApNwPpNcAodh1aTW0K+D7N6K9Pn4zXKY2aXDnyhz
         F8vmiQ6JzZIPSxbTxZ5Rn/N12GUb6tmXM9fUy2zEvSDtZjXW/1lYwmrJXj9i5gUZLOEU
         YynIg7sv7ctvU/XCn22zhBPTsAmnLNtcNeu3NHfjmI4Im9BsgzXqy5fEFAib4f2Xg/Ct
         n//Q==
X-Gm-Message-State: AOJu0Yx+1YZf9PA0JY/3uyuvitEnz4tGq/ubGysC010nHtS/KON4fVQb
	QjiLIlHG9C4VcZnYJN+jgR5BVkwMjueNyDu/+Q4SvLHmX1ofYglEqrbkJzpiUJygoX0y1iVS4hd
	iwMb09Z6Xd0j4LKY3fdDLhF8O/zrxfOjuTd9BerKcX+Xna1v57d7Oza2La6Bqh+BFEg==
X-Gm-Gg: AfdE7cnAgZIl0ux+YF3pok4bU6BZC3pjqPRADqOWFHpd3BGiUS8jzrWC+wMlmggqQId
	KDfmVfLGj786w5pmZ22asvQ8L3FXdprsdJJoUbBs+TgU1hz3vigtcJNKw/LzqFE5WItH0njz8mL
	bFHBRQDqukifijGEQvyBZJBEikd7X/fdYBzOYDKZQsWxqvkTO9x8Ac5TgKFYJJXrh0e9XjuL9LZ
	sscF7adXbPmdNUCC1whcXq3izDEeajGlA84SNQ7wM3ScP2o7vgyPze83G36tCW26IM17UAxANYc
	KEEvY75yVHh8asJAGFsY0m+K0WV6JisZffFECeQpIVVDoXeIQIntNu5GGXq1tq2+9/UsM+QxhEU
	SGfqU0yvO
X-Received: by 2002:a05:600c:1f87:b0:493:f870:fbf0 with SMTP id 5b1f17b1804b1-493f88b3693mr146191185e9.34.1784004814471;
        Mon, 13 Jul 2026 21:53:34 -0700 (PDT)
X-Received: by 2002:a05:600c:1f87:b0:493:f870:fbf0 with SMTP id 5b1f17b1804b1-493f88b3693mr146190875e9.34.1784004814144;
        Mon, 13 Jul 2026 21:53:34 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.112.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49510c8e220sm36853905e9.15.2026.07.13.21.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 21:53:33 -0700 (PDT)
Message-ID: <34db35e3-7d6e-4ce2-bd3c-cbe74b321bc4@redhat.com>
Date: Tue, 14 Jul 2026 06:53:32 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/33] lib/crypto: aes: Add CTR and XCTR support
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-5-ebiggers@kernel.org>
 <40932e40-a909-4b95-b739-c4727c1cc153@redhat.com>
 <20260713235439.GB24654@quark>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260713235439.GB24654@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/07/2026 01.54, Eric Biggers wrote:
> On Mon, Jul 13, 2026 at 10:39:53AM +0200, Thomas Huth wrote:
>>> diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
>>> index fb8106034089..6aca01d715da 100644
>>> --- a/Documentation/crypto/libcrypto-unauth-encryption.rst
>>> +++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
>>> @@ -27,6 +27,13 @@ Support for AES in the CBC and CBC-CTS modes of operation.
>>>    .. kernel-doc:: include/crypto/aes-cbc.h
>>> +AES-CTR and AES-XCTR
>>> +--------------------
>>> +
>>> +Support for AES in the CTR and XCTR modes of operation.
>>
>> I guess you already have this on your radar, but just in case: It would be
>> nice to turn this into a full sentence, too.
> 
> Yes, I'm making all of them full sentences.
> 
>>> +/**
>>> + * aes_ctr() - AES-CTR en/decryption
>>> + * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
>>> + *	 overlaps the behavior is unspecified.
>>> + * @src: The source data
>>> + * @len: Number of bytes to en/decrypt
>>> + * @ctr: The counter.  It will be incremented by ceil(@len / AES_BLOCK_SIZE).
>>> + * @key: The key
>>> + *
>>> + * This implements AES in counter mode with a 128-bit big endian counter.
>>> + *
>>> + * This supports incremental en/decryption.  The length of each non-final chunk
>>> + * must be a multiple of AES_BLOCK_SIZE, and the updated @ctr must be passed in
>>> + * each time.
>>
>> Maybe add some wording that ctr ideally should not be 0 for the first call,
>> i.e. a "nonce" value?
> 
> It depends on the usage.  If a distinct key is used for each message for
> example, always starting at 0 is perfectly fine.
> 
> I'm not sure how far we should go to document the proper use of each
> algorithm.  Really the AES-CTR support is just for internal use by
> AES-GCM and AES-CCM, and a few odd users that implement specific other
> protocols that need AES-CTR.  It's not intended to be a place to go to
> receive an introduction to CTR mode.
> 
>>> +static __always_inline void inc_be128_ctr(u8 ctr[AES_BLOCK_SIZE])
>>> +{
>>> +	/* Casts to u8 are needed because of the implicit integer promotion. */
>>> +	if (((u8)++ctr[AES_BLOCK_SIZE - 1]) != 0)
>>> +		return;
>>
>> Why do you handle the first value separately here? The code could be
>> simplified to start with "int i = AES_BLOCK_SIZE -1" in the for-loop
>> instead?
> 
> Just a trick to optimize performance by unrolling the first iteration,
> since 255 times out of 256 the first iteration is enough.
Ok, but then maybe add a comment here. Otherwise people will wonder why it 
has been done like this when reading the code later.

FWIW, I doubt that this really makes a big difference here. Looking at a 
function that contains your code, the disassembly currently looks like this 
(with -O2):

0000000000000000 <inc_be128_ctr>:
    0:   80 47 0f 01             addb   $0x1,0xf(%rdi)
    4:   48 8d 57 0e             lea    0xe(%rdi),%rdx
    8:   74 0a                   je     14 <inc_be128_ctr+0x14>
    a:   c3                      ret
    b:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
   10:   48 83 ea 01             sub    $0x1,%rdx
   14:   80 02 01                addb   $0x1,(%rdx)
   17:   75 05                   jne    1e <inc_be128_ctr+0x1e>
   19:   48 39 d7                cmp    %rdx,%rdi
   1c:   75 f2                   jne    10 <inc_be128_ctr+0x10>
   1e:   c3                      ret

So that's 3 assembly instructions 'til you reach the "ret".

When you drop the optimization, it looks like this:

0000000000000000 <inc_be128_ctr>:
    0:   48 8d 57 0f             lea    0xf(%rdi),%rdx
    4:   eb 0e                   jmp    14 <inc_be128_ctr+0x14>
    6:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
    d:   00 00 00
   10:   48 83 ea 01             sub    $0x1,%rdx
   14:   80 02 01                addb   $0x1,(%rdx)
   17:   75 05                   jne    1e <inc_be128_ctr+0x1e>
   19:   48 39 d7                cmp    %rdx,%rdi
   1c:   75 f2                   jne    10 <inc_be128_ctr+0x10>
   1e:   c3                      ret

That's 4 assembly instructions 'til you reach the "ret". Not such a big 
difference...?

And with -O3, both variants end up with the same code.

  Thomas

