Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1BB22339
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 20:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764188831; cv=none; b=kO1rPr3cPR9Giotb/h2wAoZO+LUP6s41eABmSIwPYKubyeqwBN4rtjj3GmTe29b0d+Uu8wUUyLs7M9edKqIRwV6jjOd+NEQfnzNI7NoXc8nUo6orYXnFjenT1V6o101DomMV2tD1LYRTjSAQ4eitFFOefReTBeCtZA8f0nFsRHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764188831; c=relaxed/simple;
	bh=oVVNIzhi8Bf+8eeyVPoVXbgP4/5EILgasiFbK0jJm2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFff53OyLh7VtRBeoG7DQXlvln7dW6wYgidcoQEPTUVUHpsSOcQkmKyy69gpap+xZPzeuSiTAT4xpHDWgJzdsKasqLcacw7lmDLSHRQ1c0DIpy6xe8XwChfYLAe3n3KZV3PwtcDDmfJLC6zR9OYDehrClTUBOPNyLhDy0fFKhgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=HtjMPpDW; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="HtjMPpDW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1764188829;
	bh=oVVNIzhi8Bf+8eeyVPoVXbgP4/5EILgasiFbK0jJm2M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:From;
	b=HtjMPpDWhqNJK6gdo4McZw1WdotKFT/UREQwW90oEDG1yXxxR1XxvLCUzU6oXDuDf
	 tZZq/vwMUpJ1po+cuD24JYCXIuHVNSFMJUynD7eXKGba8AfgZ62eCNDqVVIo1RJAjB
	 QEccrgibBL25kKt8L1UrJSmWAM3aDiBx+FX9DP5I=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 19E531C01BC;
	Wed, 26 Nov 2025 15:27:09 -0500 (EST)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH v2 5/5] crypto: pkcs7: add tests for pkcs7_get_authattr
Date: Wed, 26 Nov 2025 15:24:05 -0500
Message-ID: <20251126202405.23596-6-James.Bottomley@HansenPartnership.com>
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

Add example code to the test module pkcs7_key_type.c that verifies a
message and then pulls out a known authenticated attribute.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Acked-by: David Howells <dhowells@redhat.com>

---
v2: add ack

I'm not convinced this needs adding, but it provided a convenient
mechanism for testing the pcks7_get_authattr() call so I added it in
case others find it useful.
---
 crypto/asymmetric_keys/pkcs7_key_type.c | 42 ++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index b930d3bbf1af..5a1ecb5501b2 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -12,6 +12,7 @@
 #include <linux/verification.h>
 #include <linux/key-type.h>
 #include <keys/user-type.h>
+#include <crypto/pkcs7.h>
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PKCS#7 testing key type");
@@ -51,16 +52,55 @@ static int pkcs7_view_content(void *ctx, const void *data, size_t len,
 static int pkcs7_preparse(struct key_preparsed_payload *prep)
 {
 	enum key_being_used_for usage = pkcs7_usage;
+	int ret;
+	struct pkcs7_message *pkcs7;
+	const void *data;
+	size_t len;
 
 	if (usage >= NR__KEY_BEING_USED_FOR) {
 		pr_err("Invalid usage type %d\n", usage);
 		return -EINVAL;
 	}
 
-	return verify_pkcs7_signature(NULL, 0,
+	ret = verify_pkcs7_signature(NULL, 0,
 				      prep->data, prep->datalen,
 				      VERIFY_USE_SECONDARY_KEYRING, usage,
 				      pkcs7_view_content, prep);
+	if (ret)
+		return ret;
+
+	pkcs7 = pkcs7_parse_message(prep->data, prep->datalen);
+	if (IS_ERR(pkcs7)) {
+		pr_err("pkcs7 parse error\n");
+		return PTR_ERR(pkcs7);
+	}
+
+	/*
+	 * the parsed message has no trusted signer, so nothing should
+	 * be returned here
+	 */
+	ret = pkcs7_get_authattr(pkcs7, OID_messageDigest, &data, &len);
+	if (ret == 0) {
+		pr_err("OID returned when no trust in signer\n");
+		goto out;
+	}
+	/* add trust and check again */
+	ret = validate_pkcs7_trust(pkcs7, VERIFY_USE_SECONDARY_KEYRING);
+	if (ret) {
+		pr_err("validate_pkcs7_trust failed!!\n");
+		goto out;
+	}
+	/* now we should find the OID */
+	ret = pkcs7_get_authattr(pkcs7, OID_messageDigest, &data, &len);
+	if (ret) {
+		pr_err("Failed to get message digest\n");
+		goto out;
+	}
+	pr_info("Correctly Got message hash, size=%ld\n", len);
+
+ out:
+	pkcs7_free_message(pkcs7);
+	return 0;
 }
 
 /*
-- 
2.51.0

