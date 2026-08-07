Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C32245005
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 07:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086428; cv=none; b=B04rq9fpQnYJVufmCxOLeG+gIAm4eCjPU2kZoAIilekrQXoxdLGQzO9pLW57bBdIcHKQq0I/mTpr0zqW04lQkTb1r2MB3BEzTfbUkRX9nCGqluFWp1ye8Y9MTmz1M+GRaAydvXftVldP7xNtclqTgisdb3YfBgDghI5Jqw1i6ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086428; c=relaxed/simple;
	bh=JaYULTHp2SPezfRmr9jErjWyHRHYwFH/4MCkUw7PxrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2KQ4c+76Fwc8ajKo9DkS/PiSCK2FoIOqYliXxxL2ayXcFM8bpsyl/Jf22xTBdG6UzoeFBtEC40JBneSGp9fFlMkNiJ4pVjcd03fDlCLGtk8B72oRHaGX6Ptgwx2EEabvowJIbT50l8KXxWdxPyrTmVGsd69N/SgBIvu4kD1luw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O4WWaXQH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O4WWaXQH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786086426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fCdPX+LzHi81vXbH7hGFraeUcnuAFIfrwEq1PaejTQA=;
	b=O4WWaXQHY+H+WbcDEuArmGpxd89uGjb+H7fXqq0O0tnVXgtsSCEBlUSDgiNkxZnT76QlA9
	gsfe6heyDLXLxIHKl6H3vwSD9850r1ve3pr7EY3UvAUDu/OhSTTcbJrF65RcDMRNJuH8kg
	G9W1htxUQu9tVphFbvsmSW/IoIKEKq8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-D_aGlKvqPWaXU44QL1n1iw-1; Fri,
 07 Aug 2026 03:07:00 -0400
X-MC-Unique: D_aGlKvqPWaXU44QL1n1iw-1
X-Mimecast-MFC-AGG-ID: D_aGlKvqPWaXU44QL1n1iw_1786086419
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 151A21956078;
	Fri,  7 Aug 2026 07:06:59 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E3A17195DF92;
	Fri,  7 Aug 2026 07:06:56 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/10] crypto: Provide a wrapper function for zeroizing crypto_aes_ctx
Date: Fri,  7 Aug 2026 09:06:28 +0200
Message-ID: <20260807070651.228713-2-thuth@redhat.com>
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

Several crypto drivers need to zeroize their local crypto_aes_ctx
structures after use to avoid leaking key material on the stack.
Currently some call sites do this with their own memzero_explicit()
call, which is error-prone since it is easy to miss a return path
(what already happened in some drivers). Some other call sites miss
to clear crypto_aes_ctx completely.

Provide an aes_zeroize_ctx() helper that can be used with __cleanup()
to automatically zeroize the context when it goes out of scope.

Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/aes.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 3279cfa546085..eb970b8d623f9 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -159,6 +159,19 @@ static inline int aes_check_keylen(size_t keylen)
 int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		  unsigned int key_len);
 
+/**
+ * aes_zeroize_ctx - Clear a crypto_aes_ctx structure
+ * @ctx:	The location of the context that should be zeroized
+ *
+ * Explicitly fills the crypto_aes_ctx with zeroes. This should be done
+ * once the context is not required anymore to avoid that its contents
+ * are leaked on the stack or heap (if not using kfree_sensitive()).
+ */
+static inline void aes_zeroize_ctx(struct crypto_aes_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /*
  * The following functions are temporarily exported for use by the AES mode
  * implementations in arch/$(SRCARCH)/crypto/.  These exports will go away when
-- 
2.55.0

