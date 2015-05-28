From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/10] crypto: aead - Add type-safe init/exit functions
Date: Thu, 28 May 2015 22:07:53 +0800
Message-ID: <E1YxyTR-0002JC-PW@gondolin.me.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44836 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbbE1OH5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 10:07:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As it stands the only non-type safe functions left in the new
AEAD interface are the cra_init/cra_exit functions.  It means
exposing the ugly __crypto_aead_cast to every AEAD implementor.

This patch adds type-safe init/exit functions to AEAD.  Existing
algorithms are unaffected while new implementations can simply
fill in these two instead of cra_init/cra_exit.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c         |   14 ++++++++++++++
 include/crypto/aead.h |   13 +++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index 8cdea89..4bab3cf 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -174,6 +174,14 @@ static int crypto_old_aead_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static void crypto_aead_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_aead *aead = __crypto_aead_cast(tfm);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+
+	alg->exit(aead);
+}
+
 static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_aead *aead = __crypto_aead_cast(tfm);
@@ -189,6 +197,12 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	aead->child = __crypto_aead_cast(tfm);
 	aead->authsize = alg->maxauthsize;
 
+	if (alg->exit)
+		aead->base.exit = crypto_aead_exit_tfm;
+
+	if (alg->init)
+		return alg->init(aead);
+
 	return 0;
 }
 
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 61306ed..680d4b0 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -108,6 +108,17 @@ struct aead_givcrypt_request {
  * @decrypt: see struct ablkcipher_alg
  * @geniv: see struct ablkcipher_alg
  * @ivsize: see struct ablkcipher_alg
+ * @init: Initialize the cryptographic transformation object. This function
+ *	  is used to initialize the cryptographic transformation object.
+ *	  This function is called only once at the instantiation time, right
+ *	  after the transformation context was allocated. In case the
+ *	  cryptographic hardware has some special requirements which need to
+ *	  be handled by software, this function shall check for the precise
+ *	  requirement of the transformation and put any software fallbacks
+ *	  in place.
+ * @exit: Deinitialize the cryptographic transformation object. This is a
+ *	  counterpart to @init, used to remove various changes set in
+ *	  @init.
  *
  * All fields except @ivsize is mandatory and must be filled.
  */
@@ -117,6 +128,8 @@ struct aead_alg {
 	int (*setauthsize)(struct crypto_aead *tfm, unsigned int authsize);
 	int (*encrypt)(struct aead_request *req);
 	int (*decrypt)(struct aead_request *req);
+	int (*init)(struct crypto_aead *tfm);
+	void (*exit)(struct crypto_aead *tfm);
 
 	const char *geniv;
 
