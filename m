Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607FF44C4F7
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 11:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785931107; cv=none; b=Uxj8aNaq0tFHZb/V13LffPVzPLPGsVLyBO+pQc7addzdlDxwjFzJQa5P1RvzDmx6X+bEjCt+fwrJF2hJeQoL7g4aJBlV6dSNOBY3bOxh9PGXyj4oWBjTHKtKzL6Rur7grrgMZDG2d1cjTpl1CBHMu1vtZt8TPam+sBkTuyTDuM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785931107; c=relaxed/simple;
	bh=H51eEndb83vlMBdSKdQPCJs4a0NhTn4ra/iT1GUYwIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxbPxFZBIYIhiGQ9qqtiAKuaCp7L3EJblcxL7RfBT0FZC/3vJVoribejWK6UlOTmVkqnKhm7N4bkPDXJ3JEZTEBe19aPETXM85rAIhx/az5cXNw3ov2TdmPrTB/rG5VAkV16Sj5d7MxlbgQmlkwQBsCPpwyTwwR4kHllHwuTlDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FILxDIEt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FILxDIEt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785931104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgOea8COfMWPGkNwdk17UcXroZGUrewDpcR0b9Y5VNk=;
	b=FILxDIEt6munoPcBxYqNA0mPzrUvpL2il+s9bziYAHhDgnQM4xV9mgvfivsHgDHkHfAUio
	+5Y1Q36Zf8206wo2mWq0qx7MCh45Wh0BgSP422i9F0RwkipQ5vpJnpfWnEd82yUorAfCE3
	nuJ5czLTMUxBkl7duTBQyR+qZSKovOI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-2v7u31WwMPGBaCLd03fz4g-1; Wed,
 05 Aug 2026 07:58:09 -0400
X-MC-Unique: 2v7u31WwMPGBaCLd03fz4g-1
X-Mimecast-MFC-AGG-ID: 2v7u31WwMPGBaCLd03fz4g_1785931088
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1F951956096;
	Wed,  5 Aug 2026 11:58:08 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.202])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 06BBB30001A2;
	Wed,  5 Aug 2026 11:58:06 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 05/10] crypto: sa2ul - clear the crypto_aes_ctx when done
Date: Wed,  5 Aug 2026 13:57:43 +0200
Message-ID: <20260805115749.392672-6-thuth@redhat.com>
In-Reply-To: <20260805115749.392672-1-thuth@redhat.com>
References: <20260805115749.392672-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

Clear the crypto_aes_ctx structure via __cleanup(aes_zeroize_ctx) when
we're done with it to avoid that key data could leak on the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/sa2ul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index d865fd4a098cb..f1a7c2cc7a1af 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -465,7 +465,7 @@ static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
 /* Derive the inverse key used in AES-CBC decryption operation */
 static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz)
 {
-	struct crypto_aes_ctx ctx;
+	struct crypto_aes_ctx ctx __cleanup(aes_zeroize_ctx);
 	int key_pos;
 
 	if (aes_expandkey(&ctx, key, key_sz)) {
-- 
2.55.0

