Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3733C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 12:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiDFMXv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 08:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiDFMXA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 08:23:00 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89FCD31BBB6;
        Wed,  6 Apr 2022 01:11:57 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0ACF823A;
        Wed,  6 Apr 2022 01:11:57 -0700 (PDT)
Received: from e122247.kfn.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F8363F718;
        Wed,  6 Apr 2022 01:11:55 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] crypto: ccree: fixes and improvements
Date:   Wed,  6 Apr 2022 11:11:37 +0300
Message-Id: <20220406081139.1963615-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A small fix for a rare registration time and a minor improvment

Gilad Ben-Yossef (2):
  crypto: ccree: rearrange init calls to avoid race
  crypto: ccree: use fine grained DMA mapping dir

 drivers/crypto/ccree/cc_buffer_mgr.c | 27 +++++++++++++++------------
 drivers/crypto/ccree/cc_driver.c     | 24 +++++++++++++-----------
 2 files changed, 28 insertions(+), 23 deletions(-)

-- 
2.25.1

