Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE1A13A265;
	Mon,  8 Sep 2025 14:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757340597; cv=none; b=jVBTTXGqRS9k8gi9L5wJAZD14J9aAZ3kItZTfp0B3vxzRvH3BdnkVHFZLZmwBq+AabJfV+t/o9b0sLXnu51oe/MsE65esFN9dNhpzSaoRJOq7wivQWlXQ5hyv+APUTgONtHaDSFyzp01pkcqzaJu3i9vyCZv/V5p6MnmsjvNftg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757340597; c=relaxed/simple;
	bh=YW+xAgdLVyCk99Eihf1XRUWln1sdB+Hmcsil+FRwzfo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e+Z//UQw+bL9VDyEeFn7yVACpnEB1QgY7VQ2KX8llYoCTDD5TX2BB9D5gXJG4JvyMDVEr7jxbvYvVZr2pbpuGqAYNYeqj50xlTNDMMvLfc7TQe46HW4ZJwnxDBtUVOW0jaaS4NMfngxrkB5OpJ6JgFOX1xxIr1rXaz3EVUrMmYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=qYWqVTXN; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="qYWqVTXN"
Received: from fllvem-sh03.itg.ti.com ([10.64.41.86])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 588E9jYO3879893;
	Mon, 8 Sep 2025 09:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1757340585;
	bh=/I/ByhsHvnoWmzLYIldv0FWBH08ruQzyjUzN4XwE4lc=;
	h=From:To:CC:Subject:Date;
	b=qYWqVTXNDBFzonMpgjJP5SmmpmBH4UwU8fc6QxbrYRZSbmMkbVIMjMyWf6Bp6JSTk
	 NihMzJBiHYJGFk/mYXHQ+kmcVF3/DIOqGp5NjvpPqueLt/bnN0mU1OHoElBc8Qlyfc
	 zQne0AQzIA81lZOCM7HKgvmkouL/O8mKkerHTrA0=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
	by fllvem-sh03.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 588E9irZ3052648
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Mon, 8 Sep 2025 09:09:44 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Mon, 8
 Sep 2025 09:09:44 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Mon, 8 Sep 2025 09:09:44 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 588E9g8L718225;
	Mon, 8 Sep 2025 09:09:43 -0500
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
Subject: [PATCH v2 0/4] Add support for more AES modes in TI DTHEv2
Date: Mon, 8 Sep 2025 19:28:12 +0530
Message-ID: <20250908140928.2801062-1-t-pratham@ti.com>
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
(CRYPTO_SELFTESTS) which all pass successfully [3].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: DTHEv2 AES Engine kernel self-tests logs
Link: https://gist.github.com/Pratham-T/aaa499cf50d20310cb27266a645bfd60

Change log:
v2:
 - Corrected assignment of variable unpadded_cryptlen in dthe_aead_run.
 - Removed some if conditions which are always false, and documented the
   cases in comments.
 - Moved polling of TAG ready register to a separate function and
   returning -ETIMEDOUT on poll timeout.
 - Corrected comments to adhere to kernel coding guidelines.

Link to previous version:
v1: https://lore.kernel.org/all/20250905133504.2348972-4-t-pratham@ti.com/
---

T Pratham (4):
  crypto: ti: Add support for AES-XTS in DTHEv2 driver
  crypto: ti: Add support for AES-CTR in DTHEv2 driver
  crypto: ti: Add support for AES-GCM in DTHEv2 driver
  crypto: ti: Add support for AES-CCM in DTHEv2 driver

 drivers/crypto/ti/Kconfig         |   5 +
 drivers/crypto/ti/dthev2-aes.c    | 818 +++++++++++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.c |  19 +
 drivers/crypto/ti/dthev2-common.h |  30 +-
 4 files changed, 864 insertions(+), 8 deletions(-)

-- 
2.43.0

