Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3253237E31E
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 04:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776660038; cv=none; b=LLezTBZTm/gagE56o2ftOEUj7mhKkvK+zUlmw2umaMypEistBya+P2DmLhyLcUSHuSnkGOAxuPN5Iud8iP6WSZz8ZzCpbE3T/knNXllLAhEDJqkWtZTcWxvpHJqDej1ifbD/ozwcEh0yGd0Q9TQ45VmtQiCa8QbOILVjeCpNUeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776660038; c=relaxed/simple;
	bh=x2ZPuLXVjSunwvX+LttAGekckIQQ7d0H+3W+QWAgtdk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h9RckO8+TQrsFjFmfemIUqboDOVw4Vz1IyzJVIgyWq5g3bAZEfyTcgbjnZ318MPQ1AAvGsaO+B6uSNk+jRM6oP60FwnIy7YnUD0WCtKc2nKM+4dD7s3KzlM4re/Aw1NqBe5hnULp/aFYFXBPxo/bIohtWCuqYNFaEQWlXRaMKVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e67lTRGm; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e67lTRGm"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3590042fa8eso1845815a91.1
        for <linux-crypto@vger.kernel.org>; Sun, 19 Apr 2026 21:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776660036; x=1777264836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mHOwjSuH+ifukyfbMxWURVHsMLaEmqyyv0eM8V2bFvk=;
        b=e67lTRGmm0u7II2dpES7JDJa6S/yaL/15EYAl5boNjPgjtZXEoXkH7saaeQoT3Ioqf
         rEi26qh09GTJngtkl59ZWvjK5mi3QZj8hlu4jIR6dT7icEffk/VYmQVWejOtR2Y5/QpL
         g63Cx4U2/hqPAKlPM6q9TEm8K3MbVuR65OFUNo4boowM5B4syZYISm2/PpYUaw+4exT/
         Kh4H17Y8Wogmcbhz+np05bx0ysk8Y7lF+bIIjj0Z2zzyQulLDbhqfnI94CKfiLweyhCi
         OKkUPhSnYdynEjQc4onqyvGuWIqT/ko8p4BD3dZr+Xl/6P4zlmhzf4R68Azb4y/H0LjA
         UByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776660036; x=1777264836;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mHOwjSuH+ifukyfbMxWURVHsMLaEmqyyv0eM8V2bFvk=;
        b=VK+B/AhfAWVBiCjOdUHuk9xLtAvrx7KVU+bke3kqYWcbHmKW/bLxXQEpP3ARD8fRDI
         jrUDALoryJ5ithc72MqwY6DLoPk0Cu/naVL929ItKbMnHee6CXP2kO3EkD2/7r4KAu9P
         24Ep9bunHDbtQatZso9Xc5+j3oVEk34lHemAQO09Lcd/tnTY+gzHfG7XLvgJ6M0jOHn5
         EveNzPOKcnh4hq9W5JhPMO0+rr5rMc0nayM7HuA50/l4zucij0Q8Vmn9sWFf5/h5oWzu
         1noXNhNAZYSzvr1WLzYDQmkOA+B9PRkR9dkCtbTZjsE/Ip3bBfgMPhwVyZAahuPysXoB
         Q0AQ==
X-Gm-Message-State: AOJu0Yzwb144CFAqA3nOG0XxK3HCphJUqv1MwcJ+CjecjmkReAl63lK2
	Vz7BKNxL+igN8PXHDhlstu/21CBm46Ab7icERaNQJvWUpbMU5cc/xSvGM3fs9w==
X-Gm-Gg: AeBDietolpTBMLWf0EaeGZ8obVyNbcuga5gfy4c4Y8J7+Qn1GO/1ZFa5iFEFc8cDp/W
	wOhO7Q/kWCtA9jtnbSKkDBMR3buVLxl8dVbNsYFyNFNhadZk/nXG3bWpoXidFMMLT0TG+99Qx/6
	TWRrzuAU8vm30RPbIOk/OLke+egfNT3sCbpgOf58v/Tzo5uHTeVtcV/2hC0HJ9ujAqXtc2j/p2F
	BpCy9mzVcRwQXjmA3Ig97CdAJCS0c8jcBFvoXcJbnY+C9kgROBSxKkGcY/9RqfpmxrRHddlnWmz
	mCL8J+KKmxHDtaoTKppyjvwlBpxjnakzvdDIOtszmWrKwcPw+q2I4J/WmoLdtRhbCtFdyo3pRZA
	L6YWsiXxtzBR5QHYkyIkNnGiYXdgcbilfGdAhNUZE2SXtr4ShN1g6r+L16bszFf5n7SOoLQAA60
	r21Tnd3ku4JtzqLyYqgZvL8c31zZRhwCfSjEmTGde3CC7x5c+tymmio2fsAdqd+jmR5yWGB5ev7
	qq1q9YLI/imjw==
X-Received: by 2002:a17:90a:d40d:b0:35b:e5ce:73bb with SMTP id 98e67ed59e1d1-361403d61d5mr12494469a91.1.1776660036203;
        Sun, 19 Apr 2026 21:40:36 -0700 (PDT)
Received: from localhost.localdomain (69-172-89-235.static.imsbiz.com. [69.172.89.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3614186adddsm9147211a91.2.2026.04.19.21.40.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Apr 2026 21:40:35 -0700 (PDT)
From: Dudu Lu <phx0fer@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Dudu Lu <phx0fer@gmail.com>
Subject: [PATCH] crypto: krb5enc - fix async decrypt skipping hash verification
Date: Mon, 20 Apr 2026 12:40:27 +0800
Message-Id: <20260420044027.56413-1-phx0fer@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

krb5enc_dispatch_decrypt() sets req->base.complete as the skcipher
callback, which is the caller's own completion handler. When the
skcipher completes asynchronously, this signals "done" to the caller
without executing krb5enc_dispatch_decrypt_hash(), completely bypassing
the integrity verification (hash check).

Compare with the encrypt path which correctly uses
krb5enc_encrypt_done as an intermediate callback to chain into the
hash computation on async completion.

Fix by adding krb5enc_decrypt_done as an intermediate callback that
chains into krb5enc_dispatch_decrypt_hash() upon async skcipher
completion, matching the encrypt path's callback pattern.

Also fix EBUSY/EINPROGRESS handling throughout: remove
krb5enc_request_complete() which incorrectly swallowed EINPROGRESS
notifications that must be passed up to callers waiting on backlogged
requests, and add missing EBUSY checks in krb5enc_encrypt_ahash_done
for the dispatch_encrypt return value.

Fixes: d1775a177f7f ("crypto: Add 'krb5enc' hash and cipher AEAD algorithm")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
---
 crypto/krb5enc.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/crypto/krb5enc.c b/crypto/krb5enc.c
index a1de55994d92..2df7d4c3baed 100644
--- a/crypto/krb5enc.c
+++ b/crypto/krb5enc.c
@@ -39,12 +39,6 @@ struct krb5enc_request_ctx {
 	char tail[];
 };
 
-static void krb5enc_request_complete(struct aead_request *req, int err)
-{
-	if (err != -EINPROGRESS)
-		aead_request_complete(req, err);
-}
-
 /**
  * crypto_krb5enc_extractkeys - Extract Ke and Ki keys from the key blob.
  * @keys: Where to put the key sizes and pointers
@@ -127,7 +121,7 @@ static void krb5enc_encrypt_done(void *data, int err)
 {
 	struct aead_request *req = data;
 
-	krb5enc_request_complete(req, err);
+	aead_request_complete(req, err);
 }
 
 /*
@@ -188,13 +182,16 @@ static void krb5enc_encrypt_ahash_done(void *data, int err)
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
 
 	if (err)
-		return krb5enc_request_complete(req, err);
+		goto out;
 
 	krb5enc_insert_checksum(req, ahreq->result);
 
 	err = krb5enc_dispatch_encrypt(req, 0);
-	if (err != -EINPROGRESS)
-		aead_request_complete(req, err);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return;
+
+out:
+	aead_request_complete(req, err);
 }
 
 /*
@@ -264,11 +261,9 @@ static void krb5enc_decrypt_hash_done(void *data, int err)
 {
 	struct aead_request *req = data;
 
-	if (err)
-		return krb5enc_request_complete(req, err);
-
-	err = krb5enc_verify_hash(req);
-	krb5enc_request_complete(req, err);
+	if (!err)
+		err = krb5enc_verify_hash(req);
+	aead_request_complete(req, err);
 }
 
 /*
@@ -300,6 +295,21 @@ static int krb5enc_dispatch_decrypt_hash(struct aead_request *req)
 	return krb5enc_verify_hash(req);
 }
 
+static void krb5enc_decrypt_done(void *data, int err)
+{
+	struct aead_request *req = data;
+
+	if (err)
+		goto out;
+
+	err = krb5enc_dispatch_decrypt_hash(req);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return;
+
+out:
+	aead_request_complete(req, err);
+}
+
 /*
  * Dispatch the decryption of the ciphertext.
  */
@@ -323,7 +333,7 @@ static int krb5enc_dispatch_decrypt(struct aead_request *req)
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, aead_request_flags(req),
-				      req->base.complete, req->base.data);
+				      krb5enc_decrypt_done, req);
 	skcipher_request_set_crypt(skreq, src, dst,
 				   req->cryptlen - authsize, req->iv);
 
-- 
2.39.3 (Apple Git-145)

