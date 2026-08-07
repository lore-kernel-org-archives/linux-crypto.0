Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FB84746D7
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 12:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786107576; cv=none; b=khHRDOCNjtmhYXmTKxvNBOURym94YkugA7jwieNwb9ZeK6rR3xxkLg+r5ly4Wtgj1KkASFORxPBIyY5uXi9fx8rWFCE7lO+cOva/wkYglRYBc67u+Gf1X1lpCOzu7U5vy0OS23A6zl8GFDNtcU0SnaCdsiyk/QeqbvNNuygmIDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786107576; c=relaxed/simple;
	bh=qPEZRKhEi06HCbNvqfEU6K4V3GJdTOqXA3pBAX/Oy84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSDTybUhIoTSRZhdrZvCpzdNigSNQOO1ZR0XIivTETSpzs4wk+acZGf5A2hCub7sHkiXQ2PsTC8F6YmsXcza5yLTainnZec+08BRkjw2PQQECLfCOc3tQuj4UDl16ntLTPR/3IcH3ZEhJ5tAU+BgPbbuKMmTXUsNgQWCcXI1bk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QIp/cAjX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QIp/cAjX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786107554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KZ8+O2dzwSXOTlm2+htw33WMtif8W7imIy+AZH7HO/Q=;
	b=QIp/cAjXinnuaWLRxqTiklvKz0lrpbVYD9d2AgMJnRVja8eHLtUyk0HTPsWfWfCdkXKAHw
	OSwqetkfF4m4eq+A6OVAHYTxsNFBD280EwDf8P2JH2frr2PPuB+EZpy7zC54KIBkhhYZoU
	d21LsRspp97Kle4q2iVyI+N/SWgb63M=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-52-0YgWB7iWPD6zLHbetqDpSQ-1; Fri,
 07 Aug 2026 08:59:12 -0400
X-MC-Unique: 0YgWB7iWPD6zLHbetqDpSQ-1
X-Mimecast-MFC-AGG-ID: 0YgWB7iWPD6zLHbetqDpSQ_1786107551
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41FA0195608B;
	Fri,  7 Aug 2026 12:59:11 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 68A5630001A2;
	Fri,  7 Aug 2026 12:59:08 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 5/6] lib/crypto: aes: Use __cleanup() for aes_cmac_key instead of memzero_explicit()
Date: Fri,  7 Aug 2026 14:58:42 +0200
Message-ID: <20260807125845.1477067-6-thuth@redhat.com>
In-Reply-To: <20260807125845.1477067-1-thuth@redhat.com>
References: <20260807125845.1477067-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

By using __cleanup(aes_cmac_zeroize_key) for clearing the key data,
we can save one line of code here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/crypto/aes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 41aaa82cb1a1c..f1549839b3de0 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -740,7 +740,7 @@ EXPORT_SYMBOL_NS_GPL(aes_cbcmac_final, "CRYPTO_INTERNAL");
 /* FIPS cryptographic algorithm self-test for AES-CMAC */
 static void __init aes_cmac_fips_test(void)
 {
-	struct aes_cmac_key key;
+	struct aes_cmac_key key __cleanup(aes_cmac_zeroize_key);
 	u8 mac[AES_BLOCK_SIZE];
 
 	if (aes_cmac_preparekey(&key, fips_test_key, sizeof(fips_test_key)) !=
@@ -749,7 +749,6 @@ static void __init aes_cmac_fips_test(void)
 	aes_cmac(&key, fips_test_data, sizeof(fips_test_data), mac);
 	if (memcmp(fips_test_aes_cmac_value, mac, sizeof(mac)) != 0)
 		panic("aes: CMAC FIPS self-test failed (wrong MAC)\n");
-	memzero_explicit(&key, sizeof(key));
 }
 #else /* CONFIG_CRYPTO_LIB_AES_CBC_MACS */
 static inline void aes_cmac_fips_test(void)
-- 
2.55.0

