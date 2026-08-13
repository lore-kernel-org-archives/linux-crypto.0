Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AEC47ACC1
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629096; cv=none; b=YZQIgH9lEVln+r0k+AW7myMp+tz/KLyK3l4L5cChRkIj5TxxB/GNLNn2eeZQRa87dIsujXYBiJo+rrSfG/It8PJcXffUGEPZJFXm5qf2JNoEvoj7Zmd+SEQWrL2xAi00NoPzjQPmhqUqY9flNNhdVEhJDzH8/RBndZE31zEAhOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629096; c=relaxed/simple;
	bh=zTVu/A2ms08L5lU1yEoQM73ayTlZ9/oZk9DjvB1306I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKYch34Uw9GJGAQ8pWgZYQPQJ7L1ZbSAPK60vshPTI2lqFSckr5jNE11Jpp6ZkB7Gn3Pb+w+kHI59bRbPxxRMhH0ADwny0wO+ma+MwzgG0eNGOJKC8wKItY3lzz2BrO++CR9Dj7G+Hqb54Y7kr6+izTIHKRMJzgpdv+UraNbLg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E1EAtl3L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E1EAtl3L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fjC6RQ33hHDSrNn6DlYe2EQPZM5s0/22UcKy9xjB7gs=;
	b=E1EAtl3LoMLgzNzMec+l/rQZTn4vEKwErllZe9Bb8XqL/7i5Yl8sahJ0YxcD/yrHvoOyrq
	d0mUBQtKW15x0F3XZQHEoLgM6tSRxrw7AwkArHIxrPRlgf/EiXtln9BK7X4Hzb+yBZcCD8
	JH3U4gMbMCTVplwxWkrXfml94qzYZ3Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-213-q7eoBlF5N9ai4fDiJ00OMg-1; Thu,
 13 Aug 2026 09:50:23 -0400
X-MC-Unique: q7eoBlF5N9ai4fDiJ00OMg-1
X-Mimecast-MFC-AGG-ID: q7eoBlF5N9ai4fDiJ00OMg_1786629020
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8BFD19560AE;
	Thu, 13 Aug 2026 13:50:20 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 45F981800348;
	Thu, 13 Aug 2026 13:50:18 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] lib/crypto: md5: Provide a function for zeroizing hmac_md5_ctx structures
Date: Thu, 13 Aug 2026 15:49:44 +0200
Message-ID: <20260813134953.979481-7-thuth@redhat.com>
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

Some crypto code functions need to zeroize their local hmac_md5_ctx
structures after use to avoid leaking sensitive material on the stack.
Provide a hmac_md5_zeroize_ctx() helper function that can be used with
__cleanup() to automatically zeroize the context when it goes out of
scope.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/md5.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/crypto/md5.h b/include/crypto/md5.h
index c47aedfe67ecd..8cf26fd965323 100644
--- a/include/crypto/md5.h
+++ b/include/crypto/md5.h
@@ -4,6 +4,7 @@
 
 #include <crypto/hash.h>
 #include <linux/types.h>
+#include <linux/string.h>
 
 #define MD5_DIGEST_SIZE		16
 #define MD5_HMAC_BLOCK_SIZE	64
@@ -108,6 +109,20 @@ struct hmac_md5_ctx {
 	struct md5_block_state ostate;
 };
 
+/**
+ * hmac_md5_zeroize_ctx() - Zeroize an hmac_md5_ctx structure
+ * @ctx: The location of the context that should be zeroized
+ *
+ * This function explicitly fills the hmac_md5_ctx with zeroes. For
+ * example, use it with __cleanup() for local hmac_md5_ctx structures
+ * on the stack, so that their content is not leaked when the context is
+ * left. Note: This is only required when not using hmac_md5_final().
+ */
+static inline void hmac_md5_zeroize_ctx(struct hmac_md5_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_md5_preparekey() - Prepare a key for HMAC-MD5
  * @key: (output) the key structure to initialize
-- 
2.55.0

