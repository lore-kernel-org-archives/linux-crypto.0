Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net (zg8tmja5ljk3lje4mi4ymjia.icoremail.net [209.97.182.222])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 255673290D2
	for <linux-crypto@vger.kernel.org>; Sun, 19 Apr 2026 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.182.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776589094; cv=none; b=VjPA0u3YZ/Xms0o1XW4H5oljAIu0bIS4NQjyYcwZwtiLk182ldGmzjsTHHRdzRsmn3VhhWDEoTLmLjVX3JxQGv4QqzcxtCioRYRDi0TPKa7T4XdKs7qN+l2hF5AdPRxvYxrc9QEftEn8Yu/TBZ5YtgKgZs9amWri8R+NdGN0d7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776589094; c=relaxed/simple;
	bh=RL2B0zTQkFlsR8hSH5EdPQY+44UIiYDZ/GyttuyWUXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJqhdVw8lXac0rgp25T43CKvCK+HK62lfFXoSbVajCGm4xEOc5WgBDl+KWALvpO2EbmiCoxAjsCYCK9N3pyRBqyzw1fNj/yi6VnoagadAtA/epIttMTfUoelFb1BE1Zm2FcEBZC2+rm+UXxTBHCVR5BB7GyUpTC0nO1l4jnghuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=209.97.182.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowACXDwAOmeRpThjUAA--.14325S3;
	Sun, 19 Apr 2026 16:57:52 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	smueller@chronox.de,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	tr0jan@lzu.edu.cn,
	kanolyc@gmail.com,
	ldy3087146292@gmail.com,
	n05ec@lzu.edu.cn,
	enjou1224@outlook.com
Subject: [PATCH v2 2/2] crypto: ccm - keep a private IV for auth and CTR state
Date: Sun, 19 Apr 2026 16:53:00 +0800
Message-ID: <7f569774b437b9056985db1fec58aff337a41a4d.1776578475.git.enjou1224@outlook.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <43955efb67bf85481da7457b73bd30539d8e5d79.1776578475.git.enjou1224@outlook.com>
References: <43955efb67bf85481da7457b73bd30539d8e5d79.1776578475.git.enjou1224@outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowACXDwAOmeRpThjUAA--.14325S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGw18KFWrJw4fXF45Ar4rAFb_yoWrGF4Dpa
	yfWFWDtFWktFyUCF4Iqryrury3WFZak343Gw47Gw13Crnagr48tFy2yryjvF15ZFykWFyj
	yF4vyryUuw12yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsCCWnkluAAEgAAso

From: Douya Le <ldy3087146292@gmail.com>

CCM currently uses req->iv both when formatting the authentication
input and as the working IV consumed by the CTR walk.  Keep a private IV
copy in the request context for authentication, and use a separate
working copy for CTR processing.

Together with the AF_ALG IV snapshot, this makes async CCM IV handling
stable without changing normal CCM behaviour.

Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
Tested-by: Yucheng Lu <kanolyc@gmail.com>
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: ENJOU1224 <enjou1224@outlook.com>
---
changes in v2:
  - split the original combined fix and keep only the ccm private IV
    handling change in this patch
  - rebase onto the current crypto-2.6 tree context used for the
    algif_aead part of the series
  - v1 Link: https://lore.kernel.org/all/9ccd66d3acbdb4fec21e58c3167fc51eec4b63d2.1775841543.git.ldy3087146292@gmail.com

 crypto/ccm.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 2ae929ffdef8..d409324dec29 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -42,6 +42,7 @@ struct crypto_ccm_req_priv_ctx {
 	u8 odata[16];
 	u8 idata[16];
 	u8 auth_tag[16];
+	u8 iv[16];
 	u32 flags;
 	struct scatterlist src[3];
 	struct scatterlist dst[3];
@@ -121,17 +122,17 @@ static int crypto_ccm_setauthsize(struct crypto_aead *tfm,
 	return 0;
 }
 
-static int format_input(u8 *info, struct aead_request *req,
+static int format_input(u8 *info, const u8 *iv, struct aead_request *req,
 			unsigned int cryptlen)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	unsigned int lp = req->iv[0];
+	unsigned int lp = iv[0];
 	unsigned int l = lp + 1;
 	unsigned int m;
 
 	m = crypto_aead_authsize(aead);
 
-	memcpy(info, req->iv, 16);
+	memcpy(info, iv, 16);
 
 	/* format control info per RFC 3610 and
 	 * NIST Special Publication 800-38C
@@ -176,7 +177,7 @@ static int crypto_ccm_auth(struct aead_request *req, struct scatterlist *plain,
 	int ilen, err;
 
 	/* format control data for input */
-	err = format_input(odata, req, cryptlen);
+	err = format_input(odata, pctx->iv, req, cryptlen);
 	if (err)
 		goto out;
 
@@ -248,9 +249,11 @@ static int crypto_ccm_init_crypt(struct aead_request *req, u8 *tag)
 {
 	struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
 	struct scatterlist *sg;
-	u8 *iv = req->iv;
+	u8 *iv = pctx->iv;
 	int err;
 
+	memcpy(iv, req->iv, sizeof(pctx->iv));
+
 	err = crypto_ccm_check_iv(iv);
 	if (err)
 		return err;
@@ -288,7 +291,7 @@ static int crypto_ccm_encrypt(struct aead_request *req)
 	struct scatterlist *dst;
 	unsigned int cryptlen = req->cryptlen;
 	u8 *odata = pctx->odata;
-	u8 *iv = req->iv;
+	u8 *iv = pctx->idata;
 	int err;
 
 	err = crypto_ccm_init_crypt(req, odata);
@@ -303,6 +306,8 @@ static int crypto_ccm_encrypt(struct aead_request *req)
 	if (req->src != req->dst)
 		dst = pctx->dst;
 
+	memcpy(iv, pctx->iv, 16);
+
 	skcipher_request_set_tfm(skreq, ctx->ctr);
 	skcipher_request_set_callback(skreq, pctx->flags,
 				      crypto_ccm_encrypt_done, req);
@@ -365,7 +370,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 	if (req->src != req->dst)
 		dst = pctx->dst;
 
-	memcpy(iv, req->iv, 16);
+	memcpy(iv, pctx->iv, 16);
 
 	skcipher_request_set_tfm(skreq, ctx->ctr);
 	skcipher_request_set_callback(skreq, pctx->flags,
-- 
2.51.0

