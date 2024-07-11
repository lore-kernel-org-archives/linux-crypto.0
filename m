Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476A51803D
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jul 2024 04:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720673213; cv=none; b=lRdIaoiMRxEHI8oxb8Nx1LfJFRjA/TLMts/NUDrj4bAEPWI8Fob1iO9FyRJr8KCBrQ+6MtwfDGD/NY2IgsZ7s/+H47qoT27WvKCTwMdLLsoM+nGdnt/zwACNCoB0anY+mry8pXXADFjKorX1RPKIexv3H8y9y80MVwI7qJvSgrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720673213; c=relaxed/simple;
	bh=+KvGXzUeKuygJalFcpujZdXr7PyCpNIHgikBySpTKi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J9BkDeuEf1EKtHBYiHWzVUQqMmdZcOAN3lQ0AETNgoKwb0/ovY4UnSDS/93pSdoPHIZGuo20SZjNmyTChyKj+pqjwY47icbLdG5/yrKWqrwxobj84pBTmAZRrc5GcFXOhAtBoAxYOI61poM3/1N8E0BcxozCZI3cRjDIKf792Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IDOvfxpq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IDOvfxpq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720673210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lyfoEy9OwqFj0Sb+Bhj1Pj43zQ7mqRzrMZDAP0advz0=;
	b=IDOvfxpqxjczOhH/zd/+Qy4hyuRyayKTN3njLu9bW5MswWBsQB2obCDFH0K08qmXbHiElu
	MAaScmj6JC9YTR2+kTdBbofPa4bTW3bcpbt9epZUXS3SNi2ybKJXf0uJkvQIHvz4dmDUtg
	QBlGDW/U1FZ48eiQOVgIsuo9H2vvp2E=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-hLF1WBOzNhyAAoHGizud1Q-1; Thu, 11 Jul 2024 00:46:44 -0400
X-MC-Unique: hLF1WBOzNhyAAoHGizud1Q-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1fb05b9e222so3701105ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jul 2024 21:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720673203; x=1721278003;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lyfoEy9OwqFj0Sb+Bhj1Pj43zQ7mqRzrMZDAP0advz0=;
        b=ZT58k4GfhbQWIM/CygHVKZuNK1+KUt60dbwU6nXc7gJS60Mlj8I35uTe4xesmf1D+s
         sGo5zIooH/G4q+VgRJerlOXl1R5ep9ik7OdxbbFURXNzDgHJG6tcsjRt8+yTruaOsfSR
         UlDP8QmTsN9+7DU23VjjUdaIcrh5EVKEVXwJevJBQihI77kc13ellwzxqb7RXEzGsMCw
         ZUI9oMgRsBAn4JZaCJFZCZsU2B4UDNr3nSV6xNnj38XVsiRIdu72cjrVO9pI1abzh2c8
         etC8VUfJ9cGjnwH3nWE2w73afooZQAl7r36kmBQ1ILApNRFOqzCbk5jsW3lfAV4Y31F8
         pnLg==
X-Forwarded-Encrypted: i=1; AJvYcCVZXHSmKfzU+8sM9vbJsZ2FL6eWGdxaxt0+uygN1zVIQ5thA8OVgkgR8GNbFG61Vi6sms0jnYaxriJpbrZ072ShL0JxQrbEsP6SPTQl
X-Gm-Message-State: AOJu0YxV2kIkr5r2/AdBCDxNZ28JB6VrPp46HeVz9T/loB/JeC8QjCpu
	g0cYCDWDs5y/2JWk/AH8MNlo4iA9MiJhRMxuVbeST/zvF+rY3TxSOYV538vNafuJqiTGr7OXaGQ
	Z8bRK3LslIBpb3W/d4FMPl/kwzj36oLZL+3Jth+q7j3y3jnYH4c98GWmXu7/yCJv10f7owuWH
X-Received: by 2002:a17:903:11ce:b0:1fb:365:5e0 with SMTP id d9443c01a7336-1fbb6d25264mr61312205ad.14.1720673203586;
        Wed, 10 Jul 2024 21:46:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGr8a+/UDzIKV6GoLXWla7TLTJFMgLIA7t+hPHot2H8qf5AANpsyZ+2DJbcMumnXPLtOqmfpg==
X-Received: by 2002:a17:903:11ce:b0:1fb:365:5e0 with SMTP id d9443c01a7336-1fbb6d25264mr61311985ad.14.1720673203056;
        Wed, 10 Jul 2024 21:46:43 -0700 (PDT)
Received: from [172.20.2.228] ([4.28.11.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a2c055sm42643835ad.104.2024.07.10.21.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 21:46:42 -0700 (PDT)
Message-ID: <bf51a483-8725-4222-937f-3d6c66876d34@redhat.com>
Date: Thu, 11 Jul 2024 06:46:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 1/4] mm: add MAP_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 tglx@linutronix.de, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
 x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
 Carlos O'Donell <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
 Christian Brauner <brauner@kernel.org>,
 David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
References: <20240709130513.98102-1-Jason@zx2c4.com>
 <20240709130513.98102-2-Jason@zx2c4.com>
 <378f23cb-362e-413a-b221-09a5352e79f2@redhat.com>
 <9b400450-46bc-41c7-9e89-825993851101@redhat.com>
 <Zo8q7ePlOearG481@zx2c4.com> <Zo9gXAlF-82_EYX1@zx2c4.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zo9gXAlF-82_EYX1@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.07.24 06:32, Jason A. Donenfeld wrote:
> On Thu, Jul 11, 2024 at 02:44:29AM +0200, Jason A. Donenfeld wrote:
>> Hi David,
>>
>> On Wed, Jul 10, 2024 at 06:05:34AM +0200, David Hildenbrand wrote:
>>> BTW, do we have to handle the folio_set_swapbacked() in sort_folio() as well?
>>>
>>>
>>> 	/* dirty lazyfree */
>>> 	if (type == LRU_GEN_FILE && folio_test_anon(folio) && folio_test_dirty(folio)) {
>>> 		success = lru_gen_del_folio(lruvec, folio, true);
>>> 		VM_WARN_ON_ONCE_FOLIO(!success, folio);
>>> 		folio_set_swapbacked(folio);
>>> 		lruvec_add_folio_tail(lruvec, folio);
>>> 		return true;
>>> 	}
>>>
>>> Maybe more difficult because we don't have a VMA here ... hmm
>>>
>>> IIUC, we have to make sure that no folio_set_swapbacked() would ever get
>>> performed on these folios, correct?
>>
>> Hmmm, I'm trying to figure out what to do here, and if we have to do
>> something. All three conditions in that if statement will be true for a
>> folio in a droppable mapping. That's supposed to match MADV_FREE
>> mappings.
>>
>> What is the context of this, though? It's scanning pages for good ones
>> to evict into swap, right? So if it encounters one that's an MADV_FREE
>> page, it actually just wants to delete it, rather than sending it to
>> swap. So it looks like it does just that, and then sets the swapbacked
>> bit back to true, in case the folio is used for something differnet
>> later?
>>
>> If that's correct, then I don't think we need to do anything for this
>> one.
>>
>> If that's not correct, then we'll need to propagate the droppableness
>> to the folio level. But hopefully we don't need to do that.
> 
> Looks like that's not correct. This is for pages that have been dirtied
> since calling MADV_FREE. So, hm.
> 

Maybe we can find ways of simply never marking these pages dirty, so we 
don't have to special-case that code where we don't really have a VMA at 
hand?

-- 
Cheers,

David / dhildenb

