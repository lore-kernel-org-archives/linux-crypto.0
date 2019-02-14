Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4042EC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05704222D8
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550131458;
	bh=moQ2YEXGnL708aGue1qK8/S0ewdL+gljMhPwsmCfesw=;
	h=From:To:Subject:Date:List-ID:From;
	b=yFz1jlqGiHHzr4ynegM1PSJ1yWANEVYH472xjdmMHqcf7ZEVydOfP+lsHwLi8sN5O
	 KTdHo8d6yM7uGG0Tvv6mGBjkNqQBpZmRyTLZNdy7EDt1IEEv4AAqGm+nt7I25aOOpa
	 zUv8u5FC1o3wxUqU1VuYocbmowB4ne6YI5CQSPAI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391942AbfBNIER (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388779AbfBNIER (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 03:04:17 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5B4E222A1;
        Thu, 14 Feb 2019 08:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550131456;
        bh=moQ2YEXGnL708aGue1qK8/S0ewdL+gljMhPwsmCfesw=;
        h=From:To:Subject:Date:From;
        b=THqZpbUj73QQFi/caPUOczE+hO1fONWzl8+nQg3swHMbhsg5gKWv0AEI3Xg9Sd2qj
         Y1Ad7l1zfaq443a+pMKsTEobNLurdwYjoQK+1ze11Icfg8m4sorLXFZ3x7oCOjhMnH
         niT8MXCm/gdAjC4HZbQJBQjeUoaDuqV0fd9QNOtE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/6] crypto: test that CBC and CTR update the IV
Date:   Thu, 14 Feb 2019 00:03:49 -0800
Message-Id: <20190214080355.8112-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

This series makes the crypto self-tests test that all CBC and CTR
implementations update req->iv to contain the IV for the next block.
This apparently has been a requirement for a long time, but it wasn't
actually tested for.

With this series applied, all self-tests pass on x86_64, arm32, and
arm64.  But I'm not able to test hardware drivers, so possibly some of
them will fail and still need to be fixed.

Eric Biggers (6):
  crypto: testmgr - remove extra bytes from 3DES-CTR IVs
  crypto: testmgr - support checking skcipher output IV
  crypto: testmgr - add iv_out to all CBC test vectors
  crypto: testmgr - add iv_out to all CTR test vectors
  crypto: arm64/aes-blk - update IV after partial final CTR block
  crypto: arm/aes-ce - update IV after partial final CTR block

 arch/arm/crypto/aes-ce-core.S |  26 ++++----
 arch/arm64/crypto/aes-modes.S |   3 +-
 crypto/testmgr.c              |   6 +-
 crypto/testmgr.h              | 111 +++++++++++++++++++++++++++++++---
 4 files changed, 120 insertions(+), 26 deletions(-)

-- 
2.20.1

