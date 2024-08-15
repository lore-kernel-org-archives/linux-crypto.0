Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A813BB50
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 08:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723711910; cv=none; b=gdPI5stp4P2TaOriwkm+JWmM8Hl4qQ4rDWx2XThdWCIR8NaEiOGDLz/ipFWQ1A2qKsTpOGHxm00DoZYLB9Bysx4sSIdh2W6ENY7LhNKC1fu+jqqeQIxrLPhfJaRk8lF8JWp/Sud5WwB6C1qt4gXokszOLjSzU/HoHVNtyOUEM7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723711910; c=relaxed/simple;
	bh=02Mtuy/3IuxEbBZmqPQ8reBLkEA5xqqO54/7nXobsns=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ivw+f+m4l2BTu6GQoJH6NWvmk5CQNLaz78dT/56Wm4bNkZ8kLP2Pruyu5N4lg3i5dAhNbeDvZ+XEqvNlt2eTm6Nh+XMylRrV91QHzCtHItcoHcJv/B5dXqpu/Qe2N2Zyf7ras5QWa5kSHuB5+jBLAbLERYhUQcEUeAhJwNRNQlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1seW4L-004oTV-0D;
	Thu, 15 Aug 2024 16:51:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Aug 2024 16:51:38 +0800
Date: Thu, 15 Aug 2024 16:51:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	Bhoomika K <bhoomikak@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: spacc - Use crypto_authenc_extractkeys
Message-ID: <Zr3Bmpcc4Y3hJNux@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use the crypto_authenc_extractkeys helper rather than ad-hoc parsing.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/dwc-spacc/spacc_aead.c b/drivers/crypto/dwc-spacc/spacc_aead.c
index 3468ff605957..3a617da9007d 100755
--- a/drivers/crypto/dwc-spacc/spacc_aead.c
+++ b/drivers/crypto/dwc-spacc/spacc_aead.c
@@ -5,7 +5,6 @@
 #include <crypto/gcm.h>
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
-#include <linux/rtnetlink.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
 #include <linux/platform_device.h>
@@ -540,15 +539,13 @@ static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 {
 	struct spacc_crypto_ctx *ctx  = crypto_aead_ctx(tfm);
 	const struct spacc_alg  *salg = spacc_tfm_aead(&tfm->base);
+	struct crypto_authenc_keys authenc_keys;
 	struct spacc_priv	*priv;
-	struct rtattr *rta = (void *)key;
-	struct crypto_authenc_key_param *param;
 	unsigned int authkeylen, enckeylen;
 	const unsigned char *authkey, *enckey;
 	unsigned char xcbc[64];
-
-	int err = -EINVAL;
 	int singlekey = 0;
+	int err;
 
 	/* are keylens valid? */
 	ctx->ctx_valid = false;
@@ -569,26 +566,14 @@ static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		goto skipover;
 	}
 
-	if (!RTA_OK(rta, keylen)		       ||
-	    rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM ||
-	    RTA_PAYLOAD(rta) < sizeof(*param))
-		return -EINVAL;
+	err = crypto_authenc_extractkeys(&authenc_keys, key, keylen);
+	if (err)
+		return err;
 
-	param	  = RTA_DATA(rta);
-	enckeylen = be32_to_cpu(param->enckeylen);
-	key	 += RTA_ALIGN(rta->rta_len);
-	keylen	 -= RTA_ALIGN(rta->rta_len);
-
-	if (keylen < enckeylen)
-		return -EINVAL;
-
-	authkeylen = keylen - enckeylen;
-
-	/* enckey is at &key[authkeylen] and
-	 * authkey is at &key[0]
-	 */
-	authkey = &key[0];
-	enckey  = &key[authkeylen];
+	authkeylen = authenc_keys.authkeylen;
+	authkey = authenc_keys.authkey;
+	enckeylen = authenc_keys.enckeylen;
+	enckey  = authenc_keys.enckey;
 
 skipover:
 	/* detect RFC3686/4106 and trim from enckeylen(and copy salt..) */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
