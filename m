From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: [PATCH 1/2] crypto: wait for a full jiffy in do_xor_speed
Date: Tue,  3 Apr 2012 16:56:18 -0700
Message-ID: <1333497379-2640-2-git-send-email-james.t.kukunas@linux.intel.com>
References: <4F7ACF94.5080505@anonymous.org.uk>
 <1333497379-2640-1-git-send-email-james.t.kukunas@linux.intel.com>
Cc: linux-crypto@vger.kernel.org
To: linux-raid@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19318 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab2DCX4G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Apr 2012 19:56:06 -0400
In-Reply-To: <1333497379-2640-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In the existing do_xor_speed(), there is no guarantee that we actually
run do_2() for a full jiffy. We get the current jiffy, then run do_2()
until the next jiffy.

Instead, let's get the current jiffy, then wait until the next jiffy
to start our test.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 crypto/xor.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/crypto/xor.c b/crypto/xor.c
index b75182d..8788443 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -63,7 +63,7 @@ static void
 do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 {
 	int speed;
-	unsigned long now;
+	unsigned long now, j;
 	int i, count, max;
 
 	tmpl->next = template_list;
@@ -76,9 +76,11 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 	 */
 	max = 0;
 	for (i = 0; i < 5; i++) {
-		now = jiffies;
+		j = jiffies;
 		count = 0;
-		while (jiffies == now) {
+		while ((now = jiffies) == j)
+			cpu_relax();
+		while (time_before(jiffies, now + 1)) {
 			mb(); /* prevent loop optimzation */
 			tmpl->do_2(BENCH_SIZE, b1, b2);
 			mb();
-- 
1.7.8.5
