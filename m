Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192FA477E34;
	Thu, 30 Apr 2026 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777565291; cv=none; b=GQXAqMkH/RRU8ok+CNHL70/fFqgR3k7pyERWkb8Ms077m2vaRK4V9skLplbVy598EsSdireCdj0Sw4k1qtJhTez8aBE9ak2Mbky9wTfyCSylW2H+jVrHOgYrcyUq30YgjjN5WiIhBI8tOBMWSRnNAsYtqDN4Q9Sx+UK+I0MlcDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777565291; c=relaxed/simple;
	bh=A218sexPB4Eoz81IHOSyS19fv9sHjGhguWb/ZRqThiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQzoYrCi4e/yZCHWDvm29oz7cqY4WXwzb7iVd2JqSSAYJPWgKyWcW3faDpgV7+FGTbCSWawwjaa+n+gz2yMERMnzW/W+nVhWkesSpniPUk5O6aKjvMh/ejR6lTCLiwqwFT517mWk0rjmhuJXM7/YnnEmN+gTojdzOZoKLJKvH1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWPSJQ+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWPSJQ+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747ABC2BCB8;
	Thu, 30 Apr 2026 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777565291;
	bh=A218sexPB4Eoz81IHOSyS19fv9sHjGhguWb/ZRqThiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWPSJQ+4hZNmF8Lb9iJd3RLMr0MOg9OLD3PLc7eDxya/ctA2YgbOb0vrgNog2m/EB
	 0tW6frMkmaJKH8SNYUX3bpHA2qUzgYc2JUm4YZBniwSC4h52dyl1u8jvdqS0WwxE7z
	 UdZucScD+bVuYBq0smM5mhIliP7RJCyYgFlAGviK6PSrjjRFLhoEW0Tls0H5V0p9pF
	 /7PZC3PgqPS3W5ZtZnwvEapepu5tnt9AjkcRS/xAqG9w6Ne+3jIF5+6LSBY72HRpHO
	 mpAMPor9ljJClfZ/dce9oz1hR2+2T82B2dsKRo6lhzxQA5hcUaykFjVIdEuSt4mrt+
	 Ctpz7aZcgIb8w==
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
Subject: [RFC v1 6/6] crypto/ccp: Implement SNP firmware live update
Date: Thu, 30 Apr 2026 10:07:16 -0600
Message-ID: <20260430160716.1120553-7-tycho@kernel.org>
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

Put all the previous primitives together to implement SNP firmware
live update via DOWNLOAD_FIRMWARE_EX.

DOWNLOAD_FIRMWARE_EX can only be run while the legacy SEV firmware is the
UNINIT state. If the legacy firmware is in the WORKING state running legacy
guests, refuse to update. If the legacy firmware is in the INIT state,
de-initialize it so that the update can be run.

When the firmware is installed, it is only provisionally loaded. It relies
on userspace to issue ioctl(/dev/sev, SNP_COMMIT, ...) when it is happy
with the provisional firmware.

To roll back, userspace should not do an SNP_COMMIT, and invoke the
firmware loader in the same way but with the old firmware image. The
firmware spec notes:

    If a guest context page is updated to a provisional firmware version,
    then updating the context page back to the committed version after a
    rollback will always succeed.

There are essentially four classes of errors during an update:

1. kernel bugs that WARN_ON_ONCE()
2. invalid firmware (bad image, bad signature, downgrade too far, etc.)
3. UPDATE_FAILED, things can continue as normally
4. HARDWARE_UNSAFE, declare the PSP dead, since the behavior of the SEV
   firmware is undefined
5. RESTORE_REQUIRED, the firmware can only successfully execute
   DOWNLOAD_FIRMWARE_EX commands. The admin needs to load the old firmware
   image.

There is a firmware bug where upgrades across 1.58.03 time out, even though
the upgrade actually succeeds. There is no documented way to determine what
the input firmware version is, so there is no way to detect this case
before trying a firmware update. Instead look for the timeout and try an
SNP_PLATFORM_STATUS to see if the PSP is still alive.

Finally, this differs from the previous implementation [1] in a couple of
ways:

1. guest context pages are no longer required to be updated as of 1.58 of
   the SEV-SNP Firmware spec doc 56860.
2. no WBINVD+DF_FLUSH is required after a firmware update, so it drops that
   code

[1]: https://lore.kernel.org/lkml/20241112232253.3379178-7-dionnaglaze@google.com/
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 244 ++++++++++++++++++++++++++++++++++-
 1 file changed, 243 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b4711bf823e8..e7fe6dbf69c2 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -90,6 +90,8 @@ MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
 
 static bool psp_dead;
 static int psp_timeout;
+static bool dlfwex_wants_rollback;
+static bool sev_firmware_needs_reinit;
 
 enum snp_hv_fixed_pages_state {
 	ALLOCATED,
@@ -2046,11 +2048,251 @@ static enum fw_upload_err sev_fw_upload_prepare(struct fw_upload *fw_upload,
 	return FW_UPLOAD_ERR_NONE;
 }
 
+static int sev_download_firmware_ex(struct sev_device *sev, const u8 *data,
+				    u32 size)
+{
+	struct sev_data_download_firmware_ex sev_data = {0};
+	int ret, error = 0, order;
+	struct page *p;
+	void *fw_blob;
+
+	order = get_order(size);
+	p = alloc_pages(GFP_KERNEL, order);
+	if (!p)
+		return -ENOMEM;
+
+	fw_blob = page_address(p);
+	memcpy(fw_blob, data, size);
+
+	sev_data.len = sizeof(sev_data);
+	sev_data.fw_paddr = __psp_pa(fw_blob);
+	sev_data.fw_len = size;
+	sev_data.commit = 0;
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, &sev_data, &error);
+
+	/*
+	 * Quirk: firmware upgrades across 1.58.03 give ETIMEDOUT for
+	 * DLFWEX, even though the command actually succeeds. If we're
+	 * in this case, test that we can do SNP_PLATFORM_STATUS, and
+	 * if so, continue as normal.
+	 */
+	if (ret == -ETIMEDOUT) {
+		struct sev_user_data_snp_status status;
+
+		dev_info(sev->dev, "Firmware update timed out, checking status for quirk...\n");
+		psp_dead = false;
+
+		ret = __sev_do_snp_platform_status(&status, &error);
+		if (ret) {
+			dev_err(sev->dev, "SNP STATUS failed after firmware upgrade, ret = %d, error = %#x\n",
+				ret, error);
+			psp_dead = true;
+			goto out;
+		}
+	}
+
+	if (ret < 0 && error != 0)
+		ret = error;
+
+out:
+	__free_pages(p, order);
+	return ret;
+}
+
+static int sev_firmware_shutdown_if_sev_initialized(struct sev_device *sev)
+{
+	int rc, error, sev_plat_state;
+
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	error = 0;
+	rc = sev_get_platform_state(&sev_plat_state, &error);
+	if (rc < 0) {
+		if (error)
+			rc = error;
+		dev_dbg(sev->dev, "SEV get platform state failed %d\n", rc);
+		return rc;
+	}
+
+	switch (sev_plat_state) {
+	case SEV_STATE_UNINIT:
+		return 0;
+	case SEV_STATE_INIT:
+		error = 0;
+		rc = __sev_platform_shutdown_locked(&error);
+		if (rc) {
+			if (error)
+				rc = error;
+			dev_err(sev->dev, "SEV platform shutdown failed %d\n", rc);
+			return rc;
+		}
+		sev_firmware_needs_reinit = true;
+		return 0;
+	case SEV_STATE_WORKING:
+		return -EBUSY;
+	default:
+		dev_err(sev->dev, "Unknown SEV firmware state: %d\n", sev_plat_state);
+		return -EINVAL;
+	}
+}
+
+static void sev_firmware_reinit_if_shutdown(struct sev_device *sev)
+{
+	int rc, error;
+
+	guard(mutex)(&sev_cmd_mutex);
+
+	if (!sev_firmware_needs_reinit)
+		return;
+
+	sev_firmware_needs_reinit = false;
+	error = 0;
+	rc = __sev_platform_init_locked(&error);
+	if (rc) {
+		if (error)
+			rc = error;
+		dev_err(sev->dev, "SEV platform re-init failed %d\n", rc);
+	}
+}
+
 static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
 					      const u8 *data, u32 offset,
 					      u32 size, u32 *written)
 {
-	return FW_UPLOAD_ERR_BUSY;
+	struct sev_device *sev = fw_upload->dd_handle;
+	u8 old_major, old_minor, old_build;
+	int rc, error = 0;
+	enum fw_upload_err ret;
+
+	if (offset != 0)
+		return FW_UPLOAD_ERR_INVALID_SIZE;
+
+	old_major = sev->api_major;
+	old_minor = sev->api_minor;
+	old_build = sev->build;
+
+	mutex_lock(&sev_cmd_mutex);
+
+	/*
+	 * If the last firmware update returned RESTORE_REQUIRED, allow only
+	 * this DLFWEX command so the admin can restore the previous FW
+	 * version. If we are in this state the legacy firmware has previously
+	 * been shut down, so no need to do it again.
+	 */
+	if (dlfwex_wants_rollback && psp_dead) {
+		dlfwex_wants_rollback = false;
+		psp_dead = false;
+	} else {
+		rc = sev_firmware_shutdown_if_sev_initialized(sev);
+		if (rc) {
+			ret = FW_UPLOAD_ERR_BUSY;
+			goto unlock;
+		}
+	}
+
+	rc = sev_download_firmware_ex(sev, data, size);
+	if (rc) {
+		ret = FW_UPLOAD_ERR_FW_INVALID;
+		switch (rc) {
+		case SEV_RET_INVALID_PLATFORM_STATE:
+			fallthrough;
+		case SEV_RET_INVALID_ADDRESS:
+			/* these are probably kernel bugs */
+			WARN_ON_ONCE(true);
+			ret = FW_UPLOAD_ERR_BUSY;
+			goto unlock;
+		case SEV_RET_INVALID_LEN:
+			ret = FW_UPLOAD_ERR_INVALID_SIZE;
+			goto unlock;
+		case SEV_RET_INVALID_PARAM:
+			dev_err(sev->dev, "SEV firmware image is not well formed\n");
+			goto unlock;
+		case SEV_RET_SHUTDOWN_REQUIRED:
+			dev_err(sev->dev, "SEV firmware too far, shutdown required\n");
+			goto unlock;
+		case SEV_RET_INVALID_CONFIG:
+			dev_err(sev->dev, "SEV firmware upgrade would rollback SVN\n");
+			goto unlock;
+		case SEV_RET_BAD_SIGNATURE:
+			dev_err(sev->dev, "SEV firmware upgrade bad signature\n");
+			goto unlock;
+		case SEV_RET_BAD_VERSION:
+			dev_err(sev->dev, "SEV firmware upgrade less than CommittedVersion\n");
+			goto unlock;
+		case SEV_RET_UNSUPPORTED:
+			dev_err(sev->dev, "SEV firmware required feature not supported\n");
+			goto unlock;
+		case SEV_RET_UPDATE_FAILED:
+			/*
+			 * Update failed but fw rolled back on its own,
+			 * operation can continue normally.
+			 */
+			dev_err(sev->dev, "SEV firmware update failed\n");
+			ret = FW_UPLOAD_ERR_HW_ERROR;
+			goto unlock;
+		case SEV_RET_HWSEV_RET_UNSAFE:
+			/*
+			 * "Following a return of HARDWARE_UNSAFE, operation of
+			 * the SEV firmware is indeterminate
+			 * and the recommendation is to reboot the platform."
+			 */
+			dev_err(sev->dev, "SEV firmware no longer safe to operate\n");
+			psp_dead = true;
+			ret = FW_UPLOAD_ERR_HW_ERROR;
+			goto unlock;
+		case SEV_RET_RESTORE_REQUIRED:
+			/*
+			 * FW asked us to roll back; we don't hold onto the
+			 * last FW image, so we can't. We can set a flag to
+			 * allow the admin to rollback if they happen to have
+			 * the old firmware image handy.
+			 */
+			dev_err(sev->dev, "SEV firmware update failed, please roll back\n");
+			psp_dead = true;
+			dlfwex_wants_rollback = true;
+			ret = FW_UPLOAD_ERR_HW_ERROR;
+			goto unlock;
+		default:
+			dev_err(sev->dev, "Unknown SEV firmware err %d\n", rc);
+			ret = FW_UPLOAD_ERR_HW_ERROR;
+			goto unlock;
+		}
+	}
+
+	*written = size;
+	ret = FW_UPLOAD_ERR_NONE;
+
+unlock:
+	mutex_unlock(&sev_cmd_mutex);
+
+	/*
+	 * sev_get_api_version() updates the SEV and SNP statuses, SNP feature
+	 * info if available, build numbers, etc. cached in struct sev_device.
+	 * Update these if they may have changed for new firmware.
+	 */
+	if (ret == FW_UPLOAD_ERR_NONE) {
+		error = 0;
+
+		rc = sev_get_api_version();
+		if (rc) {
+			dev_warn(sev->dev,
+				 "SNP platform data refresh after firmware update failed %d\n",
+				 rc);
+		} else if (sev->api_major != old_major ||
+			   sev->api_minor != old_minor ||
+			   sev->build != old_build) {
+			dev_info(sev->dev, "SEV firmware updated to %d.%d build %d\n",
+				 sev->api_major, sev->api_minor, sev->build);
+		} else {
+			dev_info(sev->dev, "SEV firmware not updated\n");
+		}
+	}
+
+	if (!dlfwex_wants_rollback)
+		sev_firmware_reinit_if_shutdown(sev);
+
+	return ret;
 }
 
 static enum fw_upload_err sev_fw_upload_poll_complete(struct fw_upload *fw_upload)
-- 
2.54.0

