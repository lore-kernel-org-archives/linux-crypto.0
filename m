Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845DD47887B
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629012; cv=none; b=BXQ62v2sKtErILUkyUndEtmR4rN6veT+HNeb07x5+lD8XMQ3D92pX9WPi0O8Ce3dmIZSepXZzoEca8SfUUZBOr2VkYjqPdQ/00LR4HMyzhA/5dVgP1EMSRj4L5dBKflzBpdwjqa5LuKPoBgUeCsV+gf3uB6maJT1JnDozdy4/eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629012; c=relaxed/simple;
	bh=3xW7xdIM2wNppA0nF0o+0eYHDMxOofqYYPTNEqPAzYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/QbZAZgpp2bGpm4soc2LOnJcw+PrZOOmqTlnqdVpok32lPETFLFsWbY2tULs2bIovsyFmlzE6OLR+9sws99WcNb0QF0pGxqI8aHh6lOl4AVElD2oW24yt4bMku9XWA0nk4QahtIz1VJGkdh95RCMGSAf/rb8oG7sJ01BtmrQ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TyIa2sBi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TyIa2sBi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k4VB0ko4NuEn9j2j4MfCIFBIKAPYilKmfffKRX5qXbE=;
	b=TyIa2sBiFD9qtZbOkRuyN95Bx0TIyF3g7/yh7/Ohw/Ero5yOaNIACxw5RIUC7bYonSAQFP
	tHFR8cI+2joHrIZck0nvrOLYz+UyDle60P814XhrecWAZKPKyTWn8zH4NqesmYZIsuMghD
	3l27RWlE3a8e59m2cgLIPNVCPaNyqPk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-375-kcStfmB0NMqXaSKxFnD80A-1; Thu,
 13 Aug 2026 09:50:08 -0400
X-MC-Unique: kcStfmB0NMqXaSKxFnD80A-1
X-Mimecast-MFC-AGG-ID: kcStfmB0NMqXaSKxFnD80A_1786629002
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62A5C1955E70;
	Thu, 13 Aug 2026 13:50:02 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 36D921800577;
	Thu, 13 Aug 2026 13:49:59 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] lib/crypto: aes: Provide a wrapper function for zeroizing crypto_aes_ctx
Date: Thu, 13 Aug 2026 15:49:39 +0200
Message-ID: <20260813134953.979481-2-thuth@redhat.com>
In-Reply-To: <20260813134953.979481-1-thuth@redhat.com>
References: <20260813134953.979481-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

Several crypto drivers need to zeroize their local crypto_aes_ctx
structures after use to avoid leaking key material on the stack.
Currently some call sites do this with their own memzero_explicit()
call, which is error-prone since it is easy to miss a return path
(what already happened in some drivers). Some other call sites miss
to clear crypto_aes_ctx completely.

Provide an aes_zeroize_ctx() helper that can be used with __cleanup()
to automatically zeroize the context when it goes out of scope.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/aes.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 16fbfd93e2bd0..faf1d1b75a15f 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/crypto.h>
+#include <linux/string.h>
 
 #define AES_MIN_KEY_SIZE	16
 #define AES_MAX_KEY_SIZE	32
@@ -125,6 +126,19 @@ struct crypto_aes_ctx {
 	u32 key_length;
 };
 
+/**
+ * aes_zeroize_ctx - Clear a crypto_aes_ctx structure
+ * @ctx: The location of the context that should be zeroized
+ *
+ * This function explicitly fills the crypto_aes_ctx with zeroes. For
+ * example, use it with __cleanup() for local crypto_aes_ctx structures on
+ * the stack to avoid that their content is leaked when the context is left.
+ */
+static inline void aes_zeroize_ctx(struct crypto_aes_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /*
  * validate key length for AES algorithms
  */
-- 
2.55.0

