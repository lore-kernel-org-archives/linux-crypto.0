Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845124779B0;
	Thu, 30 Apr 2026 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777565289; cv=none; b=js4/Zu95bi1cjtMo5ppwmHSmd5wkV1Hc9PS0NLpW50lFHXQtJmCnoLZsVpkRFg3Lh7kX5TScCI8K0xEJbpRCd4tJo9hplkmPvRRmHGg3uWEz3PLBoUAmGgmvZFy+XbL96li/2P8WBlh8mQsEko2wPFP0FRgJgnJMcXiilxAxxhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777565289; c=relaxed/simple;
	bh=pejxj9fzZ+77vwlzN5M73gcB3B9Ho8n9BQSAk7R+bfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IX4ZolJ70+idrotXoLsmZXH2xegKEfv1tbMkY9BZPnl/5wieB5rSGkN1oq4mgp3IT9SrJ6iWzQza8nY5FUChu9pngAcIH6uMnw/IcJrVHBjHlotnWvnC8VHY9FeNE4SNuFLj45u97u3dGfodDlwo6e86cwAiPznGGBOyntjHwM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGAb/QPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGAb/QPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F985C2BCB9;
	Thu, 30 Apr 2026 16:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777565289;
	bh=pejxj9fzZ+77vwlzN5M73gcB3B9Ho8n9BQSAk7R+bfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGAb/QPnE3OmdOSIQSFLbmRe34WshOtfGRuV0ii0cHcyyNKrW6+akIf72dOXubo+B
	 zdk/29PCNca8CqnDLaBDlyjiDblmOaJtBZBaPcfPyVXDaElI9HpxidPCziL/4YjHxY
	 I74j38sVuwCJZpoBx96YBmQfoV1j/GzOKe/i4isbJNng3K7c8zJdu8XNWHr9exBdAG
	 luEUPDzjnrpSCoxmfDw9CcvRWLa8V052EIDYYed/4Po0SPiLFMrV6Z+FE3x+PmQ7j9
	 yMe9PBWsYOt1NzQkods7WOA3H3MlW31WjlmDF/MFK/uVFZx63E1+JhLVsNtzX84gzR
	 OyCkyhyNsYhjw==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Pratik R. Sampat" <prsampat@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [RFC v1 5/6] crypto/ccp: Register with fw_uploader and always fail
Date: Thu, 30 Apr 2026 10:07:15 -0600
Message-ID: <20260430160716.1120553-6-tycho@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430160716.1120553-1-tycho@kernel.org>
References: <20260430160716.1120553-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

In preparation for SNP live firmware downloading support, add an 'sev'
firmware loader that always fails with EBUSY.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 51 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  3 +++
 2 files changed, 54 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2df621b9f6e2..b4711bf823e8 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2040,6 +2040,53 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
+static enum fw_upload_err sev_fw_upload_prepare(struct fw_upload *fw_upload,
+						const u8 *data, u32 size)
+{
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
+					      const u8 *data, u32 offset,
+					      u32 size, u32 *written)
+{
+	return FW_UPLOAD_ERR_BUSY;
+}
+
+static enum fw_upload_err sev_fw_upload_poll_complete(struct fw_upload *fw_upload)
+{
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static void sev_fw_upload_cancel(struct fw_upload *fw_upload)
+{
+	/* intentional no-op */
+}
+
+static const struct fw_upload_ops sev_fw_upload_ops = {
+	.prepare = sev_fw_upload_prepare,
+	.write = sev_fw_upload_write,
+	.poll_complete = sev_fw_upload_poll_complete,
+	.cancel = sev_fw_upload_cancel,
+};
+
+static void register_sev_fw_uploader(struct sev_device *sev)
+{
+	struct fw_upload *fwl;
+
+	if (!IS_ENABLED(CONFIG_FW_UPLOAD))
+		return;
+
+	fwl = firmware_upload_register(THIS_MODULE, sev->dev, "sev",
+				       &sev_fw_upload_ops, sev);
+	if (IS_ERR(fwl)) {
+		dev_err(sev->dev, "SEV firmware upload registration failure: %ld\n", PTR_ERR(fwl));
+		return;
+	}
+
+	sev->fwl = fwl;
+}
+
 static int __sev_snp_shutdown_locked(int *error, bool panic)
 {
 	struct psp_device *psp = psp_master;
@@ -2953,6 +3000,7 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
+	register_sev_fw_uploader(sev);
 	return;
 
 err:
@@ -2969,4 +3017,7 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
+
+	if (sev->fwl)
+		firmware_upload_unregister(sev->fwl);
 }
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index b1cd556bbbf6..2f5781cb7bb1 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -24,6 +24,7 @@
 #include <linux/psp-sev.h>
 #include <linux/miscdevice.h>
 #include <linux/capability.h>
+#include <linux/firmware.h>
 
 #define SEV_CMDRESP_CMD			GENMASK(26, 16)
 #define SEV_CMD_COMPLETE		BIT(1)
@@ -66,6 +67,8 @@ struct sev_device {
 
 	struct tsm_dev *tsmdev;
 	struct sev_tio_status *tio_status;
+
+	struct fw_upload *fwl;
 };
 
 int sev_dev_init(struct psp_device *psp);
-- 
2.54.0

