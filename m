Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7AA20C461
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 06:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772779389; cv=none; b=nssoFkYxdzMNvMXfbnbLth6/lvlXgf9YEoBtCbhjuCqD3SOMaO0ndw7MH6H7ZUTEM4e0eTohDP+MFr/DJGsmYunYsMOpsV4qi/K0QiQSH/Qke1ebjB1FWOLV5BavCbIxUi+Ft+W1Z8qFaekZ8ETjTmGCV+UXDkJU+P5Y9awb5IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772779389; c=relaxed/simple;
	bh=WTSm68jH8PQSZso+MBpBdL/R1lZqKRsqj7qp1sf6HQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pxpiZHt8ju3L+Gf3CHwrwmxIJUIcTFy8uveVeHpBvtKiQtNXWp8vi+qnHWBIsuc9WFCDPjaAq7xe6yWJ9UcLTkRB9iAFSUynNe5qlrIrqsIQ9PY3ZkCtpwdKz5hv+/mBe4GqskKG90ITEnjPqJDDF/dTY8Px+IZyRFgtgMY6rAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=egsJ39M4; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="egsJ39M4"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3598df39444so3237804a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Mar 2026 22:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772779388; x=1773384188; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=11+RTC5t0MsdYzyhRjOIFhJd9Jd2+UWG3tuKjDCny7k=;
        b=egsJ39M4uerykHgLQsaysYmlzVq8jTAWdu/lcXX4naaPKi8CK8gClnXw9+yQtMN2zg
         TvmzYt6/yAu6MMhl1oRqEjvOxe50yE62Fn4LZg4V3rekzaLeQ5Fe+oF/9sA5StsTKg/4
         1nzKb0plMieUVqyI/XKvexdbHw3WVNcWTbs1gg1PJfHKnzjf1+4lAofG7btS/fdc5Mkv
         wWOFpVzSRCjScuIoqyg5DQexhcBmO+asgt3NMDiEYDuJCCkaK57n2eC5WYvBoQUTHD1x
         5zJJyO0Dhs87piNzGLD8+aMwgtovQAO0EF+3P56ytqoFzkBfzvzPpbxa7x7VQVcSF7fv
         m/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772779388; x=1773384188;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11+RTC5t0MsdYzyhRjOIFhJd9Jd2+UWG3tuKjDCny7k=;
        b=YAY7ozqLMtC2OnVDzsE8tJavzmfkHhc9nCCrqzrI/AotcMd8OKvNG1AXAmNBnqPbZN
         EvS/YjX0lmOQs94sbl4hzKchN00CHeuiF3l2GQAYG5b+9DtFX0WQrUyNRH9xdyd7FKhD
         cZY7NI+nPKFKpUU88SqtBbQEGtuZhXq4V0bPck2Ip6iqVFLjpFMHZJuAmMGHiUEvGHOt
         TkOLInOJVMVstIvwp0QHuvvczYU498v678BxBjAEdUZF1XpXlGrW83kyqz007/nrOvWS
         KKz0S/BpLGtFwXhoE8z3Di0R0ezSR3j2srZH6v2FVI5cu2XvuCgJWw11d9ezrlyjGcSA
         oGMg==
X-Forwarded-Encrypted: i=1; AJvYcCXkiPAw+f0QrwOpWc9OqU6xh6JlSXykVfR9ChUjAmXLzqf4zv+36HSNGl8rKtz2fFM2kf5g9OFbKlFLYtw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEqv3VsK49AxRFQH/tYLeh0+wBPWr9DA5qYYHYkzm+wPK2A0nr
	P3hCoBby1qowtRN69HhFP8+o+qCSsltO4bFJa/FMLFA4bx6rQZKbys9P
X-Gm-Gg: ATEYQzyJOSnR7z+IdG/uSD5v3oTPCdpeXQiRfye8oFYrnmrK0MYjJDUzrQ8OFE19oD2
	xbNbb1QPlsbGUQTieaEuwkRDz5q1nPwnWvcg1I8iAdetRs9YcqAUt980rpGPFdksxFTnHUtC+W7
	d5fF6CK+DNGRPNyAY+6Jq/iGl1GOoyNlCHp87r9bVH9ArNSN3o1hPrqE3yXzOso1tJqKWD5rq7I
	QHAB/dCxUShIvsMAF7vf0z84c2XXJENv3gJM8tNUWE2QA2pEbh7bCquV33964RnWXGsk7CiMlaI
	LumC14Tp1yXgJX6eDba9iOLXFFmu/dmblPjoKC07Eg18qnnrJ/L2ANmhTPOU2b/uCZ9+LdyQXrR
	wNYLg+S/EpOtZFJO1v6oELBHf0jdmnOjyRaivOOAtP038evRcS7sIph8GIUcT/r83Is5JUFXLz1
	zT+U9MOo7sUe21o20qVncO3s/AiWGHOw==
X-Received: by 2002:a17:902:da8a:b0:2ae:450c:951e with SMTP id d9443c01a7336-2ae82388a53mr13181935ad.17.1772779387493;
        Thu, 05 Mar 2026 22:43:07 -0800 (PST)
Received: from arm-server.. ([2001:288:7001:2724:1a31:bfff:fe58:b622])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae840b2e9dsm11892375ad.85.2026.03.05.22.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 22:43:07 -0800 (PST)
From: Cheng-Yang Chou <yphbchou0911@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	catalin.marinas@arm.com,
	will@kernel.org,
	ebiggers@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: jserv@ccns.ncku.edu.tw,
	yphbchou0911@gmail.com
Subject: [PATCH v2] crypto: arm64/aes-neonbs - Move key expansion off the stack
Date: Fri,  6 Mar 2026 14:42:54 +0800
Message-ID: <20260306064254.2079274-1-yphbchou0911@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

aesbs_setkey() and aesbs_cbc_ctr_setkey() allocate struct crypto_aes_ctx
on the stack. On arm64, the kernel-mode NEON context is also stored on
the stack, causing the combined frame size to exceed 1024 bytes and
triggering -Wframe-larger-than= warnings.

Allocate struct crypto_aes_ctx on the heap instead and use
kfree_sensitive() to ensure the key material is zeroed on free.
Use a goto-based cleanup path to ensure kfree_sensitive() is always
called.

Signed-off-by: Cheng-Yang Chou <yphbchou0911@gmail.com>
---
Changes in v1:
- Replace memzero_explicit() + kfree() with kfree_sensitive()
  (Eric Biggers)
- Link to v1: https://lore.kernel.org/all/20260305183229.150599-1-yphbchou0911@gmail.com/

 arch/arm64/crypto/aes-neonbs-glue.c | 37 ++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index cb87c8fc66b3..00530b291010 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -76,19 +76,24 @@ static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
 	struct aesbs_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_aes_ctx rk;
+	struct crypto_aes_ctx *rk;
 	int err;
 
-	err = aes_expandkey(&rk, in_key, key_len);
+	rk = kmalloc(sizeof(*rk), GFP_KERNEL);
+	if (!rk)
+		return -ENOMEM;
+
+	err = aes_expandkey(rk, in_key, key_len);
 	if (err)
-		return err;
+		goto out;
 
 	ctx->rounds = 6 + key_len / 4;
 
 	scoped_ksimd()
-		aesbs_convert_key(ctx->rk, rk.key_enc, ctx->rounds);
-
-	return 0;
+		aesbs_convert_key(ctx->rk, rk->key_enc, ctx->rounds);
+out:
+	kfree_sensitive(rk);
+	return err;
 }
 
 static int __ecb_crypt(struct skcipher_request *req,
@@ -133,22 +138,26 @@ static int aesbs_cbc_ctr_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
 	struct aesbs_cbc_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_aes_ctx rk;
+	struct crypto_aes_ctx *rk;
 	int err;
 
-	err = aes_expandkey(&rk, in_key, key_len);
+	rk = kmalloc(sizeof(*rk), GFP_KERNEL);
+	if (!rk)
+		return -ENOMEM;
+
+	err = aes_expandkey(rk, in_key, key_len);
 	if (err)
-		return err;
+		goto out;
 
 	ctx->key.rounds = 6 + key_len / 4;
 
-	memcpy(ctx->enc, rk.key_enc, sizeof(ctx->enc));
+	memcpy(ctx->enc, rk->key_enc, sizeof(ctx->enc));
 
 	scoped_ksimd()
-		aesbs_convert_key(ctx->key.rk, rk.key_enc, ctx->key.rounds);
-	memzero_explicit(&rk, sizeof(rk));
-
-	return 0;
+		aesbs_convert_key(ctx->key.rk, rk->key_enc, ctx->key.rounds);
+out:
+	kfree_sensitive(rk);
+	return err;
 }
 
 static int cbc_encrypt(struct skcipher_request *req)
-- 
2.48.1

