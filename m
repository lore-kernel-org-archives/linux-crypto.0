Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D6B225A34;
	Wed, 22 Oct 2025 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156199; cv=none; b=Q5F48qEYcccQBge6k+tqLcTfDrfRw0T2zColXWiN2XpOB0vb1Z5/CgK69oai5pKLHRQW7ya5MKm23dQ4pfcdAQXfAEzlyHY+OrJrs7nMDO7e8HMBKIQMCsOjSO1BsxcomxqmmYXfyX9F7L65H16Oi2+sVj55OnCMV9s6kIVIZs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156199; c=relaxed/simple;
	bh=LQrljQXVBNGPi3uExzVpccn2cMvSWQGjPo3cr1uKi8g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O3NPkMt8a19YjS67LtUSh73GXmg4gJaqabsonqMjnN0sviHi2qH8rvKRLldj07VbHk+GPe2UsKiV0l6OHeSF9CvseEHIqe4QRRAIpZVX9YjlWCjqZbiIrOUuoYXVVMqhwybc6eUktkRTYLWWwIUGU1ZESnFdS26TrwE1VJQ4JSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=nTAj+0ZR; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="nTAj+0ZR"
Received: from fllvem-sh03.itg.ti.com ([10.64.41.86])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 59MI3CTA1477181;
	Wed, 22 Oct 2025 13:03:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1761156192;
	bh=STmKfude06QOtFedlY+kdkDf2QvLl8jRJXljC3uzCao=;
	h=From:To:CC:Subject:Date;
	b=nTAj+0ZR7qrqXTmxci/7H/CpO+gQzHv1rOXkSe0i9/t/PvCAYd+jPLBtpFu2+7MAf
	 ufGY0hcj9qvY3EnDgdv5AOrUjqLYjxS5UxN6PhvljMaQxdSEy2et9N2iDMczmOQI41
	 ZHzu6mEhWYn1QgLpNxb1WCvYO3tQEKjdE7avnbPI=
Received: from DFLE213.ent.ti.com (dfle213.ent.ti.com [10.64.6.71])
	by fllvem-sh03.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 59MI3CYS2203641
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 22 Oct 2025 13:03:12 -0500
Received: from DFLE200.ent.ti.com (10.64.6.58) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 22 Oct
 2025 13:03:11 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 22 Oct 2025 13:03:11 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 59MI3Amb1613833;
	Wed, 22 Oct 2025 13:03:11 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Shiva Tripathi <s-tripathi1@ti.com>,
        Kavitha
 Malarvizhi <k-malarvizhi@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth
 Bajjuri <praneeth@ti.com>
Subject: [PATCH v5 0/4] Add support for more AES modes in TI DTHEv2
Date: Wed, 22 Oct 2025 23:15:38 +0530
Message-ID: <20251022180302.729728-1-t-pratham@ti.com>
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

PS: The patches 3/4 and 4/4 in this series (AES-GCM and AES-CCM) depend
on the following patch:
https://lore.kernel.org/linux-crypto/20251022171902.724369-2-t-pratham@ti.com/

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: DTHEv2 AES Engine kernel self-tests logs
Link: https://gist.github.com/Pratham-T/aaa499cf50d20310cb27266a645bfd60

Change log:
v5:
 - Simplified AES-XTS fallback allocation, directly using xts(aes) for
   alg_name
 - Changed fallback to sync and allocated on stack
v4:
 - Return -EINVAL in AES-XTS when cryptlen = 0
 - Added software fallback for AES-XTS when ciphertext stealing is
   required (cryptlen is not multiple of AES_BLOCK_SIZE)
 - Changed DTHE_MAX_KEYSIZE definition to use AES_MAX_KEY_SIZE instead
   of AES_KEYSIZE_256
 - In AES-CTR, also pad dst scatterlist when padding src scatterlist
 - Changed polling for TAG ready to use readl_relaxed_poll_timeout()
 - Used crypto API functions to access struct members instead of
   directly accessing them (crypto_aead_tfm and aead_request_flags)
 - Allocated padding buffers in AEAD algos on the stack.
 - Changed helper functions dthe_aead_prep_* to return ERR_PTR on error
 - Changed some error labels in dthe_aead_run to improve clarity
 - Moved iv_in[] declaration from middle of the function to the top
 - Corrected setting CCM M value in the hardware register
 - Added checks for CCM L value input in the algorithm from IV.
 - Added more fallback cases for CCM where hardware has limitations
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

v4: https://lore.kernel.org/all/20251009111727.911738-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20250910100742.3747614-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20250908140928.2801062-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250905133504.2348972-4-t-pratham@ti.com/
---

T Pratham (4):
  crypto: ti - Add support for AES-XTS in DTHEv2 driver
  crypto: ti - Add support for AES-CTR in DTHEv2 driver
  crypto: ti - Add support for AES-GCM in DTHEv2 driver
  crypto: ti - Add support for AES-CCM in DTHEv2 driver

 drivers/crypto/ti/Kconfig         |   5 +
 drivers/crypto/ti/dthev2-aes.c    | 918 +++++++++++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.c |  19 +
 drivers/crypto/ti/dthev2-common.h |  33 +-
 4 files changed, 958 insertions(+), 17 deletions(-)

-- 
2.43.0

