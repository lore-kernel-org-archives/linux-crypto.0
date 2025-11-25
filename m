Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44154224AF2
	for <linux-crypto@vger.kernel.org>; Tue, 25 Nov 2025 19:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764097523; cv=none; b=iT9DMWVRx2zqEi4CftYcXGWDA0T7Hn8b9bDkd9MyZQvawnNCr3DT3tCdutz5sdEpVaiYZoHEjgJwmrX5shKxasRbyqowR31/aPLlJ/FZcnTL5pNUqA1c5qzg3nVUAD5knfn7v60lqKxPBHBxH2OrsrcGmUCVfa/JtR+HWtiR+mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764097523; c=relaxed/simple;
	bh=QHPAH5dQHLvhxC4DA5235pvXPT1tBA9Br+P6aQDS5y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPq4qJNgin7hIpgtuQQ8r6GA//BO/EBwmWtkzpyPUQQjqYuJpkbGO7LttNXsz6T/K19qLk6hzNFBS9t1ANPDsqycS8hJxnTPQBO28cFnlMa7Ls+hREYGOXqfwwv5Z9MpWitTBuekl7XZZlW62vJVY7rFyEqKZXm1u8OWU1LlsQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=qhVJPlot; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="qhVJPlot"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1764097521;
	bh=QHPAH5dQHLvhxC4DA5235pvXPT1tBA9Br+P6aQDS5y0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:From;
	b=qhVJPlotQ/plyi+4zVtliQ8NEyQGuuTN2Q4neHeRz5fg448dmDXTPk/oBrpwnvGab
	 tcUBfHQtwkwfABpyI7FBJxy3t+htiTCPfsSD9KlaLluU9h8ypxgrIdyBgP837AY+7a
	 8So1z+aeXsk16cp1w3ShS+WmvLrURIT6bo5/Yhqc=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 295461C015F;
	Tue, 25 Nov 2025 14:05:21 -0500 (EST)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH 2/2] crypto: pkcs7: add tests for pkcs7_get_authattr
Date: Tue, 25 Nov 2025 14:02:56 -0500
Message-ID: <20251125190256.4034-3-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251125190256.4034-1-James.Bottomley@HansenPartnership.com>
References: <20251125190256.4034-1-James.Bottomley@HansenPartnership.com>
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

---

I'm not convinced this needs adding, but it provided a convenient
mechanism for testing the pcks7_get_authattr() call so I added it in
case others find it useful.
---
 crypto/asymmetric_keys/pkcs7_key_type.c | 27 ++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index b930d3bbf1af..d67bf1dc96b9 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -12,6 +12,7 @@
 #include <linux/verification.h>
 #include <linux/key-type.h>
 #include <keys/user-type.h>
+#include <crypto/pkcs7.h>
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PKCS#7 testing key type");
@@ -51,16 +52,40 @@ static int pkcs7_view_content(void *ctx, const void *data, size_t len,
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
+	ret = pkcs7_get_authattr(pkcs7, OID_messageDigest, &data, &len);
+	if (ret) {
+		pr_err("Failed to get message digest\n");
+		goto out;
+	}
+
+	pr_info("Correctly Got message hash, size=%ld\n", len);
+
+ out:
+	pkcs7_free_message(pkcs7);
+	return 0;
 }
 
 /*
-- 
2.51.0

