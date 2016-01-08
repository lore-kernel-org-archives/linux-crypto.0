From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: af_alg - Add nokey compatibility path
Date: Fri, 8 Jan 2016 21:48:51 +0900
Message-ID: <20160108124851.GA5425@gondor.apana.org.au>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <5687BA0F.3020104@gmail.com>
 <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de>
 <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au>
 <5688ED04.4090802@gmail.com>
 <20160104043518.GA4411@gondor.apana.org.au>
 <568A66B2.4090307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com,
	Ondrej Kozina <okozina@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57815 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbcAHMtG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jan 2016 07:49:06 -0500
Content-Disposition: inline
In-Reply-To: <568A66B2.4090307@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 04, 2016 at 01:33:54PM +0100, Milan Broz wrote:
>
> - hmac() is now failing the same way (SETKEY after accept())
> (I initially tested without two patches above, these are not in linux-next yet.)
> This breaks all cryptsetup TrueCrypt support (and moreover all systems if
> kernel crypto API is set as a default vcrypto backend - but that's not default).

Yes algif_hash would need the same compatibility patch and I'm
working on that.

> - cipher_null before worked without setkey, now it requires to set key
> (either before or after accept().
> This was actually probably bad workaround in cryptsetup, anyway it will now cause
> old cryptsetup-reencrypt tool failing with your patches.
> (Try "cryptsetup benchmark -c cipher_null-ecb". I am not sure what to do here,
> but not requiring setkey for "cipher" that has no key internally seems ok for me...)

Is cipher_null actually used in production or is this just a
benchmark? Using the kernel crypto API to perform no encryption
sounds crazy.

> As I said, I'll fix it in cryptsetup upstream but we are breaking  a lot of existing systems.
> Isn't there better way, how to fix it?

Setting the key after accept has always been wrong.  It's just
that it hasn't been noticed until now.  The main crypto socket
corresponds to the tfm object and is shared by all the child
sockets produced by accept(2).  So once you have child sockets
which may then be used by another thread you must not modify
the parent socket/tfm in any way, and in particular you must
not change the key.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
