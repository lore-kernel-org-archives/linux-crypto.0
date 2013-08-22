From: Chen Gang <gang.chen@asianux.com>
Subject: [PATCH v2] kernel/padata.c: share code between CPU_ONLINE and CPU_DOWN_FAILED,
 same to CPU_DOWN_PREPARE and CPU_UP_CANCELED
Date: Thu, 22 Aug 2013 14:43:37 +0800
Message-ID: <5215B319.3020908@asianux.com>
References: <5212E5E4.8010408@asianux.com> <5212E61F.7010602@asianux.com> <20130822051122.GB26773@secunet.com> <5215A134.90607@asianux.com> <20130822060503.GC26773@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130822060503.GC26773@secunet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Share code between CPU_ONLINE and CPU_DOWN_FAILED, same to
CPU_DOWN_PREPARE and CPU_UP_CANCELED.

It will fix 2 bugs:

  "not check the return value of __padata_remove_cpu() and __padata_add_cpu()".
  "need add 'break' between CPU_UP_CANCELED and CPU_DOWN_FAILED".


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/padata.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 072f4ee..2f0037a 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -846,6 +846,8 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		if (!pinst_has_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
@@ -857,6 +859,8 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		if (!pinst_has_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
@@ -865,22 +869,6 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 		if (err)
 			return notifier_from_errno(err);
 		break;
-
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		if (!pinst_has_cpu(pinst, cpu))
-			break;
-		mutex_lock(&pinst->lock);
-		__padata_remove_cpu(pinst, cpu);
-		mutex_unlock(&pinst->lock);
-
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-		if (!pinst_has_cpu(pinst, cpu))
-			break;
-		mutex_lock(&pinst->lock);
-		__padata_add_cpu(pinst, cpu);
-		mutex_unlock(&pinst->lock);
 	}
 
 	return NOTIFY_OK;
-- 
1.7.7.6
