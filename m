Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0BD48595A
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 12:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789044120; cv=none; b=QWJw7EGUpHKw7SsF6+WowoIDv4taiGHc5qprJ8GCQDIMdPkC208JD9ZoLgS/2C2xNW6Ej/osIRKtjF/b+wpRzNRB/P7Aaj2uj/BIMQg2D3EaBeiNWdNFlA0ReV71nOix4e9B/nbfP6y7iEldQDP9f2yYWDW3Im1TL7E/qGoBWRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789044120; c=relaxed/simple;
	bh=Pu553ZQkM91B4VrsGc9weFb5s0yBfWGWM2iMrF015hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VteFs/SLcRAWIi9+r/s3G73/zgvnlD4nylIuab1FCAvMNnqKWgfAMQm5EgAEsdNjn9Oxp4yEYOo35TWfEgUFUUwjwwGvzGjugoYiB4A++D1Ya27CUNHgRH47XlsMOu9vFUhDVK2ymHl2HVnjzGRkzLQB49/eSeLWIfZz07E0cXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bld+Utu6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bld+Utu6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789044116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iKydTuaKi3XtSbexoPJB1tXNpcTYcsS4RpRAKal/7tc=;
	b=Bld+Utu6UClU0T7uA/gtMUazwf2/lyfVi6MCYbcFtQSov4lG7e2BHWITSgfzhJrkMGYZBU
	zejNwpdUA+ffXgsSo/2Mh8kbik3In9jk0AcQA4FHwkSDz60Y7QAKXzYWvniynaxMVkiFkj
	y/qtmN8KWSxpzuGbQr9cwmb+8kxLdmI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-UKNCLXBSPXql7KfXoqJSQw-1; Thu,
 10 Sep 2026 08:41:55 -0400
X-MC-Unique: UKNCLXBSPXql7KfXoqJSQw-1
X-Mimecast-MFC-AGG-ID: UKNCLXBSPXql7KfXoqJSQw_1789044113
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 458771954214;
	Thu, 10 Sep 2026 12:41:53 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 594D230001A2;
	Thu, 10 Sep 2026 12:41:49 +0000 (UTC)
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
Subject: [PATCH v3 02/13] lib/crypto: aes-xts: Provide function for zeroizing aes_xts_key
Date: Thu, 10 Sep 2026 14:41:21 +0200
Message-ID: <20260910124138.417439-3-thuth@redhat.com>
In-Reply-To: <20260910124138.417439-1-thuth@redhat.com>
References: <20260910124138.417439-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

