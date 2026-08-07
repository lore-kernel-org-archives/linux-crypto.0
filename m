Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183453BCD38
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 13:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786107673; cv=none; b=sYTco73SvIxgVrBqymQzmiytg510drP4hNsNeesxPTr+UVoYdgdotWOeNQX4Ieqf9eWWhQKRg1J/+eRLPIxEJw1ZKN+ullnjDUqA8SbkPQLz5e8lJ3k0Zvv7AY9/uTJG7yjXWlfIuJJdn7FkmSws8pnZtx3zk/2SMUMvq2uBVCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786107673; c=relaxed/simple;
	bh=c+Obj3KxZAXJqJFX2X9E/Kyv+qj00penHJsYWag3Dkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLwAVJDC4WPv1UAQyyRZJgG2IYpTk0Vg1P0NqLmVG5kQQoFkMVsKEkljC/BXttXvndK1Zet4QOEL+vrL+//SdZ77aE6MO8FXjMdyGyTQh3az+P2svYwS6WjGdGPYbaRtZyvkcAKdspQyUQRZ967jIqeso4XKzxl4rvZQ0tUwPvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JvKE+9cS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JvKE+9cS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786107661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Ce3mbn9VnBLWH5P+vwgYp9VLPRTWUW0aQvMbeGeCrI=;
	b=JvKE+9cS6YB/x5WgfdQHDdhW5CqAIII1HRHymQuC70H6dRiq0PwVaIVC+FJCwRTAzFdpwW
	VOix2Da7dPpn5aFVI530jJyWXa0GL+E4351UH3d/vU5dPrf9VlVyqHOFs+YVmpztNNsSNV
	7564PALY+h79FUlyQEc/0N1fmeaWbrk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-WQL0Ke1hPIiluU26xBzukQ-1; Fri,
 07 Aug 2026 08:59:16 -0400
X-MC-Unique: WQL0Ke1hPIiluU26xBzukQ-1
X-Mimecast-MFC-AGG-ID: WQL0Ke1hPIiluU26xBzukQ_1786107555
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE5F81956096;
	Fri,  7 Aug 2026 12:59:14 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F069D30001A2;
	Fri,  7 Aug 2026 12:59:11 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 6/6] mac80211: fils_aead: Use __cleanup() for aes_cmac_key instead of memzero_explicit()
Date: Fri,  7 Aug 2026 14:58:43 +0200
Message-ID: <20260807125845.1477067-7-thuth@redhat.com>
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

