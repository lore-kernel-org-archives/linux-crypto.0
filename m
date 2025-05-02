Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129AB242D82;
	Fri,  2 May 2025 13:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192095; cv=none; b=uPm+dnnbXX2pJnBJQAoW2p9SmvoU9U4QYWs0OYQvojrJwQjLxpE6pog8xFN6VnUEx0l6idIu88tOSqGpQ1ez46SD9rE6QO59AqRJia6N0XqMiqCYKLV7JbdjByQfgY3o19Zot6pVgiyOD2eyjmQgrskqWCrzEODUQX4/sY4m7OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192095; c=relaxed/simple;
	bh=rIAlmlwMtQaUgow1iGT0jE1zo6pYUXceWlqRKjuOQxc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ltm75U9OENk77X5+RiRQiPS5TYKA2XxtgMoH6rw0CIZX84qmVQvY3Of4tTbnVDUhZ0MV345a1UnsYSpza/39/q7dwL7lYpb3IV7IbjM9eplZjlK8USW7OOMwAbSFfvz6UlI9Jt0hZhe5pwSF/z8Lp0hc2jbiwFvMnOgmMP4I2mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jwOsbvMa; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jwOsbvMa"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5428rEtc026238;
	Fri, 2 May 2025 06:20:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=2+wqQXMClAVhXAV0is5Y088
	yZ6Z5k3S6DIxIe4xuZyg=; b=jwOsbvMa+ohV7liVQjtFOIkxlLgBGgq5VD6fOJB
	58EAri/83tLKCYdDsWANmYXWmyjraw8h0difekZhpVF/fwod+B4ApPqikJpUQqej
	YQ+6Vq+aSCFapg9WcCu2fUfGVt7GlTjOQlOu/2zHL1ewcsZxyYR1FARiseMx8iqi
	d1midvaGa4eA0CcTAVhS9ipHeyiV+OQZZAKSlRk3doXKkZb6VPLlW2/M3C2gpRUI
	hnxfcnMv5hzwuCcEcrqaxaGQPdtpnJtOxtw7+lOaCcPsUfvS8mALsdHxDSQaamcP
	IHHekPYrLTbmj6+Z5XN/4BNrT2TWMfftr60f64CF/6GPK9g==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46cjpb97tu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 May 2025 06:20:51 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 2 May 2025 06:20:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 2 May 2025 06:20:50 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id 908765B6921;
	Fri,  2 May 2025 06:20:38 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <bbrezillon@kernel.org>, <arno@natisbad.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        <jerinj@marvell.com>, <hkelam@marvell.com>, <sbhatta@marvell.com>,
        <andrew+netdev@lunn.ch>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bbhushan2@marvell.com>, <bhelgaas@google.com>,
        <pstanner@redhat.com>, <gregkh@linuxfoundation.org>,
        <peterz@infradead.org>, <linux@treblig.org>,
        <krzysztof.kozlowski@linaro.org>, <giovanni.cabiddu@intel.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <rkannoth@marvell.com>, <sumang@marvell.com>,
        <gcherian@marvell.com>, Tanmay Jagdale <tanmay@marvell.com>
Subject: [net-next PATCH v1 00/15] Enable Inbound IPsec offload on Marvell CN10K SoC
Date: Fri, 2 May 2025 18:49:41 +0530
Message-ID: <20250502132005.611698-1-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: gnSXQwkE1vHbwsI35uWgU8hgqyEOk8wn
X-Proofpoint-ORIG-GUID: gnSXQwkE1vHbwsI35uWgU8hgqyEOk8wn
X-Authority-Analysis: v=2.4 cv=Tu/mhCXh c=1 sm=1 tr=0 ts=6814c6b3 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=JobPnVYPRzK78MvRnRwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNiBTYWx0ZWRfX6bprN3aCERIj 54lRHMrkhAyALYu5vKvQrSiwwmbNd0ySOL46nTi910ZJv6WiDwjMFb0h0D2YP8h56zYMZnrL2vp fgDacnhk23P3/H9S20TdkuqkW3Non9g2+XRh++coKmaLlzXpsmnoH7cJNV1Ztfr9ssclbCFCkS4
 bOoKpW2PtOrdNGrIc2WHJEvZLKp7m+z1scFTs9zGsgerPl9jr99/FVWptdn0VWmbTJD77ZUH1Rr futKXOqFBNfhw2IICkxoKjmBvDK9bGPsIhMtNX5SitG1eohv7WCK5VrexrjsfELATi1dPhTHJfv QyFGiEqntwozLd/ItLLg4aKCfi07FiWXd9O60DaI8TrCA5zlzxWWxY8ZSJEKHOQYrdstMkEnPJu
 aIg9NgHquDA6larr6j3zfdrXx+OowAr/NRCnFmzgGhnvTXaSOAsLVzuNxy3lFH1miz9R7v9N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01

This patch series adds support for inbound inline IPsec flows for the
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


Patches are grouped as follows:
-------------------------------
1) CPT LF movement from crypto driver to RVU AF
    0001-crypto-octeontx2-Share-engine-group-info-with-AF-dri.patch
    0002-octeontx2-af-Configure-crypto-hardware-for-inline-ip.patch
    0003-octeontx2-af-Setup-Large-Memory-Transaction-for-cryp.patch
    0004-octeontx2-af-Handle-inbound-inline-ipsec-config-in-A.patch
    0005-crypto-octeontx2-Remove-inbound-inline-ipsec-config.patch

2) RVU AF Mailbox changes for CPT 2nd pass RQ mask, SPI-to-SA table,
   NIX-CPT BPID configuration
    0006-octeontx2-af-Add-support-for-CPT-second-pass.patch
    0007-octeontx2-af-Add-support-for-SPI-to-SA-index-transla.patch
    0008-octeontx2-af-Add-mbox-to-alloc-free-BPIDs.patch

3) Inbound Inline IPsec support patches
    0009-octeontx2-pf-ipsec-Allocate-Ingress-SA-table.patch
    0010-octeontx2-pf-ipsec-Setup-NIX-HW-resources-for-inboun.patch
    0011-octeontx2-pf-ipsec-Handle-NPA-threshhold-interrupt.patch
    0012-octeontx2-pf-ipsec-Initialize-ingress-IPsec.patch
    0013-octeontx2-pf-ipsec-Manage-NPC-rules-and-SPI-to-SA-ta.patch
    0014-octeontx2-pf-ipsec-Process-CPT-metapackets.patch
    0015-octeontx2-pf-ipsec-Add-XFRM-state-and-policy-hooks-f.patch


Bharat Bhushan (5):
  crypto: octeontx2: Share engine group info with AF driver
  octeontx2-af: Configure crypto hardware for inline ipsec
  octeontx2-af: Setup Large Memory Transaction for crypto
  octeontx2-af: Handle inbound inline ipsec config in AF
  crypto: octeontx2: Remove inbound inline ipsec config

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
  octeontx2-pf: ipsec: Manage NPC rules and SPI-to-SA table entries
  octeontx2-pf: ipsec: Process CPT metapackets
  octeontx2-pf: ipsec: Add XFRM state and policy hooks for inbound flows

 .../marvell/octeontx2/otx2_cpt_common.h       |    8 -
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   10 -
 .../marvell/octeontx2/otx2_cptpf_main.c       |   50 +-
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  286 +---
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  116 +-
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |    3 +-
 .../ethernet/marvell/octeontx2/af/Makefile    |    2 +-
 .../ethernet/marvell/octeontx2/af/common.h    |    1 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  119 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |    9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   71 +
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |   11 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  706 +++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |   71 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  230 +++-
 .../marvell/octeontx2/af/rvu_nix_spi.c        |  220 +++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   16 +
 .../marvell/octeontx2/af/rvu_struct.h         |    4 +-
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 1191 ++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |  152 +++
 .../marvell/octeontx2/nic/otx2_common.c       |   23 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   16 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   17 +
 .../marvell/octeontx2/nic/otx2_struct.h       |   16 +
 .../marvell/octeontx2/nic/otx2_txrx.c         |   25 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |    4 +
 26 files changed, 2915 insertions(+), 462 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c

-- 
2.43.0

