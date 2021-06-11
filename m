Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF104C48BE8
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B99B9613C8
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhFKJJS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 05:09:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4033 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhFKJJI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 05:09:08 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1Zbq2DwqzWsnD;
        Fri, 11 Jun 2021 17:02:15 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 17:07:08 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 17:07:08 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 0/8] crypto: hisilicon - supports to configure function's QoS for ACC
Date:   Fri, 11 Jun 2021 17:06:42 +0800
Message-ID: <1623402410-63906-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Based on the Token bucket algorithm. The QM can limit the throughput
of functions in Kunpeng930. By the device debugfs node that named
"alg_qos", the ACC driver supports to configue each function's QoS
in the host. Based on the communication between pf and vf, the driver
supports reading each function's QoS in the host and VM also by the
debugfs node.

Kai Ye (8):
  crypto: hisilicon/qm - supports writing QoS int the Host
  crypto: hisilicon/qm - add the "alg_qos" file node
  crypto: hisilicon/qm - merges the work initialization process into a
    single function
  crypto: hisilicon/qm - add pf ping single vf function
  crypto: hisilicon/qm - supports to inquiry each function's QoS
  crypto: hisilicon/sec - adds the max shaper type rate
  crypto: hisilicon/hpre - adds the max shaper type rate
  crypto: hisilicon/zip - adds the max shaper type rate

 drivers/crypto/hisilicon/hpre/hpre_main.c |   7 +
 drivers/crypto/hisilicon/qm.c             | 909 +++++++++++++++++++++++-------
 drivers/crypto/hisilicon/qm.h             |  14 +
 drivers/crypto/hisilicon/sec2/sec_main.c  |   7 +
 drivers/crypto/hisilicon/zip/zip_main.c   |  11 +
 5 files changed, 757 insertions(+), 191 deletions(-)

-- 
2.7.4

