Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D54A29BDBD;
	Thu, 11 Dec 2025 21:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765488536; cv=none; b=oMh7r4GDdRR0jMKjLEZJLk8OSkLIdKvwT48Eq3YOSg436Lod0Q6XKF3H4wOK06UNRtehNbv/KdjBHhRzmHEshfkzW5GVJW6i6JIOLd+Yt+RYMyq0Yaco3ddZZuZDmzrzxokxpr01u5nCq7qITQR4J//U5VwGK5rZIPpK3RP7r2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765488536; c=relaxed/simple;
	bh=UOxsfUFg3B/0zFaqoLT7/4W1ZICoSOjZmW8j76+9tZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAMuU3vzXT/0dZyHCpvApdp0YRkUZdHUChUPPua5bjszpto0xhOzSZ0FZStJynh4BW1yJUpsDm1T+KGSKlyMLLIIhmrOzXuVbXJijoS9zc7fqktgmG60OnZ5Fiam1nTC57hCPIgy94rjIkK/y/z48aeBR93YeQawSbUJoooF2/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOUCG2RX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOUCG2RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C08C19422;
	Thu, 11 Dec 2025 21:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765488535;
	bh=UOxsfUFg3B/0zFaqoLT7/4W1ZICoSOjZmW8j76+9tZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOUCG2RXTl7oKW0lhqLjF+BICXz1FUFB2CA7u5Kb8dBErCeSi9Z+sLdw7by5MycKD
	 GATXGCBMoSkE+YTSjPrW4ou1rPooDOlnXmCjnf4l+4xTpzpMsNsHR2v8IPM/jrSXTP
	 njhau8QKNOIxW5m+XDg6r/ybwuKgJkIflpjhtlatLSO4uJeNoUSr6TrfJlZ/0V7zhF
	 YSiNluXepNYfqwLiTU+FwuPTzeGSxu1fufyofh7u4BzG/LUhSuEKn37sY2HtQ3WgUC
	 YOu0JmIWsT/T+gF6n7KbzO2itODbqY9VrpX2R0LdEWeqDPOZbSfSQXIvs9rAcetqZ4
	 GhwKZSdFzwP5A==
From: "Mario Limonciello (AMD)" <superm1@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Hans de Goede <hansg@kernel.org>,
	linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER),
	platform-driver-x86@vger.kernel.org (open list:AMD PMF DRIVER),
	Lars Francke <lars.francke@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH v2 3/4] crypto: ccp - Add an S4 restore flow
Date: Thu, 11 Dec 2025 15:28:46 -0600
Message-ID: <20251211212847.11980-4-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251211212847.11980-1-superm1@kernel.org>
References: <20251211212847.11980-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The system will have lost power during S4.  The ring used for TEE
communications needs to be initialized before use.

Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
Reported-by: Lars Francke <lars.francke@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
---
v2:
 * Fix LKP errors
 * Remove free phase
---
 drivers/crypto/ccp/sp-dev.c  | 13 +++++++++++++
 drivers/crypto/ccp/sp-dev.h  |  1 +
 drivers/crypto/ccp/sp-pci.c  | 16 +++++++++++++++-
 drivers/crypto/ccp/tee-dev.c |  5 +++++
 drivers/crypto/ccp/tee-dev.h |  6 ++++++
 5 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 3467f6db4f50..e3fa94d14026 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -21,6 +21,7 @@
 
 #include "sev-dev.h"
 #include "ccp-dev.h"
+#include "tee-dev.h"
 #include "sp-dev.h"
 
 MODULE_AUTHOR("Tom Lendacky <thomas.lendacky@amd.com>");
@@ -230,6 +231,18 @@ int sp_resume(struct sp_device *sp)
 	return 0;
 }
 
+int sp_restore(struct sp_device *sp)
+{
+	if (sp->dev_vdata->psp_vdata->tee) {
+		int r = tee_restore(sp->psp_data);
+
+		if (r)
+			return r;
+	}
+
+	return sp_resume(sp);
+}
+
 struct sp_device *sp_get_psp_master_device(void)
 {
 	struct sp_device *i, *ret = NULL;
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 6f9d7063257d..37b38afaab14 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -141,6 +141,7 @@ void sp_destroy(struct sp_device *sp);
 
 int sp_suspend(struct sp_device *sp);
 int sp_resume(struct sp_device *sp);
+int sp_restore(struct sp_device *sp);
 int sp_request_ccp_irq(struct sp_device *sp, irq_handler_t handler,
 		       const char *name, void *data);
 void sp_free_ccp_irq(struct sp_device *sp, void *data);
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index e7bb803912a6..ce55563b224d 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -353,6 +353,13 @@ static int __maybe_unused sp_pci_resume(struct device *dev)
 	return sp_resume(sp);
 }
 
+static int __maybe_unused sp_pci_restore(struct device *dev)
+{
+	struct sp_device *sp = dev_get_drvdata(dev);
+
+	return sp_restore(sp);
+}
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 static const struct sev_vdata sevv1 = {
 	.cmdresp_reg		= 0x10580,	/* C2PMSG_32 */
@@ -544,7 +551,14 @@ static const struct pci_device_id sp_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, sp_pci_table);
 
-static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
+static const struct dev_pm_ops sp_pci_pm_ops = {
+	.suspend = pm_sleep_ptr(sp_pci_suspend),
+	.resume = pm_sleep_ptr(sp_pci_resume),
+	.freeze = pm_sleep_ptr(sp_pci_suspend),
+	.thaw = pm_sleep_ptr(sp_pci_resume),
+	.poweroff = pm_sleep_ptr(sp_pci_suspend),
+	.restore_early = pm_sleep_ptr(sp_pci_restore),
+};
 
 static struct pci_driver sp_pci_driver = {
 	.name = "ccp",
diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index af881daa5855..11c4b05e2f3a 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -366,3 +366,8 @@ int psp_check_tee_status(void)
 	return 0;
 }
 EXPORT_SYMBOL(psp_check_tee_status);
+
+int tee_restore(struct psp_device *psp)
+{
+	return tee_init_ring(psp->tee_data);
+}
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
index ea9a2b7c05f5..3409253ac557 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -112,4 +112,10 @@ struct tee_ring_cmd {
 int tee_dev_init(struct psp_device *psp);
 void tee_dev_destroy(struct psp_device *psp);
 
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+int tee_restore(struct psp_device *psp);
+#else
+static inline int tee_restore(struct psp_device *psp) { return 0; }
+#endif /* CONFIG_CRYPTO_DEV_SP_PSP */
+
 #endif /* __TEE_DEV_H__ */
-- 
2.51.2

