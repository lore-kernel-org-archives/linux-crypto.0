Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE9047FB19
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629023; cv=none; b=Eao1qNghTyYSvkEa58xmCy1IK6fpu1FfMkpEp352eip/yd9EMggefM8izkQQnnHKxkjJVFlee/SOXTwjGGRpoUQBi9ABiTbhQ8LjdrLszrc5hg8ba6Z0zvnMu2EfdxoAfYJFq+ORGGXxEmlV34aBvszKvTlZsE/jO8CA/+N2SdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629023; c=relaxed/simple;
	bh=VnTATtlriT9hJ+g1OI5ge5YmyAW+/25F62oqLI5lA8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiNVRg59Dip1a1gqBwAjVd+9AOTBL9NqotGvifxc0k0diB3psxjMxaoP4lmnVFJBVf765YoHzuDwld+7WcLc1QtO15QFhbdmaM5vUC+Gz251qCJBvDzAYZzdToMIlu7QhgHgBCnKpBK73BQr00+4tUq+MUQJh1Wdi/Me/R5GSmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PyVktTa0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PyVktTa0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/IFcVC78qv0vNde4zIlgnYNgCLsv1G2LAGNIFkaroL4=;
	b=PyVktTa06jYdQ45s9B84HSC6+o7Xod3cAb/P3HFLws6HzFvBQOnCbFO67+SgBTKXtLgGr7
	CfOf+i2yXF99B46Xsc5of3NggfE6YFl+uURyEmL6E+5kyK2gO5fFmScTeUFlCaQIakJkdp
	SLSsNswv0Jku6cwZYtFExXHcXKUtXzY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-ciUfV5ZyPg2tBbJuNUBH9g-1; Thu,
 13 Aug 2026 09:50:19 -0400
X-MC-Unique: ciUfV5ZyPg2tBbJuNUBH9g-1
X-Mimecast-MFC-AGG-ID: ciUfV5ZyPg2tBbJuNUBH9g_1786629017
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C02E19560AD;
	Thu, 13 Aug 2026 13:50:17 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ABFFC1800577;
	Thu, 13 Aug 2026 13:50:14 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: x86@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] lib/crypto: aes: Use aes_zeroize_*key() instead of memzero_explicit()
Date: Thu, 13 Aug 2026 15:49:43 +0200
Message-ID: <20260813134953.979481-6-thuth@redhat.com>
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

It's only cosmetics here, but since we have the new aes_zeroize_key()
and aes_zeroize_enckey() functions anyway, we can also use them here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/crypto/aes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index f1549839b3de0..07c1d912ac365 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -539,7 +539,7 @@ static void __init aes_fips_test(void)
 	if (memcmp(fips_test_data, data, sizeof(data)) != 0)
 		panic("aes: FIPS self-test failed (wrong plaintext)\n");
 
-	memzero_explicit(&key, sizeof(key));
+	aes_zeroize_key(&key);
 }
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CBC_MACS)
@@ -827,7 +827,7 @@ static void __init aes_ecb_fips_test(void)
 	if (memcmp(fips_test_data, data, sizeof(data)) != 0)
 		panic("aes: ECB FIPS self-test failed (wrong plaintext)\n");
 
-	memzero_explicit(&key, sizeof(key));
+	aes_zeroize_key(&key);
 }
 #else /* CONFIG_CRYPTO_LIB_AES_ECB */
 static inline void aes_ecb_fips_test(void)
@@ -1040,7 +1040,7 @@ static void __init aes_cbc_fips_test(void)
 	if (memcmp(fips_test_data, data, sizeof(data)) != 0)
 		panic("aes: CBC FIPS self-test failed (wrong plaintext)\n");
 
-	memzero_explicit(&key, sizeof(key));
+	aes_zeroize_key(&key);
 }
 
 /* FIPS cryptographic algorithm self-test for AES-CBC-CTS */
@@ -1069,7 +1069,7 @@ static void __init aes_cbc_cts_fips_test(void)
 	if (memcmp(ptext, data, data_len) != 0)
 		panic("aes: CBC-CTS FIPS self-test failed (wrong plaintext)\n");
 
-	memzero_explicit(&key, sizeof(key));
+	aes_zeroize_key(&key);
 }
 #else /* CONFIG_CRYPTO_LIB_AES_CBC */
 static inline void aes_cbc_fips_test(void)
@@ -1194,7 +1194,7 @@ static void __init aes_ctr_fips_test(void)
 	if (memcmp(fips_test_data, data, sizeof(data)) != 0)
 		panic("aes: CTR FIPS self-test failed (wrong plaintext)\n");
 
-	memzero_explicit(&key, sizeof(key));
+	aes_zeroize_enckey(&key);
 }
 #else /* CONFIG_CRYPTO_LIB_AES_CTR */
 static inline void aes_ctr_fips_test(void)
-- 
2.55.0

