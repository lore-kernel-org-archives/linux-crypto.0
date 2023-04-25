Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD55C6FD18
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Apr 2023 14:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbjDYOGd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Apr 2023 10:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjDYOGc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2023 10:06:32 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE9E210A
        for <linux-crypto@vger.kernel.org>; Tue, 25 Apr 2023 07:06:31 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33P9Emxx013086;
        Tue, 25 Apr 2023 07:06:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=snHdlAcPAd1jB2fS6fayd8uJxPOIzR9ketc/MrzfIV8=;
 b=QUTsxzmU2S5CCCRyFvzdTawevjlFxr7ekTTSkov0ZSzsK58/rfMH0np0oJ0p4573QcWv
 Absy5Sk9wSC5QKSKwoOffKArdi4iTsmvW1csIl9cq+GmPx0wYrXN2rnQc0eu1w40a8kH
 3PXOvWrgMJvdgwAfmD3Q2XErKRXrLtqI5ggB/oyWe92yAV8IW0iL9My2hQLOuN/Q72mY
 HW9V3I1Hb2ddExo2TMEa2CH6L0TPNbwc5iwCgA5qfmQ/TJdIftSnOmNHO6bnNpZFlN0H
 cR/wBtCdxYesYc44Zxr1BEBycOuYV8nkcHDPfFtKqbogbyEeLP8Q1AVz65YLzx4mjLG5 7w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q6c2f94ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 07:06:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 07:06:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 07:06:22 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 263E83F7057;
        Tue, 25 Apr 2023 07:06:20 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <linux-crypto@vger.kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <bbrezillon@kernel.org>, <arno@natisbad.org>
Subject: [PATCH 0/2] crypto: octeontx2: hardware configuration for inline IPsec
Date:   Tue, 25 Apr 2023 19:36:18 +0530
Message-ID: <20230425140620.2031480-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: CrZ1lKtrkmDiaLUvAE4pmU-Tkzpj5FNY
X-Proofpoint-ORIG-GUID: CrZ1lKtrkmDiaLUvAE4pmU-Tkzpj5FNY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_06,2023-04-25_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On OcteonTX2/OctoenTX3 variants of silicon, Admin function (AF)
handles resource allocation and configuration for PFs and their VFs.
PFs request the AF directly, via mailboxes.
Unlike PFs, VFs cannot send a mailbox request directly. A VF sends
mailbox messages to its parent PF, with which it shares a
mailbox region. The PF then forwards these messages to the AF.

Patch1 adds AF to CPT PF uplink mbox to submit the CPT instructions
from AF.
Patch2 adds code to configure inline-IPsec HW resources for
CPT VFs as CPT VFs cannot send a mailbox request directly to AF.

Srujana Challa (2):
  crypto: octeontx2: add support for AF to CPT PF uplink mbox
  crypto: octeontx2: hardware configuration for inline IPsec

 .../marvell/octeontx2/otx2_cpt_common.h       |  15 ++
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |   3 +
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  34 +--
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  33 ++-
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   7 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  41 +++
 .../marvell/octeontx2/otx2_cptpf_mbox.c       | 247 +++++++++++++++++-
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  10 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   1 +
 .../marvell/octeontx2/otx2_cptvf_main.c       |   8 +-
 10 files changed, 359 insertions(+), 40 deletions(-)

-- 
2.25.1

