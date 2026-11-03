Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793688166;
	b=g3k8T2x/i4TFy3pisaCPgkC4kXz7kJ7fBguo+ho+MtmK6AtYf8zGR1ZqWhqSWVNPFDor
	 Ox7cqICh1w1kPal+aMUqEU9vX+efDDX+uLeyomTKu3WlJ7Y5ECXTDnM4ZesBLEC5bP+nF
	 MUqP5o1B/kpJQkI8Vl66f/ZozVKwf/CUnVydi1jYKoiRcgVZdG272+3pNrdy1FQrSctFP
	 8O+BHzDSqT3jqp1dBSnjqv8lRFaaCyE90BqeoAkiFp43+imu+zMv+JWaFAD8Pcd/ThFmh
	 U76JkVYun70S5b2LCZTzEFCUSJr0yTHlLKmz6vSnSDt9UpI/kPHQ+N+do29JwX7HBSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793688166;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=WtCVTc5BUYT58K9L3ssYNMksyXSRdB1lZKfCd4TmBWw=;
	b=waRhjSDBS6h3fkwJezn4xqP6WvJ1ivF7OcsjJ6N/Pz7ncLBgQGVLEHYKVwAqo9MMcIef
	 1DmaUOwK/1Dx5dRTo/+LAxiTdH46iASlIqO7IVpb3gWKIczYYGwU2xLKqEQ02pUS41i0Y
	 9fdznHaB77g/uUwT7NjzX6Sxg9/l1Oukt2W4z4b4iFcmiDmaqdPwNLNZeGigt/dR8qYZH
	 e3GfUlcldBfknv9vfGWYK+37u3y2dxzUWXc8751ejq8kr+tFcbYuHk+GJw3r09Xv7RIuT
	 E5kYLcwP5NfCg2JQiVWU1aNEPRQM26ufN8m+gEOXA6Qao+LhAaNzPjsYgKYdGuA2Sqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB04606A324;
	Tue,  3 Nov 2026 06:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDB04606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowACXoZJfgulqZXk5AA--.578S2;
	Tue, 03 Nov 2026 14:42:39 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: schalla@marvell.com,
	bbhushan2@marvell.com,
	herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: octeontx2 - Unwind allocations when AEAD initialization fails
Date: Tue,  3 Nov 2026 06:42:48 +0000
Message-Id: <20261103064248.1054181-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowACXoZJfgulqZXk5AA--.578S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr17JFWDKw1rurWrAw4Dtwb_yoW8Zr4rpF
	4rZ3y5Ary5XrZ7Kas7J3WrJFy3Ga93Cay3G3y09r18JwnxXr1vka4IyFWFqF1rCrZ5WF1j
	qFZ7A3W5Cr1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbkhL5
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAAAA2rpWwqCkwAAsM

cpt_aead_init() allocates a hash transform, descriptor and pads before
looking up a CPT device and initializing the hardware context. Failures
in those later steps return without freeing the earlier allocations.
If fallback allocation fails, the hardware context is also left mapped
and allocated. The algorithm exit callback does not run after a failed
initialization.

Release the hardware context when fallback initialization fails and free
the hash resources on all three failure paths.

Fixes: 6f03f0e8b6c8 ("crypto: octeontx2 - register with linux crypto framework")
Fixes: e92971117c2c ("crypto: octeontx2 - add ctx_val workaround")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 .../crypto/marvell/octeontx2/otx2_cptvf_algs.c   | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index 9eb5dc0a4da6..8d74e0274fdf 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -671,14 +671,24 @@ static int cpt_aead_init(struct crypto_aead *atfm, u8 cipher_type, u8 mac_type)
 
 	ret = get_se_device(&pdev, &cpu_num);
 	if (ret)
-		return ret;
+		goto err_free_hash;
 
 	ctx->pdev = pdev;
 	ret = cn10k_cpt_hw_ctx_init(pdev, &ctx->er_ctx);
 	if (ret)
-		return ret;
+		goto err_free_hash;
 
-	return cpt_aead_fallback_init(ctx, alg);
+	ret = cpt_aead_fallback_init(ctx, alg);
+	if (!ret)
+		return 0;
+
+	cn10k_cpt_hw_ctx_clear(pdev, &ctx->er_ctx);
+err_free_hash:
+	kfree(ctx->opad);
+	kfree(ctx->ipad);
+	kfree(ctx->sdesc);
+	crypto_free_shash(ctx->hashalg);
+	return ret;
 }
 
 static int otx2_cpt_aead_cbc_aes_sha1_init(struct crypto_aead *tfm)
-- 
2.34.1

