Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2831E366;
	Wed, 22 Oct 2025 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153637; cv=none; b=KdICpo0pJCKnohHpc3AfrlJskACACZzN5OCHsTLOKdlovWSLAJ+bluc8xvO+1fu9XUz6vd2B7h7BEHtv+Q76vxxq4qGrdel2IXlJQob4fqIadBUQ8+pyHDf67E56UzhH0znkFr0muQ0rO70DaW3hm/QuGIxdtV6RrHTN+LPrmF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153637; c=relaxed/simple;
	bh=UzXFscK7ZrDgpE46l6OobuZueeZYS8sRv7hF578oKpI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hmB+Nyi2DpUGWKAX12e7T1lZOo+idnwVya4j6Q+ozoIh0ctJu28Fps2vkMuO1hNLP/XRkOrNlAjOZvzer7E3UY58mpHRumWrrkqC7llmI/Upn4WP+fKzcHSBfBCJbzFfmX09Hxb2LdKm98BLHgQuc6vyR1BjIsUQB0tH/ZoFKRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=U4/+3+yk; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="U4/+3+yk"
Received: from fllvem-sh04.itg.ti.com ([10.64.41.54])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 59MHKRXF1469374;
	Wed, 22 Oct 2025 12:20:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1761153627;
	bh=MdvdD5mimjpuIfdxMCPPZDwKw2INByWlalile2YS6KI=;
	h=From:To:CC:Subject:Date;
	b=U4/+3+ykakNhQHPvJFsGRzCqh43aYXSBC5sSrjR1u2LYOOlxOgYbgG37hgTjZ0I4j
	 Eo6VFiRym9SbquVYzqQUFHfP81JbxaFtNqmf8CDFeCmfVyMYnRBceZhs9FUjxXxKOm
	 YB2kG4Eh2ai4JyX1SPpFE3osIDPCPKC4Qot/LiAc=
Received: from DFLE204.ent.ti.com (dfle204.ent.ti.com [10.64.6.62])
	by fllvem-sh04.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 59MHKR8W1761746
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 22 Oct 2025 12:20:27 -0500
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 22 Oct
 2025 12:20:27 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 22 Oct 2025 12:20:27 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 59MHKPjs1551845;
	Wed, 22 Oct 2025 12:20:26 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Shiva Tripathi <s-tripathi1@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: aead - Add support for on-stack AEAD req allocation
Date: Wed, 22 Oct 2025 22:48:42 +0530
Message-ID: <20251022171902.724369-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

This patch introduces infrastructure for allocating req objects on the
stack for AEADs. The additions mirror the existing sync skcipher APIs.
This can be used in cases where simple sync AEAD operations are being
done. So allocating the request on stack avoides possible out-of-memory
errors.

The struct crypto_sync_aead is a wrapper around crypto_aead and should
be used in its place when sync only requests will be done on the stack.
Correspondingly, the request should be allocated with
SYNC_AEAD_REQUEST_ON_STACK().

Similar to sync_skcipher APIs, the new sync_aead APIs are wrappers
around the regular aead APIs to facilitate sync only operations. The
following crypto APIs are added:
 - struct crypto_sync_aead
 - crypto_alloc_sync_aead()
 - crypto_free_sync_aead()
 - crypto_aync_aead_tfm()
 - crypto_sync_aead_setkey()
 - crypto_sync_aead_setauthsize()
 - crypto_sync_aead_authsize()
 - crypto_sync_aead_maxauthsize()
 - crypto_sync_aead_ivsize()
 - crypto_sync_aead_blocksize()
 - crypto_sync_aead_get_flags()
 - crypto_sync_aead_set_flags()
 - crypto_sync_aead_clear_flags()
 - crypto_sync_aead_reqtfm()
 - aead_request_set_sync_tfm()
 - SYNC_AEAD_REQUEST_ON_STACK()

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 crypto/aead.c         | 19 ++++++++++
 include/crypto/aead.h | 87 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index 51ab3af691af2..08d44c5e5c336 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -205,6 +205,25 @@ struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_aead);
 
+struct crypto_sync_aead *crypto_alloc_sync_aead(const char *alg_name, u32 type, u32 mask)
+{
+	struct crypto_aead *tfm;
+
+	/* Only sync algorithms are allowed. */
+	mask |= CRYPTO_ALG_ASYNC;
+	type &= ~(CRYPTO_ALG_ASYNC);
+
+	tfm = crypto_alloc_tfm(alg_name, &crypto_aead_type, type, mask);
+
+	if (!IS_ERR(tfm) && WARN_ON(crypto_aead_reqsize(tfm) > MAX_SYNC_AEAD_REQSIZE)) {
+		crypto_free_aead(tfm);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return (struct crypto_sync_aead *)tfm;
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_sync_aead);
+
 int crypto_has_aead(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_aead_type, type, mask);
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 0e8a416386780..8e66a1fa9c786 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -159,6 +159,21 @@ struct crypto_aead {
 	struct crypto_tfm base;
 };
 
+struct crypto_sync_aead {
+	struct crypto_aead base;
+};
+
+#define MAX_SYNC_AEAD_REQSIZE		384
+
+#define SYNC_AEAD_REQUEST_ON_STACK(name, _tfm)		\
+	char __##name##_desc[sizeof(struct aead_request) +	\
+			     MAX_SYNC_AEAD_REQSIZE		\
+			    ] CRYPTO_MINALIGN_ATTR;		\
+	struct aead_request *name =				\
+		(((struct aead_request *)__##name##_desc)->base.tfm = \
+			crypto_sync_aead_tfm((_tfm)),		\
+		 (void *)__##name##_desc)
+
 static inline struct crypto_aead *__crypto_aead_cast(struct crypto_tfm *tfm)
 {
 	return container_of(tfm, struct crypto_aead, base);
@@ -180,11 +195,18 @@ static inline struct crypto_aead *__crypto_aead_cast(struct crypto_tfm *tfm)
  */
 struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask);
 
+struct crypto_sync_aead *crypto_alloc_sync_aead(const char *alg_name, u32 type, u32 mask);
+
 static inline struct crypto_tfm *crypto_aead_tfm(struct crypto_aead *tfm)
 {
 	return &tfm->base;
 }
 
+static inline struct crypto_tfm *crypto_sync_aead_tfm(struct crypto_sync_aead *tfm)
+{
+	return crypto_aead_tfm(&tfm->base);
+}
+
 /**
  * crypto_free_aead() - zeroize and free aead handle
  * @tfm: cipher handle to be freed
@@ -196,6 +218,11 @@ static inline void crypto_free_aead(struct crypto_aead *tfm)
 	crypto_destroy_tfm(tfm, crypto_aead_tfm(tfm));
 }
 
+static inline void crypto_free_sync_aead(struct crypto_sync_aead *tfm)
+{
+	crypto_free_aead(&tfm->base);
+}
+
 /**
  * crypto_has_aead() - Search for the availability of an aead.
  * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
@@ -238,6 +265,11 @@ static inline unsigned int crypto_aead_ivsize(struct crypto_aead *tfm)
 	return crypto_aead_alg_ivsize(crypto_aead_alg(tfm));
 }
 
+static inline unsigned int crypto_sync_aead_ivsize(struct crypto_sync_aead *tfm)
+{
+	return crypto_aead_ivsize(&tfm->base);
+}
+
 /**
  * crypto_aead_authsize() - obtain maximum authentication data size
  * @tfm: cipher handle
@@ -255,6 +287,11 @@ static inline unsigned int crypto_aead_authsize(struct crypto_aead *tfm)
 	return tfm->authsize;
 }
 
+static inline unsigned int crypto_sync_aead_authsize(struct crypto_sync_aead *tfm)
+{
+	return crypto_aead_authsize(&tfm->base);
+}
+
 static inline unsigned int crypto_aead_alg_maxauthsize(struct aead_alg *alg)
 {
 	return alg->maxauthsize;
@@ -265,6 +302,11 @@ static inline unsigned int crypto_aead_maxauthsize(struct crypto_aead *aead)
 	return crypto_aead_alg_maxauthsize(crypto_aead_alg(aead));
 }
 
+static inline unsigned int crypto_sync_aead_maxauthsize(struct crypto_sync_aead *tfm)
+{
+	return crypto_aead_maxauthsize(&tfm->base);
+}
+
 /**
  * crypto_aead_blocksize() - obtain block size of cipher
  * @tfm: cipher handle
@@ -280,6 +322,11 @@ static inline unsigned int crypto_aead_blocksize(struct crypto_aead *tfm)
 	return crypto_tfm_alg_blocksize(crypto_aead_tfm(tfm));
 }
 
+static inline unsigned int crypto_sync_aead_blocksize(struct crypto_sync_aead *tfm)
+{
+	return crypto_aead_blocksize(&tfm->base);
+}
+
 static inline unsigned int crypto_aead_alignmask(struct crypto_aead *tfm)
 {
 	return crypto_tfm_alg_alignmask(crypto_aead_tfm(tfm));
@@ -300,6 +347,21 @@ static inline void crypto_aead_clear_flags(struct crypto_aead *tfm, u32 flags)
 	crypto_tfm_clear_flags(crypto_aead_tfm(tfm), flags);
 }
 
+static inline u32 crypto_sync_aead_get_flags(struct crypto_sync_aead *tfm)
+{
+	return crypto_aead_get_flags(&tfm->base);
+}
+
+static inline void crypto_sync_aead_set_flags(struct crypto_sync_aead *tfm, u32 flags)
+{
+	crypto_aead_set_flags(&tfm->base, flags);
+}
+
+static inline void crypto_sync_aead_clear_flags(struct crypto_sync_aead *tfm, u32 flags)
+{
+	crypto_aead_clear_flags(&tfm->base, flags);
+}
+
 /**
  * crypto_aead_setkey() - set key for cipher
  * @tfm: cipher handle
@@ -319,6 +381,12 @@ static inline void crypto_aead_clear_flags(struct crypto_aead *tfm, u32 flags)
 int crypto_aead_setkey(struct crypto_aead *tfm,
 		       const u8 *key, unsigned int keylen);
 
+static inline int crypto_sync_aead_setkey(struct crypto_sync_aead *tfm,
+					 const u8 *key, unsigned int keylen)
+{
+	return crypto_aead_setkey(&tfm->base, key, keylen);
+}
+
 /**
  * crypto_aead_setauthsize() - set authentication data size
  * @tfm: cipher handle
@@ -331,11 +399,24 @@ int crypto_aead_setkey(struct crypto_aead *tfm,
  */
 int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize);
 
+static inline int crypto_sync_aead_setauthsize(struct crypto_sync_aead *tfm,
+					       unsigned int authsize)
+{
+	return crypto_aead_setauthsize(&tfm->base, authsize);
+}
+
 static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
 {
 	return __crypto_aead_cast(req->base.tfm);
 }
 
+static inline struct crypto_sync_aead *crypto_sync_aead_reqtfm(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+
+	return container_of(tfm, struct crypto_sync_aead, base);
+}
+
 /**
  * crypto_aead_encrypt() - encrypt plaintext
  * @req: reference to the aead_request handle that holds all information
@@ -417,6 +498,12 @@ static inline void aead_request_set_tfm(struct aead_request *req,
 	req->base.tfm = crypto_aead_tfm(tfm);
 }
 
+static inline void aead_request_set_sync_tfm(struct aead_request *req,
+					     struct crypto_sync_aead *tfm)
+{
+	aead_request_set_tfm(req, &tfm->base);
+}
+
 /**
  * aead_request_alloc() - allocate request data structure
  * @tfm: cipher handle to be registered with the request
-- 
2.43.0

