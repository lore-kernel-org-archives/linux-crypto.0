Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F66054854C
	for <linux-crypto@vger.kernel.org>; Wed,  9 Sep 2026 11:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954931; cv=none; b=RiFxM4e65JMBkIpQyPamMyZtQqBO0FJLHwUSlXoe2wSpLFuiXGlJgzb97hoGX8A9dU0TLmBruZL+SDkNZh3yoC8BO+3qN4lrv2tcOqDia95rLU4duw0SPsc+feAhIX8Qe2Ypegplzh7KnO8ASvhrPkk+ZVPoVCXWIGuudFmQNt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954931; c=relaxed/simple;
	bh=d+vwqEhO/lD2ctFXZn1C2/2N9oPMH8AXcVR0UYYn2jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzFLrbxSrQ5dKkt6klXg2rk/HYCZMwA0tSkfJx4EsStp6sBd+pOfMlGBVXaiBdYmUB4CbwAUBWtvZPk6SM2Tq1QiR8JydrFvO9+ZQgKAxXiVhmqfXP0r3BLiWIHw1waLna7Vybvdc+IDRwm8tuw/7sKk9PLsyn+yL16p+f+v8P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZjLMjZm9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZjLMjZm9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788954929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+JeEBAQDGBfdd7h6R58FOX2X8OCTMKwsL/hKMH91GAo=;
	b=ZjLMjZm9CgK/4GlKQ81nLQK0i6x1WWIu7Uda6ipl9yrsQxTi+MMeAzBw/EssCmIqF06rky
	+v3ZxkI/u8zSBvbUH5ml2kVVrFqXHUxjNjvr9/kx0MamYhJd//iyhUKL5KgEp+NvNei89S
	6+9WN9Z3rzGmsCnKIvDfnee5dUIjf+M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-464-LBdoFZuMO7WDwqjtKQnZ-Q-1; Wed,
 09 Sep 2026 07:55:26 -0400
X-MC-Unique: LBdoFZuMO7WDwqjtKQnZ-Q-1
X-Mimecast-MFC-AGG-ID: LBdoFZuMO7WDwqjtKQnZ-Q_1788954924
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9686218052DA;
	Wed,  9 Sep 2026 11:55:23 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 14E441956088;
	Wed,  9 Sep 2026 11:55:19 +0000 (UTC)
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
Subject: [PATCH v2 05/13] lib/crypto: md5: Provide a function for zeroizing hmac_md5 structures
Date: Wed,  9 Sep 2026 13:54:41 +0200
Message-ID: <20260909115455.157093-6-thuth@redhat.com>
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

In certain cases crypto code functions need to zeroize their local
hmac_md5_key or hmac_md5_ctx structures after use to avoid leaking
sensitive material on the stack.
Provide hmac_md5_zeroize_key() and hmac_md5_zeroize_ctx() helper
functions that e.g. can be used with __cleanup() to automatically
zeroize the structure when it goes out of scope.

While we're at it, replace the related memzero_explicit() call in
lib/crypto/md5.c with a call to the new helper function.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/md5.h | 19 +++++++++++++++++++
 lib/crypto/md5.c     |  2 +-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/crypto/md5.h b/include/crypto/md5.h
index c47aedfe67ecd..1ed89c15b662c 100644
--- a/include/crypto/md5.h
+++ b/include/crypto/md5.h
@@ -4,6 +4,7 @@
 
 #include <crypto/hash.h>
 #include <linux/types.h>
+#include <linux/string.h>
 
 #define MD5_DIGEST_SIZE		16
 #define MD5_HMAC_BLOCK_SIZE	64
@@ -98,6 +99,15 @@ struct hmac_md5_key {
 	struct md5_block_state ostate;
 };
 
+/**
+ * hmac_md5_zeroize_key() - Zeroize an hmac_md5_key structure
+ * @key: The hmac_md5_key to zeroize
+ */
+static inline void hmac_md5_zeroize_key(struct hmac_md5_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct hmac_md5_ctx - Context for computing HMAC-MD5 of a message
  * @hash_ctx: private
@@ -108,6 +118,15 @@ struct hmac_md5_ctx {
 	struct md5_block_state ostate;
 };
 
+/**
+ * hmac_md5_zeroize_ctx() - Zeroize an hmac_md5_ctx structure
+ * @ctx: The hmac_md5_ctx context to zeroize
+ */
+static inline void hmac_md5_zeroize_ctx(struct hmac_md5_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_md5_preparekey() - Prepare a key for HMAC-MD5
  * @key: (output) the key structure to initialize
diff --git a/lib/crypto/md5.c b/lib/crypto/md5.c
index 3d2b017a0525a..a8ee57600012d 100644
--- a/lib/crypto/md5.c
+++ b/lib/crypto/md5.c
@@ -271,7 +271,7 @@ void hmac_md5_final(struct hmac_md5_ctx *ctx, u8 out[MD5_DIGEST_SIZE])
 	cpu_to_le32_array(ctx->ostate.h, ARRAY_SIZE(ctx->ostate.h));
 	memcpy(out, ctx->ostate.h, MD5_DIGEST_SIZE);
 
-	memzero_explicit(ctx, sizeof(*ctx));
+	hmac_md5_zeroize_ctx(ctx);
 }
 EXPORT_SYMBOL_GPL(hmac_md5_final);
 
-- 
2.55.0

