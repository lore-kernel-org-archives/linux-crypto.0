Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B78C282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 431D2217D4
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170069;
	bh=WBbVCM37JzleLtnPhzTgebvOSvH57a54qOBSUfe5kuM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=W/+wnKA9Q9+MovTlkh2TiwPQZHV4uQ8XlgXZ2XNH28lMQv3DXS0of8DhvnbROs/F+
	 x96mJvwCI70Yl3hbJDmSeEMpNdMZfRT7z/yF12yrwDjdyI3zq++XsuSRvgW/2H3BMc
	 O1HD/bGxIwVf8G9R10guOK4gBG/FtY4bdJa5iAw4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbfAVPO2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbfAVPO2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:14:28 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FDFF20879;
        Tue, 22 Jan 2019 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170067;
        bh=WBbVCM37JzleLtnPhzTgebvOSvH57a54qOBSUfe5kuM=;
        h=From:To:Cc:Subject:Date:From;
        b=LM9SBnHOuwCjsqXunZwSZfVfPKoCYboNBArakzhvLX0RdZ415XVlQzJ3J9MzlGASZ
         r2YS7RqcZy0mgpxIRssW2+520tiL6cMr6wpkOUb8CcKRh8egjmxTX45b4AFTNcIDHe
         qAWPR5Mw7JLBEqbQdhXzqxzMt6qgOtBxU1FUsp6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/7] crypto: cleanup debugfs usage
Date:   Tue, 22 Jan 2019 16:14:15 +0100
Message-Id: <20190122151422.14204-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When calling debugfs code, there is no need to ever check the return
value of the call, as no logic should ever change if a call works
properly or not.  Fix up a bunch of crypto-specific code to not care
about the results of debugfs.

Greg Kroah-Hartman (7):
  crypto: qat: no need to check return value of debugfs_create functions
  crypto: ccrree: no need to check return value of debugfs_create
    functions
  crypto: axis: no need to check return value of debugfs_create
    functions
  crypto: cavium: zip: no need to check return value of debugfs_create
    functions
  crypto: cavium: nitrox: no need to check return value of
    debugfs_create functions
  crypto: ccp: no need to check return value of debugfs_create functions
  crypto: caam: no need to check return value of debugfs_create
    functions

 drivers/crypto/axis/artpec6_crypto.c          |  9 ----
 drivers/crypto/caam/ctrl.c                    | 21 +++-----
 drivers/crypto/caam/intern.h                  |  1 -
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c | 27 ++--------
 drivers/crypto/cavium/nitrox/nitrox_debugfs.h |  5 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c    |  4 +-
 drivers/crypto/cavium/zip/zip_main.c          | 52 ++++---------------
 drivers/crypto/ccp/ccp-debugfs.c              | 36 +++----------
 drivers/crypto/ccree/cc_debugfs.c             | 22 ++------
 drivers/crypto/ccree/cc_debugfs.h             |  8 +--
 drivers/crypto/ccree/cc_driver.c              |  7 +--
 drivers/crypto/qat/qat_c3xxx/adf_drv.c        |  5 --
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |  5 --
 drivers/crypto/qat/qat_c62x/adf_drv.c         |  5 --
 drivers/crypto/qat/qat_c62xvf/adf_drv.c       |  5 --
 drivers/crypto/qat/qat_common/adf_cfg.c       |  7 ---
 drivers/crypto/qat/qat_common/adf_transport.c |  6 ---
 .../qat/qat_common/adf_transport_debug.c      | 15 ------
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |  5 --
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |  5 --
 20 files changed, 38 insertions(+), 212 deletions(-)

-- 
2.20.1

