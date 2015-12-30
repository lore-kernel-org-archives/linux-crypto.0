From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: use-after-free in alg_bind
Date: Wed, 30 Dec 2015 18:53:00 +0800
Message-ID: <20151230105300.GA10383@gondor.apana.org.au>
References: <CACT4Y+aDcwAn0NQmSnwa4CFCYHcyHu_5UqPNmUZ21b-B-gpZbw@mail.gmail.com>
 <20151230012436.GA8173@gondor.apana.org.au>
 <CACT4Y+ZUiiXUY06MEGQfz3FN8pugrNpSJb2QjMQ9CyRCP6kojw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>,
	syzkaller <syzkaller@googlegroups.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42313 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbbL3KxM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Dec 2015 05:53:12 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZUiiXUY06MEGQfz3FN8pugrNpSJb2QjMQ9CyRCP6kojw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 30, 2015 at 11:19:45AM +0100, Dmitry Vyukov wrote:
>
> This use-after-free does not reproduce on every run. It seems to be
> triggered by some race. Try to run the program in a parallel loop.
> I use stress tool for this:
> https://github.com/golang/tools/blob/master/cmd/stress/stress.go
> If you have Go toolchain installed, then then following will do:
> $ go get golang.org/x/tools/cmd/stress
> $ stress -p 16 ./a.out

I've tried a few thousand instances of it but still no luck.
> 
> 
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index a8e7aa3..82a7dcd 100644

There are a few missing hunks in your patch and the patch to
if_alg.h is missing.

So please start with the current crypto tree and then apply the
latest version (v2) of "crypto: af_alg - Disallow bind/setkey/...
after accept(2)" and try again.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
