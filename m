From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: use-after-free in alg_bind
Date: Wed, 30 Dec 2015 09:24:36 +0800
Message-ID: <20151230012436.GA8173@gondor.apana.org.au>
References: <CACT4Y+aDcwAn0NQmSnwa4CFCYHcyHu_5UqPNmUZ21b-B-gpZbw@mail.gmail.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:60194 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbbL3BYm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Dec 2015 20:24:42 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+aDcwAn0NQmSnwa4CFCYHcyHu_5UqPNmUZ21b-B-gpZbw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 29, 2015 at 09:19:22PM +0100, Dmitry Vyukov wrote:
> Hello,
> 
> On commit 8513342170278468bac126640a5d2d12ffbff106
> + crypto: algif_skcipher - Use new skcipher interface
> + crypto: algif_skcipher - Require setkey before accept(2)
> + crypto: af_alg - Disallow bind/setkey/... after accept(2)
> 
> The following program causes use-after-free in alg_bind and later
> terminates kernel:

Please double-check that you have the last patch applied correctly,
as I cannot reproduce the crash with your program.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
