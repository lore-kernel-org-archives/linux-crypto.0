Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C953EB64D9
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jun 2023 10:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241250AbjFOK0a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jun 2023 06:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbjFOK03 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2023 06:26:29 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E70C123;
        Thu, 15 Jun 2023 03:26:26 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q9kB4-003Hle-09; Thu, 15 Jun 2023 18:26:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Jun 2023 18:26:05 +0800
Date:   Thu, 15 Jun 2023 18:26:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, keyrings@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v2 PATCH 0/5] crypto: Add akcipher interface without SGs
Message-ID: <ZIrnPcPj9Zbq51jK@gondor.apana.org.au>
References: <ZIg4b8kAeW7x/oM1@gondor.apana.org.au>
 <570802.1686660808@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <570802.1686660808@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v2 changes:

- Rename dsa to sig.
- Add braces around else clause.

The crypto akcipher interface has exactly one user, the keyring
subsystem.  That user only deals with kernel pointers, not SG lists.
Therefore the use of SG lists in the akcipher interface is
completely pointless.

As there is only one user, changing it isn't that hard.  This
patch series is a first step in that direction.  It introduces
a new interface for encryption and decryption without SG lists:

int crypto_akcipher_sync_encrypt(struct crypto_akcipher *tfm,
				 const void *src, unsigned int slen,
				 void *dst, unsigned int dlen);

int crypto_akcipher_sync_decrypt(struct crypto_akcipher *tfm,
				 const void *src, unsigned int slen,
				 void *dst, unsigned int dlen);

I've decided to split out signing and verification because most
(all but one) of our signature algorithms do not support encryption
or decryption.  These can now be accessed through the sig interface:

int crypto_sig_sign(struct crypto_sig *tfm,
		    const void *src, unsigned int slen,
		    void *dst, unsigned int dlen);

int crypto_sig_verify(struct crypto_sig *tfm,
		      const void *src, unsigned int slen,
		      const void *digest, unsigned int dlen);

The keyring system has been converted to this interface.

The next step would be to convert the code within the Crypto API so
that SG lists are not used at all on the software path.  This
would eliminate the unnecessary copying that currently happens.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
