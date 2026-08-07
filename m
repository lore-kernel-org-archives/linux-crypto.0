Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BC63AC0C1
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 07:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086465; cv=none; b=pVvqlrqaWRLrTzTEuMQ8ImISvNgpUrTVMtp7dstS1vOi3PzdLa/z+G7GiuTw9zpESCLyp6UsIk2ohJBK+GrIjXz+XvKOYjDAm82cw0xv5M/o3NUXwRVXWQsHpVGGkO/svhCsPmb8RLXRrS/Nut3pyUOLIRccCZnKmFqSu+l4kBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086465; c=relaxed/simple;
	bh=F9GujSQevTps620iz5oy1DgxTU+gjz6ekhGD5dTuULw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sptw+oxarauFl3Hbi/QPohhZeazbGj5OueBJm+K4A/0nYJeUY45ODUqoC5BZRuOi4+Oc6aNtfRUMSXvoekhSYvpNIpdpjcpGmW/deza4bbNj9kDSJZGJU1x4BHzfFxZF1u5KzapJhhCC3iMf2uLRGZqdVYxbCWpLdQir8tT9cvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kz4kq+hR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kz4kq+hR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786086461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIyHmJyMzYdv73lqmdakFUzxNfZrooLWlQlqB6xyRlY=;
	b=Kz4kq+hRl3xWMjVVAWYARrWuoidgldjxtWm3PWUYNL0oHSRrTcfV/MXxVrrDcONtGpEp2x
	bnOJzhuFgR0wzDNWayZkIyMeHmryRoRetq+6XKLCt3uQ9Pxv9rB+g5fF/BMEZMxmbI4JZz
	+jTq7PKcwB+sSiFnpnFFF01P2suGRKQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-i-ZIHYNJNMGEys58Q3UdQQ-1; Fri,
 07 Aug 2026 03:07:38 -0400
X-MC-Unique: i-ZIHYNJNMGEys58Q3UdQQ-1
X-Mimecast-MFC-AGG-ID: i-ZIHYNJNMGEys58Q3UdQQ_1786086457
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 360B91956095;
	Fri,  7 Aug 2026 07:07:37 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 19E52195DF92;
	Fri,  7 Aug 2026 07:07:34 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/10] crypto: safexcel - Rework cleanup of sensitive structs in safexcel_aead_setkey
Date: Fri,  7 Aug 2026 09:06:36 +0200
Message-ID: <20260807070651.228713-10-thuth@redhat.com>
In-Reply-To: <20260807070651.228713-1-thuth@redhat.com>
References: <20260807070651.228713-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

The crypto_authenc_keys structure only contains pointers to keys, but not
the key data itself. So explicitly clearing the structure at the end of
safexcel_aead_setkey() is not really necessary, see Eric's recommendation
here:

 https://lore.kernel.org/linux-crypto/20260804185402.GD2904385@google.com/

On the other hand, the crypto_aes_ctx might contain sensitive information,
so this structure should be cleaned up at the end instead. Do this
now via the new __cleanup(aes_zeroize_ctx) marker.

Since __cleanup() and gotos should not be mixed in the same function,
replace the gotos with early return statements, which is fine now that
we dropped the memzero_explicit(&keys, sizeof(keys)) at the end.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .../crypto/inside-secure/safexcel_cipher.c    | 27 ++++++++-----------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index a8349b684693e..c331d81ac8a2d 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -407,17 +407,17 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_authenc_keys keys;
-	struct crypto_aes_ctx aes;
-	int err = -EINVAL, i;
+	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
+	int err, i;
 	const char *alg;
 
 	if (unlikely(crypto_authenc_extractkeys(&keys, key, len)))
-		goto badkey;
+		return -EINVAL;
 
 	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD) {
 		/* Must have at least space for the nonce here */
 		if (unlikely(keys.enckeylen < CTR_RFC3686_NONCE_SIZE))
-			goto badkey;
+			return -EINVAL;
 		/* last 4 bytes of key are the nonce! */
 		ctx->nonce = *(u32 *)(keys.enckey + keys.enckeylen -
 				      CTR_RFC3686_NONCE_SIZE);
@@ -430,25 +430,25 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	case SAFEXCEL_DES:
 		err = verify_aead_des_key(ctfm, keys.enckey, keys.enckeylen);
 		if (unlikely(err))
-			goto badkey;
+			return err;
 		break;
 	case SAFEXCEL_3DES:
 		err = verify_aead_des3_key(ctfm, keys.enckey, keys.enckeylen);
 		if (unlikely(err))
-			goto badkey;
+			return err;
 		break;
 	case SAFEXCEL_AES:
 		err = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
 		if (unlikely(err))
-			goto badkey;
+			return err;
 		break;
 	case SAFEXCEL_SM4:
 		if (unlikely(keys.enckeylen != SM4_KEY_SIZE))
-			goto badkey;
+			return -EINVAL;
 		break;
 	default:
 		dev_err(priv->dev, "aead: unsupported cipher algorithm\n");
-		goto badkey;
+		return -EINVAL;
 	}
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
@@ -486,24 +486,19 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 		break;
 	default:
 		dev_err(priv->dev, "aead: unsupported hash algorithm\n");
-		goto badkey;
+		return -EINVAL;
 	}
 
 	if (safexcel_hmac_setkey(&ctx->base, keys.authkey, keys.authkeylen,
 				 alg, ctx->state_sz))
-		goto badkey;
+		return -EINVAL;
 
 	/* Now copy the keys into the context */
 	for (i = 0; i < keys.enckeylen / sizeof(u32); i++)
 		ctx->key[i] = cpu_to_le32(((u32 *)keys.enckey)[i]);
 	ctx->key_len = keys.enckeylen;
 
-	memzero_explicit(&keys, sizeof(keys));
 	return 0;
-
-badkey:
-	memzero_explicit(&keys, sizeof(keys));
-	return err;
 }
 
 static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
-- 
2.55.0

