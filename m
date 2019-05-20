Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F12C04AAC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 11:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4A9B20645
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 11:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbfETLuf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 07:50:35 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:43972 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730606AbfETLuf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 07:50:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C50980D;
        Mon, 20 May 2019 04:50:34 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F27B43F5AF;
        Mon, 20 May 2019 04:50:32 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     gregkh@linuxfoundation.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [STABLE PATCH 0/2] crypto: ccree: fixes backport to 4.19
Date:   Mon, 20 May 2019 14:50:22 +0300
Message-Id: <20190520115025.16457-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Backport of upstream fixes to 4.19.y, which also applies to 5.0.y
and 5.1.y.

Gilad Ben-Yossef (2):
  crypto: ccree: zap entire sg on aead request unmap
  crypto: ccree: fix backlog notifications

 drivers/crypto/ccree/cc_aead.c        |  4 ++++
 drivers/crypto/ccree/cc_buffer_mgr.c  | 18 ++---------------
 drivers/crypto/ccree/cc_cipher.c      |  4 ++++
 drivers/crypto/ccree/cc_hash.c        | 28 +++++++++++++++++++--------
 drivers/crypto/ccree/cc_request_mgr.c | 11 ++++++++---
 5 files changed, 38 insertions(+), 27 deletions(-)

-- 
2.21.0

