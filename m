Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF6837756B
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 09:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750322; cv=none; b=V5uBuTyWYlooaoB9iZIHQ7lGoOKJ4l2e9xEyRLeA2NUDjhRzsl/ecP90twSLcIUBgPiJB20+QksvggHWqAtgkmZhnQ8000DgYYLIJ4ZnVvOxfDz4zbvS7hxh0fgbrbIaxo1688xPQBk8tOIzNthm3lbKjEsWIepghExcShei5+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750322; c=relaxed/simple;
	bh=dHiWsuZcN9yBemaC9Mcs84SKEAwk+m6rbldjlEmvX8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZm5cfSNpQM90y+VkpVe1i3j5giqwIeKZM40PqDGtuALp44dRiE6u02/+SyvGGKnXyPX1XN6GDixWDwH1p9uk2A9bjCnP/ge8ibFYlpa+lqqCpwm5J99/oxNhivmboJV49WgdLnwrVzHEu6wY38LFqWo5Ak2CU4/PWDWkk3+2Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GS2r1T8L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GS2r1T8L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785750319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kqzqzXsKLyD/JykJa41z6gjBOK5AcAPVYWltBpH9JdQ=;
	b=GS2r1T8L9Ayhzy1YftsWlCQYIkBu9BGMVqQOKjp+xQMbwhkUGEkBQUNo/TnI2GRa3x8L7f
	B8cms3nL0LcFzDwU2UWOY5PB2w40qf94K81FvUFtzib8lPVJ6j8+Zq7BDLNIS75QE92y9m
	q9J+NAm8sy89OVzETbNKYzNc3WburbY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-451-GnM8WsrJNJayiuqXF46ESw-1; Mon,
 03 Aug 2026 05:45:15 -0400
X-MC-Unique: GnM8WsrJNJayiuqXF46ESw-1
X-Mimecast-MFC-AGG-ID: GnM8WsrJNJayiuqXF46ESw_1785750314
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9A741800473;
	Mon,  3 Aug 2026 09:45:13 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.213])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C07931956087;
	Mon,  3 Aug 2026 09:45:09 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 7/9] crypto: arm64/aes-neonbs - clear the crypto_aes_ctx when done
Date: Mon,  3 Aug 2026 11:44:26 +0200
Message-ID: <20260803094432.70505-8-thuth@redhat.com>
In-Reply-To: <20260803094432.70505-1-thuth@redhat.com>
References: <20260803094432.70505-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

Clear the crypto_aes_ctx structure via __cleanup(aes_clear_ctx) when
we're done with it to avoid that key data could leak on the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/arm64/crypto/aes-neonbs-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 5bcbac9798931..4c0f1bbd03fee 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -247,7 +247,7 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
 	struct aesbs_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_aes_ctx rk;
+	struct crypto_aes_ctx rk __cleanup(aes_clear_ctx);
 	int err;
 
 	err = xts_verify_key(tfm, in_key, key_len);
-- 
2.55.0

