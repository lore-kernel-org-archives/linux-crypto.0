Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D93A927;
	Thu,  8 May 2025 10:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746699627; cv=none; b=oVyGVzN+8tBJstPnxuJDeCFdGGPius8Y4+pK0xcfcpaELsxmRKqKrAHA4TI1kZhJqqFYebQa6Mr31h3NhVyXu4lo49RVYGQ28UT2Nx4iJfo7wrgCahJ0haKHNQx1KoaLjVLMElH+miJ+8Ck/yII3Pef7cJru1Z47997A+kNjIAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746699627; c=relaxed/simple;
	bh=gIgafhy5zWc3M8O8oMA9ZYhwYnZoLDMjRm43UpOFRuY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PkUj+/O4ztwVY/pfcSwO4PjGB/SwKw1OycbTorEwH0jhcficOW5gHqYrtHmR5fWCOt6AFgWTTF0al2wWGPWvwGfObWoNm4zqz57I3F+dhMnGX5PSqv1ZJxnWMrrBZxtMJNlPC65o4f8E58ayqsUwqXw0xoSY9DpO5/VIZ9Vldzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=SiHnXDhR; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="SiHnXDhR"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 548AKF6K1067278
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 May 2025 05:20:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1746699615;
	bh=77i1XLR+zAF1WeatUhe0e2qwafkiomWLSZPAwCtDIto=;
	h=From:To:CC:Subject:Date;
	b=SiHnXDhRSVN1dzvV8tg8FcRFE2WZuGsYdQBWOnHTB35Vm8/55GdtfhVrDDEC6GK/x
	 Bh42Gk9qF0iV0WKEgjjM+eRGFm6L0CqSu27QRu+P26hvTjvSKmrmvKHvl6hbXBlaM8
	 QUiReaA71hfo57l6Ycpy/6ylADv8gJ206HC9i1Xw=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 548AKF4g032093
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 8 May 2025 05:20:15 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 8
 May 2025 05:20:14 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 8 May 2025 05:20:14 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 548AKDAr008495;
	Thu, 8 May 2025 05:20:14 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller"
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
Subject: [PATCH v4 0/2] Add support for Texas Instruments DTHE V2 crypto accelerator
Date: Thu, 8 May 2025 15:37:39 +0530
Message-ID: <20250508101723.846210-2-t-pratham@ti.com>
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
v3: https://lore.kernel.org/all/20250502121253.456974-2-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20250411091321.2925308-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com/
---
T Pratham (2):
  dt-bindings: crypto: Add binding for TI DTHE V2
  crypto: ti: Add driver for DTHE V2 AES Engine (ECB, CBC)

 .../bindings/crypto/ti,am62l-dthev2.yaml      |  50 ++
 MAINTAINERS                                   |   7 +
 drivers/crypto/Kconfig                        |   1 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/ti/Kconfig                     |  13 +
 drivers/crypto/ti/Makefile                    |   3 +
 drivers/crypto/ti/dthev2-aes.c                | 428 ++++++++++++++++++
 drivers/crypto/ti/dthev2-common.c             | 220 +++++++++
 drivers/crypto/ti/dthev2-common.h             | 111 +++++
 9 files changed, 834 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
 create mode 100644 drivers/crypto/ti/Kconfig
 create mode 100644 drivers/crypto/ti/Makefile
 create mode 100644 drivers/crypto/ti/dthev2-aes.c
 create mode 100644 drivers/crypto/ti/dthev2-common.c
 create mode 100644 drivers/crypto/ti/dthev2-common.h

-- 
2.43.0

