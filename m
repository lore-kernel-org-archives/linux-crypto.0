Return-Path: <SRS0=1tzS=TR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E7BC04AB4
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 09:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF8B22082E
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 09:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfEQJ3R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 May 2019 05:29:17 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46015 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbfEQJ3R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 May 2019 05:29:17 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hRZAp-00056S-Q5; Fri, 17 May 2019 11:29:07 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1hRZAp-0004FF-14; Fri, 17 May 2019 11:29:07 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 0/3] crypto: CAAM: Print debug messages at debug level
Date:   Fri, 17 May 2019 11:29:02 +0200
Message-Id: <20190517092905.1264-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CAAM driver has most of its debug messages inside #ifdef DEBUG and
then prints them at KERN_ERR level. Do this properly and print the
messages at DEBUG_LEVEL as they are supposed to. With this we can get
rid of a lot of ifdefs in the code.

Sascha

Sascha Hauer (3):
  crypto: caam: remove unused defines
  crypto: caam: print debug messages at debug level
  crypto: caam: print messages in caam_dump_sg at debug level

 drivers/crypto/caam/caamalg.c      | 110 ++++++++---------------
 drivers/crypto/caam/caamalg_desc.c |  71 ++++-----------
 drivers/crypto/caam/caamalg_qi.c   |  38 +++-----
 drivers/crypto/caam/caamalg_qi2.c  |   4 +-
 drivers/crypto/caam/caamhash.c     | 134 +++++++++--------------------
 drivers/crypto/caam/caamrng.c      |  16 ++--
 drivers/crypto/caam/error.c        |   6 +-
 drivers/crypto/caam/error.h        |   2 +-
 drivers/crypto/caam/key_gen.c      |  19 ++--
 drivers/crypto/caam/sg_sw_sec4.h   |   5 +-
 10 files changed, 124 insertions(+), 281 deletions(-)

-- 
2.20.1

