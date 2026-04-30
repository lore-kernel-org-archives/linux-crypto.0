Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE38946AF3F;
	Thu, 30 Apr 2026 16:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777565283; cv=none; b=YeY1r+30jMuwKKtu3p1R7XsMlCap/l/lfUi+TV+vFqGHOC1rEwe3eJ4PtIAbMt3ddRoBzZvhvemmQ3ErO3PRz39j7eXoUcr4juPSzpd7+AdvfbWCNL1LFUNDiQX5CiqYD/5hQ57ud+wkl1cN2JREVTBFgXDcipdNTEVGNIlZQ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777565283; c=relaxed/simple;
	bh=RD/xehk71EurLmD3n8bVFda9UNe1vsIrDTcsFaZpYRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIPmXKEHma4VfxYviHl4804yaL+K4U5kLMMP2RSCHeKj6Lrt0u0Gqzfv36pFUhi7mb0T0A1lfvvvtH+JMkUL5L+6a4y4JA50g+GRCqbQUTnriNWUkngryHQ0jRTHa6IIAdlcPrNT5H/GC19hRAfZBu/ofqX3vLhjegL8cWzJGjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9EVyH+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9EVyH+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3002FC2BCB8;
	Thu, 30 Apr 2026 16:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777565283;
	bh=RD/xehk71EurLmD3n8bVFda9UNe1vsIrDTcsFaZpYRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9EVyH+O2dXMsY05UCTePIqHsu2aROutq8u9lq4Hmk/BemBWxBTIOulKXSfsXVT9W
	 LjrawUwXZaOMbBqM22lrL2ZRZxCWRDPf+Cr6yyZ54o1r41YTl/nMC4ke5jeq1TCPnD
	 rwDTPogbx3Tuk6XiCK7Mh981TwximVHQ6QsjEU6JbhllMWLnewddsNvKf9gNoSO2l2
	 DdbHog3u1q+XU9EpCu+h7878MaafSbbVK5vKeNt7+5KU/00FU4d0Kmeu4E2v5h55nU
	 y7U44AfjrNyRV5tvxxzWSKoFaJolT0lhNAlUkHon13fFM9QrAxbpzdjlWnvQ9IBlur
	 LEPYH0ScQHlKg==
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
Subject: [RFC v1 2/6] crypto/ccp: Allow snp_get_platform_data() after SNP init
Date: Thu, 30 Apr 2026 10:07:12 -0600
Message-ID: <20260430160716.1120553-3-tycho@kernel.org>
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

In preparation for refreshing the cached SNP platform status and feature
information after a successful firmware live update, allow
snp_get_platform_data() to be called when the SNP firmware is in the INIT
state.

When SNP is initialized the firmware additionally requires status pages to
be in the firmware-owned RMP state. __sev_do_snp_platform_status() already
handles this for SNP_PLATFORM_STATUS, so switch to that helper for that
command. Add the same mark/reclaim dance around the SNP_FEATURE_INFO
page.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 22bc4ef27a63..7ca29ccda0e7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -132,6 +132,9 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
 static int snp_shutdown_on_panic(struct notifier_block *nb,
 				 unsigned long reason, void *arg);
 
+static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
+					int *error);
+
 static struct notifier_block snp_panic_notifier = {
 	.notifier_call = snp_shutdown_on_panic,
 };
@@ -1264,19 +1267,12 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 {
 	struct sev_data_snp_feature_info snp_feat_info;
 	struct snp_feature_info *feat_info;
-	struct sev_data_snp_addr buf;
 	struct page *page;
 	int rc;
 
-	/*
-	 * This function is expected to be called before SNP is
-	 * initialized.
-	 */
-	if (sev->snp_initialized)
-		return -EINVAL;
-
-	buf.address = __psp_pa(&sev->snp_plat_status);
-	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
+	mutex_lock(&sev_cmd_mutex);
+	rc = __sev_do_snp_platform_status(&sev->snp_plat_status, error);
+	mutex_unlock(&sev_cmd_mutex);
 	if (rc) {
 		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
 			rc, *error);
@@ -1305,17 +1301,32 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
 		return -ENOMEM;
 
 	feat_info = page_address(page);
+
+	if (sev->snp_initialized) {
+		if (rmp_mark_pages_firmware(__pa(feat_info), 1, false)) {
+			rc = -EFAULT;
+			goto free_page;
+		}
+	}
+
 	snp_feat_info.length = sizeof(snp_feat_info);
 	snp_feat_info.ecx_in = 0;
 	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
 
 	rc = sev_do_cmd(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
+
+	if (sev->snp_initialized) {
+		if (snp_reclaim_pages(__pa(feat_info), 1, false))
+			return -EFAULT;
+	}
+
 	if (!rc)
 		sev->snp_feat_info_0 = *feat_info;
 	else
 		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
 			rc, *error);
 
+free_page:
 	__free_page(page);
 
 	return rc;
-- 
2.54.0

