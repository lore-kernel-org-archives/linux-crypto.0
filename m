Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7F2C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CE022081C
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfE0Ovp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 10:51:45 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:39047 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfE0Ovn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 10:51:43 -0400
X-Originating-IP: 90.88.147.134
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 87BE3FF802;
        Mon, 27 May 2019 14:51:35 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, igall@marvell.com
Subject: [PATCH 00/14] crypto: inside-secure - self-test fixes
Date:   Mon, 27 May 2019 16:50:52 +0200
Message-Id: <20190527145106.8693-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

The crypto runtime self-tests were improved and thanks to this we
spotted new issues within the Inside Secure SafeXcel cryptographic
engine driver:
- Intermediate IV were not retrieved from the hardware nor copied to the
  quest IV buffer for cbc(aes/des).
- HMAC updates wasn't supported.
- We spotted issues with the use of the SG lists.
- There was an issue with the use of result buffers.

The series fixes all those issues, and includes other small changes
found while doing this work.

Thanks!
Antoine

Antoine Tenart (14):
  crypto: inside-secure - remove empty line
  crypto: inside-secure - move comment
  crypto: inside-secure - fix coding style for a condition
  crypto: inside-secure - remove useless check
  crypto: inside-secure - improve the result error format when displayed
  crypto: inside-secure - change returned error when a descriptor
    reports an error
  crypto: inside-secure - enable context reuse
  crypto: inside-secure - unify cache reset
  crypto: inside-secure - fix zeroing of the request in ahash_exit_inv
  crypto: inside-secure - fix queued len computation
  crypto: inside-secure - implement IV retrieval
  crypto: inside-secure - add support for HMAC updates
  crypto: inside-secure - fix use of the SG list
  crypto: inside-secure - do not rely on the hardware last bit for
    result descriptors

 drivers/crypto/inside-secure/safexcel.c       |  13 +-
 drivers/crypto/inside-secure/safexcel.h       |  17 ++-
 .../crypto/inside-secure/safexcel_cipher.c    | 116 +++++++++++-------
 drivers/crypto/inside-secure/safexcel_hash.c  |  92 ++++++++------
 drivers/crypto/inside-secure/safexcel_ring.c  |   3 +
 5 files changed, 157 insertions(+), 84 deletions(-)

-- 
2.21.0

