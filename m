Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED0FC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 13:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B254D23772
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 13:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbhAONxg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 08:53:36 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1638 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731425AbhAONxf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 08:53:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10FDjouB003175;
        Fri, 15 Jan 2021 05:52:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=6A7ewF/KD3i2UkQoTLJ6v/jhMuX0fNIhAG8zlnMZ/Nk=;
 b=MdTfOjG+zoE0FpLVmkJLVC24yMaKSBJ17KvA4y6KFA79ywzIFPl+uEXQD8zJkfTHd9YC
 soSO4LV9bZ6gn/Z1btwQMZw84s1TrWlNddOE6FCNmwnYaifKjTHW48SpuZB+qDJonbSx
 HwDu7wndlvqTw6xHV3aF2owmy03yvMEzx/HZDIrucp9m1W8Qb3/g6Pzt+WM/r20/WuOx
 +1EPtUSSOE0lQsYhRU5cLoWG1sbtIhf4oQVEtEsqXXT14N/YeYLB9s6/xF6UQdXJ8pgs
 rQwPSwFYBiloFm8TAUkY3yrq6YzunrOVeFb6cCBcHG1fiKP+Ylw+1JS0PSjFpuO/XPaZ Ng== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqt2wk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 05:52:48 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Jan
 2021 05:52:47 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Jan
 2021 05:52:46 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 15 Jan 2021 05:52:46 -0800
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 0162F3F703F;
        Fri, 15 Jan 2021 05:52:44 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <pathreya@marvell.com>, <jerinj@marvell.com>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH v2 0/9] Add Support for Marvell OcteonTX2 CPT engine
Date:   Fri, 15 Jan 2021 19:22:18 +0530
Message-ID: <20210115135227.20909-1-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series introduces crypto(CPT) drivers(PF & VF) for Marvell
OcteonTX2 CN96XX Soc.

OcteonTX2 SOC's resource virtualization unit (RVU) supports multiple
physical and virtual functions. Each of the PF/VF's functionality is
determined by what kind of resources are attached to it. When the CPT
block is attached to a VF, it can function as a security device.

The CPT PF driver is responsible for:
- Forwarding messages to/from VFs from/to admin function(AF),
- Enabling/disabling VFs,
- Loading/unloading microcode (creation/deletion of engine groups).

The CPT VF driver works as a crypto offload device.

This patch series includes:
- CPT PF driver patches that include AF<=>PF<=>VF mailbox communication,
sriov_configure, and firmware load to the acceleration engines.
- CPT VF driver patches that include VF<=>PF mailbox communication and
crypto offload support through the kernel cryptographic API.

This series is tested with CRYPTO_EXTRA_TESTS enabled and
CRYPTO_DISABLE_TESTS disabled.

Changes since v1:
* Resolved compilation warning.


Srujana Challa (9):
  drivers: crypto: add Marvell OcteonTX2 CPT PF driver
  crypto: octeontx2: add mailbox communication with AF
  crypto: octeontx2: enable SR-IOV and mailbox communication with VF
  crypto: octeontx2: load microcode and create engine groups
  crypto: octeontx2: add LF framework
  crypto: octeontx2: add support to get engine capabilities
  crypto: octeontx2: add virtual function driver support
  crypto: octeontx2: add support to process the crypto request
  crypto: octeontx2: register with linux crypto framework

 drivers/crypto/marvell/Kconfig                |   14 +
 drivers/crypto/marvell/Makefile               |    1 +
 drivers/crypto/marvell/octeontx2/Makefile     |   10 +
 .../marvell/octeontx2/otx2_cpt_common.h       |  137 ++
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |  464 +++++
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  202 ++
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  197 ++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  429 ++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  353 ++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   61 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  713 +++++++
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  356 ++++
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 1415 +++++++++++++
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |  162 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   29 +
 .../marvell/octeontx2/otx2_cptvf_algs.c       | 1758 +++++++++++++++++
 .../marvell/octeontx2/otx2_cptvf_algs.h       |  178 ++
 .../marvell/octeontx2/otx2_cptvf_main.c       |  410 ++++
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  167 ++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  541 +++++
 20 files changed, 7597 insertions(+)
 create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c

-- 
2.29.0

