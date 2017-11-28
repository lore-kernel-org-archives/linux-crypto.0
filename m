From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] X.509: fix printing uninitialized stack memory when OID
 is empty
Date: Tue, 28 Nov 2017 10:56:27 -0800
Message-ID: <20171128185627.GB45321@gmail.com>
References: <20171127071817.25999-1-ebiggers3@gmail.com>
 <10620.1511867034@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Takashi Iwai <tiwai@suse.de>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:37169 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753410AbdK1S4c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 13:56:32 -0500
Content-Disposition: inline
In-Reply-To: <10620.1511867034@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

On Tue, Nov 28, 2017 at 11:03:54AM +0000, David Howells wrote:
> I wonder if all -EBADMSG returns here should just print "(badoid)" into the
> buffer.
> 

I don't really care either way; it's just a question of whether it's better to
truncate the bad part, or print a special value.  If you prefer the latter here
is a revised patch to consider.  (I went with "(bad)" instead of "(badoid)"
because the callers already label the string as an OID.):

---8<---

>From 5a68ec1afd819e145446a97268bd790f9f3226b3 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 28 Nov 2017 10:47:42 -0800
Subject: [PATCH v2] X.509: fix printing uninitialized stack memory when OID is
 empty

Callers of sprint_oid() do not check its return value before printing
the result.  In the case where the OID is zero-length, -EBADMSG was
being returned without anything being written to the buffer, resulting
in uninitialized stack memory being printed.  Fix this by writing
"(bad)" to the buffer in the cases where -EBADMSG is returned.

Fixes: 4f73175d0375 ("X.509: Add utility functions to render OIDs as strings")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/oid_registry.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/oid_registry.c b/lib/oid_registry.c
index 41b9e50711a7..b5f7d9986be1 100644
--- a/lib/oid_registry.c
+++ b/lib/oid_registry.c
@@ -116,7 +116,7 @@ int sprint_oid(const void *data, size_t datasize, char *buffer, size_t bufsize)
 	int count;
 
 	if (v >= end)
-		return -EBADMSG;
+		goto bad;
 
 	n = *v++;
 	ret = count = snprintf(buffer, bufsize, "%u.%u", n / 40, n % 40);
@@ -134,7 +134,7 @@ int sprint_oid(const void *data, size_t datasize, char *buffer, size_t bufsize)
 			num = n & 0x7f;
 			do {
 				if (v >= end)
-					return -EBADMSG;
+					goto bad;
 				n = *v++;
 				num <<= 7;
 				num |= n & 0x7f;
@@ -148,6 +148,10 @@ int sprint_oid(const void *data, size_t datasize, char *buffer, size_t bufsize)
 	}
 
 	return ret;
+
+bad:
+	snprintf(buffer, bufsize, "(bad)");
+	return -EBADMSG;
 }
 EXPORT_SYMBOL_GPL(sprint_oid);
 
-- 
2.15.0.417.g466bffb3ac-goog
