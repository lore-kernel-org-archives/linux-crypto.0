Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3802C433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 06:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80FB061465
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 06:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhELGoS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 02:44:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3727 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhELGoQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 02:44:16 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fg4sF11gNzmgKq;
        Wed, 12 May 2021 14:39:45 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 14:42:59 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] crypto: ecdh - register NIST P384
Date:   Wed, 12 May 2021 14:39:59 +0800
Message-ID: <1620801602-49287-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
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

Hui Tang (3):
  crypto: ecdh - fix 'ecdh_init'
  crypto: ecdh - register NIST P384 tfm
  crypto: ecdh - add test suite for NIST P384

 crypto/ecdh.c    | 44 +++++++++++++++++++++++++++++++++++++++-
 crypto/testmgr.c |  7 +++++++
 crypto/testmgr.h | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+), 1 deletion(-)

--
2.8.1

