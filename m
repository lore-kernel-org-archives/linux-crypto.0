Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D37536B903
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 09:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750301; cv=none; b=dZH/Eycqo46zKWNwfuqJgblDvbn5RYRu/s3hH68FYBHDCePOfNn+4kLpNdAvFAxsU6hvoqIfuNgyyoNKtpXV8MCHjdhC6WdgJi8vR8eWToNn/3AY6wu25xZ+10fQKnNIl1Ga8qJJLnkjiN+9tbpCz779uyWFiHbsw7G65ozlckU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750301; c=relaxed/simple;
	bh=Ly3gsOBB0d0dZwCOQG/BAo9MKOMd4r6cuiwq5qrqiOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hh3WTyAjHYvOwATPxhdYuzmIFSFfUkobxrSc9xmvmw/aAAWtXHNsQHq29OSOGxW2JVe9daWOBpsuJSn4xB3KBipMjLJtNKBJcPWS84krxUMPs1Eexv0CIca2yZ+jJOX9tmPSbtb84OWzrYuQ9izA9nT9cgfM+bIMeL059F8w3S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dt3gY7XW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dt3gY7XW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785750298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1BITfAIER9fk3/uef/hKbnVdlnd+g+3AUzVw4gdmtNA=;
	b=Dt3gY7XWAy4lY/k50HuB2pIrl3WmA38DaQSyZe2MRFQW6xosSHwoljamBu+xPLK4Jnhxmw
	AIwphj2WHVFkH+EZpAll6cToQfWgp37RqwC6BqXIF7el2JBT7hHu4nx+LalnL9+35hbPRT
	XvHKq/QjB8PyOGO7WxrV50W17bx6NYo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-Xa3eL1rVMOmdTOmAHmgX1w-1; Mon,
 03 Aug 2026 05:44:56 -0400
X-MC-Unique: Xa3eL1rVMOmdTOmAHmgX1w-1
X-Mimecast-MFC-AGG-ID: Xa3eL1rVMOmdTOmAHmgX1w_1785750295
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75057180029F;
	Mon,  3 Aug 2026 09:44:55 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.213])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 170D2195608E;
	Mon,  3 Aug 2026 09:44:50 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>
Cc: Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 3/9] crypto: inside-secure/eip93 - clear the crypto_aes_ctx when done
Date: Mon,  3 Aug 2026 11:44:22 +0200
Message-ID: <20260803094432.70505-4-thuth@redhat.com>
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

Clear the crypto_aes_ctx structure via __cleanup(aes_clear_ctx)
when we're done with it to avoid that key data could leak on the
stack.

Cc: Christian Marangi <ansuelsmth@gmail.com>
Cc: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/inside-secure/eip93/eip93-aead.c   | 2 +-
 drivers/crypto/inside-secure/eip93/eip93-cipher.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-aead.c b/drivers/crypto/inside-secure/eip93/eip93-aead.c
index 2bbd0af7b0e0e..8bbbf8c0b8c98 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-aead.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-aead.c
@@ -92,7 +92,7 @@ static int eip93_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_authenc_keys keys;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_clear_ctx);
 	struct sa_record *sa_record = ctx->sa_record;
 	u32 nonce = 0;
 	int ret;
diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.c b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
index 4dd7ab7503e85..3f9a15aa93541 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
@@ -116,7 +116,7 @@ static int eip93_skcipher_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 	}
 
 	if (flags & EIP93_ALG_AES) {
-		struct crypto_aes_ctx aes;
+		struct crypto_aes_ctx aes __cleanup(aes_clear_ctx);
 
 		ctx->blksize = AES_BLOCK_SIZE;
 		ret = aes_expandkey(&aes, key, keylen);
-- 
2.55.0

