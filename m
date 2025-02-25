Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8A32686B8;
	Tue, 25 Feb 2025 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.143.211.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740486750; cv=none; b=YKgaiRqm1ObYyOmG5qtFApABimL5t0VpFW9SQtfJhn93odTuDGbpWicGQvlYPQErUP3fRcCgX/pJb2DK4UUsIpY/5i8m++Hgb1s1tA7QpwK+WUxWk8aTnoFn3/zFQvNZyfZNvtIGhHpbZ7q3N3hwe8H21g0OS5Ktq8pww0P/dwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740486750; c=relaxed/simple;
	bh=twedXejbs0nq+ksMdQ1vMCmEi4SWHyHVxLXcEmDOJL4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gpV0YKQLe5Nw/Lq/Gcu34jdoWz0t+oHRN6UyXjOQ32bhap95LJRbCLTJNkmLVDyfnIu4iAwFcmBEBfHU1rxpMZAu8CcFH66YbJMIhe6zOO8Me7SIUXZhgQxX/Djw529akUUf++mPutgdhwWS/ydIuqT8kJlBvhg3DPhs/S2ZCVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; spf=pass smtp.mailfrom=swemel.ru; dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b=o8dGidXs; arc=none smtp.client-ip=95.143.211.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=swemel.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b="o8dGidXs"
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1740486736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HJwIHBMCpWGqDSfH1Y+aSqVcFdIzOTc9QCQgARpEMGU=;
	b=o8dGidXsz0V+1HWLVWM54KwkrcQs9fFq2tWeObizgwMb++P/7N3Qzb/ZdeLhW+mWj0804A
	9ZGbWf3CfqYu7S8dhG0sFsyDRa7e9NYGrPmEP8ATGZ1xzsbjKDrG4mwqsiSMqs73WqOmU0
	4JRJ6fhOD1K4S8oXGuxgKnoLu59XJak=
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Vitaly Chikunov <vt@altlinux.org>
Subject: [PATCH 5.10] crypto: tcrypt - Fix missing return value check
Date: Tue, 25 Feb 2025 15:32:14 +0300
Message-ID: <20250225123215.26154-1-arefev@swemel.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit 7b3d52683b3a47c0ba1dfd6b5994a3a795b06972 upstream.

There are several places where the return value check of crypto_aead_setkey
and crypto_aead_setauthsize were lost. It is necessary to add these checks.

At the same time, move the crypto_aead_setauthsize() call out of the loop,
and only need to call it once after load transform.

Fixes: 53f52d7aecb4 ("crypto: tcrypt - Added speed tests for AEAD crypto alogrithms in tcrypt test suite")
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[Denis: minor fix to resolve merge conflict.]                                           
Signed-off-by: Denis Arefev <arefev@swemel.ru> 
---
 crypto/tcrypt.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 7972d2784b3b..580c50afa587 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -290,6 +290,11 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	}
 
 	ret = crypto_aead_setauthsize(tfm, authsize);
+	if (ret) {
+		pr_err("alg: aead: Failed to setauthsize for %s: %d\n", algo,
+		       ret);
+		goto out_free_tfm;
+	}
 
 	for (i = 0; i < num_mb; ++i)
 		if (testmgr_alloc_buf(data[i].xbuf)) {
@@ -315,7 +320,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	for (i = 0; i < num_mb; ++i) {
 		data[i].req = aead_request_alloc(tfm, GFP_KERNEL);
 		if (!data[i].req) {
-			pr_err("alg: skcipher: Failed to allocate request for %s\n",
+			pr_err("alg: aead: Failed to allocate request for %s\n",
 			       algo);
 			while (i--)
 				aead_request_free(data[i].req);
@@ -565,13 +570,19 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	sgout = &sg[9];
 
 	tfm = crypto_alloc_aead(algo, 0, 0);
-
 	if (IS_ERR(tfm)) {
 		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
 		goto out_notfm;
 	}
 
+	ret = crypto_aead_setauthsize(tfm, authsize);
+	if (ret) {
+		pr_err("alg: aead: Failed to setauthsize for %s: %d\n", algo,
+		       ret);
+		goto out_noreq;
+	}
+
 	crypto_init_wait(&wait);
 	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
 			get_driver_name(crypto_aead, tfm), e);
@@ -607,8 +618,13 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 					break;
 				}
 			}
+
 			ret = crypto_aead_setkey(tfm, key, *keysize);
-			ret = crypto_aead_setauthsize(tfm, authsize);
+			if (ret) {
+				pr_err("setkey() failed flags=%x: %d\n",
+					crypto_aead_get_flags(tfm), ret);
+				goto out;
+			}
 
 			iv_len = crypto_aead_ivsize(tfm);
 			if (iv_len)
@@ -618,15 +634,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
 					i, *keysize * 8, *b_size);
 
-
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
-			if (ret) {
-				pr_err("setkey() failed flags=%x\n",
-						crypto_aead_get_flags(tfm));
-				goto out;
-			}
-
 			sg_init_aead(sg, xbuf, *b_size + (enc ? 0 : authsize),
 				     assoc, aad_size);
 
-- 
2.43.0

