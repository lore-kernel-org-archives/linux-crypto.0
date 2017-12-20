From: Cheah Kok Cheong <thrust73@gmail.com>
Subject: [PATCH 2/2] padata: Remove redundant export.h header
Date: Thu, 21 Dec 2017 04:15:21 +0800
Message-ID: <1513800921-12452-2-git-send-email-thrust73@gmail.com>
References: <1513800921-12452-1-git-send-email-thrust73@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thrust73@gmail.com
To: steffen.klassert@secunet.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513800921-12452-1-git-send-email-thrust73@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

It is already included in module.h, see
commit f50169324df4 ("module.h: split out the EXPORT_SYMBOL into export.h")
for their relationship.

Signed-off-by: Cheah Kok Cheong <thrust73@gmail.com>
---
 kernel/padata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 9d91909..e265953 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -16,7 +16,6 @@
  * more details.
  */
 
-#include <linux/export.h>
 #include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/cpu.h>
-- 
2.7.4
