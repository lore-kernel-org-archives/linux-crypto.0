From: gcherianv@gmail.com
Subject: [PATCH 0/3] Add Support for Cavium Cryptographic Accelerarion Unit
Date: Fri, 18 Nov 2016 15:00:06 +0000
Message-ID: <1479481209-11475-1-git-send-email-gcherianv@gmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        George Cherian <george.cherian@cavium.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36588 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753156AbcKRPAY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2016 10:00:24 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: George Cherian <george.cherian@cavium.com>

This series adds the support for Cavium Cryptographic Accelerarion Unit (CPT)
CPT is available in Octeon-Tx SoC series.

George Cherian (3):
  drivers: crypto: Add Support for Octeon-tx CPT Engine
  drivers: crypto: Add the Virtual Function driver for CPT
  drivers: crypto: Enable CPT options crypto for build

 drivers/crypto/Kconfig                       |    1 +
 drivers/crypto/Makefile                      |    1 +
 drivers/crypto/cavium/cpt/Kconfig            |   32 +
 drivers/crypto/cavium/cpt/Makefile           |    4 +
 drivers/crypto/cavium/cpt/cpt.h              |   90 +++
 drivers/crypto/cavium/cpt/cpt_common.h       |  377 ++++++++++
 drivers/crypto/cavium/cpt/cpt_hw_types.h     |  940 +++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cpt_main.c         |  891 ++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cpt_pf_mbox.c      |  174 +++++
 drivers/crypto/cavium/cpt/cptvf.h            |  255 +++++++
 drivers/crypto/cavium/cpt/cptvf_algs.c       |  446 +++++++++++
 drivers/crypto/cavium/cpt/cptvf_algs.h       |  159 ++++
 drivers/crypto/cavium/cpt/cptvf_main.c       | 1038 ++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptvf_mbox.c       |  208 ++++++
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c |  655 ++++++++++++++++
 drivers/crypto/cavium/cpt/request_manager.h  |  221 ++++++
 16 files changed, 5492 insertions(+)
 create mode 100644 drivers/crypto/cavium/cpt/Kconfig
 create mode 100644 drivers/crypto/cavium/cpt/Makefile
 create mode 100644 drivers/crypto/cavium/cpt/cpt.h
 create mode 100644 drivers/crypto/cavium/cpt/cpt_common.h
 create mode 100644 drivers/crypto/cavium/cpt/cpt_hw_types.h
 create mode 100644 drivers/crypto/cavium/cpt/cpt_main.c
 create mode 100644 drivers/crypto/cavium/cpt/cpt_pf_mbox.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf.h
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_algs.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_algs.h
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_main.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_mbox.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_reqmanager.c
 create mode 100644 drivers/crypto/cavium/cpt/request_manager.h

-- 
2.1.4
