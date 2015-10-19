From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: ahash - Add crypto_ahash_blocksize
Date: Mon, 19 Oct 2015 09:37:41 +0800
Message-ID: <20151019013741.GB3156@gondor.apana.org.au>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
 <E1Znqk6-0005W5-Kk@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60659 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbbJSBh7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 21:37:59 -0400
Content-Disposition: inline
In-Reply-To: <E1Znqk6-0005W5-Kk@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 18, 2015 at 05:23:30PM +0100, Russell King wrote:
> There's an easier way to get at the hash transform - rather than
> using crypto_ahash_tfm(ahash), we can get it directly from
> req->base.tfm.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

This should be converted to crypto_ahash_blocksize which doesn't
exist for some reason.  So I'm going to add it with the following
patch and then I'll change your patch to use it.

Thanks,

---8<---
This patch adds the missing helper crypto_ahash_blocksize which
returns the block size of an ahash algorithm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 8e920b4..3d69c93 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -264,6 +264,20 @@ static inline unsigned int crypto_ahash_alignmask(
 	return crypto_tfm_alg_alignmask(crypto_ahash_tfm(tfm));
 }
 
+/**
+ * crypto_ahash_blocksize() - obtain block size for cipher
+ * @tfm: cipher handle
+ *
+ * The block size for the message digest cipher referenced with the cipher
+ * handle is returned.
+ *
+ * Return: block size of cipher
+ */
+static inline unsigned int crypto_ahash_blocksize(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+}
+
 static inline struct hash_alg_common *__crypto_hash_alg_common(
 	struct crypto_alg *alg)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
