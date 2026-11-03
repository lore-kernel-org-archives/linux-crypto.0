Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793688028;
	b=e3kHxZSfEgS883nQ9BtXImySCjZyx2VI+F4/nlRsG9kd00KCRbUiwgV6rADw9njgtG51
	 RGtWXL04p2HrpGczRTJwl4NAeLxmYcFV9oymytkVArF7F5Cr3goXSA2I8OihJEpIUOIRG
	 Z3RUi1zixpJsz/0/tWj22KYF+xQNgm6YIxM9XYOsHzlZwoif0Mmi34JhtTIITehUyvmrr
	 rdR2tm0C3n7+XKwNVdq9bJ04HH5KAY7aYRGVJKAaw5aQppFbT0WnGdszZwfCwp5RxFXhi
	 Zoh4mTh2jB4yD+5Sv2C+t8C7HqbEqWxqe0BgmzghxZAJs/fbPed1ko0cBzXQRyZ8xMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793688028;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=qwgGBP6Md9p7J4/jGlwlz49uLEe/dOav/vGFCZDz5ig=;
	b=kCZGsQW/zuQgQNkSjShM+/q9s1kO9JOoodZ6TpyKnh5W+5xTcw/5uPlebq9YpvJZzZmo
	 zVbeDb8278sriXHWO5wckz28wBc0TskIFuGvkl0vpkidtth6MCHrW/qZ4zFXjsdqiy1qj
	 63iW9jlE3ohsWlSJ5nr3Pe0MYyveZ2nE5YKOrwiyMXAK9QhUhqM+QXSYXXL/WsKK3gZnM
	 ag2PHCBl4dzswrE1uf3TiK/Q2QlP8rYOjLuX8aiZTSepXts3V3dDzbexjZaW9fOIiuHng
	 gGvDIdWFBTjQHQqlyVi7X02ikLw+F9Vrqs4aYGIYzItxVt/JtZ9KhrC0/9MgKdmsshA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9431606A324;
	Tue,  3 Nov 2026 06:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9431606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowADn8JHVgelq7nQ5AA--.180S2;
	Tue, 03 Nov 2026 14:40:21 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: atenart@kernel.org,
	herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: safexcel - Unwind SHA3 initialization if HMAC setup fails
Date: Tue,  3 Nov 2026 06:40:30 +0000
Message-Id: <20261103064030.1034291-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowADn8JHVgelq7nQ5AA--.180S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw17GFy7ZF48Jw47CF1Utrb_yoW8CryDpF
	s3JrZ8try5JF4xWa42qF4ruFyru3ySkry3Cws7Cw1fZ39xZ3W8KryayFy8uF9rAFy8Ja4Y
	qrs7Kw43Cr15Z37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbkhL5
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgUAA2rpWmWBuAAAsF

safexcel_hmac_sha3_cra_init() first initializes the SHA3 context, which
allocates an ahash fallback. If allocating the shash transform or its
descriptor fails afterwards, that fallback is not released. The crypto
core does not invoke cra_exit after cra_init returns an error.

Call safexcel_sha3_cra_exit() on these failure paths to release the
resources acquired by safexcel_sha3_cra_init().

Fixes: 6c1c09b3dd0c ("crypto: inside-secure - Add HMAC-SHA3 family of authentication algorithms")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 8f107da66685..308a1992a738 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2649,17 +2649,24 @@ static int safexcel_hmac_sha3_cra_init(struct crypto_tfm *tfm, const char *alg)
 
 	/* Allocate precalc basic digest implementation */
 	ctx->shpre = crypto_alloc_shash(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(ctx->shpre))
-		return PTR_ERR(ctx->shpre);
+	if (IS_ERR(ctx->shpre)) {
+		ret = PTR_ERR(ctx->shpre);
+		goto err_sha3;
+	}
 
 	ctx->shdesc = kmalloc(sizeof(*ctx->shdesc) +
 			      crypto_shash_descsize(ctx->shpre), GFP_KERNEL);
 	if (!ctx->shdesc) {
 		crypto_free_shash(ctx->shpre);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_sha3;
 	}
 	ctx->shdesc->tfm = ctx->shpre;
 	return 0;
+
+err_sha3:
+	safexcel_sha3_cra_exit(tfm);
+	return ret;
 }
 
 static void safexcel_hmac_sha3_cra_exit(struct crypto_tfm *tfm)
-- 
2.34.1

