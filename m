Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACFA3128D7
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 20:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764188699; cv=none; b=ZqsfcqnVaSlAdN/3VIcPXOWRaqVRAaHigkVLgyNFzL7h6fB5Yi6oHYZxzYQCksylDDN9kR318coJ0Cf0cESKAahIya6cRXBk6hox8qYh/S6jX//2JC5eheNfj255D0YXFihvhDQo26saA2/42D2Do66J3HnfztOmN27b4+o3J9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764188699; c=relaxed/simple;
	bh=2wTii2pedSNLbTdEgS8mRXNGP6T5uZqKwhRfrlLdl3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTU/om3yGCtrTRVwz6cNm8cfYef83K67oa5K4mLaEtICeJnwFHvvtVjWhk9bVyWYZApquHqyHzIh9xHrP28F/wguYMkkNYC+Jy2anDfwRIPQEhPWba7IXvwSdG2UJ6ycVI92Qy7QVwV8YrVmppOq5E+F1eLIxsspxlTYIsaJeJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=hOwax353; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="hOwax353"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1764188696;
	bh=2wTii2pedSNLbTdEgS8mRXNGP6T5uZqKwhRfrlLdl3M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:From;
	b=hOwax353lTnpzOerel5U9QJLmpnnznz1fk/BN9D385RMc9Ir0Ssfz2KTjxbzKnFnj
	 sZUqv2VbUUB+5tLkmoXe0SjVyZSKrHAGw4oOLNCJ5QOWedTjyNAEmSwT/lBxTaTcqD
	 CgafNm1SRLiyYlNe9EJh3ChHBxCv8J5OojiYZlg4=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 26BB81C01BC;
	Wed, 26 Nov 2025 15:24:56 -0500 (EST)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH v2 1/5] certs: break out pkcs7 check into its own function
Date: Wed, 26 Nov 2025 15:24:01 -0500
Message-ID: <20251126202405.23596-2-James.Bottomley@HansenPartnership.com>
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

Add new validate_pkcs7_trust() function which can operate on the
system keyrings and is simply some of the innards of
verify_pkcs7_message_sig().

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 certs/system_keyring.c       | 76 +++++++++++++++++++++---------------
 include/linux/verification.h |  2 +
 2 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index 9de610bf1f4b..807ab4a6fc7e 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -298,42 +298,19 @@ late_initcall(load_system_certificate_list);
 #ifdef CONFIG_SYSTEM_DATA_VERIFICATION
 
 /**
- * verify_pkcs7_message_sig - Verify a PKCS#7-based signature on system data.
- * @data: The data to be verified (NULL if expecting internal data).
- * @len: Size of @data.
+ * validate_pkcs7_trust - add trust markers based on keyring
  * @pkcs7: The PKCS#7 message that is the signature.
  * @trusted_keys: Trusted keys to use (NULL for builtin trusted keys only,
  *					(void *)1UL for all trusted keys).
- * @usage: The use to which the key is being put.
- * @view_content: Callback to gain access to content.
- * @ctx: Context for callback.
  */
-int verify_pkcs7_message_sig(const void *data, size_t len,
-			     struct pkcs7_message *pkcs7,
-			     struct key *trusted_keys,
-			     enum key_being_used_for usage,
-			     int (*view_content)(void *ctx,
-						 const void *data, size_t len,
-						 size_t asn1hdrlen),
-			     void *ctx)
+int validate_pkcs7_trust(struct pkcs7_message *pkcs7, struct key *trusted_keys)
 {
 	int ret;
 
-	/* The data should be detached - so we need to supply it. */
-	if (data && pkcs7_supply_detached_data(pkcs7, data, len) < 0) {
-		pr_err("PKCS#7 signature with non-detached data\n");
-		ret = -EBADMSG;
-		goto error;
-	}
-
-	ret = pkcs7_verify(pkcs7, usage);
-	if (ret < 0)
-		goto error;
-
 	ret = is_key_on_revocation_list(pkcs7);
 	if (ret != -ENOKEY) {
 		pr_devel("PKCS#7 key is on revocation list\n");
-		goto error;
+		return ret;
 	}
 
 	if (!trusted_keys) {
@@ -351,18 +328,55 @@ int verify_pkcs7_message_sig(const void *data, size_t len,
 		trusted_keys = NULL;
 #endif
 		if (!trusted_keys) {
-			ret = -ENOKEY;
 			pr_devel("PKCS#7 platform keyring is not available\n");
-			goto error;
+			return -ENOKEY;
 		}
 	}
 	ret = pkcs7_validate_trust(pkcs7, trusted_keys);
-	if (ret < 0) {
-		if (ret == -ENOKEY)
-			pr_devel("PKCS#7 signature not signed with a trusted key\n");
+	if (ret == -ENOKEY)
+		pr_devel("PKCS#7 signature not signed with a trusted key\n");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(validate_pkcs7_trust);
+
+/**
+ * verify_pkcs7_message_sig - Verify a PKCS#7-based signature on system data.
+ * @data: The data to be verified (NULL if expecting internal data).
+ * @len: Size of @data.
+ * @pkcs7: The PKCS#7 message that is the signature.
+ * @trusted_keys: Trusted keys to use (NULL for builtin trusted keys only,
+ *					(void *)1UL for all trusted keys).
+ * @usage: The use to which the key is being put.
+ * @view_content: Callback to gain access to content.
+ * @ctx: Context for callback.
+ */
+int verify_pkcs7_message_sig(const void *data, size_t len,
+			     struct pkcs7_message *pkcs7,
+			     struct key *trusted_keys,
+			     enum key_being_used_for usage,
+			     int (*view_content)(void *ctx,
+						 const void *data, size_t len,
+						 size_t asn1hdrlen),
+			     void *ctx)
+{
+	int ret;
+
+	/* The data should be detached - so we need to supply it. */
+	if (data && pkcs7_supply_detached_data(pkcs7, data, len) < 0) {
+		pr_err("PKCS#7 signature with non-detached data\n");
+		ret = -EBADMSG;
 		goto error;
 	}
 
+	ret = pkcs7_verify(pkcs7, usage);
+	if (ret < 0)
+		goto error;
+
+	ret = validate_pkcs7_trust(pkcs7, trusted_keys);
+	if (ret < 0)
+		goto error;
+
 	if (view_content) {
 		size_t asn1hdrlen;
 
diff --git a/include/linux/verification.h b/include/linux/verification.h
index dec7f2beabfd..57f1460d36f1 100644
--- a/include/linux/verification.h
+++ b/include/linux/verification.h
@@ -44,6 +44,8 @@ enum key_being_used_for {
 struct key;
 struct pkcs7_message;
 
+extern int validate_pkcs7_trust(struct pkcs7_message *pkcs7,
+				struct key *trusted_keys);
 extern int verify_pkcs7_signature(const void *data, size_t len,
 				  const void *raw_pkcs7, size_t pkcs7_len,
 				  struct key *trusted_keys,
-- 
2.51.0

