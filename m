From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] checkpatch: add *_ON_STACK to $declaration_macros
Date: Tue, 27 Jun 2017 10:55:16 +0300
Message-ID: <1498550116-12475-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52814 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751723AbdF0HzY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 03:55:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the crypto API *_ON_STACK to $declaration_macros.

Resolves the following false warning:

WARNING: Missing a blank line after declarations
+			int err;
+			SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 scripts/checkpatch.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4b9569f..b42eb62 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -733,6 +733,7 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant|$String)};
 our $declaration_macros = qr{(?x:
 	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
 	(?:$Storage\s+)?LIST_HEAD\s*\(|
+	(?:$Storage\s+)?[A-Z_]*_ON_STACK\(|
 	(?:$Storage\s+)?${Type}\s+uninitialized_var\s*\(
 )};
 
-- 
2.1.4
