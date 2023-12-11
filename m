Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jYEyyqYA"
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4212D1;
	Sun, 10 Dec 2023 23:19:34 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BANfjlm019781;
	Sun, 10 Dec 2023 23:19:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=pfpt0220; bh=8vh6tf0U
	iRO7FFwK1zjPOvDLQnY91imk59vOvs2rXlE=; b=jYEyyqYAzz5DIdzvHExKHz7f
	bvTF4raXGN/jyVoAfnGuV+qNxDaLA8pOxgyOth1/Y7QOdtG9K8LWLePCczqWqQcM
	KQ/o92y4yEsn4PchLIH5VaY0JcZVLHNzUB8OV7TUHcrIIwkHb7mnS6DRWNgHGnIP
	2iKz6LKIPOdtCuQWCBXqj7AHafm3toOItGm5V30z+woHYP4sDYo69WMVwD4K/WI+
	6sq87maP0j7+IZi2kqTC+V0dGsDbGOwWypRsS3cQJqMQH/pqZ5dzKjjJ88v7jsRv
	P8yGUhIZx2BJXm7pNHzYYuMU0os0QzMwNlk0ZMhUVo+kpp1PLBDgnbBWBogaRw==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3uvrmjkmgt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sun, 10 Dec 2023 23:19:22 -0800 (PST)
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 10 Dec
 2023 23:19:20 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 10 Dec 2023 23:19:20 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id D646A3F70A1;
	Sun, 10 Dec 2023 23:19:14 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <corbet@lwn.net>, <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <jerinj@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next v1 00/10] Add Marvell CPT CN10KB/CN10KA B0 support
Date: Mon, 11 Dec 2023 12:49:03 +0530
Message-ID: <20231211071913.151225-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: vuFEhNP5g5RWo8ezdaOa__R2rmyalrig
X-Proofpoint-ORIG-GUID: vuFEhNP5g5RWo8ezdaOa__R2rmyalrig
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

Marvell OcteonTX2's next gen platform CN10KB/CN10KA B0
introduced changes in CPT SG input format(SGv2) to make
it compatibile with NIX SG input format, to support inline
IPsec in SG mode.

This patchset modifies the octeontx2 CPT driver code to
support SGv2 format for CN10KB/CN10KA B0. And also adds
code to configure newly introduced HW registers.
This patchset also implements SW workaround for couple of
HW erratas.

v1:
- Fixed sparse errors reported by kernel test robot.

Nithin Dabilpuram (2):
  crypto/octeontx2: register error interrupts for inline cptlf
  crypto: octeontx2: support setting ctx ilen for inline CPT LF

Srujana Challa (8):
  crypto: octeontx2: remove CPT block reset
  :crypto: octeontx2: add SGv2 support for CN10KB or CN10KA B0
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
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c  |  89 +++++-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |  27 ++
 .../marvell/octeontx2/otx2_cpt_common.h       |  68 +++-
 .../marvell/octeontx2/otx2_cpt_devlink.c      |  89 +++++-
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |   9 +-
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  26 ++
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 295 ++++++++++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c | 133 +++++---
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 104 ++++--
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   4 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  76 ++---
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  82 ++++-
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  49 +--
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |   3 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   2 +
 .../marvell/octeontx2/otx2_cptvf_algs.c       |  31 ++
 .../marvell/octeontx2/otx2_cptvf_algs.h       |   5 +
 .../marvell/octeontx2/otx2_cptvf_main.c       |  25 +-
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  28 ++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 162 +---------
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  20 ++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  14 +
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   1 +
 26 files changed, 1076 insertions(+), 305 deletions(-)
 create mode 100644 Documentation/crypto/device_drivers/index.rst
 create mode 100644 Documentation/crypto/device_drivers/octeontx2.rst

-- 
2.25.1
