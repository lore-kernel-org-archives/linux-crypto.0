Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A700372AAE;
	Wed, 19 Nov 2025 20:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763585994; cv=none; b=khSUsQbf3pHhOgM4MayIzzN3UZlrfnHkFsGxZJSVXbBRLg8Oo0jVXnMyfrN+RjgWCCmrEXIK3k/sv5aOjPBbVmjJzx74njssyPJ4Fwq7i6saU9nIdeLmVicMe3KIvGlYSXgjHpdH2XInRUnH+FF8BjwMRKDBjSp4v4Am2ojY4nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763585994; c=relaxed/simple;
	bh=CISrx6QYClhrudxAgbXAEmIiAHmEXmhmttNDNwZ/YIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TniHMJ/fjaBxbhWTZl7K2iuPSkoxv68xc0KAnWYeN/D3efwdcbaDoVYJu0BdtPaKXccLOEgPx5nl3zvwoYXjnH6RAKmZuY8NfhDyMKSONIW8Vu6x+dfLGkzxgwXqtLotFrJ3L5noG5zhVOh+LRtQw7pBHRu/tN6zJgve5lLxcP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFEVWn7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFEVWn7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEA2C116B1;
	Wed, 19 Nov 2025 20:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763585993;
	bh=CISrx6QYClhrudxAgbXAEmIiAHmEXmhmttNDNwZ/YIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFEVWn7aKL2Ff7OHg+qvQ6hqEH6kI8t1o3eeci0eh6PQa52THtv/UhxwCPYql8qhZ
	 Ljtst/bFsa5Z+6c4S0qPi9m3NhfLsfldk9SE9c7nZv2dFexlKGobZNvli5UzCqoaJy
	 u0sjPa/3jBoTHN5JwrES0f1yc1IAdwPYHKxg34EprUsiMrtwtzXhOg6oHeOtavP4XF
	 iRVgVF5y+m7d2rv4fZdrdcSOFiUSQOae/isVwVZn8YK0mohnvAoKfNT6XozvIBqSWY
	 Bbk2w8MZHSRsOGsGcaii1l+qRIgiWuvS/IscNGJndS9z8fieEezMQ13BLbbeSAhcgf
	 n+FltIctd+usg==
From: "Mario Limonciello (AMD)" <superm1@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Hans de Goede <hansg@kernel.org>,
	linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER),
	platform-driver-x86@vger.kernel.org (open list:AMD PMF DRIVER),
	Lars Francke <lars.francke@gmail.com>,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Mario Limonciello <superm1@kernel.org>
Subject: [PATCH 1/2] platform/x86/amd/pmf: Prevent TEE errors after hibernate
Date: Wed, 19 Nov 2025 14:59:41 -0600
Message-ID: <20251119205942.3411155-2-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119205942.3411155-1-superm1@kernel.org>
References: <20251119205942.3411155-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

After resuming from hibernate, TEE commands can time out and cause PSP
disables. Fix this by reinitializing the Trusted Application (TA) and
cancelling the pb workqueue in the hibernate callbacks to avoid these
errors.

ccp 0000:c4:00.2: tee: command 0x5 timed out, disabling PSP
amd-pmf AMDI0107:00: TEE enact cmd failed. err: ffff000e, ret:0
amd-pmf AMDI0107:00: TEE enact cmd failed. err: ffff000e, ret:0
amd-pmf AMDI0107:00: TEE enact cmd failed. err: ffff000e, ret:0

Fixes: ae82cef7d9c5 ("platform/x86/amd/pmf: Add support for PMF-TA interaction")
Reported-by: Lars Francke <lars.francke@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
Co-developed-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
[ML: Add more tags]
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
 drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
 drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
 3 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index bc544a4a5266e..e787480f4df26 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -314,6 +314,61 @@ int amd_pmf_init_metrics_table(struct amd_pmf_dev *dev)
 	return 0;
 }
 
+static int amd_pmf_reinit_ta(struct amd_pmf_dev *pdev)
+{
+	bool status;
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(amd_pmf_ta_uuid); i++) {
+		ret = amd_pmf_tee_init(pdev, &amd_pmf_ta_uuid[i]);
+		if (ret) {
+			dev_err(pdev->dev, "TEE init failed for UUID[%d] ret: %d\n", i, ret);
+			return ret;
+		}
+
+		ret = amd_pmf_start_policy_engine(pdev);
+		dev_dbg(pdev->dev, "start policy engine ret: %d (UUID idx: %d)\n", ret, i);
+		status = ret == TA_PMF_TYPE_SUCCESS;
+		if (status)
+			break;
+		amd_pmf_tee_deinit(pdev);
+	}
+
+	return 0;
+}
+
+static int amd_pmf_restore_handler(struct device *dev)
+{
+	struct amd_pmf_dev *pdev = dev_get_drvdata(dev);
+	int ret;
+
+	if (pdev->buf) {
+		ret = amd_pmf_set_dram_addr(pdev, false);
+		if (ret)
+			return ret;
+	}
+
+	if (pdev->smart_pc_enabled)
+		amd_pmf_reinit_ta(pdev);
+
+	return 0;
+}
+
+static int amd_pmf_freeze_handler(struct device *dev)
+{
+	struct amd_pmf_dev *pdev = dev_get_drvdata(dev);
+
+	if (!pdev->smart_pc_enabled)
+		return 0;
+
+	cancel_delayed_work_sync(&pdev->pb_work);
+	/* Clear all TEE resources */
+	amd_pmf_tee_deinit(pdev);
+	pdev->session_id = 0;
+
+	return 0;
+}
+
 static int amd_pmf_suspend_handler(struct device *dev)
 {
 	struct amd_pmf_dev *pdev = dev_get_drvdata(dev);
@@ -347,7 +402,12 @@ static int amd_pmf_resume_handler(struct device *dev)
 	return 0;
 }
 
-static DEFINE_SIMPLE_DEV_PM_OPS(amd_pmf_pm, amd_pmf_suspend_handler, amd_pmf_resume_handler);
+static const struct dev_pm_ops amd_pmf_pm = {
+	.suspend = amd_pmf_suspend_handler,
+	.resume = amd_pmf_resume_handler,
+	.freeze = amd_pmf_freeze_handler,
+	.restore = amd_pmf_restore_handler,
+};
 
 static void amd_pmf_init_features(struct amd_pmf_dev *dev)
 {
diff --git a/drivers/platform/x86/amd/pmf/pmf.h b/drivers/platform/x86/amd/pmf/pmf.h
index bd19f2a6bc786..2da1885d87915 100644
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -122,6 +122,12 @@ struct cookie_header {
 
 typedef void (*apmf_event_handler_t)(acpi_handle handle, u32 event, void *data);
 
+static const uuid_t amd_pmf_ta_uuid[] __used = { UUID_INIT(0xd9b39bf2, 0x66bd, 0x4154, 0xaf, 0xb8,
+							   0x8a, 0xcc, 0x2b, 0x2b, 0x60, 0xd6),
+						 UUID_INIT(0x6fd93b77, 0x3fb8, 0x524d, 0xb1, 0x2d,
+							   0xc5, 0x29, 0xb1, 0x3d, 0x85, 0x43),
+					       };
+
 /* APTS PMF BIOS Interface */
 struct amd_pmf_apts_output {
 	u16 table_version;
@@ -888,4 +894,8 @@ void amd_pmf_populate_ta_inputs(struct amd_pmf_dev *dev, struct ta_pmf_enact_tab
 void amd_pmf_dump_ta_inputs(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in);
 int amd_pmf_invoke_cmd_enact(struct amd_pmf_dev *dev);
 
+int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid);
+void amd_pmf_tee_deinit(struct amd_pmf_dev *dev);
+int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev);
+
 #endif /* PMF_H */
diff --git a/drivers/platform/x86/amd/pmf/tee-if.c b/drivers/platform/x86/amd/pmf/tee-if.c
index 6e8116bef4f6a..9030459352375 100644
--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -27,12 +27,6 @@ module_param(pb_side_load, bool, 0444);
 MODULE_PARM_DESC(pb_side_load, "Sideload policy binaries debug policy failures");
 #endif
 
-static const uuid_t amd_pmf_ta_uuid[] = { UUID_INIT(0xd9b39bf2, 0x66bd, 0x4154, 0xaf, 0xb8, 0x8a,
-						    0xcc, 0x2b, 0x2b, 0x60, 0xd6),
-					  UUID_INIT(0x6fd93b77, 0x3fb8, 0x524d, 0xb1, 0x2d, 0xc5,
-						    0x29, 0xb1, 0x3d, 0x85, 0x43),
-					};
-
 static const char *amd_pmf_uevent_as_str(unsigned int state)
 {
 	switch (state) {
@@ -312,7 +306,7 @@ static void amd_pmf_invoke_cmd(struct work_struct *work)
 	schedule_delayed_work(&dev->pb_work, msecs_to_jiffies(pb_actions_ms));
 }
 
-static int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev)
+int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev)
 {
 	struct cookie_header *header;
 	int res;
@@ -468,7 +462,7 @@ static int amd_pmf_register_input_device(struct amd_pmf_dev *dev)
 	return 0;
 }
 
-static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
+int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 {
 	u32 size;
 	int ret;
@@ -516,7 +510,7 @@ static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 	return ret;
 }
 
-static void amd_pmf_tee_deinit(struct amd_pmf_dev *dev)
+void amd_pmf_tee_deinit(struct amd_pmf_dev *dev)
 {
 	if (!dev->tee_ctx)
 		return;
-- 
2.43.0

