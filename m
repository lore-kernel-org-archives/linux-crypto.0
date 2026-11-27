Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795752274;
	b=o+0VM9FLpvfUZk00twbclt/EFwnrQhV0saAZc26otRFiZ9kIu7JEErZTemHWNHhBTYYb
	 az9a7VXv/zarHyaNH2h3U+oGmRe8lFn+TPFlVuxDdGB8I4QenZNFECosFIPUGCiwJYY22
	 GH+jg+wDrhe9Wz5JrHaxjhBwGx2DhvnSygBEUqQYyJP7C8bhxNAg5jxA/xH5Rt8mJSv9K
	 5gBuGVxQNAq7gafN8yrPqbXwo1AIC6xpqcGdZB1c76IJ+Ps5JLwdk6Uj4j5IvFs+/6/GS
	 E2F9+lntbVl89ILCPOrGTlr4oDPTboNpbvagBIeunDaMAk+r353W5ZHoxpmcogdbRGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752274;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bjFZEkx7eeY7bqPzAbqCKatK0hc/idmgxkzT4Zy9IdI=;
	b=3OY/vn/lQZMOhw77gKQ/kzrLFL2fhuIZ3UdqMGPdnM/6MClsLo6CEH6TvNajJm7dkOfd
	 tESSoHZW+anLC1/aSFauIHrELy6n5nYVyVKZi/4YxylV1sWvxUIYVIlOi65+1RBgijmCC
	 2LGRbBa5q6WSDGRLIZHL+2OOXYs9THvaaDcdY51UPOhzHQPiYwbB4ERVW1GBgn2Ihm7wv
	 w8wCgxhKjY/+1WT7ErG/PRDByTDnI7SRPrqCQ9VURDyNvXnbM4+jjPOV7P8I8Wf6nsU8B
	 iXlupwUFyHBHz2aeScIsoeXhZuJ9rS/Zz/9lI3+O3BQB0vebRqnup9WcOy5ASLZWnGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OlyqYVYC;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB02C606A32A
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:04:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB02C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OlyqYVYC
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2f06ff94acfso34200315ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 20:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795752273; x=1796357073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bjFZEkx7eeY7bqPzAbqCKatK0hc/idmgxkzT4Zy9IdI=;
        b=OlyqYVYC4iScWoQlkcCY5rzd3MuW+wpe+RrknPDAq/yjmibUf6A8RVw00vpwDD2jzi
         Xg/t6YnGEvzwz2qMlDm0z8zVOLDIJ+Zw8upelACoOhUrhK6Nc752Vy+vKUHFZv2Hd/GQ
         7AOtTjHO4EkNgc4wuhexZ29moaLCZQiG1K25zh3THb+FP6xKNKKWmnEeSwO6JUOXdNkD
         PQuqn9rNfhbVTfgkeRtkrqZsV0V2ZhnSfqBly7tkORFnsh/IhA6OykhUZNKqtGs4Vuru
         g9ROvx8ngWkuVir7TwYehzu0d1aFp/PnKyc2bkqq5vTxbcbq5uR7IpNq8NuJjLiYxWwY
         CaBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752273; x=1796357073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bjFZEkx7eeY7bqPzAbqCKatK0hc/idmgxkzT4Zy9IdI=;
        b=0zfvnQ9+N3jDP4LgIeIr+wt14qYm/j7f6sc6TsDKsx1oF10q9g/nd4n3q91QbGjm2s
         xIjHi5CTMgOSKI7XoTHqAidfs4Yf2SapweQBMb4foSgLmSz1LOmX7xJN+AT1B2GoTS/l
         NBLwpjrdWYuUJRmL4CVHR8DdY8tEglcAmLgWGNI9klWf/m9lG+mTVfFeNp4Uzo8FS86z
         td6uea2ZNoVryZlZo4NmtUOkbMeJWFXjfDXCvWqJWiU6PCjxOPIZcM56Fgc9DZv57EiV
         +tnlcybCBu02BqF9F/5xiZ7ObskGqKvFrjwOTd7xu8F/FhQR6hDXofz8RaA5IHqipL3d
         wHRA==
X-Gm-Message-State: APuU4Z9QORRoE42VXl0NpIJ3xWNWoxAhCyXk43daIQeiPxwaCsTNtNG3
	3p6fWjIHRg4w+xKPdrof1SJgAujDxeR0cBwBPDIP7R/2tNzZXnZz2lGwsfQjUQ==
X-Gm-Gg: AZFdTZeLtnYCevvzgUxzLnGI22SQWDwEEkq7RGBFs4mp98M3PAzBCkM2kzrkN78iHMP
	eKB5KJ/BT64lZ7L9BYxKuNQ8TnU/EMn2//Al/JqP/0977086J/G3vKyCftY3o9edIUEi7kc9Rm5
	qMTTi8s/YjlFe9IInA9qTOEj8xFR4YU3/SWKgSt6JkmPTpEWlEe/kVgR8EvTLpPFUTlFa3DBQto
	k9KmdEWjoSaeWz647hBHdvHV1AIFUXFAaPxnA5Yajs++QpzICOfcQTGBwqtd+fMODU8FFw7tsNg
	C2ztQkmftydBRkXkTVDoU4wbUUF9ocU0/cKeGvOtb+TcuAzzExR4EqRPve9hXaCJoHJGuZPjBU7
	kY6KiCA8kyPQZKjXW7AU3Dhcc24ImvzaFyt5eDcnPwNnp2MfTFYEh86t0F4nB9sMIOBr178YDyy
	7q3gtBewBT0Uv0q8axNH0G9Fqczi1Fa4RYEGjabI4bqnE81w77wpkr1ArHtvkPqTM9Iu1HD7TEA
	hx9LV2yISg8MFTJM4lzMw71r1+3TFlr7eVcD0o3BsU1uEi3rzzLCIcl6F50PwavrHRJeFo3GDBb
	Zepat/VWm/tPBhTDvMLcwB9QSTfsck3116pnzlPIRgiwLRW+RdLInIKwVg9PeFNmZijRqijD+Mf
	Tg3ZHxHGOqC2qxAKcWd9iGwPmsMB3BidghXUUqiBT20FnUOsU4ZuaYZDaO5inaf0/c243YpujQ0
	BP2Q==
X-Received: by 2002:a17:90b:1e4f:b0:3b5:35eb:5e88 with SMTP id 98e67ed59e1d1-3b535eb5fadmr923029a91.27.1795752272918;
        Thu, 26 Nov 2026 20:04:32 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b457a58d04sm15090652a91.0.2026.11.26.20.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:04:31 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Hsiao <jhsiao@amcc.com>,
	Rosen Penev <rosenp@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 3/8] crypto: amcc - allocate all algorithm wrappers before registering
Date: Thu, 26 Nov 2026 20:04:18 -0800
Message-ID: <20261127040423.1023233-4-rosenp@gmail.com>
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

crypto4xx_register_alg() allocates a wrapper and registers it, one
algorithm at a time. If an allocation fails partway, it returns
-ENOMEM with the earlier algorithms still registered. The probe error
path does not unregister them, but devres frees the device context and
descriptor rings they point to. The next request on one of them,
typically its own self-test, is a use-after-free. With an allocation
failure injected at the third algorithm on an APM82181:

  crypto4xx 400180000.crypto: probe with driver crypto4xx failed with error -12
  BUG: Unable to handle kernel data access on write at 0xe4fbd028
  NIP [e4f9bb4c] crypto4xx_build_pd+0x174/0x83c [crypto4xx]
  [c188b7b0] [e4f9c888] crypto4xx_ctr_crypt+0xc8/0x188 [crypto4xx]
  [c188b9e0] [c035f098] test_skcipher_vec_cfg+0x3bc/0x890

Unregistering the algorithms on that path is not safe either: with
self-tests enabled, a test that started on registration may still hold
the algorithm and have requests on the engine.

Allocate every wrapper first and only then register, so an allocation
failure leaves nothing registered.

Fixes: 049359d65527 ("crypto: amcc - Add crypt4xx driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index e28e836c4f35..6131fd6c0607 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -982,15 +982,32 @@ static int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
 				  struct crypto4xx_alg_common *crypto_alg,
 				  int array_size)
 {
-	struct crypto4xx_alg *alg;
+	struct crypto4xx_alg **algs, *alg;
 	int i;
 	int rc = 0;
 
+	/*
+	 * Allocate every wrapper before registering anything: a registered
+	 * algorithm may already have its self-test running on the engine,
+	 * so it cannot simply be unregistered again if a later allocation
+	 * fails.
+	 */
+	algs = kzalloc_objs(*algs, array_size);
+	if (!algs)
+		return -ENOMEM;
+
 	for (i = 0; i < array_size; i++) {
-		alg = kzalloc_obj(struct crypto4xx_alg);
-		if (!alg)
+		algs[i] = kzalloc_obj(*algs[i]);
+		if (!algs[i]) {
+			while (i--)
+				kfree(algs[i]);
+			kfree(algs);
 			return -ENOMEM;
+		}
+	}
 
+	for (i = 0; i < array_size; i++) {
+		alg = algs[i];
 		alg->alg = crypto_alg[i];
 		alg->dev = sec_dev;
 
@@ -1010,6 +1027,7 @@ static int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
 			list_add_tail(&alg->entry, &sec_dev->alg_list);
 	}
 
+	kfree(algs);
 	return 0;
 }
 
-- 
2.56.1

