Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2F620DD47;
	Fri, 11 Apr 2025 09:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744363294; cv=none; b=lli1xI+yBkk5+DrP/R5jfpH/bKMCICKhuAcCZpd3LfdZBdruLICNvgybd8N6Aa5MZl934eAktiC/V3NmjwhE4qSy+faz1WV4peck5Wsn5jXQK9b4zBqXKNgG5osw/lZ+IOMm6tMQvjKQAMauGJgi4ukz8kEWj0dDF1wVC9Y5oqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744363294; c=relaxed/simple;
	bh=GF5I4HDrY8UX8vkATNsvnxdK5wqH9mXL9n37eldxjZM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sRJK+l5GyG9qR/Lw70TMbc5ckCm8KX7jS9x0jCRfUf3GpKxCQNjfsQU4l9Z+PpOXsbieon2FBx5YXoeBO+Zx6k4KPxCKjuy6sMgXAZFlv0+k5Lml+SyCdCet8Kkbln2qW0bTnLVBCH6HbZ4mpLGyZZaWQKdGnO70Nfj5zNnEbaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=VDswg6FJ; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="VDswg6FJ"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 53B9LH5U2078754
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 04:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1744363278;
	bh=0NX2vOw4ZRae1V2JRwjOkGJo9DQjMbPoKMVpYg1An7o=;
	h=From:To:CC:Subject:Date;
	b=VDswg6FJmWylPIyKVoVYZJFRFJ1MAgSyVk0C8+MFMxyL/C1AUMpXGGNf/AKa8okqM
	 B9iK/4Joci6KdGBoXX5gwGvHssIWeBKou5CPRYX7jvptu2xQChMn0YIKZCA/MplJbX
	 X+OJf0RdlC3amiQvcH8Lv/o8wbfBnPJrKq8XErYA=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 53B9LHvS054119
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Apr 2025 04:21:17 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 11
 Apr 2025 04:21:17 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 11 Apr 2025 04:21:17 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 53B9LGv1053002;
	Fri, 11 Apr 2025 04:21:16 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski
	<krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Vignesh
 Raghavendra <vigneshr@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH v2 0/2] Add support for Texas Instruments DTHE V2 crypto accelerator
Date: Fri, 11 Apr 2025 14:43:20 +0530
Message-ID: <20250411091321.2925308-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

This series adds support for TI DTHE V2 crypto accelerator. DTHE V2 is a
new crypto accelerator which contains multiple crypto IPs [1].
This series implements support for ECB and CBC modes of AES for the AES
Engine of DTHE, using skcipher APIs of the kernel.

Tested with:
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y

and tcrypt,
sudo modprobe tcrypt mode=500 sec=1

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

Chnage log:
v2:
 - Corrected dt-bindings syntax errors and other review comments in v1.
 - Completely changed driver code structure, splitting code into
   multiple files

Link to previous versions:
v1: https://lore.kernel.org/all/20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com/
---
T Pratham (2):
  dt-bindings: crypto: Add binding for TI DTHE V2 driver
  crypto: ti: Add driver for DTHE V2 AES Engine (ECB, CBC)

 .../devicetree/bindings/crypto/ti,dthev2.yaml |  50 +++
 MAINTAINERS                                   |   7 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/ti/Kconfig                     |  10 +
 drivers/crypto/ti/Makefile                    |   3 +
 drivers/crypto/ti/dthev2-aes.c                | 416 ++++++++++++++++++
 drivers/crypto/ti/dthev2-common.c             | 206 +++++++++
 drivers/crypto/ti/dthev2-common.h             | 110 +++++
 8 files changed, 803 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
 create mode 100644 drivers/crypto/ti/Kconfig
 create mode 100644 drivers/crypto/ti/Makefile
 create mode 100644 drivers/crypto/ti/dthev2-aes.c
 create mode 100644 drivers/crypto/ti/dthev2-common.c
 create mode 100644 drivers/crypto/ti/dthev2-common.h

-- 
2.34.1

