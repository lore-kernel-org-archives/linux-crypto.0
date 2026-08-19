Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B0544DB85
	for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2026 10:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787137130; cv=none; b=HiMU1kzfT5l0VPUeg33TaIDsWDU3Gss6/XiwjUU0v1bH1G909cg5PjtZ6TJp/FJT3npPSvOPKHlpW+y6Yzy5VZl5vfXM4m+5JE+BLfxHg+m7TZR9BW1EIjyHYWwOaB1TTD/MaWJ1Tm3nOrsAN+VD8GAmIh4y1/IVABMD/5wy6uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787137130; c=relaxed/simple;
	bh=OW8C4JDKbtZ4alPmS5kPd8XZ7KeJHEIYdqguUWd7gk8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=asTTHi5SLV1wylPAbmPTTr4okG1/XQJX7NSiPIqxSASv9FJ9mWi/DmUWjqoVIfZGudGgHzO8spRdjlz/mFZ1KmMU+q2JX5uZB5qUEwNzoxp9mqlvZuayOH8cDMN4sX9ehL4hyLDI9A4BtXMW796xTekBKUb3rRylqKSFkWQMJds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S1k0fgHI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1k0fgHI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787137128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R9yLjdVL8g+b/DViNWYt+VwS6QdMyKs9cO13v/1bubE=;
	b=S1k0fgHIZZVg+sM4JfvV8fXiAlVV8clv0mYVBpQW0xtJsxpx3MgOcYlsAdL+BJ8ttRWZ9o
	/AZhZqHuP7nqe0A7sCjrDY2y6i7dPj2RiKpAGK09klkUsOQWQT0WoMwtHW5dZxp0rU69O0
	bFpqgWcBKBKtpTooJ3+m7UheHlr5OmE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-380-lm-pHNXDOyaWSPuFg0NNgg-1; Wed,
 19 Aug 2026 06:58:44 -0400
X-MC-Unique: lm-pHNXDOyaWSPuFg0NNgg-1
X-Mimecast-MFC-AGG-ID: lm-pHNXDOyaWSPuFg0NNgg_1787137122
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6865319560AF;
	Wed, 19 Aug 2026 10:58:42 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.32.254])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4801E180034C;
	Wed, 19 Aug 2026 10:58:37 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	Pascal van Leeuwen <pascalvanl@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: inside-secure - Zeroize temporary arrays on stack with sensitive data
Date: Wed, 19 Aug 2026 12:58:36 +0200
Message-ID: <20260819105836.156251-1-thuth@redhat.com>
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
 v2: Added "Fixes:" and "Reported-by:" tags
 
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

