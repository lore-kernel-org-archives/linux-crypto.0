Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26023470EB2
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786552452; cv=none; b=RZ3S7VP75K9B48OBUKN1hxMbFNOlTj/iZRVnat2s67QTpFetNFaT2C53v8Dz4JzadzbVXEvc7IKloF3CU6UWqZ9zMqiIXNFxvq1sD2AYh5t8ocda6tk0Bk4PP7udWsDnsjbdrTLp0M1+CG3ZaVmdOC7CLc2e3RYoy/lXWfImgfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786552452; c=relaxed/simple;
	bh=+2zRxSvjAmqwYOE+tKwr1WSnbMWmNOH7W2evqTcz3wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjZkyuGxvIlwHs+ofjsh5nKMiYQBXBnSM4RhP+zNaHwn/ag02rMJVACVfoXhOeSD5wD/0wy5a6NB0YWYn3g8fh5eCiumdGkLJoxtLlbzmBFntzMDoZOXf2/wHI6CbodDQzzgBN7rZPiONRX8hNdueasv3n09TfwLRlsZP3Cxids=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gjH57X5F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gjH57X5F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786552450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpTxCCo1JlTQTpMq2MklUewzzbiQjhVKEixoMx1SLYE=;
	b=gjH57X5Fbtr20nRSCqBhn5K/df0+ciLR6mawO7I8fzYV85GZRBRCVDBzLo8q3a79MmTHe0
	dCy68SWcIaT+pzQtCRZ4lV1w5Zo4gLuU7JUrCPqhVxoFAyL1ADx/3mbvmRIiEGta/6yPsW
	1cC4OTnJF9rJ6IoA6NKzwvb2+2kCEkM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-rnie3BrMNuqh1rYf3ZMijw-1; Wed,
 12 Aug 2026 12:34:04 -0400
X-MC-Unique: rnie3BrMNuqh1rYf3ZMijw-1
X-Mimecast-MFC-AGG-ID: rnie3BrMNuqh1rYf3ZMijw_1786552442
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57089180028A;
	Wed, 12 Aug 2026 16:34:02 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E4443002D30;
	Wed, 12 Aug 2026 16:33:56 +0000 (UTC)
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
Subject: [PATCH 3/3] lib/crypto: sha1: Use hmac_sha1_zeroize_ctx() instead of memzero_explicit()
Date: Wed, 12 Aug 2026 18:33:36 +0200
Message-ID: <20260812163336.3103835-4-thuth@redhat.com>
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

It's only cosmetics, but since we have the new hmac_sha1_zeroize_ctx()
function anyway, we can also use it here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/crypto/sha1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
index b687b89d97cb4..c4361ef77166e 100644
--- a/lib/crypto/sha1.c
+++ b/lib/crypto/sha1.c
@@ -275,7 +275,7 @@ void hmac_sha1_final(struct hmac_sha1_ctx *ctx, u8 out[SHA1_DIGEST_SIZE])
 	for (size_t i = 0; i < SHA1_DIGEST_SIZE; i += 4)
 		put_unaligned_be32(ctx->ostate.h[i / 4], out + i);
 
-	memzero_explicit(ctx, sizeof(*ctx));
+	hmac_sha1_zeroize_ctx(ctx);
 }
 EXPORT_SYMBOL_GPL(hmac_sha1_final);
 
-- 
2.55.0

