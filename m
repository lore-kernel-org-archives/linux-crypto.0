From: Marcel Holtmann <marcel@holtmann.org>
Subject: Proposal for adding setpubkey callback to akcipher_alg
Date: Sun, 2 Aug 2015 22:28:33 -0700
Message-ID: <905E1812-AD9B-4188-A668-3CD8985EA1BF@holtmann.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46420 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbbHCF2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 01:28:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tadeusz,

I think we need to split the akcipher_alg setkey callback into a setkey and setpubkey.

diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 69d163e39101..ca93952b6d19 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -91,6 +91,8 @@ struct akcipher_alg {
        int (*decrypt)(struct akcipher_request *req);
        int (*setkey)(struct crypto_akcipher *tfm, const void *key,
                      unsigned int keylen);
+       int (*setpubkey)(struct crypto_akcipher *tfm, const void *key,
+                        unsigned int keylen);
        int (*init)(struct crypto_akcipher *tfm);
        void (*exit)(struct crypto_akcipher *tfm);
 
If the cipher actually uses two different formats for the public + private key data compared to just the public key data, then it is useful to have these independent. That way we can use standard formats for the keys and do not have to have a Linux kernel specific key format.

My definition would be that setkey sets the private and public key. And the setpubkey only sets the public key. So depending on which format of keys you have, you call the proper function and it will do the rest for you. At least for RSA this solves the problem that I described in my previous email and we could use RSA standard ASN.1 formats for each of the key files.

For obvious reasons, when you only call setpubkey, then only encrypt and verify will work. However if you call setkey, then you can sign, verify, encrypt and decrypt.

When exposing akcipher via AF_ALG, I would also propose to add a ALG_SET_PUBKEY so that userspace can clearly tell the kernel which part of the keys it has. This would map nicely and we then know which ASN.1 decoder to call instead of having to guess what format userspace provided. In case of RSA, the user already selected RSA as cipher. So it either has RSA Public Key and would use ALG_SET_PUBKEY or it has RSA Private Key and would use ALG_SET_KEY. Since the key formats do not describe themselves, I think this is the cleaner solution from an API point of view.

On a side note, that the ASN.1 decoder accepts a key with two integers even while the format describes three integers seems like a bug in the decoder and not a feature. If the third integer is not marked as optional, the decoder should just fail the parsing.

Regards

Marcel
