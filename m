From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [RFC] mm/page_ref, crypto/async_pq: don't put_page from __exit
Date: Sun, 28 Feb 2016 22:57:23 +0100
Message-ID: <1456696663-2340682-1-git-send-email-arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Michal Nazarewicz <mina86@mina86.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:50717 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbcB1V7Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Feb 2016 16:59:16 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The addition of tracepoints to the page reference tracking had an
unfortunate side-effect in at least one driver that calls put_page
from its exit function, resulting in a link error:

`.exit.text' referenced in section `__jump_table' of crypto/built-in.o: defined in discarded section `.exit.text' of crypto/built-in.o

I could not come up with a nice solution that ignores __jump_table
entries in discarded code, so we probably now have to treat this
as something a driver is not allowed to do. Removing the __exit
annotation avoids the problem in this particular driver, but the
same problem could come back any time in other code.

On a related problem regarding the runtime patching for SMP
operations on ARM uniprocessor systems, we resorted to not
drop the .exit section at link time, but that doesn't seem
appropriate here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 0f80830dd044 ("mm/page_ref: add tracepoint to track down page reference manipulation")
---
 crypto/async_tx/async_pq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index c0748bbd4c08..be167145aa55 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -442,7 +442,7 @@ static int __init async_pq_init(void)
 	return -ENOMEM;
 }
 
-static void __exit async_pq_exit(void)
+static void async_pq_exit(void)
 {
 	put_page(pq_scribble_page);
 }
-- 
2.7.0
