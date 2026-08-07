Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4539F380FC7
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 07:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086453; cv=none; b=F7ApXa6ixPjqV5j1LMbqyKJe0Vuz1PaIbQAlGErM3ik2VZF3HQHN+gtWqpQpSnQo9+q1wc2Ss8hvCRRxaj3D6qpjc5BeVkLW8wESL9hjOa+d8xEhRXPh+L7ZGiaQcnb3XPl5Wp/VBDhDGJ9g7lMP+9bNkTaeOlA/0wiatRRZE2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086453; c=relaxed/simple;
	bh=b5aZNIDCHkvfoWtjbjEcQ7aD9yQG5oyRD+0JfQ4XMl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chYr8Y2MY1h7weUvx36ASI45VCCfMGiPbJkR9XFjO00H/KLNeFAUv5Xhtzd3cgdDqN4IIUwAcCZpFas+2iWWSAmCMCnyb0OloXJOqlS+ytDHONxAqDHBMebfM/4EStY8hQg2GESZvPJ6TfISnuJ3nB2IE0hjAQx6SCiqSgaeGkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KWU66cug; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KWU66cug"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786086451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vqj916x7IWEPwY8/O5oc6WAr80znZJ+nk/7CTdbfDAQ=;
	b=KWU66cugitdIrQwveKwaDLu9UNgw6AG+i6KOksBe2AgW2yaodeocrvEKf5x7v7BDgE1mEo
	I/WK+eSPwb1wH9aoZcefES04IZPzge38lCMUCIq6UCNTmelL3l275Zibxkrf8au9Kxmdd1
	rgEZoOjkDnhL+pKn6lY3gELNs6Xs2pU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-yuNjvHM6PTa9_E8jKbh68g-1; Fri,
 07 Aug 2026 03:07:27 -0400
X-MC-Unique: yuNjvHM6PTa9_E8jKbh68g-1
X-Mimecast-MFC-AGG-ID: yuNjvHM6PTa9_E8jKbh68g_1786086446
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C186A1800471;
	Fri,  7 Aug 2026 07:07:24 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0DF841956094;
	Fri,  7 Aug 2026 07:07:20 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 06/10] crypto: arm/aes-neonbs - clear the crypto_aes_ctx when done
Date: Fri,  7 Aug 2026 09:06:33 +0200
Message-ID: <20260807070651.228713-7-thuth@redhat.com>
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

Clear the crypto_aes_ctx structure via __cleanup(aes_zeroize_ctx) when
we're done with it to avoid that key data could leak on the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/arm/crypto/aes-neonbs-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index c49ddafc54f34..f0c8bfd2ac8fc 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -60,7 +60,7 @@ static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
 	struct aesbs_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_aes_ctx rk;
+	struct crypto_aes_ctx rk __cleanup(aes_zeroize_ctx);
 	int err;
 
 	err = aes_expandkey(&rk, in_key, key_len);
-- 
2.55.0

