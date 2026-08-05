Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FE138B12D
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940612; cv=none; b=NU3k2j0GgFh+X3XkKTpKLuKwG3hryS5SkVy0lP9UDPrXbXoT0eROxD1F1B+bZ6tI0OqIjdM+ZNR11V3QRaTfJdX+UdYaU3uWD6Fam/GVxVciLKgS3truoeLRlyh9owV6jACnfdk+X5GXM2mp1nKlpWJlpnyIalKVhzdSo9DFPRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940612; c=relaxed/simple;
	bh=c+Obj3KxZAXJqJFX2X9E/Kyv+qj00penHJsYWag3Dkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUBsME4d03c6g0XhnvGVMJc2IBJfhGMfxAuGJL9QRxnc/IUn1lNdSIUGQdhLF5vOHYnQYiZl4yzXhz15dE706kt9bwYccijz2qS3ILzhz064DTgYr5AV791iHbQYC8WUSQZ63rJpVGKAQUOCsAj3vlbRokKBtUpYBdW1fIKEdcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CUfuoyXU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUfuoyXU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785940605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Ce3mbn9VnBLWH5P+vwgYp9VLPRTWUW0aQvMbeGeCrI=;
	b=CUfuoyXUjsE1Tp8EtqqPubQZha+T2UbpTBFC/kaG2ka+AvGS30FawLOZbhnUBJF2hvzv8R
	uo4ukkLCjtYlVZODYVAdz+If58Dv+nt0awAy9Ljklhh43kGw7zKeeg6TEzA1+mgW/RKD2g
	3gw9Vzsu1X+XfCseRHnysBRpWbjcAaA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-U6v6dCt1Mu6Wv-I9a0_Piw-1; Wed,
 05 Aug 2026 10:36:41 -0400
X-MC-Unique: U6v6dCt1Mu6Wv-I9a0_Piw-1
X-Mimecast-MFC-AGG-ID: U6v6dCt1Mu6Wv-I9a0_Piw_1785940599
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6EB21955E7C;
	Wed,  5 Aug 2026 14:36:38 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.209])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 22D4D1800598;
	Wed,  5 Aug 2026 14:36:35 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] mac80211: fils_aead: Use _cleanup for aes_cmac_key instead of memzero_explicit
Date: Wed,  5 Aug 2026 16:36:09 +0200
Message-ID: <20260805143611.818559-7-thuth@redhat.com>
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
 net/mac80211/fils_aead.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
index d2f4a17eab990..293590976489a 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -24,7 +24,7 @@ static int aes_s2v(const u8 *in_key, size_t key_len,
 		   size_t num_elem, const u8 *addr[], size_t len[], u8 *v)
 {
 	u8 d[AES_BLOCK_SIZE], tmp[AES_BLOCK_SIZE] = {};
-	struct aes_cmac_key key;
+	struct aes_cmac_key key __cleanup(aes_cmac_zeroize_key);
 	struct aes_cmac_ctx ctx;
 	size_t i;
 	int res;
@@ -62,7 +62,6 @@ static int aes_s2v(const u8 *in_key, size_t key_len,
 	aes_cmac_update(&ctx, d, AES_BLOCK_SIZE);
 	aes_cmac_final(&ctx, v);
 
-	memzero_explicit(&key, sizeof(key));
 	return 0;
 }
 
-- 
2.55.0

