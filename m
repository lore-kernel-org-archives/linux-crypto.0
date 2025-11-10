Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E11414A60C;
	Mon, 10 Nov 2025 06:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762757716; cv=none; b=FL/fXZjr+PreKEDJjDiQdONO8XpEW71z9Eh0geAhuscBNSG8JzM5zO6hLNJ94oRqQxSTFgdTNkQXduWRy/cKFB4Lh054mj44Q8PTsFHT1MDaqaMpuUbSNwYBodrIwR+z+a2n7aWswqIEFYpsmnlx/xj/9xRj2QgmTmcXULQggNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762757716; c=relaxed/simple;
	bh=vl24YyeTi1eeULzWrbNkRM3cgOR7pIDchtUMwWFoL0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=btIC1jlmdtHf5sElfQ4ZI+5q7zLS/D2gwtLRWoSvVWzSDIcTalW1EB5c0mN4OxMOdXAp2akKLiWEh2QC92I9kFGCAwTN8/XIxLy7reYCGd8NWU8KUp2NAvDOMoOPdRQYrOOOJWBWVNhulNZCbwbuK8caGTXOiHFql4TCAdwFmdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-03 (Coremail) with SMTP id rQCowABH19kxjBFpPGk0AA--.10014S2;
	Mon, 10 Nov 2025 14:54:42 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: jiajie.ho@starfivetech.com,
	william.qiu@starfivetech.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] crypto: starfive: Correctly handle return of sg_nents_for_len
Date: Mon, 10 Nov 2025 14:54:38 +0800
Message-ID: <20251110065438.898-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABH19kxjBFpPGk0AA--.10014S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CF4kWw1kKF4DAryxAw1fWFg_yoW8Ww1UpF
	4YyFZYyrW5Jw17CF95JrnYkr1rJ3sakr12gFW0g34ayr15Xa4kZ34fCrW0qFnrAFZ7Gw18
	KFZF9w15AFs8ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgoCA2kRRWaDEAABsE

The return value of sg_nents_for_len was assigned to an unsigned long
in starfive_hash_digest, causing negative error codes to be converted
to large positive integers.

Add error checking for sg_nents_for_len and return immediately on
failure to prevent potential buffer overflows.

Fixes: 7883d1b28a2b ("crypto: starfive - Add hash and HMAC support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/crypto/starfive/jh7110-hash.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/starfive/jh7110-hash.c b/drivers/crypto/starfive/jh7110-hash.c
index 6cfe0238f615..66a8b04c0a55 100644
--- a/drivers/crypto/starfive/jh7110-hash.c
+++ b/drivers/crypto/starfive/jh7110-hash.c
@@ -326,6 +326,7 @@ static int starfive_hash_digest(struct ahash_request *req)
 	struct starfive_cryp_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct starfive_cryp_request_ctx *rctx = ahash_request_ctx(req);
 	struct starfive_cryp_dev *cryp = ctx->cryp;
+	int sg_len;
 
 	memset(rctx, 0, sizeof(struct starfive_cryp_request_ctx));
 
@@ -334,7 +335,10 @@ static int starfive_hash_digest(struct ahash_request *req)
 	rctx->in_sg = req->src;
 	rctx->blksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	rctx->digsize = crypto_ahash_digestsize(tfm);
-	rctx->in_sg_len = sg_nents_for_len(rctx->in_sg, rctx->total);
+	sg_len = sg_nents_for_len(rctx->in_sg, rctx->total);
+	if (sg_len < 0)
+		return sg_len;
+	rctx->in_sg_len = sg_len;
 	ctx->rctx = rctx;
 
 	return crypto_transfer_hash_request_to_engine(cryp->engine, req);
-- 
2.50.1.windows.1

