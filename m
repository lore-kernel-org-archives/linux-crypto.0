Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793687385;
	b=alMj4qNMB0aVwQPkQl2X1f15qEzfIeIF1/t3OERQAcFjc8u4cyh98b/9lMosL2ygPpoK
	 yjDM0uJPSrvMBTm5jAytrGDRRWi+hBf+1NtR5qHFsK5tFF4Dn0174QmoariBuOvOm1xBu
	 Co6ggQKXuzH/WlroouRQBolf/64+7itnQ6LOmMF7KqT8kNh9IQ0xwowiNjlnLyCtx5nvJ
	 j1ogbmvEawD+n0nOWYgBmS8/QxOsusnNCp/QImmts3CYTTFn9BZmzynZu4Yxtszp3S24h
	 TQmu6s4M6O4M6qOb0x+v4lBn8EsNSgOjN1OKxxpWLbvE/6oxTq0W3UbpEAcNtJRVyew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793687385;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=6/6xUUOjwtL1FwuXpKSTtDVBiayCB2HCPjgP1T7L0+g=;
	b=lp0hRafTEgWZQ3FRvjy7kegcpPPUoYo3w9Nn1ncewKRm0VZvxxxMc9VnBSRcHxL3A3Pv
	 9wWYdy+h2t0+NFrmJX0B5NevRWIOs9pVeIww+QkZwjpdt9eoS+sRI1BbI2hVKsZ7L/IrF
	 p0QcLdxLX+W2I/xiZKDqp3LMs8nkDRbrpiw8Yvwt7tO1tAJiOh9hBT0RBiEFve09JqO5J
	 pd2IYjZ6fttWUwKPmYMwo/hTQiM+WvVTLl2fH2G9cGgYJNkavhjFfOd+BBuWpPpzPxjps
	 SSCEWDw0FIuAg4Hh6QsX94sZ7VmES7ZYTf3mN/zrm0lUELMVGz39wrQEsBCP6WVkp+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51CB606A32C;
	Tue,  3 Nov 2026 06:29:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E51CB606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowACXoZJNf+lqD145AA--.419S2;
	Tue, 03 Nov 2026 14:29:33 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: clabbe@baylibre.com,
	herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linusw@kernel.org,
	kaloz@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: ixp4xx - Free the fallback cipher if context initialization fails
Date: Tue,  3 Nov 2026 06:29:42 +0000
Message-Id: <20261103062942.1021598-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowACXoZJNf+lqD145AA--.419S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw17Gw43Wr43tw1kAFW7CFg_yoW8CF4rpF
	WrCrWkKrWDJF17Ca4xJFWrCFyfJ3yrAayakw48G340kFn3urZ5GFW2yr4jkrZ5JFyrGFyx
	AF4vvryUJwnrXaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUogAwDUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRUAA2rpWfV5NwAAs+

init_tfm_ablk() allocates a fallback skcipher before calling init_tfm().
If allocating either security association context fails, init_tfm()
returns an error and the fallback is left allocated. The crypto core
does not call the algorithm exit callback after a failed initialization,
so exit_tfm_ablk() cannot release it.

Free the fallback cipher when init_tfm() fails. The security association
contexts are already unwound by init_tfm().

Fixes: dfb098d692ea ("crypto: ixp4xx - fallback when having more than one SG")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index 33e8e887a415..6af50a01c96f 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -635,6 +635,7 @@ static int init_tfm_ablk(struct crypto_skcipher *tfm)
 	struct crypto_tfm *ctfm = crypto_skcipher_tfm(tfm);
 	struct ixp_ctx *ctx = crypto_tfm_ctx(ctfm);
 	const char *name = crypto_tfm_alg_name(ctfm);
+	int ret;
 
 	ctx->fallback_tfm = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->fallback_tfm)) {
@@ -649,7 +650,11 @@ static int init_tfm_ablk(struct crypto_skcipher *tfm)
 		 );
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct ablk_ctx) + crypto_skcipher_reqsize(ctx->fallback_tfm));
-	return init_tfm(crypto_skcipher_tfm(tfm));
+	ret = init_tfm(crypto_skcipher_tfm(tfm));
+	if (ret)
+		crypto_free_skcipher(ctx->fallback_tfm);
+
+	return ret;
 }
 
 static int init_tfm_aead(struct crypto_aead *tfm)
-- 
2.34.1

