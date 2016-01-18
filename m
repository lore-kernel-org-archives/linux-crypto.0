From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] crypto: Fix crc32c soft dependency
Date: Mon, 18 Jan 2016 17:06:05 +0100
Message-ID: <20160118170605.4e4a022f@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michal Marek <mmarek@suse.cz>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbcARQGJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 11:06:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I don't think it makes sense for a module to have a soft dependency
on itself. This seems quite cyclic by nature and I can't see what
purpose it could serve.

OTOH libcrc32c calls crypto_alloc_shash("crc32c", 0, 0) so it pretty
much assumes that some incarnation of the "crc32c" hash algorithm has
been loaded. Therefore it makes sense to have the soft dependency
there (as crc-t10dif does.)

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 crypto/crc32c_generic.c |    1 -
 lib/libcrc32c.c         |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- linux-4.5-rc0.orig/crypto/crc32c_generic.c	2016-01-11 00:01:32.000000000 +0100
+++ linux-4.5-rc0/crypto/crc32c_generic.c	2016-01-18 16:47:35.243398451 +0100
@@ -172,4 +172,3 @@ MODULE_DESCRIPTION("CRC32c (Castagnoli)
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CRYPTO("crc32c");
 MODULE_ALIAS_CRYPTO("crc32c-generic");
-MODULE_SOFTDEP("pre: crc32c");
--- linux-4.5-rc0.orig/lib/libcrc32c.c	2016-01-11 00:01:32.000000000 +0100
+++ linux-4.5-rc0/lib/libcrc32c.c	2016-01-18 16:47:47.978681236 +0100
@@ -74,3 +74,4 @@ module_exit(libcrc32c_mod_fini);
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: crc32c");


-- 
Jean Delvare
SUSE L3 Support
