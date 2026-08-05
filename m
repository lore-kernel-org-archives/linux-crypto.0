Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A5A44C66F
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 11:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785931099; cv=none; b=G/sl9nPuI1ZF9ShXqI9qRtfyxqqxZMp3Oa4JDcx7c+rXkMt6hqZttmWgESYapBFp2TchypuDewi7NOoxOfu9k4wOVom030sdZ4Nzb0nYU9ki580TFKIFcNSYeNyB10EeyAYJOATdsyVTahSN9hDW9jExiSx5aOuIssef079lrCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785931099; c=relaxed/simple;
	bh=rrHOeIvGuTbxvBxf0sD+S1Wa6q8TEDfmgAXE4+BZst4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJAx++qMp6//t9OLuwYwKiZjLNjs0FGewqbffz3M3054cUuRMjMd4FyjrPhNLwn9QUlyZbQw4kAHfuqbjkIbuLAUGHB1SWDWoTxHrodMWv1PNOzypSFOPwZweglBf4PwLcIekI9yJYsqa0aRhY+jkDNibJsJJ56g4YiJ4q3pbIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BWDwypgK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BWDwypgK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785931097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFIxmKcUsq1WalhKwXv0wsQgLSJrF7IelNY2pEdEa3U=;
	b=BWDwypgKZqCVsbLXrChhOSej5V3o29aWve47/p0mKHyX3Wy3PRR3LIXUVonIq2Htop5e0q
	BykyrPDuBhTjtQFqJIwtR5Jee3i9nC3nLzfP9WJhn0F5LJ1aCJxU7eAs0r9wHbzc9zafPX
	u9gnygn2kTUE6/T+akq+YZP+0yX26eg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-S3dhsJWwNV-vIPG2bC1I2w-1; Wed,
 05 Aug 2026 07:58:07 -0400
X-MC-Unique: S3dhsJWwNV-vIPG2bC1I2w-1
X-Mimecast-MFC-AGG-ID: S3dhsJWwNV-vIPG2bC1I2w_1785931086
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1163E19560AA;
	Wed,  5 Aug 2026 11:58:06 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.202])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 515F330001A2;
	Wed,  5 Aug 2026 11:58:04 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 04/10] crypto: padlock-aes - clear the crypto_aes_ctx when done
Date: Wed,  5 Aug 2026 13:57:42 +0200
Message-ID: <20260805115749.392672-5-thuth@redhat.com>
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

Clear the crypto_aes_ctx structure via __cleanup(aes_zeroize_ctx)
when we're done with it to avoid that key data could leak on the
stack.

And since __cleanup() (and __free()) should not be mixed with
"gotos" in the same function, turn the goto statement here
into a proper block of the related if-statement.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/padlock-aes.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 1be549a07a219..400a889e924d7 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -109,7 +109,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
 	const __le32 *key = (const __le32 *)in_key;
-	struct crypto_aes_ctx gen_aes;
+	struct crypto_aes_ctx gen_aes __cleanup(aes_zeroize_ctx);
 	int cpu;
 
 	if (key_len % 8)
@@ -137,20 +137,18 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	ctx->cword.decrypt.ksize = ctx->cword.encrypt.ksize;
 
 	/* Don't generate extended keys if the hardware can do it. */
-	if (aes_hw_extkey_available(key_len))
-		goto ok;
+	if (!aes_hw_extkey_available(key_len)) {
+		ctx->D = ctx->d_data;
+		ctx->cword.encrypt.keygen = 1;
+		ctx->cword.decrypt.keygen = 1;
 
-	ctx->D = ctx->d_data;
-	ctx->cword.encrypt.keygen = 1;
-	ctx->cword.decrypt.keygen = 1;
+		if (aes_expandkey(&gen_aes, in_key, key_len))
+			return -EINVAL;
 
-	if (aes_expandkey(&gen_aes, in_key, key_len))
-		return -EINVAL;
-
-	memcpy(ctx->E, gen_aes.key_enc, AES_MAX_KEYLENGTH);
-	memcpy(ctx->D, gen_aes.key_dec, AES_MAX_KEYLENGTH);
+		memcpy(ctx->E, gen_aes.key_enc, AES_MAX_KEYLENGTH);
+		memcpy(ctx->D, gen_aes.key_dec, AES_MAX_KEYLENGTH);
+	}
 
-ok:
 	for_each_online_cpu(cpu)
 		if (&ctx->cword.encrypt == per_cpu(paes_last_cword, cpu) ||
 		    &ctx->cword.decrypt == per_cpu(paes_last_cword, cpu))
-- 
2.55.0

