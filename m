Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8898F252904;
	Fri,  2 May 2025 12:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746188124; cv=none; b=IyaWl4TuTbXASaxHUfgORKqfYv/6V3Q8MZa+9fZFvQAyS2w4byDEwddMXr3/NlumHFvfAm92lmH2Qm6a4jwIRBL3xKCzKNC4/PrTMqNuj/DOoT7oKEXnYppS6WSCCHtMl7zhRWV4eRieBYNY6Oz9L4qzmy0nfRC2L9JusWAkbew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746188124; c=relaxed/simple;
	bh=Gj8dQ2NYqz3Puzjnn2bvbGd2N3TgXYnAoNlFXwh0yo0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dibP1poseVjsFg2cAn4P1gpFhu57kRhXAFXw4/V/jZOXEYPLVx7hCpPdCPmMNI7+D2IX5HPPBFZ94XodKkMGPYV/fdRWgZbvXt4VciG7Gb+uuwOkbyMGlLAl6R7Nso/yWoMFSI7mVQlRpRBtwmSkdFtZYxzMzX1FJxdUObk8iao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=RUqc7JhW; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="RUqc7JhW"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 542CFDTj3856698
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 May 2025 07:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1746188113;
	bh=gF0fe93dDvvRc55ckQaLkdaPCwBtmDcqC3mqXfkN3qE=;
	h=From:To:CC:Subject:Date;
	b=RUqc7JhWiShQ8V9tEgqWV+bARrhamuqafbdo4WTgTRTqViigrCbb2rvNUJT+1d+f0
	 CX+YGquQWiNO4kS0IL1kiWAeo66Bo6BvgW2orcqWI9A4aENI65OGRcL2T+0wHiyMG9
	 3FT5ymO8e7o9w7kKvq6kSrSZ4ykNgbrOGJBJNm7U=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 542CFDm1002527
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 2 May 2025 07:15:13 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 2
 May 2025 07:15:13 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 2 May 2025 07:15:13 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 542CFCBc086839;
	Fri, 2 May 2025 07:15:12 -0500
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
Subject: [PATCH v3 0/2] Add support for Texas Instruments DTHE V2 crypto accelerator
Date: Fri, 2 May 2025 17:21:15 +0530
Message-ID: <20250502121253.456974-2-t-pratham@ti.com>
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
v2: https://lore.kernel.org/all/20250411091321.2925308-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com/
---
T Pratham (2):
  dt-bindings: crypto: Add binding for TI DTHE V2 driver
  crypto: ti: Add driver for DTHE V2 AES Engine (ECB, CBC)

 .../devicetree/bindings/crypto/ti,dthev2.yaml |  55 +++
 MAINTAINERS                                   |   7 +
 drivers/crypto/Kconfig                        |   1 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/ti/Kconfig                     |  13 +
 drivers/crypto/ti/Makefile                    |   3 +
 drivers/crypto/ti/dthev2-aes.c                | 414 ++++++++++++++++++
 drivers/crypto/ti/dthev2-common.c             | 220 ++++++++++
 drivers/crypto/ti/dthev2-common.h             | 110 +++++
 9 files changed, 824 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
 create mode 100644 drivers/crypto/ti/Kconfig
 create mode 100644 drivers/crypto/ti/Makefile
 create mode 100644 drivers/crypto/ti/dthev2-aes.c
 create mode 100644 drivers/crypto/ti/dthev2-common.c
 create mode 100644 drivers/crypto/ti/dthev2-common.h

-- 
2.43.0

