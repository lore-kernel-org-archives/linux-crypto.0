Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC3024169D;
	Wed, 10 Sep 2025 10:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757498896; cv=none; b=LgCdxe7BImwUB6Q1Z1xdfQ/n97jKbumIcRtiW79vIwBzCijjN1Zq1S5/+Bx95+FKnyWYXCrtKH/vfatA1CY+rKKKPKAEkFwFtDyy7kLhOxVQbcBSj5ApFkb9BvVQEv4AMQ6TxYer/duO3hLnHXNtaStiWIUyZTTkzvCJ7llkczU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757498896; c=relaxed/simple;
	bh=EtUfUkvzb7E29pnUfb+7GcBsZuRcPtDZR4KAbwm/U7c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UzugyIL4Yqc7H7SFjpZQVCF2t6BzpVajxBhWjY9XuR87Utt1l/2qy4YfGXMJPFlNPwbI8AAtF94NQN5dkIuL7TsKcX66hn54Ka74W0Sp5qLsCeypJfC1xYEkldZ5lpAi1hrV2u/WrYnDhVVrN2AuTUmqTj9NHU3yglNj8n6CD1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=h/cSepim; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="h/cSepim"
Received: from fllvem-sh03.itg.ti.com ([10.64.41.86])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 58AA830u116384;
	Wed, 10 Sep 2025 05:08:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1757498883;
	bh=gCENm792EnFeoaPQ3uL6l9LeUPkozNrQPVe1cUFoG3I=;
	h=From:To:CC:Subject:Date;
	b=h/cSepim0CVeWg7ynZRq5YWchL15fMY5xoN502iM76wvSKOBSfkyFV/mJFAD8LTQb
	 tENXy9FtUjIfqBK6nPCh1JJX4IfQRsyLXZAj2zHWkSEEJO38RxcQ+Ssqc1y5LgKAZi
	 7pWFhkncBBYZQGu1cBfcVEYMgIzlzj5wdYMo1NDw=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
	by fllvem-sh03.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 58AA82kh293113
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Wed, 10 Sep 2025 05:08:02 -0500
Received: from DFLE200.ent.ti.com (10.64.6.58) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Wed, 10
 Sep 2025 05:08:02 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 10 Sep 2025 05:08:02 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 58AA80f4317718;
	Wed, 10 Sep 2025 05:08:01 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Kamlesh Gurudasani <kamlesh@ti.com>,
        Manorit
 Chawdhry <m-chawdhry@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth
 Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Kavitha
 Malarvizhi <k-malarvizhi@ti.com>
Subject: [PATCH v3 0/4] Add support for more AES modes in TI DTHEv2
Date: Wed, 10 Sep 2025 14:46:52 +0530
Message-ID: <20250910100742.3747614-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 and details of AES modes supported were detailed in
[1]. Additional hardware details available in SoC TRM [2].

This patch series adds support for the following AES modes:
 - AES-XTS
 - AES-CTR
 - AES-GCM
 - AES-CCM

The driver is tested using full kernel crypto selftests
(CRYPTO_SELFTESTS_FULL) which all pass successfully [3].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: DTHEv2 AES Engine kernel self-tests logs
Link: https://gist.github.com/Pratham-T/aaa499cf50d20310cb27266a645bfd60

Change log:
v3:
 - Added header files to remove implicit declaration error.
 - Corrected assignment of src_nents and dst_nents in dthe_aead_run
 (Ran the lkp kernel test bot script locally to ensure no more such
 errors are present)
v2:
 - Corrected assignment of variable unpadded_cryptlen in dthe_aead_run.
 - Removed some if conditions which are always false, and documented the
   cases in comments.
 - Moved polling of TAG ready register to a separate function and
   returning -ETIMEDOUT on poll timeout.
 - Corrected comments to adhere to kernel coding guidelines.

Link to previous version:

v2: https://lore.kernel.org/all/20250908140928.2801062-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250905133504.2348972-4-t-pratham@ti.com/
---

T Pratham (4):
  crypto: ti: Add support for AES-XTS in DTHEv2 driver
  crypto: ti: Add support for AES-CTR in DTHEv2 driver
  crypto: ti: Add support for AES-GCM in DTHEv2 driver
  crypto: ti: Add support for AES-CCM in DTHEv2 driver

 drivers/crypto/ti/Kconfig         |   5 +
 drivers/crypto/ti/dthev2-aes.c    | 820 +++++++++++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.c |  19 +
 drivers/crypto/ti/dthev2-common.h |  30 +-
 4 files changed, 866 insertions(+), 8 deletions(-)

-- 
2.43.0

