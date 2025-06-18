Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B2E27817A;
	Wed, 18 Jun 2025 11:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246246; cv=none; b=BOzFT/t4juAuLXD/Z6yoHCdpQwon1zahqVY1dR+30vabCt2/Wn0Y1xlR9TOwfUYt5ZETOkGjr7JMZQVpfUkiaUgLZ2/Ova4OI2ze0cFTgBa5nsCJxz+60RqL/VbYO0hnnvpBUDss45j9dGvdrPXJR2/EGXrZD7zUyi/rVPTEiIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246246; c=relaxed/simple;
	bh=G1ZC6k9aElxTPcGTMaMBc9WVAseOHou+R0Sd1uM1cBw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A3QJhEtnTCZK3Dj4TeqfKMi+x8Wb40Z+maMWbC2ZQifv6w8ntWR7jLnCo+md1l8MrvyCtHdb15N22iBwL7/5I0q/hBDj+NHZ0P/KViUipuAR90J1pfRYz25goAXuMLocWLgZSEVC/pCdkUAlWcXWNSTLwSxzWCg3u2yMX3reyHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=KZ/WZHOK; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KZ/WZHOK"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I9GM44023319;
	Wed, 18 Jun 2025 04:30:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=LfhpCStMs4CvHwLjxcKvdQj
	A+A3DqaHTy6neqFpZJPo=; b=KZ/WZHOKgdFHP5sGmyHi7c6l/Aj8p1tmO0Xdysf
	khIws1Cp3PyArwD5SdpNpG/Lnn7jG/vh2xjYZ8QsokI10o+RieRfmXg9kgx0yWnj
	abDpJJwSzpVTvKPDjYe0VL/VMfhCS7Hlhwfi/RPxktreABXZgANgl6fpBEmCKo+8
	r8f9ZnlLAz5s2ATkXcKgn4HrGvIPSnLWvE3bRSCXROAD/UChuDTJJb9zNSz/nkQa
	sSm1pjYg6s7Bhj5e/1QtV+wGuqGxvJ9Azb1Pcuic8EZ6aiRiQa8MGqmxWsSaNAFX
	L4N+O49dM404oRVnFuxiC5iz7hRsv1IHnKmpx0gb3DggOcQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 47btnx88ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 04:30:34 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Jun 2025 04:30:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Jun 2025 04:30:33 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 866A23F7048;
	Wed, 18 Jun 2025 04:30:30 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v2 00/14] Enable Inbound IPsec offload on Marvell CN10K SoC
Date: Wed, 18 Jun 2025 16:59:54 +0530
Message-ID: <20250618113020.130888-1-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=E4TNpbdl c=1 sm=1 tr=0 ts=6852a35a cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=6IFa9wvqVegA:10 a=OTBs_5SviU20kZL2kjsA:9
X-Proofpoint-ORIG-GUID: iAobG7RsJXRjyMee5o9EPy3WOYSI5Odp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA5NyBTYWx0ZWRfX2x0yQHtYXsev Z/3DTgigfUhJMAMK7OP6LC7YnzS45NODExup85HnxNc64SFEopwn8nIylfNfs75mDEALR/FXfTE vERmSMWa/dHbGXO8bh03j8F7EvypLE1eTr9B/djlJPElfhJrwVQ0Fx8HO8Ib7kbo+WOUHLYl09G
 5fUsH7QDxdBQ7yy4BnLowLAqgAuCmDOCktUQmbAp8zgIBkmW3WD0jH4wrpBlOMzrtYTx6gkw1YQ TtqGzgn7liigDOIwUIzs1IBkge+0nLKD7X3Kn7qV/3A6Uk4aJ7ibYLWDok7toh43eSaV2ken2GZ RCKP1v2ngcyXiBqnqjUG3pleh/lzPCvBu62X8NCqDEHmE9AdiwC7+sAikhAc0l7/9zU77r+I3b8
 r1kNbIeWv7igX/FOiC8/mwMf1I7JGsfKcqiL5SmeDvV9oYNVP+snpxDSYEUKvopKRET1VjOU
X-Proofpoint-GUID: iAobG7RsJXRjyMee5o9EPy3WOYSI5Odp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_04,2025-06-18_02,2025-03-28_01

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
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |    9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   71 +
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |   11 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  707 +++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |   71 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  235 +++-
 .../marvell/octeontx2/af/rvu_nix_spi.c        |  211 +++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   40 +
 .../marvell/octeontx2/af/rvu_struct.h         |    4 +-
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 1183 ++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |  154 +++
 .../marvell/octeontx2/nic/otx2_common.c       |   23 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   18 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   17 +
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |    2 +
 .../marvell/octeontx2/nic/otx2_struct.h       |   16 +
 .../marvell/octeontx2/nic/otx2_txrx.c         |   29 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |    4 +
 28 files changed, 2935 insertions(+), 464 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c

-- 
2.43.0

