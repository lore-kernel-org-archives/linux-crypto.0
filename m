Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97803AA9F4
	for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 08:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786696632; cv=none; b=La6N2cUD7Hu1bVaUukkiQLDUdeU3QxVcOlGv6fV2cPSSTPEaYx1smGMkDoN8DsvwmoxDI9qd21bIVYqdhlaNj2YokCChwwtA7MYDg0ylmDwivx5IdFLCAiX4b2eRS48vKQL7YLBK/8u0nxzYdXQDRcnMW1NhToCuD4XWhoV7uGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786696632; c=relaxed/simple;
	bh=jOoGKYtPzZBmJ4GpQuVNqJq1TN+TdKqL5Vn0GGXMxPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p3EQnBhDAXICwxTvHVtiwzR9zDPrtvlHz2hM7/+U49vZlIeSFQ7dJio0su+6310r/YXIH0K1xRzOcgbaPZYmd/sghzlqGyp2yZjFG+E9dC20Ns0wWIhQtJTh2cfiT8Il3adMwJATVzSAo/k7QQTY/65egQ5pUk8a1ambZqXblPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bFnZjB6R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bFnZjB6R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786696621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HqdTSi5AjPQGrWLAzKmiczmwiOW3iMCRJfHHj7QRQZc=;
	b=bFnZjB6RKYdvFXc39Zw1kfpdi4pGHjcsSBk4fJU3nFOz/OrFme4b5zgtZ7/G2Mckor3P2v
	LmQAsXSipzAMjsx99pUrvZGemtLw2uImySkzA12ThMBYoc/Q5J9RbdlQ0HDJK3x9ZMr+vi
	gztSZgOkckwVByeYkhvj1B8QzPX9gZs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-392-6q6mfqqJPMiuHyoQFPxqXw-1; Fri,
 14 Aug 2026 04:36:57 -0400
X-MC-Unique: 6q6mfqqJPMiuHyoQFPxqXw-1
X-Mimecast-MFC-AGG-ID: 6q6mfqqJPMiuHyoQFPxqXw_1786696615
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFD381955F7E;
	Fri, 14 Aug 2026 08:36:55 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 74402423;
	Fri, 14 Aug 2026 08:36:53 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: inside-secure - Zeroize temporary arrays on stack with sensitive data
Date: Fri, 14 Aug 2026 10:36:51 +0200
Message-ID: <20260814083651.59535-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

This issue has been found by the Sashiko bot while reviewing another
patch: key_tmp[] in safexcel_xcbcmac_setkey() and consts[] / _const[]
in safexcel_cmac_setkey() contain crypto key material that should not
get exposed to the outside once the function is done. Scrub the arrays
with memzero_explicit() to avoid that the data could leak via the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 3402e570d045c..1ae6fbec31298 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1993,6 +1993,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	ret = aes_prepareenckey(ctx->aes,
 				(u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
 				AES_MIN_KEY_SIZE);
+	memzero_explicit(key_tmp, sizeof(key_tmp));
 	if (ret)
 		return ret;
 
@@ -2104,6 +2105,9 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	}
 	ctx->cbcmac = false;
 
+
+	memzero_explicit(consts, sizeof(consts));
+	memzero_explicit(_const, sizeof(_const));
 	return 0;
 }
 
-- 
2.55.0

