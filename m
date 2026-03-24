Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9663E558F
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 11:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351655; cv=none; b=tUAGdbAiKmQGX9CbJ9le+eGL/dloatmSxLfXZ7Fn+F+gkVSzstxMk5T2xFIDUw5IVI64DqkiyeD5UobKfI9PO+8fJEVT+tc3TqJ1szpEjKniU6hkJ79bJxsfJooefItLHtBYh85Svr49WOhSFBJd7EUkAlRU1Cpi5gN9O/R6j20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351655; c=relaxed/simple;
	bh=j2OPAl+SveGv2rqOW2bNGBFPaFwznwlHpIiFdQ6UZ88=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tEoA5+7b3UWn194ZT9CMG+SQLSR/40XLryLh/j/n5RP3LoXhKVimXqaS6s1A+rOmGx/EllJZHXNHGf4iyeUrWPNZixxMnXBA0ohbTGuY+t4HOLUsqbxV4XaweAa3p+ylLMo/wd2VWu127F1bSCQ8K7+NVKi7JHMkfXxl/Hy5/dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E/GXtiNH; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E/GXtiNH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774351652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rD8r+L4ewlCmSe6Mc1BgIUAya3UWUPOpi16rXKFsJGo=;
	b=E/GXtiNHq41iQVw39I0E4iRYYd2z+wED+YpqsON6vPaEJ9SqySyVZC0M1UqBv3EW+X/FsN
	V8uiN20s7ZoxfFKW037gthdvccBsjlxORzPqUgZhrasJABpdwBDVcjSNiFXd0pnnetj+h4
	B8TZAtXpzjo5/C3PpaeYrb4G1xMzcgg=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hifn_795x - Replace snprintf("%s") with strscpy
Date: Tue, 24 Mar 2026 12:27:05 +0100
Message-ID: <20260324112703.94917-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1467; i=thorsten.blum@linux.dev; h=from:subject; bh=j2OPAl+SveGv2rqOW2bNGBFPaFwznwlHpIiFdQ6UZ88=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJmHStlPHkqoPSvwNjovtvb3O9+GT4taYjecsukISPi/Q UKulyGzo5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACZi/ZzhD3/Hw7vtixTep8n9 uTyn1Z6hxnP7y6idt4KWsIjoHvg0Zwkjw/Y/66+xvcz32s23t6GMiyNPXeBqXXjlk7XH7xceei3 sygUA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace snprintf("%s", ...) with the faster and more direct strscpy().
Check if the return value is less than 0 to detect string truncation.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/hifn_795x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index edf36f6add52..afea061c3070 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
+#include <linux/string.h>
 #include <linux/highmem.h>
 #include <linux/crypto.h>
 #include <linux/hw_random.h>
@@ -2256,8 +2257,7 @@ static int hifn_alg_alloc(struct hifn_device *dev, const struct hifn_alg_templat
 	alg->alg.init = hifn_init_tfm;
 
 	err = -EINVAL;
-	if (snprintf(alg->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "%s", t->name) >= CRYPTO_MAX_ALG_NAME)
+	if (strscpy(alg->alg.base.cra_name, t->name) < 0)
 		goto out_free_alg;
 	if (snprintf(alg->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "%s-%s", t->drv_name, dev->name) >= CRYPTO_MAX_ALG_NAME)
@@ -2367,7 +2367,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	INIT_LIST_HEAD(&dev->alg_list);
 
-	snprintf(dev->name, sizeof(dev->name), "%s", name);
+	strscpy(dev->name, name);
 	spin_lock_init(&dev->lock);
 
 	for (i = 0; i < 3; ++i) {
