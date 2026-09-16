Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9984D4BA1F5
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 09:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552266; cv=none; b=FJUDwa30+n7tNBkkohpzAkvAgbjjh1cviQvCBPQxy75fkjp+v8ajFtIImpxUOuyyr7qSfd+JjvprQJShfzjVjvLbsV4LfEILuZt7rv5IfDDFlTqxVEHLBLXCLxKBxjgTFJKxYEnJHTA4C1Ugi0/de0vGekBYq7UWShYMkaeQ/34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552266; c=relaxed/simple;
	bh=d+vwqEhO/lD2ctFXZn1C2/2N9oPMH8AXcVR0UYYn2jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpE7RYFtice5bkkkD9oVE0wNm/X2bWbVzeIYzH2A4BvgVz5jKDldvGEczdh82UhMzWfhOOzPW9qemwaNSSvkjfWtu7NyvfINFDI2MWBNc+ODmzQJ4pPCha6lMZMuqLONUEUH1FGZd+rXPmC94PYzDxBQFUsOGOQVeKgUmlw8i4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iZGOpLF4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZGOpLF4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789552259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+JeEBAQDGBfdd7h6R58FOX2X8OCTMKwsL/hKMH91GAo=;
	b=iZGOpLF4Ae85KRVhjCBVh8JkqT4kNJgwEpjyUH1xK/m0jIPRDI5yeuvENTmqZwmpLg1C3U
	f5CCyRfPONBEOfL9GGxyQCHsLazK1/FDXzoQC4VjrFi6UoXEJX6WQAI8OkJVhTLIk3ht6e
	a5xwEKlRvSQi2E286P3BBMLITPxo7AA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-P9g4S4TpMWiT1wAOC-yfvg-1; Wed,
 16 Sep 2026 05:50:56 -0400
X-MC-Unique: P9g4S4TpMWiT1wAOC-yfvg-1
X-Mimecast-MFC-AGG-ID: P9g4S4TpMWiT1wAOC-yfvg_1789552254
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBA5B1829E0D;
	Wed, 16 Sep 2026 09:50:51 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 12E831800446;
	Wed, 16 Sep 2026 09:50:47 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v4 05/13] lib/crypto: md5: Provide a function for zeroizing hmac_md5 structures
Date: Wed, 16 Sep 2026 11:50:07 +0200
Message-ID: <20260916095022.604354-6-thuth@redhat.com>
In-Reply-To: <20260916095022.604354-1-thuth@redhat.com>
References: <20260916095022.604354-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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

