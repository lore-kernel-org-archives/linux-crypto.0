Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0A91DA23;
	Tue,  3 Jun 2025 12:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748954587; cv=none; b=U4bNcCBzr9qgkasdGif6wkuSsCsufeTUnMocMqrEKDXg1c1LyTMBXcFst40Z58Ytj1jlNsxceJC254bWyt43dfVn/uDAY9Bpp0Z4Ve948+tyeVBrGf3z2xL7aa3SVrlHPbaalFCu8q8+Rwk+xHTvdhPdQPrpAJ02gpq1NoucLaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748954587; c=relaxed/simple;
	bh=Q3MPjYNM0ds7NcGkHkAOnn+zmBsfx+iyn3GRMyTp26Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RNmMgqFjp6BiGfkmbc0iPHiAptprLUdc23I2VSiBQYM/15EsY8SxsdqM0EX8geB9Rwz547pVBV2q22yLdXIr2xnLgWMVYgRa9RaNWIM1NYpPq7V85he9zMtrcL0r0a3F4mrGBzIoa348wOv/v6iLgKdEJpg14JO9UeKQ7R5O2iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=q5hx/hJp; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="q5hx/hJp"
Received: from fllvem-sh03.itg.ti.com ([10.64.41.86])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTP id 553CgqLq3511909;
	Tue, 3 Jun 2025 07:42:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1748954572;
	bh=L0py/9TGR2NMmoGZKjvaiqkIuL2ReQF6Z8MVpdYpYj8=;
	h=From:To:CC:Subject:Date;
	b=q5hx/hJpKX2abHZHAaz4G3HBxEJGkwz709aVmeAGr3axonv+sjf+MPm4/LhfZe5/5
	 7gyRIROhj7YX+w4QGOzd7JvTkMBIA08EekcfxgsldKYJYTdhfrsGf8sOrZsduM4VUP
	 vfIT6ryI29nxEgXKgku56JIo1ofJ64P/lAgfNcuQ=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
	by fllvem-sh03.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 553Cgqhs3528140
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Tue, 3 Jun 2025 07:42:52 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 3
 Jun 2025 07:42:51 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 3 Jun 2025 07:42:51 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 553CgodK351685;
	Tue, 3 Jun 2025 07:42:51 -0500
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
        Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth
 Bajjuri <praneeth@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH v5 0/2] Add support for Texas Instruments DTHE V2 crypto accelerator
Date: Tue, 3 Jun 2025 18:07:27 +0530
Message-ID: <20250603124217.957116-1-t-pratham@ti.com>
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

This series adds support for TI DTHE V2 crypto accelerator. DTHE V2 is a
new crypto accelerator which contains multiple crypto IPs [1].
This series implements support for ECB and CBC modes of AES for the AES
Engine of the DTHE, using skcipher APIs of the kernel.

Tested with:
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y

and tcrypt,
sudo modprobe tcrypt mode=500 sec=1

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

Change log:
v5:
 - Simplified tfm ctx struct
 - Set cra_reqsize instead of using crypto_skcipher_set_reqsize()
 - Move setting sysconfig and irqenable registers to dthe_aes_run
v4:
 - Corrected dt-bindings example indentation
 - Simplified dt-bindings example, removing the node surrounding crypto
 - Fixed typo in dthev2-common.h header guard
 - Removed unused ctx field in dev_data struct
 - Moved per-op data into request context
v3:
 - Corrected dt-bindings reg length is too long error
 - Converted AES driver code to use crypto_engine APIs for using
   internal crypto queue instead of mutex.
 - Removed calls to skcipher_request_complete in paths not returning
   -EINPROGRESS before.
 - Added missing KConfig import, which was accidentally removed in v2.

v2:
 - Corrected dt-bindings syntax errors and other review comments in v1.
 - Completely changed driver code structure, splitting code into
   multiple files

Link to previous versions:
v4: https://lore.kernel.org/all/20250508101723.846210-2-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20250502121253.456974-2-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20250411091321.2925308-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com/
---

T Pratham (2):
  dt-bindings: crypto: Add binding for TI DTHE V2
  crypto: ti: Add driver for DTHE V2 AES Engine (ECB, CBC)

 .../bindings/crypto/ti,am62l-dthev2.yaml      |  50 +++
 MAINTAINERS                                   |   7 +
 drivers/crypto/Kconfig                        |   1 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/ti/Kconfig                     |  13 +
 drivers/crypto/ti/Makefile                    |   3 +
 drivers/crypto/ti/dthev2-aes.c                | 420 ++++++++++++++++++
 drivers/crypto/ti/dthev2-common.c             | 220 +++++++++
 drivers/crypto/ti/dthev2-common.h             | 101 +++++
 9 files changed, 816 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
 create mode 100644 drivers/crypto/ti/Kconfig
 create mode 100644 drivers/crypto/ti/Makefile
 create mode 100644 drivers/crypto/ti/dthev2-aes.c
 create mode 100644 drivers/crypto/ti/dthev2-common.c
 create mode 100644 drivers/crypto/ti/dthev2-common.h

-- 
2.43.0

