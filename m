Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EABEC3F2D1
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 22:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B2B120716
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 22:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583361878;
	bh=apYSsJJG78Y3YFtApoHfeNi6qGd3fX0M/ZHQZdEkeW4=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=GeViHen/G4wse8EIPLF/3pHHWGZ/KYVpbjzd368XP0NQrfSslM5qyybwu/XESvj/2
	 8cx93osADnJE+6olfCymMB83jhAQBGuRmed/8BJp7QtVusgUEvFkEiqqg1qEmvTNlS
	 B2xvH/HDJquIYcz5bbeYuMeCmZd3y75yRn8A9Kxg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388389AbgCDWoh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 17:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387931AbgCDWoh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 17:44:37 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0639820716;
        Wed,  4 Mar 2020 22:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583361877;
        bh=apYSsJJG78Y3YFtApoHfeNi6qGd3fX0M/ZHQZdEkeW4=;
        h=From:To:Cc:Subject:Date:From;
        b=pHSftGN6Hb15b0GhxAoI1U3+N/UWV6FQfK0PsbWkOnx1oWpUb1ENYPAY9DTsGwgzb
         jtAAxzQTI9F0pqPr4EHuy2dQHho0b7Fo6Mzx0824KSMqt71W+FTxZC1L9gvtMOZrib
         uq5qANfeVJ4050mQ3JLGVsDYcBDJN7GrcaG84nXk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/3] crypto: AEAD fuzz tests and doc improvement
Date:   Wed,  4 Mar 2020 14:44:02 -0800
Message-Id: <20200304224405.152829-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

- Make the AEAD fuzz tests avoid implementation-defined behavior for
  rfc4106, rfc4309, rfc4543, and rfc7539esp.  This replaces
  "[PATCH v2] crypto: testmgr - sync both RFC4106 IV copies"

- Adjust the order of the AEAD fuzz tests to be more logical.

- Improve the documentation for the AEAD scatterlist layout.

(I was also going to add a patch that makes the inauthentic AEAD tests
start mutating the IVs, but it turns out that "ccm" needs special
handling so I've left that for later.)

Eric Biggers (3):
  crypto: testmgr - use consistent IV copies for AEADs that need it
  crypto: testmgr - do comparison tests before inauthentic input tests
  crypto: aead - improve documentation for scatterlist layout

 crypto/testmgr.c      | 28 +++++++++++++++----------
 include/crypto/aead.h | 48 ++++++++++++++++++++++++-------------------
 2 files changed, 44 insertions(+), 32 deletions(-)

-- 
2.25.1

