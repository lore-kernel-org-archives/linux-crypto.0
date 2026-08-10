Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5467F238159
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 09:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354231; cv=none; b=mktTwjt5hgGbkceimPTx0qUe+wMCf9J63S7D3PE0xQCknjLjW53dfXIaawml9mB098MkYhwIEl4kW2Xn0KHsu3LlCnHmhue4tq9QQjKeJ6LVBtT8BX22rQKZHp8i06vu1MTFMNF0EXex4bA2n8HxXzcvm27PSRVFDC7DtFxtQBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354231; c=relaxed/simple;
	bh=WVt0qQ4+1eH0aK8H3LOcQUCnNbq+Qzdzr1yi2CdD+9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utcqqZxu1MYR/etpWg6SxZm+qwkrVOQxl1X1pqnRvIhazIpFMbWyvEZZtCAy1l5bNgV8V7k2ps3jOqqbjsi39o/7bauH8DHeORMxQ7yYv0UsWNXgXGUw9pRIjXZyRHnDuUfdqnYL5fEsRsalbxxWEXbqCsgQ2jYyrJajPXar7Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SKFmN0YT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SKFmN0YT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786354229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rFuj09l13bDJWP8ROOQNO6DWGBJe5ddETVvR3frCMgU=;
	b=SKFmN0YTaRd5VGmEQZuE0cwXpU5edHv7TxjFbStXOdqpLwtPF8CtzKIMM4GruMEM27e3US
	Gh/eugcL6XHtTFgxDePHs8u1tdKXODS2+X5ToahCPU5vDWL4+KSUJbLh3bEEoZcqjlFLP7
	zrcDEdOGd3D3t1sWtwQWbEwgGQdEJJ4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-136-U7rsMKF7Nkq7P_7Ivsxu4g-1; Mon,
 10 Aug 2026 05:30:25 -0400
X-MC-Unique: U7rsMKF7Nkq7P_7Ivsxu4g-1
X-Mimecast-MFC-AGG-ID: U7rsMKF7Nkq7P_7Ivsxu4g_1786354224
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 324011800846;
	Mon, 10 Aug 2026 09:30:23 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0BF853001D38;
	Mon, 10 Aug 2026 09:30:17 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Neal Liu <neal_liu@aspeedtech.com>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>,
	linux-aspeed@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 02/10] crypto: aspeed - clear the crypto_aes_ctx when done
Date: Mon, 10 Aug 2026 11:29:57 +0200
Message-ID: <20260810093009.608090-3-thuth@redhat.com>
In-Reply-To: <20260810093009.608090-1-thuth@redhat.com>
References: <20260810093009.608090-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

Declare the gen_aes_key with __cleanup(aes_zeroize_ctx) to avoid that
its contents could be leaking via the stack when the function returns.
And since it is only required in one branch of the if-statement there,
move it to that block, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/aspeed/aspeed-hace-crypto.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-crypto.c b/drivers/crypto/aspeed/aspeed-hace-crypto.c
index fa201dae1f81b..e7d3f611df05c 100644
--- a/drivers/crypto/aspeed/aspeed-hace-crypto.c
+++ b/drivers/crypto/aspeed/aspeed-hace-crypto.c
@@ -576,7 +576,6 @@ static int aspeed_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 {
 	struct aspeed_cipher_ctx *ctx = crypto_skcipher_ctx(cipher);
 	struct aspeed_hace_dev *hace_dev = ctx->hace_dev;
-	struct crypto_aes_ctx gen_aes_key;
 
 	CIPHER_DBG(hace_dev, "keylen: %d bits\n", (keylen * 8));
 
@@ -585,9 +584,9 @@ static int aspeed_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 		return -EINVAL;
 
 	if (ctx->hace_dev->version == AST2500_VERSION) {
+		struct crypto_aes_ctx gen_aes_key __cleanup(aes_zeroize_ctx);
 		aes_expandkey(&gen_aes_key, key, keylen);
 		memcpy(ctx->key, gen_aes_key.key_enc, AES_MAX_KEYLENGTH);
-
 	} else {
 		memcpy(ctx->key, key, keylen);
 	}
-- 
2.55.0

