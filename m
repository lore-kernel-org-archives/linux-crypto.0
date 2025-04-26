Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F3E7494
	for <linux-crypto@vger.kernel.org>; Sat, 26 Apr 2025 22:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745706437; cv=none; b=M0plTiKnRKIUcg05W9Cn8+Hota1jQn8Cwk3p0jHebAkTxCITIQRXi78wseLoIXiBfvj2meETzpEOT7F5XPiHQzw13Iw5uFWJS+OWIBUAwIvYIKx1kzFe1tBQzKmJ5fOCKoa0zdz4zh3BSRzkM6f0UW5NfujBuF1NSSd+ac7Dopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745706437; c=relaxed/simple;
	bh=y3wv2i7dz7Xe1WPxWtb+hFLK/z0p4b6qQp7XfLjl3Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rtzc/cLiYfBjR2sILy+lxopcVDhp86PCU7yzUfqJgnWb3Py3fbm/X4QWQPaZiA96WBp4u9Aa62EKo9c7MMuYknb1pTjlhX+Dz58bW9Z58TRsyGq7VNEY74Mk3+i3iKbxRMmSdWR7gAydl5b0Wtja8H94kKUpQ5ZwgwfPDe2cp10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vU4OvdYa; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vU4OvdYa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745706433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dStqifmk7S+BpETVzABU1ARJ7nrE33RR05tHBW+iFOo=;
	b=vU4OvdYabyV72CURL9pSiBs5PU6a8qwqXNK0pm4/HQBbjU/mXSnWunzOaAA/ePxvlp3Cjr
	/BQTWltn9BxxWZD6fR4uw8lQQZBs7igED8hZOKTPRrSdwrmVZ31wqPKWYZaCKdWUdWQXcz
	l1LAgfh1Odit+MGYwdJ8L+ps2nhn+Ss=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: octeontx2 - Simplify multiple return statements
Date: Sun, 27 Apr 2025 00:26:19 +0200
Message-ID: <20250426222621.2104-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Simplify multiple return statements by directly returning the boolean
expressions.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 .../marvell/octeontx2/otx2_cpt_common.h       | 34 ++++++-------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index c5b7c57574ef..84f2bb0ca11c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -145,11 +145,8 @@ static inline u64 otx2_cpt_read64(void __iomem *reg_base, u64 blk, u64 slot,
 
 static inline bool is_dev_otx2(struct pci_dev *pdev)
 {
-	if (pdev->device == OTX2_CPT_PCI_PF_DEVICE_ID ||
-	    pdev->device == OTX2_CPT_PCI_VF_DEVICE_ID)
-		return true;
-
-	return false;
+	return pdev->device == OTX2_CPT_PCI_PF_DEVICE_ID ||
+	       pdev->device == OTX2_CPT_PCI_VF_DEVICE_ID;
 }
 
 static inline bool is_dev_cn10ka(struct pci_dev *pdev)
@@ -159,12 +156,10 @@ static inline bool is_dev_cn10ka(struct pci_dev *pdev)
 
 static inline bool is_dev_cn10ka_ax(struct pci_dev *pdev)
 {
-	if (pdev->subsystem_device == CPT_PCI_SUBSYS_DEVID_CN10K_A &&
-	    ((pdev->revision & 0xFF) == 4 || (pdev->revision & 0xFF) == 0x50 ||
-	     (pdev->revision & 0xff) == 0x51))
-		return true;
-
-	return false;
+	return pdev->subsystem_device == CPT_PCI_SUBSYS_DEVID_CN10K_A &&
+	       ((pdev->revision & 0xFF) == 4 ||
+		(pdev->revision & 0xFF) == 0x50 ||
+		(pdev->revision & 0xFF) == 0x51);
 }
 
 static inline bool is_dev_cn10kb(struct pci_dev *pdev)
@@ -174,11 +169,8 @@ static inline bool is_dev_cn10kb(struct pci_dev *pdev)
 
 static inline bool is_dev_cn10ka_b0(struct pci_dev *pdev)
 {
-	if (pdev->subsystem_device == CPT_PCI_SUBSYS_DEVID_CN10K_A &&
-	    (pdev->revision & 0xFF) == 0x54)
-		return true;
-
-	return false;
+	return pdev->subsystem_device == CPT_PCI_SUBSYS_DEVID_CN10K_A &&
+	       (pdev->revision & 0xFF) == 0x54;
 }
 
 static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
@@ -192,18 +184,12 @@ static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
 
 static inline bool cpt_is_errata_38550_exists(struct pci_dev *pdev)
 {
-	if (is_dev_otx2(pdev) || is_dev_cn10ka_ax(pdev))
-		return true;
-
-	return false;
+	return is_dev_otx2(pdev) || is_dev_cn10ka_ax(pdev);
 }
 
 static inline bool cpt_feature_sgv2(struct pci_dev *pdev)
 {
-	if (!is_dev_otx2(pdev) && !is_dev_cn10ka_ax(pdev))
-		return true;
-
-	return false;
+	return !is_dev_otx2(pdev) && !is_dev_cn10ka_ax(pdev);
 }
 
 int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
-- 
2.49.0

