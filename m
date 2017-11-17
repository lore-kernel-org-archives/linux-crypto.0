From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: [PATCH 7/8] net: ovs: remove unused hardirq.h
Date: Sat, 18 Nov 2017 07:02:20 +0800
Message-ID: <1510959741-31109-7-git-send-email-yang.s@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
Cc: <linux-mm@kvack.org>,
   <linux-fsdevel@vger.kernel.org>,
   <linux-crypto@vger.kernel.org>,
   <netdev@vger.kernel.org>,
  "Yang Shi" <yang.s@alibaba-inc.com>,
  "Pravin Shelar" <pshelar@nicira.com>,
  "David S. Miller" <davem@davemloft.net>,
   <dev@openvswitch.org>
To: linux-kernel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

Preempt counter APIs have been split out, currently, hardirq.h just
includes irq_enter/exit APIs which are not used by openvswitch at all.

So, remove the unused hardirq.h.

Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: dev@openvswitch.org
---
 net/openvswitch/vport-internal_dev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 04a3128..2f47c65 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -16,7 +16,6 @@
  * 02110-1301, USA
  */
 
-#include <linux/hardirq.h>
 #include <linux/if_vlan.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
-- 
1.8.3.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
