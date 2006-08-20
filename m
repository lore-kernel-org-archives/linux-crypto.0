From: Solar Designer <solar@openwall.com>
Subject: Re: [PATCH] cit_encrypt_iv/cit_decrypt_iv for ECB mode
Date: Sun, 20 Aug 2006 18:49:08 +0400
Message-ID: <20060820144908.GA19602@openwall.com>
References: <20060820002346.GA16995@openwall.com> <20060820080403.GA602@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mother.openwall.net ([195.42.179.200]:5824 "HELO
	mother.openwall.net") by vger.kernel.org with SMTP id S1750814AbWHTOxO
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Aug 2006 10:53:14 -0400
To: Willy Tarreau <w@1wt.eu>
Content-Disposition: inline
In-Reply-To: <20060820080403.GA602@1wt.eu>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Aug 20, 2006 at 10:04:03AM +0200, Willy Tarreau wrote:
> On Sun, Aug 20, 2006 at 04:23:46AM +0400, Solar Designer wrote:
> > The attached patch actually defines ecb_encrypt_iv() and
> > ecb_decrypt_iv() functions that perform ECB encryption/decryption
> > ignoring the IV, yet return -ENOSYS (just like nocrypt_iv would).
> > The result is no more Oopses and no infoleaks either.
> 
> Can the cryptoloop patch use CRYPTO_TFM_MODE_CFB or CRYPTO_TFM_MODE_CTR
> and so be redirected to nocrypt() which will leave uninitialized memory
> too ?

At least patch-cryptoloop-jari-2.4.22.0 in particular will only do CBC
(default, preferred) or ECB (if requested); it won't attempt to use CFB
or CTR.

Regarding nocrypt*():

> I wonder whether we shouldn't consider that those functions must at
> least clear the memory area that was submitted to them, such as
> proposed below. It would also fix the problem for potential other
> users.

This makes sense to me, although it is not perfect as Herbert has
correctly pointed out:

> If the user is ignoring the error value here then you're in serious
> trouble anyway since they've just lost all their data.

Can we maybe define working but IV-ignoring functions for ECB (like I
did), but use memory-clearing nocrypt*() for CFB and CTR (as long as
these are not supported)?  Of course, all of these will return -ENOSYS.

Alexander
