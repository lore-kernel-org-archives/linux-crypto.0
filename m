Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E65A44AB8F
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 11:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785931083; cv=none; b=Ij/EvP+Yxoo7Ta0RiK/1G4Yfak/TMI34oCSPtrKLArSQjzSZ+McJslYOXykae8g68upRyQUEYmKFLYzh+jwZDE2cLOuaXZWlplgmZJ9xIXMpFFj282OhGDG1Szcw8NQkKYzpBVu7gqDxcUHbt7M8FLxX1y/KvsMLz+8W60JiHT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785931083; c=relaxed/simple;
	bh=yw/JPU3AhK0bU1PIxC6NpN8/dO32Q22HNdfqE+3cj18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQokZqHUl8ZZmyjBZvxC2shcfVuEFLhbgPKyAjVSmAxBsJDmLC7tqv3hNgYv8Fz7D6wVWS05ohINepznv/gxSASteaRR9Nd7FLfrSBCZMShe8xzKyIVsqwdjhkskyTMkzXMZzQJUOFZJhKVPGIK0LPViniCfq2lkKqOkxi4Rdlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=glBZj4fD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="glBZj4fD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785931080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ULLBSh1RmnUuu3Ug3555qqjX9ogDob1JcFCmK/FvMFs=;
	b=glBZj4fDRcpc56m8/r9Iis4sElyFBhGpL6zKLVHngf6Y7Mu0TOmivVMqpM4EWEVhrNHRRv
	kOEcbmtglEm4sPUGYNwIdSEVl9BntJ2tW8ORVfdTBZrn6I8BOehbguAWV0rafcOL0jlzIS
	civBpmiEdc7sBqwHPbVqjDGEpciQenQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-IeDW5EGaNjCeAGC6TU_BEQ-1; Wed,
 05 Aug 2026 07:57:57 -0400
X-MC-Unique: IeDW5EGaNjCeAGC6TU_BEQ-1
X-Mimecast-MFC-AGG-ID: IeDW5EGaNjCeAGC6TU_BEQ_1785931076
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF9A119560B4;
	Wed,  5 Aug 2026 11:57:55 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.202])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1535730001A2;
	Wed,  5 Aug 2026 11:57:53 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 01/10] crypto: Provide a wrapper function for zeroizing crypto_aes_ctx
Date: Wed,  5 Aug 2026 13:57:39 +0200
Message-ID: <20260805115749.392672-2-thuth@redhat.com>
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

Several crypto drivers need to zeroize their local crypto_aes_ctx
structures after use to avoid leaking key material on the stack.
Currently some call sites do this with their own memzero_explicit()
call, which is error-prone since it is easy to miss a return path
(what already happened in a driver). Some other call sites miss
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
+ * are leaked on the stack or heap.
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

