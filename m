Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF60368D5F
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 09:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750299; cv=none; b=QgT7YOqA14NkkiCRiLALsOhvor7+jwA4XwWKmLf1HrE9jq+cVG7vEPTbwaRedNWRiZEWLEVl9rqMZmEGnl67KdcOeRNt0V9K3347bSBExAiDh+kQ10xvk25SBFTNxsqlvOEK1Az9yD7qTM5YMATniO47CEdJLUZ1x3WjzmMrN68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750299; c=relaxed/simple;
	bh=tZ9DFU3CImOxJ23hySRfTaj9nKHCdZcc7HQT89o1FyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiJ8a7B29OAB990N1FgfTeKzZcELUjzrRwVtuXOyAFCCD966fRf1l3XyVUgY6EdwiPyzKHr64bJCKU5CIvvTTODFnRsUdovuQigm2ec2mJY0w3YFX1pO8lKdcZf+pNtCT5+UQn2mcHkEJ/VRIOMmUj3XJ7qX5F6WPKazmQQel78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TRNyNYE+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TRNyNYE+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785750296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kq1yNBsy1kHNFFiJapNMSiZHiMzaL2oUNaY6DUDtqzs=;
	b=TRNyNYE+OIeLgSUF1eiWkyJJrZtRzyHoshH6DKIRsY0PkvRlbrLUyhaXaLHLuUDf/WjZL4
	iTICuOzR/E3OEWcjlyk/aVUlH2aEsvZPzImjH4bGU/n0wi7oOiebtq16s7ZLcmaDAHfGjJ
	/kDcCPX7i3HwiLF2AOh7fcioc7xum94=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-Pz97ijfvNm26Z97FiCNjWQ-1; Mon,
 03 Aug 2026 05:44:43 -0400
X-MC-Unique: Pz97ijfvNm26Z97FiCNjWQ-1
X-Mimecast-MFC-AGG-ID: Pz97ijfvNm26Z97FiCNjWQ_1785750282
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64BC1180034A;
	Mon,  3 Aug 2026 09:44:42 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.213])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C76C31956087;
	Mon,  3 Aug 2026 09:44:39 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 1/9] crypto: Provide a wrapper for zeroizing crypto_aes_ctx
Date: Mon,  3 Aug 2026 11:44:20 +0200
Message-ID: <20260803094432.70505-2-thuth@redhat.com>
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

Several crypto drivers need to zeroize their local crypto_aes_ctx
structures after use to avoid leaking key material on the stack.
Currently some call sites do this with their own memzero_explicit()
call, which is error-prone since it is easy to miss a return path
(what already happened in some drivers). Some other call sites miss
to clear crypto_aes_ctx completely.

Provide an aes_clear_ctx() helper that can be used with __cleanup()
to automatically zeroize the context when it goes out of scope.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/aes.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 3279cfa546085..5ca7b1ab50e8c 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -159,6 +159,19 @@ static inline int aes_check_keylen(size_t keylen)
 int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		  unsigned int key_len);
 
+/**
+ * aes_clear_ctx - Zeroize a crypto_aes_ctx structure
+ * @ctx:	The location of the context that should be zeroized
+ *
+ * Explicitly fills the crypto_aes_ctx with zeroes. This should be done
+ * once the context is not required anymore to avoid that its contents
+ * are leaked on the stack or heap.
+ */
+static inline void aes_clear_ctx(struct crypto_aes_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /*
  * The following functions are temporarily exported for use by the AES mode
  * implementations in arch/$(SRCARCH)/crypto/.  These exports will go away when
-- 
2.55.0

