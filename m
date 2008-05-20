From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-next 20080519 build failure
Date: Tue, 20 May 2008 14:39:22 +0800
Message-ID: <E1JyLVK-00026D-00@gondolin.me.apana.org.au>
References: <20080519163035.GA8804@coyote.octets.fr>
Cc: linux-crypto@vger.kernel.org
To: p.o.roussel@free.fr (Philippe Roussel)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57356 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757021AbYETGjY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 May 2008 02:39:24 -0400
In-Reply-To: <20080519163035.GA8804@coyote.octets.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Philippe Roussel <p.o.roussel@free.fr> wrote:
> Hi,
> 
> While building randconfigs I rant into 
> 
> crypto/built-in.o: In function cryptd_alloc':cryptd.c:(.text+0xe35b): undefined reference to crypto_ahash_type'
> make: *** [.tmp_vmlinux1] Error 1
> 
> with 
> 
> CONFIG_CRYPTO=y
> CONFIG_CRYPTO_HASH=m

You need CONFIG_CRYPTO_HASH=y since you've got CONFIG_CRYPTD=y.

This is alerady fixed in my tree but I forgot to push :) Sorry.
It's pushed now.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
