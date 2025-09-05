Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A3D352075;
	Fri,  5 Sep 2025 13:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757079570; cv=none; b=UDDrPwWK3cTfTkWLcaaTXNSwWYxt+EUvx31Q5F3rkkH+nOhW19q0asV/A+BdOu8gAOob+F1j+Phf1jhUlGvNfhLO7c7GZlwCqsYgkJae4ViA0ZPKSaJsdLGAi6dd9zi9qZ2tOPY9XmJiqvHbFpqVPYn2Ul4a4LBHDZ8AMhj8WpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757079570; c=relaxed/simple;
	bh=P9kFPN2iwi47xgh4I7W8LWEmREmVWePTFNwbhoNzIFk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AVTQ6esKjk18ggcUsV3qVAMMrs+IbVoEwG3Qv0gu9O3cE1ZH+zcyHsW+VQqW6l/8prLDQ0eK3EgNNYGO7FxJdYofUgBYbhyWWwZheGCyS/solIIJ59FD87ii/KSoKN+s3qTMqizXbyxKE673i0Rvk0SVT8YLaRCmuJQaI2JH9R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=hSKdHSEJ; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="hSKdHSEJ"
Received: from fllvem-sh04.itg.ti.com ([10.64.41.54])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTP id 585DdMZn3764191;
	Fri, 5 Sep 2025 08:39:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1757079562;
	bh=BUmWyg8y4ECYkEoM3zkajWe4cYnxpWMMjEBrbi/sYF0=;
	h=From:To:CC:Subject:Date;
	b=hSKdHSEJHtp5W4iFBdrq5jmQ7Pxc9QWKwCeH1hb4nu+ZgRwvFCRYk7BF3+HTx6lHV
	 1/B+QaXUK/ZLo1rfpvHoFAhk2nN6tSIX5fJmn+MVagoDh4l8JllM5C6RAN06FFDd16
	 Y1Tvse0cR/CYsPFQQ9ucrUn/JQfp0SGXbkElfiKk=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
	by fllvem-sh04.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 585DdMNB1674537
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Fri, 5 Sep 2025 08:39:22 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Fri, 5
 Sep 2025 08:39:21 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Fri, 5 Sep 2025 08:39:22 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 585DdKqr807600;
	Fri, 5 Sep 2025 08:39:21 -0500
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
Subject: [PATCH 0/4] Add support for more AES modes in TI DTHEv2
Date: Fri, 5 Sep 2025 18:57:15 +0530
Message-ID: <20250905133504.2348972-4-t-pratham@ti.com>
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
---

T Pratham (4):
  crypto: ti: Add support for AES-XTS in DTHEv2 driver
  crypto: ti: Add support for AES-CTR in DTHEv2 driver
  crypto: ti: Add support for AES-GCM in DTHEv2 driver
  crypto: ti: Add support for AES-CCM in DTHEv2 driver

 drivers/crypto/ti/Kconfig         |   5 +
 drivers/crypto/ti/dthev2-aes.c    | 792 +++++++++++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.c |  19 +
 drivers/crypto/ti/dthev2-common.h |  30 +-
 4 files changed, 838 insertions(+), 8 deletions(-)

-- 
2.43.0

