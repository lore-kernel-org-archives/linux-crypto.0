Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3554D47D93A
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629023; cv=none; b=JBSXbwNxnb3w135I2eomrFfqBLxxkmru1/y63+I+yLhfRZ5hIgPE5vcyLMmRkarNRVum4Z6n+uDgjDEj3UpOgTap/wQUBymWRMP186BOUQikJUO2SWVJJztNGEDt08faTv8INRmUKTHESRvMsQSctS7dhJSzABj+WBCg6jqWWFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629023; c=relaxed/simple;
	bh=uUa5plyw0TfZtImmIp9ZSco5a2LUcuWZ490iootreRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFHkOgZYKSJbtJ3KbfKkubWgL3rVf0MwMrPK96Gj6H+yODWtnh5wac88nMU/qOP7NL3qgYjXLowdOTs/tBm/rMkBCc2jSFDjxK1lGgHLeh2LBm1rN67yszkhsVGCtLX7mXZdCWXyDmjD1oppcp/t2uQCMzSp3854HO28+PkJfxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MeKhS3Ri; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MeKhS3Ri"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sddW5u89pPuUGP366qWgtzb2asLGLVmYCNoyTSeV2rs=;
	b=MeKhS3Ri44X1xJpGfQB34dHxgYnW83qKUiX9Sq4HnDdB2laCRiCgGRUYs68yrfAL/qDFhd
	JUAmQThNi7j0Ga1J4dCsJfjQUkgNLDqzSC1OSjh2uXFzNc9W9EtAmZoH7pV3Zllo0jLGhN
	HKQFOkYtzCsRjgGmjng/gQy1dEUr+7s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-150-nsNrpX_9PsqVVQdzjt1OWw-1; Thu,
 13 Aug 2026 09:50:15 -0400
X-MC-Unique: nsNrpX_9PsqVVQdzjt1OWw-1
X-Mimecast-MFC-AGG-ID: nsNrpX_9PsqVVQdzjt1OWw_1786629014
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3A451954B09;
	Thu, 13 Aug 2026 13:50:13 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C2421800348;
	Thu, 13 Aug 2026 13:50:11 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] lib/crypto: aes: Provide functions for zeroizing aes_key and aes_enckey
Date: Thu, 13 Aug 2026 15:49:42 +0200
Message-ID: <20260813134953.979481-5-thuth@redhat.com>
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

Some crypto functions need to zeroize their local aes_key or aes_enckey
structures after use to avoid leaking sensitive material on the stack.
Provide aes_zeroize_key() and aes_zeroize_enckey() helper functions that
can be used with __cleanup() to automatically zeroize the structs when
they go out of scope.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/aes.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index faf1d1b75a15f..d00d88b71690b 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -102,6 +102,19 @@ struct aes_enckey {
 	union aes_enckey_arch k;
 };
 
+/**
+ * aes_zeroize_enckey() - Zeroize an aes_enckey structure
+ * @key: The location of the key structure that should be zeroized
+ *
+ * Explicitly fills the aes_enckey with zeroes. For example, use it with
+ * __cleanup() for local aes_enckey structures on the stack, so that their
+ * content is not leaked when the context is left.
+ */
+static inline void aes_zeroize_enckey(struct aes_enckey *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct aes_key - An AES key prepared for encryption and decryption
  * @aes_enckey: Common fields and the key prepared for encryption
@@ -116,6 +129,19 @@ struct aes_key {
 	union aes_invkey_arch inv_k;
 };
 
+/**
+ * aes_zeroize_key() - Zeroize an aes_key structure
+ * @key: The location of the key structure that should be zeroized
+ *
+ * Explicitly fills the aes_key with zeroes. For example, use it with
+ * __cleanup() for local aes_key structures on the stack, so that their
+ * content is not leaked when the context is left.
+ */
+static inline void aes_zeroize_key(struct aes_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /*
  * Please ensure that the first two fields are 16-byte aligned
  * relative to the start of the structure, i.e., don't move them!
-- 
2.55.0

