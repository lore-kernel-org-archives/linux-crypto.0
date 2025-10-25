Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BC1305053;
	Sat, 25 Oct 2025 16:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409306; cv=none; b=i6RKJvf+djneyoIJ8KI4r/I72uVajwOk/CzEubjQNhyS0O8VLimRMeDCqrxankxJjAkD5ZuGw+DZwsTpul4bPcVoJBQJ8kbdF/YQ4cBjbhEnQPr+7KiSjKga7OLNXsrpUsFXnDV1xnypkOSakBrZofJbvOy8VAnJEXuEsDwyvTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409306; c=relaxed/simple;
	bh=aRQJe2poTPrnWBH5HHvGmBBnV+TzAYtQT4ZwKTNjPZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lwKACoDfiFquzv+JYM6y06NbF02tZua6zXXSm3H45DT8c8LwYpFcifMNC7mTouwW9F55hr3VaCelVAe1SeOGCoGrP6qdbBoBStE3ADqHqqNVJ9N/wdHPHns42UMaRtHJuw2RoP9b8OpZLgZgIQYK60CM92gRXNp/8icokFL2UJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbodeaN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbodeaN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDCDC2BCB2;
	Sat, 25 Oct 2025 16:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409305;
	bh=aRQJe2poTPrnWBH5HHvGmBBnV+TzAYtQT4ZwKTNjPZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbodeaN9CtmecEydHHn7O876VrD9tZN7/KXvjciezxTC7er+uBs9o/HNJ6mA7pv6m
	 ngg/tUg39OdcEIlGmlXC7Kfe5V5kGMD/hz+lMmYcsnoGlinLV4DuJV+E//5997nrFP
	 fEIQJOg0fJpNV4LFFaGJpl11IwXARXkZIlekJ4pqcWyrE1x2JHnIEi8W6xqs6/Sdnw
	 9vFRRjQWfpBDffpk2u6g88jS6Pbr6crwpQaftVL+aUQ+0xzRwz81YyQqvrsuYf8n+Z
	 WwRoCZWNcHdu9Lz0spsop9kWOrocOYUkKWPHMBEAdhshzfJNEBMFIuLYy9vtVYKiT7
	 2oCrVp9vItVOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	thomas.lendacky@amd.com,
	john.allen@amd.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] crypto: ccp: Skip SEV and SNP INIT for kdump boot
Date: Sat, 25 Oct 2025 11:58:23 -0400
Message-ID: <20251025160905.3857885-272-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit 8c571019d8a817b701888926529a5d7a826b947b ]

Since SEV or SNP may already be initialized in the previous kernel,
attempting to initialize them again in the kdump kernel can result
in SNP initialization failures, which in turn lead to IOMMU
initialization failures. Moreover, SNP/SEV guests are not run under a
kdump kernel, so there is no need to initialize SEV or SNP during
kdump boot.

Skip SNP and SEV INIT if doing kdump boot.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Link: https://lore.kernel.org/r/d884eff5f6180d8b8c6698a6168988118cf9cba1.1756157913.git.ashish.kalra@amd.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes real kdump failures: Reinitializing SEV/SNP in the kdump kernel
  can fail SNP init and cascade into AMD IOMMU init failures, preventing
  reliable crash dumps. Skipping SEV/SNP init in kdump avoids this
  failure mode and aligns with the fact that SEV/SNP guests aren’t run
  under kdump.
- Minimal, targeted change: Adds `#include <linux/crash_dump.h>` to
  access `is_kdump_kernel()` and short-circuits SEV/SNP init only when
  booted as kdump.
  - Include added: drivers/crypto/ccp/sev-dev.c:31
  - Early return on kdump: drivers/crypto/ccp/sev-dev.c:1627
- Normal boots unaffected: Outside kdump, the init path is unchanged and
  continues to:
  - Return early if already initialized: drivers/crypto/ccp/sev-
    dev.c:1632
  - Attempt SNP init: drivers/crypto/ccp/sev-dev.c:1635
  - Then legacy SEV init: drivers/crypto/ccp/sev-dev.c:1643
- Callers consistent with design: `sev_platform_init()` is primarily
  invoked when setting up SEV/SNP VMs (e.g., KVM path) and won’t be used
  in a kdump kernel where VMs aren’t launched:
  - KVM caller example: arch/x86/kvm/svm/sev.c:448
- Established pattern: Many subsystems adjust behavior based on
  `is_kdump_kernel()`, including AMD IOMMU, reinforcing that deferring
  hardware state churn in kdump is correct and expected.
  - Example precedent: drivers/iommu/amd/init.c:409
- Low regression risk: The change is a simple guard that only applies in
  kdump. It avoids reprogramming PSP/SEV/SNP during a crash kernel,
  which is specifically where hardware re-init is fragile. It does not
  introduce new features or alter interfaces.
- Backport considerations: Older stable trees may have minor local
  differences (e.g., `sev->state` vs. `sev->sev_plat_status.state`, or
  `__sev_snp_init_locked` signature). The kdump guard itself is trivial
  to adapt and `is_kdump_kernel()` is long-standing and available via
  `linux/crash_dump.h`.

Conclusion: This is a small, well-scoped bug fix that improves kdump
robustness on SEV/SNP systems with minimal risk and no architectural
changes. It meets stable backport criteria.

 drivers/crypto/ccp/sev-dev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9f5ccc1720cbc..651346db6909d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -28,6 +28,7 @@
 #include <linux/fs_struct.h>
 #include <linux/psp.h>
 #include <linux/amd-iommu.h>
+#include <linux/crash_dump.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -1345,6 +1346,15 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (!psp_master || !psp_master->sev_data)
 		return -ENODEV;
 
+	/*
+	 * Skip SNP/SEV initialization under a kdump kernel as SEV/SNP
+	 * may already be initialized in the previous kernel. Since no
+	 * SNP/SEV guests are run under a kdump kernel, there is no
+	 * need to initialize SNP or SEV during kdump boot.
+	 */
+	if (is_kdump_kernel())
+		return 0;
+
 	sev = psp_master->sev_data;
 
 	if (sev->state == SEV_STATE_INIT)
-- 
2.51.0

