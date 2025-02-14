Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FCF3A8D2
	for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2025 06:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739512939; cv=none; b=r+7+LZ9nH3NQTs0lwLQT26rT+vUaC1VpzquCAyrCfOszc+O0cmd5bglcsPsKOd5n0pAB5/VyIK5qSk8Dq948U0OE4tpiq4/qCIQMO17gYLZb3dqshVg/ckBG/VaFAIh7/aDjzBo+mAO4L+rGt6j98MOeHr6IShlb24sos6ue1B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739512939; c=relaxed/simple;
	bh=GbbllElRMsGzuOm2jnzCAx0T1EAEMoQjiK661Viy29E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=m3gQqlqO/96fJxvGlKRUX5FsqM0f+VuM6h68rWonev6R6ITse+bS/b08xppw5PRuXcwZZpJfSt05X3YndS6qid1TgN/2oUpizwBSQLJVLn3d4nK9AZs/QPf8i2GYPCBMcn3zKP+0oeCVSiJciKhANNnJnsJ/e9EdH3y4mk3QBUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nONnULGH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nONnULGH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=x23heio0IpD9cknjyIBlccCScw2o/y3CEF9w17EI8cE=; b=nONnULGH5sounEw0/wLNmZySo+
	jFviAUDcpT8n/IeMBuPcLAlsyJLpeigKNqmkkDijMchLNxLRPbWCN4W45DeY4KwQVMfj5bUbvwqYe
	+KM40uCStotoHRUDvAVGQMNREKDmYOqbtRmu6cZmbYkh4tFDDQvGfy12QJYIYMQQdkoHS5tj1hAmQ
	kz6wq2zWQxhFddnVg2Wz94pJmYaHB8hL3akqeoGWryFz+YD5+tvLl8purmTUvDvXxSpJp6BNDXH9v
	vLzu9OXr2Th0V56NdcLpQSgBkQTnCYBbUHsaP/DxUhZrnA7oiFMk9Uzndr/o5qMIgKAI/ulh+l+7E
	lqMg8T5A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tioZD-000Ez8-2x;
	Fri, 14 Feb 2025 14:02:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Feb 2025 14:02:08 +0800
Date: Fri, 14 Feb 2025 14:02:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: skcipher - Set tfm in SYNC_SKCIPHER_REQUEST_ON_STACK
Message-ID: <Z67cYORHJ2XIENjx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Set the request tfm directly in SYNC_SKCIPHER_REQUEST_ON_STACK since
the tfm is already available.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 18a86e0af016..9e5853464345 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -214,16 +214,17 @@ struct lskcipher_alg {
 
 #define MAX_SYNC_SKCIPHER_REQSIZE      384
 /*
- * This performs a type-check against the "tfm" argument to make sure
+ * This performs a type-check against the "_tfm" argument to make sure
  * all users have the correct skcipher tfm for doing on-stack requests.
  */
-#define SYNC_SKCIPHER_REQUEST_ON_STACK(name, tfm) \
+#define SYNC_SKCIPHER_REQUEST_ON_STACK(name, _tfm) \
 	char __##name##_desc[sizeof(struct skcipher_request) + \
-			     MAX_SYNC_SKCIPHER_REQSIZE + \
-			     (!(sizeof((struct crypto_sync_skcipher *)1 == \
-				       (typeof(tfm))1))) \
+			     MAX_SYNC_SKCIPHER_REQSIZE \
 			    ] CRYPTO_MINALIGN_ATTR; \
-	struct skcipher_request *name = (void *)__##name##_desc
+	struct skcipher_request *name = \
+		(((struct skcipher_request *)__##name##_desc)->base.tfm = \
+			crypto_sync_skcipher_tfm((_tfm)), \
+		 (void *)__##name##_desc)
 
 /**
  * DOC: Symmetric Key Cipher API
@@ -311,6 +312,12 @@ static inline struct crypto_tfm *crypto_lskcipher_tfm(
 	return &tfm->base;
 }
 
+static inline struct crypto_tfm *crypto_sync_skcipher_tfm(
+	struct crypto_sync_skcipher *tfm)
+{
+	return crypto_skcipher_tfm(&tfm->base);
+}
+
 /**
  * crypto_free_skcipher() - zeroize and free cipher handle
  * @tfm: cipher handle to be freed
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
