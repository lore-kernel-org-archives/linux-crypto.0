Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93EDC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 08:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B677120674
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 08:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfK0ItU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 03:49:20 -0500
Received: from foss.arm.com ([217.140.110.172]:44536 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfK0ItU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 03:49:20 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9AACF31B;
        Wed, 27 Nov 2019 00:49:18 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.153])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BE173F52E;
        Wed, 27 Nov 2019 00:49:17 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] crypto: ccree: fixes
Date:   Wed, 27 Nov 2019 10:49:04 +0200
Message-Id: <20191127084909.14472-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Assorted fixes for the ccree driver

Gilad Ben-Yossef (2):
  crypto: ccree: remove useless define
  crypto: ccree: fix backlog memory leak

Hadar Gat (2):
  crypto: ccree: fix typos in comments
  crypto: ccree: fix typos in error msgs

 drivers/crypto/ccree/cc_driver.c      |  8 ++++----
 drivers/crypto/ccree/cc_driver.h      |  1 -
 drivers/crypto/ccree/cc_fips.c        |  2 +-
 drivers/crypto/ccree/cc_hash.c        |  2 --
 drivers/crypto/ccree/cc_pm.c          |  2 +-
 drivers/crypto/ccree/cc_request_mgr.c | 13 +++++++------
 6 files changed, 13 insertions(+), 15 deletions(-)

-- 
2.23.0

