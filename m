Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD16548545
	for <linux-crypto@vger.kernel.org>; Wed,  9 Sep 2026 11:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954935; cv=none; b=IIy1UpPEKJZhDDsvr5Pg1A+gHSRw8ynO20T2C9kjvj1aMJ/a3X2fpp1ygWcvC2hcodhZ1ZeD5XhKE6pPbn2JoOqiFZkuLoWv5Us3duIvc2bmU4er26EfnUNbIsLfn+9kFoiHKBeI2+bsglIf7gnlnkXBdQDD7+CKj3fQFJsBoO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954935; c=relaxed/simple;
	bh=1eGnr7sGi0HQFB/17GdIY9Hr7u1mX/ltDaQTx/Vt9Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRifvzbVasZR1RA/syr9S+h0sOGtiW5zJO3CTqGFgMkEiNlUY76FS2a0xyYZjJc5TKgeIv6BTmHHLjMZtbVQIblZC06FJLQKdbFMem0RtaI2eK9pF9iPUuQiZFu7x0IL+LyjMpV6CLUDkGOQTZnSvWu6K6B/LW1d+SL/gRCiC6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bmPPIkJf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bmPPIkJf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788954933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7xr6U9d+4aCYYZf6FSP46iQRfFcNkrBzahPUUHhcqcw=;
	b=bmPPIkJfWGCWb1JTdqaDePdxFFYBbBxTI0aJOEGg48GDbZ1VC9BlXxMVE9bGZNl2UCZeir
	8/WUgbCkz8pMX56FhAryx7OtywttH6eUmQUc/8/hNimRWH4FNJcStlNlqolg6XYgMDSj09
	xqVISXRfBivfmcmwgYnJBVOUmZ/W48Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-3qWkksO5NKKaHQxpTgDL8w-1; Wed,
 09 Sep 2026 07:55:29 -0400
X-MC-Unique: 3qWkksO5NKKaHQxpTgDL8w-1
X-Mimecast-MFC-AGG-ID: 3qWkksO5NKKaHQxpTgDL8w_1788954928
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24A7B1955BD9;
	Wed,  9 Sep 2026 11:55:28 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6EADA1956088;
	Wed,  9 Sep 2026 11:55:24 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v2 06/13] lib/crypto: sm3: Provide a function for zeroizing the sm3_ctx structure
Date: Wed,  9 Sep 2026 13:54:42 +0200
Message-ID: <20260909115455.157093-7-thuth@redhat.com>
In-Reply-To: <20260909115455.157093-1-thuth@redhat.com>
References: <20260909115455.157093-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In certain cases crypto code functions need to zeroize their local
sm3_ctx structure after use to avoid leaking sensitive material. Provide
a sm3_zeroize_ctx() helper function that e.g. can be used with __cleanup()
to automatically zeroize the structure when it goes out of scope.

While we're at it, replace the related memzero_explicit() call in
lib/crypto/sm3.c with a call to the new helper function.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/sm3.h | 9 +++++++++
 lib/crypto/sm3.c     | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/crypto/sm3.h b/include/crypto/sm3.h
index 371e8a6617054..1b41356ed0864 100644
--- a/include/crypto/sm3.h
+++ b/include/crypto/sm3.h
@@ -41,6 +41,15 @@ struct sm3_ctx {
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

