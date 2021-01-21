Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827FEC433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 15:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A56F23A23
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 15:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731693AbhAUP5y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731211AbhAUP45 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 10:56:57 -0500
Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc0a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D00C0613ED
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jan 2021 07:55:27 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4DM6Rb0l2mzMqbZ9;
        Thu, 21 Jan 2021 16:55:23 +0100 (CET)
Received: from localhost (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4DM6RY3TkSzlppyk;
        Thu, 21 Jan 2021 16:55:21 +0100 (CET)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <jmorris@namei.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v4 00/10] Enable root to update the blacklist keyring
Date:   Thu, 21 Jan 2021 16:55:03 +0100
Message-Id: <20210121155513.539519-1-mic@digikod.net>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fourth patch series mainly reorder patches and add more
documentation as requested by Jarkko.  This series is based on
v5.11-rc4.

The goal of these patches is to add a new configuration option to enable the
root user to load signed keys in the blacklist keyring.  This keyring is useful
to "untrust" certificates or files.  Enabling to safely update this keyring
without recompiling the kernel makes it more usable.

Previous patch series:
https://lore.kernel.org/lkml/20210114151909.2344974-1-mic@digikod.net/

Regards,

Alex Shi (1):
  certs/blacklist: fix kernel doc interface issue

David Howells (1):
  certs: Fix blacklist flag type confusion

Mickaël Salaün (8):
  tools/certs: Add print-cert-tbs-hash.sh
  certs: Check that builtin blacklist hashes are valid
  certs: Fix blacklisted hexadecimal hash string check
  certs: Replace K{U,G}IDT_INIT() with GLOBAL_ROOT_{U,G}ID
  certs: Make blacklist_vet_description() more strict
  certs: Factor out the blacklist hash creation
  PKCS#7: Fix missing include
  certs: Allow root user to append signed hashes to the blacklist
    keyring

 MAINTAINERS                                   |   2 +
 certs/.gitignore                              |   1 +
 certs/Kconfig                                 |  17 +-
 certs/Makefile                                |  15 +-
 certs/blacklist.c                             | 217 ++++++++++++++----
 certs/system_keyring.c                        |   5 +-
 crypto/asymmetric_keys/x509_public_key.c      |   3 +-
 include/keys/system_keyring.h                 |  14 +-
 include/linux/key.h                           |   1 +
 include/linux/verification.h                  |   2 +
 scripts/check-blacklist-hashes.awk            |  37 +++
 security/integrity/ima/ima_mok.c              |   4 +-
 .../platform_certs/keyring_handler.c          |  26 +--
 security/keys/key.c                           |   2 +
 tools/certs/print-cert-tbs-hash.sh            |  91 ++++++++
 15 files changed, 350 insertions(+), 87 deletions(-)
 create mode 100755 scripts/check-blacklist-hashes.awk
 create mode 100755 tools/certs/print-cert-tbs-hash.sh


base-commit: 19c329f6808995b142b3966301f217c831e7cf31
-- 
2.30.0

