Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137FF3B0596
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 09:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354228; cv=none; b=ik2PvPTDxPB2G1Tktq8Ld79LCy60UIwVMQ62Kkv2UfaEPEt3cyTVRo0cLcq0xfDTPxsWLIYMr9R1w3LuplKvDdezbkXG0GTmnZK2ni92808Cae/HSNd8qV+jpzCi1QvVQgCaMK83e3qn/1jMm9f4zgzcdYHYTvMMHo0tt0WtEG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354228; c=relaxed/simple;
	bh=El7IzaMDWkQRBdqCf6D4Vf3bxHbeuZw27aOMI6pHWuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khwcKpOMCN5XAzmQ9NXv7MQMpPHyFa//zB+J6+tfhN8BbgPA9lU0IMo9c/tQ0EN1b1fmTDQ0SpUrenIx6wmZ6woBsnPUsqc7QhhwQDm6HjWa7B7nA6FszRGZGl7kQYbCccLHtSe+k7wAa8PkgPxyLPO14CljOK/olYkNTmjwi+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8FWpS3P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8FWpS3P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786354223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FBdlBWEfW4WZn7IIRYi3s7HZuga9kryjgjm+NiKtMPY=;
	b=D8FWpS3PYEKO1lNoWlzuab8mtHsSLJMhVsFkYzvB+qZNIpbkEwahjeZxXc9zkHMdGKsdQe
	1Jh4PWI8QbwgImXTAKAKG30GKVcwqdl9v/byZK6jDSjtRlLzfLSKe57SxPc4l8LkY7iWjm
	t8r8bASc8T4d2lNO3af2E2r6pJcL/Zg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-91-dUQHHiaePL6-0D7U3oJ5kw-1; Mon,
 10 Aug 2026 05:30:18 -0400
X-MC-Unique: dUQHHiaePL6-0D7U3oJ5kw-1
X-Mimecast-MFC-AGG-ID: dUQHHiaePL6-0D7U3oJ5kw_1786354217
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA71E1956058;
	Mon, 10 Aug 2026 09:30:16 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 859953001D38;
	Mon, 10 Aug 2026 09:30:14 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>
Subject: [PATCH v5 01/10] crypto: Provide a wrapper function for zeroizing crypto_aes_ctx
Date: Mon, 10 Aug 2026 11:29:56 +0200
Message-ID: <20260810093009.608090-2-thuth@redhat.com>
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
index 3279cfa546085..e70607249ae5c 100644
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

