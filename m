Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C7D372AAE;
	Wed, 19 Nov 2025 20:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763585995; cv=none; b=jHT2TCrbe7itRRpxcZzV34u9lh35lOuvBSWk80gZMot/D9V0UHEqrE1AUdO3PHnGyou8eRy7qUH5/FSUTypBXYF+8/60JlY/Noa7Joqvfzstd39Me+cJHQVnPxX4yN1Oe3/S1m6slwLhHk8niUgfH+LCTSuPpTOvNb/e8rJYPzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763585995; c=relaxed/simple;
	bh=iFfkZJCMVJj765cRqe9Pj+gcn+21VjD/+h6jMliXOeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JD1qt5ITkiztf2tx7qIGbe7E3ZFBRuL0/HYv0MS0P/j82yk/pr26Jqxoq4GKsqBfJ6+lbT15aTbc3GLuX+2/JSnQQqIEBpvwLwZWIu/LWIFrhqD2YdAvoDWD7/H4T7Flw3sFsGISGRov50L09Nbsc+soNWovCWmxfJYqJL1YGA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qj4q76pb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qj4q76pb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5575C116C6;
	Wed, 19 Nov 2025 20:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763585994;
	bh=iFfkZJCMVJj765cRqe9Pj+gcn+21VjD/+h6jMliXOeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qj4q76pbo7EkiyeRxJArdr6OmBXch8ES9yezze6pFHuBdDlwhvdyQhby/ajs5xRzL
	 yg5swx+3wVUMgXmcB57ucAu4lbxGYeM37dSQcLh4TtQkT28RFM3vdZzRO4/M6drchQ
	 mbYtowUmF9X2cx6iDanWWnXeOqlHbtIOWmJBSYLBH5tq8uaAkdr7rYV+48rIGn5DIY
	 g3vaR3ZtJ3oHw9rt+JhpR0c2yXSLyX4zvLgesA1LGZNdbMRyqEL3cJTUafwlJVy2ck
	 3AaYwSG0y73Ncy4fhXzsu1fFAnIEXTuJxe7USpxVqyD9/JhU4Nc8YtbLfI7gpkovi4
	 vEBFWAHw54W0A==
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
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lars Francke <lars.francke@gmail.com>
Subject: [PATCH 2/2] crypto: ccp - Add an S4 restore flow
Date: Wed, 19 Nov 2025 14:59:42 -0600
Message-ID: <20251119205942.3411155-3-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119205942.3411155-1-superm1@kernel.org>
References: <20251119205942.3411155-1-superm1@kernel.org>
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
 drivers/crypto/ccp/sp-dev.c  | 13 +++++++++++++
 drivers/crypto/ccp/sp-dev.h  |  1 +
 drivers/crypto/ccp/sp-pci.c  | 16 +++++++++++++++-
 drivers/crypto/ccp/tee-dev.c |  6 ++++++
 drivers/crypto/ccp/tee-dev.h |  1 +
 5 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 3467f6db4f505..e3fa94d14026b 100644
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
index 6f9d7063257d7..37b38afaab147 100644
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
index e7bb803912a6d..61c7b4b4b4c7c 100644
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
+const struct dev_pm_ops sp_pci_pm_ops = {
+	.suspend = pm_sleep_ptr(sp_pci_suspend),
+	.resume = pm_sleep_ptr(sp_pci_resume),
+	.freeze = pm_sleep_ptr(sp_pci_suspend),
+	.thaw = pm_sleep_ptr(sp_pci_resume),
+	.poweroff = pm_sleep_ptr(sp_pci_suspend),
+	.restore = pm_sleep_ptr(sp_pci_restore),
+};
 
 static struct pci_driver sp_pci_driver = {
 	.name = "ccp",
diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5e1d80724678d..66468de08fc34 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -365,3 +365,9 @@ int psp_check_tee_status(void)
 	return 0;
 }
 EXPORT_SYMBOL(psp_check_tee_status);
+
+int tee_restore(struct psp_device *psp)
+{
+	tee_free_ring(psp->tee_data);
+	return tee_init_ring(psp->tee_data);
+}
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
index ea9a2b7c05f57..c23416cb7bb37 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -111,5 +111,6 @@ struct tee_ring_cmd {
 
 int tee_dev_init(struct psp_device *psp);
 void tee_dev_destroy(struct psp_device *psp);
+int tee_restore(struct psp_device *psp);
 
 #endif /* __TEE_DEV_H__ */
-- 
2.43.0

