Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE07C10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A130C217D9
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554878928;
	bh=S9mnIkgMExDgyhhQ2nejQlv8QrBJR2QQPp+ghFYdNjo=;
	h=From:To:Subject:Date:List-ID:From;
	b=g7pYSy0X+e18Qo75YohqOSx23ODijt56W+PO1hyCAF2RuuVOlU10HCaXjmp3euXFP
	 4Os6+Dwv5JL9/tD5wIHFTveBsmZuybEbJaFGYVqq5OkAFSnX6iGPRxf6Yi4nz4HQ77
	 zVr2pyktQwh45TwmWeeL05OoMEjyXDcMU+HDuwqc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfDJGsr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728695AbfDJGsq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 02:48:46 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DC2D2083E
        for <linux-crypto@vger.kernel.org>; Wed, 10 Apr 2019 06:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554878926;
        bh=S9mnIkgMExDgyhhQ2nejQlv8QrBJR2QQPp+ghFYdNjo=;
        h=From:To:Subject:Date:From;
        b=h97u6DfiZ1TzIkcYPGUeLkBjAhoBz//Mkh8LIYf7rIh+ue6jDlnstRKJPi3Iar+qe
         gshXgGIIew8lBnEdDeCK0zcsxqes45Xwi7j/FisvMawKh3jvxy5RTODPk5hnX5sbCr
         HiDXCLAERiPKGOzoMRC9qLpZyCUt+faaQxcTdLRE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/7] crypto: fixes in preparation of new fuzz tests
Date:   Tue,  9 Apr 2019 23:46:28 -0700
Message-Id: <20190410064635.11813-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series contains the remaining fixes in preparation of the
comparison fuzz tests I've proposed in the series
"crypto: fuzz algorithms against their generic implementation".

I will send a new version of the testmgr patches separately.

These fixes and my latest tests can also be retrieved from git at:

	Repository: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
	Branch: cryptofuzz-vs-generic

Eric Biggers (7):
  crypto: lrw - don't access already-freed walk.iv
  crypto: salsa20 - don't access already-freed walk.iv
  crypto: arm/aes-neonbs - don't access already-freed walk.iv
  crypto: arm64/aes-neonbs - don't access already-freed walk.iv
  crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
  crypto: ccm - fix incompatibility between "ccm" and "ccm_base"
  crypto: vmx - return correct error code on failed setkey

 arch/arm/crypto/aes-neonbs-glue.c   |  2 ++
 arch/arm64/crypto/aes-neonbs-glue.c |  2 ++
 crypto/ccm.c                        | 43 ++++++++++++-----------------
 crypto/gcm.c                        | 32 ++++++---------------
 crypto/lrw.c                        |  4 ++-
 crypto/salsa20_generic.c            |  2 +-
 drivers/crypto/vmx/aes.c            |  7 +++--
 drivers/crypto/vmx/aes_cbc.c        |  7 +++--
 drivers/crypto/vmx/aes_ctr.c        |  5 ++--
 drivers/crypto/vmx/aes_xts.c        |  9 +++---
 10 files changed, 50 insertions(+), 63 deletions(-)

-- 
2.21.0

