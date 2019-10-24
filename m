Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD479CA9EAF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 16:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B44E320659
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 16:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409799AbfJXQ2X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:28:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:45494 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405586AbfJXQ2X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 12:28:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D553BAC0C;
        Thu, 24 Oct 2019 16:28:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AB83DDA733; Thu, 24 Oct 2019 18:28:33 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     ard.biesheuvel@linaro.org, ebiggers@kernel.org,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v7 0/2]  BLAKE2b generic implementation
Date:   Thu, 24 Oct 2019 18:28:30 +0200
Message-Id: <cover.1571934170.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The patchset adds blake2b reference implementation and test vectors.

V7:

Contents of include/crypto/blake2b.h moved to blake2b_generic.c, as the
exported constants or structures are not needed by anything as for now.

V1: https://lore.kernel.org/linux-crypto/cover.1569849051.git.dsterba@suse.com/
V2: https://lore.kernel.org/linux-crypto/e31c2030fcfa7f409b2c81adf8f179a8a55a584a.1570184333.git.dsterba@suse.com/
V3: https://lore.kernel.org/linux-crypto/e7f46def436c2c705c0b2cac3324f817efa4717d.1570715842.git.dsterba@suse.com/
V4: https://lore.kernel.org/linux-crypto/cover.1570812094.git.dsterba@suse.com/
V5: https://lore.kernel.org/linux-crypto/cover.1571043883.git.dsterba@suse.com/
V6: https://lore.kernel.org/linux-crypto/cover.1571788861.git.dsterba@suse.com/

David Sterba (2):
  crypto: add blake2b generic implementation
  crypto: add test vectors for blake2b

 crypto/Kconfig           |  17 ++
 crypto/Makefile          |   1 +
 crypto/blake2b_generic.c | 435 +++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c         |  28 +++
 crypto/testmgr.h         | 307 +++++++++++++++++++++++++++
 5 files changed, 788 insertions(+)
 create mode 100644 crypto/blake2b_generic.c

-- 
2.23.0

