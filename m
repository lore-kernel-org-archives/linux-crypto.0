Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BB84B0C95
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 09:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552268; cv=none; b=YzTN8cqYfTMYEBNtpK+dC2vVZeH+6z/kvTOWppLaemIJiKlCA1XTbHBDxw5EYxT33Js8vzTJaetOyhaaCsUe0jv8a9BO6xPi5pW9ItyqkMKKHG4GLGMy25wIs2/obE+ysBk0PYdY7xskBvoJh8sq15qyCKfbCRXGmFu8zLVS6O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552268; c=relaxed/simple;
	bh=Pu553ZQkM91B4VrsGc9weFb5s0yBfWGWM2iMrF015hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ek1PXz4jv+Ck6iML12Ol2JhsOF+yfuNYQaCwlsuCLEq0hdFkBbPzLSt5jMvpXmaypi2KgWj5pyuRzN9KB41HA15d/iNWvx2Y2eMkxKZx5Ps+Q79m3lXXdYYUGmHeOEXRkR6Xsf8dBTYtjSd2glABhyb/z/o/6yMck/sB/RV9YFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ignHr3Og; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ignHr3Og"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789552245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iKydTuaKi3XtSbexoPJB1tXNpcTYcsS4RpRAKal/7tc=;
	b=ignHr3OgRvLrmMpp5jJiFPisVS0EQAejjv4RYrgIPA1bJ59Sv3mtD6MDt5cQ/qLh0tltJE
	3iA92RZeJtofpZ/2gfehjhld2EYsRBEXXMtvo5Y78l6233XGw0ePIymtQar1Ojex7FrNoQ
	KovzV0eL/2134MTHqWEfI6CGPRtqK0o=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-agQkf6kLMLu0ekoPCI2NKQ-1; Wed,
 16 Sep 2026 05:50:40 -0400
X-MC-Unique: agQkf6kLMLu0ekoPCI2NKQ-1
X-Mimecast-MFC-AGG-ID: agQkf6kLMLu0ekoPCI2NKQ_1789552239
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C9F6189F8E0;
	Wed, 16 Sep 2026 09:50:38 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1940F1800446;
	Wed, 16 Sep 2026 09:50:33 +0000 (UTC)
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
Subject: [PATCH v4 02/13] lib/crypto: aes-xts: Provide function for zeroizing aes_xts_key
Date: Wed, 16 Sep 2026 11:50:04 +0200
Message-ID: <20260916095022.604354-3-thuth@redhat.com>
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
aes_xts_key structures after use to avoid leaking sensitive material.
Provide an aes_xts_zeroize_key() helper function that e.g. can be
used with __cleanup() to automatically zeroize the struct when it
goes out of scope.

While we're at it, replace the related memzero_explicit() call in
lib/crypto/aes.c with a call to the new helper function.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/aes-xts.h | 13 +++++++++++--
 lib/crypto/aes.c         |  2 +-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/crypto/aes-xts.h b/include/crypto/aes-xts.h
index b9e828265e58a..3a52e1cf40b57 100644
--- a/include/crypto/aes-xts.h
+++ b/include/crypto/aes-xts.h
@@ -22,6 +22,15 @@ struct aes_xts_key {
 	struct aes_enckey tweak_key;
 };
 
+/**
+ * aes_xts_zeroize_key() - Zeroize an aes_xts_key structure
+ * @key: The aes_xts_key to zeroize
+ */
+static inline void aes_xts_zeroize_key(struct aes_xts_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * aes_xts_preparekey() - Prepare a key for AES-XTS encryption and decryption
  * @key: (output) The key structure to initialize
@@ -30,8 +39,8 @@ struct aes_xts_key {
  * @flags: Optional flag XTS_FORBID_WEAK_KEYS to forbid keys whose two halves
  *	   are the same.
  *
- * Users should use memzero_explicit() to zeroize the key struct at the end of
- * its lifetime.  (But if this function fails, zeroization is unnecessary.)
+ * Users should use aes_xts_zeroize_key() to zeroize the key struct at the end
+ * of its lifetime.  (But if this function fails, zeroization is unnecessary.)
  *
  * Context: Any context.
  * Return:
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 07c1d912ac365..34ef5deca0a79 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -1223,7 +1223,7 @@ int aes_xts_preparekey(struct aes_xts_key *key, const u8 *in_key,
 	return 0;
 
 out_zeroize:
-	memzero_explicit(key, sizeof(*key));
+	aes_xts_zeroize_key(key);
 	return err;
 }
 EXPORT_SYMBOL_GPL(aes_xts_preparekey);
-- 
2.55.0

