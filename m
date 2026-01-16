Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B766B20C00C;
	Fri, 16 Jan 2026 04:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768536706; cv=none; b=Ll6hyesB6tQK11STDAgliGEuIBm67fDRM7CrxbQHBFb+Cta80wB1yBdMPJCfbTQngutO4nut8vwNFg+x2HsYT5eV27wsTjEfpc9jjMBswFGqBe8+NhbywBQlVGuAqiK1EBkKmVTkijq4n/5Pb5IYOhFIeAOkFBdWoy5VHqbErug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768536706; c=relaxed/simple;
	bh=RKk3OZtoGrnBJbGeSLlghVzcAZy5TqwLt5+aH1pFxN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAediH/0uEs2uZ0n1Beul8MCDofHY+I/JT8ap9tbQ/RjNYxnQM71uZsWwESV+8OmCGdFPiMuf7+FG+VUTpdZKFU4iJ0oDKYWyasBfE/eotpjXC9A2Rrq+k5g4AQE4UyFEl3XL/VhrAKFJYhMFb+U3aqJHXqwnaW3SIL/Wwo00Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUHLmTmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUHLmTmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066D4C19424;
	Fri, 16 Jan 2026 04:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768536706;
	bh=RKk3OZtoGrnBJbGeSLlghVzcAZy5TqwLt5+aH1pFxN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUHLmTmXIdl0TKVrWxRFdcAceFfBG+4YMQAfbUhKeXRsrxFFuPH9ES88yUSCZy5JU
	 OzU0uXag523DId/L3ux9X/JcMWED8ymyS1pt4gCPGYQavTW0CLG8dlaiP9L4X7y9F+
	 iKn3PyE4RMDtq3U4fIO9u/HQWfeTNwuU5hP3vf5EQtHreER4TUu6GXu++Fa9lGJdqf
	 1emRtq5gcOkohIov4bFCaa2Qwjsw4rUXNFhDyFvcu8HwYSry4OwCLYzywagT34hKVs
	 b/7QwhvdDoHksP/Ytte26BbFdxGAs15ZqAUK9b2CsCwwN4QjfDK/+fkv5iUNdoXeuy
	 BxVBa8NNQrIvg==
From: "Mario Limonciello (AMD)" <superm1@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Hans de Goede <hansg@kernel.org>,
	linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER),
	platform-driver-x86@vger.kernel.org (open list:AMD PMF DRIVER),
	Lars Francke <lars.francke@gmail.com>,
	Yijun Shen <Yijun.Shen@dell.com>,
	Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Yijun Shen <Yijun.Shen@Dell.com>
Subject: [PATCH v6 3/5] crypto: ccp - Add an S4 restore flow
Date: Thu, 15 Jan 2026 22:11:30 -0600
Message-ID: <20260116041132.153674-4-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260116041132.153674-1-superm1@kernel.org>
References: <20260116041132.153674-1-superm1@kernel.org>
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
Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
---
v6:
 * Add sp_restore() flow (Tom)
 * Drop CONFIG_CRYPTO_DEV_SP_PSP conditional behavior
v5:
 * Fix return for psp_restore() (LKP robot, Shyam)
v4:
 * Add tag (Yijun)
 * Remove blank line (Ilpo)
 * Adjust whitespace in psp_restore() (Ilpo)
---
 drivers/crypto/ccp/psp-dev.c | 11 +++++++++++
 drivers/crypto/ccp/sp-dev.c  | 12 ++++++++++++
 drivers/crypto/ccp/sp-dev.h  |  3 +++
 drivers/crypto/ccp/sp-pci.c  | 16 +++++++++++++++-
 drivers/crypto/ccp/tee-dev.c |  5 +++++
 drivers/crypto/ccp/tee-dev.h |  1 +
 6 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 9e21da0e298ad..5c7f7e02a7d8a 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -351,6 +351,17 @@ struct psp_device *psp_get_master_device(void)
 	return sp ? sp->psp_data : NULL;
 }
 
+int psp_restore(struct sp_device *sp)
+{
+	struct psp_device *psp = sp->psp_data;
+	int ret = 0;
+
+	if (psp->tee_data)
+		ret = tee_restore(psp);
+
+	return ret;
+}
+
 void psp_pci_init(void)
 {
 	psp_master = psp_get_master_device();
diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 3467f6db4f505..f204aa5df96e2 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -230,6 +230,18 @@ int sp_resume(struct sp_device *sp)
 	return 0;
 }
 
+int sp_restore(struct sp_device *sp)
+{
+	if (sp->psp_data) {
+		int ret = psp_restore(sp);
+
+		if (ret)
+			return ret;
+	}
+
+	return sp_resume(sp);
+}
+
 struct sp_device *sp_get_psp_master_device(void)
 {
 	struct sp_device *i, *ret = NULL;
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 1335a83fe052e..a83751cfd0060 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -141,6 +141,7 @@ void sp_destroy(struct sp_device *sp);
 
 int sp_suspend(struct sp_device *sp);
 int sp_resume(struct sp_device *sp);
+int sp_restore(struct sp_device *sp);
 int sp_request_ccp_irq(struct sp_device *sp, irq_handler_t handler,
 		       const char *name, void *data);
 void sp_free_ccp_irq(struct sp_device *sp, void *data);
@@ -174,6 +175,7 @@ int psp_dev_init(struct sp_device *sp);
 void psp_pci_init(void);
 void psp_dev_destroy(struct sp_device *sp);
 void psp_pci_exit(void);
+int psp_restore(struct sp_device *sp);
 
 #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -181,6 +183,7 @@ static inline int psp_dev_init(struct sp_device *sp) { return 0; }
 static inline void psp_pci_init(void) { }
 static inline void psp_dev_destroy(struct sp_device *sp) { }
 static inline void psp_pci_exit(void) { }
+static inline int psp_restore(struct sp_device *sp) { return 0; }
 
 #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
 
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 8891ceee1d7d0..6ac805d99ccb3 100644
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
@@ -563,7 +570,14 @@ static const struct pci_device_id sp_pci_table[] = {
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
index af881daa5855b..11c4b05e2f3a2 100644
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

