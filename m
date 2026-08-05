Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B42D44AB72
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 11:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785931107; cv=none; b=UhF4or0lzrHKvt7UP+QlfJHFagFo53z10XOVwXfgIASY47BlaXWnp/meR3qRkqnu7W4E9sO9kF0DqJtj0HaDQp6TuFuwgFCQyqzWdOzptJjb5HWuE+88SdH71547Ed0yh7L1DUsbpVvKVRew0sN/6iacMR5h9SjvVH3iD8muwG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785931107; c=relaxed/simple;
	bh=sgrWOcBFo9Sd2WuA0nVAH1BFjCA3yxoLh5SvhbCkwfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fvyq9+8wXmgC0zENcXrgBjO0dIfKMCAHF4C/La+rqJMA0nV1v/8HbMqusrlNG4oEc+2FQkytJbf+zQEslrxuiHuO29FK28LpiY9Y6eMPWUtV0tdeHj1PyHMCPzU50N7ZTMkzE49dutNpHM6UhJm3VbwAlvgP3SlE+tVsOAvY5+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ekxeuitk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ekxeuitk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785931104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpzU2gD6nS7CuMmMhQxgVG5WsJfE9oTaObIb5LgkYdE=;
	b=EkxeuitkRb0CxBQrn0XXC+Qs2G6L/909TG49uKEzOUViYxTCuiLcenEjWJDaFTCqN6xYWN
	I2bNzf5b6U1JOnNRTUrHfoOoRIwd08UFK89pyaYwwSjBnPwNRTX1PsAsQhlhb086JPMkFq
	coGCb7GCUfQI6x8dZQQ875RG1rmgyjo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-153-qMlZiLTnP1WpjyalZ7PoVQ-1; Wed,
 05 Aug 2026 07:58:20 -0400
X-MC-Unique: qMlZiLTnP1WpjyalZ7PoVQ-1
X-Mimecast-MFC-AGG-ID: qMlZiLTnP1WpjyalZ7PoVQ_1785931098
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80FB218007F0;
	Wed,  5 Aug 2026 11:58:18 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.202])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 52A0F30001A2;
	Wed,  5 Aug 2026 11:58:16 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	qat-linux@intel.com
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 08/10] crypto: qat - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
Date: Wed,  5 Aug 2026 13:57:46 +0200
Message-ID: <20260805115749.392672-9-thuth@redhat.com>
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

A recent patch by Giovanni Cabiddu already added a memzero_explicit()
for the crypto_aes_ctx in the qat_alg_xts_reverse_key() function,
but since we introduced __cleanup(aes_zeroize_ctx) markers in previous
commits in many spots of the code already, let's use it here now, too,
to have the same code pattern everywhere.

Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/intel/qat/qat_common/qat_algs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index 91663805d9e60..cb669fb661625 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -388,7 +388,7 @@ static void qat_alg_skcipher_init_enc(struct qat_alg_skcipher_ctx *ctx,
 static void qat_alg_xts_reverse_key(const u8 *key_forward, unsigned int keylen,
 				    u8 *key_reverse)
 {
-	struct crypto_aes_ctx aes_expanded;
+	struct crypto_aes_ctx aes_expanded __cleanup(aes_zeroize_ctx);
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

