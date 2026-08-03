Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF8C371CF4
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 09:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750308; cv=none; b=HQKW5W83BsQV5Bh0qTmZoKtvMAMZoevuRL96u/pO9bKrLH2rm6ReoDAqBrMkxeSd6re64hgfMXFI0KvETpDalWKbpKWgxVf5lueLt80sxEWB7rkQ6vzeBSKwjLe4jSKrKKyiHTbj92BJqNF8k58avSSzA/t/XmRTOKOSP+rfmvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750308; c=relaxed/simple;
	bh=hlFkWPJbwxqmu6n2UBUC9mnTUyBcPL2Dz2V9kgQ8ZAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQLu/HxsKgvco+K8l0AqHoEobKybxm5lJYxfN0b6BxfW1ZEHSLW3oVeLaY1XkoM6+8jzDdnqvdjtlhzqGj5Ow5hrnVv/e+BTxYyaeV5nccU9HUVLXfq8SGY7S16d4O2cNKIKz/YBvS9Eli9xUL4HevhMYbtR5z/hn1Ej61Jw1Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DJ4N3kl7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJ4N3kl7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785750305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rNfaUJSGZkllVVmqoWpRblGjymrMkwDfUYzNGF3wB5o=;
	b=DJ4N3kl7T1oHl/WotRxHkdLP2BEWmVxCqyWFBz3/KG7/OVxYc4jWJm7inDmwZBF1gQ2iO1
	whB6wMC5x28UhewmB8hpaOa0wJvGTdq3ZM9PTNxzpv2yTWVO9M5Vj42/mf543g5FIi60JY
	gF9qGwxc4qbXVIT6AfNkuw8lSMU/c50=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-6nUzNavaMcGu9F092Tibjg-1; Mon,
 03 Aug 2026 05:45:04 -0400
X-MC-Unique: 6nUzNavaMcGu9F092Tibjg-1
X-Mimecast-MFC-AGG-ID: 6nUzNavaMcGu9F092Tibjg_1785750303
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6898A1800350;
	Mon,  3 Aug 2026 09:45:03 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.213])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 89AD01956087;
	Mon,  3 Aug 2026 09:45:00 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 5/9] crypto: sa2ul - clear the crypto_aes_ctx when done
Date: Mon,  3 Aug 2026 11:44:24 +0200
Message-ID: <20260803094432.70505-6-thuth@redhat.com>
In-Reply-To: <20260803094432.70505-1-thuth@redhat.com>
References: <20260803094432.70505-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

Clear the crypto_aes_ctx structure via __cleanup(aes_clear_ctx) when
we're done with it to avoid that key data could leak on the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/sa2ul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index d865fd4a098cb..b921993d86a7b 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -465,7 +465,7 @@ static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
 /* Derive the inverse key used in AES-CBC decryption operation */
 static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz)
 {
-	struct crypto_aes_ctx ctx;
+	struct crypto_aes_ctx ctx __cleanup(aes_clear_ctx);
 	int key_pos;
 
 	if (aes_expandkey(&ctx, key, key_sz)) {
-- 
2.55.0

