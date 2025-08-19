Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6930D287519;
	Tue, 19 Aug 2025 02:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755570663; cv=none; b=k1Yqjbt83c11K/5Td0+wQ8EC3vLevGlH5bVlY2E5B75Sb2j1LcMqpG6D583D/edTlp6/q+IvwvbyRv4XLKLqe4Rjw7pPiwVB9hJL8KOMmoxzjlcBVrm8h3dKBuidSUnOICVKSGhznIZxj+nqQa6kuiDHtke5p+1n8GTiNQuw/fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755570663; c=relaxed/simple;
	bh=cnJ0ywBARICzJ9Lft0hAuWFhnk5YlqCCmzKE/ASnBcE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jLd1fLyekD8QJSyO8fCZsXYTKbcm05cugbBUwNZh6JEGfxEL1CEb06WMw7jk9jL+DFSXm3PL0PaOEbnrPiVWBi/vWPTnRRnANKZgJFnTJT9SHkaJgWsv3nGCnUlkD6w2NbyGBStUSJvvbi9gFbbnuCHzlLyzwin8XjHuYPtKY20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=CADVwbiC; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CADVwbiC"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IMlaZj000347;
	Mon, 18 Aug 2025 19:15:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=phNq7khW8PFXPVCUnlbCBks
	UuJk/61w/L9up8WjJ2YA=; b=CADVwbiCE0xoTnjEodu7kFfbVpw7w4R2ZAypcNx
	hUnsBuPmPJJR5vfMW1VbxH+UVu1cDy8ICUen5z1Sy1dp8MsYJYSqlMeUBnQyqH6h
	WM67IBZbaf3o+f22g5WvzKIbrCS4+zkN04NGMjvjO+UpH9zleOudqNNDGvPStwc6
	2wlkIKIi57F/yPziwVqi4E3Ra3xFEVpk+nI53hlsPpTjn+RiVIwcjCsY5nqu2mLa
	4EZ+xC7Z8fLpRkpAJYD6bwtNYDghD/2E552sTIL7cRqdTUMR8RyFSSeahHdzgEZr
	TCpe7fWdv0QzWmfCtli45fZE1Ys3wOcUTx3fV8/aQ/OBpsA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 48md9ggccw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 19:15:16 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 18 Aug 2025 19:15:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 18 Aug 2025 19:15:20 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 0A7033F7078;
	Mon, 18 Aug 2025 19:15:12 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v4 00/14] Enable Inbound IPsec offload on Marvell CN10K SoC
Date: Tue, 19 Aug 2025 07:44:51 +0530
Message-ID: <20250819021507.323752-1-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=PN8P+eqC c=1 sm=1 tr=0 ts=68a3de34 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=2OwXVqhp2XgA:10 a=OTBs_5SviU20kZL2kjsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDAyMCBTYWx0ZWRfX0fRyAT/9cIvu f51sgw9XJtW/w9WOfTwZeA8H//a1PJYXxDMuhLl0ig7a3OspgqygkwW+dLZQ+jljWRaBI5wWQJ+ MU1Bv9b1uj8xe3RfMejmkmuR7yz2bQ/X75/VHHf4qtsaUFZ3aIM0IJSJui0yZsj8iLymmPyuT/p
 GkzpMENEgppFlxUbUM9C+EDtrmmpHulrLvKG//mwcsQYNOFNG2K2q1JfhP/zaMGdtei5anxacDt sGC78Sj6YOJgoKXfVCMvSM+YO8UI8wjCCpwvS8d9ZDjoUF1FY6brO/iClBiukwEjaNEpEs3+YTq Czs+wq3DQJ0hAhv1wPXByHyrz/ZnCRCek+BAwYgMEFJUIrkKa2MxZoeo9Rz3Abwnf3O8Pmmv4Pl
 ihg3qNHAnTbh28sAnwHzjvJIe5eVl87Pslo8KZr88wCjEzANcrX1fwL/6kHgtc6Qs9zP/YfU
X-Proofpoint-GUID: SOFXTo22oKhkMOiI_bnsIwiQzQWCvcNc
X-Proofpoint-ORIG-GUID: SOFXTo22oKhkMOiI_bnsIwiQzQWCvcNc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01

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
  CPT also sets BIT(11) of channel number to further help in identifcation.
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

Tanmay Jagdale (7):
  octeontx2-pf: ipsec: Allocate Ingress SA table
  octeontx2-pf: ipsec: Setup NIX HW resources for inbound flows
  octeontx2-pf: ipsec: Handle NPA threshold interrupt
  octeontx2-pf: ipsec: Initialize ingress IPsec
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
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  707 +++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |   71 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  235 +++-
 .../marvell/octeontx2/af/rvu_nix_spi.c        |  211 +++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   40 +
 .../marvell/octeontx2/af/rvu_struct.h         |    4 +-
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 1208 ++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |  136 ++
 .../marvell/octeontx2/nic/otx2_common.c       |   23 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   16 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   17 +
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |    5 +
 .../marvell/octeontx2/nic/otx2_struct.h       |   16 +
 .../marvell/octeontx2/nic/otx2_txrx.c         |   27 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |    4 +
 28 files changed, 2940 insertions(+), 464 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c

-- 
2.43.0

