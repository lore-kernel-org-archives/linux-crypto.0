Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7132D19539F;
	Sun, 26 Oct 2025 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491413; cv=none; b=p/ZvEKzvceWyoYhpIfw/Na8ANx91alQjmzglNXFk33Rw7zyH6VH+qqc8q9qgN5RrhH89iJ8hu/+mrg01jdMpYUjQ4RTbKOKZRaiRPKi7ev//eCvX31bAxzvAyWN8mlVDOiOWn9KBR/alt/e9OrPPJ5p6xTHk756YAMnWwLxt5zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491413; c=relaxed/simple;
	bh=KH1ox9mHfRvUW3ky2/6vb4uyW86DfQGq2VDJQBj/j5s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p1iNnq9oLV3jNLxhtZWLYkBJ5F3TJr4eoF9deoZXQjxnLtwKgGJS97WvremmLpRTzgo88wg7aInS9nr+eOfnRcFSRU0gudMCrAys0Kp820j6xPBsAj2xT8Jh5Z6DvpWir0rGE9yY96HD/v5lODpFLd5ZVf0m14ypi9F6kb9t4bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=IxVWALNu; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IxVWALNu"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59QDWx8Z3735070;
	Sun, 26 Oct 2025 08:09:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=Ne2GRUkpOKNzTyqpYWnsKU2
	nvGFP1B9RF9QeWQenQPY=; b=IxVWALNus2JvhhAPIeLft6wPg3W3njWas2Gu1Af
	0xAjd42s/7Zg1QLmWJzg8XekMqP6XlbjGKuOPWtuO0wrD3gIpiyX7H193giMqbPr
	Z70RzZRaZFVqEI0kYyQuyRF9FxsySg9ZgPGKW9VQDSBgeHedkfDCXPI50CN+z6aJ
	XLm/PJs93RHj511zMdSe+0YV+7Jzb77xMAh5jpKKs2zwUesmiVzmTuHo2VSGfuwB
	uYhIouDer7ejU76xx1c9e9EtxB+uSoo8pHQe5/i1z5gjSMgQyQrZRt+/Oop4hzpV
	0kbD3vNWD8Vc5sjDwybHzxS1vUaGUgisvQMaqjx6FV3++6A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4a1fa5rfw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Oct 2025 08:09:57 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 26 Oct 2025 08:10:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 26 Oct 2025 08:10:07 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 4B5763F70B4;
	Sun, 26 Oct 2025 08:09:54 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <horms@kernel.org>, <leon@kernel.org>,
        <herbert@gondor.apana.org.au>, <bbhushan2@marvell.com>,
        <sgoutham@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v5 00/15] Enable Inbound IPsec offload on Marvell CN10K SoC
Date: Sun, 26 Oct 2025 20:38:55 +0530
Message-ID: <20251026150916.352061-1-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI2MDE0NSBTYWx0ZWRfX60Ch/FymfVTC
 Q3x5h65R1nCaaEoc6NNAaq2D/sYUiubv8AT+EFUpFjzFK0D9n5eqdqCtjZZqtht9P8JTEF9cLkq
 3tvPFPfbMOrW2TQaXGk/XJRykdnQeQt4IjI4EtHGJ84GZN4XAizD1Yvgn+Ja+YLW+ko/x3kd2c1
 p+qEK99oMVKC//GjoEXgV8e9se0ZR+zNrF56sHDRGazgabYHtNtol08DfvUc+vFnh2slfz2FHpq
 STWI8B5k5uRVCvJzP0+5c+/Kj8mXFZXH+CC8OtBz+R7DTM6iEE4N9kX2atVDffj2cdh2SbepV1g
 83GA00iwHs6mdRs7BgvVTz4UKghfOaHHu+Xzp0g1zK47UQO72cORXPxhfyLf5S1HMfAYJWzG1u4
 xX0YjmnEYH1RRq3+shWQKHmo8NEXbQ==
X-Authority-Analysis: v=2.4 cv=VOnQXtPX c=1 sm=1 tr=0 ts=68fe39c5 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=wSMj3bjwG01oINX3TXIA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: zwagvTggpXj7g5UUM4hizTws1BtEiQxn
X-Proofpoint-ORIG-GUID: zwagvTggpXj7g5UUM4hizTws1BtEiQxn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_06,2025-10-22_01,2025-03-28_01

This patch series adds support for IPsec packet offload for the
Marvell CN10K SoC.

The packet flow
---------------
An encrypted IPSec packet goes through two passes in the RVU hardware
before reaching the CPU.
First Pass:
  The first pass involves identifying the packet as IPSec, assigning an RQ,
  allocating a buffer from the Aura pool and then send it to CPT for decryption.

Second Pass:
  After CPT decrypts the packet, it sends a metapacket to NIXRX via the X2P
  bus. The metapacket contains CPT_PARSE_HDR_S structure and some initial
  bytes of the decrypted packet which would help NIXRX in classification.
  CPT also sets BIT(11) of channel number to further help in identification.
  NIXRX allocates a new buffer for this packet and submits it to the CPU.

Once the decrypted metapacket packet is delivered to the CPU, get the WQE
pointer from CPT_PARSE_HDR_S in the packet buffer. This WQE points to the
complete decrypted packet. We create an skb using this, set the relevant
XFRM packet mode flags to indicate successful decryption, and submit it
to the network stack.

Bharat Bhushan (4):
  crypto: octeontx2: Share engine group info with AF driver
  octeontx2-af: Configure crypto hardware for inline ipsec
  octeontx2-af: Setup Large Memory Transaction for crypto
  octeontx2-af: Handle inbound inline ipsec config in AF

Geetha sowjanya (1):
  octeontx2-af: Add mbox to alloc/free BPIDs

Kiran Kumar K (1):
  octeontx2-af: Add support for SPI to SA index translation

Rakesh Kudurumalla (1):
  octeontx2-af: Add support for CPT second pass

Tanmay Jagdale (8):
  octeontx2-pf: ipsec: Setup NIX HW resources for inbound flows
  octeontx2-pf: ipsec: Allocate Ingress SA table
  octeontx2-pf: ipsec: Handle NPA threshold interrupt
  octeontx2-pf: ipsec: Initialize ingress IPsec
  octeontx2-pf: ipsec: Configure backpressure
  octeontx2-pf: ipsec: Process CPT metapackets
  octeontx2-pf: ipsec: Manage NPC rules and SPI-to-SA table entries
  octeontx2-pf: ipsec: Add XFRM state and policy hooks for inbound flows

 .../marvell/octeontx2/otx2_cpt_common.h       |    8 -
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   10 -
 .../marvell/octeontx2/otx2_cptpf_main.c       |   50 +-
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  282 +---
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  116 +-
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |    3 +-
 .../ethernet/marvell/octeontx2/af/Makefile    |    2 +-
 .../ethernet/marvell/octeontx2/af/common.h    |    1 +
 .../net/ethernet/marvell/octeontx2/af/mbox.c  |    3 -
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  119 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |    8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   71 +
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |   11 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  708 ++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |   71 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  235 ++-
 .../marvell/octeontx2/af/rvu_nix_spi.c        |  211 +++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   40 +
 .../marvell/octeontx2/af/rvu_struct.h         |    4 +-
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 1357 ++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |  140 ++
 .../marvell/octeontx2/nic/otx2_common.c       |   26 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   16 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   21 +
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   18 +
 .../marvell/octeontx2/nic/otx2_struct.h       |   16 +
 .../marvell/octeontx2/nic/otx2_txrx.c         |   31 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |    4 +
 28 files changed, 3105 insertions(+), 477 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c

-- 
2.43.0

