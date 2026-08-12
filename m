Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9DE448D02
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786552444; cv=none; b=B2XxSMXXpyzdW4hqrZiyUJXsTFF3YzLQ+PGKySWDHeAsd89uUpdO5bEsNy+A2ptfGeqRBrpPxaphxe2Aj4men4YQibJPkX3tYHKo5VO+bH7FbSsKVrtxgBiZvBldhHl9wuiU9yYR14bpS2Vg51uSkQTniAj7lYkJZjf2hyIBJT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786552444; c=relaxed/simple;
	bh=H0AsNw6nyb/BtVnYK60V39hmdcgkIq5e7NKdNvUULCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZ7QCpObzbXevN+Ct07EDgo5wvqhSCwa6pU1Y51SLrBQ25oup07MDgMxHqgOq8Mn4gB5h9Yty/p24HHY8NRlNBjy7Q2Y+RFgo/ueIcHgxN1pT67JQ4XS/ek12blhIZ1EEQZJpyYSEObKehaGEa7xML05ZnSIv/7tP9og9Wyxjo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D2y/51xO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D2y/51xO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786552442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iy7j/qc0bwgXcBR+rs01Cp3y9nQB0NyqAakXgL7RNv4=;
	b=D2y/51xOvK/I1UhiDh9o21EGb1zIAapGBQrPrDJzG6Rkc/qrhmcwKc5dNBz9MlSuGNO+9Z
	4EAq4tPkS+jC6ZtFlFkf4pwkJ2pj8ie51+kgzwcIITNqMFtMlmGRrTfQQm5K7ySaHS7+7t
	kBz3Yg8c20Zxehd2kV2j8TzGSBPNbUE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-qJhN_oKbOPKXR9IOzvP6vg-1; Wed,
 12 Aug 2026 12:33:58 -0400
X-MC-Unique: qJhN_oKbOPKXR9IOzvP6vg-1
X-Mimecast-MFC-AGG-ID: qJhN_oKbOPKXR9IOzvP6vg_1786552436
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDE261956048;
	Wed, 12 Aug 2026 16:33:55 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE8FF3002D29;
	Wed, 12 Aug 2026 16:33:49 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH 2/3] security: keys: trusted: always clear the hmac_sha1_ctx before returning
Date: Wed, 12 Aug 2026 18:33:35 +0200
Message-ID: <20260812163336.3103835-3-thuth@redhat.com>
In-Reply-To: <20260812163336.3103835-1-thuth@redhat.com>
References: <20260812163336.3103835-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

Clear the hmac_sha1_ctx structure via __cleanup(hmac_sha1_zeroize_ctx)
to make sure that the function cannot leak any sensitive data on the
stack in case we return without hmac_sha1_final() here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 security/keys/trusted-keys/trusted_tpm1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 13513819991e7..90536ae53d4a8 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -102,7 +102,7 @@ static inline void dump_tpm_buf(unsigned char *buf)
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

