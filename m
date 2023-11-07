Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12CF4433
	for <linux-crypto@vger.kernel.org>; Tue,  7 Nov 2023 06:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Greylist: delayed 305 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Nov 2023 22:42:41 PST
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3ABE8
	for <linux-crypto@vger.kernel.org>; Mon,  6 Nov 2023 22:42:41 -0800 (PST)
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowABXOQ4L20llS8PdAA--.63801S2;
	Tue, 07 Nov 2023 14:36:59 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	t-kristo@ti.com,
	j-keerthy@ti.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] crypto: sa2ul - Add check for crypto_aead_setkey
Date: Tue,  7 Nov 2023 06:31:52 +0000
Message-Id: <20231107063152.529830-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABXOQ4L20llS8PdAA--.63801S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZFyrGr15trWfJF4rCw1rWFg_yoWDKFX_Cr
	ZFg3ZxWrWUAr48u39rW3yrAryFqasxuF93uFWvqa43Aay5Aw4ruF4xArn5ZryFyr4UJrn8
	Ww47CryrAry7ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbc8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r47
	MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
	W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUYeHqDUUUU
X-Originating-IP: [124.16.138.129]
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Add check for crypto_aead_setkey() and return the error if it fails
in order to transfer the error.

Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/crypto/sa2ul.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 6846a8429574..6bac2382e261 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1806,6 +1806,7 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	int cmdl_len;
 	struct sa_cmdl_cfg cfg;
 	int key_idx;
+	int error;
 
 	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
 		return -EINVAL;
@@ -1869,7 +1870,9 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	crypto_aead_set_flags(ctx->fallback.aead,
 			      crypto_aead_get_flags(authenc) &
 			      CRYPTO_TFM_REQ_MASK);
-	crypto_aead_setkey(ctx->fallback.aead, key, keylen);
+	error = crypto_aead_setkey(ctx->fallback.aead, key, keylen);
+	if (error)
+		return error;
 
 	return 0;
 }
-- 
2.25.1

