From: Gonglei <arei.gonglei@huawei.com>
Subject: [PATCH v6 1/2] sparc: fix a building error reported by kbuild
Date: Thu, 8 Dec 2016 12:37:08 +0800
Message-ID: <1481171829-116496-2-git-send-email-arei.gonglei@huawei.com>
References: <1481171829-116496-1-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <luonengjun@huawei.com>, <mst@redhat.com>, <stefanha@redhat.com>,
        <weidong.huang@huawei.com>, <wu.wubin@huawei.com>,
        <xin.zeng@intel.com>, <claudio.fontana@huawei.com>,
        <herbert@gondor.apana.org.au>, <pasic@linux.vnet.ibm.com>,
        <davem@davemloft.net>, <jianjay.zhou@huawei.com>,
        <hanweidong@huawei.com>, <arei.gonglei@hotmail.com>,
        <cornelia.huck@de.ibm.com>, <xuquan8@huawei.com>,
        <longpeng2@huawei.com>, <wanzongshun@huawei.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Sam Ravnborg <sam@ravnborg.org>, <sparclinux@vger.kernel.org>
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <virtio-dev@lists.oasis-open.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-crypto@vger.kernel.org>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1481171829-116496-1-git-send-email-arei.gonglei@huawei.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>> arch/sparc/include/asm/topology_64.h:44:44:
error: implicit declaration of function 'cpu_data'
[-Werror=implicit-function-declaration]

 #define topology_physical_package_id(cpu) (cpu_data(cpu).proc_id)
                                               ^
Let's include cpudata.h in topology_64.h.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Suggested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
---
 arch/sparc/include/asm/topology_64.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 7b4898a..2255430 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -4,6 +4,7 @@
 #ifdef CONFIG_NUMA
 
 #include <asm/mmzone.h>
+#include <asm/cpudata.h>
 
 static inline int cpu_to_node(int cpu)
 {
-- 
1.8.3.1


