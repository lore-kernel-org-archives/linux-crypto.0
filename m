From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for March 10 (crypto & NLATTR)
Date: Tue, 10 Mar 2009 11:57:37 -0700
Message-ID: <49B6B821.5050302@oracle.com>
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:50708 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZCJS4g (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2009 14:56:36 -0400
In-Reply-To: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090306:
> 
> 
> The driver-core tree gained a build failure due to a conflict with the
> crypto tree.  I have applied a patch to the crypto tree for today.

I had several (4 of 50) randconfig builds fail with:

lib/built-in.o: In function `__nla_reserve_nohdr':
(.text+0xd08d): undefined reference to `skb_put'
lib/built-in.o: In function `__nla_reserve':
(.text+0xd121): undefined reference to `skb_put'
lib/built-in.o: In function `nla_append':
(.text+0xd493): undefined reference to `skb_put'

which happens with CONFIG_NET=n, CONFIG_CRYPTO=y, CONFIG_CRYPTO_ZLIB=[my].

CRYPTO_ZLIB selects NLATTR, but obviously the build of nlattr.c fails
when CONFIG_NET=n.  Should CRYPTO_ZLIB depend on NET?
Please don't say that CRYPTO_ZLIB should select NET.


-- 
~Randy
