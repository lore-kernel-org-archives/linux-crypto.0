Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F63530E0EE;
	Sun, 14 Dec 2025 19:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765739547; cv=none; b=UGDsLtTCPI4osNk73+qLfbdpcBtsfi37El1etjQAYVSVJBlIDdL+7ssFR+fmNUKsPglcOY8/WowbXyAFqzdn7ovDYl5gKlBU6ejGeQg5ZOD2ioFHxRYjN6IPIMVC097+GNcEg8WB/CrbA+nDH+IICn1Rqy0GcLN8fdw+rXnIXZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765739547; c=relaxed/simple;
	bh=rqr8ZyfdjIs8KcbT5Zb4Av5EACd9n5pfghm/h3SRrfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5PTy1Vb/EWWgtM+2CXCdW9pnEdJLMNcXSzE6cF9nxjGhdEiFh36NTZmUeLpIPFrQqu4uakcq24ca2EPRNDJSYxY5uK/moZk7AMBpERapSMYPfZ6chF5J8se/fHTVUH005aaJucP7WUEK3+4L7SePrjM0k5zV8HxPkT1nA4DbuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5JtTQ37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5JtTQ37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE702C19421;
	Sun, 14 Dec 2025 19:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765739547;
	bh=rqr8ZyfdjIs8KcbT5Zb4Av5EACd9n5pfghm/h3SRrfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5JtTQ37KnTMyfwJZ0Ywl2JmWRxLzVIESvd3Be1xJwshyLZ7HaFBwIhf0rMy2NZzP
	 N7MJP7ADooXmXW8H9vocFrnMHvz7j6KGkW7Qfkm5kcVal/B0WByF7WN95ZcDWG0Leu
	 kG+9N1qZICiTzH32jZzs1fsv9qG7RRAuEGFrxNp/I4/2oxL2UD5LBipBwOWzXRaOG6
	 VQh3DcgCb0T31BYXZfdnP5OJ8dn46i+P31fZNBQjRMwC/h55znbRtwBBB90ayqbmc7
	 4RpKQGPo1M11JyaLKAfPz8IhN3tO8iYZTjpLhnJYuFIHWWj5AIRU+yPUwgtETRE+Oz
	 FdWjckH0gw96g==
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
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH v3 3/5] crypto: ccp - Add an S4 restore flow
Date: Sun, 14 Dec 2025 13:12:11 -0600
Message-ID: <20251214191213.154021-4-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251214191213.154021-1-superm1@kernel.org>
References: <20251214191213.154021-1-superm1@kernel.org>
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
v3:
 * Adjust to Tom's suggested flow
---
 drivers/crypto/ccp/psp-dev.c | 15 +++++++++++++++
 drivers/crypto/ccp/sp-dev.h  |  2 ++
 drivers/crypto/ccp/sp-pci.c  | 24 +++++++++++++++++++++++-
 drivers/crypto/ccp/tee-dev.c |  5 +++++
 drivers/crypto/ccp/tee-dev.h |  1 +
 5 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 9e21da0e298ad..e1da4f1a5db99 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -351,6 +351,21 @@ struct psp_device *psp_get_master_device(void)
 	return sp ? sp->psp_data : NULL;
 }
 
+
+int psp_restore(struct sp_device *sp)
+{
+	struct psp_device *psp = sp->psp_data;
+
+	if (psp->tee_data) {
+		int r = tee_restore(psp);
+
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
 void psp_pci_init(void)
 {
 	psp_master = psp_get_master_device();
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 1335a83fe052e..0deea1a399e47 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -174,6 +174,7 @@ int psp_dev_init(struct sp_device *sp);
 void psp_pci_init(void);
 void psp_dev_destroy(struct sp_device *sp);
 void psp_pci_exit(void);
+int psp_restore(struct sp_device *sp);
 
 #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -181,6 +182,7 @@ static inline int psp_dev_init(struct sp_device *sp) { return 0; }
 static inline void psp_pci_init(void) { }
 static inline void psp_dev_destroy(struct sp_device *sp) { }
 static inline void psp_pci_exit(void) { }
+static inline int psp_restore(struct sp_device *sp) { return 0; }
 
 #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
 
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 8891ceee1d7d0..931ec6bf2cec6 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -353,6 +353,21 @@ static int __maybe_unused sp_pci_resume(struct device *dev)
 	return sp_resume(sp);
 }
 
+static int __maybe_unused sp_pci_restore(struct device *dev)
+{
+	struct sp_device *sp = dev_get_drvdata(dev);
+
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+	if (sp->psp_data) {
+		int ret = psp_restore(sp);
+
+		if (ret)
+			return ret;
+	}
+#endif
+	return sp_resume(sp);
+}
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 static const struct sev_vdata sevv1 = {
 	.cmdresp_reg		= 0x10580,	/* C2PMSG_32 */
@@ -563,7 +578,14 @@ static const struct pci_device_id sp_pci_table[] = {
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

