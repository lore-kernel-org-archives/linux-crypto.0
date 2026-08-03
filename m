Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE0337756B
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 09:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750317; cv=none; b=WYB0pZhfXtyvEtjGCjrl3/YTYiKXCVD6gfTfYWFf2vv5zPJruSLzFF20m0X/8XZuCYb9qQr0TLdDDfALxJhEtBnFmoMs/FKK30PHn8yvOLaAkzGoyjQ1d71wLcQjCZDrlZCyC8L6m+9tVML/Eit5XyjMply4NBecFnbOkPvnpcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750317; c=relaxed/simple;
	bh=Y1ZQ2Z65qWpaCYiK8JIwqN04PJl0FQWPEWmvnfjs9xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA8lrR6LOOe8BbKKNS5jFGwlUzJk4cSVz+kSLDnnT5dKlxksXJha1P4wtcpR3juPQmLw7NN4mXe22Va9+u0BPLvPE6UPdk89VvG4wuS/MOkakqISLDnjyAeIeO8TbBxdag1YCqUK461hlsCwxZFN6fEsjvPPG7eoG68Kx0XPJ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U3YCOo/C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U3YCOo/C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785750313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tgRIZfjAKRcjwzlyDkDI9fWoNOZ3iNTbySLuYW1QpTA=;
	b=U3YCOo/CD3gtrs2yLJmwIKQEF1ZLsZRlJJFKzI4zg+4moq390YX33l20p5vJcTCK9wQzMT
	eP01owVnvyRv9rCSzdsEHJ5EnlVDnRtUfjp6Jcv60l6u3UfEqO3k2+InG6/VyyHu9JSW6L
	92gNuDusfvJrZNicOrib2IG12icjEZg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-mikQaVWmOWil4AOAeWIsyg-1; Mon,
 03 Aug 2026 05:45:10 -0400
X-MC-Unique: mikQaVWmOWil4AOAeWIsyg-1
X-Mimecast-MFC-AGG-ID: mikQaVWmOWil4AOAeWIsyg_1785750309
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C09511800348;
	Mon,  3 Aug 2026 09:45:08 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.213])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2AB891956087;
	Mon,  3 Aug 2026 09:45:03 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org
Cc: Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 6/9] crypto: arm/aes-neonbs - clear the crypto_aes_ctx when done
Date: Mon,  3 Aug 2026 11:44:25 +0200
Message-ID: <20260803094432.70505-7-thuth@redhat.com>
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
 arch/arm/crypto/aes-neonbs-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index c49ddafc54f34..2bb21f7b06a8e 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -60,7 +60,7 @@ static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
 	struct aesbs_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_aes_ctx rk;
+	struct crypto_aes_ctx rk __cleanup(aes_clear_ctx);
 	int err;
 
 	err = aes_expandkey(&rk, in_key, key_len);
-- 
2.55.0

