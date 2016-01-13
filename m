From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: use-after-free in hash_sock_destruct_common
Date: Wed, 13 Jan 2016 14:57:29 +0800
Message-ID: <20160113065729.GA8123@gondor.apana.org.au>
References: <CACT4Y+YP0Ppj41P9mX1SPSEXkV=ffe0vuK1Ap7r0Ub8GROD5nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44935 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbcAMG5j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 01:57:39 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+YP0Ppj41P9mX1SPSEXkV=ffe0vuK1Ap7r0Ub8GROD5nQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 12, 2016 at 07:31:03PM +0100, Dmitry Vyukov wrote:
> 
> The following program triggers use-after-free in
> hash_sock_destruct_common. This is on master of
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
> (cd7e98414462b9db70067ac29896c58210b13b69). I've also seen a similar
> crash in skcipher_sock_destruct_common.

OK the new compatibility nokey path introduced some new problems.
Please try the following patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
