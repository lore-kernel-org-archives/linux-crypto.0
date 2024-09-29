Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66497AD2F;
	Sun, 29 Sep 2024 01:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727573094; cv=none; b=CWCeDLcFXDBKbr3yH53mRywjndvWEs/nmrPMglS8Vq9ARjuSdpt2zVJpkg+6YdZClhO+3Etu064bdHDOHXGUeIllpCS7m4a6pl6KBBL7OvxlsFhqpCrsmOhaJJIw1ZmBlykOaiAB7h6DjTv14cJQ664vXrI2unMExK4GVtG6jrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727573094; c=relaxed/simple;
	bh=265DAUjUcq4+eox17EL9S3KP5DNC3weRg6P3a+3EIGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PyRoYv9qc1P+NQpeCfou6y/OZxtiehqYQ2tfdUYutkmrm46LhwHuwCeTTEDFNaXu1LPlnue+Lh/P1SE9TvxgrSPuN7m/LJ9yiAoq2Af0ETw9+uhtbWp2ay6+mE6m0uCBIm+bdqUmmq0PePpj6RVdx42Mz2Gt5slIe2D2juEYgMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=oMT6jTaR; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="oMT6jTaR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=cyho00Y/D0RN2sK64ufzlsvVId69W+370Af2hc3LCu0=; b=oMT6jTaRpy7hy49E
	pgp+sVjf3tURy9krCCDvVeo5Psgstvu71rsKzCQH9ySiAN8KbNWVB8PkujscRQeljAnvBLtljPET4
	7K2uM6fBAwZ+tlYRb/SgTVFI5xUv+t3gvWieGBm0lSXOkTnG7aLdgkcl8/NrWJ5R5qHda0pT+QnZx
	hvILxEuCYRsyqN5We3eo0bLCbMNxGyQXakzg+Stn0aG+2zOOGZwWLEkJHO+f7yOTx5TiYiRTlRWm/
	Ox7r+8169BDisL4n2jBdv9JfkIkk90KeG6A0oP6LR/lSwOIX7nMgM6j08HiKytTOTQhOhfc+Tirdl
	MKcLhc2eSq3NUDQy5g==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1suig0-007mVh-0V;
	Sun, 29 Sep 2024 01:24:44 +0000
From: linux@treblig.org
To: giovanni.cabiddu@intel.com,
	herbert@gondor.apana.org.au
Cc: qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: qat - remove unused adf_devmgr_get_first
Date: Sun, 29 Sep 2024 02:24:41 +0100
Message-ID: <20240929012442.435921-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

adf_devmgr_get_first has been unused since commit
4a4b0bad0653 ("crypto: qat - fix crypto_get_instance_node function")

Remove it.

(Build tested only, I don't own the hardware)

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h |  1 -
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c    | 10 ----------
 2 files changed, 11 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index f7ecabdf7805..eaa6388a6678 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -69,7 +69,6 @@ void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
 		       struct adf_accel_dev *pf);
 struct list_head *adf_devmgr_get_head(void);
 struct adf_accel_dev *adf_devmgr_get_dev_by_id(u32 id);
-struct adf_accel_dev *adf_devmgr_get_first(void);
 struct adf_accel_dev *adf_devmgr_pci_to_accel_dev(struct pci_dev *pci_dev);
 int adf_devmgr_verify_id(u32 id);
 void adf_devmgr_get_num_dev(u32 *num);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
index 96ddd1c419c4..34b9f7731c78 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
@@ -276,16 +276,6 @@ void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
 }
 EXPORT_SYMBOL_GPL(adf_devmgr_rm_dev);
 
-struct adf_accel_dev *adf_devmgr_get_first(void)
-{
-	struct adf_accel_dev *dev = NULL;
-
-	if (!list_empty(&accel_table))
-		dev = list_first_entry(&accel_table, struct adf_accel_dev,
-				       list);
-	return dev;
-}
-
 /**
  * adf_devmgr_pci_to_accel_dev() - Get accel_dev associated with the pci_dev.
  * @pci_dev:  Pointer to PCI device.
-- 
2.46.2

