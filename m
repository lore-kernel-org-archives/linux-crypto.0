Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E66C35669
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 03:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE07520828
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 03:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgBXDnJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 23 Feb 2020 22:43:09 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:52746 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgBXDnJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Feb 2020 22:43:09 -0500
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01O3gx6Y015521;
        Sun, 23 Feb 2020 19:43:00 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     vinay.yadav@chelsio.com, manojmalviya@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH Crypto 0/2] Improving the performance of chelsio crypto operations
Date:   Mon, 24 Feb 2020 09:12:31 +0530
Message-Id: <20200224034233.12476-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.25.0.114.g5b0ca87
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

patch 1: Recalculate iv only if it is needed for aes-xts.
patch 2: Use multiple txq/rxq per tfm to process the requests.

Ayush Sawal (2):
  chcr: Recalculate iv only if it is needed
  chcr: Use multiple txq/rxq per tfm to process the requests

 drivers/crypto/chelsio/chcr_algo.c   | 337 +++++++++++++++++----------
 drivers/crypto/chelsio/chcr_core.h   |   1 -
 drivers/crypto/chelsio/chcr_crypto.h |  15 +-
 3 files changed, 227 insertions(+), 126 deletions(-)

-- 
2.25.0.114.g5b0ca87

