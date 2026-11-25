Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592794;
	b=2LFbQb6EphRX+33pTjfoVfq0SVNMOA/G28lgYqRY5ZjACSyPN2k5BQ1TF4Xh/4LCrIB1
	 1Mto+kboNTHauXrcM7lJN/jCr1n2XFOju29NerAHuZOLzDlbdPPJRkoMhRU1NwTN3n+O0
	 eukrdWeSFroQrJvPBCCTjU7Dv5ro5bTz/Z7/FrneFDvg2+qS4sEqSz2Nx0RR/u4G4+J+2
	 cnxPPXUzrBAg1k8wUx4UUL0dtGWlavqLx9hI2wsOC0goD+TZLthgxdjZWt/A8rIY8zfD6
	 PCkz0rWI4avZhkRB+wP26V7019Ja7mbdFX8DijcbjrANr9BGqg4s/Ncv4vHj6ICuyOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592794;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=Imqkd7xKLsDI20X2OMVhw8aQGSuklVlLwofVUI+4PLc=;
	b=E6J9bNBvaG4xCo+8qBXHfpBfaCqIULXqbWgitGT2zIUymxjPPTS54X4wS/OwSeiXWsYq
	 FckmxXik0mCUdMip1WAvVzoAH9vgjDmGDNpwdpdLs0VOl84ea6Kpv7oDHqUVclbKLV0HU
	 lsguXDzASK1PvQMNvS3RqeBd4ibdqpwi6869dgzlUrL1jk4yVppYGEax6liJzrNK41QaY
	 EEVXQwkwirMy7epN+FVNhV0csy5aYlFNnQ7oCJvj0FvyHjXkEpQSTgnj2EzU8Z7cvcTBc
	 KGncj06A2YnGkahnvdHJfh/RuY/036zOkE66JZPdIAdRwC0CVJ+6KY7RLTYNOhkuvsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B13F606A326;
	Wed, 25 Nov 2026 07:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B13F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZV6DrPzg1cV;
	Wed, 25 Nov 2026 15:46:26 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZT0wNJzg1cV;
	Wed, 25 Nov 2026 15:46:25 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 84B10300B6F1;
	Wed, 25 Nov 2026 15:45:12 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:24 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>
Subject: [PATCH 00/11] crypto: ccp - add Hygon SM3/SM4 support
Date: Wed, 25 Nov 2026 15:45:58 +0800
Message-ID: <cover.1795588986.git.yangdepei@hygon.cn>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

This series adds SM3 and SM4 offload for Hygon CCP devices, which use
the v5 programming model, and fixes two pre-existing problems in the
queue handling that were found while validating it.

Patches 1-2 are generic fixes that apply to the AMD devices as well:

  1: correct the LSB region mask, which tested the wrong region
  2: acknowledge the queue interrupt before publishing the completion

Patches 3-11 prepare and enable the Hygon support on top of a per-device
capability set instead of unconditional registration:

  3-4: add struct ccp_caps and gate algorithm registration on the
       engines the device implements.  AMD v5 devices keep their
       current set of algorithms; the v3 CCP does not implement DES3
       and no longer advertises it.
  5:   split descriptor submission from running the queue, so that the
       SM engines can submit a whole batch and run the queue once.
  6-7: add the SM3/SM4 command ABI, the Hygon PCI IDs and vdata.
  8:   ignore the empty-queue interrupt status bit, which the Hygon
       CCP reports and the v5 handler must not treat as a completion.
       AMD hardware has not been observed to report it; for the status
       values AMD produces the check makes no difference.
  9:   read the implemented engines from the Hygon version register.
  10-11: add the SM4 skcipher and SM3 ahash front ends, registering
       ecb/cbc/ctr(sm4), sm3 and hmac(sm3).

Every patch was built separately with W=1 and passes checkpatch.  The
driver has been tested on Hygon CCP hardware: the crypto API self-tests
pass, and an out-of-tree test module passes all 17 of its cases.  The
cases cover known-answer vectors, cross-checks against the generic
software implementations, streaming and export state, multi-segment
scatterlists, repeated requests and concurrent requests.

AI assistance: the code and changelogs were produced with AI coding
assistants under human review.  The assistance is recorded here, as the
patches do not carry per-patch Assisted-by tags:

  Assisted-by: Claude:deepseek-v4-flash-1017

The test module is not part of this series.

Depei Yang (11):
  crypto: ccp - fix LSB region mask calculation
  crypto: ccp - acknowledge queue interrupt before waking waiter
  crypto: ccp - add engine capability and version information
  crypto: ccp - register algorithms only for supported engines
  crypto: ccp - split v5 command submission from queue run
  crypto: ccp - add SM3/SM4 command definitions
  crypto: ccp - add Hygon CCP device IDs and vdata
  crypto: ccp - handle only supported interrupts in v5 irq bh
  crypto: ccp - detect the Hygon CCP engines from the version register
  crypto: ccp - add SM4 engine and skcipher algorithms
  crypto: ccp - add SM3 engine and ahash algorithms

 drivers/crypto/ccp/Kconfig           |   1 +
 drivers/crypto/ccp/Makefile          |   4 +-
 drivers/crypto/ccp/ccp-crypto-main.c |  36 +-
 drivers/crypto/ccp/ccp-crypto-sm3.c  | 468 +++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-crypto-sm4.c  | 254 ++++++++++++++
 drivers/crypto/ccp/ccp-crypto.h      |  67 ++++
 drivers/crypto/ccp/ccp-dev-v3.c      |  21 +-
 drivers/crypto/ccp/ccp-dev-v5.c      | 260 +++++++++++++-
 drivers/crypto/ccp/ccp-dev.c         |  37 ++
 drivers/crypto/ccp/ccp-dev.h         |  31 ++
 drivers/crypto/ccp/ccp-ops.c         | 487 +++++++++++++++++++++++++++
 drivers/crypto/ccp/sp-dev.h          |  12 +
 drivers/crypto/ccp/sp-pci.c          |  35 ++
 include/linux/ccp.h                  | 187 ++++++++++
 14 files changed, 1878 insertions(+), 22 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-sm3.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-sm4.c


base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
-- 
2.34.1


