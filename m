Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E7BC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Mar 2022 17:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350438AbiCKRsz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Mar 2022 12:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347508AbiCKRsu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Mar 2022 12:48:50 -0500
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E1D4C438
        for <linux-crypto@vger.kernel.org>; Fri, 11 Mar 2022 09:47:45 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KFYKz6xSbzMqC3M;
        Fri, 11 Mar 2022 18:47:35 +0100 (CET)
Received: from localhost (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4KFYKz5L1xzlj4bl;
        Fri, 11 Mar 2022 18:47:35 +0100 (CET)
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
Subject: [PATCH v1 2/2] certs: Remove panic() calls from system_trusted_keyring_init()
Date:   Fri, 11 Mar 2022 18:47:41 +0100
Message-Id: <20220311174741.250424-3-mic@digikod.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311174741.250424-1-mic@digikod.net>
References: <20220311174741.250424-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Mickaël Salaün <mic@linux.microsoft.com>

Replace panic() calls from device_initcall(system_trusted_keyring_init)
with proper error handling using -ENODEV.

Suggested-by: Jarkko Sakkinen <jarkko@kernel.org> [1]
Link: https://lore.kernel.org/r/Yik0C2t7G272YZ73@iki.fi [1]
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Link: https://lore.kernel.org/r/20220311174741.250424-3-mic@digikod.net
---
 certs/system_keyring.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index 05b66ce9d1c9..428046a7aa7f 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -148,8 +148,10 @@ static __init int system_trusted_keyring_init(void)
 			      KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH),
 			      KEY_ALLOC_NOT_IN_QUOTA,
 			      NULL, NULL);
-	if (IS_ERR(builtin_trusted_keys))
-		panic("Can't allocate builtin trusted keyring\n");
+	if (IS_ERR(builtin_trusted_keys)) {
+		pr_err("Can't allocate builtin trusted keyring\n");
+		return -ENODEV;
+	}
 
 #ifdef CONFIG_SECONDARY_TRUSTED_KEYRING
 	secondary_trusted_keys =
@@ -161,14 +163,26 @@ static __init int system_trusted_keyring_init(void)
 			      KEY_ALLOC_NOT_IN_QUOTA,
 			      get_builtin_and_secondary_restriction(),
 			      NULL);
-	if (IS_ERR(secondary_trusted_keys))
-		panic("Can't allocate secondary trusted keyring\n");
+	if (IS_ERR(secondary_trusted_keys)) {
+		pr_err("Can't allocate secondary trusted keyring\n");
+		goto err_secondary;
+	}
 
-	if (key_link(secondary_trusted_keys, builtin_trusted_keys) < 0)
-		panic("Can't link trusted keyrings\n");
+	if (key_link(secondary_trusted_keys, builtin_trusted_keys) < 0) {
+		pr_err("Can't link trusted keyrings\n");
+		goto err_link;
+	}
 #endif
 
 	return 0;
+
+err_link:
+	key_put(secondary_trusted_keys);
+
+err_secondary:
+	key_put(builtin_trusted_keys);
+
+	return -ENODEV;
 }
 
 /*
-- 
2.35.1

