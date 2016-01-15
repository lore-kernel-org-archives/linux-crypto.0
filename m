From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/2] crypto: Fix race condition in *_check_key
Date: Fri, 15 Jan 2016 21:59:00 +0800
Message-ID: <20160115135900.GA31813@gondor.apana.org.au>
References: <CACT4Y+ap-GiGRjwWr9kDwMNwQOg5TbJfi8kGD2H2Qv5SBrQK4Q@mail.gmail.com>
 <20160114141341.GA21300@gondor.apana.org.au>
 <CACT4Y+bEJ4iVqUB8yFT=7bHgyaQmFQUq08kEa8Wp_poj5Mthog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54293 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbcAON7G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jan 2016 08:59:06 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+bEJ4iVqUB8yFT=7bHgyaQmFQUq08kEa8Wp_poj5Mthog@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 15, 2016 at 10:06:11AM +0100, Dmitry Vyukov wrote:
> 
> With these patches I see lots of:
> 
> [ INFO: possible recursive locking detected ]
> 4.4.0+ #250 Not tainted
> ---------------------------------------------
> syz-executor/16742 is trying to acquire lock:
>  (sk_lock-AF_ALG){+.+.+.}, at: [<     inline     >] lock_sock
> include/net/sock.h:1480
>  (sk_lock-AF_ALG){+.+.+.}, at: [<ffffffff828661d2>]
> hash_check_key.isra.3+0xd2/0x210 crypto/algif_hash.c:261
> 
> but task is already holding lock:
>  (sk_lock-AF_ALG){+.+.+.}, at: [<     inline     >] lock_sock
> include/net/sock.h:1480
>  (sk_lock-AF_ALG){+.+.+.}, at: [<ffffffff82866126>]
> hash_check_key.isra.3+0x26/0x210 crypto/algif_hash.c:252
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(sk_lock-AF_ALG);
>   lock(sk_lock-AF_ALG);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation

Indeed.  Here is an updated version.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
