Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6FF165F1A;
	Sun, 14 Dec 2025 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765739549; cv=none; b=vCjU5RGAPYYMDuh9mm0Rg+vhU+lqdXpRulpt53XWo2nq2ILXhi2mGpNdjTh58HjmiIjvdmTOrb1rDzCLWRsgpMe08KlgKwHrTxdWZO2jdBN02ssMbjrzRe3/O1WFRVSaoMjGeIZGawYPP/LAclFHt7DlQUD9eUjOuOn7lyvOc2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765739549; c=relaxed/simple;
	bh=fKkxPppPHZO4Vav2ht3I1OGRUh2h3l2GHLl/rKnaQuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJeTweqmZ6Xovpz5cpbti+MEmPU8jmTJe4SvtM3HycVaPw1pXjeymu8QD2XB0bdEc38dCY6fRKRenfABUmnIsMzb8G/TeKdltvnUuM2b8d/8M/nRnDVvSeXjycfjn56W5TsHkWRgS782w6dIGXgdVRe5avvDYxRk433gw1S+ReI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Svn57APC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Svn57APC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F72C16AAE;
	Sun, 14 Dec 2025 19:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765739548;
	bh=fKkxPppPHZO4Vav2ht3I1OGRUh2h3l2GHLl/rKnaQuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Svn57APCHI6Le+ryeppmk0+G2Qgr4/V5gtb+hW6jm7V2k+HwfJd+KFtzRpnyA9wPf
	 FiUTd90IYAZw8jGgnUglzUmbVbuVhJFnrDi01HT1kXFvlDlO3gFbd7uCq9fvQSwQ8f
	 U/HVDen5ZBKbz73uBTuPuypayi5P/HnNHge3z8NthEAWjrNFXug1QvEOQpjrsxOQ6x
	 irPR6AS+Ztr2RpTixQEX9CTHZ0egmkxlxl58oOwfqJ8/xr88u39wcvLK9QLUQtCJR3
	 sxnGtgRn0+TotinGOnyYza0tlCfOxXVCMnTn6cL1w/Ta631p8eQXvfq+Jk3K2+AM11
	 SioSUzQKHcwUw==
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
Subject: [PATCH v3 4/5] crypto: ccp - Factor out ring destroy handling to a helper
Date: Sun, 14 Dec 2025 13:12:12 -0600
Message-ID: <20251214191213.154021-5-superm1@kernel.org>
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

The ring destroy command needs to be used in multiple places. Split
out the code to a helper.

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

