Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207D029DB65;
	Mon,  5 Jan 2026 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767633797; cv=none; b=etTzBgPjAKVAuvnpALrNzAiyynCSfOBu0Cv4ugTXIDWFn1dBA1SetvepWfwd8S6UqNv7Vrbx8ffqEZXObLxM0Mu0o/yEJnI+U9V9WkCDMLuRX9rDphzZujD51o/JN4WVxczl3XWkybkANNTHaw7N4xctsQKXGY31K1g1QgGzEhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767633797; c=relaxed/simple;
	bh=38rlMGT2vLZ4jHbteDpjbYVnn+hcEmJ/7bHs93EBK4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eKtAJd0W/cxs+7b1OvjBBS44eophdnVm8T8CVWyTgTS3G3yC+y9erc9dts7FDwd9b4mnhdTMVK/0FM/M/rLPkSSMfEcJhWgXONbpCLMkMz2pFxA6gnyE/c7Dn6OXqqlgoUGoNIBAHzS0C1XHqnxzdPpuGkOGrHd6xjj+KLQDw2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsEMOUDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsEMOUDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D05CC116D0;
	Mon,  5 Jan 2026 17:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767633796;
	bh=38rlMGT2vLZ4jHbteDpjbYVnn+hcEmJ/7bHs93EBK4k=;
	h=From:To:Cc:Subject:Date:From;
	b=EsEMOUDzSFua3O7TgMRiZLGamCd/ucvZG/TWkHGGATgOV0IccuqpW9mThp7Fes0gc
	 eC9m0bE5P/xdH4e1aE2G5023RHvpZ/2zNZ4n996cjWtvAfOTH1a5FE9f4qQnPisXGH
	 vmkVzNnqAiGmIDC3kcW0iU0aVA9txIKvVN5pjct9DPgfh70a3snc4n1zqARNZT0OBd
	 kc3lYaKX3hwvveb38KragQ0zkvZe2aWbzBPbrRKcw7gbAOrQBArpfs2eY5NKi2Guid
	 7bE89oYsv9xnarVdNy/Y1FdPkHuWRSDxFqpOWitGkLvJlQ3GoRZKG6T7Gdf8X/06Jm
	 n0woaIrLAC65Q==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH 1/2] crypto: ccp - Fix a case where SNP_SHUTDOWN is missed
Date: Mon,  5 Jan 2026 10:22:17 -0700
Message-ID: <20260105172218.39993-1-tycho@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

If page reclaim fails in sev_ioctl_do_snp_platform_status() and SNP was
moved from UNINIT to INIT for the function, SNP is not moved back to
UNINIT state. Additionally, SNP is not required to be initialized in order
to execute the SNP_PLATFORM_STATUS command, so don't attempt to move to
INIT state and let SNP_PLATFORM_STATUS report the status as is.

Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 46 ++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 956ea609d0cc..6e6011e363e3 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2378,11 +2378,10 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	bool shutdown_required = false;
 	struct sev_data_snp_addr buf;
 	struct page *status_page;
-	int ret, error;
 	void *data;
+	int ret;
 
 	if (!argp->data)
 		return -EINVAL;
@@ -2393,31 +2392,35 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 
 	data = page_address(status_page);
 
-	if (!sev->snp_initialized) {
-		ret = snp_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			goto cleanup;
-	}
-
 	/*
-	 * Firmware expects status page to be in firmware-owned state, otherwise
-	 * it will report firmware error code INVALID_PAGE_STATE (0x1A).
+	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
+	 * when SNP has been initialized, the status page must be firmware-owned.
 	 */
-	if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
-		ret = -EFAULT;
-		goto cleanup;
+	if (sev->snp_initialized) {
+		/*
+		 * Firmware expects the status page to be in Firmware state,
+		 * otherwise it will report an error INVALID_PAGE_STATE.
+		 */
+		if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
+			ret = -EFAULT;
+			goto cleanup;
+		}
 	}
 
 	buf.address = __psp_pa(data);
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
 
-	/*
-	 * Status page will be transitioned to Reclaim state upon success, or
-	 * left in Firmware state in failure. Use snp_reclaim_pages() to
-	 * transition either case back to Hypervisor-owned state.
-	 */
-	if (snp_reclaim_pages(__pa(data), 1, true))
-		return -EFAULT;
+	if (sev->snp_initialized) {
+		/*
+		 * The status page will be in Reclaim state on success, or left
+		 * in Firmware state on failure. Use snp_reclaim_pages() to
+		 * transition either case back to Hypervisor-owned state.
+		 */
+		if (snp_reclaim_pages(__pa(data), 1, true)) {
+			snp_leak_pages(__page_to_pfn(status_page), 1);
+			return -EFAULT;
+		}
+	}
 
 	if (ret)
 		goto cleanup;
@@ -2427,9 +2430,6 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 		ret = -EFAULT;
 
 cleanup:
-	if (shutdown_required)
-		__sev_snp_shutdown_locked(&error, false);
-
 	__free_pages(status_page, 0);
 	return ret;
 }

base-commit: 3609fa95fb0f2c1b099e69e56634edb8fc03f87c
-- 
2.52.0

