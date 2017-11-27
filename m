From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] X.509: fix buffer overflow detection in sprint_oid()
Date: Sun, 26 Nov 2017 23:17:51 -0800
Message-ID: <20171127071751.25935-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Takashi Iwai <tiwai@suse.de>
To: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:36132 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdK0HSJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 02:18:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

In sprint_oid(), if the input buffer were to be more than 1 byte too
small for the first snprintf(), 'bufsize' would underflow, causing a
buffer overflow when printing the remainder of the OID.

Fortunately this cannot actually happen currently, because no users pass
in a buffer that can be too small for the first snprintf().

Regardless, fix it by checking the snprintf() return value correctly.

For consistency also tweak the second snprintf() check to look the same.

Fixes: 4f73175d0375 ("X.509: Add utility functions to render OIDs as strings")
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/oid_registry.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/oid_registry.c b/lib/oid_registry.c
index 41b9e50711a7..5a75d127995d 100644
--- a/lib/oid_registry.c
+++ b/lib/oid_registry.c
@@ -120,10 +120,10 @@ int sprint_oid(const void *data, size_t datasize, char *buffer, size_t bufsize)
 
 	n = *v++;
 	ret = count = snprintf(buffer, bufsize, "%u.%u", n / 40, n % 40);
+	if (count >= bufsize)
+		return -ENOBUFS;
 	buffer += count;
 	bufsize -= count;
-	if (bufsize == 0)
-		return -ENOBUFS;
 
 	while (v < end) {
 		num = 0;
@@ -141,9 +141,9 @@ int sprint_oid(const void *data, size_t datasize, char *buffer, size_t bufsize)
 			} while (n & 0x80);
 		}
 		ret += count = snprintf(buffer, bufsize, ".%lu", num);
-		buffer += count;
-		if (bufsize <= count)
+		if (count >= bufsize)
 			return -ENOBUFS;
+		buffer += count;
 		bufsize -= count;
 	}
 
-- 
2.15.0
