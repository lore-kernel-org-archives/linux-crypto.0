Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8F554B1D3
	for <linux-crypto@vger.kernel.org>; Wed,  9 Sep 2026 11:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954944; cv=none; b=dVAaRpHAcAGLhOZZDe4Sv5KOyNC+1ep6j+b+MZfy2hBr2nlG4561WQZ2uby0Dasyr6F2FWP2e0BN6OlFG3KEolA3y1hwunJvpDEUv2DUNQQPXoI2mtO9TFChrTvlhxWLKOhk1uzthTfU/BypclCwiV3mm6SncqbSusRVQuH26/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954944; c=relaxed/simple;
	bh=SMz1n2qZSUfU+2cgkcz49kZ4uQA0DD7hBcMOHyDLDOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plWkp7h1tStBVOyolsq73c0umB90Ue12Y1YolJ8HhXL6Bm8EYjoknDKGth563h60lnYX2TvN+xAR8ClrmxllT0gUax6UVS2pBP6KagT+Eo6YoDV9G21Eafkamrsrgq9lavYO50P49Y07l3CEjJrM5TFXJ/ncWHbRL8ax2PgVahA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Iw7Eq6q8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Iw7Eq6q8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788954942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YFi1wI0axV9T/N/bsBEiFja16TRKzsIA5VOlO65mHUM=;
	b=Iw7Eq6q8AxkNLt7MyT5Nh2JOBj/bme7XDrrFAvkCnjKlW0/ELqOFkbMSfuzp8TeWkMJoB9
	hxUF3YjzJCqAcDfDDyfSZfewYSSZErDpLzL2/aLjJIJx4Qa0nZQOa2qcIrhVqOLaeeXCPP
	c1FzCoCEDrPOKs/sTqxmQav/gLNqXM8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-1UeizDOZM1ilgStpsowz2Q-1; Wed,
 09 Sep 2026 07:55:38 -0400
X-MC-Unique: 1UeizDOZM1ilgStpsowz2Q-1
X-Mimecast-MFC-AGG-ID: 1UeizDOZM1ilgStpsowz2Q_1788954937
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2D271955BD9;
	Wed,  9 Sep 2026 11:55:36 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D2A61956088;
	Wed,  9 Sep 2026 11:55:33 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v2 08/13] lib/crypto: sha1: Provide functions for zeroizing hmac_sha1 structures
Date: Wed,  9 Sep 2026 13:54:44 +0200
Message-ID: <20260909115455.157093-9-thuth@redhat.com>
In-Reply-To: <20260909115455.157093-1-thuth@redhat.com>
References: <20260909115455.157093-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In certain cases crypto code needs to zeroize their local hmac_sha1_key
or hmac_sha1_ctx structures after use to avoid leaking sensitive material.
Provide hmac_sha1_zeroize_key() and hmac_sha1_zeroize_ctx() helper
functions that e.g. can be used with __cleanup() to automatically zeroize
the structures when they go out of scope.

While we're at it, replace the related memzero_explicit() call in
lib/crypto/sha1.c with a call to the new helper function.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/sha1.h | 19 +++++++++++++++++++
 lib/crypto/sha1.c     |  2 +-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/crypto/sha1.h b/include/crypto/sha1.h
index 4d973e016cd69..bc0046bffeaee 100644
--- a/include/crypto/sha1.h
+++ b/include/crypto/sha1.h
@@ -7,6 +7,7 @@
 #define _CRYPTO_SHA1_H
 
 #include <linux/types.h>
+#include <linux/string.h>
 
 #define SHA1_DIGEST_SIZE        20
 #define SHA1_BLOCK_SIZE         64
@@ -96,6 +97,15 @@ struct hmac_sha1_key {
 	struct sha1_block_state ostate;
 };
 
+/**
+ * hmac_sha1_zeroize_key() - Zeroize an hmac_sha1_key structure
+ * @key: The hmac_sha1_key to zeroize
+ */
+static inline void hmac_sha1_zeroize_key(struct hmac_sha1_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct hmac_sha1_ctx - Context for computing HMAC-SHA1 of a message
  * @sha_ctx: private
@@ -106,6 +116,15 @@ struct hmac_sha1_ctx {
 	struct sha1_block_state ostate;
 };
 
+/**
+ * hmac_sha1_zeroize_ctx() - Zeroize an hmac_sha1_ctx structure
+ * @ctx: The hmac_sha1_ctx context to zeroize
+ */
+static inline void hmac_sha1_zeroize_ctx(struct hmac_sha1_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha1_preparekey() - Prepare a key for HMAC-SHA1
  * @key: (output) the key structure to initialize
diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
index b687b89d97cb4..c4361ef77166e 100644
--- a/lib/crypto/sha1.c
+++ b/lib/crypto/sha1.c
@@ -275,7 +275,7 @@ void hmac_sha1_final(struct hmac_sha1_ctx *ctx, u8 out[SHA1_DIGEST_SIZE])
 	for (size_t i = 0; i < SHA1_DIGEST_SIZE; i += 4)
 		put_unaligned_be32(ctx->ostate.h[i / 4], out + i);
 
-	memzero_explicit(ctx, sizeof(*ctx));
+	hmac_sha1_zeroize_ctx(ctx);
 }
 EXPORT_SYMBOL_GPL(hmac_sha1_final);
 
-- 
2.55.0

