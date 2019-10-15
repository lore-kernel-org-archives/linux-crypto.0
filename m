Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05873ECE58E
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 08:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9F9220873
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 08:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BM+3d1XI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbfJOIOT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 04:14:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38996 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728560AbfJOIOT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 04:14:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so22646155wrj.6
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2019 01:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=CNzhRj9715dIAlH5g4GbpFfzHsByaP7eq8QaF1Kazok=;
        b=BM+3d1XI4HFrlSwLIpH7fjaZOfh/yUWXNrzZEk5ESrYBV9gzoWA4PXL96UVQMwKCyt
         v5bk973NJZmSURWE8XT2tp4ta2Oj4D3cAzbBqM864BQfa+a6d9xgnlS5IZeqtIPs1ZqU
         VogHniayaoRH98Oj534/0KtVgU52BKl4geBKsp85EvlFghSlgiI0E+3AlVrj/smvSCnD
         J1s7AQ0ofxF2t0T74cIVbTnYIbFIWn4S2kvwqAW3yMW64Bu2gISf52eg+v24naZbKZm1
         gBvnyC6KBrE+dVxltIwAxL8a7ut+/LbGlE8BO5yYLvT9zsPlFUS1mxTPuB67SpFEuuaC
         BQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CNzhRj9715dIAlH5g4GbpFfzHsByaP7eq8QaF1Kazok=;
        b=h6mdGWYg37ULcriDCVO71pJKl50CarUDy74RcIzsD4ROfIV7GuvFkY/K/35Aiper1y
         wGJjuTcl4t/1Co9fGxwvXq0pxKmv+qmfJlVkEWFmPqSuNo5zwOZAnA2z1vfqnQ991hy+
         HkO2ol3L4tQAfSqCfcRE5pwi5G2AuBl0MbexOeWp6qoAfaym28UMNndWhB+gc+OUiSQ8
         I2zxmfoIlKiS95oUgKR6KrrrYzsYgp3dejNsFX9bfJjIbm6dlDREoSzZ45wkP6g3SZH9
         KmmcHWawV/84owz8NisOh1xNj/D79515mR4DaGTLTc+sf63jaz8rHk1eNCNK4f0q+6cf
         rlEQ==
X-Gm-Message-State: APjAAAWjLoUSE9JgSa4V0wpNCghV87lyXng6C9D0A2lZcnuuBJfirGZd
        /j3hF3nvCgCkyh4CTD7KnX1eg6WMQh7ylkuT
X-Google-Smtp-Source: APXvYqyn+9HiJv4pPgGutGbodgiPjTvk4uatUJt5kcdGhPiXMofaF/Zznc4BOsTeuVpqRFXLQHbyrA==
X-Received: by 2002:adf:de85:: with SMTP id w5mr28706856wrl.278.1571127255179;
        Tue, 15 Oct 2019 01:14:15 -0700 (PDT)
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr. [90.118.215.104])
        by smtp.gmail.com with ESMTPSA id b7sm22427078wrx.56.2019.10.15.01.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 01:14:14 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: powerpc/spe-xts - implement support for ciphertext stealing
Date:   Tue, 15 Oct 2019 10:14:12 +0200
Message-Id: <20191015081412.5295-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the logic to deal with input sizes that are not a round multiple
of the AES block size, as described by the XTS spec. This brings the
SPE implementation in line with other kernel drivers that have been
updated recently to take this into account.

Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
This applies onto Eric's series 'crypto: powerpc - convert SPE AES algorithms
to skcipher API', which helpfully contained instructions how to run this code
under QEMU, allowing me to test the changes below.

 arch/powerpc/crypto/aes-spe-glue.c | 81 +++++++++++++++++++-
 1 file changed, 79 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index f828f8bcd0c6..1fad5d4c658d 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -19,6 +19,8 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
+#include <crypto/gf128mul.h>
+#include <crypto/scatterwalk.h>
 
 /*
  * MAX_BYTES defines the number of bytes that are allowed to be processed
@@ -327,12 +329,87 @@ static int ppc_xts_crypt(struct skcipher_request *req, bool enc)
 
 static int ppc_xts_encrypt(struct skcipher_request *req)
 {
-	return ppc_xts_crypt(req, true);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct ppc_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int tail = req->cryptlen % AES_BLOCK_SIZE;
+	int offset = req->cryptlen - tail - AES_BLOCK_SIZE;
+	struct skcipher_request subreq;
+	u8 b[2][AES_BLOCK_SIZE];
+	int err;
+
+	if (req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (tail) {
+		subreq = *req;
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   req->cryptlen - tail, req->iv);
+		req = &subreq;
+	}
+
+	err = ppc_xts_crypt(req, true);
+	if (err || !tail)
+		return err;
+
+	scatterwalk_map_and_copy(b[0], req->dst, offset, AES_BLOCK_SIZE, 0);
+	memcpy(b[1], b[0], tail);
+	scatterwalk_map_and_copy(b[0], req->src, offset + AES_BLOCK_SIZE, tail, 0);
+
+	spe_begin();
+	ppc_encrypt_xts(b[0], b[0], ctx->key_enc, ctx->rounds, AES_BLOCK_SIZE,
+			req->iv, NULL);
+	spe_end();
+
+	scatterwalk_map_and_copy(b[0], req->dst, offset, AES_BLOCK_SIZE + tail, 1);
+
+	return 0;
 }
 
 static int ppc_xts_decrypt(struct skcipher_request *req)
 {
-	return ppc_xts_crypt(req, false);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct ppc_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int tail = req->cryptlen % AES_BLOCK_SIZE;
+	int offset = req->cryptlen - tail - AES_BLOCK_SIZE;
+	struct skcipher_request subreq;
+	u8 b[3][AES_BLOCK_SIZE];
+	le128 twk;
+	int err;
+
+	if (req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (tail) {
+		subreq = *req;
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   offset, req->iv);
+		req = &subreq;
+	}
+
+	err = ppc_xts_crypt(req, false);
+	if (err || !tail)
+		return err;
+
+	scatterwalk_map_and_copy(b[1], req->src, offset, AES_BLOCK_SIZE + tail, 0);
+
+	spe_begin();
+	if (!offset)
+		ppc_encrypt_ecb(req->iv, req->iv, ctx->key_twk, ctx->rounds,
+				AES_BLOCK_SIZE);
+
+	gf128mul_x_ble(&twk, (le128 *)req->iv);
+
+	ppc_decrypt_xts(b[1], b[1], ctx->key_dec, ctx->rounds, AES_BLOCK_SIZE,
+			(u8 *)&twk, NULL);
+	memcpy(b[0], b[2], tail);
+	memcpy(b[0] + tail, b[1] + tail, AES_BLOCK_SIZE - tail);
+	ppc_decrypt_xts(b[0], b[0], ctx->key_dec, ctx->rounds, AES_BLOCK_SIZE,
+			req->iv, NULL);
+	spe_end();
+
+	scatterwalk_map_and_copy(b[0], req->dst, offset, AES_BLOCK_SIZE + tail, 1);
+
+	return 0;
 }
 
 /*
-- 
2.17.1

