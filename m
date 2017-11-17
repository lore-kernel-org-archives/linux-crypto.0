From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: [PATCH 2/8] fs: pstore: remove unused hardirq.h
Date: Sat, 18 Nov 2017 07:02:15 +0800
Message-ID: <1510959741-31109-2-git-send-email-yang.s@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
Cc: <linux-mm@kvack.org>,
   <linux-fsdevel@vger.kernel.org>,
   <linux-crypto@vger.kernel.org>,
   <netdev@vger.kernel.org>,
  "Yang Shi" <yang.s@alibaba-inc.com>,
  "Kees Cook" <keescook@chromium.org>,
  "Anton Vorontsov" <anton@enomsg.org>,
  "Colin Cross" <ccross@android.com>,
  "Tony Luck" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

Preempt counter APIs have been split out, currently, hardirq.h just
includes irq_enter/exit APIs which are not used by pstore at all.

So, remove the unused hardirq.h.

Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Tony Luck <tony.luck@intel.com>
---
 fs/pstore/platform.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 2b21d18..25dcef4 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -41,7 +41,6 @@
 #include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
-#include <linux/hardirq.h>
 #include <linux/jiffies.h>
 #include <linux/workqueue.h>
 
-- 
1.8.3.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
