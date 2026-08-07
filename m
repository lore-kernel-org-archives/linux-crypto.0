Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C8344238C
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 12:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786107547; cv=none; b=DT3MuuhixrFTGlH6XiLfh7rlf0eharMbPrNkxdGenShLV/y+6RGwEELbuhqTf7k9XRH+WzD6EAn6vJtZDxULUCvVG9yXR7Z9fSfVnjQPig+0PZGEzYtJU2qCD/oBIP5J/n0eXax8wMN+oFPweAMX0TBAuqGeRg004HVY+ihSzKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786107547; c=relaxed/simple;
	bh=GOicAiiPdCosnYt+UyxDcvfW0DeSZyz5yYTdbWqyCUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFWu150+QFpTObvvPDLubNCtqY6CJQMdT66CDytu2aD+Jwj4HBrvulRSB9ab101oHbN7dagKJXmxCWDttox6gLzvN1QqVOVFzqb8GnU3YsQXaK1UQqQBVAbLjasrIgjSZfS6ameZ8FVoVZzUVI/bPUsFJpUGl/0GI2dwF0DhoQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IKp+Rc4j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IKp+Rc4j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786107537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SAuxcU+LljEfsSN8otHgMJR5aOh9hA9sihtkJB/tiGQ=;
	b=IKp+Rc4jLJhkOUnzQxs7ptLzM7p6eeTNLt4kpqmQw8XqxytDFeGI+NVdVuCT4egfYkF6GB
	JcxksxyuBJdpPBSJbPYZZvDGKsryTqVuzaUD/MJAFOMHxtoH6uDc4gZHUhmdPsE8TQSeh4
	FwDCMArFEvPkLP4Ht3fycENuyVhMYHQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-Y9pqZvjBOSyoo-bdcoWNiw-1; Fri,
 07 Aug 2026 08:58:54 -0400
X-MC-Unique: Y9pqZvjBOSyoo-bdcoWNiw-1
X-Mimecast-MFC-AGG-ID: Y9pqZvjBOSyoo-bdcoWNiw_1786107533
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3C50195609D;
	Fri,  7 Aug 2026 12:58:52 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8CF2C30001A2;
	Fri,  7 Aug 2026 12:58:50 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 1/6] crypto: Provide wrapper functions for zeroizing aes_cmac_key and aes_cmac_ctx
Date: Fri,  7 Aug 2026 14:58:38 +0200
Message-ID: <20260807125845.1477067-2-thuth@redhat.com>
In-Reply-To: <20260807125845.1477067-1-thuth@redhat.com>
References: <20260807125845.1477067-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

Code that uses AES-CMAC might need to zeroize their local aes_cmac_key
and/or aes_cmac_ctx structures after use to avoid leaking sensitive
material on the stack.

Provide an aes_cmac_zeroize_key() and an aes_cmac_zeroize_ctx() helper
function that can be used with __cleanup() to automatically clear
the key and context when they go out of scope.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/aes-cbc-macs.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/crypto/aes-cbc-macs.h b/include/crypto/aes-cbc-macs.h
index e61df108b926d..06e8a22f8a0ac 100644
--- a/include/crypto/aes-cbc-macs.h
+++ b/include/crypto/aes-cbc-macs.h
@@ -8,6 +8,7 @@
 #define _CRYPTO_AES_CBC_MACS_H
 
 #include <crypto/aes.h>
+#include <linux/string.h>
 
 /**
  * struct aes_cmac_key - Prepared key for AES-CMAC or AES-XCBC-MAC
@@ -24,6 +25,19 @@ struct aes_cmac_key {
 	} k_final[2];
 };
 
+/**
+ * aes_cmac_zeroize_key() - Zeroize an aes_cmac_key structure
+ * @key: The location of the key structure that should be zeroized
+ *
+ * Explicitly fills the aes_cmac_key with zeroes. This should be done once
+ * the key is not required anymore to avoid that its contents are leaked
+ * on the stack or heap (if not using kfree_sensitive()).
+ */
+static inline void aes_cmac_zeroize_key(struct aes_cmac_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct aes_cmac_ctx - Context for computing an AES-CMAC or AES-XCBC-MAC value
  * @key: Pointer to the key struct.  A pointer is used rather than a copy of the
@@ -40,6 +54,19 @@ struct aes_cmac_ctx {
 	u8 h[AES_BLOCK_SIZE];
 };
 
+/**
+ * aes_cmac_zeroize_ctx() - Zeroize an aes_cmac_ctx structure
+ * @ctx: The location of the context that should be zeroized
+ *
+ * Explicitly fills the aes_cmac_ctx with zeroes. This should be done once
+ * the context is not required anymore to avoid that its contents are
+ * leaked on the stack or heap. Only required if not using aes_cmac_final().
+ */
+static inline void aes_cmac_zeroize_ctx(struct aes_cmac_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * aes_cmac_preparekey() - Prepare a key for AES-CMAC
  * @key: (output) The key struct to initialize
@@ -47,6 +74,10 @@ struct aes_cmac_ctx {
  * @key_len: Length of the raw key in bytes.  The supported values are
  *	     AES_KEYSIZE_128, AES_KEYSIZE_192, and AES_KEYSIZE_256.
  *
+ * On success, the caller should ensure that the prepared key is zeroized
+ * at the end of its lifetime, e.g. by calling aes_cmac_zeroize_key() or
+ * kfree_sensitive().
+ *
  * Context: Any context.
  * Return: 0 on success or -EINVAL if the given key length is invalid.  No other
  *	   errors are possible, so callers that always pass a valid key length
@@ -79,6 +110,9 @@ void aes_xcbcmac_preparekey(struct aes_cmac_key *key,
  *
  * This supports both AES-CMAC and AES-XCBC-MAC.  Which one is done depends on
  * whether aes_cmac_preparekey() or aes_xcbcmac_preparekey() was called.
+ *
+ * The caller should ensure that the context is zeroized at the end of its
+ * lifetime, e.g. by calling aes_cmac_final() or aes_cmac_zeroize_ctx().
  */
 static inline void aes_cmac_init(struct aes_cmac_ctx *ctx,
 				 const struct aes_cmac_key *key)
-- 
2.55.0

