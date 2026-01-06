Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84ECC29B200;
	Tue,  6 Jan 2026 04:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767675289; cv=none; b=hi8FANRF7synI8YUfJw9ntHY0X+VwskCJDPPbeqyyMdoCou6tr0FrgaAecEGdWFXoCIOVAdWsISQeseyQ31V37OAg6/cCIfuGnFQ+Af0FZBIJsSg5RUCFApr/IBRPZ5T8x0H0uZc6+LQa9T9Fguh1CRAjOdVkTSVRvT/9TU0OFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767675289; c=relaxed/simple;
	bh=hHanQwA3+eHDfox43LEzfReiBmZSAi2n4ffgk+tAZy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTjRsqmeLEl2Gow/tD2bMeO9FdpwnUkpO5o+7dJBUDmcfqRcU2SCNsE479RWj2fMi/Dsk5NOgEtDfM9za9aQrQ5J/PSeXQmxWaEgSOKvm3cNn4Frr32VQvp5tn8/RmyX8DhKRnkSo8gfwarcoVAhS8qu0velM99DNx+c4bCjgeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQ2tFc2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQ2tFc2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD968C19424;
	Tue,  6 Jan 2026 04:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767675288;
	bh=hHanQwA3+eHDfox43LEzfReiBmZSAi2n4ffgk+tAZy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQ2tFc2BCeTnK1lqrm8TyXOT43L5Fjf6poBnvPtyaRhtXwbYimEzd/CYgs+mD+i45
	 V3eqnJ1IXLB1sjji7t4MPCRbrFSx7LOWNwhLzBPpsVdTmNDJBfP+lGWVmfn+HR43/v
	 VTzLqedctCViAF0+QahQu/7oRbkos/92d6HHLr7PwVeUahHrO5S2bQAovg6sVIaBtV
	 qaCHVny+yWOK3Viz6bYNIflca/tQhnXm4zBJvtZACLvYmUrPpx4eKG9Ti3JpOcrYD/
	 cVKutfoE9If8jVtS+EFAoNY3DTY5f3QwnyV8XcI+xbdpD1g52w8koyda+egatFBrv1
	 Ln3Gm4Xom5XPg==
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
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Yijun Shen <Yijun.Shen@Dell.com>
Subject: [PATCH v4 4/5] crypto: ccp - Factor out ring destroy handling to a helper
Date: Mon,  5 Jan 2026 22:54:22 -0600
Message-ID: <20260106045423.55190-5-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260106045423.55190-1-superm1@kernel.org>
References: <20260106045423.55190-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ring destroy command needs to be used in multiple places. Split
out the code to a helper.

Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 11c4b05e2f3a2..ef1430f86ad62 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -86,6 +86,29 @@ static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
 	kfree(cmd);
 }
 
+static bool tee_send_destroy_cmd(struct psp_tee_device *tee)
+{
+	unsigned int reg;
+	int ret;
+
+	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
+				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
+	if (ret) {
+		dev_err(tee->dev, "tee: ring destroy command timed out, disabling TEE support\n");
+		psp_dead = true;
+		return false;
+	}
+
+	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
+		dev_err(tee->dev, "tee: ring destroy command failed (%#010lx)\n",
+			FIELD_GET(PSP_CMDRESP_STS, reg));
+		psp_dead = true;
+		return false;
+	}
+
+	return true;
+}
+
 static int tee_init_ring(struct psp_tee_device *tee)
 {
 	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
@@ -137,24 +160,13 @@ static int tee_init_ring(struct psp_tee_device *tee)
 
 static void tee_destroy_ring(struct psp_tee_device *tee)
 {
-	unsigned int reg;
-	int ret;
-
 	if (!tee->rb_mgr.ring_start)
 		return;
 
 	if (psp_dead)
 		goto free_ring;
 
-	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
-				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
-	if (ret) {
-		dev_err(tee->dev, "tee: ring destroy command timed out, disabling TEE support\n");
-		psp_dead = true;
-	} else if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
-		dev_err(tee->dev, "tee: ring destroy command failed (%#010lx)\n",
-			FIELD_GET(PSP_CMDRESP_STS, reg));
-	}
+	tee_send_destroy_cmd(tee);
 
 free_ring:
 	tee_free_ring(tee);
-- 
2.43.0

