Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795752282;
	b=0gWljiwxJTbiE1jlcYohB1KLTV00WKdoE6Ux7sAxmR+va/qD9yj0H7UR7iqlU+QYlkFj
	 FGwSErK0EVM/8tIyusuRoVo7Ug5xufkhk3GF2TEhg+ZyA+2c5r4GFfHbetX8U5xbS4oDV
	 ZpZeEOyZHoJ82o0YJL03hgCWWSYC2vo4NLnF2hc2MLm1A5hK69e3+k31LcwARSKDqFvEO
	 zjc3n2At/cY+cektetq7nHn1bIT+A5VkMETe2ce/4aN+SlC8NV+++xmtTNMS1o3wekqiX
	 BokIaCP1uCv2RsBfCwAFdHasg37E+7ez2HojOIB/tlCa2H/U5buA7jARtOlj90X2yCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752282;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5iz2xhznaAm+hKwrtltzMwrPAKmj1lljaoJiLwWoVUc=;
	b=Ti5uXN/pHHn9ASiYcke9PxJoS7doYNnXANj9AOwjFuu+jBdsMljKMr3vk09SzA4lMDFz
	 ajSxU8c+c0n6TWYK+YT3YlncLc6ktHoKyQrguTAUjbtdS7Qv/mBG7QDVxn+mNXHXg+QHq
	 rgfpf+3N1VNvo75ntYQ8RBwuCnhvM4s+ILjc5+1r8lUevsuSdkf3KxUYSy8Gd1WNBQIem
	 /gQZJ2G+8+oVsFOnOx0a+e0Uw4ATgY2Pz4lQSegC+zM5nZyP1OhIOMYWN1kTmESTaQtrH
	 YvtIwjOmr0o96vC3qNSpgb2tyjHWLykpMmHY/zoPjX6wSEhJSrM7cn9INdJNv6Y6svw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NMEsIsZO;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7922606A321
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:04:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7922606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NMEsIsZO
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cddc597d062so4583044a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 20:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795752281; x=1796357081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5iz2xhznaAm+hKwrtltzMwrPAKmj1lljaoJiLwWoVUc=;
        b=NMEsIsZOoXtmq8SIwpYCwiafBwE6gpa6ZXsRZe/pnuJEN1xHN8TOp/hKNXFMgQvfxW
         QLCft4GpkKZLs0VoG27pAt50DLOqKfwsRjX8aI/HVipr5xOSDb2VH78DDz1xTXRZLwoQ
         0U1pDde/naDDDC+4CJ1iWGgn0tVCy5ky7ldGn1kOj/Ommzdsm7gvytNJnaPDyT1vdZkW
         lge01LLbK6AemE3l6mvM9mW+rva+23q5w0eCEgn759xIeR126FV+Qi9U+o1WybRdslqn
         bmvrG01iizswkH1dUDagaZSuZG4+O28DrZOGjKziDu7pqdofE2e0kza0MlPO7/tGEftj
         XKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752281; x=1796357081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5iz2xhznaAm+hKwrtltzMwrPAKmj1lljaoJiLwWoVUc=;
        b=JcfzBZo0e9LEPKpkQHzhWGXaQob+ePBzdfa8ANS2ix/FLMjDaaBRDBNmI6xAMT3ib3
         OEnQDICWuofjzDku3NilPkIidl5iRtF2ibZV3DxwVWki4hM6HITxPQIsQeLC4MlKl5i8
         4JPsbq3jXIvQuoJzLHvzevuTQ4K35byAjC5r9SbBwM6vlO2VM4Gou4S+0jUeadzdjVxv
         DYF/V9s+r2aILmWtPCx8NqkSAcpld8u3VzFIOTirczV+HP0pXYms/99PfFJ2DTd7Bc7k
         rQkPOswwAgPo988+vgHrgRoWn4OveA1bVLozImbaCmbS7UcMgAW4asAs9/0TXD8qh/Oj
         2TpQ==
X-Gm-Message-State: APuU4Z/ZB6D10OqBaCXFTTvXhKJQ0gmmz8i1MKdSwiVR9entiTvJQOQF
	Vn8eIrZSCRoqy7ypLKSuhG9kvFs+Y9gmegra17jlCLp2nvEGISdEdjIlNRdYEQ==
X-Gm-Gg: AZFdTZePHfNR8I1RqPn9z8MqP73j+z2OnV9KFPpe1qd2E76bwL6zwEXrElW2kExSRJP
	l03FqdjIQ4OVA7NkuYn8Huix5oOHZhKVOA2ul1Mzw3wKTAdqx59z8O781dDuhMIM0CC147smuhD
	qzHS3xIZb4wrluhUi5Ol902DHQDFgB5i7jbDl6+yaR5Wd1LuCNxwgq9stH/RX3PMhLT880eZ6p7
	Fd36fQLDfZ8VNUmVw2CzCuH7BDODvr3iedEYU4Jnv1lC2uhyaAkP+N6NGXVWAz3jz+3CRpHnhPv
	5HQvVQbh0skRkbTb+GUoBmTiUNeeNCVzb2ra4RwWw/4zP0KPYy6ojTRI28Xb0YPrchLNaTvknSE
	P6VhqId+au8Dd+8Igex3I9i5E3Dkq1asBxRfaqIp0V8SOMJljhY0nzUDddvqwX2VJ5e78OLXcvG
	3DGpMhwy9fg6dxmiE/OW12IutMukbiKNC2XhIXhU/XliWfu5FDYcGmJfRRskiGAGPQw/xAnlL5K
	VKHh/eLX4zd2DCQeXogBvznbd/aJfqodYFXp6ruyQcl8TxtwmIeNxTtrbEm4NKH5x2/0438NnMe
	pAIY/vQlDlIGx2tizut9vzLYIZ828IQsdBUiOx8hOZ8HshxPYnEriqXmxe3cFhwAc4HBi5auh94
	iMzuZeYQa9Q1zkH65tRnOCVtBiNNsYGn725p7T4j9Vc/7wwWSH2pHw85dByrthyT4rGEYi+FbtE
	ZfBQ==
X-Received: by 2002:a17:90a:d2cf:b0:3b4:1714:5bfc with SMTP id 98e67ed59e1d1-3b41c9b9dc1mr23166479a91.61.1795752281266;
        Thu, 26 Nov 2026 20:04:41 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b457a58d04sm15090652a91.0.2026.11.26.20.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:04:39 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Hsiao <jhsiao@amcc.com>,
	Rosen Penev <rosenp@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 8/8] crypto: amcc - wipe the SA key material when freeing it
Date: Thu, 26 Nov 2026 20:04:23 -0800
Message-ID: <20261127040423.1023233-9-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127040423.1023233-1-rosenp@gmail.com>
References: <20261127040423.1023233-1-rosenp@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The inbound and outbound SAs of a transform hold the AES key, and for
GCM the hash key derived from it, but crypto4xx_free_sa() releases
them with plain kfree(). The key stays in freed memory both on rekey
and when the transform is destroyed.

Free them with kfree_sensitive() instead.

Fixes: 049359d65527 ("crypto: amcc - Add crypt4xx driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 8b070b7edcb6..bb078b524994 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -150,9 +150,9 @@ int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size)
 
 void crypto4xx_free_sa(struct crypto4xx_ctx *ctx)
 {
-	kfree(ctx->sa_in);
+	kfree_sensitive(ctx->sa_in);
 	ctx->sa_in = NULL;
-	kfree(ctx->sa_out);
+	kfree_sensitive(ctx->sa_out);
 	ctx->sa_out = NULL;
 	ctx->sa_len = 0;
 }
-- 
2.56.1

