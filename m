Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9864848095E
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629016; cv=none; b=JVkcxDp1VwwD9dpWMSWCjz6kgRgTLpJh5N2ibXyg/VyRFtzi6XBvABlsLNl7WRK60xD0yg9NeCcBro2vAbcNMXS1oGMoYpZtbckojJpA9B1/1TY4hw+XNcQSlZoqwnXoAxVmG6oFTJq5lijjecXcdh2f0w384ilvJo7VXpoBBtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629016; c=relaxed/simple;
	bh=bX6HRBwdnB6ZIpN9/d4z0qHvQIXwP/ROMZqxiYBFN58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stjWhQfINlqRV68wz8xTOHrNnhgRneU4CVMZ2Ld+YqmPzt2QPm+irH/dRJyvuj9LxIZ65mN/UylhgPboBvPr6epUKzzo8ZpHrYUpMDpZP5aF5eyfxwOxlXekR/sIISCMcn2SeMYvig7iGO9aFL3qDuO0L5APapAt4pykOMc/KR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jO+UFGJr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jO+UFGJr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ewMKbBScmXwQYp7ywq0PQOjQEbufTUVDV5iJ2npxWc=;
	b=jO+UFGJr/4xdOoOT/NXpK2w446dEUo714QToJYZYI2kHeACUYvIWUiNtKnCA2vCnJa356J
	3nLiSHUoIquDbmS60WfU8lH5fna/HQC+W2/Cor46MaBHTHqeK1NTsHQiCptm7OcHWwQntb
	IVBsVnxuW2p8n52sAQ558gFt+5dGtrI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-210-CrbOrvhXMBe16k_ysetcMA-1; Thu,
 13 Aug 2026 09:50:09 -0400
X-MC-Unique: CrbOrvhXMBe16k_ysetcMA-1
X-Mimecast-MFC-AGG-ID: CrbOrvhXMBe16k_ysetcMA_1786629007
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BBBD195608A;
	Thu, 13 Aug 2026 13:50:06 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D6CA180049F;
	Thu, 13 Aug 2026 13:50:02 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] crypto: safexcel - Simplify the check for a valid AES key
Date: Thu, 13 Aug 2026 15:49:40 +0200
Message-ID: <20260813134953.979481-3-thuth@redhat.com>
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

safexcel_aead_setkey() currently uses aes_expandkey() to check for a valid
AES key, but then does not use the crypto_aes_ctx afterwards anymore,
i.e. this is just a wasteful way of checking the key length, and thus
aes_check_keylen() should be used instead.
This also fixes a potential leak of sensitive data via the stack, since
this function forgot to zeroize crypto_aes_ctx before returning to the
caller.

Suggested-by: Antoine Tenart <atenart@kernel.org>
Acked-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index a8349b684693e..f07d043c67d45 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -407,7 +407,6 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_authenc_keys keys;
-	struct crypto_aes_ctx aes;
 	int err = -EINVAL, i;
 	const char *alg;
 
@@ -438,7 +437,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 			goto badkey;
 		break;
 	case SAFEXCEL_AES:
-		err = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
+		err = aes_check_keylen(keys.enckeylen);
 		if (unlikely(err))
 			goto badkey;
 		break;
-- 
2.55.0

