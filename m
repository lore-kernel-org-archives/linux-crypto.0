Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A2647AF6D
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629034; cv=none; b=F2sUDJ4Yx0qtteaHTcWwkZ/sm6KrrTioOmnSi6ksoxqxlcbzbFhZ7zR5PpKJM1Q0dOE0MCHdvJmN1ks+KoXo9j9VFWaUNqlUMxbrLc1NwHIgUs6YrGe7kKuQaZeiCX9OI5CLBo7WXfI03GhH9pCfF11Fne7b+N1SPBbYxEnhFh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629034; c=relaxed/simple;
	bh=UFJphz2HCaus0zGusjKTqSYg8G+KwkOhX1aebVlqLgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PafK/7RImkyHZgE9OTgcNtQP357qo4IbWkqy9Nv1wphBDinFwy5+GjosyvB6v88yGym0WdXLw6UVc6+2J19sK/Hw8mIruEdU1gDDG0+7Naycq8zweJ9s9CcGL9ASiA3rnE2NTrX6Kb7CR70xMTtrBLTeXYSq0YxLAiDYYoRUyUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vu1onGFz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vu1onGFz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OIj4h+dI3DPEf3hvqsFZKfrcm+ChB0/2xtHLuuFb0+A=;
	b=Vu1onGFzhdrg/Vc9SzLo5rvYLgpov03t0vPaCoHYb82Evjs1Hb+eUXzaM9rEwK3kYig1wt
	2Oosd4pG+Z/zrq+XtD1nrr1nyvXS7usTbi4IEtKtLxhxsBzWu6tWf43fNaRn4k3XLZoVZN
	4tkgnTRUb6LdnL330ObE8HfeMAdJPdg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-116-tAT7j24OMFiwWZVvRHw8lg-1; Thu,
 13 Aug 2026 09:50:25 -0400
X-MC-Unique: tAT7j24OMFiwWZVvRHw8lg-1
X-Mimecast-MFC-AGG-ID: tAT7j24OMFiwWZVvRHw8lg_1786629024
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 344F91800655;
	Thu, 13 Aug 2026 13:50:24 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7585C1800348;
	Thu, 13 Aug 2026 13:50:21 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: x86@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] lib/crypto: md5: Use hmac_md5_zeroize_ctx() instead of memzero_explicit()
Date: Thu, 13 Aug 2026 15:49:45 +0200
Message-ID: <20260813134953.979481-8-thuth@redhat.com>
In-Reply-To: <20260813134953.979481-1-thuth@redhat.com>
References: <20260813134953.979481-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

It's only cosmetics, but since we have the new hmac_md5_zeroize_ctx()
function anyway, we can also use it here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/crypto/md5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/md5.c b/lib/crypto/md5.c
index 3d2b017a0525a..a8ee57600012d 100644
--- a/lib/crypto/md5.c
+++ b/lib/crypto/md5.c
@@ -271,7 +271,7 @@ void hmac_md5_final(struct hmac_md5_ctx *ctx, u8 out[MD5_DIGEST_SIZE])
 	cpu_to_le32_array(ctx->ostate.h, ARRAY_SIZE(ctx->ostate.h));
 	memcpy(out, ctx->ostate.h, MD5_DIGEST_SIZE);
 
-	memzero_explicit(ctx, sizeof(*ctx));
+	hmac_md5_zeroize_ctx(ctx);
 }
 EXPORT_SYMBOL_GPL(hmac_md5_final);
 
-- 
2.55.0

