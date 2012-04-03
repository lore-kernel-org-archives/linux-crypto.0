From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: [PATCH 2/2] crypto: disable preemption while benchmarking RAID5 xor checksumming
Date: Tue,  3 Apr 2012 16:56:19 -0700
Message-ID: <1333497379-2640-3-git-send-email-james.t.kukunas@linux.intel.com>
References: <4F7ACF94.5080505@anonymous.org.uk>
 <1333497379-2640-1-git-send-email-james.t.kukunas@linux.intel.com>
Cc: linux-crypto@vger.kernel.org
To: linux-raid@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31481 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418Ab2DCX4G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Apr 2012 19:56:06 -0400
In-Reply-To: <1333497379-2640-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With CONFIG_PREEMPT=y, we need to disable preemption while benchmarking
RAID5 xor checksumming to ensure we're actually measuring what we think
we're measuring.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 crypto/xor.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/crypto/xor.c b/crypto/xor.c
index 8788443..84daa11 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -21,6 +21,7 @@
 #include <linux/gfp.h>
 #include <linux/raid/xor.h>
 #include <linux/jiffies.h>
+#include <linux/preempt.h>
 #include <asm/xor.h>
 
 /* The xor routines to use.  */
@@ -69,6 +70,8 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 	tmpl->next = template_list;
 	template_list = tmpl;
 
+	preempt_disable();
+
 	/*
 	 * Count the number of XORs done during a whole jiffy, and use
 	 * this to calculate the speed of checksumming.  We use a 2-page
@@ -91,6 +94,8 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 			max = count;
 	}
 
+	preempt_enable();
+
 	speed = max * (HZ * BENCH_SIZE / 1024);
 	tmpl->speed = speed;
 
-- 
1.7.8.5
