Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055C4189B9D
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 07:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744789714; cv=none; b=ipQ+n+GcwXnq5rf2pzZ1BPCXAjY453rlRJDBpUKbBQjAvDB0LQxJodey1UXwcM850kxbDsbmcFz5FKXMj7GpOyKwvc3OfZF9Q3zI306qas7knOjRTjuKTnH/WBLozdNDJ0Wkq7421w4/mBF93UqvObFHtF2261wO2/CLFPQYsZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744789714; c=relaxed/simple;
	bh=m4RnQ4fN5PK1CEMAjifX3R532O/9egbF6GtBBJDTbwo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qZU9/3E7EgU+XjfVHaxphXQTZxzx/dXWWI4OH24JkVD4nLYcxreMQj8OAK/YXDn/0IbN3oyHkFD4KLUB7/u8J8dT9VMrvtfKOnTryAmaFCEBkGBrEgzRHZaw2wmq2NTCpuUSOe3GoAs27aV2J97z3cbIGZ687kU81yvPX9H8lMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=b9S8BVGD; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="b9S8BVGD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gMDoZ9hw/rozkyhQy+LVzGOuJi1u6TwN4f4luEZaN8o=; b=b9S8BVGDxTdDWGiCqkYpnrnXoF
	+m77K45SJQ1tW7HMKpqI2q5A8wWngekqpLVxkWNG31+hniuQr9TkO+qeSsbQyjAPDIORkJMsi/nct
	CQqsz26oxFQBy95xkP4f1v+9zup0bPN2FRVYDypfq4K+/jBsVGsL1nP9Z8LZeqHPfI2T51EbHM53Q
	oM5ldfBh33YLmuvvgXKr4NaD11NIr6vvjZYlMmDsum+Fw00431uP7szNvPVlj747Q3HkRzYy6MOaK
	zMcMAh5Z1miNSPdgQr2O5kGMpFC/I9p64wpiRfWqLi1iy9FkqWWIiLWrgxVgV6O/veEBAzs48Dzqz
	emrceuTw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4xVS-00G7il-18;
	Wed, 16 Apr 2025 15:48:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:48:26 +0800
Date: Wed, 16 Apr 2025 15:48:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH] crypto: public_key - Make sig/tfm local to if clause in
 software_key_query
Message-ID: <Z_9gygoIHTH7A9Ma@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The recent code changes in this function triggered a false-positive
maybe-uninitialized warning in software_key_query.  Rearrange the
code by moving the sig/tfm variables into the if clause where they
are actually used.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 89dc887d2c5c..e5b177c8e842 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -163,10 +163,8 @@ static u8 *pkey_pack_u32(u8 *dst, u32 val)
 static int software_key_query(const struct kernel_pkey_params *params,
 			      struct kernel_pkey_query *info)
 {
-	struct crypto_akcipher *tfm;
 	struct public_key *pkey = params->key->payload.data[asym_crypto];
 	char alg_name[CRYPTO_MAX_ALG_NAME];
-	struct crypto_sig *sig;
 	u8 *key, *ptr;
 	int ret, len;
 	bool issig;
@@ -191,6 +189,8 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	memset(info, 0, sizeof(*info));
 
 	if (issig) {
+		struct crypto_sig *sig;
+
 		sig = crypto_alloc_sig(alg_name, 0, 0);
 		if (IS_ERR(sig)) {
 			ret = PTR_ERR(sig);
@@ -202,7 +202,7 @@ static int software_key_query(const struct kernel_pkey_params *params,
 		else
 			ret = crypto_sig_set_pubkey(sig, key, pkey->keylen);
 		if (ret < 0)
-			goto error_free_tfm;
+			goto error_free_sig;
 
 		len = crypto_sig_keysize(sig);
 		info->key_size = len;
@@ -221,7 +221,12 @@ static int software_key_query(const struct kernel_pkey_params *params,
 			if (pkey->key_is_private)
 				info->supported_ops |= KEYCTL_SUPPORTS_DECRYPT;
 		}
+
+error_free_sig:
+		crypto_free_sig(sig);
 	} else {
+		struct crypto_akcipher *tfm;
+
 		tfm = crypto_alloc_akcipher(alg_name, 0, 0);
 		if (IS_ERR(tfm)) {
 			ret = PTR_ERR(tfm);
@@ -233,7 +238,7 @@ static int software_key_query(const struct kernel_pkey_params *params,
 		else
 			ret = crypto_akcipher_set_pub_key(tfm, key, pkey->keylen);
 		if (ret < 0)
-			goto error_free_tfm;
+			goto error_free_akcipher;
 
 		len = crypto_akcipher_maxsize(tfm);
 		info->key_size = len * BITS_PER_BYTE;
@@ -245,15 +250,11 @@ static int software_key_query(const struct kernel_pkey_params *params,
 		info->supported_ops = KEYCTL_SUPPORTS_ENCRYPT;
 		if (pkey->key_is_private)
 			info->supported_ops |= KEYCTL_SUPPORTS_DECRYPT;
+
+error_free_akcipher:
+		crypto_free_akcipher(tfm);
 	}
 
-	ret = 0;
-
-error_free_tfm:
-	if (issig)
-		crypto_free_sig(sig);
-	else
-		crypto_free_akcipher(tfm);
 error_free_key:
 	kfree_sensitive(key);
 	pr_devel("<==%s() = %d\n", __func__, ret);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
