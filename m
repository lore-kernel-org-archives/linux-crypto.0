Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9226FC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Mar 2022 17:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242755AbiCKRst (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Mar 2022 12:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344100AbiCKRss (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Mar 2022 12:48:48 -0500
Received: from smtp-bc09.mail.infomaniak.ch (smtp-bc09.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc09])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1AB48324
        for <linux-crypto@vger.kernel.org>; Fri, 11 Mar 2022 09:47:40 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KFYKy5vmNzMppQX;
        Fri, 11 Mar 2022 18:47:34 +0100 (CET)
Received: from localhost (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4KFYKy1GL6zlj4cF;
        Fri, 11 Mar 2022 18:47:34 +0100 (CET)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Snowberg <eric.snowberg@oracle.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        Paul Moore <paul@paul-moore.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] Remove panic() from keyring init calls
Date:   Fri, 11 Mar 2022 18:47:39 +0100
Message-Id: <20220311174741.250424-1-mic@digikod.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As suggested by Jarkko [1], let's remove the panic() calls from the
keyring initializations.  This series applies on top of commit
c9e54f38976a ("integrity: Only use machine keyring when
uefi_check_trust_mok_keys is true"), which also includes 50c486fe3108
("certs: Allow root user to append signed hashes to the blacklist
keyring").

[1] https://lore.kernel.org/r/Yik0C2t7G272YZ73@iki.fi
[2] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/commit/?id=c9e54f38976a1c0ec69c0a6208b3fd55fceb01d1

Regards,

Mickaël Salaün (2):
  certs: Remove panic() calls from blacklist_init()
  certs: Remove panic() calls from system_trusted_keyring_init()

 certs/blacklist.c      | 27 +++++++++++++++++++++------
 certs/system_keyring.c | 26 ++++++++++++++++++++------
 2 files changed, 41 insertions(+), 12 deletions(-)


base-commit: c9e54f38976a1c0ec69c0a6208b3fd55fceb01d1
-- 
2.35.1

