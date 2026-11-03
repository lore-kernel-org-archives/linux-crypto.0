Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793687928;
	b=InG9aZqHu8oB4zAnEerIKXfS8dznw6JAFZgIAvPdcv1+mFjt7rmroesdckZ56cC8+I69
	 qeCxcYqwkfqCBDPtnA0drO6lvLkEt/IS3Q5p85qM8o2+8zx5afQUd5ZWuKnf1yz1JaVDQ
	 wE7nC1i1rwvse1m+Tp1preUX5sh6KdS9oPdx+sK77Q0Wwv8IkcAwQWQ42R3KNCtzqUIuM
	 PBE6xNVY/rQgKaBvMfWGC0ul8lfK/kvZCVrllRrC96L+d1r0Lm3uQrqNvUzptW9OjrAQ3
	 KqoJGqJEw89XT6j+GjewcJU3lEIEMbO7kJtnhtwpovDEEF4ZMUymOc6vCod0FK+ic3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793687928;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=sTSdkkz2vrjceniKIFMADF9L4UGSrsp9KNEr/A42Nmc=;
	b=4a3C5uhvPy6faFfL/siJytWaiE2PtTtsAR6OWRWTdOnypMVsqDRJg4hpp+BiN++hQyl9
	 ZkeUwgDVKblerfBlEbYvZeGhjGkD66eY53oRzrMMEZHtvpsW+F3ddMbBWzYYpto3Imz+p
	 dWKi9iHWDWxdt473TUM8rcJ4jqNlhXh/lEdiM17Wrz8tpY9EbH1pXmKC1yIz2oAEZOWjO
	 I5SFeuPc7A+FEEYLLrvdX5eQ8ceb/jMjoKbI7QOtDQ7V+B7En4bpgv6At52snVKe8d+l7
	 bZ90hCpzss7bbwanX9ZAKo84kpc8wvGLspTO3exuYE/NSfPOZRbi9FRJNaf39KUZmOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30ED606A324;
	Tue,  3 Nov 2026 06:38:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C30ED606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAHGJlxgelqZHE5AA--.148S2;
	Tue, 03 Nov 2026 14:38:41 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: ayush.sawal@chelsio.com,
	herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: chcr - Free fallback transforms when device assignment fails
Date: Tue,  3 Nov 2026 06:38:50 +0000
Message-Id: <20261103063850.1033008-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:rQCowAAHGJlxgelqZHE5AA--.148S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJw48WrW7Jr18KFWkJFy3twb_yoW5tr4DpF
	4Yk3yvyrWrJFn7KayxJrs5G3s8Ga9ayay7KrWFkw1FkwnIvrWkWF9rX3yjvF15tFW8JFW5
	Zr4vyas8Wr1DJaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbkhL5
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwQAA2rpWtl+-AAAsC

The skcipher, RFC3686 and AEAD initialization callbacks allocate their
fallback transforms before calling chcr_device_init(). If no active
device can be assigned, chcr_device_init() returns -ENXIO and the
fallback is leaked. The crypto core does not invoke the algorithm's
exit callback after its initialization callback fails.

Free the fallback transform before returning the device assignment
error in each of these initialization callbacks.

Fixes: b8fd1f4170e7 ("crypto: chcr - Add ctr mode and process large sg entries for cipher")
Fixes: 0e93708dabc0 ("crypto: chcr - Add fallback for AEAD algos")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/chelsio/chcr_algo.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index e2f2b2a6200e..fd4720fa50a9 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1439,6 +1439,7 @@ static int chcr_init_tfm(struct crypto_skcipher *tfm)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct chcr_context *ctx = crypto_skcipher_ctx(tfm);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
+	int ret;
 
 	ablkctx->sw_cipher = crypto_alloc_skcipher(alg->base.cra_name, 0,
 				CRYPTO_ALG_NEED_FALLBACK);
@@ -1450,7 +1451,11 @@ static int chcr_init_tfm(struct crypto_skcipher *tfm)
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct chcr_skcipher_req_ctx) +
 					 crypto_skcipher_reqsize(ablkctx->sw_cipher));
 
-	return chcr_device_init(ctx);
+	ret = chcr_device_init(ctx);
+	if (ret)
+		crypto_free_skcipher(ablkctx->sw_cipher);
+
+	return ret;
 }
 
 static int chcr_rfc3686_init(struct crypto_skcipher *tfm)
@@ -1458,6 +1463,7 @@ static int chcr_rfc3686_init(struct crypto_skcipher *tfm)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct chcr_context *ctx = crypto_skcipher_ctx(tfm);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
+	int ret;
 
 	/*RFC3686 initialises IV counter value to 1, rfc3686(ctr(aes))
 	 * cannot be used as fallback in chcr_handle_cipher_response
@@ -1470,7 +1476,11 @@ static int chcr_rfc3686_init(struct crypto_skcipher *tfm)
 	}
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct chcr_skcipher_req_ctx) +
 				    crypto_skcipher_reqsize(ablkctx->sw_cipher));
-	return chcr_device_init(ctx);
+	ret = chcr_device_init(ctx);
+	if (ret)
+		crypto_free_skcipher(ablkctx->sw_cipher);
+
+	return ret;
 }
 
 
@@ -3164,6 +3174,7 @@ static int chcr_aead_cra_init(struct crypto_aead *tfm)
 {
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(a_ctx(tfm));
 	struct aead_alg *alg = crypto_aead_alg(tfm);
+	int ret;
 
 	aeadctx->sw_cipher = crypto_alloc_aead(alg->base.cra_name, 0,
 					       CRYPTO_ALG_NEED_FALLBACK |
@@ -3174,7 +3185,11 @@ static int chcr_aead_cra_init(struct crypto_aead *tfm)
 		tfm, max(sizeof(struct chcr_aead_reqctx),
 			 sizeof(struct aead_request) +
 			 crypto_aead_reqsize(aeadctx->sw_cipher)));
-	return chcr_device_init(a_ctx(tfm));
+	ret = chcr_device_init(a_ctx(tfm));
+	if (ret)
+		crypto_free_aead(aeadctx->sw_cipher);
+
+	return ret;
 }
 
 static void chcr_aead_cra_exit(struct crypto_aead *tfm)
-- 
2.34.1

