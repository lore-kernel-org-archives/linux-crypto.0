Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7B311B;
	Sun, 26 Nov 2023 18:04:14 -0800 (PST)
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowACHCx4S+WNlHS2RBA--.55153S2;
	Mon, 27 Nov 2023 10:04:02 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	t-kristo@ti.com,
	j-keerthy@ti.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH v2] crypto: sa2ul - Return crypto_aead_setkey to transfer the error
Date: Mon, 27 Nov 2023 02:03:01 +0000
Message-Id: <20231127020301.2307177-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACHCx4S+WNlHS2RBA--.55153S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKFyrKr1xuw4ktr43Wr17ZFb_yoWfKrb_C3
	y29FnxXryDAr48u3y8W3y5uryFvasxWFyfuFWvq3Z3ta4fCw4ruF1xur18ZryrZr4UJrn8
	Wa17Ary5Ar17ZjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8
	JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
	0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbN6pPUUUUU==
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Return crypto_aead_setkey() in order to transfer the error if
it fails.

Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
Changelog:

v1 -> v2:
1. Simplify code
2. Update commit message
---
 drivers/crypto/sa2ul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 6846a8429574..78a4930c6480 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1869,9 +1869,8 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	crypto_aead_set_flags(ctx->fallback.aead,
 			      crypto_aead_get_flags(authenc) &
 			      CRYPTO_TFM_REQ_MASK);
-	crypto_aead_setkey(ctx->fallback.aead, key, keylen);
 
-	return 0;
+	return crypto_aead_setkey(ctx->fallback.aead, key, keylen);
 }
 
 static int sa_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
-- 
2.25.1

