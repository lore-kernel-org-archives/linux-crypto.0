Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AD412B94
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 07:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086458; cv=none; b=ulBs8hrFGXVsZt0YVXtk57T5hw7qmIFC1Xj4q4V3L2LdCVYCej24ZnMOuwDXcyT4yyEQu97DlYy068xBcSYIrK27ai41nWmVWiNA5odph4SOTX8agaZCtiIsFF0YbCQs/OtRZKLcNzA9ADkGxRkU0XKrfIMV9H/gm9ZRyAc1osA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086458; c=relaxed/simple;
	bh=TXi1E78cjlAEwfYKo16gnIGsjCugY7q4hnj/efQOZ4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpOA0+bxZebimqr6VeuZiasAtzSXEh/OLL60Nv64S847cQChARLfvUpwyWciM5KYdWztsXkLIaCbv/O1iMmNJ3hp45P8Q8BjvygPTvkzl3DwICZv0BFmIpOtzMDyaIE5jmuhR20cu6H3TMxLtTWoR0HgVUE3jxvxhBaXEw429wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+8ZoBxD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+8ZoBxD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786086456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D6NyyqK7KlyD8z4FwO/BXzdfa/BL5mjoIdYzF1ekpFM=;
	b=S+8ZoBxD7JD+9iirg3FB4q4IGS/gTKig3dHGOwCRsqjIrJzDFsLdnNQlqKYjcIZxgWnvF3
	Sdedj8GGxzpM9kWmzpJxtikdWskAMM+rOw5CXxzsTMpNkCz5b4CMbc+o/bfLhCC5hFaaO+
	JeD9IIKg1przGyvuHzbDJ6iRf6zBWFE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-280-XVYdn7r6OtmkJxuEHP0pwg-1; Fri,
 07 Aug 2026 03:07:30 -0400
X-MC-Unique: XVYdn7r6OtmkJxuEHP0pwg-1
X-Mimecast-MFC-AGG-ID: XVYdn7r6OtmkJxuEHP0pwg_1786086449
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EF26195605E;
	Fri,  7 Aug 2026 07:07:29 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 545201956094;
	Fri,  7 Aug 2026 07:07:25 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 07/10] crypto: arm64/aes-neonbs - clear the crypto_aes_ctx when done
Date: Fri,  7 Aug 2026 09:06:34 +0200
Message-ID: <20260807070651.228713-8-thuth@redhat.com>
In-Reply-To: <20260807070651.228713-1-thuth@redhat.com>
References: <20260807070651.228713-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

Clear the crypto_aes_ctx structure via __cleanup(aes_zeroize_ctx) when
we're done with it to avoid that key data could leak on the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/arm64/crypto/aes-neonbs-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 5bcbac9798931..c2f3eac0ca661 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -247,7 +247,7 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
 	struct aesbs_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_aes_ctx rk;
+	struct crypto_aes_ctx rk __cleanup(aes_zeroize_ctx);
 	int err;
 
 	err = xts_verify_key(tfm, in_key, key_len);
-- 
2.55.0

