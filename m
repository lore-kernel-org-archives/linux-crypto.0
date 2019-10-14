Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453CFECE58D
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 09:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2816B20882
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 09:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbfJNJRp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 05:17:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:41102 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730797AbfJNJRo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 05:17:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B41D4B974;
        Mon, 14 Oct 2019 09:17:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CA99DDA7E3; Mon, 14 Oct 2019 11:16:48 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@google.com, ard.biesheuvel@linaro.org,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 0/2]  BLAKE2b generic implementation
Date:   Mon, 14 Oct 2019 11:16:42 +0200
Message-Id: <cover.1571043883.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The patchset adds blake2b refrerence implementation and test vectors.

V5:

- removed return 0 and switched to void in blake2 functions
- reordered shash_alg definition so that .base.* are first (this seems
  to be the preferred ordering from what I saw in recent patches in the
  mailinglist)
- added note to blake2b_generic.c about changes made for kernel
  inclusion
- test vectors reworked so that key length and input length are
  distributed over all digest sizes

Tested on x86_64 with KASAN and SLUB_DEBUG.

V1: https://lore.kernel.org/linux-crypto/cover.1569849051.git.dsterba@suse.com/
V2: https://lore.kernel.org/linux-crypto/e31c2030fcfa7f409b2c81adf8f179a8a55a584a.1570184333.git.dsterba@suse.com/
V3: https://lore.kernel.org/linux-crypto/e7f46def436c2c705c0b2cac3324f817efa4717d.1570715842.git.dsterba@suse.com/
V4: https://lore.kernel.org/linux-crypto/cover.1570812094.git.dsterba@suse.com/

David Sterba (2):
  crypto: add blake2b generic implementation
  crypto: add test vectors for blake2b

 crypto/Kconfig           |  17 +
 crypto/Makefile          |   1 +
 crypto/blake2b_generic.c | 413 ++++++++++++++++++++++
 crypto/testmgr.c         |  28 ++
 crypto/testmgr.h         | 719 +++++++++++++++++++++++++++++++++++++++
 include/crypto/blake2b.h |  46 +++
 6 files changed, 1224 insertions(+)
 create mode 100644 crypto/blake2b_generic.c
 create mode 100644 include/crypto/blake2b.h

-- 
2.23.0

