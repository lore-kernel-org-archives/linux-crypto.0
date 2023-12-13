Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="XBlRdELe"
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826A1BD;
	Tue, 12 Dec 2023 23:31:14 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BCMH459019781;
	Tue, 12 Dec 2023 23:31:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=pfpt0220; bh=pD8pB40+
	MGPhPGsW22XbO9Z6GQcv7R44T6Pe6un/LSo=; b=XBlRdELePeBKn36psY2AumcG
	YRYPzyA/x35EQKDafRPKiDMivL/z5V11gQ/i5wnk4D+TcXwAarCnWCqfBrn1JkCe
	y77k+AwbYdwvWBHmQqjgCmek/nO/Lc1XU2FrN8yQuHhhZVWoEFFPbKpQH6xwfg3r
	myXpQ+C5F2QaaMqXlE1CLPppr++7eAu9fdDMzDIIVDz5AIc7Ryq0qeqHfpWSjbFc
	yzuGTRggiipylxljOLLYKLqvfYqaBx1Q0pXmgfLi/w2yAC+KFDqBd5eoq7CQInsi
	DqOcf2dSFQBbFNaGl2x8YQ3ErRU2U6cdmlWL4pL3onTfwFGGDXtkgCjUyrrx6A==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3uvrmjvrhw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 23:31:03 -0800 (PST)
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 12 Dec
 2023 23:31:01 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 12 Dec 2023 23:31:01 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 213083F7085;
	Tue, 12 Dec 2023 23:30:56 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kuba@kernel.org>, <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <corbet@lwn.net>, <kalesh-anakkur.purayil@broadcom.com>,
        <horms@kernel.org>, <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <jerinj@marvell.com>, <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v3 0/9] Add Marvell CPT CN10KB/CN10KA B0 support
Date: Wed, 13 Dec 2023 13:00:46 +0530
Message-ID: <20231213073055.588530-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: SGbzkdvS5yTp9Nj50pL9J2olfVuuuIb2
X-Proofpoint-ORIG-GUID: SGbzkdvS5yTp9Nj50pL9J2olfVuuuIb2
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

v3:
- Dropped a patch to submit to netdev.
v2:
- Addressed review comments.
- Fixed sparse errors reported by kernel test robot.

Nithin Dabilpuram (2):
  crypto/octeontx2: register error interrupts for inline cptlf
  crypto: octeontx2: support setting ctx ilen for inline CPT LF

Srujana Challa (7):
  crypto: octeontx2: remove CPT block reset
  crypto: octeontx2: add SGv2 support for CN10KB or CN10KA B0
  crypto: octeontx2: add devlink option to set t106 mode
  crypto: octeontx2: remove errata workaround for CN10KB or CN10KA B0
    chip.
  crypto: octeontx2: add LF reset on queue disable
  octeontx2-af: update CPT inbound inline IPsec mailbox
  crypto: octeontx2: add ctx_val workaround

 Documentation/crypto/device_drivers/index.rst |   9 +
 .../crypto/device_drivers/octeontx2.rst       |  25 ++
 Documentation/crypto/index.rst                |   1 +
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c  |  86 ++++-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |  27 ++
 .../marvell/octeontx2/otx2_cpt_common.h       |  54 +++-
 .../marvell/octeontx2/otx2_cpt_devlink.c      |  44 ++-
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |   9 +-
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  26 ++
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 298 ++++++++++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c | 133 +++++---
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 105 ++++--
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   4 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  73 ++---
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  82 ++++-
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  49 +--
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |   3 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   2 +
 .../marvell/octeontx2/otx2_cptvf_algs.c       |  31 ++
 .../marvell/octeontx2/otx2_cptvf_algs.h       |   5 +
 .../marvell/octeontx2/otx2_cptvf_main.c       |  23 +-
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  28 ++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 162 +---------
 23 files changed, 975 insertions(+), 304 deletions(-)
 create mode 100644 Documentation/crypto/device_drivers/index.rst
 create mode 100644 Documentation/crypto/device_drivers/octeontx2.rst

-- 
2.25.1

