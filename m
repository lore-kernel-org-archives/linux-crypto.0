Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE2331C57B
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 11:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764934313; cv=none; b=iXeaoOI1Yqzyqgizl5tJ44pdtwHeteRMSo7KF9xJiAP7jYztQ3tmAgHgDiFU8XEbQ7RWlxUX+/v8Jbcb8uABK+X+b0ZFMBCoA7swpJleACkhBJ++DAIojZ3ssL9hY5DNwGyw4kch+PjpJYWTmt1J69oI3Pweko4LdfhcbCCyU1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764934313; c=relaxed/simple;
	bh=SZtJGFF8P2hFOr3YJFW6U79eM6LhNi8nW08d2n1GOlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k2rlgiI9imgj6HomEArGqPkcn4NNKlWoK6TAG+LtbcXodpsGaF5QX3EjsHBhdi77vZbCvXyF7Bq7kZVJyWLfRB6tbqzsd7Shs2GGjdcUJ35gOY4hhj/HrHhJnykDosn7VRhq74IdGC404GWQzSCkGafAqIYT1inFRnf78oXx5do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R1XUhG8a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R1XUhG8a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764934308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oG/VqOSGdc08oA76xA7Nvg0WSnERV4bv7fXit1XbI2I=;
	b=R1XUhG8aFQVGlm5c3/roiDmFsfgyUuVOvsDFsvuUPDiep8at/lzuz06Dh4Bduqj3Rnxulu
	0iHDIfePId4zuGFv09DWAIMT2vtSuGeTY13L7kVQO4mNTk/H05Uka4RsGj9uE85QZ+C6r8
	Emekqyfagt3bsfjc7QVwIePjWju46Ts=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-457-kj2ofKYZPh6H-eSRtVN0ZA-1; Fri,
 05 Dec 2025 06:31:45 -0500
X-MC-Unique: kj2ofKYZPh6H-eSRtVN0ZA-1
X-Mimecast-MFC-AGG-ID: kj2ofKYZPh6H-eSRtVN0ZA_1764934304
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48840195608F;
	Fri,  5 Dec 2025 11:31:44 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.72.112.26])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C37721800357;
	Fri,  5 Dec 2025 11:31:39 +0000 (UTC)
From: Li Tian <litian@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC] crypto/hkdf: Skip tests with keys too short in FIPS mode
Date: Fri,  5 Dec 2025 19:31:36 +0800
Message-ID: <20251205113136.17920-1-litian@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

FIPS mode mandates the keys to _setkey should be longer than 14 bytes.
It's up to the callers to not use keys too short.

Signed-off-by: Li Tian <litian@redhat.com>
---
 crypto/hkdf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/hkdf.c b/crypto/hkdf.c
index 82d1b32ca6ce..73d318f3f677 100644
--- a/crypto/hkdf.c
+++ b/crypto/hkdf.c
@@ -10,6 +10,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/sha2.h>
 #include <crypto/hkdf.h>
+#include <linux/fips.h>
 #include <linux/module.h>
 
 /*
@@ -462,7 +463,12 @@ static const struct hkdf_testvec hkdf_sha512_tv[] = {
 };
 
 static int hkdf_test(const char *shash, const struct hkdf_testvec *tv)
-{	struct crypto_shash *tfm = NULL;
+{
+	/* Skip the tests with keys too short in FIPS mode */
+	if (fips_enabled && (tv->salt_size < 112 / 8))
+		return 0;
+
+	struct crypto_shash *tfm = NULL;
 	u8 *prk = NULL, *okm = NULL;
 	unsigned int prk_size;
 	const char *driver;
-- 
2.50.0

