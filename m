Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778E03FBA7
	for <linux-crypto@vger.kernel.org>; Thu, 27 Nov 2025 22:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282090; cv=none; b=X7PKQlrC2XMlx7L/qbn0WzK4sMgdeDzLE8CqmUF/7tCQJhRBnmOfmOrUUW6/Ipg+fqWjt/TjCbMirWTppTk8WjpsHSGLWkcTzZHLT/cRvooPP7iyGhVq4eh4gJMyP0zVq2HepaH+Io1wWx/8ebJY8rOwO2By0diPqapSRDa836c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282090; c=relaxed/simple;
	bh=M/5ZsuPhtWKSXNAwlbB6SkkwZ5Rc4dja+fJ2BUUa+cw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IOFPVOp9QQPmARVHblVedmFGEPL6tP++VydCX8HsPy2AAO1iujpF6Mq6s3joGjbZWp9jFgpt3ngaCrSjySx5X0jEG0vLs+DlPVFOtNbQ4wHWT15Kd6M8o5CxB2rc0uNUBhAR5kMsKw/lIhagesQL3ZUYt52Ktwl4kpzGTmATHWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UBH9CIWE; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UBH9CIWE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764282075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=volo886vM580bKB0ZE0U770fPV3kAw+OiaDNJdnadMk=;
	b=UBH9CIWEHmaez6RvzFuHAvRqYtZcy76vkgZAwrf4uveo31/ZbsGPhwjeskdHk5LP9VcrpJ
	ZLialC6Q+cpBfwGAGI1Gr5+Yo3oAh/VZqA4uuT9L2gmk7EN6HrcEMhmW9wzd9RgL4jIjMd
	Z6jviFcgBxQ1eAO5gyLFIbRgkocKbuQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: iaa - Simplify init_iaa_device()
Date: Thu, 27 Nov 2025 23:20:58 +0100
Message-ID: <20251127222058.181047-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Return the result directly to simplify init_iaa_device().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 23f585219fb4..a91d8cb83d57 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -544,13 +544,7 @@ static struct iaa_device *add_iaa_device(struct idxd_device *idxd)
 
 static int init_iaa_device(struct iaa_device *iaa_device, struct iaa_wq *iaa_wq)
 {
-	int ret = 0;
-
-	ret = init_device_compression_modes(iaa_device, iaa_wq->wq);
-	if (ret)
-		return ret;
-
-	return ret;
+	return init_device_compression_modes(iaa_device, iaa_wq->wq);
 }
 
 static void del_iaa_device(struct iaa_device *iaa_device)
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

