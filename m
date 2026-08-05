Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AD944C51E
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 11:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785931090; cv=none; b=pkqWPfo8Wf54RPa+pux6ZPMrVVZKF9T34/SqSuUHTh0vhr6yLRQdY3t1/O+A9jqvCLWbaL0Ixw9OIMlb7UUE+PvbhylZYci4DX+J7nzRVc0XisA6p20LG11431GOl8pofTC2KZor/WGxa8TNor2n8ISmxJ3Mdg2+ogOPda2wju8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785931090; c=relaxed/simple;
	bh=vzZOFKBz/vS1L4OiBZo1G1l389pu1nVzeo0UGyLy+sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwSofNeoujhq/aRlUW4qixt1CG+jJlQG0h0wf5Y6P7QKF2YF/9HKFXkn0QDRfJNYWv232tNgc1RY2kqGc++/Vxhb9rAWpgGj6liroFp2xaXsPVjxZhAi67k8dwH2Ll1YDG0BgE0m1GKpB0C7tcjSL27VO+QU/FsQZuYz70bCGN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WVVmpk/c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WVVmpk/c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785931088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5/FP2iona05c4GGFGjhMtKYGShx3GCcZ6CaDckfTOnk=;
	b=WVVmpk/ci+bpTOfjclm4bvILUn+zIprHKIarbvFROfqUC2PZxTt3pQ6I3Y3DQx3INsem7P
	An9rqoOoFBA74zAyumuPAsoUm1JcqcP5vPcv6USt+Y2DMVYJy8LbmFap/bxEvXFvgGjcBP
	wEHDYbZ2mxH9c25Nsx1AnLORoBIn87E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679--16dSFeXN4GJtlujppaAxg-1; Wed,
 05 Aug 2026 07:58:05 -0400
X-MC-Unique: -16dSFeXN4GJtlujppaAxg-1
X-Mimecast-MFC-AGG-ID: -16dSFeXN4GJtlujppaAxg_1785931084
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA9F519560B4;
	Wed,  5 Aug 2026 11:58:03 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.202])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7710230002EA;
	Wed,  5 Aug 2026 11:58:00 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 03/10] crypto: inside-secure/eip93 - clear the crypto_aes_ctx when done
Date: Wed,  5 Aug 2026 13:57:41 +0200
Message-ID: <20260805115749.392672-4-thuth@redhat.com>
In-Reply-To: <20260805115749.392672-1-thuth@redhat.com>
References: <20260805115749.392672-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

Clear the crypto_aes_ctx structure via __cleanup(aes_zeroize_ctx)
when we're done with it to avoid that key data could leak on the
stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/inside-secure/eip93/eip93-aead.c   | 2 +-
 drivers/crypto/inside-secure/eip93/eip93-cipher.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-aead.c b/drivers/crypto/inside-secure/eip93/eip93-aead.c
index 2bbd0af7b0e0e..973cebef5df37 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-aead.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-aead.c
@@ -92,7 +92,7 @@ static int eip93_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_authenc_keys keys;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
 	struct sa_record *sa_record = ctx->sa_record;
 	u32 nonce = 0;
 	int ret;
diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.c b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
index 4dd7ab7503e85..7051b99ee6235 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
@@ -116,7 +116,7 @@ static int eip93_skcipher_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 	}
 
 	if (flags & EIP93_ALG_AES) {
-		struct crypto_aes_ctx aes;
+		struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
 
 		ctx->blksize = AES_BLOCK_SIZE;
 		ret = aes_expandkey(&aes, key, keylen);
-- 
2.55.0

