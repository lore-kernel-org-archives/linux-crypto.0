Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A633E4BAA17
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 09:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552289; cv=none; b=X84y06pG+nOCMLXpEPKXyArNSAVfVygqAFl51K8yhdfFTh5p+8yAPUK2r73U2nwYpnzYKvxgAwznpBCiuEFo9cc7WxNC/A96Gn83cXbqdXtr8ZXXMsVneomuUMtXyEMb4g7wDA1oetPsjRMeKpOnSypuDegiK1x62aA/Oo1mieI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552289; c=relaxed/simple;
	bh=jlhtz27GSry8dABqGr+SGBe1KYYN8UQBI18T52Q8X+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bdx0GpmgMg1mqDn4rd1AWgEBsI1MT8Kj2PUJxxwy3NDTeIOa8uAeGndNNMof1Hs0U+CdF5DxAZW0cySA+YtO0M+Sw8EYrD1XF+mF+NC7jrobX52i9ra46Cl0p2RJBv02+np1xgQSwLFJEvXWaFKCNFblfOdgDsIILuNyKpgfQew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RD/hvKRQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RD/hvKRQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789552264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T46zRcaSlVLde9uhnONtqfo/sj56j7rPD8ZbLDPStgs=;
	b=RD/hvKRQjV+g+mSUAT0tRZdEilEivMmzFKBSFn0YDejyybZRhh4YzRJRUQZZNEQlZswZL+
	Glq5WyMt6D0eq5dsE7Pxl8sWcCaWtQRIzkBAHQlGWBPZBIrpawG29ulnR1Uh64GXjs5r/p
	LwgNqV1alpb5vD6xs47CfhdEPAotCW0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-pIgKSMrqMYiixOzPDfL5Rg-1; Wed,
 16 Sep 2026 05:51:00 -0400
X-MC-Unique: pIgKSMrqMYiixOzPDfL5Rg-1
X-Mimecast-MFC-AGG-ID: pIgKSMrqMYiixOzPDfL5Rg_1789552259
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56E32191FE1D;
	Wed, 16 Sep 2026 09:50:56 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E30DC1800345;
	Wed, 16 Sep 2026 09:50:52 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v4 06/13] lib/crypto: sm3: Provide a function for zeroizing the sm3_ctx structure
Date: Wed, 16 Sep 2026 11:50:08 +0200
Message-ID: <20260916095022.604354-7-thuth@redhat.com>
In-Reply-To: <20260916095022.604354-1-thuth@redhat.com>
References: <20260916095022.604354-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

In certain cases crypto code functions need to zeroize their local
sm3_ctx structure after use to avoid leaking sensitive material. Provide
a sm3_zeroize_ctx() helper function that e.g. can be used with __cleanup()
to automatically zeroize the structure when it goes out of scope.

While we're at it, replace the related memzero_explicit() call in
lib/crypto/sm3.c with a call to the new helper function.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/sm3.h | 10 ++++++++++
 lib/crypto/sm3.c     |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/crypto/sm3.h b/include/crypto/sm3.h
index 371e8a6617054..d044ca80213ba 100644
--- a/include/crypto/sm3.h
+++ b/include/crypto/sm3.h
@@ -11,6 +11,7 @@
 #define _CRYPTO_SM3_H
 
 #include <linux/types.h>
+#include <linux/string.h>
 
 #define SM3_DIGEST_SIZE	32
 #define SM3_BLOCK_SIZE	64
@@ -41,6 +42,15 @@ struct sm3_ctx {
 	u8 buf[SM3_BLOCK_SIZE] __aligned(__alignof__(__be64));
 };
 
+/**
+ * sm3_zeroize_ctx() - Zeroize an sm3_ctx structure
+ * @ctx: The sm3_ctx to zeroize
+ */
+static inline void sm3_zeroize_ctx(struct sm3_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * sm3_init() - Initialize an SM3 context for a new message
  * @ctx: the context to initialize
diff --git a/lib/crypto/sm3.c b/lib/crypto/sm3.c
index b02b8a247adf2..23059347b4493 100644
--- a/lib/crypto/sm3.c
+++ b/lib/crypto/sm3.c
@@ -258,7 +258,7 @@ static void __sm3_final(struct sm3_ctx *ctx, u8 out[SM3_DIGEST_SIZE])
 void sm3_final(struct sm3_ctx *ctx, u8 out[SM3_DIGEST_SIZE])
 {
 	__sm3_final(ctx, out);
-	memzero_explicit(ctx, sizeof(*ctx));
+	sm3_zeroize_ctx(ctx);
 }
 EXPORT_SYMBOL_GPL(sm3_final);
 
-- 
2.55.0

