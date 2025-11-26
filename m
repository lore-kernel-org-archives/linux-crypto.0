Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DD72750FE
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 20:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764188755; cv=none; b=Q7ADjYCN1PUkWSsIfk0kpzQHiIlgrS4pFlFsksHr04FJ0M+yU8C3h9Y+EdeernfIJIGvVCZQs9pN0cl26qJHamgMM1eaiB+BXUbMA1rUPbpaJ+XvxJbqJupTt/j1tsv1dKS3f7tp+h3u+jBCof0uSv6v5vDA/n66bmUOV4OMW3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764188755; c=relaxed/simple;
	bh=+42Z2fcfOSHO058y5xYcG+oWCR9Tb56UUhuNvCnrMT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikwwn0CCBAOgme3GfTRxVfIVuZpjuJpOAyarBvpYoiQ1c2ejICIOq5tPlVQZ58yqtras0WzrlFeSmpSPI8Jtd1Up2eslgq7EK6mgy2MaMfVTabKVBevIYRIVUAtKE0WShjJG/ZYQTEb25u6xefvoyGB7AaP2uZIUUSackTpgCMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=eA7ZqMx7; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="eA7ZqMx7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1764188752;
	bh=+42Z2fcfOSHO058y5xYcG+oWCR9Tb56UUhuNvCnrMT4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:From;
	b=eA7ZqMx7y5iunYZnRisrxMb6IxDTyQ+xpvFSNMN8rR3a1XE1q4UrF3pj1rfTjewtl
	 hG5ihHl4Sf9xp+/vy5nzhScAknjQiFv3P7CbIpHaCYu11KjAoblN4a55MX3rFYFRzQ
	 U8CqNYW+zkviAhgAkkVPKv/HVkjcNwW3YY1zEndw=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 6EC9C1C01BC;
	Wed, 26 Nov 2025 15:25:52 -0500 (EST)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH v2 3/5] crypto: pkcs7: allow pkcs7_digest() to be called from pkcs7_trust
Date: Wed, 26 Nov 2025 15:24:03 -0500
Message-ID: <20251126202405.23596-4-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126202405.23596-1-James.Bottomley@HansenPartnership.com>
References: <20251126202405.23596-1-James.Bottomley@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trying to run pkcs7_validate_trust() on something that parsed
correctly but is not verified doesn't work because the signature
digest hasn't been calculated.  Fix this by adding a digest calclation
in to pkcs7_validate_one().  This is almost a nop if the digest exists.

Additionally, the trust validation doesn't know the data payload, so
adjust the digest calculator to skip checking the data digest if
pkcs7->data is NULL.  A check is added in pkcs7_verify() for
pkcs7->data being null (returning -EBADMSG) to guard against someone
forgetting to supply data and getting an invalid success return.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 crypto/asymmetric_keys/pkcs7_parser.h |  3 +++
 crypto/asymmetric_keys/pkcs7_trust.c  |  8 ++++++++
 crypto/asymmetric_keys/pkcs7_verify.c | 13 +++++++++----
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index 344340cfa6c1..179cd1cdbe22 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -63,3 +63,6 @@ struct pkcs7_message {
 	size_t		data_hdrlen;	/* Length of Data ASN.1 header */
 	const void	*data;		/* Content Data (or 0) */
 };
+
+int pkcs7_digest(struct pkcs7_message *pkcs7,
+		 struct pkcs7_signed_info *sinfo);
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 78ebfb6373b6..7cb0a6bc7b32 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -30,6 +30,14 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 
 	kenter(",%u,", sinfo->index);
 
+	/*
+	 * if we're being called immediately after parse, the
+	 * signature won't have a calculated digest yet, so calculate
+	 * one.  This function returns immediately if a digest has
+	 * already been calculated
+	 */
+	pkcs7_digest(pkcs7, sinfo);
+
 	if (sinfo->unsupported_crypto) {
 		kleave(" = -ENOPKG [cached]");
 		return -ENOPKG;
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 6d6475e3a9bf..19b3999381e6 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -19,8 +19,8 @@
 /*
  * Digest the relevant parts of the PKCS#7 data
  */
-static int pkcs7_digest(struct pkcs7_message *pkcs7,
-			struct pkcs7_signed_info *sinfo)
+int pkcs7_digest(struct pkcs7_message *pkcs7,
+		 struct pkcs7_signed_info *sinfo)
 {
 	struct public_key_signature *sig = sinfo->sig;
 	struct crypto_shash *tfm;
@@ -85,8 +85,8 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 			goto error;
 		}
 
-		if (memcmp(sig->digest, sinfo->msgdigest,
-			   sinfo->msgdigest_len) != 0) {
+		if (pkcs7->data && memcmp(sig->digest, sinfo->msgdigest,
+					  sinfo->msgdigest_len) != 0) {
 			pr_warn("Sig %u: Message digest doesn't match\n",
 				sinfo->index);
 			ret = -EKEYREJECTED;
@@ -439,6 +439,11 @@ int pkcs7_verify(struct pkcs7_message *pkcs7,
 		return -EINVAL;
 	}
 
+	if (!pkcs7->data) {
+		pr_warn("Data not supplied to verify operation\n");
+		return -EBADMSG;
+	}
+
 	for (sinfo = pkcs7->signed_infos; sinfo; sinfo = sinfo->next) {
 		ret = pkcs7_verify_one(pkcs7, sinfo);
 		if (sinfo->blacklisted) {
-- 
2.51.0

