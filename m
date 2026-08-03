Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C431F37C916
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 09:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750330; cv=none; b=Cbeaszbccq5Er/DINxfUUpqxOIORQh7mVzKR8bVd0EI9P6ZMGbs6yihnul9dtulNGXCgzjCwzGTdPzf9oZ330HbuejAuqd6+xrWhZ+i2j1gIe4X5fABSnmQ9FfDzO2nJLCZYjxs4149tVDRPiIKx9ApyYo+SoNuZuuE74anU2fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750330; c=relaxed/simple;
	bh=0LDHq7QdkqDReNPHALZn7cIcfQsp6FI/EqyFL/S+3O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsEZjhaD3I8ppgZqAiw2JsrWWe7sRCQ0FZ59AHSjr+X68Qoiz4R8FmZaLYM5f5pId3DDDAcuM/zq2NhoANdAaMzOMtd34vYQr330mC6cWrXTDm+8BfvTTipxh84/aUzsR2XJ7UyRZPWGV13X3583OXCbIkfpjBWMpXdpnmP2P6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PpOVzrHp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PpOVzrHp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785750327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dYwdk10fZS/RlXj0yQtqtdCG4riS9n+O4AarGWgwDs0=;
	b=PpOVzrHpvzC9Jg60te9HZUguHxTnpGPGak0XgzqDMxcmr4e/7gmDCWVlknwAlNJunhHv30
	Rb9bLJfiGdWpgEPvHa6w3xmsk4LShx+Tu/Zl8Lk0YLALxxTPV8GwaVUiYVwQvD26NC1Ckz
	NTZNV3f4cSkt5sBdGr8QeMmRsGl82VE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-213-KTRdosnKOcmRdBGh9i5rJA-1; Mon,
 03 Aug 2026 05:45:24 -0400
X-MC-Unique: KTRdosnKOcmRdBGh9i5rJA-1
X-Mimecast-MFC-AGG-ID: KTRdosnKOcmRdBGh9i5rJA_1785750323
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E45819560BC;
	Mon,  3 Aug 2026 09:45:23 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.213])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 016C01956087;
	Mon,  3 Aug 2026 09:45:18 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	qat-linux@intel.com
Cc: Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 9/9] crypto: qat - zeroize crypto_aes_ctx with __cleanup(aes_clear_ctx)
Date: Mon,  3 Aug 2026 11:44:28 +0200
Message-ID: <20260803094432.70505-10-thuth@redhat.com>
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

A recent patch by Giovanni Cabiddu already added a memzero_explicit()
for the crypto_aes_ctx in the qat_alg_xts_reverse_key() function,
but since we introduced __cleanup(aes_clear_ctx) markers in previous
commits in many spots of the code already, let's use it here now, too,
to have the same code pattern everywhere.

Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/intel/qat/qat_common/qat_algs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index 91663805d9e60..9a56fcdedd579 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -388,7 +388,7 @@ static void qat_alg_skcipher_init_enc(struct qat_alg_skcipher_ctx *ctx,
 static void qat_alg_xts_reverse_key(const u8 *key_forward, unsigned int keylen,
 				    u8 *key_reverse)
 {
-	struct crypto_aes_ctx aes_expanded;
+	struct crypto_aes_ctx aes_expanded __cleanup(aes_clear_ctx);
 	int nrounds;
 	u8 *key;
 
@@ -405,7 +405,6 @@ static void qat_alg_xts_reverse_key(const u8 *key_forward, unsigned int keylen,
 		memcpy(key_reverse + AES_BLOCK_SIZE, key - AES_BLOCK_SIZE,
 		       AES_BLOCK_SIZE);
 	}
-	memzero_explicit(&aes_expanded, sizeof(aes_expanded));
 }
 
 static void qat_alg_skcipher_init_dec(struct qat_alg_skcipher_ctx *ctx,
-- 
2.55.0

