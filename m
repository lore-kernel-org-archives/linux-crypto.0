Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9283D6CB6
	for <linux-crypto@vger.kernel.org>; Thu, 19 Mar 2026 19:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773947690; cv=none; b=JHaMqTxHUDvs7DIsL8CJLsyf4FxSlmGhWlfN+3r0xut83z86BJaAzw7dqJS4gl2tR/P3FoBgaRYEPkX2MH8ZU0PRfvEuTY3+OdcUYs2ZpxEGA022jKizHfLYjHWNiai35kI5zY8kyfw7KbK7hhmApXhVaq7T6E1He8GOfUpAYP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773947690; c=relaxed/simple;
	bh=UFfdZ4QkrA8DPTm88hv8CuAvXq0EGqI5NmbNKZrPya4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jckfNF7cAHmPGAy550SE+vAKKhbyGkjstM3Sl9gZ6kYQzsvRuFZMope3r85HTTkFBwbKnjEAsXV5sTLcHW/7Dnmh3XmbSbvAphHj8z4ZhCqEVFmJIw6zPvlE+BxrWHUK184NtNRPirEeQltguzoNPEGs60V5C7YkICRKu3QCw/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=owxt4HnQ; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="owxt4HnQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1773947684;
	bh=UFfdZ4QkrA8DPTm88hv8CuAvXq0EGqI5NmbNKZrPya4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:From;
	b=owxt4HnQ+tP3yjrRJPvHlNuZzPVI2nsrwE+EBC4V7fmS4DCoBgQgwAJWj4HtjjflC
	 WqtFJlRjf6DVUB5ahJJmYDWtLSEORd2x0eTv9KtrlN05PAdB7kXX+KEuRSs1a2xFh2
	 BNwFOH87MdqU6Ndv5yKkbYVSZJNPmtaYv+V8qVng=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 61E941C02ED;
	Thu, 19 Mar 2026 15:14:44 -0400 (EDT)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH v4 3/3] crypto: pkcs7: add tests for pkcs7_get_authattr
Date: Thu, 19 Mar 2026 15:12:08 -0400
Message-ID: <20260319191208.831-4-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260319191208.831-1-James.Bottomley@HansenPartnership.com>
References: <20260319191208.831-1-James.Bottomley@HansenPartnership.com>
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
v4: adjust format specifier for size_t

I'm not convinced this needs adding, but it provided a convenient
mechanism for testing the pcks7_get_authattr() call so I added it in
case others find it useful.
---
 crypto/asymmetric_keys/pkcs7_key_type.c | 44 ++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index b930d3bbf1af..e0b1ce0202f6 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -12,6 +12,7 @@
 #include <linux/verification.h>
 #include <linux/key-type.h>
 #include <keys/user-type.h>
+#include <crypto/pkcs7.h>
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PKCS#7 testing key type");
@@ -51,16 +52,57 @@ static int pkcs7_view_content(void *ctx, const void *data, size_t len,
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
+	ret = verify_pkcs7_message_sig(NULL, 0, pkcs7,
+				       VERIFY_USE_SECONDARY_KEYRING, usage,
+				       NULL, NULL);
+	if (ret) {
+		pr_err("verify_pkcs7_message_sig failed!!\n");
+		goto out;
+	}
+	/* now we should find the OID */
+	ret = pkcs7_get_authattr(pkcs7, OID_messageDigest, &data, &len);
+	if (ret) {
+		pr_err("Failed to get message digest\n");
+		goto out;
+	}
+	pr_info("Correctly Got message hash, size=%zu\n", len);
+
+ out:
+	pkcs7_free_message(pkcs7);
+	return 0;
 }
 
 /*
-- 
2.51.0

