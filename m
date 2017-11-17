From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: [PATCH 3/8] fs: btrfs: remove unused hardirq.h
Date: Sat, 18 Nov 2017 07:02:16 +0800
Message-ID: <1510959741-31109-3-git-send-email-yang.s@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
Cc: <linux-mm@kvack.org>,
   <linux-fsdevel@vger.kernel.org>,
   <linux-crypto@vger.kernel.org>,
   <netdev@vger.kernel.org>,
  "Yang Shi" <yang.s@alibaba-inc.com>,
  "Chris Mason" <clm@fb.com>,
  "Josef Bacik" <jbacik@fb.com>,
  "David Sterba" <dsterba@suse.com>,
   <linux-btrfs@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

Preempt counter APIs have been split out, currently, hardirq.h just
includes irq_enter/exit APIs which are not used by btrfs at all.

So, remove the unused hardirq.h.

Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/extent_map.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 2e348fb..cced7f1 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -2,7 +2,6 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/hardirq.h>
 #include "ctree.h"
 #include "extent_map.h"
 #include "compression.h"
-- 
1.8.3.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
