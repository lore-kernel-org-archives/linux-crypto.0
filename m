Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369C3C4724C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 03:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E21B206C0
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 03:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgEEDOL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 May 2020 23:14:11 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:16825 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgEEDOL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 May 2020 23:14:11 -0400
Received: from beagle7.blr.asicdesigners.com (beagle7.blr.asicdesigners.com [10.193.80.123])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0453Dquu019487;
        Mon, 4 May 2020 20:13:53 -0700
From:   Devulapally Shiva Krishna <shiva@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        secdev@chelsio.com, Devulapally Shiva Krishna <shiva@chelsio.com>
Subject: [PATCH net-next 0/5] Crypto/chcr: Fix issues regarding algorithm implementation in driver
Date:   Tue,  5 May 2020 08:42:52 +0530
Message-Id: <20200505031257.9153-1-shiva@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The following series of patches fixes the issues which came during
self-tests with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.

Patch 1: Fixes gcm(aes) hang issue and rfc4106-gcm encryption issue.
Patch 2: Fixes ctr, cbc, xts and rfc3686-ctr extra test failures.
Patch 3: Fixes ccm(aes) extra test failures.
Patch 4: Added support for 48 byte-key_len in aes_xts.
Patch 5: fix for hmac(sha) extra test failure.

Devulapally Shiva Krishna (5):
  Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests
  Crypto/chcr: fix ctr, cbc, xts and rfc3686-ctr failed tests
  Crypto/chcr: fix for ccm(aes) failed test
  Crypto/chcr: support for 48 byte key_len in aes-xts
  Crypto/chcr: fix for hmac(sha) test fails

 drivers/crypto/chelsio/chcr_algo.c   | 89 +++++++++++++++++++++-------
 drivers/crypto/chelsio/chcr_crypto.h |  1 +
 2 files changed, 68 insertions(+), 22 deletions(-)

-- 
2.18.1

