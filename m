Return-Path: <SRS0=UIra=5S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453C6C43331
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Apr 2020 12:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2066A20757
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Apr 2020 12:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbgDBMfg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Apr 2020 08:35:36 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:41684 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387752AbgDBMfg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Apr 2020 08:35:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0TuQbXI9_1585830904;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TuQbXI9_1585830904)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 02 Apr 2020 20:35:04 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@kernel.org, ebiggers@google.com, pvanleeuwen@rambus.com,
        zohar@linux.ibm.com, gilad@benyossef.com,
        jarkko.sakkinen@linux.intel.com, dmitry.kasatkin@intel.com,
        nicstange@gmail.com, tadeusz.struk@intel.com, jmorris@namei.org,
        serge@hallyn.com, zhang.jia@linux.alibaba.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@linux.alibaba.com
Subject: [PATCH v2 0/7] crpyto: introduce OSCCA certificate and SM2 asymmetric algorithm
Date:   Thu,  2 Apr 2020 20:34:57 +0800
Message-Id: <20200402123504.84628-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello all,

This new module implement the OSCCA certificate and SM2 public key
algorithm. It was published by State Encryption Management Bureau, China.
List of specifications for OSCCA certificate and SM2 elliptic curve
public key cryptography:

* GM/T 0003.1-2012
* GM/T 0003.2-2012
* GM/T 0003.3-2012
* GM/T 0003.4-2012
* GM/T 0003.5-2012
* GM/T 0015-2012
* GM/T 0009-2012 

IETF: https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
oscca: http://www.oscca.gov.cn/sca/xxgk/2010-12/17/content_1002386.shtml
scctc: http://www.gmbz.org.cn/main/bzlb.html

These patchs add the OID object identifier defined by OSCCA. The
x509 certificate supports sm2-with-sm3 type certificate parsing
and verification.

The sm2 algorithm is based on libgcrypt's mpi implementation, and has
made some additions to the kernel's original mpi library, and added the
implementation of ec to better support elliptic curve-like algorithms.

sm2 has good support in both openssl and gnupg projects, and sm3 and sm4
of the OSCCA algorithm family have also been implemented in the kernel.

Among them, sm3 and sm4 have been well implemented in the kernel.
This group of patches has newly introduced sm2. In order to implement
sm2 more perfectly, I expanded the mpi library and introduced the
ec implementation of the mpi library as the basic algorithm. Compared
to the kernel's crypto/ecc.c, the implementation of mpi/ec.c is more
complete and elegant, sm2 is implemented based on these algorithms.

---
v2 changes:
  1. simplify the sm2 algorithm and only retain the verify function
  2. extract the sm2 certificate code into a separate file

Tianjia Zhang (7):
  crypto: sm3 - export crypto_sm3_final function
  lib/mpi: Extend the MPI library
  lib/mpi: Introduce ec implementation to MPI library
  crypto: sm2 - introduce OSCCA SM2 asymmetric cipher algorithm
  crypto: testmgr - support test with different ciphertext per
    encryption
  X.509: support OSCCA certificate parse
  X.509: support OSCCA sm2-with-sm3 certificate verification

 crypto/Kconfig                            |   17 +
 crypto/Makefile                           |    8 +
 crypto/asymmetric_keys/Makefile           |    1 +
 crypto/asymmetric_keys/public_key.c       |    6 +
 crypto/asymmetric_keys/public_key_sm2.c   |   59 +
 crypto/asymmetric_keys/x509_cert_parser.c |   14 +-
 crypto/asymmetric_keys/x509_public_key.c  |    2 +
 crypto/sm2.c                              |  498 +++++++
 crypto/sm2signature.asn1                  |    4 +
 crypto/sm3_generic.c                      |    7 +-
 crypto/testmgr.c                          |    7 +-
 include/crypto/public_key.h               |   14 +
 include/crypto/sm2.h                      |   25 +
 include/crypto/sm3.h                      |    2 +
 include/linux/mpi.h                       |  193 +++
 include/linux/oid_registry.h              |    6 +
 lib/mpi/Makefile                          |    6 +
 lib/mpi/ec.c                              | 1538 +++++++++++++++++++++
 lib/mpi/mpi-add.c                         |  207 +++
 lib/mpi/mpi-bit.c                         |  251 ++++
 lib/mpi/mpi-cmp.c                         |   46 +-
 lib/mpi/mpi-div.c                         |  259 ++++
 lib/mpi/mpi-internal.h                    |   53 +
 lib/mpi/mpi-inv.c                         |  143 ++
 lib/mpi/mpi-mod.c                         |  155 +++
 lib/mpi/mpi-mul.c                         |  166 +++
 lib/mpi/mpicoder.c                        |  336 +++++
 lib/mpi/mpih-div.c                        |  294 ++++
 lib/mpi/mpih-mul.c                        |   25 +
 lib/mpi/mpiutil.c                         |  204 +++
 30 files changed, 4531 insertions(+), 15 deletions(-)
 create mode 100644 crypto/asymmetric_keys/public_key_sm2.c
 create mode 100644 crypto/sm2.c
 create mode 100644 crypto/sm2signature.asn1
 create mode 100644 include/crypto/sm2.h
 create mode 100644 lib/mpi/ec.c
 create mode 100644 lib/mpi/mpi-add.c
 create mode 100644 lib/mpi/mpi-div.c
 create mode 100644 lib/mpi/mpi-inv.c
 create mode 100644 lib/mpi/mpi-mod.c
 create mode 100644 lib/mpi/mpi-mul.c

-- 
2.17.1

