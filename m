From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH] lib: memzero_explicit: add comment for its usage
Date: Tue,  6 Jan 2015 00:27:45 +0100
Message-ID: <1420500465-6522-1-git-send-email-dborkman@redhat.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbbAEX1v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Jan 2015 18:27:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Lets improve the comment to add a note on when to use memzero_explicit()
for those not digging through the git logs. We don't want people to
pollute places with memzero_explicit() where it's not really necessary.

Reference: https://lkml.org/lkml/2015/1/4/190
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 [ Sending to -crypto as it's most relevant here and suggested by
   Herbert anyway. ]

 lib/string.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/string.c b/lib/string.c
index 1006330..d984ec4 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -604,6 +604,11 @@ EXPORT_SYMBOL(memset);
  * @s: Pointer to the start of the area.
  * @count: The size of the area.
  *
+ * Note: usually using memset() is just fine (!), but in cases
+ * where clearing out _local_ data at the end of a scope is
+ * necessary, memzero_explicit() should be used instead in
+ * order to prevent the compiler from optimising away zeroing.
+ *
  * memzero_explicit() doesn't need an arch-specific version as
  * it just invokes the one of memset() implicitly.
  */
-- 
1.7.11.7
