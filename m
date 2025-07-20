Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB1E382
	for <linux-crypto@vger.kernel.org>; Sun, 20 Jul 2025 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753036054; cv=none; b=Jlqnv/o8QQtxDGXbTGO6rhm5DwBcTxmkDj+ORI2S12oOHR+6eJxXjrrwaEvfEh5TT3/146ajN0gDLgU0T1u4y2lzXQ9QAG/X95zFp03RU1NZoMCtEGBVNw8s7coBZe6Nnmr8iOC9918c0zFXuP37RW+C5uOy4s3CeU3buqxW8fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753036054; c=relaxed/simple;
	bh=X5xqs1ZP4P2RhnBgNzZid0V1n/QQZPwqie8VhCKeGfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o/3xEVxaLzzK3d2RklX0hPGsY9RScWZvTmQEZrqrXNMKKNQNs/7d1BDwT67XjUXHwM5MRw5eJ86oHfK2Jlx/c/4O0PBratT4m/eLDaQ+kuA+3yNjTTEH+Rek0hNR40HQAoR71n7t8vCsg/fo0jMX9r1dlw8gwLf7bL8o+OD3Vm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HRQHuVxZ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HRQHuVxZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753036040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KEkcY99JjeRt6Kj8QpuGyp3e5YKfE6FffJwx4zakCNE=;
	b=HRQHuVxZJ56WcWGTQDyJKlDbffAoZe9YzaqooFMdD2Z/BI309pI8IDSWt33iIYpuG+ZWap
	zS5rbkQFryiv0uXYPmVlXVl5/o2n8xqGNYK53AHwIqkivygZRoWOe1AmXdBlUSqSPEoFbz
	ABQkYNbItNiko+dhI7z38xmnZjpF8sE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: keembay - Use min() to simplify ocs_create_linked_list_from_sg()
Date: Sun, 20 Jul 2025 20:26:05 +0200
Message-ID: <20250720182605.427375-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use min() to simplify ocs_create_linked_list_from_sg() and improve its
readability.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/intel/keembay/ocs-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/keembay/ocs-aes.c b/drivers/crypto/intel/keembay/ocs-aes.c
index be9f32fc8f42..b69e7bfce9cc 100644
--- a/drivers/crypto/intel/keembay/ocs-aes.c
+++ b/drivers/crypto/intel/keembay/ocs-aes.c
@@ -7,6 +7,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
+#include <linux/minmax.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/swab.h>
@@ -1473,8 +1474,7 @@ int ocs_create_linked_list_from_sg(const struct ocs_aes_dev *aes_dev,
 	ll = dll_desc->vaddr;
 	for (i = 0; i < dma_nents; i++, sg = sg_next(sg)) {
 		ll[i].src_addr = sg_dma_address(sg) + data_offset;
-		ll[i].src_len = (sg_dma_len(sg) - data_offset) < data_size ?
-				(sg_dma_len(sg) - data_offset) : data_size;
+		ll[i].src_len = min(sg_dma_len(sg) - data_offset, data_size);
 		data_offset = 0;
 		data_size -= ll[i].src_len;
 		/* Current element points to the DMA address of the next one. */
-- 
2.50.1

