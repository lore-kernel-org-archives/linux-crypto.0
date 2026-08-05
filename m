Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E30844C65A
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 11:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785931105; cv=none; b=QVnbeYRVZ1YuDatgn0caTcM9yrNQAW5yWK2nY6Ghld8ukGIGWNqrzUN7hdYeyVyx+yfg0NkWgxftsXEKbBVx0L/uGEq+7Zi/0qL9/fFYbCgDdrrz5iA5LPWE4jt4QxGnFsibLAPCN4sR++gB/TFlUlARYyCsZb4osKKStBJ2Msw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785931105; c=relaxed/simple;
	bh=TXi1E78cjlAEwfYKo16gnIGsjCugY7q4hnj/efQOZ4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcVJLLlmwZOmTT3FkTDhV6N7QSpl/DE3YWq2yQJ9rF9d5pH2sLZHflHbAxoVIwg6oL2ZT7Rryc7ot0Nw9NOT09mUvmd4+AtnTJ/8LrWnoH+JJGteY2yZEdwNHunVLSDo8mjnnXgLO/rG2ofjW+Z+OpKczV7ewrZjMP53lismCoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BfKj6iHM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BfKj6iHM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785931102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D6NyyqK7KlyD8z4FwO/BXzdfa/BL5mjoIdYzF1ekpFM=;
	b=BfKj6iHMrrFwLN8/TAJHU83EPq6Buq7ijnFtoWAf9x2vhSMYfw4K+Kihqkuyzp5ijARpep
	QysYAwl8S33hBtbdNPrTmNG4bY72Aa6BbePIjzTbRNzPtxa9vMxKsJH4uFHM0SF0mkj1Fz
	uGBusnCMIYBjSXiiUTTeZQTPPZJkdog=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-GeXVgMZBM0-LiOv6q7OUsA-1; Wed,
 05 Aug 2026 07:58:17 -0400
X-MC-Unique: GeXVgMZBM0-LiOv6q7OUsA-1
X-Mimecast-MFC-AGG-ID: GeXVgMZBM0-LiOv6q7OUsA_1785931095
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C09051955F21;
	Wed,  5 Aug 2026 11:58:15 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.202])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CE72D30002E9;
	Wed,  5 Aug 2026 11:58:12 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 07/10] crypto: arm64/aes-neonbs - clear the crypto_aes_ctx when done
Date: Wed,  5 Aug 2026 13:57:45 +0200
Message-ID: <20260805115749.392672-8-thuth@redhat.com>
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

