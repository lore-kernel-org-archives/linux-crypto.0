From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 02/18] crypto: marvell: keep creq->state in CPU endian format
 at all times
Date: Sun, 18 Oct 2015 17:23:35 +0100
Message-ID: <E1ZnqkB-0005WB-Q1@rmk-PC.arm.linux.org.uk>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45195 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbbJRQXq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:23:46 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, we read/write the state in CPU endian, but on the final
request, we convert its endian according to the requested algorithm.
(md5 is little endian, SHA are big endian.)

Always keep creq->state in CPU native endian format, and perform the
necessary conversion when copying the hash to the result.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/cesa.h |  2 +-
 drivers/crypto/marvell/hash.c | 25 ++++++++++++++-----------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index bc2a55bc35e4..e19302c9dec9 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -612,7 +612,7 @@ struct mv_cesa_ahash_req {
 	u64 len;
 	int src_nents;
 	bool last_req;
-	__be32 state[8];
+	u32 state[8];
 };
 
 /* CESA functions */
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index d9cc49e9c43b..f59faabcd34f 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -347,18 +347,21 @@ static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
 				   ahashreq->nbytes - creq->cache_ptr);
 
 	if (creq->last_req) {
-		for (i = 0; i < digsize / 4; i++) {
-			/*
-			 * Hardware provides MD5 digest in a different
-			 * endianness than SHA-1 and SHA-256 ones.
-			 */
-			if (digsize == MD5_DIGEST_SIZE)
-				creq->state[i] = cpu_to_le32(creq->state[i]);
-			else
-				creq->state[i] = cpu_to_be32(creq->state[i]);
-		}
+		/*
+		 * Hardware's MD5 digest is in little endian format, but
+		 * SHA in big endian format
+		 */
+		if (digsize == MD5_DIGEST_SIZE) {
+			__le32 *result = (void *)ahashreq->result;
+
+			for (i = 0; i < digsize / 4; i++)
+				result[i] = cpu_to_le32(creq->state[i]);
+		} else {
+			__be32 *result = (void *)ahashreq->result;
 
-		memcpy(ahashreq->result, creq->state, digsize);
+			for (i = 0; i < digsize / 4; i++)
+				result[i] = cpu_to_be32(creq->state[i]);
+		}
 	}
 
 	return ret;
-- 
2.1.0
