Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5553AA4E6
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413618; cv=none; b=J9XMlI5WePddRHTc7XGeMiCG8I3W2K5vn9/sjpEGmvhpiIDGyheptJrCMbV29dWz4mzxBKzB48SuhrPPFnwiOvS0XKLm5/SqB0PesCvOTA/wI3m/reweS2KvSVX3Y7OC8oXqbNGKku5t0cGM6ZgnyvL/lttMzYftoE1EdixkB70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413618; c=relaxed/simple;
	bh=mdwBFN8K5RDWuWmVmv54KlMzvSeOOo5UhSbsJBxJ9ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y0X0bsqsRxIMbwG9SUIJx2uuQk4MiZa3YTC0EL//2opltJJmOoD87tF+PlPjV3Q5QZpv3RNEnlvcozxRCcceZbBfrV4kt3FVfdQSd+5ktWlII+GSIcou6TNXg5JVFME5Mq0StHkFHeyzi1ns7cqCvkIi1ZmA0mafXH3KsUU0Bgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mxFD9SvI; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mxFD9SvI"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-829759ca646so1352667b3a.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 07:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773413615; x=1774018415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yhl5+IeUuVzO44nLBI8orasuKnNyReJagrIJl9tDNnw=;
        b=mxFD9SvIOTPlP0Ll+aTtVOCi4doNUYq2TA+x1MQUiGIJKRKblh4i/EVQLlB08K8fHF
         ejU2EI9P5+66/dmSqKQmE3+2ELeh/+oZy8Sn7NFL8qRDYtg+awPXgGsD6vcQCHJe4UYD
         qEfI6znndNj6sVGrUCPOQbSQU1owX/cU7C8gFNHU/SB5A1vVPlVF2I/pKi1FmqAAYY/p
         j7zlFksAC3aZTF6kzrFzsz2HpCHFh8PvrQkWmhduNuvEMtYhODiwiXUfHMQLN4OmgorK
         8y82zodbUXwjyFC4TI23etfSazqfFSQmyfr9fn6hjvk+YQfNKH+b6JDexK8PqSftZOzw
         35wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773413615; x=1774018415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yhl5+IeUuVzO44nLBI8orasuKnNyReJagrIJl9tDNnw=;
        b=MqjFKKrGbeR98q7W+u8i0PkZleWiQRoAUkf79Y68ZZMwjrpsTD13zLd+HggrWxGJPc
         5MTL+gUd7ZffDYY5vQvgWprFen9PN+8g9GolT0sGGgWGoF+1+pT4+M/9Uu3kOroN+/5g
         I3xkMJNc7e4KAKNz3BU1F446aJ5HpZk5PIYc0R1XTTFEJxtJdwwjxHSsRbrwEA0vTG8L
         Xw45Yc/Roprc7QoYZWkPZPCi9r+9n93Y2jj5cvqzgc5FqTe7aCACg+hqwMqCByNv2sLY
         Jq8z0Y87xbQl2M6ljGNYrSEspHN340cJLJhGCw2JBh5aBjwV3QDimhtUk4sNh3FEbCaC
         5iuA==
X-Gm-Message-State: AOJu0Yy2+i4f5f5mGgIL0pdBTn4vreQ5dL+Or6+B4kEVPSE16ve6XcZL
	7IZfvlkAskIn6iDqc0qAx2kV3sxkuTkGU1fIJ50VPP2PFe8+Lepwa5MJ
X-Gm-Gg: ATEYQzzuwkJr9SJeHjmlC894/tdFaVazX/ChYaoqJ+cv5JciDGvKAMvl09dfFUlO7G1
	tlA3QqLn+j26lUhyR8+SSEv0FLv4DZMPdL9cIc8hWX7IjfJixaYdFVv4jZmCvRh/vX4UzsdHXBd
	prIRZGSzzsNEVfQMzaoWB8SEGbFVl+0cwTfCjoRjNmpKYnUYsT3Chx7SWg08hfRXSvWE8CA9vCU
	P7vfM+q72oToUljBIyg657UlbO7h1OqzkyyLZ9i/IZhwjARY4mzsoVJYLMjAh3qYzeFT9RfuMoG
	mO+8CKcF30O9jHrN9s5oaofSse4EhMia+nChMI2+pOULQkpSDtC4prSiS3lzm+UtAoLptYVtSvG
	UmBiEZo8AAPmjnjC1EgSLpfe55RHRaczmsQF7FmNXevKslTJBjAErCOqmbvwebB9bDdmQutNROc
	3pnFg0G/AvYWV2nEjpclPNTsctluJ8FE3nITA0LW3D
X-Received: by 2002:a05:6a00:138e:b0:81f:9b4c:81c0 with SMTP id d2e1a72fcca58-82a198b80e0mr3296300b3a.41.1773413615208;
        Fri, 13 Mar 2026 07:53:35 -0700 (PDT)
Received: from x540up.localdomain ([2408:8340:a629:1ce0:feaa:76fa:efb7:a761])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a0738564csm5352372b3a.58.2026.03.13.07.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 07:53:34 -0700 (PDT)
From: Sun Chaobo <suncoding913@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	suncoding913@gmail.com
Subject: [PATCH] crypto: Fix several spelling mistakes in comments
Date: Fri, 13 Mar 2026 22:52:57 +0800
Message-ID: <20260313145257.41937-1-suncoding913@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix several typos in comments and messages.
No functional change.

Signed-off-by: Sun Chaobo <suncoding913@gmail.com>
---
 crypto/drbg.c   | 2 +-
 crypto/lrw.c    | 2 +-
 crypto/tcrypt.c | 2 +-
 crypto/tea.c    | 2 +-
 crypto/xts.c    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1ed209e5d..9204e6edb 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1780,7 +1780,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 	max_addtllen = drbg_max_addtl(drbg);
 	max_request_bytes = drbg_max_request_bytes(drbg);
 	drbg_string_fill(&addtl, buf, max_addtllen + 1);
-	/* overflow addtllen with additonal info string */
+	/* overflow addtllen with additional info string */
 	len = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
 	BUG_ON(0 < len);
 	/* overflow max_bits */
diff --git a/crypto/lrw.c b/crypto/lrw.c
index dd403b800..aa31ab03a 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -134,7 +134,7 @@ static int lrw_next_index(u32 *counter)
 /*
  * We compute the tweak masks twice (both before and after the ECB encryption or
  * decryption) to avoid having to allocate a temporary buffer and/or make
- * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
+ * multiple calls to the 'ecb(..)' instance, which usually would be slower than
  * just doing the lrw_next_index() calls again.
  */
 static int lrw_xor_tweak(struct skcipher_request *req, bool second_pass)
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index aded37546..6374c86a1 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2817,7 +2817,7 @@ static int __init tcrypt_mod_init(void)
 		pr_debug("all tests passed\n");
 	}
 
-	/* We intentionaly return -EAGAIN to prevent keeping the module,
+	/* We intentionally return -EAGAIN to prevent keeping the module,
 	 * unless we're running in fips mode. It does all its work from
 	 * init() and doesn't offer any runtime functionality, but in
 	 * the fips case, checking for a successful load is helpful.
diff --git a/crypto/tea.c b/crypto/tea.c
index cb05140e3..7c66efcb5 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -2,7 +2,7 @@
 /* 
  * Cryptographic API.
  *
- * TEA, XTEA, and XETA crypto alogrithms
+ * TEA, XTEA, and XETA crypto algorithms
  *
  * The TEA and Xtended TEA algorithms were developed by David Wheeler 
  * and Roger Needham at the Computer Laboratory of Cambridge University.
diff --git a/crypto/xts.c b/crypto/xts.c
index 3da8f5e05..ad97c8091 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -76,7 +76,7 @@ static int xts_setkey(struct crypto_skcipher *parent, const u8 *key,
 /*
  * We compute the tweak masks twice (both before and after the ECB encryption or
  * decryption) to avoid having to allocate a temporary buffer and/or make
- * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
+ * multiple calls to the 'ecb(..)' instance, which usually would be slower than
  * just doing the gf128mul_x_ble() calls again.
  */
 static int xts_xor_tweak(struct skcipher_request *req, bool second_pass,
-- 
2.53.0

