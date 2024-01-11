Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8A215AC5
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 12:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tiEueNP9"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d9a541b720aso7073640276.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 04:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704976405; x=1705581205; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1r4P+/itv3ZU+X95tsTa9mZmYFVKE80ClGK6kPu6wRQ=;
        b=tiEueNP9/4HaboDNIRMfZxQD/5zjyyA9iNt8VpEbnEgXUXVovphpi5Xw4G/KjwNJoG
         8quWULRAxdivoD932EDXBSWwezyjDbeAGrO3dBnr9ODrspIcn7AnFac5CQszbGVqd42G
         8xiVlGbmNTE43z5t/guU2MNK2B8cgu4ikr2gKPfYOdtn8nhv5n0mq4y9QriwDooM7PxK
         CWh/jWsFoI8hX6IZ6kvMEV6QNZe+ws4mX2XykcOPOPOMEWiivHh4XGvVD2EOiKzCsQh9
         t+RrHDpaAyeRfcPsjbi61XiZ11j2LfAJBbSAfkpNtdtawbDCHYwu3CFrgeTfjHQeLSax
         I9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976405; x=1705581205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1r4P+/itv3ZU+X95tsTa9mZmYFVKE80ClGK6kPu6wRQ=;
        b=IvaEbF3E9WdI7HkI7VCcK27WaAAivDiWjxqPRCd2qIibZulB2+j14DIK/T7DPhffIU
         vmqrqBmPImHadpF6dWKkZ1xbjHhRv9ftqXGn42bKEVrzBmlV59O/q+rue/7Rc3crFXZP
         YaGBBIlNW5hUSZMEyM3mYTxUFcdTJSAd3anMTBXP1B82qEdqqy2XjT041F22XwfIuckq
         iGNMAQjKuhOxA/3q65YMt2/1Dus3aVnc4Yod7UUYxrXvX4Z6csSfRuoz3wIfaI+QfpsH
         wXD2MrCtpz5Hwwsa9AfZm7Z1pnJWpdQpmBHt8WMgq4j4dwUR+pxMAQaAEF/4uGWuCpdh
         fspQ==
X-Gm-Message-State: AOJu0YwWIsGfn+3VA06JVee54EAXPWUAmiC5CtGyBefV1DM8wGJCUzjp
	JN44EPh+cjWTe5wdCMMxYBSWgW41fWOvmvDP2jvvME6OTm7LIGQIZ+tm/Op03+z8klUX+Jvkw0b
	Ej6B6JBX6J31ALgdv9iDvTPYdeCxAWx6VrXGXd+pF4u4GMOcvTRWTnxmIbNu9w5yqNjIYVEs=
X-Google-Smtp-Source: AGHT+IFZ+w0pXnhEuIt5QjyyfDZ6Y28NLSyTv1QBugcUTAoHS4xRHg2dTYYRphLtevBSfgkhBCEfOKGt
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:6902:18c1:b0:dbe:23c0:baaf with SMTP id
 ck1-20020a05690218c100b00dbe23c0baafmr459335ybb.6.1704976405198; Thu, 11 Jan
 2024 04:33:25 -0800 (PST)
Date: Thu, 11 Jan 2024 13:33:04 +0100
In-Reply-To: <20240111123302.589910-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111123302.589910-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4040; i=ardb@kernel.org;
 h=from:subject; bh=6y8C/lj/zNWs2gTnw3E09HW8DY1N4ZPhG1WnxorPOHQ=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXX+/f+r+52usPqtF19xWuyzruavl19P3r1xbc/CN9bRa
 6IN1mgFdZSyMIhxMMiKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJPL7G8N/9/bkz8ySjVDPV
 hA++zW5pbYjI3/bTRdByy5LEgg0GPFMZGbqm13c08JpWfbn2d0L9TxutI7IsXNmOOb3KV33NjQq U2QA=
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111123302.589910-11-ardb+git@google.com>
Subject: [PATCH 1/8] crypto: arm64/aes-ccm - Revert "Rewrite skcipher walker loop"
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

This reverts commit 57ead1bf1c54, which updated the CCM code to only
rely on walk.nbytes to check for failures returned from the skcipher
walk API, mostly for the common good rather than to fix a particular
problem in the code.

This change introduces a problem of its own: the skcipher walk is
started with the 'atomic' argument set to false, which means that the
skcipher walk API is permitted to sleep. Subsequently, it invokes
skcipher_walk_done() with preemption disabled on the final iteration of
the loop. This appears to work by accident, but it is arguably a bad
example, and providing a better example was the point of the original
patch.

Given that future changes to the CCM code will rely on the original
behavior of entering the loop even for zero sized inputs, let's just
revert this change entirely, and proceed from there.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 57 +++++++++++---------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 25cd3808ecbe..c4f14415f5f0 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -161,39 +161,43 @@ static int ccm_encrypt(struct aead_request *req)
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
+	if (unlikely(err))
+		return err;
 
 	kernel_neon_begin();
 
 	if (req->assoclen)
 		ccm_calculate_auth_mac(req, mac);
 
-	while (walk.nbytes) {
+	do {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
-		bool final = walk.nbytes == walk.total;
 
-		if (final)
+		if (walk.nbytes == walk.total)
 			tail = 0;
 
 		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   walk.nbytes - tail, ctx->key_enc,
 				   num_rounds(ctx), mac, walk.iv);
 
-		if (!final)
-			kernel_neon_end();
-		err = skcipher_walk_done(&walk, tail);
-		if (!final)
-			kernel_neon_begin();
-	}
+		if (walk.nbytes == walk.total)
+			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-	ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		kernel_neon_end();
 
-	kernel_neon_end();
+		if (walk.nbytes) {
+			err = skcipher_walk_done(&walk, tail);
+			if (unlikely(err))
+				return err;
+			if (unlikely(walk.nbytes))
+				kernel_neon_begin();
+		}
+	} while (walk.nbytes);
 
 	/* copy authtag to end of dst */
 	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(aead), 1);
 
-	return err;
+	return 0;
 }
 
 static int ccm_decrypt(struct aead_request *req)
@@ -215,36 +219,37 @@ static int ccm_decrypt(struct aead_request *req)
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
+	if (unlikely(err))
+		return err;
 
 	kernel_neon_begin();
 
 	if (req->assoclen)
 		ccm_calculate_auth_mac(req, mac);
 
-	while (walk.nbytes) {
+	do {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
-		bool final = walk.nbytes == walk.total;
 
-		if (final)
+		if (walk.nbytes == walk.total)
 			tail = 0;
 
 		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   walk.nbytes - tail, ctx->key_enc,
 				   num_rounds(ctx), mac, walk.iv);
 
-		if (!final)
-			kernel_neon_end();
-		err = skcipher_walk_done(&walk, tail);
-		if (!final)
-			kernel_neon_begin();
-	}
+		if (walk.nbytes == walk.total)
+			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-	ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		kernel_neon_end();
 
-	kernel_neon_end();
-
-	if (unlikely(err))
-		return err;
+		if (walk.nbytes) {
+			err = skcipher_walk_done(&walk, tail);
+			if (unlikely(err))
+				return err;
+			if (unlikely(walk.nbytes))
+				kernel_neon_begin();
+		}
+	} while (walk.nbytes);
 
 	/* compare calculated auth tag with the stored one */
 	scatterwalk_map_and_copy(buf, req->src,
-- 
2.43.0.275.g3460e3d667-goog

