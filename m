Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C28393DE9
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755809348; cv=none; b=VRjjFd0+f2sShtgFT1fK91BqYMu+I0d14wxyFAIFCWbuSa0zn2lWzFJzEAw54ULMn4BI1/jPMRGlDYOqX6uFLnSuaSCWMZ3CfKLRFwxLWV0v8LVu/pA8182R+7sAYTWE1Ixhyh0EanZ9Hg0LLk8gU7j+sA+lPV2EhLhLfuKZIgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755809348; c=relaxed/simple;
	bh=+nnKNQmue4LNk2OyjtRe3k47W/E6JYvWz/99GuAeFyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukOslDCFc/Yz32ubJJTpQ3QjIIYOc0f5NcWnHRijzeBG/mpNN2phIv1Yxf/BOHvgIs/QVA/P1AEG9bPK1jM3LWe8k0GZUfrNPPz//onIzubYqJ89LQLvCe2SGyv7LWCcojGdWfP7D5R0nBbVbm97QVdaPQn2+qj3VmRrmqQWFbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h+XpgWxF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h+XpgWxF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755809346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8r0AdniSkpUyDQzUhdxUS1CDdb6tGNCWglBSYFRm2/I=;
	b=h+XpgWxFLZHqpU7+WEnc/p7ZTs0kcvwwsuV41gMYis45+E2ktiazPOlkNCqQx2AuV0SMgq
	abB7d0s+JEfxcYA/n1JWuzisj/r+9mwlnpf2Aua9IMpvSCKMNK9QIpjFKUXU1ZyNT8KMxV
	2Gb22GPBIR5cqzHSL+0AknlUsAjtJdY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450-4rEoukLGMlOEPPtxn-9yRw-1; Thu,
 21 Aug 2025 16:48:59 -0400
X-MC-Unique: 4rEoukLGMlOEPPtxn-9yRw-1
X-Mimecast-MFC-AGG-ID: 4rEoukLGMlOEPPtxn-9yRw_1755809338
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6BCA18003FC;
	Thu, 21 Aug 2025 20:48:57 +0000 (UTC)
Received: from my-developer-toolbox-latest.redhat.com (unknown [10.2.16.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 10CBE1977687;
	Thu, 21 Aug 2025 20:48:54 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: linux-nvme@lists.infradead.org,
	Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/2] nvme-auth: use hkdf_expand_label()
Date: Thu, 21 Aug 2025 13:48:16 -0700
Message-ID: <20250821204816.2091293-3-cleech@redhat.com>
In-Reply-To: <20250821204816.2091293-1-cleech@redhat.com>
References: <20250821204816.2091293-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

When generating keying material during an authentication transaction
(secure channel concatenation), the HKDF-Expand-Label function is part
of the specified key derivation process.

The current open-coded implementation misses the length prefix
requirements on the HkdfLabel label and context variable-length vectors
(RFC 8446 Section 3.4).

Instead, use the hkdf_expand_label() function.

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/nvme/common/auth.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index c6eae8e6b6f99..1f51fbebd9fac 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -768,10 +768,10 @@ int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
 {
 	struct crypto_shash *hmac_tfm;
 	const char *hmac_name;
-	const char *psk_prefix = "tls13 nvme-tls-psk";
+	const char *label = "nvme-tls-psk";
 	static const char default_salt[HKDF_MAX_HASHLEN];
-	size_t info_len, prk_len;
-	char *info;
+	size_t prk_len;
+	const char *ctx;
 	unsigned char *prk, *tls_key;
 	int ret;
 
@@ -811,36 +811,29 @@ int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
 	if (ret)
 		goto out_free_prk;
 
-	/*
-	 * 2 additional bytes for the length field from HDKF-Expand-Label,
-	 * 2 additional bytes for the HMAC ID, and one byte for the space
-	 * separator.
-	 */
-	info_len = strlen(psk_digest) + strlen(psk_prefix) + 5;
-	info = kzalloc(info_len + 1, GFP_KERNEL);
-	if (!info) {
+	ctx = kasprintf(GFP_KERNEL, "%02d %s", hmac_id, psk_digest);
+	if (!ctx) {
 		ret = -ENOMEM;
 		goto out_free_prk;
 	}
 
-	put_unaligned_be16(psk_len, info);
-	memcpy(info + 2, psk_prefix, strlen(psk_prefix));
-	sprintf(info + 2 + strlen(psk_prefix), "%02d %s", hmac_id, psk_digest);
-
 	tls_key = kzalloc(psk_len, GFP_KERNEL);
 	if (!tls_key) {
 		ret = -ENOMEM;
-		goto out_free_info;
+		goto out_free_ctx;
 	}
-	ret = hkdf_expand(hmac_tfm, info, info_len, tls_key, psk_len);
+	ret = hkdf_expand_label(hmac_tfm,
+				label, strlen(label),
+				ctx, strlen(ctx),
+				tls_key, psk_len);
 	if (ret) {
 		kfree(tls_key);
-		goto out_free_info;
+		goto out_free_ctx;
 	}
 	*ret_psk = tls_key;
 
-out_free_info:
-	kfree(info);
+out_free_ctx:
+	kfree(ctx);
 out_free_prk:
 	kfree(prk);
 out_free_shash:
-- 
2.50.1

