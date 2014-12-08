From: Amos Kong <akong@redhat.com>
Subject: [PATCH v5 REPOST 6/6] hw_random: don't init list element we're about to add to list.
Date: Mon,  8 Dec 2014 16:50:40 +0800
Message-ID: <1418028640-4891-7-git-send-email-akong@redhat.com>
References: <1418028640-4891-1-git-send-email-akong@redhat.com>
Cc: virtualization@lists.linux-foundation.org,
	herbert@gondor.apana.org.au, rusty@rustcorp.com.au,
	kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com,
	amit.shah@redhat.com, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1418028640-4891-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Another interesting anti-pattern.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index a9286bf..4d13ac5 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -489,7 +489,6 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 		}
 	}
-	INIT_LIST_HEAD(&rng->list);
 	list_add_tail(&rng->list, &rng_list);
 
 	if (old_rng && !rng->init) {
-- 
1.9.3
