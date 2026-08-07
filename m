Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80FB38C42B
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 07:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086454; cv=none; b=jmLXscugX2tzIzybFdnGtSc4Kl1YtpIecPJca8aUz+rsmdFyhdix4yTROrgVNaeLjFSrc1uS6iCo4Z640z9JXgAUrNHnuFyM1UdZ2+sV6nfxd5PzfO83G2GIpU5tpg7S14DGrA1M5ZVmuFpoiuEJ5f+1+ZewlZ8cLEIKZHpJgPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086454; c=relaxed/simple;
	bh=rrHOeIvGuTbxvBxf0sD+S1Wa6q8TEDfmgAXE4+BZst4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efxDZB+QUaXoTt0xlsU8uZag91k1+rIciGsVJ4J/9lMLWup6IV/wLPenunJWBRgi92y/uzYSGhDnjD+C5xazRPPMwjAJAiYf/xtoX/8whGimXdXkMakZqLRk2kMcc/7Oc+PYsez+Lb3scUgJdPjFvXc3iNRenrC/kyOfKsMQdOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A6Wzcgm1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A6Wzcgm1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786086451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFIxmKcUsq1WalhKwXv0wsQgLSJrF7IelNY2pEdEa3U=;
	b=A6Wzcgm1B0S1u9mFaMdTBt25cmZfb+GgKEo2K3SCOfwA5YTiq287Cc0UiWiuX6ArJikEOU
	xRE6RiamYmzEICxjwCMa82JDHpK90CejsuJBRAg8NfKv5EDbKQzfBVVDFkGT+hnaQPGE2B
	NMN7MQeC0KWLjYavCKVXn0gIrfatxz4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-vF4XTtHUOtq9Lc1s9CYOUA-1; Fri,
 07 Aug 2026 03:07:17 -0400
X-MC-Unique: vF4XTtHUOtq9Lc1s9CYOUA-1
X-Mimecast-MFC-AGG-ID: vF4XTtHUOtq9Lc1s9CYOUA_1786086436
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F151B1800867;
	Fri,  7 Aug 2026 07:07:15 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 09B221956094;
	Fri,  7 Aug 2026 07:07:13 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/10] crypto: padlock-aes - clear the crypto_aes_ctx when done
Date: Fri,  7 Aug 2026 09:06:31 +0200
Message-ID: <20260807070651.228713-5-thuth@redhat.com>
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

