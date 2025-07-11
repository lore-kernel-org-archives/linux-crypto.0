Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE40528C2D2;
	Fri, 11 Jul 2025 12:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752236042; cv=none; b=Fr3QEANUn7HnPc+0T/52RXnsdwIk7sekhywZRBo3tuGdcFcuw43qKXORjwsYIfY01KhMwsiqwwpccVrAp5ivDnJPYCQwIDMnHykBgtDuFQdmd8zNg1tdZZ9gt+jLV74B7+EV0FNq2SPkdIdeTpRBGxoqLdFc3y7jNsZnGCRQl6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752236042; c=relaxed/simple;
	bh=od06OYyJQNBIaoMMEWnmyZCZFNCqB4uJCnhW4mgRLNg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ldm/fD7FLqqzPumIWepmF4lWGEGv+mV9k7m/B7sxJ6XEuduzo4476SKY1QA7AYA3yvTWjFA39HQO9JX45sdEDtZVvgbAxK0t6hhDOqW3AWfIwNqCxn48tgiHfM8G6RLVnDRvDbEOQf5xgKMQTiPdSb8nRWqD5gRBMNb5cw94M/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=PHhpq+JQ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="PHhpq+JQ"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56BBSfGL024054;
	Fri, 11 Jul 2025 05:13:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=VHbYwcxmV/ccLUWFZRZKrRh
	/eZa9nENxL6IzsNfpziw=; b=PHhpq+JQG7OmPIZcJ/XSeYUjOREGj0CKyFTMyCb
	EhtPYT7rfksKjJ410uj+Kut9NeA3tlAz8lAuHcXAwq7My+aBhKPVYwmlNMr9pZe7
	WNRcXfvQGKUTctaAgIRI7JhUE3h/ZlhikvnYh/X2wCR1ScZ1CMU58dnnegMjkKMg
	6jm6WdmroOsnVU5y+sq9BR6zxaY20IA6dOqFPAqFpgdxemQalYLs2r59Dh8kb7P+
	ECvqS3naUvP7Bfn4jOWX4+1oF3YLV/2Xl3Hn48xbundmoE68gOIcqm0Jrw3Tdh3p
	d5TIXD5ap8gz06bdvBQ4jOFi/0Yq4sbuzLzJ5oRipQuWaIQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 47u1s501xp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 05:13:40 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 11 Jul 2025 05:13:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 11 Jul 2025 05:13:38 -0700
Received: from optiplex.marvell.com (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with ESMTP id B66FD3F7058;
	Fri, 11 Jul 2025 05:13:35 -0700 (PDT)
From: Tanmay Jagdale <tanmay@marvell.com>
To: <davem@davemloft.net>, <leon@kernel.org>, <horms@kernel.org>,
        <herbert@gondor.apana.org.au>, <sgoutham@marvell.com>,
        <bbhushan2@marvell.com>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tanmay Jagdale
	<tanmay@marvell.com>
Subject: [PATCH net-next v3 00/14] Enable Inbound IPsec offload on Marvell CN10K SoC
Date: Fri, 11 Jul 2025 17:42:53 +0530
Message-ID: <20250711121317.340326-1-tanmay@marvell.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA4NiBTYWx0ZWRfX2eL/zLQ2YfXZ 4ibQcliANTY9Ti7/sJboetU2ZjnJPXdY2jtWKx1bjX4xXljRU0n0aSjMsfvJvQJ1GJU43BT0IYq Gf/9+/HM+OuwzRJNY/CgOv/rrUlCiskM2EZxAkzaEBvfwG2Wx836xEBnNrz8B8DlsX6fHm0tW8r
 hG9R3D5OiLMTB06Rol3+GBJzW85QCx60anDBdiM52CYP0fjpkyeZJDxPyb6vSBDmMpeqYjCPOMO S2CEv/S99L3AGWLBsuthDGRqji821wHBTCamCtGstPsnV+77gW/asMIXZqGCnhBa216lS3Mtxu3 hLFILXlgVIRwdHIUd6CHu770B0FoFqXwOEgWCoKt9w3YNlnopOppN1apOTsHNr8TCSdOlCVnvrG
 1G5E3QwvEFeDj9P9tauOhk3xm5EMCmYN9Lyu5IdXW+qh5QE2RsQU+kG3gi2gTv/1uMImGHW+
X-Authority-Analysis: v=2.4 cv=DO+P4zNb c=1 sm=1 tr=0 ts=6870fff4 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=Wb1JkmetP80A:10 a=OTBs_5SviU20kZL2kjsA:9
X-Proofpoint-GUID: V8INzZprujE8PDQrkAXJCfSP78ovgYUJ
X-Proofpoint-ORIG-GUID: V8INzZprujE8PDQrkAXJCfSP78ovgYUJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01

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
 .../marvell/octeontx2/nic/cn10k_ipsec.c       | 1204 ++++++++++++++++-
 .../marvell/octeontx2/nic/cn10k_ipsec.h       |  159 +++
 .../marvell/octeontx2/nic/otx2_common.c       |   23 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   16 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   17 +
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |    5 +
 .../marvell/octeontx2/nic/otx2_struct.h       |   16 +
 .../marvell/octeontx2/nic/otx2_txrx.c         |   27 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |    4 +
 28 files changed, 2959 insertions(+), 464 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c

-- 
2.43.0

