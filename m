Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B7FC4707F
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 11:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6C496101E
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 11:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhEYLcL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 07:32:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44886 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231321AbhEYLcI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 07:32:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PBUPU6028126;
        Tue, 25 May 2021 04:30:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=mAkMu1+TVLOV+6VgA8/k5DOXUGSoGAtVt3S5a0Ph3Gc=;
 b=JCSWAU0xR+VCoztzKA7gVmvsMyxUxr4DKwuqSl+Hai+ceTAIMfhbVEygDceSc5btzfnl
 KY8GMMUrQRkd/Or8xP/d7V6LqpbggxHj43Ww2qgFSeb/EYi0mSc5Cv8N5MeFq165WI4a
 MMm19CSwjhJQwLFo/U+1p+mEs0O7/fRLZxW3av+kZBpHlxDXeSOLrk3Zr5cO/SIj4ltF
 BOyxidvgaAEULunKrRtTG3eCioHUPMnZ9OVbLDgsQdjtcIM4JKDGzdfYYg5Iw2m2ThXC
 muDMeUZEm5BELjL0e0vyk1sfC7rKb+FXFoiEx8PRcGgpW24y7f4SeURZKKnw5HrhO69B OA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38s0dw801h-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 04:30:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 04:27:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 04:27:43 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 9D25A3F703F;
        Tue, 25 May 2021 04:27:41 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <arno@natisbad.org>, <bbrezillon@kernel.org>, <jerinj@marvell.com>,
        "Srujana Challa" <schalla@marvell.com>
Subject: [PATCH 0/4] Add support for Marvell CN10K CPT block
Date:   Tue, 25 May 2021 16:57:14 +0530
Message-ID: <20210525112718.18288-1-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: PcO-DROIe4dSq-MRGxO4lFcmpVpm5U0Y
X-Proofpoint-ORIG-GUID: PcO-DROIe4dSq-MRGxO4lFcmpVpm5U0Y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_06:2021-05-25,2021-05-25 signatures=0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current CPT driver supports OcteonTX2 silicon variants.
The same OcteonTX2 Resource Virtualization Unit(RVU) is
carried forward to the next-gen silicon ie OcteonTX3(CN10K),
with some changes and feature enhancements.

This patch series adds support for CN10K silicon.

Srujana Challa (4):
  crypto: octeontx2: Add mailbox support for CN10K
  crypto: octeontx2: add support to map LMTST region for CN10K
  crypto: octeontx2: add support for CPT operations on CN10K
  crypto: octeontx2: enable and handle ME interrupts

 drivers/crypto/marvell/octeontx2/Makefile     |  13 +-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c  |  93 ++++++++++
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |  36 ++++
 .../marvell/octeontx2/otx2_cpt_common.h       |  23 +++
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |  16 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c |   9 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  10 ++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   1 +
 .../marvell/octeontx2/otx2_cptpf_main.c       | 160 +++++++++++++-----
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  32 +++-
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |   8 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   3 +
 .../marvell/octeontx2/otx2_cptvf_main.c       |  49 ++++--
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  43 +++++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  17 +-
 15 files changed, 438 insertions(+), 75 deletions(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/cn10k_cpt.c
 create mode 100644 drivers/crypto/marvell/octeontx2/cn10k_cpt.h

-- 
2.29.0

