From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [v2 PATCH 0/2] crypto: Fix race condition in *_check_key
Date: Fri, 15 Jan 2016 18:30:44 +0100
Message-ID: <CACT4Y+aN-UWNEApm7q31EMfTYt5SCL5OhvRWse9L=yrY+Cch5A@mail.gmail.com>
References: <CACT4Y+ap-GiGRjwWr9kDwMNwQOg5TbJfi8kGD2H2Qv5SBrQK4Q@mail.gmail.com>
 <20160114141341.GA21300@gondor.apana.org.au> <CACT4Y+bEJ4iVqUB8yFT=7bHgyaQmFQUq08kEa8Wp_poj5Mthog@mail.gmail.com>
 <20160115135900.GA31813@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33290 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbcAORbF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jan 2016 12:31:05 -0500
Received: by mail-wm0-f45.google.com with SMTP id f206so32006806wmf.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 Jan 2016 09:31:04 -0800 (PST)
In-Reply-To: <20160115135900.GA31813@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 15, 2016 at 2:59 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Jan 15, 2016 at 10:06:11AM +0100, Dmitry Vyukov wrote:
>>
>> With these patches I see lots of:
>>
>> [ INFO: possible recursive locking detected ]
>> 4.4.0+ #250 Not tainted
>> ---------------------------------------------
>> syz-executor/16742 is trying to acquire lock:
>>  (sk_lock-AF_ALG){+.+.+.}, at: [<     inline     >] lock_sock
>> include/net/sock.h:1480
>>  (sk_lock-AF_ALG){+.+.+.}, at: [<ffffffff828661d2>]
>> hash_check_key.isra.3+0xd2/0x210 crypto/algif_hash.c:261
>>
>> but task is already holding lock:
>>  (sk_lock-AF_ALG){+.+.+.}, at: [<     inline     >] lock_sock
>> include/net/sock.h:1480
>>  (sk_lock-AF_ALG){+.+.+.}, at: [<ffffffff82866126>]
>> hash_check_key.isra.3+0x26/0x210 crypto/algif_hash.c:252
>>
>> other info that might help us debug this:
>>  Possible unsafe locking scenario:
>>
>>        CPU0
>>        ----
>>   lock(sk_lock-AF_ALG);
>>   lock(sk_lock-AF_ALG);
>>
>>  *** DEADLOCK ***
>>
>>  May be due to missing lock nesting notation
>
> Indeed.  Here is an updated version.

With these patches the original bug is fixed and don't see any new.

Tested-by: Dmitry Vyukov <dvyukov@google.com>
