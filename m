Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F22C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 06:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E804207FC
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 06:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgHEGXO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 02:23:14 -0400
Received: from foss.arm.com ([217.140.110.172]:54332 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHEGXO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 02:23:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF691D6E;
        Tue,  4 Aug 2020 23:23:13 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE3A43F718;
        Tue,  4 Aug 2020 23:23:11 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Remove none supported ciphers
Date:   Wed,  5 Aug 2020 09:22:59 +0300
Message-Id: <20200805062302.16569-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

the CryptoCell HW has support for ciphers and modes not supported
and used at this time by Linux. Remove the code supporting this
in the ccree ddriver until such time support is added in the kernel.

Gilad Ben-Yossef (2):
  crypto: ccree: remove data unit size support
  crypto: ccree: remove bitlocker cipher

 drivers/crypto/ccree/cc_cipher.c     | 282 +--------------------------
 drivers/crypto/ccree/cc_crypto_ctx.h |   1 -
 drivers/crypto/ccree/cc_driver.h     |   1 -
 3 files changed, 4 insertions(+), 280 deletions(-)

-- 
2.27.0

