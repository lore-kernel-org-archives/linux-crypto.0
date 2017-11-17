From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: [PATCH 1/8] mm: kmemleak: remove unused hardirq.h
Date: Sat, 18 Nov 2017 07:02:14 +0800
Message-ID: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
Cc: <linux-mm@kvack.org>,
   <linux-fsdevel@vger.kernel.org>,
   <linux-crypto@vger.kernel.org>,
   <netdev@vger.kernel.org>,
  "Yang Shi" <yang.s@alibaba-inc.com>,
  "Michal Hocko" <mhocko@suse.com>,
  "Andrew Morton" <akpm@linux-foundation.org>,
  "Matthew Wilcox" <mawilcox@microsoft.com>
To: linux-kernel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

Preempt counter APIs have been split out, currently, hardirq.h just
includes irq_enter/exit APIs which are not used by kmemleak at all.

So, remove the unused hardirq.h.

Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/kmemleak.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7780cd8..25b977f 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -91,7 +91,6 @@
 #include <linux/stacktrace.h>
 #include <linux/cache.h>
 #include <linux/percpu.h>
-#include <linux/hardirq.h>
 #include <linux/bootmem.h>
 #include <linux/pfn.h>
 #include <linux/mmzone.h>
-- 
1.8.3.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
