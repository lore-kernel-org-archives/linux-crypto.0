Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2953923717F;
	Thu,  6 Nov 2025 08:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762418954; cv=none; b=BNZsf1U6GTlbdRcLFztjbTDatB7kWFdL+Ryjsp9PTjkgOoW55fuQ9fjN0Uz72g6aVyZxbKrXLaKjt27R+qxBxOZ6V4GTbbqsqMpEYPOuSXzolLHthziiGjyOIu4rv7sLXhdvs8cndVYyNJ4bQ4eYS5yADJHF2tAfCE4NR3Fb+e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762418954; c=relaxed/simple;
	bh=q1Pmsl28SPq6AeXsI0AP2vqxF0zgwAn6cmGXQ/MSido=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sLP/FbMgLxlnTanrQutK6AWXOVvOy4UWWkj51ckI9zDRD3D6Bzu1cfIYILBgtljL9kY+7htOJ1niO4f3xo8TWRGyXwtNwwdhHsBdsNCcmG60MPfZILZ5lrB3oU2pE4StqFrM3Tu2SIxCLAFv8AZfJLEw4bhQ4AQlYfzeajcucrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-03 (Coremail) with SMTP id rQCowACXEur8YAxpIwy2AQ--.1774S2;
	Thu, 06 Nov 2025 16:49:02 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: nhorman@tuxdriver.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] crypto: ansi_cprng: fix cipher leak in cprng_init error path
Date: Thu,  6 Nov 2025 16:48:50 +0800
Message-ID: <20251106084851.639-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACXEur8YAxpIwy2AQ--.1774S2
X-Coremail-Antispam: 1UD129KBjvdXoWruFWrtry8KFyDJr1xAr1kXwb_yoWkArg_J3
	s2gw1Igry3AF97uwn7ta9rZr1IqF9xCryq9FWrKrZ7t3y3JrWqvF9rGr98Ar17urWjvrWU
	Gan5ury3AwnrujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjO6pDUUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBg0SA2kMSF9lDAAAsB

In the commit referenced by the Fixes tag, crypto_alloc_cipher()
was moved from reset_prng_context() to cprng_init(). However,
this approach does not account for the error path: when
reset_prng_context() fails, crypto_free_cipher() is never called,
resulting in a resource leak.

Free the allocated cipher before returning on reset_prng_context()
failure.

Fixes: fd09d7facb7c ("crypto: ansi_prng - alloc cipher just in init")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 crypto/ansi_cprng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 153523ce6076..6cf505bcf794 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -329,8 +329,10 @@ static int cprng_init(struct crypto_tfm *tfm)
 		return PTR_ERR(ctx->tfm);
 	}
 
-	if (reset_prng_context(ctx, NULL, DEFAULT_PRNG_KSZ, NULL, NULL) < 0)
+	if (reset_prng_context(ctx, NULL, DEFAULT_PRNG_KSZ, NULL, NULL) < 0) {
+		crypto_free_cipher(ctx->tfm);
 		return -EINVAL;
+	}
 
 	/*
 	 * after allocation, we should always force the user to reset
-- 
2.50.1.windows.1

