Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C883B71DA
	for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787152738; cv=none; b=tLpY2gH4amtc0jM5IUpFQwRhaVa/pgRBPPRTFs5xk8zhQm+vIgAgf2UBHslHRi+44JIahq/V9J1Ey67c7OYtsghGhVtTWUESNBPFSCHpLLhmZ2VBXI2L1NySwV9uxmheqrLjSRxKAF2jn+AVL0Vkvv1GWmWhkhntQ5WzIPbae9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787152738; c=relaxed/simple;
	bh=W8gzSLxgUXRIg6ES2X+k7feBydOAh39+wT9krLYMe50=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JuFoalPudjo0ol0oAl02mNWl0iHcpEBMNXj+arzSwrtsEfaamVYD1UhuJb/rc9QQSvoj3RAoPU0/Cug1pIwYdg7HltoLc7dCOXI6+Pmaw0zNBpQ7NXQC9aPIk+ndnsE2U30uAkmhcXau6n0rj6bmw5qNQBAb1M+I+jWmWTdJQQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KjrjMV0V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KjrjMV0V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787152736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KylyHVRk0/+cOPTn3a7mM1KmHvNvxTQmuNWA3JJOQno=;
	b=KjrjMV0ViJtxXbzRvwEvYE87b3jRX9tBqlrsYFlh28MwBEsIG8YZKjFeCU0Ynul/Vjsb2K
	lY8EAsRqGNQ8HVR5rgSiiIYbFw5khBrejnlM8+apq6Gn1kC7hQT6RCdaVfDidMuVyGoFC/
	QCGW95gBREh3nv/59oVU729jrLOn3tc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-iM8BvbaxOn-MrfDGErR3Bg-1; Wed,
 19 Aug 2026 11:18:52 -0400
X-MC-Unique: iM8BvbaxOn-MrfDGErR3Bg-1
X-Mimecast-MFC-AGG-ID: iM8BvbaxOn-MrfDGErR3Bg_1787152731
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4344B1800644;
	Wed, 19 Aug 2026 15:18:51 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.32.254])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 670BF18005BB;
	Wed, 19 Aug 2026 15:18:46 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	Pascal van Leeuwen <pascalvanl@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] crypto: inside-secure - Zeroize temporary arrays on stack with sensitive data
Date: Wed, 19 Aug 2026 17:18:45 +0200
Message-ID: <20260819151845.835768-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

key_tmp[] in safexcel_xcbcmac_setkey() and consts[] / _const[] in
safexcel_cmac_setkey() contain crypto key material that should not
get exposed to the outside once the function is done. Scrub the
arrays with memzero_explicit() to avoid that the data could leak
via the stack.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260813134953.979481-1-thuth%40redhat.com
Fixes: 38f21b4bab11f ("crypto: inside-secure - Added support for the AES XCBC ahash")
Fixes: 7a627db9cafdb ("crypto: inside-secure - Added support for the AES-CMAC ahash")
Acked-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 v3: Fixed white space damage

 drivers/crypto/inside-secure/safexcel_hash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 3402e570d045c..7c68118fbb05c 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1993,6 +1993,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	ret = aes_prepareenckey(ctx->aes,
 				(u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
 				AES_MIN_KEY_SIZE);
+	memzero_explicit(key_tmp, sizeof(key_tmp));
 	if (ret)
 		return ret;
 
@@ -2104,6 +2105,8 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	}
 	ctx->cbcmac = false;
 
+	memzero_explicit(consts, sizeof(consts));
+	memzero_explicit(_const, sizeof(_const));
 	return 0;
 }
 
-- 
2.55.0

