Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4D7C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 11:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20D8D20870
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 11:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfAWL7w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 06:59:52 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:40642 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfAWL7w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 06:59:52 -0500
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 82EB0182DA;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id CgT_QryoCcu1; Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from boulder02.se.axis.com (boulder02.se.axis.com [10.0.8.16])
        by bastet.se.axis.com (Postfix) with ESMTPS id F23D01848F;
        Wed, 23 Jan 2019 12:59:49 +0100 (CET)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3B931A077;
        Wed, 23 Jan 2019 12:59:49 +0100 (CET)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C88B61A075;
        Wed, 23 Jan 2019 12:59:49 +0100 (CET)
Received: from seth.se.axis.com (unknown [10.0.2.172])
        by boulder02.se.axis.com (Postfix) with ESMTP;
        Wed, 23 Jan 2019 12:59:49 +0100 (CET)
Received: from pc32929-1845.se.axis.com (pc32929-1845.se.axis.com [10.88.129.17])
        by seth.se.axis.com (Postfix) with ESMTP id BCBB71CA2;
        Wed, 23 Jan 2019 12:59:49 +0100 (CET)
Received: by pc32929-1845.se.axis.com (Postfix, from userid 20456)
        id B8C4D409B9; Wed, 23 Jan 2019 12:59:49 +0100 (CET)
From:   Lars Persson <lars.persson@axis.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Lars Persson <larper@axis.com>
Subject: [PATCH 0/7] crypto: axis - fixes for the Artpec SoCs
Date:   Wed, 23 Jan 2019 12:59:39 +0100
Message-Id: <cover.1548243646.git.larper@axis.com>
X-Mailer: git-send-email 2.11.0
X-TM-AS-GCONF: 00
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi

This series brings to mainline fixes done during our product development and
fixes for errors detected by the IPsec testsuite in LTP.

Lars Persson (6):
  crypto: axis - remove sha384 support for artpec7
  crypto: axis - remove sha512 support for artpec7
  crypto: axis - fix for recursive locking from bottom half
  crypto: axis - give DMA the start of the status buffer
  crypto: axis - support variable AEAD tag length
  crypto: axis - use a constant time tag compare

Vincent Whitchurch (1):
  crypto: axis - move request unmap outside of the queue lock

 drivers/crypto/axis/artpec6_crypto.c | 317 ++++++++---------------------------
 1 file changed, 71 insertions(+), 246 deletions(-)

-- 
2.11.0

