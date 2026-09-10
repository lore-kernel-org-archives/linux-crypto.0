Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5553A488218
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 12:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789044155; cv=none; b=VI0InGKgJriHXsV0lyZOPVPUHD+xMR4RN0skYE1FN/QhxZGx0yqLAf0ZkL4IrF/y33yfpTFJMS/c7aEXnXKl6ybvykQsUGOW/8BICfGzDdxkWeDi4UCd8ulqOkHNm308uXcNObv6lqbEC36nYJViLm9+9z0C6gkAxGewJtZ9SH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789044155; c=relaxed/simple;
	bh=YA+a6CCA1zWdQPcieNEuLQ0mIwRn0Ck7WsDOY4ql94Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmeuKhqMAOWMXYvIeButMdN36Qh4FNBCElNI900RZQcdBJF83g7Zc5wlafYbOmDwq69jM+P/U+QZgY/kSkpLcjz2brZzakWjZ5cPY+UQf2xMr9a+ZBAsm6GmU9nwYdOXVmV8W9EN9tNI8jqugLHmqZsCJaV3vjMFWZ/P84fwrH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TJeUmXs9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TJeUmXs9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789044153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FeWcXK9/x+ZPPaC++IgCQ9jS/VWtgj79RgI0CVq94cU=;
	b=TJeUmXs9HSaL4fUxogZX7rz8ckyoXRAa8+Pq5PRqGyA7Yrwb6KBwefEtbFUYcb+vCFuZwe
	EQkLuQNp5tOPuiGQf6hEPP3J7cQSofNMsqF/X0WzZWZKuXmgjX4plv+InapgJbNsOg7kxE
	4mG5hhP4WV/uW49/JNhC9lyvvAKvSQc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-510-_fDLdsfrOGmPiu1KhPeDgg-1; Thu,
 10 Sep 2026 08:42:28 -0400
X-MC-Unique: _fDLdsfrOGmPiu1KhPeDgg-1
X-Mimecast-MFC-AGG-ID: _fDLdsfrOGmPiu1KhPeDgg_1789044146
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA9721800640;
	Thu, 10 Sep 2026 12:42:25 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B2AB730001A2;
	Thu, 10 Sep 2026 12:42:19 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-integrity@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v3 09/13] security: keys: trusted: always clear the hmac_sha1_ctx before returning
Date: Thu, 10 Sep 2026 14:41:28 +0200
Message-ID: <20260910124138.417439-10-thuth@redhat.com>
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

Clear the hmac_sha1_ctx structure via __cleanup(hmac_sha1_zeroize_ctx)
to make sure that the function does not leak sensitive data on the stack
when returning without calling hmac_sha1_final().

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 security/keys/trusted-keys/trusted_tpm1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index bf0bf7f369705..e5a904b5c1946 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -101,7 +101,7 @@ static inline void dump_tpm_buf(unsigned char *buf)
 static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
 		       unsigned int keylen, ...)
 {
-	struct hmac_sha1_ctx hmac_ctx;
+	struct hmac_sha1_ctx hmac_ctx __cleanup(hmac_sha1_zeroize_ctx);
 	va_list argp;
 	unsigned int dlen;
 	unsigned char *data;
-- 
2.55.0

