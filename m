Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AD9234969;
	Tue, 18 Feb 2025 10:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739875832; cv=none; b=pbTLAmF0txn+nommnpAmENl81NQVgi/6cwCfoWN/JhwXgIksEjCJWl3Tf4xIVmwZceTl6ID66sc1eAeJC09S7tGbd5RZpVnuJ63LwfkMUv7x914JcmxEsw2+A+cOoPPX58wyd+AhwpU0xz5R++I698e3/JcE+bzoCsLvo9gno6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739875832; c=relaxed/simple;
	bh=lonkTfpE1uQpQfUotzgaBcpisRPmw8aacZS0KCdpj0A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h1u3kZlzUdnwx6o2tmi3/1nB1V4UWh3lgeRNwVqovTOCC+0qlcHWNByPQy9+Bg3iVflWhuKnDCrtddnkkVukDCh8MI4oEVvkr8swbjyLXvylSg0mRGccx9Xs/IX64D8/xSryhNivr3ukPpH9YQnrP1lHbCCNVhfu0ddvE/3D2dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=nLuhSvoa; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="nLuhSvoa"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 51IAoOJb695914
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 04:50:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1739875824;
	bh=LgtPkOuGwto4QmwQu9EsTlAOQD0tMlHHoIxO+LBkwwA=;
	h=From:To:CC:Subject:Date;
	b=nLuhSvoawCSpM7my3AxNUAbNB0swHgaD2YN5jG9JSosYyPBj9dQCB3eMtgD8kdN3+
	 5LTtZcPTNgac4ZJ8mKTRxzlSvmyz6mAcYJq0yLwVS2jXLGTtfMtCbiu5MOLFRx+AW4
	 j/qRvSJD1S4LTm+TcAyi+fVv2y+FN/Ba3H0TLA+I=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 51IAoO0B031586
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 18 Feb 2025 04:50:24 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 18
 Feb 2025 04:50:24 -0600
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 18 Feb 2025 04:50:24 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 51IAoNTk094644;
	Tue, 18 Feb 2025 04:50:24 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH RFC 0/2] Add support for hashing algorithms in TI DTHE V2
Date: Tue, 18 Feb 2025 16:19:41 +0530
Message-ID: <20250218104943.2304730-1-t-pratham@ti.com>
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

This adds supoprt for the hashing algorithms SHA224/256/384/512 and MD5
for the hashing engine of Texas Instruments DTHE V2 crypto accelerator
driver.

This patch series depends on the following previous series:
[1] [PATCH RFC 0/3] Add support for Texas Instruments DTHE V2 crypto accelerator
https://lore.kernel.org/all/20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com/

As with the previous series [1], the hardware spec is still to be
updated in the public TRM. It will be shared in a later series when it
is made available.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
T Pratham (2):
  crypto: ti: Add support for SHA224/256/384/512 in DTHE V2 driver
  crypto: ti: Add support for MD5 in DTHE V2 Hashing Engine driver

 drivers/crypto/ti/Kconfig  |   3 +
 drivers/crypto/ti/dthev2.c | 920 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 912 insertions(+), 11 deletions(-)

-- 
2.34.1

