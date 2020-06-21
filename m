Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AB7C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 11:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56AEA248D9
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 11:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbgFULUH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 07:20:07 -0400
Received: from foss.arm.com ([217.140.110.172]:58544 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729878AbgFULUH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 07:20:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B51FD6E;
        Sun, 21 Jun 2020 04:20:07 -0700 (PDT)
Received: from e110176-lin.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E23B53F6CF;
        Sun, 21 Jun 2020 04:20:05 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ofir Drang <ofir.drang@arm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 0/3] fixes and update to essiv support
Date:   Sun, 21 Jun 2020 14:19:56 +0300
Message-Id: <20200621112000.31495-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Small fixes and adapt essiv support to the new template format

---
Changes from v1:
- Incorporate coding style fixes suggested by Markus Elfring.

Gilad Ben-Yossef (3):
  crypto: ccree: fix resource leak on error path
  crypto: ccree: adapt ccree essiv support to kcapi
  crypto: ccree: remove unused field

 drivers/crypto/ccree/cc_cipher.c | 149 ++++++++++++++++++++++---------
 1 file changed, 108 insertions(+), 41 deletions(-)

-- 
2.27.0

