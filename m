Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA98225A34;
	Thu,  6 Feb 2025 09:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738833690; cv=none; b=uNAGajf8rbYHYa7S3LbPlbz/9TLRPDy7JZC76U34yaFPkqx7xRaFwr1zVO+BvKhw/bab0BqCW4d+xk16tWyvG3rwemly5Iq4PeimxH+zKZ+uyT0mJuEAvOzGTZOIR2AZ+JboieNwW6eXFhoEQ/th2VpSRBEyRUEDvzfHmapRgO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738833690; c=relaxed/simple;
	bh=20jKvm61h8SpiA1T/jSmJOZ7YwpSo4CNuL2QjEvnKiU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HeSQ617pjThCLv3Eb9HIJ5ocivnyfEdx9wU98assniT0M8IkhUa9QdPzRJYdKAtjjDx16369fBAkrxvszySALM2Pu13L2g/no/4U2Nx5mzDL+yj0iitej3im/Sx2Wpx+A4YkyTXIGnfxArLNOKJtZd4Rs0TcvvNLHuFqInZwQKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Y6TbVl68; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Y6TbVl68"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 5169L0aC3525872
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 03:21:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1738833660;
	bh=q/hPjfrmBqGxLdAhschBZsF6fpecnKff2pCdRQJEkKM=;
	h=From:To:CC:Subject:Date;
	b=Y6TbVl68Ibizx7RIPtSmeC2N5R5Ca8bfs0aZA6vbn+xXBwzktXlVw6FOsDTT8Qyad
	 4pHlKzcpa0THLDN/zhVELahIhrlyvPmP7MjgWFeXArRROceIO+mfuobxH7JSYe4Dz9
	 u/lRyJ3izAzRLzxh33gElIbE+ADzMkpa6N3hAE2Q=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 5169L0Ul007091
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 6 Feb 2025 03:21:00 -0600
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 6
 Feb 2025 03:20:59 -0600
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 6 Feb 2025 03:20:59 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 5169Kwr3009086;
	Thu, 6 Feb 2025 03:20:59 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski
	<krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Catalin Marinas
	<catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vignesh Raghavendra
	<vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh Gurudasani
	<kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH RFC 0/3] Add support for Texas Instruments DTHE V2 crypto accelerator
Date: Thu, 6 Feb 2025 14:44:29 +0530
Message-ID: <20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20250205-dthe-v2-aes-80ea2dd58185
X-Mailer: b4 0.14.2
Content-Transfer-Encoding: 8bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

This adds support for TI DTHE V2 crypto accelerator. DTHE V2 is a new
crypto accelerator which contains multiple crypto IPs.
This series implements support for ECB and CBC modes of the AES Engine
of DTHE, using skcipher APIs of the kernel.

Tested with:
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_MANAGER_EXTAR_TESTS=y

and tcrypt,
sudo modprobe tcrypt mode=500 sec=1

Signed-off-by: T Pratham <t-pratham@ti.com>
---
T Pratham (3):
      dt-bindings: crypto: Add binding for TI DTHE V2 driver
      crypto: ti: Add driver for DTHE V2 AES Engine (ECB, CBC)
      arm64: defconfig: enable DTHE V2 module

 .../devicetree/bindings/crypto/ti,dthev2.yaml      |  50 ++
 MAINTAINERS                                        |   7 +
 arch/arm64/configs/defconfig                       |   1 +
 drivers/crypto/Kconfig                             |   1 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/ti/Kconfig                          |  11 +
 drivers/crypto/ti/Makefile                         |   1 +
 drivers/crypto/ti/dthev2.c                         | 749 +++++++++++++++++++++
 8 files changed, 821 insertions(+)
---
base-commit: 9d4f8e54cef2c42e23ef258833dbd06a1eaff89b
change-id: 20250205-dthe-v2-aes-80ea2dd58185

Best regards,
-- 
T Pratham <t-pratham@ti.com>

