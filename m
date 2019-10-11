Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D10ECE58C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 16:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 039BE206CD
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 16:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfJKQwC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 12:52:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:35116 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726728AbfJKQwC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 12:52:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A2743B2AE;
        Fri, 11 Oct 2019 16:52:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C74AADA808; Fri, 11 Oct 2019 18:52:13 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     ard.biesheuvel@linaro.org, ebiggers@google.com,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 0/5] BLAKE2b generic implementation
Date:   Fri, 11 Oct 2019 18:52:03 +0200
Message-Id: <cover.1570812094.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The patchset adds blake2b refrerence implementation and test vectors.

V4:

Code changes:

- removed .finup
- removed .cra_init
- dropped redundant sanity checks (key length, output size length)
- switch blake2b_param from a 1 element array to plain struct
- direct assignment in blake2b_init, instead of put_unaligned*
- removed blake2b_is_lastblock
- removed useless error cases in the blake * helpers
- replace digest_desc_ctx with blake2b_state
- use __le32 in blake2b_param

Added testmgr vectors:

- all digests covered: 160, 256, 384, 512
- 4 different keys:
  - empty
  - short (1 byte, 'B', 0x42)
  - half of the default key (32 bytes, sequence 00..1f)
  - default key (64 bytes, sequence 00..3f)
- plaintext values:
  - subsequences of 0..15 and 247..255
  - the full range 0..255 add up to 4MiB of .h, for all digests and key
    sizes, so this is not very practical for the in-kernel testsuite
- official blake2 provided test vectors are only for empty and default key for
  digest size 512
- the remaining combinations were obtained from b2sum utility (enhanced to
  accept a key)

Testing performed:

- compiled with SLUB_DEBUG and KASAN, plus crypto selftests
  CONFIG_CRYPTO_MANAGER2=y
  CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n
  CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
- module loaded, no errors reported from the tessuite
- (un)intentionally broken test values were detected

The test values were produced by b2sum, compiled from the reference
implementation. The generated values were cross-checked by pyblake2
based script (ie. not the same sources, built by distro).

The .h portion of testmgr is completely generated, so in case somebody feels
like reducing it in size, adding more keys, changing the formatting, it's easy
to do.

In case the patches don't make it to the mailinglist, it's in git

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/blake2b-v4

V1: https://lore.kernel.org/linux-crypto/cover.1569849051.git.dsterba@suse.com/
V2: https://lore.kernel.org/linux-crypto/e31c2030fcfa7f409b2c81adf8f179a8a55a584a.1570184333.git.dsterba@suse.com/
V3: https://lore.kernel.org/linux-crypto/e7f46def436c2c705c0b2cac3324f817efa4717d.1570715842.git.dsterba@suse.com/

David Sterba (5):
  crypto: add blake2b generic implementation
  crypto: add test vectors for blake2b-160
  crypto: add test vectors for blake2b-256
  crypto: add test vectors for blake2b-384
  crypto: add test vectors for blake2b-512

 crypto/Kconfig           |    17 +
 crypto/Makefile          |     1 +
 crypto/blake2b_generic.c |   418 ++
 crypto/testmgr.c         |    28 +
 crypto/testmgr.h         | 10561 +++++++++++++++++++++++++++++++++++++
 include/crypto/blake2b.h |    48 +
 6 files changed, 11073 insertions(+)
 create mode 100644 crypto/blake2b_generic.c
 create mode 100644 include/crypto/blake2b.h

-- 
2.23.0

