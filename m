Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A987C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 17:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53B39206B6
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600278398;
	bh=lEy53FAW74XKdD238kz0oDFe+5SsKgxIOtG93jT5F/s=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=E35qoTyv+i3HMJ8oZ+ezzTjkge72QTzBa5nZQspdS4lf3nuDk3/OwnpYrLNTuEULc
	 RXe3u+0uQcaz0g+MUdhIp3Th0NX7T/fTuC577qAgCsAEDE0tJxTJvp5jMSGtoqSIsC
	 DXc7F5yQcMHj9Qenrjfbx4qgSdTnFtgqI/qXkOWM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgIPRq2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 13:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbgIPRqT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 13:46:19 -0400
Received: from e123331-lin.nice.arm.com (adsl-245.46.190.88.tellas.gr [46.190.88.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B00772083B;
        Wed, 16 Sep 2020 12:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600259811;
        bh=lEy53FAW74XKdD238kz0oDFe+5SsKgxIOtG93jT5F/s=;
        h=From:To:Cc:Subject:Date:From;
        b=hi0Wq3Aalk1NKBkdO9XQE1dAC/Hly5t5zvTqqf/C7t19BsxNu8QN0SgiMtxV8s6f6
         kvzz6O7nDPe2/WIkEv+AupBq8LvuA8iLEgPRKU5fBBpTxFAQsyn6QvG26CUIU/ypWl
         mj0obsTCzAQ1wYrayjte/pYsNAAg/Wu0TPxdrz2I=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/3] crypto: arm/aes-neonbs - some polish
Date:   Wed, 16 Sep 2020 15:36:39 +0300
Message-Id: <20200916123642.20805-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some polish for the ARM bit-sliced NEON implementation. No functional
or performance changes anticipated.

Ard Biesheuvel (3):
  crypto: arm/aes-neonbs - avoid hacks to prevent Thumb2 mode switches
  crypto: arm/aes-neonbs - avoid loading reorder argument on encryption
  crypto: arm/aes-neonbs - use typed init/exit routines for XTS

 arch/arm/crypto/aes-neonbs-core.S | 54 +++++++++-----------
 arch/arm/crypto/aes-neonbs-glue.c | 12 ++---
 2 files changed, 31 insertions(+), 35 deletions(-)

-- 
2.17.1

