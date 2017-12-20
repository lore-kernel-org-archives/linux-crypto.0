From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH RESEND] checkpatch: add *_ON_STACK to declaration_macros
Date: Wed, 20 Dec 2017 08:31:19 +0000
Message-ID: <1513758679-14532-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
index 168687a..e7fa1a2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -759,6 +759,7 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant|$String)};
 our $declaration_macros = qr{(?x:
 	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
 	(?:$Storage\s+)?[HLP]?LIST_HEAD\s*\(|
+	(?:$Storage\s+)?[A-Z_]*_ON_STACK\(|
 	(?:$Storage\s+)?${Type}\s+uninitialized_var\s*\(
 )};
 
-- 
2.7.4
