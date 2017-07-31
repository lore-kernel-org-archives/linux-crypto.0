From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: ccp - avoid uninitialized variable warning
Date: Mon, 31 Jul 2017 22:49:21 +0200
Message-ID: <20170731204936.1511542-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:52625 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdGaUt6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 16:49:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The added support for version 5 CCPs introduced a false-positive
warning in the RSA implementation:

drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_rsa_cmd':
drivers/crypto/ccp/ccp-ops.c:1856:3: error: 'sb_count' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This changes the code in a way that should make it easier for
the compiler to track the state of the sb_count variable, and
avoid the warning.

Fixes: 6ba46c7d4d7e ("crypto: ccp - Fix base RSA function for version 5 CCPs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/ccp/ccp-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 40c062ad8726..a8bc207b099a 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1758,6 +1758,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	o_len = 32 * ((rsa->key_size + 255) / 256);
 	i_len = o_len * 2;
 
+	sb_count = 0;
 	if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0)) {
 		/* sb_count is the number of storage block slots required
 		 * for the modulus.
@@ -1852,7 +1853,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	ccp_dm_free(&exp);
 
 e_sb:
-	if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0))
+	if (sb_count)
 		cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
 
 	return ret;
-- 
2.9.0
