Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dqlkOEly"
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC32193;
	Fri, 24 Nov 2023 04:51:12 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AO7OxsH003390;
	Fri, 24 Nov 2023 04:50:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=D0eHCyYS6dJbZ9YBln0mmyyhaxqQQDc3Q5QhEnxeRSc=;
 b=dqlkOElygrV+9AA9QxnrKnlG89Ar4S1XD2ta2TB5ZnxO8wKJh1pKzIAiihna+TiafuSu
 5DR2DWur0bJ+rY0krrRgaBuSHkKHihkULX0YUonY6S6Bs0yBz2iUWJTIYlbuiVxCwb+N
 rtSIygK1DbgU7e7Wv6IVovETqJgJtsbVH+roPaYBL3XbKRBDIZHcEaMLq9A2iMQqaFey
 o5kYCLfEzmnRKyc75XO1fDBK+TFtKBaachQ8cnZoROQqtXMtJSWLX60l5wnAMIw2gbZk
 cwUg3MCVFYw4qstCjDnq+n9NF+MOWNu6crJ4zgbRfeZhXKlVHxuFO27qJ9PFyb5jEMo7 5A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3uhpxn69a1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Fri, 24 Nov 2023 04:50:55 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 24 Nov
 2023 04:50:53 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 24 Nov 2023 04:50:53 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 528483F7040;
	Fri, 24 Nov 2023 04:50:48 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <ndabilpuram@marvell.com>, <sgoutham@marvell.com>,
        <jerinj@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next 00/10] Add Marvell CPT CN10KB/CN10KA B0 support
Date: Fri, 24 Nov 2023 18:20:37 +0530
Message-ID: <20231124125047.2329693-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: sCnd2jpYCzYf-z7YZN9aDl46LNjL0z9L
X-Proofpoint-GUID: sCnd2jpYCzYf-z7YZN9aDl46LNjL0z9L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-23_15,2023-11-22_01,2023-05-22_02

Marvell OcteonTX2's next gen platform CN10KB/CN10KA B0
introduced changes in CPT SG input format(SGv2) to make
it compatibile with NIX SG input format, to support inline
IPsec in SG mode.

This patchset modifies the octeontx2 CPT driver code to
support SGv2 format for CN10KB/CN10KA B0. And also adds
code to configure newly introduced HW registers.
This patchset also implements SW workaround for couple of
HW erratas.

Nithin Dabilpuram (2):
  crypto/octeontx2: register error interrupts for inline cptlf
  crypto: octeontx2: support setting ctx ilen for inline CPT LF

Srujana Challa (8):
  crypto: octeontx2: remove CPT block reset
  crypto: octeontx2: add SGv2 support for CN10KB or CN10KA B0
  crypto: octeontx2: add devlink option to set max_rxc_icb_cnt
  crypto: octeontx2: add devlink option to set t106 mode
  crypto: octeontx2: remove errata workaround for CN10KB or CN10KA B0
    chip.
  crypto: octeontx2: add LF reset on queue disable
  octeontx2-af: update CPT inbound inline IPsec mailbox
  crypto: octeontx2: add ctx_val workaround

 Documentation/crypto/device_drivers/index.rst |   9 +
 .../crypto/device_drivers/octeontx2.rst       |  29 ++
 Documentation/crypto/index.rst                |   1 +
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c  |  87 +++++-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |  25 ++
 .../marvell/octeontx2/otx2_cpt_common.h       |  68 +++-
 .../marvell/octeontx2/otx2_cpt_devlink.c      |  88 +++++-
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |   9 +-
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  26 ++
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 293 ++++++++++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c | 131 +++++---
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 102 ++++--
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   4 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  76 ++---
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  81 ++++-
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  49 +--
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |   3 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   2 +
 .../marvell/octeontx2/otx2_cptvf_algs.c       |  31 ++
 .../marvell/octeontx2/otx2_cptvf_algs.h       |   5 +
 .../marvell/octeontx2/otx2_cptvf_main.c       |  25 +-
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  27 ++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 162 +---------
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  20 ++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  14 +
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   1 +
 26 files changed, 1063 insertions(+), 305 deletions(-)
 create mode 100644 Documentation/crypto/device_drivers/index.rst
 create mode 100644 Documentation/crypto/device_drivers/octeontx2.rst

-- 
2.25.1

