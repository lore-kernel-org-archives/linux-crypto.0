Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B931822E3E7
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764338106; cv=none; b=lDMYAKQdQ1ovElsJVwlqswrPbmehZUxaWD1FSkrNvQQDoPtdPrr4CjdFNLmx38p3W5z8H1Tt1PiS0F7ej8I3T6oqivKgIZqX+1jS8LkxyqXaZ67JOHy+Hexljbux+UP3++MUL2AyaH4xcVwouPsRye8hLoSSK5Ul6Jw/y5npgkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764338106; c=relaxed/simple;
	bh=6a6nY2EEaissI/IVeRD3sYuFuuMKASJRofK+xrtfxF4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U9lBOlKwTqQa6RKDFhOC2185wLucR918Lc830/zMlr2SvoTBzW8gvSJSfDYfAAELKqEnI8dcVqVGonRHrswTU0zgv39SVsWSamrscxX0WdQoBHgUIPQKE4nboodPbAP0wbGOQ5E781eq6+D9GCScPtjLpevL6cKF5Q1yz6vMPXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HO1mR5cN; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HO1mR5cN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764338099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WQlZ6HBe0P+eMFB+lzHzUJA2cphey3zA39SibqZ7jE8=;
	b=HO1mR5cNaRix3eIpTqc3fZjZW4DMcgZfEFPfO58HozUjfQElxp4vjPRZ6DH5b58rLZ7iJZ
	U66WMFh62PQaFyUD5Mc3Pi2T3/1Pn0sdSa248nNJbz3Oc+YZS9D0lCk7OjfMuZcvnMxFof
	w+rgLjy8DqKDh7CSr7QMn6PhcgDOz5I=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: iaa - Remove unreachable pr_debug from iaa_crypto_cleanup_module
Date: Fri, 28 Nov 2025 14:54:12 +0100
Message-ID: <20251128135413.2291-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

iaa_unregister_compression_device() always returns 0, making the debug
log message unreachable. Remove the log statement and convert
iaa_unregister_compression_device() to a void function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index a91d8cb83d57..83d0ff1fc7c7 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1698,12 +1698,10 @@ static int iaa_register_compression_device(void)
 	return ret;
 }
 
-static int iaa_unregister_compression_device(void)
+static void iaa_unregister_compression_device(void)
 {
 	if (iaa_crypto_registered)
 		crypto_unregister_acomp(&iaa_acomp_fixed_deflate);
-
-	return 0;
 }
 
 static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
@@ -1919,8 +1917,7 @@ static int __init iaa_crypto_init_module(void)
 
 static void __exit iaa_crypto_cleanup_module(void)
 {
-	if (iaa_unregister_compression_device())
-		pr_debug("IAA compression device unregister failed\n");
+	iaa_unregister_compression_device();
 
 	iaa_crypto_debugfs_cleanup();
 	driver_remove_file(&iaa_crypto_driver.drv,
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

