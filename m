Return-Path: <SRS0=jmhz=46=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C20C10DCE
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 11:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABA5220691
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 11:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Aut9rHjd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgCMLr6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Mar 2020 07:47:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8144 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726479AbgCMLr6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Mar 2020 07:47:58 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DBiqE5021801;
        Fri, 13 Mar 2020 04:47:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=DbCQXabVT+AFR1lUQkzyM4WAwKVKfN6pXKN+bVd2188=;
 b=Aut9rHjdp4m6iW10EWQtIC6qpxqBEtF5/jjagXeyXRvHOwkops601CXKShPuiaLi/xfm
 7PFaa6yiEQQRgp8l4W4Gk7dKwTbfgYkQEBnYOWuUlCis4Vtudt5rHO51IBc+ArYQUeHR
 ESRjU6bHliujiNLphL1Ebyc+p5/kOlC9wscL+AbKmI0x2SQJhS7YoAj2VYUhRv96zWWC
 Kpj2b+G3qMezLn+RS/dnY0VRFzLpQiib2vQWhizsRcn5RNsXMI16njUWopfdTZUjqxan
 SllTvztifpHuItoyFazeiekRW4CQUp30OAZGmdZ0n0ASKhPRbhZ/rCBaHyllZIGcG52L YA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2yqt7t3mu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Mar 2020 04:47:47 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 13 Mar
 2020 04:47:46 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 13 Mar
 2020 04:47:45 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 13 Mar 2020 04:47:45 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id F20F23F7040;
        Fri, 13 Mar 2020 04:47:41 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <pathreya@marvell.com>, <schandran@marvell.com>,
        <arno@natisbad.org>, <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH v2 0/4] Add Support for Marvell OcteonTX Cryptographic
Date:   Fri, 13 Mar 2020 17:17:04 +0530
Message-ID: <1584100028-21279-1-git-send-email-schalla@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_04:2020-03-12,2020-03-13 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The following series adds support for Marvell Cryptographic Accelerarion
Unit (CPT) on OcteonTX CN83XX SoC.

Changes since v1:
* Replaced CRYPTO_BLKCIPHER with CRYPTO_SKCIPHER in Kconfig.

Srujana Challa (4):
  drivers: crypto: create common Kconfig and Makefile for Marvell
  drivers: crypto: add support for OCTEON TX CPT engine
  drivers: crypto: add the Virtual Function driver for CPT
  crypto: marvell: enable OcteonTX cpt options for build

 MAINTAINERS                                        |    1 +
 drivers/crypto/Kconfig                             |   15 +-
 drivers/crypto/Makefile                            |    2 +-
 drivers/crypto/marvell/Kconfig                     |   37 +
 drivers/crypto/marvell/Makefile                    |    7 +-
 drivers/crypto/marvell/cesa.c                      |  615 -------
 drivers/crypto/marvell/cesa.h                      |  880 ----------
 drivers/crypto/marvell/cesa/Makefile               |    3 +
 drivers/crypto/marvell/cesa/cesa.c                 |  615 +++++++
 drivers/crypto/marvell/cesa/cesa.h                 |  881 ++++++++++
 drivers/crypto/marvell/cesa/cipher.c               |  801 +++++++++
 drivers/crypto/marvell/cesa/hash.c                 | 1448 ++++++++++++++++
 drivers/crypto/marvell/cesa/tdma.c                 |  352 ++++
 drivers/crypto/marvell/cipher.c                    |  798 ---------
 drivers/crypto/marvell/hash.c                      | 1442 ----------------
 drivers/crypto/marvell/octeontx/Makefile           |    6 +
 drivers/crypto/marvell/octeontx/otx_cpt_common.h   |   51 +
 drivers/crypto/marvell/octeontx/otx_cpt_hw_types.h |  824 +++++++++
 drivers/crypto/marvell/octeontx/otx_cptpf.h        |   34 +
 drivers/crypto/marvell/octeontx/otx_cptpf_main.c   |  307 ++++
 drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c   |  253 +++
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  | 1686 +++++++++++++++++++
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h  |  180 ++
 drivers/crypto/marvell/octeontx/otx_cptvf.h        |  104 ++
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   | 1744 ++++++++++++++++++++
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h   |  188 +++
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c   |  985 +++++++++++
 drivers/crypto/marvell/octeontx/otx_cptvf_mbox.c   |  247 +++
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c |  612 +++++++
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h |  227 +++
 drivers/crypto/marvell/tdma.c                      |  350 ----
 31 files changed, 11592 insertions(+), 4103 deletions(-)
 create mode 100644 drivers/crypto/marvell/Kconfig
 delete mode 100644 drivers/crypto/marvell/cesa.c
 delete mode 100644 drivers/crypto/marvell/cesa.h
 create mode 100644 drivers/crypto/marvell/cesa/Makefile
 create mode 100644 drivers/crypto/marvell/cesa/cesa.c
 create mode 100644 drivers/crypto/marvell/cesa/cesa.h
 create mode 100644 drivers/crypto/marvell/cesa/cipher.c
 create mode 100644 drivers/crypto/marvell/cesa/hash.c
 create mode 100644 drivers/crypto/marvell/cesa/tdma.c
 delete mode 100644 drivers/crypto/marvell/cipher.c
 delete mode 100644 drivers/crypto/marvell/hash.c
 create mode 100644 drivers/crypto/marvell/octeontx/Makefile
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cpt_common.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cpt_hw_types.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h
 delete mode 100644 drivers/crypto/marvell/tdma.c

-- 
1.9.1

