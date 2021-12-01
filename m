Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2752C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Dec 2021 09:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348134AbhLAJFo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Dec 2021 04:05:44 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63792 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348068AbhLAJFn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Dec 2021 04:05:43 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B10fL5V028993;
        Wed, 1 Dec 2021 01:02:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=akShGmMsOPl2awYdh8eGCwNPG7V+wiwKl3WNKUdogHs=;
 b=R7FpJJPRnaedNNiMpjYZFU0oMA21XBSRLrHYMaSYfai0zW5tSye2k7HOQ0Hb949ey1pT
 UON7KoZYzxgkeDKIf0+fOOT/jCPv86vgZ2lLPF6uh5gjkZ8hi3oxgvVEcZpwn+YX0W3a
 LBYNjJRNjIa+Gy4XcG1P5NdL3ghDmsP54LPpqW3FzAZ+/5vCOve4TWUrg5mVPsJdzjRh
 v48w9htx60TyXZar6aWkeZ3y2ENEEMGRFM6GfTfDEOFgAj7lnqxoeUIqlluUmLZWxiWO
 EjHv2mYNxEEglqdJQ1ghAovLQLv0G6SVy3S6ddHSA5G1KpXx60AR7sl41C3zbyeYCdD1 oA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cnqvyug9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 Dec 2021 01:02:16 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 1 Dec
 2021 01:02:13 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 1 Dec 2021 01:02:13 -0800
Received: from localhost.localdomain (unknown [10.28.34.29])
        by maili.marvell.com (Postfix) with ESMTP id 296335B6938;
        Wed,  1 Dec 2021 01:02:10 -0800 (PST)
From:   Shijith Thotton <sthotton@marvell.com>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Shijith Thotton <sthotton@marvell.com>,
        <linux-crypto@vger.kernel.org>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, <gcherian@marvell.com>,
        <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH 0/2] Octeon TX2 CPT custom engine group
Date:   Wed, 1 Dec 2021 14:31:59 +0530
Message-ID: <cover.1638348922.git.sthotton@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ElN7nmi9AY1YdLyHC9GIFdv9BoCDYulC
X-Proofpoint-GUID: ElN7nmi9AY1YdLyHC9GIFdv9BoCDYulC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Octeon TX2 CPT has three type of engines to handle symmetric, asymmetric
and ipsec specific workload. For better utilization, these engines can
be grouped to custom groups at runtime. Devlink parameters are used to
create and destroy the custom groups (devlink is a framework mainly used
in network subsystem).

Srujana Challa (2):
  crypto: octeontx2: add apis for custom engine groups
  crypto: octeontx2: parameters for custom engine groups

 drivers/crypto/marvell/octeontx2/Makefile     |   2 +-
 .../marvell/octeontx2/otx2_cpt_common.h       |   1 +
 .../marvell/octeontx2/otx2_cpt_devlink.c      | 108 ++++++
 .../marvell/octeontx2/otx2_cpt_devlink.h      |  20 ++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   3 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |   9 +
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 322 +++++++++++++++++-
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |   7 +-
 8 files changed, 464 insertions(+), 8 deletions(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.h

-- 
2.25.1

