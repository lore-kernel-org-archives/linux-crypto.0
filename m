Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC33815B140;
	Mon, 19 Aug 2024 08:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724057348; cv=none; b=dVcq5D0atkw8YcLdt7n6WHzqJJFKIGAPODQV82dTiT2ovrmA7uWl6LTXduC7tYZAPoy4fVtUGY5kAK7/9FbgzTnXxjIp2ZLOMW2D1OnkeUV8r2S4aGngKpT+SXuTBFDqfJNRvwU5Ryx4f/KGB20hxXFpy0LUCpgd5ZO9TbLiS94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724057348; c=relaxed/simple;
	bh=3YlNtsaDCcsAcHaVTN0CfYd2K6RSzN6+m+xD9anLX84=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iPdLJ3tZNB39xsrMexvSUXqbZ406g9WCrJ+vCjEQh91aATw2t7Wl8lpAQC4FQP8EgYwUv81Q/D9RkJSScUzIkqpqupylMtxqsZFN5fRS3f0fGuK690Gh9jWfnl0+ux/Q6W2GOZ3FcbD4xcmT819PVDrxJj4Xi8Q0/kD7pCs4HCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from icess-ProLiant-DL380-Gen10.. (unknown [183.174.60.14])
	by APP-03 (Coremail) with SMTP id rQCowACnhRjsBsNmhUISCA--.42807S2;
	Mon, 19 Aug 2024 16:48:51 +0800 (CST)
From: Ma Ke <make24@iscas.ac.cn>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	j-keerthy@ti.com,
	t-kristo@ti.com,
	akpm@linux-foundation.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ma Ke <make24@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH RESEND] crypto: sa2ul - fix memory leak in sa_cra_init_aead()
Date: Mon, 19 Aug 2024 16:48:43 +0800
Message-Id: <20240819084843.1012289-1-make24@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACnhRjsBsNmhUISCA--.42807S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tw18KFykGF1xtF45Jw43Jrb_yoW8uw4fpF
	s5uFWjyry5JFn3GFWftws5Gr15X3yS93yagayxGwn3ZrnF9r1v9FW7CFy0vF17GF1kGr17
	XFZrJr45Zr1UG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUQvtAUUUUU=
X-CM-SenderInfo: ppdnvj2u6l2u1dvotugofq/

Currently the resource allocated by crypto_alloc_shash() is not freed in
case crypto_alloc_aead() fails, resulting in memory leak.

Add crypto_free_shash() to fix it.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
---
 drivers/crypto/sa2ul.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 461eca40e878..b5af621f7f17 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1740,7 +1740,8 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 	ctx->shash = crypto_alloc_shash(hash, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->shash)) {
 		dev_err(sa_k3_dev, "base driver %s couldn't be loaded\n", hash);
-		return PTR_ERR(ctx->shash);
+		ret = PTR_ERR(ctx->shash);
+		goto err_free_shash;
 	}
 
 	ctx->fallback.aead = crypto_alloc_aead(fallback, 0,
@@ -1749,7 +1750,8 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 	if (IS_ERR(ctx->fallback.aead)) {
 		dev_err(sa_k3_dev, "fallback driver %s couldn't be loaded\n",
 			fallback);
-		return PTR_ERR(ctx->fallback.aead);
+		ret = PTR_ERR(ctx->fallback.aead);
+		goto err_free_shash;
 	}
 
 	crypto_aead_set_reqsize(tfm, sizeof(struct aead_request) +
@@ -1757,19 +1759,23 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 
 	ret = sa_init_ctx_info(&ctx->enc, data);
 	if (ret)
-		return ret;
+		goto err_free_shash;
 
 	ret = sa_init_ctx_info(&ctx->dec, data);
-	if (ret) {
-		sa_free_ctx_info(&ctx->enc, data);
-		return ret;
-	}
+	if (ret)
+		goto err_free_ctx_info;
 
 	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 
 	return ret;
+
+err_free_ctx_info:
+	sa_free_ctx_info(&ctx->enc, data);
+err_free_shash:
+	crypto_free_shash(ctx->shash);
+	return ret;
 }
 
 static int sa_cra_init_aead_sha1(struct crypto_aead *tfm)
-- 
2.25.1

