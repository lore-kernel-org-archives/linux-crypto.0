Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAEB416852
	for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2026 12:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787574257; cv=none; b=LoTZD1MMv2dGE5gQyeJa2AVoXD9nCSKJDR1wPvSSjf9zCb46AiJ73h2h7CKk//sKIWBwzuzRdB7eT5GscHYDkABhOR6ko6n8+s1hDGHarVtOgjwkZHyJFMg6FGsLK3uuTW9wNdM5ofXKGtyW6OZ4PjuPgrO9DT6xWqUPd2OTMRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787574257; c=relaxed/simple;
	bh=dPgg2k5vxcjur3m6hKCZs84iQMtWE8b9xRUilboM3W4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lmvVlePARlZB+Ne4DjJI0CeOir3TQWAUZLtQvw7LOq2nO/QRupxNJtLFV7mnAQ7VplICiPONW++BfEWxHuXv3lGh5KSI1k8gtKLJhxqJsRRZ7LS7XzdM0FZD5u8PxYmPnv4u58NxBirn5PPhiPCHeEMXpMciF61aBpADDB/YYXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iVgTlgh+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iVgTlgh+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787574253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=abvLEBybSRIKRrth/tk8LZ7F6x5kg7UkwY+u9550D+A=;
	b=iVgTlgh+uhT2TSfQ34qAP+Q6vpBJLipvVGxnHjcvUYdHwkdvCvbQRhsQRubBPGuxyLpphH
	Dyuzo9p1JGcxi1qZbn1BdQsrpGch2lINR4D+0LFvOqggveOWaQB1e+2v/ORXGSMd9aec+6
	WGbU3Q/RnJgJsbD+k1Um2XVjTxvtf8U=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-306-zDH8xp9DMjSKxc5vISpv9w-1; Mon,
 24 Aug 2026 08:24:09 -0400
X-MC-Unique: zDH8xp9DMjSKxc5vISpv9w-1
X-Mimecast-MFC-AGG-ID: zDH8xp9DMjSKxc5vISpv9w_1787574248
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F3EB194510D;
	Mon, 24 Aug 2026 12:24:07 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3479D1955F07;
	Mon, 24 Aug 2026 12:24:04 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qat - Don't use -EFAULT as error code during setkey()
Date: Mon, 24 Aug 2026 14:24:02 +0200
Message-ID: <20260824122403.630026-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

EFAULT means "Bad Address", it's the error code that is meant to
be returned when userspace provided the kerknel with a pointer to
memory that is not part of its address space. However, the QAT driver
abuses this error code during its setkey() function to signal that
there was something wrong with the selected algorithm, which is just
confusing.

The best choice for an error code would likely have been EINVAL here,
but qat_alg_aead_init_sessions() seems to make an effort to use this
for another error case already, so there is likely the desire to
distinguish the different errors here. Thus use EOPNOTSUPP as a
replacement now, so qat_alg_aead_init_sessions() continues to return
two different error codes depending on what went wrong.

Anyway, instead of hard-coding the error codes in the function
qat_alg_aead_init_sessions() again, let's also simply rather pass
the error code from the called functions up to the caller instead,
this way we can also get rid of the need to call memzero_explicit()
here three times.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .../crypto/intel/qat/qat_common/qat_algs.c    | 31 +++++++++----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index 91663805d9e60..91da9cad1d89a 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -135,7 +135,7 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 		return 0;
 	}
 	default:
-		return -EFAULT;
+		return -EOPNOTSUPP;
 	}
 }
 
@@ -186,7 +186,7 @@ static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
 		cpu_to_be32(ctx->hash_blocksize);
 
 	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen))
-		return -EFAULT;
+		return -EOPNOTSUPP;
 
 	/* Request setup */
 	qat_alg_init_common_hdr(header);
@@ -273,7 +273,7 @@ static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 		cpu_to_be32(ctx->hash_blocksize);
 
 	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen))
-		return -EFAULT;
+		return -EOPNOTSUPP;
 
 	/* Request setup */
 	qat_alg_init_common_hdr(header);
@@ -472,28 +472,25 @@ static int qat_alg_aead_init_sessions(struct crypto_aead *tfm, const u8 *key,
 				      unsigned int keylen,  int mode)
 {
 	struct crypto_authenc_keys keys;
-	int alg;
-
-	if (crypto_authenc_extractkeys(&keys, key, keylen))
-		goto bad_key;
+	int alg, ret;
 
-	if (qat_alg_validate_key(keys.enckeylen, &alg, mode))
-		goto bad_key;
+	ret = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (ret)
+		goto error;
 
-	if (qat_alg_aead_init_enc_session(tfm, alg, &keys, mode))
+	ret = qat_alg_validate_key(keys.enckeylen, &alg, mode);
+	if (ret)
 		goto error;
 
-	if (qat_alg_aead_init_dec_session(tfm, alg, &keys, mode))
+	ret = qat_alg_aead_init_enc_session(tfm, alg, &keys, mode);
+	if (ret)
 		goto error;
 
-	memzero_explicit(&keys, sizeof(keys));
-	return 0;
-bad_key:
-	memzero_explicit(&keys, sizeof(keys));
-	return -EINVAL;
+	ret = qat_alg_aead_init_dec_session(tfm, alg, &keys, mode);
+
 error:
 	memzero_explicit(&keys, sizeof(keys));
-	return -EFAULT;
+	return ret;
 }
 
 static int qat_alg_skcipher_init_sessions(struct qat_alg_skcipher_ctx *ctx,
-- 
2.55.0

