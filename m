Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9B347CA86
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629034; cv=none; b=GrBtvk4quNAKrnWOx6TvVMwjeo22EoWMWJbzV37YF8NIoe5T0UYEjYB7FkyFSkEmthJSjdnpz4re760gfzBjhxzTCdu5/4p3rr1UMi3KtHlGoklqHWwIw3NNgrQSCo3zZdGXUscxusz/hOC8tiaIJ7LXS/uYDoM3ykgLH6zvJps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629034; c=relaxed/simple;
	bh=d+L8foNQBrjJ8WnaiI4PwJAfjUHuu28jNyMGmN6okvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5ZF8V1fMnzgYF//IJcMS3hdq+8kLebBNDX6YVVtz5AV863S0apqW2ktG2xPWeKlmAThFOaLOs/dLB62b8wcXq/IqTwUn4x1EWqzngLW0xULc9AXOfEIwfKqZjHrkYqUakTAs8V1pBjYaXzD0dEG4OV8k8ka8q/iLE3/TvZ/Kq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h/zDucy1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h/zDucy1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXpHjZdJlgTVAOWLqnDb9i2gpqAP30mT9+QLCS2hQXo=;
	b=h/zDucy1xEQoanhR8BDl76m1H0Spg0aW9kgp3IhtN3VNqJKGw+pduiQEZKRofTZUQqHoQC
	Db6BMbgNFC8ssnifDR3ubBGbcNuz2n/rWEcJzuBtRinTaQYwc7Z/2AAhvXSUpe1QYNPgsc
	CC6UQwHNNXR+LiunRRcmgsIJReyIQOQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-DeiIw1h5OGGKb5C1Bl5FUA-1; Thu,
 13 Aug 2026 09:50:29 -0400
X-MC-Unique: DeiIw1h5OGGKb5C1Bl5FUA-1
X-Mimecast-MFC-AGG-ID: DeiIw1h5OGGKb5C1Bl5FUA_1786629027
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 97537195608E;
	Thu, 13 Aug 2026 13:50:27 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DD5C61800348;
	Thu, 13 Aug 2026 13:50:24 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] lib/crypto: sha1: Provide a wrapper for zeroizing hmac_sha1_ctx
Date: Thu, 13 Aug 2026 15:49:46 +0200
Message-ID: <20260813134953.979481-9-thuth@redhat.com>
In-Reply-To: <20260813134953.979481-1-thuth@redhat.com>
References: <20260813134953.979481-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

Some kernel code needs to zeroize their local hmac_sha1_ctx structures
after use to avoid leaking sensitive material on the stack.
Provide an hmac_sha1_zeroize_ctx() helper that can be used with __cleanup()
to automatically zeroize the context when it goes out of scope.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/sha1.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/crypto/sha1.h b/include/crypto/sha1.h
index 4d973e016cd69..888dfc62e1c65 100644
--- a/include/crypto/sha1.h
+++ b/include/crypto/sha1.h
@@ -7,6 +7,7 @@
 #define _CRYPTO_SHA1_H
 
 #include <linux/types.h>
+#include <linux/string.h>
 
 #define SHA1_DIGEST_SIZE        20
 #define SHA1_BLOCK_SIZE         64
@@ -106,6 +107,22 @@ struct hmac_sha1_ctx {
 	struct sha1_block_state ostate;
 };
 
+/**
+ * hmac_sha1_zeroize_ctx() - Zeroize an hmac_sha1_ctx structure
+ * @ctx: The location of the context that should be zeroized
+ *
+ * This function explicitly fills the hmac_sha1_ctx with zeroes. For
+ * example, it can be used with __cleanup() for local hmac_sha1_ctx
+ * structures on the stack, so that their content is not leaked via the
+ * stack when the context is left. Note: This is only required when not
+ * using hmac_sha1_final() that already zeroizes the structure at the
+ * end.
+ */
+static inline void hmac_sha1_zeroize_ctx(struct hmac_sha1_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha1_preparekey() - Prepare a key for HMAC-SHA1
  * @key: (output) the key structure to initialize
-- 
2.55.0

