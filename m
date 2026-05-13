Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B9648094B;
	Wed, 13 May 2026 15:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685620; cv=none; b=uFuJGEE9sJ+uf3DUO5j2hUC0uc2yU4EjKXK+bybTzsvIAw1tqa+PXax/j6sy3UEq5ZtNTJWO6EGkqAEj2kBOElO27e2BMqdavhhpfSW5Y8TFBKCFbiVYYUUfvMYDFvTfA5pYc033MmR9O3U80Iqa92X/OsYS89TXuyE50CMjV/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685620; c=relaxed/simple;
	bh=GxZLA7FGuwZ6gIhXUtbqrAThF662IxRFJjz1LxqGC1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T722iLW3zBc2aNlYQ7I7ZMHYBPHFMELPNPK4wQpJpdGz0R9VcDb+i+acAcfGdj9aDOLMcXTxHGLUBYYWGnngwldXnecmdWAkw8JjX9eSrffVZzBsGBwfGp+aDLZRnPtiUqXHX5EgzfggT7jxuUN0leHt3i+Gok0HbU7NLpbrQUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FQZI1k9W; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FQZI1k9W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778685619; x=1810221619;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GxZLA7FGuwZ6gIhXUtbqrAThF662IxRFJjz1LxqGC1U=;
  b=FQZI1k9W5EiQ5YP3yio3kKkX8fvFdZiDjpls951cIF/kMhdVYAqSUO6a
   oHRpp7cAJV5ULWFeHxa8WWjzGn8GLqavuDSHrx422uK5tt6ijL+90tPIX
   CVLmnNXat8FK+93ftqPoUJBMTh0EiUSSTioVwiKk09Vqt9GsNQRCU0khH
   osMd2zUhDJLgqYcJM5DqZDt56L7pnS0+AFYKQdabowvE9JGnwBBkvvU5O
   tyAsCFO9NDq7Krfxw7Cq8l1+KeFb9yqI9BZnHahdjyAHg/3JD89b/DLmz
   0U+cYsXOJ1uzkOJElozEKFbGjGuGJIDTnMnv6zwxGmDWVa8qmuIjPtxt0
   A==;
X-CSE-ConnectionGUID: eo1IfQN1STKbyvPHipE2cg==
X-CSE-MsgGUID: BbdWGI20SoOIG2uSvTmfHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83489494"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="83489494"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 08:20:18 -0700
X-CSE-ConnectionGUID: plpbcqNRRiOHv0TdCJvDuA==
X-CSE-MsgGUID: TBtbiJNTRSqbvtt+N8oy2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="239931509"
Received: from zp3110c001s1504.deacluster.intel.com ([10.219.161.39])
  by fmviesa004.fm.intel.com with ESMTP; 13 May 2026 08:20:17 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: [PATCH 3/6] crypto: qat - centralize bus master enable
Date: Wed, 13 May 2026 17:16:56 +0200
Message-ID: <fb59d7881b362728d1ddf560cb94aaabf69bc2cf.1778685152.git.ahsan.atta@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <cover.1778685152.git.ahsan.atta@intel.com>
References: <cover.1778685152.git.ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

QAT driver currently toggles PCI bus mastering in multiple places
(probe paths, and reset callbacks). This makes BME state depend on
call ordering and on what PCI command bits were captured in saved PCI
config state.

Make BME control explicit and deterministic:
- remove pci_set_master() from device-specific probe paths
- add adf_set_bme() and call it from adf_dev_init() so BME is enabled
  at one point before device bring-up
- drop redundant pci_set_master() and pci_clear_master from adf_aer.c
  and rely on the unified init path for BME enablement

This is in preparation for adding reset_prepare() and reset_done()
hooks. In the PCI reset callback flow, the PCI core saves and
restores device configuration state around reset_prepare() and
reset_done(). This change is needed to ensure that we are able to
properly shutdown or reinitialize the device post sysfs triggered
resets.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c         |  2 --
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c          |  2 --
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c          |  2 --
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c         |  1 -
 drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c       |  1 -
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c          |  1 -
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c        |  1 -
 drivers/crypto/intel/qat/qat_common/adf_aer.c        | 10 +++++++---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h |  1 +
 drivers/crypto/intel/qat/qat_common/adf_init.c       |  2 ++
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c      |  1 -
 drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c    |  1 -
 12 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
index 566adc0a2d11..265bd52778c5 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
@@ -146,8 +146,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	pci_set_master(pdev);
-
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state.\n");
 		ret = -ENOMEM;
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index daca73651c14..681c4dd8f3d2 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -148,8 +148,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	pci_set_master(pdev);
-
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state.\n");
 		ret = -ENOMEM;
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
index c52462a48c34..ab62b91ecb51 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
@@ -189,8 +189,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	pci_set_master(pdev);
-
 	/*
 	 * The PCI config space is saved at this point and will be restored
 	 * after a Function Level Reset (FLR) as the FLR does not completely
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
index 7a59bca3242f..ded52744b4fc 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
@@ -167,7 +167,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			goto out_err_free_reg;
 		}
 	}
-	pci_set_master(pdev);
 
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
index 0881575f7670..e7600d284ed3 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
@@ -163,7 +163,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			goto out_err_free_reg;
 		}
 	}
-	pci_set_master(pdev);
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
index 4972e52dd944..2ebff5855b01 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -167,7 +167,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			goto out_err_free_reg;
 		}
 	}
-	pci_set_master(pdev);
 
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
index d3f728b9f2f2..91e148bb4870 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
@@ -163,7 +163,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			goto out_err_free_reg;
 		}
 	}
-	pci_set_master(pdev);
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 9c6bfb9fef80..365637e40439 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -41,7 +41,6 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 		accel_dev->hw_device->exit_arb(accel_dev);
 	}
 	adf_dev_restarting_notify(accel_dev);
-	pci_clear_master(pdev);
 	adf_dev_down(accel_dev);
 
 	return PCI_ERS_RESULT_NEED_RESET;
@@ -106,6 +105,13 @@ void adf_dev_restore(struct adf_accel_dev *accel_dev)
 	}
 }
 
+void adf_set_bme(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+
+	pci_set_master(pdev);
+}
+
 static void adf_device_sriov_worker(struct work_struct *work)
 {
 	struct adf_sriov_dev_data *sriov_data =
@@ -198,8 +204,6 @@ static pci_ers_result_t adf_slot_reset(struct pci_dev *pdev)
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	if (!pdev->is_busmaster)
-		pci_set_master(pdev);
 	pci_restore_state(pdev);
 	res = adf_dev_up(accel_dev, false);
 	if (res && res != -EALREADY)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index b9188ea9aa72..762a0b5e774a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -77,6 +77,7 @@ extern const struct pci_error_handlers adf_err_handler;
 void adf_reset_sbr(struct adf_accel_dev *accel_dev);
 void adf_reset_flr(struct adf_accel_dev *accel_dev);
 void adf_dev_restore(struct adf_accel_dev *accel_dev);
+void adf_set_bme(struct adf_accel_dev *accel_dev);
 int adf_init_aer(void);
 void adf_exit_aer(void);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index f8088388cf12..f9f5696ed476 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -74,6 +74,8 @@ static int adf_dev_init(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
+	adf_set_bme(accel_dev);
+
 	if (!test_bit(ADF_STATUS_CONFIGURED, &accel_dev->status) &&
 	    !accel_dev->is_vf) {
 		dev_err(&GET_DEV(accel_dev), "Device not configured\n");
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
index 8a863d7d86d7..97ad53eef38f 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
@@ -167,7 +167,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			goto out_err_free_reg;
 		}
 	}
-	pci_set_master(pdev);
 
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
index f8a6e10a1de7..a5edda8bad32 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
@@ -163,7 +163,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			goto out_err_free_reg;
 		}
 	}
-	pci_set_master(pdev);
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
-- 
2.45.0

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

