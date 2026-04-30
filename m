Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEFA3DDDDD
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 07:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777534725; cv=none; b=L6R64GB2EqVwBlmjRsq9GV8fCNX2FCbnJZLSNC3lLoQW2MPMxyid3gb5HiJp6Biz4qwDOqgdQC/sYPTN0Tu0kbGrdZYktRd/V9DfcuMtKbIGnOmjyRZeLX7UIweCzKqX5Plx2QIumYdL1YXXC3PkETFPOy9+SxRYlrLRatDaqm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777534725; c=relaxed/simple;
	bh=sk0vIHPf1KGhP/s52BoHh4ZDFHdAvSKew1mZHChtjdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UyXV0VGQ1JxSwvHu4nt7YnRIdSHwxsX591vmh4TA++8hZ0Bt8bConCsMkoQrEx9rYlR1yPlOL66ShoJYD1Lq9fB2Ktc1m7io3FFwVBsCGBTO8nfaMjm22MmwhMN/HJKlPNfgn7Ar+AIU+JM/9CidXqgS4E8eLTg9UM/O7n/Z6rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A2Xt19cg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rTNmR/xC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A2Xt19cg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rTNmR/xC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777534714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/WDYnnUoiqNbJR98i81Dp10k2P1EVxsRyVeqRvwR0cc=;
	b=A2Xt19cgJ9/neOuDMmbLxG0SHMlPSEKYGZCpRYfOscAoNDqlVD+kdMKWsFXUeR5Ablr2rt
	j6pf2eUHjXVRNu2NgqqVAMQYnPKaGSJ+yKFqm3KlX9P0GBHxl64IPsUrgLqyBdUvNZkt6G
	k9jtHJ2GwC7ZgwSWOLRmt3udUw3KGvY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-9bFo7IiHP2ClG8JTpV0kuw-1; Thu, 30 Apr 2026 03:38:32 -0400
X-MC-Unique: 9bFo7IiHP2ClG8JTpV0kuw-1
X-Mimecast-MFC-AGG-ID: 9bFo7IiHP2ClG8JTpV0kuw_1777534711
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48a55ecc249so3838495e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 00:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777534711; x=1778139511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/WDYnnUoiqNbJR98i81Dp10k2P1EVxsRyVeqRvwR0cc=;
        b=rTNmR/xCr7c7b9af/Ii2KRTzQXQyFVXk72QwoK9jv58whXtNtOJGBBe+MMQf9kc+xd
         +Em8stDMARaZPHwB0mCsZo6BaSVDzETxxN/wc8e0sEsmGyNKFNMxUg2E7nWIBfE65UIY
         lRVcehFUNEI/N6r3k5qUCsvdIv8xzbJ37olm8nRugtUX0H5Bu+U93BF/BQZkQ6UNJZ2h
         W669xp5oy9Uyk8fLF3hrlrvwINluDzv3fl0wQB67nXMfyB8I8yYVx73S9M3r0o/x69nR
         HI1mJBo/FCR5bCA0qzDII5rnhYve3XCXuj21+mShRdO1XtPIDsUWzo+B48A/Nu9cpnpM
         NIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777534711; x=1778139511;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/WDYnnUoiqNbJR98i81Dp10k2P1EVxsRyVeqRvwR0cc=;
        b=bMOMrROkzCPD/kVtWu+ITIu2C1J2nwjwgsJVymvnJnomX2hAGGu6i1pQYhb65PjnXA
         8kQyZOF1nPDMaytjaX+J0wA1PQRrE1PUiSC1GWd/Vm8JOhwy4CGUYbQpu6YMveEivE3l
         VG4z9v7SpL5ITPGmghoukaF7jirqm2UepI9DDsiSh8cSuOx67aFnPY69nxcYdQB7NA/Z
         oPfYwygnzRjue6CktYU6MMV6vLNwnmmnARGVhx2gezb6hHMpinmg2sLq+gFY1vqGRFZ2
         OIOBqb4uTjpq8WQRjqIJv2iXwLZzpRDgdKOQbIblbuybTiHV2of/7sdnYXhuGzAgyffN
         KiSg==
X-Forwarded-Encrypted: i=1; AFNElJ/p1YN8i1wbEW1Q3irCDm0tC4q3fzKRDFSIiue8rT87IC0wdJIdKDwFS9DS/gstZyy+LwkoHrTdBARp3ks=@vger.kernel.org
X-Gm-Message-State: AOJu0YzadYwmetRByLtWp5i6IPch23/kODOigR7TrmIw8Dq6PFF3SsmZ
	0I8fyC4gbyUtXwJCungCITfvi7iZjyb+kLlmXQHRiZBSNQM9rvjFZu3JFVgoKm+ddakFOQ6h/rD
	gHNuZL9qnA/HmzIXyc5boeJep3tRdjZGHkYlY5g4dLlydXp1Ytkn/zI0lfARX3fJr3g==
X-Gm-Gg: AeBDies9ovzjpviN4DLvxDEx7cfG5xCoph6yasitxSPWi9+pAyayrVV3gmMfKz7B4ov
	oacAZUGqNqMAHiHFTgQUhupiz7J4TtykQRPoS9Kp99TSoWBQ0HL7+eZ7nnuu1GjvpKY6g6L7pqk
	3ZdGwuY3EStkfk5mlsGinBQWtazAFiYdAOqAbN4jORYhxiLs/yimY/g9fy3Z7CkNh9qqrMATA3p
	ABvxJNaG0vGZih48ClsSdQvVJc/nTq8MLGpRiRJ9A7iAf/lJTK6QeEZ/DAzbE/7i5vRUULUNmjw
	Wpb3epS1Y/klCMtcp/aXUD0AqMD1LykbPvzBnTnlSHI3tS3Jbth/6KTkTCXpcoZ2oiK974BKUeV
	6UpqvTSbB+DqVLNHajjIiGd8TbHlunTtZGJHmCIWspw7e0KqwqYVtxKL3oVnI4NJ6jw==
X-Received: by 2002:a05:600d:c:b0:489:fec9:a17e with SMTP id 5b1f17b1804b1-48a844f4fd9mr18983535e9.12.1777534711217;
        Thu, 30 Apr 2026 00:38:31 -0700 (PDT)
X-Received: by 2002:a05:600d:c:b0:489:fec9:a17e with SMTP id 5b1f17b1804b1-48a844f4fd9mr18983195e9.12.1777534710740;
        Thu, 30 Apr 2026 00:38:30 -0700 (PDT)
Received: from [192.168.88.32] ([150.228.93.27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c2f2eb8sm59538525e9.6.2026.04.30.00.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 00:38:30 -0700 (PDT)
Message-ID: <a642b858-eea0-4b7a-aeb2-aa67c6cf0f64@redhat.com>
Date: Thu, 30 Apr 2026 09:38:28 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
To: Dmitry Safonov <0x7f454c46@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, netdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, "David S . Miller"
 <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Simon Horman <horms@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Dmitry Safonov <dima@arista.com>
References: <20260427172727.9310-1-ebiggers@kernel.org>
 <CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>
 <20260427155538.2e1b8488@kernel.org>
 <CAJwJo6Zh_1V009JSBGwAmR7GWj=2HdG6f=uBxK8krE4B1YrGkA@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CAJwJo6Zh_1V009JSBGwAmR7GWj=2HdG6f=uBxK8krE4B1YrGkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/28/26 2:00 AM, Dmitry Safonov wrote:
> On Mon, 27 Apr 2026 at 23:55, Jakub Kicinski <kuba@kernel.org> wrote:
>> On Mon, 27 Apr 2026 20:09:05 +0100 Dmitry Safonov wrote:
>>> I do like these numbers quite much! Yet, as I mentioned in version 1,
>>> removing a fallback for other algorithms' support does not sound good
>>> to me. There are two reasons:
>>> - Ronald P. Bonica (the original RFC5925 author), together with Tony
>>> Li do have an active RFC draft to support the additional algorithms
>>> [1], potentially in addition to TCP Extended Options [2]
>>> - There is at least one open-source BGP implementation (BIRD) that
>>> allows using the algorithms that you are removing [3]. Without a
>>> deprecation period and communication with at least known open source
>>> users, it implies intentionally breaking them, which I can't agree
>>> with.
>>>
>>> I don't feel like Naking as we don't have any customers using anything
>>> other than the 3 algorithms above (and BGP implementation is
>>> [unfortunately] closed-source, so that would not feel appropriate even
>>> if we had such customers), yet I do feel like it's worth and
>>> appropriate to express my thoughts/concerns.
>>
>> What do you want to happen? You are the maintainer of this code,
>> you don't get so say "i don't want to nack it but also no" :)
> 
> Yeah, that's not what I meant. I see value in Eric's contribution, and
> I like getting rid of tcp-sigpool. So, anything but "nack" is not "no"
> :-)

I read the above as: "If there isn't any additional feedback soon,
please apply".

>> Like Eric says if there are no real users code can be deleted.
>> Adding deprecation warnings upstream is quite slow, IDK if injecting
>> deprecation warnings to stable has been discussed..
> 
> FWIW, I've written to bird's mailing list inviting them to this
> thread; in case if they need other algorithms to be supported,
> hopefully that should avoid any breakages on their side.
> I'm aware that ciena and fortinet use tcp-ao too, but I'm less
> concerned, as they aren't open source.

Let me add my 2c here:
- the only TCP-AO use-case I'm aware of, is to _drop_ TCP-MD5
- We had some discussion about TCP Extended Options in past netconf, and
IIRC at very best it's not going to happen any time soon kernel wise
because it basically requires disabling GRO.
- the possibility of using crc32 is indeed a security issue, that AFAICS
must be addressed, and can only be fixed removing such option. I'm fine
dropping support for any other algo considered vulnerable.

More than 48H passed since the last email on this thread, I'm going to
apply it.

Thanks,

Paolo

