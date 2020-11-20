Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA059C63798
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 18:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3D42415A
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 18:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgKTSLM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:11:12 -0500
Received: from smtp-190b.mail.infomaniak.ch ([185.125.25.11]:56133 "EHLO
        smtp-190b.mail.infomaniak.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729262AbgKTSLM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 13:11:12 -0500
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Cd4FG4VwpzlhGW4;
        Fri, 20 Nov 2020 19:04:34 +0100 (CET)
Received: from localhost (unknown [94.23.54.103])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Cd4FG2R9Dzlh8T9;
        Fri, 20 Nov 2020 19:04:34 +0100 (CET)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Serge E . Hallyn" <serge@hallyn.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v1 1/9] certs: Fix blacklisted hexadecimal hash string check
Date:   Fri, 20 Nov 2020 19:04:18 +0100
Message-Id: <20201120180426.922572-2-mic@digikod.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120180426.922572-1-mic@digikod.net>
References: <20201120180426.922572-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Mickaël Salaün <mic@linux.microsoft.com>

When looking for a blacklisted hash, bin2hex() is used to transform a
binary hash to an ascii (lowercase) hexadecimal string.  This string is
then search for in the description of the keys from the blacklist
keyring.  When adding a key to the blacklist keyring,
blacklist_vet_description() checks the hash prefix and the hexadecimal
string, but not that this string is lowercase.  It is then valid to set
hashes with uppercase hexadecimal, which will be silently ignored by the
kernel.

Add an additional check to blacklist_vet_description() to check that
hexadecimal strings are in lowercase.

Cc: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
---
 certs/blacklist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/certs/blacklist.c b/certs/blacklist.c
index 6514f9ebc943..4e1a58170d5c 100644
--- a/certs/blacklist.c
+++ b/certs/blacklist.c
@@ -37,7 +37,7 @@ static int blacklist_vet_description(const char *desc)
 found_colon:
 	desc++;
 	for (; *desc; desc++) {
-		if (!isxdigit(*desc))
+		if (!isxdigit(*desc) || isupper(*desc))
 			return -EINVAL;
 		n++;
 	}
-- 
2.29.2

