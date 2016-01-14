From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/2] crypto: Fix race condition in *_check_key
Date: Thu, 14 Jan 2016 22:13:41 +0800
Message-ID: <20160114141341.GA21300@gondor.apana.org.au>
References: <CACT4Y+ap-GiGRjwWr9kDwMNwQOg5TbJfi8kGD2H2Qv5SBrQK4Q@mail.gmail.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:48538 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbcANONt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jan 2016 09:13:49 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+ap-GiGRjwWr9kDwMNwQOg5TbJfi8kGD2H2Qv5SBrQK4Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 13, 2016 at 12:58:34PM +0100, Dmitry Vyukov wrote:
> 
> The following program triggers use-after-free in skcipher_sock_destruct.
> This is on upstream commit 03891f9c853d5c4473224478a1e03ea00d70ff8d +
> all pending patches from
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git +
> 4 latest Herbert patches.

OK, the check_key function is buggy in that it doesn't lock the
child socket so if you make two syscalls on the child socket at
the same time you can end up freeing the parent socket.

Please try these two patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
