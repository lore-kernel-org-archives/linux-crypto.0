Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFC9191F8E;
	Wed, 27 Nov 2024 23:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732751059; cv=none; b=AJbJ3eAlBiaQiVr/IR0bfrlPP9Ba/OC3LMpvYGT0oQHr5nsqmgJxPChS6H7ifjcln4UNMUI9/MYogS4vTLScvedthpFCaAESP+vEyyyKk/ETTtCldsYJFKP9W6B/yTXZxAO2RTlKDjCagkS/7v4TPsvKl1ImZCUIxlUeJHe6FrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732751059; c=relaxed/simple;
	bh=SJgQfHOSQEkKrprgq2qm57fqyeX+64ivBUN9XHKz728=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hs/FWwJb+ICh2G/Ug5Yxxh7Awv2mF6h02xUKUmRbPpG3j+SnOPLk59UyYnrJwg7sX15S/CPte4q/6w2fAKJoYXNbVvdGGnYJQijQW7YPgi1pmRFbgGwLxZsw7uJwRXKfq+ecc2xAgubz9P1OJDXmaAMeSs6JeQnJig9BG0yh8ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9OPHKBB; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9OPHKBB"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7251731d2b9so1014292b3a.1;
        Wed, 27 Nov 2024 15:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732751057; x=1733355857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j+MIlH5caWtN86lAoqIcyCI0PAwLZbimudGFiQD/0o8=;
        b=Z9OPHKBBcq6bDwqay69gYq9JxIMlYWyJ66uP4944wDwIAB5McGdmvVqm9DRBDAXaDJ
         6EFL4/LQJwGUla8bO15gGVQrYZgBBqe6xP8EAETJMhul0x1ikLhrRIbvCDlfcJ8mH1Mz
         ZcJwtLf2lshXJ2mWPriu89H6udCwyZMkLMP01Q0UE2fqEioi3Fak3ghH+0+qFB+0On3o
         E03iTUqjpHeMd81bX/zBQSzEL3y0qE4wVxLg409yUbucWFjjjmwNUtscILFHz1KxLCE/
         Yu09hRoZBYwUGbyHTQvc1XgrtVIrx0HZvWKXSbOJgH2mxGLGhaXBGoo1Wl7YRoaTbnQK
         wWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732751057; x=1733355857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+MIlH5caWtN86lAoqIcyCI0PAwLZbimudGFiQD/0o8=;
        b=WJexTVjd4TyHWVlMd05T1OVPd9cuiG8OlPEmG3dNFDb6aD81+bi6Nq4+iZ3IWRQRZP
         BAT4+6Pe1qX68OykOot9HZVroZ4iqS032RwnsbfZbRk2jqaFqZ5qf5+zaoabDLpZcms6
         bd5XmeH7PDTmv4HwiZG34XtvTQLl9ibybTGMMBxASjCv0X+V2sut5mgzaSEbGA0jm7Rw
         VOkmdzB6JdSDaEiG9/zioeY4z8CkzV6+Nx8+kBEdysJmnwOUAy8aBDyqER3E8zcQnsnn
         L1FrZDfBUZ9Eu0KlJrfv5vwpX733rU/fefdSn1jpEcgT/fwmmUEMafLRJ1kI0WHO6WCb
         +mIw==
X-Forwarded-Encrypted: i=1; AJvYcCUAuGBe9w5Hwkk89ace5Vsf4Cfwpr7tSBkDx2gr8f84YPlFLEJ7VMbpIZLWfVw/wz7/uqAqQqNuWC9sIBw=@vger.kernel.org, AJvYcCUmSaggSJZuNEONfhbdCK1wPQjG88MgFGBNn9MGpyDdxh7sMooB/tY4vQK0CwZCuVfQ3Fb40upDDvKBXmXs@vger.kernel.org
X-Gm-Message-State: AOJu0YxmRHcKk67e1U1pxu9FwZk70Cisovsy0rwjrwPwVl/FQ/9e0nss
	n71DTVZxUX4omtKfBC9sMP2fPaX9g1uPseUVa5aXynegF4jruEfG
X-Gm-Gg: ASbGncuwdy4GYIZ3VKYd0I9EOIxeEUCOyj2AY4OGdxh6tfnRLtILmjsuUvahhm9VVHR
	q4cbsSu9jr8zjV4pZ5uv2SOuJwwjc6FnQxZgC6rwIJscMJaEV9jCz52S14GRRwGz6rrKMVDn1Ww
	Bq89w9oF34FnaXNSARCuV7tj0bIEP+VW3SFnUmybPp8MB/p+saxOpiJ6rtorKmusV0t/TnoI2VX
	CGgPXCjeHgzNmt51ZsvxTkm/CcILNNuK92XoSvmWB7WdxHQW60A
X-Google-Smtp-Source: AGHT+IGZJyMglYCdFWYJvTUolybseLph5KHalgMYhe6FouC4A/B7u1APP2l2Yk+cRmbxW/j7oEFFdA==
X-Received: by 2002:a17:902:f541:b0:20c:f6c5:7f6c with SMTP id d9443c01a7336-2151d33e1e0mr20148275ad.16.1732751057389;
        Wed, 27 Nov 2024 15:44:17 -0800 (PST)
Received: from localhost ([38.141.211.103])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725417fbffasm141807b3a.103.2024.11.27.15.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 15:44:16 -0800 (PST)
From: Ragavendra <ragavendra.bn@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com
Cc: x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ragavendra <ragavendra.bn@gmail.com>
Subject: [PATCH] x86/aesni: fix uninit value for skcipher_walk
Date: Wed, 27 Nov 2024 15:43:47 -0800
Message-ID: <20241127234347.1739754-1-ragavendra.bn@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In crypto/aesni-intel_glue.c most declarations of struct
skcipher_walk are unitialized. This causes one of the values
in the struct to be left uninitialized in the later usages.

This patch fixes it by adding initializations to the struct
skcipher_walk walk variable.

Fixes bugs reported in the Coverity scan with CID 139545,
1518179, 1585019 and 1598915.

Signed-off-by: Ragavendra Nagraj <ragavendra.bn@gmail.com>
---
---
 arch/x86/crypto/aesni-intel_glue.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index b0dd83555499..168edb21a6c4 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -398,7 +398,7 @@ static int ctr_crypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
 	u8 keystream[AES_BLOCK_SIZE];
-	struct skcipher_walk walk;
+	struct skcipher_walk walk = {};
 	unsigned int nbytes;
 	int err;
 
@@ -447,7 +447,7 @@ static int xctr_crypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
 	u8 keystream[AES_BLOCK_SIZE];
-	struct skcipher_walk walk;
+	struct skcipher_walk walk = {};
 	unsigned int nbytes;
 	unsigned int byte_ctr = 0;
 	int err;
@@ -517,7 +517,7 @@ xts_crypt_slowpath(struct skcipher_request *req, xts_crypt_func crypt_func)
 	int tail = req->cryptlen % AES_BLOCK_SIZE;
 	struct scatterlist sg_src[2], sg_dst[2];
 	struct skcipher_request subreq;
-	struct skcipher_walk walk;
+	struct skcipher_walk walk = {};
 	struct scatterlist *src, *dst;
 	int err;
 
@@ -1339,7 +1339,7 @@ gcm_crypt(struct aead_request *req, int flags)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	const struct aes_gcm_key *key = aes_gcm_key_get(tfm, flags);
 	unsigned int assoclen = req->assoclen;
-	struct skcipher_walk walk;
+	struct skcipher_walk walk = {};
 	unsigned int nbytes;
 	u8 ghash_acc[16]; /* GHASH accumulator */
 	u32 le_ctr[4]; /* Counter in little-endian format */
-- 
2.46.1

