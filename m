Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF8C2F90C4
	for <linux-crypto@vger.kernel.org>; Tue, 13 Jan 2026 08:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768293111; cv=none; b=AH+qOCJwlO4/g8w13QucJ1j6X0TAi8MZe0rKablHGylT6Ci8BTHm3fjkSZCouMqmZG0ZEHeUyMqxMyxNT8rFOHE7vEq3roe1Fvku5E5fRoXldCY9OzNG09MD/ucX3sRwkwzLTT4NvMS2CICSnYSBN1dNimcDMMaEXUyaXLZSS+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768293111; c=relaxed/simple;
	bh=/bhAza7HHqUpiMJ6qKzY3dKoSlgYXI91zK2ulsYpzok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Us5d9Gt+8wg9bTwtdsUBxuLDZa/f62oRUhne8Q1eswIvfi/+Rn5woBZcw+HG5fgE+4hJSoSHFJpcpRS3ZyuVWbCv0xnekMgL+bfYw7ySN/qkJE2h9fQH54VaupQJ5laMWoWSdPqQWSoOVe+sxaMPJXTNQVfaUmCTt4pZTvIjUOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iEdkK8qB; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iEdkK8qB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768293107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5s+0rDdp0xucx1mfaPO37Eu5HjJOMe4rckgTaeXS34k=;
	b=iEdkK8qBk9VWUL0M3zQikilw1NJeTx6un8VSq0b+VCtVm3MvKEX5LIcodzALPIFuXLDv+2
	epebbRxlV9Dm209cjSzVpO2vmX4U0cu+FTTMbarWYrxPKv+MnImQJ/XhUBxOAzvRWMCnYm
	b5e4YqOXYz3iswna0CMjRc475tuyAP0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	=?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
	Eric Biggers <ebiggers@google.com>,
	Colin Ian King <colin.i.king@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: stm32 - Replace min_t(size_t) with just min()
Date: Tue, 13 Jan 2026 09:31:28 +0100
Message-ID: <20260113083130.790316-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In most cases, min_t(size_t) and explicit casting are unnecessary
because the values ->hw_blocksize, ->payload_{in,out}, and ->header_in
are already of type 'size_t'. Use the simpler min() macro instead.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/stm32/stm32-cryp.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 5e82e8a1f71a..d206eddb67bf 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/minmax.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -1922,20 +1923,19 @@ static void stm32_cryp_irq_read_data(struct stm32_cryp *cryp)
 	u32 block[AES_BLOCK_32];
 
 	readsl(cryp->regs + cryp->caps->dout, block, cryp->hw_blocksize / sizeof(u32));
-	memcpy_to_scatterwalk(&cryp->out_walk, block, min_t(size_t, cryp->hw_blocksize,
-							    cryp->payload_out));
-	cryp->payload_out -= min_t(size_t, cryp->hw_blocksize,
-				   cryp->payload_out);
+	memcpy_to_scatterwalk(&cryp->out_walk, block, min(cryp->hw_blocksize,
+							  cryp->payload_out));
+	cryp->payload_out -= min(cryp->hw_blocksize, cryp->payload_out);
 }
 
 static void stm32_cryp_irq_write_block(struct stm32_cryp *cryp)
 {
 	u32 block[AES_BLOCK_32] = {0};
 
-	memcpy_from_scatterwalk(block, &cryp->in_walk, min_t(size_t, cryp->hw_blocksize,
-							     cryp->payload_in));
+	memcpy_from_scatterwalk(block, &cryp->in_walk, min(cryp->hw_blocksize,
+							   cryp->payload_in));
 	writesl(cryp->regs + cryp->caps->din, block, cryp->hw_blocksize / sizeof(u32));
-	cryp->payload_in -= min_t(size_t, cryp->hw_blocksize, cryp->payload_in);
+	cryp->payload_in -= min(cryp->hw_blocksize, cryp->payload_in);
 }
 
 static void stm32_cryp_irq_write_gcm_padded_data(struct stm32_cryp *cryp)
@@ -1980,10 +1980,9 @@ static void stm32_cryp_irq_write_gcm_padded_data(struct stm32_cryp *cryp)
 	 */
 	readsl(cryp->regs + cryp->caps->dout, block, cryp->hw_blocksize / sizeof(u32));
 
-	memcpy_to_scatterwalk(&cryp->out_walk, block, min_t(size_t, cryp->hw_blocksize,
-							    cryp->payload_out));
-	cryp->payload_out -= min_t(size_t, cryp->hw_blocksize,
-				   cryp->payload_out);
+	memcpy_to_scatterwalk(&cryp->out_walk, block, min(cryp->hw_blocksize,
+							  cryp->payload_out));
+	cryp->payload_out -= min(cryp->hw_blocksize, cryp->payload_out);
 
 	/* d) change mode back to AES GCM */
 	cfg &= ~CR_ALGO_MASK;
@@ -2078,9 +2077,9 @@ static void stm32_cryp_irq_write_ccm_padded_data(struct stm32_cryp *cryp)
 	 */
 	readsl(cryp->regs + cryp->caps->dout, block, cryp->hw_blocksize / sizeof(u32));
 
-	memcpy_to_scatterwalk(&cryp->out_walk, block, min_t(size_t, cryp->hw_blocksize,
-							    cryp->payload_out));
-	cryp->payload_out -= min_t(size_t, cryp->hw_blocksize, cryp->payload_out);
+	memcpy_to_scatterwalk(&cryp->out_walk, block, min(cryp->hw_blocksize,
+							  cryp->payload_out));
+	cryp->payload_out -= min(cryp->hw_blocksize, cryp->payload_out);
 
 	/* d) Load again CRYP_CSGCMCCMxR */
 	for (i = 0; i < ARRAY_SIZE(cstmp2); i++)
@@ -2158,7 +2157,7 @@ static void stm32_cryp_irq_write_gcmccm_header(struct stm32_cryp *cryp)
 	u32 block[AES_BLOCK_32] = {0};
 	size_t written;
 
-	written = min_t(size_t, AES_BLOCK_SIZE, cryp->header_in);
+	written = min(AES_BLOCK_SIZE, cryp->header_in);
 
 	memcpy_from_scatterwalk(block, &cryp->in_walk, written);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

