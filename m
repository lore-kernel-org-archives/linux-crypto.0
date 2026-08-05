Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1EE38A72A
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940613; cv=none; b=JnBxzgnhJPeVz5puuiR575jLAGhJolE6Ev7QLtZpoZQPv5dvuV780lLdK4WJvrLM3by6PzxOE3kZyUNqup/Pd/JcOF1R6N6BxPyAQ+cdJgcvmbJCj6TbORpS7+bNT0pzwjvtgKQcYBBKWLvYImCUZyTmzHwR0soKRAEHtdTA7/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940613; c=relaxed/simple;
	bh=LmpijrFU5VnQEBfjJ8Gl/AStXuoZjWEwdsCP9ODIWXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCCMxe8hr4lvOIpZQSlBVDr3JszpjxxUhqhnnojh2Jf8Q5yxlKAtmX23iZiIIWxF8LxAg9vTNy0b6UmWpnmgMu2Pudq4FlZ3vR+PrkauyNglvGGjbQvZgCCuYI+fgDCqFt+qB9x0EkOyYK7dpkXk7H9ie7m8it+pOfZ7ErUkdCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Edj0gFjt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Edj0gFjt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785940600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fwwpqQsgkBaEc2CC3i/V5A9RM+6KRyNvVsbwOuZjf0k=;
	b=Edj0gFjtGnGtNc8KI+wubiucb0wIvZO5MZQtaleeFknmfimHLQtxruAz390ftGSN5rBoME
	6VGum1hjnd4wGn5GJvGQyyX9Wpb3IG8ARQQGBmrwSzOlGbbQ11QWBuarimTsIMlHa2xEST
	62g5h+M9XdVBuL7xKe+KQaKYVGN5waM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-WPdFBf9uMPS3kYj9pFV7Pw-1; Wed,
 05 Aug 2026 10:36:36 -0400
X-MC-Unique: WPdFBf9uMPS3kYj9pFV7Pw-1
X-Mimecast-MFC-AGG-ID: WPdFBf9uMPS3kYj9pFV7Pw_1785940595
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 548B31955F15;
	Wed,  5 Aug 2026 14:36:35 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.209])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CE7B01800598;
	Wed,  5 Aug 2026 14:36:32 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] lib/crypto: aes: Use _cleanup() for aes_cmac_key instead of memzero_explicit()
Date: Wed,  5 Aug 2026 16:36:08 +0200
Message-ID: <20260805143611.818559-6-thuth@redhat.com>
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

By using __cleanup(aes_cmac_zeroize_key) for clearing the key data,
we can save one line of code here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/crypto/aes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index ca733f15b2a8f..895f8dffa44ae 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -720,7 +720,7 @@ EXPORT_SYMBOL_NS_GPL(aes_cbcmac_final, "CRYPTO_INTERNAL");
  */
 static void __init aes_cmac_fips_test(void)
 {
-	struct aes_cmac_key key;
+	struct aes_cmac_key key __cleanup(aes_cmac_zeroize_key);
 	u8 mac[AES_BLOCK_SIZE];
 
 	if (aes_cmac_preparekey(&key, fips_test_key, sizeof(fips_test_key)) !=
@@ -729,7 +729,6 @@ static void __init aes_cmac_fips_test(void)
 	aes_cmac(&key, fips_test_data, sizeof(fips_test_data), mac);
 	if (memcmp(fips_test_aes_cmac_value, mac, sizeof(mac)) != 0)
 		panic("aes: CMAC FIPS self-test failed (wrong MAC)\n");
-	memzero_explicit(&key, sizeof(key));
 }
 #else /* CONFIG_CRYPTO_LIB_AES_CBC_MACS */
 static inline void aes_cmac_fips_test(void)
-- 
2.55.0

