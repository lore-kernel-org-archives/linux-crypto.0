From: Jan Stancek <jstancek@redhat.com>
Subject: [PATCH] crypto: testmgr - add guard to dst buffer for ahash_export
Date: Wed, 28 Sep 2016 16:38:37 +0200
Message-ID: <26da11d26bf0d34f9a5896ab9f9540db5be17012.1475072761.git.jstancek@redhat.com>
Cc: linux-kernel@vger.kernel.org, marcelo.cerri@canonical.com,
        jstancek@redhat.com
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932486AbcI1Oim (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 10:38:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a guard to 'state' buffer and warn if its consistency after
call to crypto_ahash_export() changes, so that any write that
goes beyond advertised statesize (and thus causing potential
memory corruption [1]) is more visible.

[1] https://marc.info/?l=linux-crypto-vger&m=147467656516085

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marcelo Cerri <marcelo.cerri@canonical.com>
---
 crypto/testmgr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5c9d5a5e7b65..96343bcae01e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -209,16 +209,19 @@ static int ahash_partial_update(struct ahash_request **preq,
 	char *state;
 	struct ahash_request *req;
 	int statesize, ret = -EINVAL;
+	const char guard[] = { 0x00, 0xba, 0xad, 0x00 };
 
 	req = *preq;
 	statesize = crypto_ahash_statesize(
 			crypto_ahash_reqtfm(req));
-	state = kmalloc(statesize, GFP_KERNEL);
+	state = kmalloc(statesize + sizeof(guard), GFP_KERNEL);
 	if (!state) {
 		pr_err("alt: hash: Failed to alloc state for %s\n", algo);
 		goto out_nostate;
 	}
+	memcpy(state + statesize, guard, sizeof(guard));
 	ret = crypto_ahash_export(req, state);
+	WARN_ON(memcmp(state + statesize, guard, sizeof(guard)));
 	if (ret) {
 		pr_err("alt: hash: Failed to export() for %s\n", algo);
 		goto out;
-- 
1.8.3.1
