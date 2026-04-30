Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACC5477983;
	Thu, 30 Apr 2026 16:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777565287; cv=none; b=Zwz82/9qFNmqwGj13uOnJwwXzkE6QYdnsdZUnAVdn5WfCm7NnAoa7Hyipr6fTsUf2rxzXSvDBk1zn0nuSg+LpkELOW7eHXDoh4DO1XWxKlIo+SiMMEQeVyQY+WfsoWDlfOYAzto0n8kjXCKoeleuZ/dQUtKphRbPYUYFnyji03E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777565287; c=relaxed/simple;
	bh=ppqUBdHv5atY4swQeEtCHJ6NLY5UYUIHNSSBVG5oToY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hg0HD1wOdZdxFZYrFNdALerjSUD6A8PLk3UxSYYgJuXLBQ05WHUXvqn77132fZ5czfZstYpXfGnrU/IDMrThhrSYQktO0fLHG/4iejCVjwSvBLrGcyw+q3R9275WIu/OECobPbSZvB7Hbszyl4z4zOkTRzjwgaRFD+pKdg+HjT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oigEgUG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oigEgUG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC925C2BCB8;
	Thu, 30 Apr 2026 16:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777565287;
	bh=ppqUBdHv5atY4swQeEtCHJ6NLY5UYUIHNSSBVG5oToY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oigEgUG3dWXwDwUJzUJgvzyzHnD0kM+7ALFEWEFlQGcWyH/ZV5+9KSlxB/llYkKxe
	 LTX25P9KzqQ9NAR0SXMDTe2rSWmKtId79ViSnScmMWA3p6XE19lxDx6pHRejQLE/na
	 1ykL2j7d8RXRKzQb73+gx7NPsqKAiLq5TdG5uzvnu3PCRT+tPtD7HofU0GpR8sZIac
	 aQ8TNrP+l+jtnDi6S8FAA0miC6/zALd+G2GxWy0yUB/NGdzhPGeDYR6gQE+VbHL45P
	 lZJHerGExYwdXLrBrwNh4KJjI7oAiyHajva00sqO92Ym9mBWzlaxF5tNawEwOLrplA
	 3ZPu07rBpmaRA==
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
Subject: [RFC v1 4/6] crypto/ccp: Reclaim command buffer when the PSP dies
Date: Thu, 30 Apr 2026 10:07:14 -0600
Message-ID: <20260430160716.1120553-5-tycho@kernel.org>
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

When the PSP dies due to timeout the psp_dead flag is set, but the
buffer-in-use flag was not unset, and the pages were not reclaimed for
legacy commands.

In preparation for a firmware quirk where updates time out but the
situation is recoverable, move the reclamation before the error checking
and handling. Be sure to only copy the output buffer when the command has
not timed out, i.e. when there is sensible output in the buffer.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 60 +++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index defdc1bc226e..2df621b9f6e2 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -948,6 +948,38 @@ int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 
 	/* wait for command completion */
 	ret = sev_wait_cmd_ioc(sev, &reg, psp_timeout);
+
+	/*
+	 * Copy potential output from the PSP back to data.  Do this even on
+	 * failure in case the caller wants to glean something from the error,
+	 * unless the operation timed out, in which case there is nothing to
+	 * copy back.
+	 */
+	if (data) {
+		int ret_reclaim;
+		/*
+		 * Restore the page state after the command completes.
+		 */
+		ret_reclaim = snp_reclaim_cmd_buf(cmd, cmd_buf);
+		if (ret_reclaim) {
+			dev_err(sev->dev,
+				"SEV: failed to reclaim buffer for legacy command %#x. Error: %d\n",
+				cmd, ret_reclaim);
+			return ret_reclaim;
+		}
+
+		if (ret != -ETIMEDOUT)
+			memcpy(data, cmd_buf, buf_len);
+
+		if (sev->cmd_buf_backup_active)
+			sev->cmd_buf_backup_active = false;
+		else
+			sev->cmd_buf_active = false;
+
+		if (snp_unmap_cmd_buf_desc_list(desc_list))
+			return -EFAULT;
+	}
+
 	if (ret) {
 		if (psp_ret)
 			*psp_ret = 0;
@@ -984,34 +1016,6 @@ int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 		ret = sev_write_init_ex_file_if_required(cmd);
 	}
 
-	/*
-	 * Copy potential output from the PSP back to data.  Do this even on
-	 * failure in case the caller wants to glean something from the error.
-	 */
-	if (data) {
-		int ret_reclaim;
-		/*
-		 * Restore the page state after the command completes.
-		 */
-		ret_reclaim = snp_reclaim_cmd_buf(cmd, cmd_buf);
-		if (ret_reclaim) {
-			dev_err(sev->dev,
-				"SEV: failed to reclaim buffer for legacy command %#x. Error: %d\n",
-				cmd, ret_reclaim);
-			return ret_reclaim;
-		}
-
-		memcpy(data, cmd_buf, buf_len);
-
-		if (sev->cmd_buf_backup_active)
-			sev->cmd_buf_backup_active = false;
-		else
-			sev->cmd_buf_active = false;
-
-		if (snp_unmap_cmd_buf_desc_list(desc_list))
-			return -EFAULT;
-	}
-
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
 			     buf_len, false);
 
-- 
2.54.0

