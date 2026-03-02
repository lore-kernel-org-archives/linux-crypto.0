Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C6D430B97;
	Mon,  2 Mar 2026 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772463756; cv=none; b=OOhL10jXAnknVyOTUk5NfKcltaFKrxT+05xuwQ5ip3GF82hxXCGXTDlfQQIzTw4YJV+CZZ+XAXzXAmfF+twK0nUnDVvewFAkRxGZHYsN7jPZFyVQ0jnlx7ihzoOnMJ5zlQYqFq3KgCWFevqQs1RmFqFRfc4ieqLwd+p/rnDez30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772463756; c=relaxed/simple;
	bh=WbKyTohiepH7gS1u3MGVpzLg9xedP6rhGUYsHzWhp8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LCkXvnWjtD3Zrkh+ncvfVv2ahsOif3jNoQKego+9oa2lcmbhqDK5jbXGFJOCYU/Zjem0gWi3l+5KNB7u+owTqJjZRYbSgSJ8Mn3CjwbM2EjEB63u+iHPHEJv39CAf3xGNDxJS5S7SHLzBTvZiS2FhXAa2z2TZ23kMRRz8sj04FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rr9h21nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rr9h21nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD7CC19423;
	Mon,  2 Mar 2026 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772463755;
	bh=WbKyTohiepH7gS1u3MGVpzLg9xedP6rhGUYsHzWhp8U=;
	h=From:To:Cc:Subject:Date:From;
	b=rr9h21nqqxBj7BbqOvK/5KG0JXIZALL6Tz9I0oL0YpyX7CeaOjUXTk1GIMg7k5y+1
	 Lz1xaaxlfPhvfLcNUl1VrqvPR0qVrVrEgtMXNIJXCg3mZmuHWvG2n6fcHcP/wcB9nm
	 lZ/KX+vERDtWCPk7tqkAGl0Mwfenypuh14bqGKhPqOVz+phz+zuLjZngignUcbO/pj
	 4RCmw7ToBVR4Gt++tXxITiwEDphIrQ/qSHkt/yOWCmfAUW+dTBSsH66ASVep0sIc+/
	 M3ZwIZJAqGtGqhNSpY/+MSUR/hvRtgkZclNzKrGruc7XEnWprOpgNxqSlmq3qjTf+a
	 yAvrfKQ5j9tmQ==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: ccp - simplify sev_update_firmware()
Date: Mon,  2 Mar 2026 08:02:23 -0700
Message-ID: <20260302150224.786118-1-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

sev_do_cmd() has its own command buffer (sev->cmd_buf) with the correct
alignment, perms, etc. that it copies the command into, so prepending it to
the firmware data is unnecessary.

Switch sev_update_firmware() to using a stack allocated command in light of
this copy, and drop all of the resulting pointer math.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 096f993974d1..c45c74190c75 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1967,11 +1967,11 @@ static int sev_get_firmware(struct device *dev,
 /* Don't fail if SEV FW couldn't be updated. Continue with existing SEV FW */
 static int sev_update_firmware(struct device *dev)
 {
-	struct sev_data_download_firmware *data;
+	struct sev_data_download_firmware data;
 	const struct firmware *firmware;
 	int ret, error, order;
 	struct page *p;
-	u64 data_size;
+	void *fw_blob;
 
 	if (!sev_version_greater_or_equal(0, 15)) {
 		dev_dbg(dev, "DOWNLOAD_FIRMWARE not supported\n");
@@ -1983,16 +1983,7 @@ static int sev_update_firmware(struct device *dev)
 		return -1;
 	}
 
-	/*
-	 * SEV FW expects the physical address given to it to be 32
-	 * byte aligned. Memory allocated has structure placed at the
-	 * beginning followed by the firmware being passed to the SEV
-	 * FW. Allocate enough memory for data structure + alignment
-	 * padding + SEV FW.
-	 */
-	data_size = ALIGN(sizeof(struct sev_data_download_firmware), 32);
-
-	order = get_order(firmware->size + data_size);
+	order = get_order(firmware->size);
 	p = alloc_pages(GFP_KERNEL, order);
 	if (!p) {
 		ret = -1;
@@ -2003,20 +1994,20 @@ static int sev_update_firmware(struct device *dev)
 	 * Copy firmware data to a kernel allocated contiguous
 	 * memory region.
 	 */
-	data = page_address(p);
-	memcpy(page_address(p) + data_size, firmware->data, firmware->size);
+	fw_blob = page_address(p);
+	memcpy(fw_blob, firmware->data, firmware->size);
 
-	data->address = __psp_pa(page_address(p) + data_size);
-	data->len = firmware->size;
+	data.address = __psp_pa(fw_blob);
+	data.len = firmware->size;
 
-	ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
+	ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, &data, &error);
 
 	/*
 	 * A quirk for fixing the committed TCB version, when upgrading from
 	 * earlier firmware version than 1.50.
 	 */
 	if (!ret && !sev_version_greater_or_equal(1, 50))
-		ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
+		ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, &data, &error);
 
 	if (ret)
 		dev_dbg(dev, "Failed to update SEV firmware: %#x\n", error);

base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.53.0

