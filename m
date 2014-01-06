From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 5/6] crypto: ccp - Cleanup hash invocation calls
Date: Mon, 6 Jan 2014 13:34:23 -0600
Message-ID: <20140106193423.26918.55048.stgit@tlendack-t1.amdoffice.net>
References: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Cleanup the ahash digest invocations to check the init
return code and make use of the finup routine.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    2 +-
 drivers/crypto/ccp/ccp-crypto-sha.c      |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index a52b97a..8e162ad 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -198,7 +198,7 @@ static int ccp_aes_cmac_digest(struct ahash_request *req)
 	if (ret)
 		return ret;
 
-	return ccp_do_cmac_update(req, req->nbytes, 1);
+	return ccp_aes_cmac_finup(req);
 }
 
 static int ccp_aes_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index d30f6c8..3867290 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -248,9 +248,13 @@ static int ccp_sha_finup(struct ahash_request *req)
 
 static int ccp_sha_digest(struct ahash_request *req)
 {
-	ccp_sha_init(req);
+	int ret;
 
-	return ccp_do_sha_update(req, req->nbytes, 1);
+	ret = ccp_sha_init(req);
+	if (ret)
+		return ret;
+
+	return ccp_sha_finup(req);
 }
 
 static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
