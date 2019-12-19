Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3FDC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 10:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1791C24650
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 10:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfLSKwc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 05:52:32 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:7101 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfLSKwc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 05:52:32 -0500
Received: from cyclone.blr.asicdesigners.com (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBJAqL21010899;
        Thu, 19 Dec 2019 02:52:23 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 0/2] chelsio/chtls
Date:   Thu, 19 Dec 2019 16:21:46 +0530
Message-Id: <20191219105148.32456-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series of patches address two issues in chtls.
patch 1 add support for AES256-GCM based ciphers.
patch 2 fixes memory leak issues.

Thanks,
Vinay

Vinay Kumar Yadav (2):
  chtls: Add support for AES256-GCM based ciphers
  chtls: Fixed memory leak

 drivers/crypto/chelsio/chtls/chtls.h      |  7 ++-
 drivers/crypto/chelsio/chtls/chtls_cm.c   | 27 +++++-----
 drivers/crypto/chelsio/chtls/chtls_cm.h   | 21 ++++++++
 drivers/crypto/chelsio/chtls/chtls_hw.c   | 65 ++++++++++++++++-------
 drivers/crypto/chelsio/chtls/chtls_main.c | 23 +++++++-
 5 files changed, 109 insertions(+), 34 deletions(-)

-- 
2.18.1

