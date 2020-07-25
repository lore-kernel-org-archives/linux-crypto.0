Return-Path: <SRS0=tM/H=BE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C690C433EA
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 03:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1D0D206EB
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 03:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgGYDq7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jul 2020 23:46:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8819 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726981AbgGYDq4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jul 2020 23:46:56 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E8160180ABAB9E4834D3;
        Sat, 25 Jul 2020 11:46:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Sat, 25 Jul 2020 11:46:39 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 00/10] crypto: hisilicon/zip - misc clean up
Date:   Sat, 25 Jul 2020 11:44:33 +0800
Message-ID: <1595648683-50590-1-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset make some clean up:
patch 1:remove useless parameters
patch 4:replace 'sprintf' with 'scnprintf'
patch 7:fix static check warning
and the rest patch fix some coding style

This patchset depends on:
https://patchwork.kernel.org/cover/11680181/

Shukun Tan (1):
  crypto: hisilicon/zip - modify debugfs interface parameters

Yang Shen (9):
  crypto: hisilicon/zip - remove some useless parameters
  crypto: hisilicon/zip - unify naming style for functions and macros
  crypto: hisilicon/zip - replace 'sprintf' with 'scnprintf'
  crypto: hisilicon/zip - use a enum parameter instead of some macros
  crypto: hisilicon/zip - add print for error branch
  crypto: hisilicon/zip - fix static check warning
  crypto: hisilicon/zip - move some private macros from 'zip.h' to
    'zip_crypto.c'
  crypto: hisilicon/zip - supplement some comments
  crypto: hisilicon/zip - fix some coding styles

 drivers/crypto/hisilicon/zip/zip.h        |  15 ----
 drivers/crypto/hisilicon/zip/zip_crypto.c | 126 ++++++++++++++++++++---------
 drivers/crypto/hisilicon/zip/zip_main.c   | 130 ++++++++++++++----------------
 3 files changed, 148 insertions(+), 123 deletions(-)

--
2.7.4

