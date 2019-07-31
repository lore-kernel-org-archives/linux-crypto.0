Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D661C32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 13:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B7A6206B8
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 13:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbfGaNGG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 09:06:06 -0400
Received: from inva021.nxp.com ([92.121.34.21]:41186 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387604AbfGaNGG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 09:06:06 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6432F200A0C;
        Wed, 31 Jul 2019 15:06:04 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 574B82009FA;
        Wed, 31 Jul 2019 15:06:04 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0D579205F3;
        Wed, 31 Jul 2019 15:06:04 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v3 0/2] crypto: validate inputs for gcm and aes
Date:   Wed, 31 Jul 2019 16:05:53 +0300
Message-Id: <1564578355-9639-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added inline helper functions to check authsize and assoclen for
gcm, rfc4106 and rfc4543.  
Added, also, inline helper function to check key length for AES algorithms.
These are used in the generic implementation of gcm/rfc4106/rfc4543
and aes.

Changes since v2:
- rename aes helper functions without crypto_ prefix;
- change include for gcm.h.

Iuliana Prodan (2):
  crypto: gcm - helper functions for assoclen/authsize check
  crypto: aes - helper function to validate key length for AES
    algorithms

 crypto/gcm.c         | 41 ++++++++++++++-------------------------
 include/crypto/aes.h | 17 ++++++++++++++++
 include/crypto/gcm.h | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/crypto/aes.c     |  8 ++++----
 4 files changed, 91 insertions(+), 30 deletions(-)

-- 
2.1.0

