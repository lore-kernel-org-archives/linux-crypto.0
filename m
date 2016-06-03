From: Stephan Mueller <smueller@chronox.de>
Subject: Re: authenc methods vs FIPS in light of unencrypted associated data
Date: Fri, 03 Jun 2016 08:42:31 +0200
Message-ID: <2641743.LA46gJhHTE@tauon.atsec.com>
References: <20160602160104.GK18490@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Marcus Meissner <meissner@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35780 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbcFCGmf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jun 2016 02:42:35 -0400
In-Reply-To: <20160602160104.GK18490@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 2. Juni 2016, 18:01:04 schrieb Marcus Meissner:

Hi Marcus, Herbert

> Hi,
> 
> In February I already tagged some authenc ciphers for FIPS compatibility.
> 
> I currently revisit this to get testmgr running all the tests in strict FIPS
> mode.
> 
> The authenc() class is troublesome.
> 
> There is a HASH + ENC part of this method, but you can also add associated
> data, which is not encrypted. (using the ctx->null cipher in
> crypto/authenc.c)
> 
> But in FIPS mode the crypto_authenc_init_tfm does:
> 
> 	null = crypto_get_default_null_skcipher();
> 
> which results in error, as the crypto_alloc_blkcipher("ecb(cipher_null)", 0,
> 0); results in failure due to "ecb(cipher_null)" not FIPS compliant.
> 
> How to handle this?
> 
> I think GCM also does not encrypt, just hashes, the associated data, it just
> does copy the content itself and does not use a virtual cipher.

This issue points to a more pervasive issue in how the fips_allowed flag is 
handled. In combined ciphers, the use of individual components separately from 
the combined cipher may not be allowed in FIPS mode. However, the use of the 
combined cipher is allowed.

For example, GCM is an allowed cipher, but ghash is not. To make GCM usable, 
the fips_allowed flag is set for ghash which would allow a user to use ghash 
directly outside GCM, which is not allowed.

Therefore, the fips_allowed flag should only be evaluated for the cipher the 
user invokes. If that cipher employs sub-ordinate ciphers, the fips_allowed 
flag is not enforced any more. The idea would be that when fips_allowed is set 
for a cipher, it implies that this cipher with all its sub-ordinate ciphers is 
allowed even when those individual ciphers would be allowed.

Herbert, when using crypto_spawn_*, is there a flag set by the crypto API that 
the to-be-instantiated cipher is invoked by the kernel crypto API instead of 
by a user? I would assume that the INTERNAL flag could be of relevance here. 
If that INTERNAL flag is set, I think that the function alg_test could be 
changed such that if the INTERNAL flag is set, the fips_allowed flag is not 
enforced.

Ciao
Stephan
