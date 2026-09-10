Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38A648987F
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 12:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789044180; cv=none; b=llOOk+4mfukZnoI/Dy4LstgQpb2kak7yEK34kvGw1qRFzf1acPnHxDV/2ByOZ2QeUCQm/625cldfE91dY8biS5fjnbA5rUDtzUCQnGhShFVui47iyNJnz7L0JPhPQrL8oCGQgxcPCB12nEOzghj8G7YNC7JwcUzlWoCacID1qZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789044180; c=relaxed/simple;
	bh=hyE4ASHNwg9Uj2y/LqFNdaodpbnC/HufT5ZC6lmi+i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3okdO800EI8+3FDLcXCeYAc8GHc/LtOd3tj3ymJDg/tPhD0uImhhcRoVrkJTQCD7ajzxDFpMLI89TxyjZMznHtdc5V1uvrrC8uMBg0TfaDHbMk4SjNBVOPDquRogvoMcaHum7ZwPSC1t21cqbs5dHi3yqtvdC3dxgVQqRZVhcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MMrauRPH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MMrauRPH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789044172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wf4K7MwVHeiA8+HVe2UqXYpCXeE1gIwIobNNMMvBsJk=;
	b=MMrauRPHwNUxU/82ZRyKo8UfAt72l6E3RKjx0b81FSxWt/JXAz7Z6QizP/EfrXzontV/a7
	QSFaMWmRPdOG16nnHzZN+MYp5uaTBsdYE4Ese6QWgQ9dV/HySSOo4C1RxFwSzOUXRVG3tX
	TwebddTJY1VkNI9XKSTvRWRmhdUWvTk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-14-acUEBIB3MWuFJTkD2YmIlw-1; Thu,
 10 Sep 2026 08:42:49 -0400
X-MC-Unique: acUEBIB3MWuFJTkD2YmIlw-1
X-Mimecast-MFC-AGG-ID: acUEBIB3MWuFJTkD2YmIlw_1789044167
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A04EE1955F6E;
	Thu, 10 Sep 2026 12:42:46 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0975E30001A2;
	Thu, 10 Sep 2026 12:42:41 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH v3 13/13] lib/crypto: Add documentation about zeroization of key and context data
Date: Thu, 10 Sep 2026 14:41:32 +0200
Message-ID: <20260910124138.417439-14-thuth@redhat.com>
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

Add a central document about zeroization in libcrypto so we don't
have to repeat this information in the individual kernel docs of
the zeroization functions all over the place.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .../crypto/libcrypto-zeroization.rst          | 129 ++++++++++++++++++
 Documentation/crypto/libcrypto.rst            |   1 +
 2 files changed, 130 insertions(+)
 create mode 100644 Documentation/crypto/libcrypto-zeroization.rst

diff --git a/Documentation/crypto/libcrypto-zeroization.rst b/Documentation/crypto/libcrypto-zeroization.rst
new file mode 100644
index 0000000000000..2a12417e335a3
--- /dev/null
+++ b/Documentation/crypto/libcrypto-zeroization.rst
@@ -0,0 +1,129 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+Crypto Key Zeroization
+======================
+
+This document describes the conventions for zeroizing crypto structures in the
+kernel.
+
+.. contents::
+
+Overview
+--------
+
+Cryptographic key material and intermediate state (such as HMAC contexts) must
+be zeroized after use to prevent sensitive data from lingering on the stack or
+heap, where it could be leaked through memory disclosure vulnerabilities,
+crash dumps, or cold-boot attacks.
+
+For memory that has been allocated with kmalloc() or a similar function,
+kfree_sensitive() should be used instead of kfree() to release the memory.
+
+For other cases, the kernel provides memzero_explicit() for clearing the
+memory.  Unlike plain memset(), memzero_explicit() is guaranteed not
+to be optimized away by the compiler, even when the memory being cleared
+appears to be dead.
+
+The crypto library builds on memzero_explicit() by providing typed
+zeroization helpers for each key and context structure.  These helpers serve
+two purposes:
+
+1. They make __cleanup() annotations possible, so that structures on
+   the stack are automatically zeroized when they go out of scope.
+
+2. They improve readability by replacing ``memzero_explicit(&key, sizeof(key))``
+   with a self-documenting call like ``aes_zeroize_key(&key)``.
+
+
+What to zeroize
+---------------
+
+The following types of structures hold sensitive material and should be
+zeroized after use:
+
+- **Key structures** (e.g. ``struct aes_key``, ``struct hmac_sha256_key``):
+  contain expanded round keys or prepared key material.
+
+- **HMAC/MAC context structures** (e.g. ``struct hmac_sha256_ctx``,
+  ``struct aes_cmac_ctx``): contain inner and outer hash states derived from
+  the key.
+
+- **Hash context structures** (e.g. ``struct sha256_ctx``): may contain
+  sensitive data being hashed.
+
+Not all of these require explicit cleanup by callers.  Many ``..._final()``
+functions already zeroize their context internally (see `Automatic vs. manual
+zeroization`_ below).
+
+
+Zeroization helpers
+-------------------
+
+Each crypto structure that callers may need to zeroize should have a
+corresponding inline helper function.  The naming convention is::
+
+    <algorithm>_zeroize_<type>(struct <algorithm>_<type> *p);
+
+For example::
+
+    void aes_zeroize_key(struct aes_key *key);
+    void aes_zeroize_enckey(struct aes_enckey *key);
+    void hmac_sha256_zeroize_ctx(struct hmac_sha256_ctx *ctx);
+    void aes_cmac_zeroize_key(struct aes_cmac_key *key);
+    void aes_cmac_zeroize_ctx(struct aes_cmac_ctx *ctx);
+
+Each helper is a ``static inline`` function in the algorithm's header that
+wraps ``memzero_explicit()``, for example::
+
+    static inline void hmac_sha256_zeroize_ctx(struct hmac_sha256_ctx *ctx)
+    {
+            memzero_explicit(ctx, sizeof(*ctx));
+    }
+
+These helpers should include kernel-doc comments following the standard
+conventions::
+
+    /**
+     * hmac_sha256_zeroize_ctx() - Zeroize an hmac_sha256_ctx structure
+     * @ctx: The hmac_sha256_ctx context to zeroize
+     */
+
+
+Using __cleanup for automatic zeroization
+-----------------------------------------
+
+The preferred way to zeroize stack-allocated key and context structures is
+with the __cleanup() attribute.  This ensures zeroization happens on all
+exit paths, including error returns and early exits.
+
+Note that __cleanup() attributes should not be used in functions that use
+"goto" statements. The benefit of cleanup helpers is the removal of "gotos",
+and that "goto" statements can jump between scopes, so the expectation is
+that usage of "goto" and cleanup helpers is never mixed in the same function.
+
+
+Automatic vs. manual zeroization
+--------------------------------
+
+Many ``..._final()`` functions in the crypto library automatically zeroize
+their context before returning.  When this is the case, the kernel-doc for the
+function documents it::
+
+    After finishing, this zeroizes @ctx.  So the caller does not need to do it.
+
+In these cases, callers on simple code paths (where ``..._final()`` is always
+reached) do not need to add __cleanup() or explicit zeroization.
+However, __cleanup() is still recommended whenever there are error paths
+that bypass ``..._final()``, as it ensures zeroization on all paths.
+
+For algorithms where ``..._final()`` does *not* zeroize the context (such as
+the SHAKE XOFs, where ``shake_squeeze()`` can be called multiple times),
+callers must explicitly zeroize the context by calling the appropriate helper
+or using __cleanup(), for example::
+
+    struct shake_ctx ctx __cleanup(shake_zeroize_ctx);
+
+    shake256_init(&ctx);
+    shake_update(&ctx, data, data_len);
+    shake_squeeze(&ctx, out, out_len);
+    /* ctx is automatically zeroized at end of scope */
diff --git a/Documentation/crypto/libcrypto.rst b/Documentation/crypto/libcrypto.rst
index e911e05215979..9533c12caa79d 100644
--- a/Documentation/crypto/libcrypto.rst
+++ b/Documentation/crypto/libcrypto.rst
@@ -165,4 +165,5 @@ API documentation
    libcrypto-signature
    libcrypto-unauth-encryption
    libcrypto-utils
+   libcrypto-zeroization
    sha3
-- 
2.55.0

