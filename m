Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A2727A927
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 21:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772054512; cv=none; b=KaqiiBqmyRn5dXn4TTL3kMeN9lYR2kc9HgtKqbzECz0vvZJuvzGCLaBrLqDE+iSKfLVcubr8D27IYuZ7bhG4fmIIGpw0jWLkeNsZm1lDtPLuJcvESngOOp1r9/UP5qZQsb+CvpfNVDMY49u8NiSfrvjKdJsGHYOwWMh3FuHsv4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772054512; c=relaxed/simple;
	bh=oVVNIzhi8Bf+8eeyVPoVXbgP4/5EILgasiFbK0jJm2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHBJj+/PZQxkTcAzCNmhF+d1CnWn/C6z1dpQ8oogeHzSyd+WuxcatUENxaIJwJAzangWQBPoE6KsHSc3uHPOjDiSVprt7A7by0A6STzIzYyTkK/EbKDfnsEp4l2gabSBYqWo2Ogtmh5X6zlWGQoHgVRFQVDZueEEU0/GfNpTY5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=uUaxQqC7; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="uUaxQqC7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1772054510;
	bh=oVVNIzhi8Bf+8eeyVPoVXbgP4/5EILgasiFbK0jJm2M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:From;
	b=uUaxQqC7DxXUhx/93+Q36qA8aayNMTNiI6/dPjvo+YL4nSmXVoyqlF012XffYQygT
	 UNLS2WgbLeGisY32lEaWI863L4lgea15++TrPB2Olr0QxiBtGEamSLXttmQLRAOm12
	 WOqvfbzOFS3TtiWOVIx3RZVhqPwkQEWgx79W/Qrg=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 846F41C02E8;
	Wed, 25 Feb 2026 16:21:50 -0500 (EST)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH v3 5/5] crypto: pkcs7: add tests for pkcs7_get_authattr
Date: Wed, 25 Feb 2026 16:19:07 -0500
Message-ID: <20260225211907.7368-6-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
References: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
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

