From: David Howells <dhowells@redhat.com>
Subject: [PATCH] akcipher: Don't #include crypto/public_key.h as the
 contents aren't used
Date: Mon, 19 Oct 2015 12:19:45 +0100
Message-ID: <20151019111945.9535.66118.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbJSLTu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 07:19:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Don't #include crypto/public_key.h in akcipher as the contents of the
header aren't used and changes in a future patch cause it to fail to
compile if CONFIG_KEYS=n.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/akcipher.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 528ae6aa9bff..120ec042ec9e 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -21,7 +21,6 @@
 #include <linux/cryptouser.h>
 #include <net/netlink.h>
 #include <crypto/akcipher.h>
-#include <crypto/public_key.h>
 #include "internal.h"
 
 #ifdef CONFIG_NET
