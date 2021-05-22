Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FE3C4707E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 02:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 739D76138C
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 02:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhEVCtI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 22:49:08 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3473 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhEVCtI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 22:49:08 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fn79d42ZBzCsgg;
        Sat, 22 May 2021 10:44:53 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 10:47:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 10:47:42 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/4] crypto: ecdh - register NIST P384
Date:   Sat, 22 May 2021 10:44:27 +0800
Message-ID: <1621651471-42010-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Register NIST P384 tfm and extend the testmgr with NIST P384 test vectors.

Summary of changes:

* crypto/ecdh.c
  - fix 'ecdh_init' not unregistering NIST P192
  - add ecdh_nist_p384_init_tfm
  - register and unregister P384 tfm

* crypto/testmgr.c
  - add test vector for P384 on vector of tests

* crypto/testmgr.h
  - add test vector params for P384

---
v1 -> v2:
* Add patch#1:
  - Fix ecdh-nist-p192's entry in testmgr.
  - Add a comment for registering ecdh-nist-p192.

v2 - > v3:
* Fix patch#1 subject format.
---

Hui Tang (4):
  crypto: ecdh - fix ecdh-nist-p192's entry in testmgr
  crypto: ecdh - fix 'ecdh_init'
  crypto: ecdh - register NIST P384 tfm
  crypto: ecdh - add test suite for NIST P384

 crypto/ecdh.c    | 45 +++++++++++++++++++++++++++++++++++++++-
 crypto/testmgr.c | 10 ++++++---
 crypto/testmgr.h | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 112 insertions(+), 6 deletions(-)

--
2.8.1

