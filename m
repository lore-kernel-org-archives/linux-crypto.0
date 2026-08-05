Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD0538C2D1
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940604; cv=none; b=Cw+F0RVme6RA2F0NmYoBNTmI7ZFsQUCzj7i0k3LtDBdd7BpyhxMCs6IER2z47X/eIFH6FBIWI0Kbo9t0C25Hvm64bBcj2ahUuetFrHNO8somaEpmi3j/Z9A4KOcfZt08mJFqt2YnoDFPOjSUT2dyDGy5x901op0Rjxs/61zanms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940604; c=relaxed/simple;
	bh=duW19IgJsAZJrRbXwEO0zEH2t8L/hVDfEvkJX44DDOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCphwM2UxJ/n5CseHez6jbOF5/bW0sYAbC2o/nkt70KqvNC3FSJTdKPIxGeq8qN0O8OXtAVFWr1MnS7uXK+DeA8oTgIMVN5cL9yE/rSUzKOF3ow+3BoDRI+VZn7H2nc2eMAttyAwUBDFu6m6T0TaFSxbtmSfw9oEU9wBOwTwN6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ikqA+L3t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ikqA+L3t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785940595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yei7OHfAGHdMIi/iQ/Eh6Hu6W5UwksEC5q06wHwkLjE=;
	b=ikqA+L3t4GYfxRbevm3lwlKfyFvcacytoSDB0IPFNaz8vDkcFIYaF/xsxhycqH6svlz1IQ
	nOxRiMUyge7+QscpkzG6GkRAwGzxLfKBj1j3IRXNWMAzOxoM+pACekj41AX/jOoemHevMY
	JO85tuBzqBKUjHJhZU7OcMdhFJ3qhXc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-7Nyd_fOAPNykH5qV9j9BZg-1; Wed,
 05 Aug 2026 10:36:19 -0400
X-MC-Unique: 7Nyd_fOAPNykH5qV9j9BZg-1
X-Mimecast-MFC-AGG-ID: 7Nyd_fOAPNykH5qV9j9BZg_1785940578
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C78319560A7;
	Wed,  5 Aug 2026 14:36:18 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.209])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 37F031800598;
	Wed,  5 Aug 2026 14:36:15 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] crypto: Provide wrapper functions for zeroizing aes_cmac_key and aes_cmac_ctx
Date: Wed,  5 Aug 2026 16:36:04 +0200
Message-ID: <20260805143611.818559-2-thuth@redhat.com>
In-Reply-To: <20260805143611.818559-1-thuth@redhat.com>
References: <20260805143611.818559-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

Code that uses AES-CMAC might need to zeroize their local aes_cmac_key
and/or aes_cmac_ctx structures after use to avoid leaking sensitive
material on the stack.

Provide an aes_cmac_zeroize_key() and an aes_cmac_zeroize_ctx() helper
function that can be used with __cleanup() to automatically clear
the key and context when they go out of scope.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/aes-cbc-macs.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/crypto/aes-cbc-macs.h b/include/crypto/aes-cbc-macs.h
index e61df108b926d..b2f3b8be7886b 100644
--- a/include/crypto/aes-cbc-macs.h
+++ b/include/crypto/aes-cbc-macs.h
@@ -109,6 +109,32 @@ void aes_cmac_update(struct aes_cmac_ctx *ctx, const u8 *data, size_t data_len);
  */
 void aes_cmac_final(struct aes_cmac_ctx *ctx, u8 out[at_least AES_BLOCK_SIZE]);
 
+/**
+ * aes_cmac_zeroize_key - Clear a aes_cmac_key structure
+ * @ctx: The location of the key structure that should be zeroized
+ *
+ * Explicitly fills the aes_cmac_key with zeroes. This should be done once
+ * the key is not required anymore to avoid that its contents are leaked
+ * on the stack or heap.
+ */
+static inline void aes_cmac_zeroize_key(struct aes_cmac_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
+/**
+ * aes_cmac_zeroize_ctx - Clear a aes_cmac_ctx structure
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
  * aes_cmac() - Compute AES-CMAC or AES-XCBC-MAC in one shot
  * @key: The key to use
-- 
2.55.0

