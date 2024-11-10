Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFDD381AF;
	Sun, 10 Nov 2024 18:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731264671; cv=none; b=tHoYKv8XNvGcggAY6nAcr8lQOr4w2HrKwGjV9WiKMAqUe5U061Tty5hMJbV71pg2rxjUkFasA1mSq72YAr8+A1rX7mPAARbjHXS9uILW0wK1iuT9VAkSviI9tSo5FLov0LoF8XiF+QnrRqbyYS2tjF1uhXD8zEHu5/pGJgoQD9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731264671; c=relaxed/simple;
	bh=hxoFXh2tf+fSHJm5jTqWTme4JJ8C+JkVWWODbJ/lMdE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iZsx5fd0WzVx2AeprwtowFOExT9ZX4pcwzl6C6on9X4RUfbkvw8PE5DvctZu4lGIlP5RYnj5u6WSvWxc33Rbm5AbyKMJH7tpO2K6wg2AQnxi4zpzCTFu/Drwr9PACBWia+MhjhAcI0HObb7T1tELnllAmEv0jBvaOCsfTk/w+IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aGu85AiV; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aGu85AiV"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9ec86a67feso673535266b.1;
        Sun, 10 Nov 2024 10:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731264667; x=1731869467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9/4pjCP82gvfS9OpswKVNnjN1UrKYwhiQEVjC6lI57Q=;
        b=aGu85AiV/zhbXph1tydnFrJHzoPcmeREYsXAoMkx6z3FCZAkoa09mn4+IAiSFzLs0z
         qDoAW0ArvPGXnjwjyU0Q00XArW4wi4bRBq9HS/4vhLed+aElCu81EXV16czrhzqjCups
         Z0XKDSMm+w8X8GyDD+xvKAnYG6v3sGxae8VMt94rlxsc9AWitaltiwgHWHynF2szkKBB
         IvWsa/ZrMB5vFDuiWqQRs9uK/5SqKGmrJDSq5hUJRVV1cdnQcwbOI/wz3HTYPJeuY+nL
         bKDs6rFnztXVR7g2XoCzFDM84QPXGMWU9DDeMbp523VxEslzqOFYy7AztSe8UbN0p5hN
         c/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731264667; x=1731869467;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9/4pjCP82gvfS9OpswKVNnjN1UrKYwhiQEVjC6lI57Q=;
        b=mv0m3pLRfK2cDjZxDAYTGVtZRemVbaxuLrUIOdJlpFq5EAFTgMUI6onx1uQpEpiB11
         V1X2r8rcYYW3x9BJs+MPY5V0rrNU/zlRKruaQRXYjcGnXT4RlJPlMI88n1o4jGLu4o2B
         UX6J7bq7yisKFDtt+b+Lt3kIIkxQphAZ1pahTY1caJlL+lY8mB5+EpH+jABlBoYt5doe
         MGLAQ09oZf8p3yXhrWRbdeTBtNwOnHMuCekWAGgWmJUJxqVR2IyhFm3+j8Hm8GdJEKCy
         KUHGwFgXX4ASn7ZiPCQyK9rTrAAibzgxw7ZOWGvNm5JRRTuD245K4yd/dw76rzH4kEIm
         4i5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwpIEFeOgOVhTCV8+oxua/PPld/2pBZY0+mODDTx9dNQtO+t4UYSpdy29wQHDPyawFE5C8lXd1J+sGl6U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk5Q0084viyd+TGl0j5bRlQ35hA3YZmz1aKzUN9D6JtpGbJSNK
	vXfkspJkZAKeoqBCCk08M7mcyeWTrWW/vhW+/A9CGinCx8nepQmL
X-Google-Smtp-Source: AGHT+IF94RU14sYzHF8bjEr+0jO9Wvs+vc/Y0hkEmXamxVU+iLlP6EtFkiM6BPwnfpFQDvOkn5ocWw==
X-Received: by 2002:a17:907:7baa:b0:a9a:2afc:e4e4 with SMTP id a640c23a62f3a-a9ef0052ae7mr1015948166b.59.1731264667234;
        Sun, 10 Nov 2024 10:51:07 -0800 (PST)
Received: from localhost.localdomain ([83.168.79.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0abea92sm502076066b.85.2024.11.10.10.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 10:51:06 -0800 (PST)
From: Karol Przybylski <karprzy7@gmail.com>
To: bbrezillon@kernel.org,
	arno@natisbad.org,
	schalla@marvell.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	karprzy7@gmail.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: [PATCH] crypto: marvell/cesa: fix uninit value for struct mv_cesa_op_ctx
Date: Sun, 10 Nov 2024 19:50:58 +0100
Message-Id: <20241110185058.2226730-1-karprzy7@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In cesa/cipher.c most declarations of struct mv_cesa_op_ctx are uninitialized.
This causes one of the values in the struct to be left unitialized in later
usages.

This patch fixes it by adding initializations in the same way it is done in
cesa/hash.c.

Fixes errors discovered in coverity: 1600942, 1600939, 1600935, 1600934, 1600929, 1600927,
1600925, 1600921, 1600920, 1600919, 1600915, 1600914

Signed-off-by: Karol Przybylski <karprzy7@gmail.com>
---
 drivers/crypto/marvell/cesa/cipher.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 0f37dfd42d85..cf62db50f958 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -489,7 +489,7 @@ static int mv_cesa_des_op(struct skcipher_request *req,
 
 static int mv_cesa_ecb_des_encrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl,
 			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
@@ -500,7 +500,7 @@ static int mv_cesa_ecb_des_encrypt(struct skcipher_request *req)
 
 static int mv_cesa_ecb_des_decrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl,
 			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
@@ -543,7 +543,7 @@ static int mv_cesa_cbc_des_op(struct skcipher_request *req,
 
 static int mv_cesa_cbc_des_encrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_ENC);
 
@@ -552,7 +552,7 @@ static int mv_cesa_cbc_des_encrypt(struct skcipher_request *req)
 
 static int mv_cesa_cbc_des_decrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_DEC);
 
@@ -596,7 +596,7 @@ static int mv_cesa_des3_op(struct skcipher_request *req,
 
 static int mv_cesa_ecb_des3_ede_encrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl,
 			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
@@ -608,7 +608,7 @@ static int mv_cesa_ecb_des3_ede_encrypt(struct skcipher_request *req)
 
 static int mv_cesa_ecb_des3_ede_decrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl,
 			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
@@ -649,7 +649,7 @@ static int mv_cesa_cbc_des3_op(struct skcipher_request *req,
 
 static int mv_cesa_cbc_des3_ede_encrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl,
 			   CESA_SA_DESC_CFG_CRYPTCM_CBC |
@@ -661,7 +661,7 @@ static int mv_cesa_cbc_des3_ede_encrypt(struct skcipher_request *req)
 
 static int mv_cesa_cbc_des3_ede_decrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl,
 			   CESA_SA_DESC_CFG_CRYPTCM_CBC |
@@ -725,7 +725,7 @@ static int mv_cesa_aes_op(struct skcipher_request *req,
 
 static int mv_cesa_ecb_aes_encrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl,
 			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
@@ -736,7 +736,7 @@ static int mv_cesa_ecb_aes_encrypt(struct skcipher_request *req)
 
 static int mv_cesa_ecb_aes_decrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl,
 			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
@@ -778,7 +778,7 @@ static int mv_cesa_cbc_aes_op(struct skcipher_request *req,
 
 static int mv_cesa_cbc_aes_encrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_ENC);
 
@@ -787,7 +787,7 @@ static int mv_cesa_cbc_aes_encrypt(struct skcipher_request *req)
 
 static int mv_cesa_cbc_aes_decrypt(struct skcipher_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_DEC);
 
-- 
2.34.1

