Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2035025CC74
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 07:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776497957; cv=none; b=dFfWDGPVJES179TNGK+cfq8N5tJA5Y4ikDzz50SlNIwyDaKtuloL2kLNn64GJbK9tE1NtfCxzn5kCoG8QgVpSHqiL5ORQ6PunqkFd8nlgMadIa09aDeoBa1WMs6BjtIhZgHl8VAg2uX6GW+aFIOI5jZkqNn7/XRy5mPY9NZFAVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776497957; c=relaxed/simple;
	bh=ku3fajHzc7IGQS5QC4//FvI+ZkHNeq1cRKv7tgyQ2/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM42BsN3CEy1GiLWg8NEEXR1B6XfeAcepG1n3+RFSKv1PItvwCij7AbAHk+cIVBnKX/XNe+lvEJKNg/iiu7UqAo7RAn09v1i5aFcwhAbTFA7eLuoXu180pWxZkb2N2zbRHh6NA1CbB9rxG2gaG5RwyCED+FSoXNa8pJBtnoj/Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowACnHwAVNeNpDPfRAA--.48797S3;
	Sat, 18 Apr 2026 15:39:02 +0800 (CST)
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
	n05ec@lzu.edu.cn
Subject: [PATCH 1/1] crypto: algif_aead, ccm - stabilize IV handling for async CCM requests
Date: Sat, 18 Apr 2026 15:34:57 +0800
Message-ID: <9ccd66d3acbdb4fec21e58c3167fc51eec4b63d2.1775841543.git.ldy3087146292@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1775841543.git.ldy3087146292@gmail.com>
References: <cover.1775841543.git.ldy3087146292@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowACnHwAVNeNpDPfRAA--.48797S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF13AFy3GFykZrWkJw1UKFg_yoWrKF4kpa
	yfGFZ8trW8XryIk3WftryrCr45Gr93ZFW3Wr4fGr13Grnaqr4FvFy2yFyYvF1YkFykGrWU
	tF4vyr98uw12yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsBCWnh8+AOxgAAsR

From: Douya Le <ldy3087146292@gmail.com>

AF_ALG AEAD AIO requests currently use the socket-wide IV buffer during
request processing.  For async CCM requests, later socket activity can
update that shared state before the original request has fully completed,
which can lead to inconsistent IV handling.

Fix this in two places:

- snapshot the IV into per-request storage in algif_aead before
  submitting an async AEAD operation, so in-flight requests no longer
  depend on mutable socket state;
- make CCM keep a private IV copy for authentication, separate from the
  working IV that is consumed by the CTR walk.

Together these changes make async CCM IV handling stable without
changing normal AF_ALG or CCM behaviour.

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
---
 crypto/algif_aead.c | 10 ++++++++--
 crypto/ccm.c        | 19 ++++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index f8bd45f7dc83..cb651ab58d62 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -72,8 +72,10 @@
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_aead *tfm = pask->private;
 	unsigned int as = crypto_aead_authsize(tfm);
+	unsigned int ivsize = crypto_aead_ivsize(tfm);
 	struct af_alg_async_req *areq;
 	struct scatterlist *rsgl_src, *tsgl_src = NULL;
+	void *iv;
 	int err = 0;
 	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
 	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
@@ -125,10 +127,14 @@
 
 	/* Allocate cipher request for current operation. */
 	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
-				     crypto_aead_reqsize(tfm));
+				     crypto_aead_reqsize(tfm) + ivsize);
 	if (IS_ERR(areq))
 		return PTR_ERR(areq);
 
+	iv = (u8 *)aead_request_ctx(&areq->cra_u.aead_req) +
+	     crypto_aead_reqsize(tfm);
+	memcpy(iv, ctx->iv, ivsize);
+
 	/* convert iovecs of output buffers into RX SGL */
 	err = af_alg_get_rsgl(sk, msg, flags, areq, outlen, &usedpages);
 	if (err)
@@ -187,7 +193,7 @@
 
 	/* Initialize the crypto operation */
 	aead_request_set_crypt(&areq->cra_u.aead_req, tsgl_src,
-			       areq->first_rsgl.sgl.sgt.sgl, used, ctx->iv);
+			       areq->first_rsgl.sgl.sgt.sgl, used, iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 2ae929ffdef8..d409324dec29 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -42,6 +42,7 @@
 	u8 odata[16];
 	u8 idata[16];
 	u8 auth_tag[16];
+	u8 iv[16];
 	u32 flags;
 	struct scatterlist src[3];
 	struct scatterlist dst[3];
@@ -121,17 +122,17 @@
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
@@ -176,7 +177,7 @@
 	int ilen, err;
 
 	/* format control data for input */
-	err = format_input(odata, req, cryptlen);
+	err = format_input(odata, pctx->iv, req, cryptlen);
 	if (err)
 		goto out;
 
@@ -248,9 +249,11 @@
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
@@ -288,7 +291,7 @@
 	struct scatterlist *dst;
 	unsigned int cryptlen = req->cryptlen;
 	u8 *odata = pctx->odata;
-	u8 *iv = req->iv;
+	u8 *iv = pctx->idata;
 	int err;
 
 	err = crypto_ccm_init_crypt(req, odata);
@@ -303,6 +306,8 @@
 	if (req->src != req->dst)
 		dst = pctx->dst;
 
+	memcpy(iv, pctx->iv, 16);
+
 	skcipher_request_set_tfm(skreq, ctx->ctr);
 	skcipher_request_set_callback(skreq, pctx->flags,
 				      crypto_ccm_encrypt_done, req);
@@ -365,7 +370,7 @@
 	if (req->src != req->dst)
 		dst = pctx->dst;
 
-	memcpy(iv, req->iv, 16);
+	memcpy(iv, pctx->iv, 16);
 
 	skcipher_request_set_tfm(skreq, ctx->ctr);
 	skcipher_request_set_callback(skreq, pctx->flags,
--
2.43.0

