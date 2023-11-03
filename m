Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD0BC4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Nov 2023 05:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjKCFda (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Nov 2023 01:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjKCFda (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2023 01:33:30 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35E018B;
        Thu,  2 Nov 2023 22:33:24 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A2L8vPV025634;
        Thu, 2 Nov 2023 22:33:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=++u2QPmCV6gWswyCJVglrBgtKR9wwnznpwMNf3rdKew=;
 b=cVL8B6Tq2H2EuAR6RKBUzeNXM7l2XNwksELNjSG+OZ7GPbYIDpI5HR50aRe3oazcFIJS
 ZXPsfuT+kL0G5/7WDpCJZr6Szz7w3LY1v5atQ9SilI8NfS3Di+zUe3WZhfQ7HPBVr+2o
 pynLmrbSnqAw09veleHkmNrHzh/h/QHH8ZNMyOq9roZEhIKybilxsstTuERGXLp7xQRj
 T3LoZ6tSjtIrFJdmosZ5jPvRyy5JdHosKZip4uCcDyJcat3LbJt/EN5fit5y/MFnRrBx
 NMA5R/JihkCQCRtVhO1I2Mdif/SPEUpnKWImLvEBhv9lqXIpnuAI0ypBnsg/cglH6WsI 4Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3u3y235dxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Nov 2023 22:33:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 2 Nov
 2023 22:33:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 2 Nov 2023 22:33:10 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 86F2C3F7070;
        Thu,  2 Nov 2023 22:33:07 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <kuba@kernel.org>, <ndabilpuram@marvell.com>,
        <sgoutham@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v1 00/10] Add Marvell CN10KB/CN10KA B0 support
Date:   Fri, 3 Nov 2023 11:02:56 +0530
Message-ID: <20231103053306.2259753-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: rk-1i1-YhAlpep0PIGw0aEJl15nvYkxf
X-Proofpoint-GUID: rk-1i1-YhAlpep0PIGw0aEJl15nvYkxf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_05,2023-11-02_03,2023-05-22_02
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Marvell OcteonTX2's next gen platform CN10KB/CN10KA B0
introduced changes in CPT SG input format(SGv2) to make
it compatibile with NIX SG input format, to support inline
IPsec in SG mode.

This patchset modifies the octeontx2 CPT driver code to
support SGv2 format for CN10KB/CN10KA B0. And also adds
code to configure newly introduced HW registers.
This patchset also implements SW workaround for couple of
HW erratas.

---
v1:
- Documented devlink parameters supported by octeontx2 CPT
  driver.
---

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

