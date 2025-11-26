Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED9A302CA2
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764164558; cv=none; b=ftUaD172AvE5HfDXHlSjrDNlFctl/6FnelpqsoTKiGf8RxJUNTJhQfCpSYumenqIRETPoHHC4qw9Hd5YrzRYoFti9Up5FlBflqIbuASd5qMFIvLBm6hzsFVFUSh1FuvqANk+10IHjXgv7Y93SBByyS+u+kQk9RYhR92IlyTc+Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764164558; c=relaxed/simple;
	bh=kL6gTk/zn8eSmSBFKolJt9AS/LSAf5Q6VzXUgZOK2gs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VxhY1HUQ3YF+4Fwgm+NYBL9Gm8EKGo7w+sF80WnsgSxiuQwgI6wdcc78yP4/qOxBgGeMnwy3hXxraL+rRqBdjU3lB21UdrJkxu95bjWAnCV+8YQc8KMtQh70p7v4OHmkYvhNdxbjUjJSZsLOhS3l4Z780GDhdlZusadlegU9QIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jw2AXfnR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jw2AXfnR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764164556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pd8sCI+vzVwFpcNtUsv5ZNMe1abMa4r5lZFUnyCkmR8=;
	b=Jw2AXfnRnBc/2Mb7DSBQ9zN5H5Nv4ztOEp5VyB7iO+W9AK4XX7Q10UReN31gFQV7b3QOkF
	Lx3I3oWi0lFvZpVodVcbySKHDs5KWYdNppTR0JY9v0/LHpksyeLlRSjhid/HIoNBgw+mf/
	3ODq82/8bHNM4jUHAsvKyFJmG+Q1LfE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-314-V97xpvFRPZChs6ur8MJe_Q-1; Wed,
 26 Nov 2025 08:42:31 -0500
X-MC-Unique: V97xpvFRPZChs6ur8MJe_Q-1
X-Mimecast-MFC-AGG-ID: V97xpvFRPZChs6ur8MJe_Q_1764164550
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EABDF19560B2;
	Wed, 26 Nov 2025 13:42:29 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.72.112.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 33A6D3001E83;
	Wed, 26 Nov 2025 13:42:24 +0000 (UTC)
From: Li Tian <litian@redhat.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH RFC] crypto/hkdf: Fix salt length short issue in FIPS mode
Date: Wed, 26 Nov 2025 21:42:22 +0800
Message-ID: <20251126134222.22083-1-litian@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Under FIPS mode, the hkdf test fails because salt is required
to be at least 32 bytes long. Pad salt with 0's.

Signed-off-by: Li Tian <litian@redhat.com>
---
 crypto/hkdf.c         | 11 ++++++++++-
 fs/crypto/hkdf.c      | 13 -------------
 include/crypto/hkdf.h | 13 +++++++++++++
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/crypto/hkdf.c b/crypto/hkdf.c
index 82d1b32ca6ce..9af0ef4dfb35 100644
--- a/crypto/hkdf.c
+++ b/crypto/hkdf.c
@@ -46,6 +46,15 @@ int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
 		 u8 *prk)
 {
 	int err;
+	u8 tmp_salt[HKDF_HASHLEN];
+
+	if (saltlen < HKDF_HASHLEN) {
+		/* Copy salt and pad with zeros to HashLen */
+		memcpy(tmp_salt, salt, saltlen);
+		memset(tmp_salt + saltlen, 0, HKDF_HASHLEN - saltlen);
+		salt = tmp_salt;
+		saltlen = HKDF_HASHLEN;
+	}
 
 	err = crypto_shash_setkey(hmac_tfm, salt, saltlen);
 	if (!err)
@@ -151,7 +160,7 @@ struct hkdf_testvec {
  */
 static const struct hkdf_testvec hkdf_sha256_tv[] = {
 	{
-		.test = "basic hdkf test",
+		.test = "basic hkdf test",
 		.ikm  = "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			"\x0b\x0b\x0b\x0b\x0b\x0b",
 		.ikm_size = 22,
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index 706f56d0076e..5e4844c1d3d7 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -13,19 +13,6 @@
 
 #include "fscrypt_private.h"
 
-/*
- * HKDF supports any unkeyed cryptographic hash algorithm, but fscrypt uses
- * SHA-512 because it is well-established, secure, and reasonably efficient.
- *
- * HKDF-SHA256 was also considered, as its 256-bit security strength would be
- * sufficient here.  A 512-bit security strength is "nice to have", though.
- * Also, on 64-bit CPUs, SHA-512 is usually just as fast as SHA-256.  In the
- * common case of deriving an AES-256-XTS key (512 bits), that can result in
- * HKDF-SHA512 being much faster than HKDF-SHA256, as the longer digest size of
- * SHA-512 causes HKDF-Expand to only need to do one iteration rather than two.
- */
-#define HKDF_HASHLEN		SHA512_DIGEST_SIZE
-
 /*
  * HKDF consists of two steps:
  *
diff --git a/include/crypto/hkdf.h b/include/crypto/hkdf.h
index 6a9678f508f5..7ef55ce875e2 100644
--- a/include/crypto/hkdf.h
+++ b/include/crypto/hkdf.h
@@ -11,6 +11,19 @@
 
 #include <crypto/hash.h>
 
+/*
+ * HKDF supports any unkeyed cryptographic hash algorithm, but fscrypt uses
+ * SHA-512 because it is well-established, secure, and reasonably efficient.
+ *
+ * HKDF-SHA256 was also considered, as its 256-bit security strength would be
+ * sufficient here.  A 512-bit security strength is "nice to have", though.
+ * Also, on 64-bit CPUs, SHA-512 is usually just as fast as SHA-256.  In the
+ * common case of deriving an AES-256-XTS key (512 bits), that can result in
+ * HKDF-SHA512 being much faster than HKDF-SHA256, as the longer digest size of
+ * SHA-512 causes HKDF-Expand to only need to do one iteration rather than two.
+ */
+#define HKDF_HASHLEN            SHA512_DIGEST_SIZE
+
 int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
 		 unsigned int ikmlen, const u8 *salt, unsigned int saltlen,
 		 u8 *prk);
-- 
2.50.0

